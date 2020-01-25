// matter.js module aliases
var Engine = Matter.Engine,
    World = Matter.World,
    Bodies = Matter.Bodies;

// World Variables
var engine;
var world;

// Shape Variables
var s_avatar;
var particles = [];
var particlesMade = 0;
var maxParticles = 50;

function setup() {
  createCanvas(640, 640);
  noStroke();

  //Physics Creation
  engine = Engine.create();
  world = engine.world;
  world.gravity.scale = 0;
  Engine.run(engine);

  s_avatar = new Avatar(mouseX, mouseY, 30);
}

function draw() {
  background(32);
  renderForces();
  s_avatar.move();
  for (var i = 0; i < particles.length; i++){
    particles[i].move();
  }
}

function renderForces(){ //Needs Fixing
  // for (var i = 0; i < particles.length; i++){
  //   var fX = 0.0, fY = 0.0;
  //   for (var j = particles.length-1; j >= 0 ; j--){
  //     if (i != j){
  //       var dx = particles[j].pos.x - balls[i].pos.x;
  //       var dy = particles[j].pos.y - particles[i].pos.y;
  //
  //       var d = sqrt(dx*dx+dy*dy);
  //       if (d < 1){
  //         d = 1;
  //       }
  //
  //       var f = (d-4)/(d-0.9);
  //       fX = (fX + 100*f*dx);
  //       fY = (fY + 100*f*dy);
  //     }
  //   }
  //   particles[i].force(fX,fY);
  //   }
}

function mousePressed(){
  addParticles();
}

function mouseDragged(){
  addParticles();
}

function addParticles(){
  if (particlesMade < maxParticles){
    particles.push(new Particle(mouseX, mouseY, random(15,30)));
    particlesMade++;
  }
  else {
    particles.shift();
    particles.push(new Particle(mouseX, mouseY, random(15,30)));
  }
}
