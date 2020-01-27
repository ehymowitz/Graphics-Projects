// matter.js module aliases
var Engine = Matter.Engine,
    World = Matter.World,
    Bodies = Matter.Bodies,
    Constraint = Matter.Constraint;

// World Variables
var engine, world;
var canvasX = 640, canvasY = 400;

// Shape Variables
var particles = [];
var particlesMade = 0;
var maxParticles = 100;
var lastTime = 0, threshold = 0;

// Avatar
var avatar, gPart;
var constr, options;

function setup() {
  var canvas = createCanvas(canvasX, canvasY);
  canvas.parent('Surface-Tension');
  noStroke();
  // noCursor();

  // Physics Creation
  engine = Engine.create();
  world = engine.world;
  world.gravity.scale = 0;

  // Avatar
  avatar = new Avatar(canvasX/2, canvasY/2, 30);
  gPart = new GodParticle(canvasX/2, canvasY/2, 20);
  options = {
    bodyA: gPart.body,
    bodyB: avatar.body,
    length: 70,
    stiffness: 0.1
  }
  constr = Constraint.create(options);
  World.add(world, constr);
}

function draw() {
  background(32);
  Matter.Engine.update(engine);
  avatar.move();
  gPart.move();
  if (mouseX <= canvasX && mouseY >= 10){
    if (mouseY <= canvasY && mouseY >= 10){
      if (particlesMade <= 10 && millis() > 5000){
        addParticles();
      }
    }
  }
  for (var i = 0; i < particles.length; i++){
    particles[i].move();
  }
}

function mousePressed(){
  addParticles();
}

function mouseDragged(){
  addParticles();
}

function addParticles(){
  if(millis()-lastTime > threshold){
    lastTime = millis();
    if (particlesMade < maxParticles){
      particles.push(new Particle(mouseX, mouseY, random(10,20)));
      particlesMade++;
    }
    else {
      threshold = 120;
      particles.shift();
      particles.push(new Particle(mouseX, mouseY, random(10,20)));
    }
  }
}
