var canvasX = 640, canvasY = 400;

// Particle Tracking
var particleX = [], particleY = [], velocityX = [], velocityY =[], particleR = [];
// Mouse Componenet
var vXm = [], vYm = [], aXm = [], aYm = [];
// Other Particles Component
var vXp = [], vYp = [];

// Numbers Tracking
var particlesMade = 0;
var maxParticles = 100;
var lastTime = 0, threshold = 0;

function setup() {
  createCanvas(canvasX, canvasY);
  noStroke();
  noCursor();
}

function draw() {
  background(32);

  fill(100,40,200,255);
  circle(mouseX, mouseY, 10)
  noStroke();

  push();
  fill(64, 255, 255, 130);
  // Mouse Componenet
  for (var i = 0; i < particlesMade; i++){

    if (particlesMade > 0){
      var dXm = particleX[i] - mouseX;
      var dYm = particleY[i] - mouseY;

      var distance = sqrt(dXm*dXm + dYm*dYm);
      if (distance < 1) distance = 1;

      var fm = distance * particleR * 0.005;

      aXm[i] += dXm*fm * 0.005;
      aYm[i] += dYm*fm * 0.005;

      vXm[i] += aXm[i] * 0.005;
      vYm[i] += aYm[i] * 0.005;

      console.log(vXm);

    }

  }

  for (var i = 0; i < particlesMade; i++){
      particleX[i] += vXm[i];
      particleY[i] += vYm[i];

      circle(particleX[i], particleY[i], particleR[i]);
    }
  pop();
}

function mousePressed(){
  addParticles();
}

function addParticles(){
  particleX.push(mouseX);
  particleY.push(mouseY);
  particleR.push(random(10,20));
  velocityY.push(0);
  velocityX.push(0);
  aXm.push(0);
  aXm.push(0);
  vXm.push(0);
  vYm.push(0);
  particlesMade++;
}
