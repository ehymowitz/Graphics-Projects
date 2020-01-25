public class ballRing{
  private int numberOfBalls;
  private FCircle[] balls;
    
  private float averageSize;
  
  private float averageDistance;
  
  private float angleOffset;
     
  public float Xpos;
  public float Ypos;
      
  public ballRing(int n, float as, float x, float y, float ad, float ao, FWorld w){
    numberOfBalls = n;
    balls = new FCircle[numberOfBalls];
    averageSize = as;
    Xpos = x;
    Ypos = y+2;
    averageDistance = ad;  
    angleOffset = ao;
    for (int i = 0; i < balls.length; i++){
          balls[i] = new FCircle(as);
          balls[i].setFill(0,0,0);
          balls[i].setNoStroke();
          balls[i].setStatic(true);
          balls[i].setSensor(true);
          balls[i].setPosition(x+ad*cos(ao+map(i,0,balls.length,0,2*3.1415)), y+ad*sin(ao+map(i,0,balls.length,0,2*3.1415)));
          w.add(balls[i]);
        }
      }
     
  public void updateRing(float f, float sa, float da, float hx, float hy){
    if (hy < -5){
      hy = -5;
    }
    float Distance = averageDistance+da*sin(f*millis());
    float Size = averageSize-sa*sin(f*millis());
    float zoomP = (hy+6)/8;
    float angleP = (hx+1)/50;
    float sizeP = (abs(hy+8))/8;
    float greenP, blueP;
    if (hx < 0){
      greenP = 0;
      blueP = abs(hx*10);
    }
    else{
      greenP = hx*10;
      blueP = 0;
    }

    for (int i = 0; i < balls.length; i++){
        balls[i].setPosition(Xpos+Distance*zoomP*cos(angleOffset*angleP+map(i,0,balls.length,0,2*3.1415))-hx, Ypos+Distance*zoomP*sin(angleOffset*angleP+map(i,0,balls.length,0,2*3.1415)));
        balls[i].setSize(Size*sizeP);
        balls[i].setFill(255-(255/2)*sin(f*millis()), greenP, blueP);
      }
    }
}
