var canvasX = 640, canvasY = 400;

// Particle Tracking
var particleR = [], particleX = [], particleY = [];
var particlesMade = 0;
var maxParticles = 100;
var lastTime = 0, threshold = 0;

function setup() {
  var canvas = createCanvas(canvasX, canvasY);
  canvas.parent('Particle-Play');
  noStroke();
  noCursor();
}

function draw() {
  background(32);

  fill(100,40,200,255);
  circle(mouseX, mouseY, 10)

  push();
  fill(64, 255, 255, 130);
  for (var i = 0; i <= particlesMade; i++){
    circle(particleX[i], particleY[i], particleR[i]);
  }
  pop();

}

function mousePressed(){
  addParticles();
}
function mouseDragged(){
  addParticles();
}
function addParticles(){
  particleR.push(random(10,20));
  particleX.push(mouseX);
  particleY.push(mouseY);
  particlesMade++;
}
