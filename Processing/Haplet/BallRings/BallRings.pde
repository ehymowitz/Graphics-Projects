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

// Variable Initialization
FWorld world; 

// ballrings
ballRing[] rings = new ballRing[10];

void setup(){
  // Screen Size (px)
  size(1000, 600);
  
  //device setup 
  haplyBot = new Two_DOF_Robot(this, Serial.list()[2]);
  
  // 2D physics scaling and world creation
  hAPI_Fisica.init(this); 
  hAPI_Fisica.setScale(40); 

  // Creating the world
  world = new FWorld();
  
  // Creating ballRing(int n, float as, float x, float y, float ad, float ao, FWorld w)
  for (int i = 0; i < rings.length; i++){
    rings[i] = new ballRing(20, 0.2, worldWidth/2, worldHeight/2, 3.0, float(i), world);
  }

  world.draw();
}

void draw(){
  background(200);
  
  haplyBot.read_robot_data();
  
  float haplet_posx = haplyBot.get_device_position()[0] - 1.9999;
  float haplet_posy = haplyBot.get_device_position()[1] - 7.2111;
  
  haplyBot.write_robot_data(0,0);
    
  // updateRing(float f, float sa, float da, float hx, float hy)
  for (int i = 0; i < rings.length; i++){
    rings[i].updateRing((float(i+1)/3000),0.1, 1, haplet_posx, haplet_posy);
  }
  //println(haplet_posx);
    
  world.draw();  
}
