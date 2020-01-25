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
  size(1000, 400);
  
  // 2D physics scaling and world creation
  hAPI_Fisica.init(this); 
  hAPI_Fisica.setScale(40); 

  // Creating the world
  world = new FWorld();
  
  // Creating ballRing(int n, float as, float x, float y, float ad, float ao, FWorld w)
  for (int i = 0; i < rings.length; i++){
    rings[i] = new ballRing(20, 0.2, worldWidth/2, worldHeight/2, 3, i, world);
  }

  world.draw();
}

void draw(){
  background(200);
  // updateRing(float f, float sa, float da)
  for (int i = 0; i < rings.length; i++){
    rings[i].updateRing((float(i+1)/3000),0.1, 1);
  }
  world.draw();  
}
