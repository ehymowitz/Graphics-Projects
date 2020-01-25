import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;

private final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

Two_DOF_Robot haplyBot;

// Balls to be created
FCircle ball;
int ballsIncrementor;
int ballsCreated;
boolean maxBalled = false;
int maxBalls = 100;
FCircle[] balls = new FCircle[maxBalls];

int dragThreshold = 0;
int dragRefresh = 100;

/* Initialization of avatar */
HVirtualCoupling  s;

// Variable Initialization
FWorld world; 

// Encapsulation
boolean hapticsOn;

void setup(){
  //Screen Size (px)
  size(1000, 500);
  
  //device setup 
  haplyBot = new Two_DOF_Robot(this, Serial.list()[2]);
  
  //2D physics scaling and world creation
  hAPI_Fisica.init(this); 
  hAPI_Fisica.setScale(50); 

  //Creating the world
  world = new FWorld();
  world.setGravity(0,0);
    
  //Haptic Tool Initialization
  s = new HVirtualCoupling((0.7)); 
  s.h_avatar.setDensity(1);
  s.h_avatar.setFill(0,10,70,150); 
  s.h_avatar.setDamping(40);
  s.init(world, width/(2*50), 2); 
  
  world.draw();
    
  //setup simulation thread to run at 1kHz
  SimulationThread st = new SimulationThread();
  scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
}

void draw(){
  background(32);
  
  renderForces(); 
    
  world.draw();  
}

void mouseClicked() {
    if (millis() - dragThreshold > dragRefresh){
    float size = random(0.3,0.6);
    createBall(size);
    dragThreshold = dragThreshold + dragRefresh;
    }
}

void mouseDragged() { 
  if (millis() - dragThreshold > dragRefresh){
    float size = random(0.3,0.6);
    createBall(size);
    dragThreshold = dragThreshold + dragRefresh;
  }
}

void createBall(float b){
  if (hapticsOn == false){
    ball = new FCircle(b);
    ball.setDensity(50);
    ball.setFill(64, 255, 255, 200);
    ball.setSensor(false);
    ball.setPosition(mouseX/50,mouseY/50);
    ball.setDamping(3);
    ball.setRestitution(0.2);
    ball.setGrabbable(false);
    world.add(ball);
    if (ballsCreated < maxBalls && maxBalled == false){
      ballsCreated++;
    }
    if (ballsIncrementor < maxBalls){
      ballsIncrementor++;
    }
    else {
      ballsIncrementor = 1;
      maxBalled = true;
    }
    if (balls[ballsIncrementor-1] != null){
      world.remove(balls[ballsIncrementor-1]);
    }
    balls[ballsIncrementor-1] = ball;
  }
}

void renderForces(){
 for (int i = 0; i < ballsCreated; i++){
   float fX = 0, fY = 0;
   for (int j = ballsCreated-1; j >= 0 ; j--){
     if (i != j){
       float dx = balls[j].getX() - balls[i].getX();
       float dy = balls[j].getY() - balls[i].getY();
       
       float d = sqrt(dx*dx+dy*dy);
       if (d < 1){
         d = 1;
       }
       
       float f = (d-4)/(d-0.9);
       fX = (fX + 100*f*dx);
       fY = (fY + 100*f*dy);
     }
   }
   balls[i].setForce((balls[i].getForceX() + fX),(balls[i].getForceY()+fY));
   }
}  

class SimulationThread implements Runnable{
  public void run(){
    
    float xPosition = 0.0;
    float yPosition = 0.0;
    
    haplyBot.read_robot_data();
    
    xPosition = 25/2 - haplyBot.get_device_position()[0] + 2;
    yPosition = haplyBot.get_device_position()[1]-7;
    
    s.setToolPosition(xPosition, yPosition); 
    s.updateCouplingForce();
    
    hapticsOn = true;
    haplyBot.write_robot_data(s.getVCforceX(), s.getVCforceY());
    hapticsOn = false;
    
    world.step(1.0f/1000.0f);
    
  }
}
