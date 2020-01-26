var ad = 70, amp = 30, ar = 8, ramp = 5, freq = 0.002, balls = 15;

function setup() {
  createCanvas(640, 640);
  noStroke();
}

function draw() {
  background(200);
  distance = ad + amp*sin(freq*millis());
  radius = ar - ramp*sin(freq*millis());
  color = 255-255/2*sin(freq*millis());
  for (var i=0; i<balls; i++){
    fill(color, 0, 50);
    circle(mouseX+distance*sin(map(i,0,balls,0,2*PI)), mouseY+distance*cos(map(i,0,balls,0,2*PI)), radius);
  }
}
