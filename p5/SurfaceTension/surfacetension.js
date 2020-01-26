// matter.js module aliases
var Engine = Matter.Engine,
    World = Matter.World,
    Bodies = Matter.Bodies,
    Mouse = Matter.Mouse,
    MouseConstraint = Matter.MouseConstraint;

// World Variables
var engine, world;
var canvasX = 640, canvasY = 400;

// Shape Variables
var particles = [];
var particlesMade = 0;
var maxParticles = 100;
var lastTime = 0, threshold = 0;

// Avatar
var avatar;
var cMouse, mConst, options;

function setup() {
  var canvas = createCanvas(canvasX, canvasY);
  noStroke();
  noCursor();

  // Physics Creation
  engine = Engine.create();
  world = engine.world;
  world.gravity.scale = 0;

  // Avatar
  avatar = new Avatar(canvasX/2, canvasY/2, 30);
  cMouse = Mouse.create(canvas.elt);
  cMouse.pixelRatio = pixelDensity();
  options = {
    mouse: cMouse,
    // body: avatar.Body
  }
  mConst = MouseConstraint.create(engine, options);
  World.add(world, mConst);
}

function draw() {
  background(32);
  Matter.Engine.update(engine);
  avatar.move();
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
