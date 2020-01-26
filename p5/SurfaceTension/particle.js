function Particle(x,y,r){
  this.body = Bodies.circle(x,y,r);
  this.r=r;
  World.add(world, this.body);

  this.move = function(){
    var pos = this.body.position;

    push();
    fill(64, 255, 255, 200);
    translate(pos.x, pos.y);
    circle(0,0,this.r);
    pop();
  }
}
