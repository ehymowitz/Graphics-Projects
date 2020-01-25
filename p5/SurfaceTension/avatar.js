function Avatar(x, y, r){
  this.body = Bodies.circle(x,y,r);
  this.r = r;
  World.add(world, this.body);

  this.move = function(){
    push();
    fill(0,10,70,150);
    translate(mouseX, mouseY);
    circle(0,0,this.r);
    pop();
  }
}
