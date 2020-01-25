// World Variables
FWorld world;
float scale = 100.0;

// Balls to be created
FCircle ball;
int ballsCreated;
int maxBalls = 100;
FCircle[] balls = new FCircle[maxBalls];

void setup() {
  size(1000, 700);
  
  // Initiate Fisica
  hAPI_Fisica.init(this);
  hAPI_Fisica.setScale(scale);
  
  // Creating World
  world = new FWorld();
  world.setGravity(0,0);

  world.draw();
  
}

void draw() {
  background(32);
    
  renderForces();  
    
  world.step();
  world.draw();
  
}

void mouseClicked() {
  float size = random(0.1,0.3);
  createBall(size);
}

void mouseDragged() { 
  float size = random(0.1,0.3);
  createBall(size);
}

void createBall(float b){
  if(ballsCreated < maxBalls){
    ball = new FCircle(b);
    ball.setDensity(0.5);
    ball.setFill(64, 255, 255, 200);
    ball.setSensor(false);
    ball.setPosition(mouseX/scale,mouseY/scale);
    world.add(ball);
    ballsCreated++;
    balls[ballsCreated-1] = ball;
  }
  else{
    println("Too many balls!");
  }
}

void renderForces(){
  if(ballsCreated >= 2){
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
         
         float f = (d-2)/(d-0.9);
         fX = (fX + f*dx);
         fY = (fY + f*dy);
       }
     }
     balls[i].setForce((balls[i].getForceX() + fX),(balls[i].getForceY()+fY));
   }
 }
}
