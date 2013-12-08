class Spear {
  PVector position, tip, pt_v, seg_v, closest, proj_v;
  float r, projVLength, distance, segVLength, diff;
  int deg=0;
  
  color c, scoreC, playerC;
  color red = color(180, 0,50);
  ControllDevice device;
  ControllStick stick;
  ControllButton button, leftTrigger, rightTrigger;
  boolean isColliding = false;
  String path;
  int scoreX, scoreY;
  int score;
  
  Spear(int xx, int yy, String d, color cc, int scX, int scY, color scC) {
    position = new PVector (xx, yy);
    r = 20.0;
    path = d;
    playerC = cc;
    c = playerC;
    score = 0;
    scoreX = scX;
    scoreY = scY;
    scoreC = scC;
    device = controll.getDevice(d);
    stick = device.getStick(0);
    stick.setTolerance(0.05f);
    button = device.getButton("0");
    rightTrigger = device.getButton("5");
    leftTrigger = device.getButton("4");
  }
  
  void render() {
    //spear
    strokeWeight(1);
    stroke(40);
    line(position.x,position.y,tip.x,tip.y);
    //player
    noStroke();
    fill(c);
    ellipse(position.x,position.y,r,r);
    fill(scoreC);
    ellipse(tip.x,tip.y, 3, 3);
  }
  
  void spin(int direction) {
    if (direction == 6) {
      deg -= 5;
    }
    else if (direction == 4 ) {
      deg += 5;
    }
  }
  
  void update() {
    controls();
    float rad = (PI/180)*deg;
    tip = new PVector (sin(rad)*100 + position.x, cos(rad)*100 + position.y);
    render();
    
    checkForCollision();
  }
    
  void controls() {
    if (rightTrigger.pressed()) {
      spin(6); 
    }
    if (leftTrigger.pressed()) {
      spin(4); 
    }
    
    if (path=="Gamepad for Xbox 360") {
      ControllStick stick2 = device.getStick(1);
      if (stick2.getY() > 0.33) {
        spin(6);
      } 
      if (stick2.getY() < -(0.33)) {
        spin(4);
      } 
    }
    move();
  }
  
  void move() {
    if (position.y <= 500 && position.y >= 100) {
    position.y += stick.getX();
    }
    if (position.x <= 650 && position.x >= 100) {
    position.x += stick.getY();
    }
    if (position.x >= 650) {
      position.x -= 1; 
    }
    if (position.x <= 150) {
      position.x += 1; 
    }
    if (position.y >= 500) {
      position.y -= 1; 
    }
    if (position.y <= 100) {
      position.y += 1; 
    }
  }
  
  void setCoordinates(int xx, int yy) {
    position.x = xx;
    position.y = yy; 
  }
  
  void checkForCollision() {
    for (int i=0; i< spears.length; i++) {
      PVector opponent = new PVector (spears[i].position.x,spears[i].position.y);
      segVLength = sqrt(pow((tip.x-position.x),2) + pow((position.y-tip.y),2));  
      pt_v = new PVector(opponent.x - position.x, position.y - opponent.y);
      seg_v = new PVector (tip.x-position.x, position.y-tip.y);
      projVLength = (pt_v.x * (seg_v.x/segVLength)) + (pt_v.y * (seg_v.y/segVLength));
      proj_v = new PVector (projVLength * (seg_v.x/segVLength), projVLength * (seg_v.y/segVLength));
      closest = new PVector(position.x+proj_v.x,position.y-proj_v.y);
      if (projVLength < 0) { closest = position; }
      if (projVLength > segVLength) { closest = tip; }
      distance = sqrt( pow(closest.x-opponent.x,2) + pow(closest.y-opponent.y,2));
      diff = distance - spears[i].r;
      if ( distance != 0.0 ) {
        if ( distance < spears[i].r/2) {
         // println(i + " IS COLLIDING.  Distance: " + distance );
          spears[i].c = red;
          stab.trigger();
          gameOver = true; 
          score+=1;
        }
        else {
         // println(i + " is not colliding.  Distance: " + distance );
        }
      }
    }
  }
  
  void resetColor() {
    c = playerC; 
  }
  
  void printScore() {
    fill(scoreC);
    text(str(score),scoreX,scoreY);  
  }
  
}
