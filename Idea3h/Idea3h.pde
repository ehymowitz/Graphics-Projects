import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;

private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

Two_DOF_Robot haplyBot;

/* World boundaries in centimeters */
float worldWidth = 25.0;  
float worldHeight = 10.0; 

float edgeTopLeftX = 0.0; 
float edgeTopLeftY = 0.0; 
float edgeBottomRightX = worldWidth; 
float edgeBottomRightY = worldHeight;

// World Initialization
FWorld world; 

// Cursor
HVirtualCoupling s;

// Goals
FBox goalLeft;
FBox goalRight;
FBox goalBottom;
FBox goalTop;

// Comet
FBox comet;
int cometCount = 3;
float timer;
float creation = 5000;
float lastCreated;

// Text
PFont f;

void setup(){
  //Screen Size (px)
  size(1000, 400);
  
  //device setup 
  haplyBot = new Two_DOF_Robot(this, Serial.list()[1]);
  
  //2D physics scaling and world creation
  hAPI_Fisica.init(this); 
  hAPI_Fisica.setScale(40); 

  //Creating the world
  world = new FWorld();
  world.setGravity(0,0);
    
  //Haptic Tool Initialization
  s = new HVirtualCoupling((0.5)); 
  s.h_avatar.setDensity(2); 
  s.h_avatar.setFill(255,0,0,0); 
  s.h_avatar.setStroke(255);
  s.h_avatar.setStrokeWeight(2);
  s.init(world, edgeTopLeftX+worldWidth/2, edgeTopLeftY+2); 
  
  goalLeft = new FBox(2, worldHeight);
  goalLeft.setStatic(true);
  goalLeft.setSensor(true);
  goalLeft.setFill(116,29,29,0);
  goalLeft.setPosition(-2, worldHeight/2);
  goalLeft.setName("Left");
  world.add(goalLeft);
  
  goalRight = new FBox(2, worldHeight);
  goalRight.setStatic(true);
  goalRight.setSensor(true);
  goalRight.setFill(116,29,29,0);
  goalRight.setPosition(worldWidth+2, worldHeight/2);
  goalRight.setName("Right");
  world.add(goalRight);
  
  goalBottom = new FBox(worldWidth, 2);
  goalBottom.setStatic(true);
  goalBottom.setSensor(true);
  goalBottom.setFill(116,29,29,0);
  goalBottom.setPosition(worldWidth/2, worldHeight+2);
  goalBottom.setName("Bottom");
  world.add(goalBottom);
  
  goalTop = new FBox(worldWidth*2, 2);
  goalTop.setStatic(true);
  goalTop.setSensor(true);
  goalTop.setFill(116,29,29,0);
  goalTop.setPosition(worldWidth/2, -9);
  goalTop.setName("Top");
  world.add(goalTop);
   
  world.draw();
  
  frameRate(30);
  f = createFont("Calibri", 16, true);
    
  //setup simulation thread to run at 1kHz
  SimulationThread st = new SimulationThread();
  scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
  
}

void draw(){
  background(116,29,29);
  textFont(f);
  
  timer = millis();
  if (timer - lastCreated > creation){
    createComet();
    lastCreated = lastCreated + creation;
  }
  
  textAlign(CENTER);
  text(cometCount,width/2, height/2);
  
  world.draw();
}
  
void createComet(){
  comet = new FBox(random(1,5), random(1,5));
  comet.setFill(255,20,20);
  comet.setGrabbable(false);
  comet.setDensity(100);
  comet.setPosition(random(2, worldWidth-2),-2);
  comet.setVelocity(random(-2,2),random(7,16));
  comet.setName("Comet");
  world.add(comet);
}

void contactStarted(FContact contact){ // runs twice for some reason
 if (contact.contains("Left", "Comet") == true){
     world.remove(contact.getBody2());
 }
 if (contact.contains("Right", "Comet") == true){
     world.remove(contact.getBody2());
 } 
 if (contact.contains("Bottom", "Comet") == true){
   world.remove(contact.getBody2());
   println(contact);
   cometCount--;
 }
  if (contact.contains("Top", "Comet") == true){
   world.remove(contact.getBody2());
   //cometCount--;
 }
}

class SimulationThread implements Runnable{
  public void run(){
    
    float xPosition = 0.0;
    float yPosition = 0.0;
    
    haplyBot.read_robot_data();
    
    xPosition = edgeTopLeftX + worldWidth/2 - haplyBot.get_device_position()[0] + 2;
    yPosition = edgeTopLeftY + haplyBot.get_device_position()[1]-7;
    
    s.setToolPosition(xPosition, yPosition); 
    s.updateCouplingForce();
    
    haplyBot.write_robot_data(s.getVCforceX(), s.getVCforceY());
    
    world.step(1.0f/1000.0f);
  
  }
}
