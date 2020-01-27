function Avatar(x, y, r){
  this.body = Bodies.circle(x,y,r);
  this.r = r;
  World.add(world, this.body);

  this.move = function(){
    var pos = this.body.position;

    push();
    fill(0,10,70,150);
    translate(pos.x, pos.y);
    circle(0,0,this.r);
    pop();
  }
}

function GodParticle(x, y, r){
  this.body = Bodies.circle(x,y,r);
  this.r = r;
  World.add(world, this.body);

  this.move = function(){
    var pos = this.body.position;

    push();
    fill(0,0,0);
    translate(pos.x, pos.y);
    circle(0,0,this.r);
    pop();
  }
}
