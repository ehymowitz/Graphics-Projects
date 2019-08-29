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

/* Initialization of avatar */
HVirtualCoupling  s;

// Variable Initialization
FWorld world; 

void setup(){
  //Screen Size (px)
  size(1000, 400);
  
  //device setup 
  haplyBot = new Two_DOF_Robot(this, Serial.list()[1]);
  println(Serial.list());
  
  //2D physics scaling and world creation
  hAPI_Fisica.init(this); 
  hAPI_Fisica.setScale(40); 

  //Creating the world
  world = new FWorld();
  world.setGravity((0.0), (300.0)); //1000 cm/(s^2)
  world.setEdges(edgeTopLeftX, edgeTopLeftY, edgeBottomRightX, edgeBottomRightY);
  world.setEdgesRestitution(0.4);
  world.setEdgesFriction(0.5);
    
  //Haptic Tool Initialization
  s = new HVirtualCoupling((0.5)); 
  s.h_avatar.setDensity(2); 
  s.h_avatar.setFill(255,0,0); 
  s.init(world, edgeTopLeftX+worldWidth/2, edgeTopLeftY+2); 

  world.draw();
    
  //setup simulation thread to run at 1kHz
  SimulationThread st = new SimulationThread();
  scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
}

void draw(){
  background(255);
  world.draw();  
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
