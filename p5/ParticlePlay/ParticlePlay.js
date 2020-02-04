var canvasX = 640, canvasY = 400;

// Particle Tracking
var particleX = [], particleY = [], velocityX = [], velocityY =[], particleR = [];
// Mouse Componenet
var vXm = [], vYm = [];
// Other Particles Component
var vXp = [], vYp = [];

// Numbers Tracking
var particlesMade = 0;
var maxParticles = 700;
var lastTime = 0, threshold = 100;

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
  // Particle Component
  for (var i = 0; i < particlesMade; i++){
    var aXp = 0, aYp = 0;
    for (var j = 0; j < particlesMade; j++){
      if (i != j){
        var dX = particleX[i] - particleX[j];
        var dY = particleY[i] - particleY[j];

        d = sqrt(dX*dX + dY*dY);
        if (d < 1) d = 1;

        var f = (canvasY/1.8-d)/d;
        aXp += f*dX*0.1;
        aYp += f*dY*0.1;
      }
    }
    vXp[i] = vXp[i]*0.95 + aXp*0.05;
    vYp[i] = vYp[i]*0.95 + aYp*0.05;
  }

  // // Mouse Componenet
  // for (var i = 0; i < particlesMade; i++){
  //   var aXm = 0, aYm = 0;
  //   var dXm = particleX[i] - mouseX;
  //   var dYm = particleY[i] - mouseY;
  //
  //   d = sqrt(dXm*dXm + dYm*dYm);
  //   if (d < 1) d = 1;
  //
  //   var f = (canvasY/20-d)/d;
  //   aXm += f*dXm*0.01;
  //   aYm += f*dYm*0.01;
  //   vXm[i] = vXm[i]*0.95 + aXm*0.05;
  //   vYm[i] = vYm[i]*0.95 + aYm*0.05;
  // }


  // Particle Generation
  for (var i = 0; i < particlesMade; i++){
      particleX[i] += vXm[i]+vXp[i];
      particleY[i] += vYm[i]+vYp[i];

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
  var time = millis();
  if (particlesMade < maxParticles){
    if (time - lastTime > threshold){
      particleX.push(mouseX);
      particleY.push(mouseY);
      particleR.push(random(10,20));
      velocityY.push(0);
      velocityX.push(0);
      vXm.push(0);
      vYm.push(0);
      vXp.push(0);
      vYp.push(0);
      particlesMade++;
      lastTime = time;
    }
  }
}
