var canvasX = 500, canvasY = 500
var ad = 90, amp = 50, ar = 8, ramp = 5, balls = 40, x = canvasX/2, y = canvasY/2;

function setup() {
  createCanvas(canvasX, canvasY);
  noStroke();
  noCursor();
}

function draw(){
  background(200);
  for (var i = 0; i < 10; i++){
    ballring(ad, amp, ar, ramp, map(i, 0, 9, 0.001, .0025), balls, x, y);
  }

if (!mouseIsPressed) {
  push();
  fill(0,0,0)
  circle(mouseX, mouseY, 5);
  pop();
}

  if (mouseIsPressed) {
    push();
    fill("Black");
    textSize(12);
    textAlign(CENTER);
    text("← Ring Color →, ↑ Ring Size ↓,", mouseX, mouseY);
    pop();
 }

}

function ballring(ad, amp, ar, ramp, freq, balls, x, y){
  var mouseFactorX = 0, mouseFactorY = 0;
  if(mouseX <= canvasX-10 && mouseX >=10){
    if(mouseY <= canvasY-10 && mouseY >=10){
      mouseFactorX = map(mouseX, 0, canvasX, 0, 255);
      mouseFactorY = map(mouseY, 0, canvasY,0,100);
    }
  }
  var distance = mouseFactorY + ad + amp*sin(freq*millis());
  var radius = ar - ramp*sin(freq*millis());
  var color = 255-255/2*sin(freq*millis());
  for (var j=0; j<balls; j++){
    fill(color, mouseFactorX, mouseFactorX);
    circle(x+distance*cos(j+map(j,0,balls,0,2*PI)), y+distance*sin(j+map(j,0,balls,0,2*PI)), radius);
  }
}
