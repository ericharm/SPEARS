class Spear {
  
  float x, y, cX, cY, rad, r;
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
    x = xx;
    y = yy;
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
    strokeWeight(1);
    stroke(40);
    line(x,y,cX,cY);
    fill(c);
    noStroke();
    ellipse(x,y,r,r);
    fill(scoreC);
    ellipse(cX,cY, 3, 3);
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
    rad = (PI/180)*deg;
    cX = sin(rad)*100 + x;
    cY = cos(rad)*100 + y;
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
    if (y <= 500 && y >= 100) {
    y += stick.getX();
    }
    if (x <= 650 && x >= 100) {
    x += stick.getY();
    }
    if (x >= 650) {
      x -= 1; 
    }
    if (x <= 150) {
      x += 1; 
    }
    if (y >= 500) {
      y -= 1; 
    }
    if (y <= 100) {
      y += 1; 
    }
  }
  
  void setCoordinates(int xx, int yy) {
    x = xx;
    y = yy; 
  }
  
  
  void checkForCollision() {
    float spearTips[] = new float [4];
    for (int i = 0; i < spears.length; i = i+1) {
      spearTips[i] = cX;
      spearTips[i+2] = cY;
      if ( (pow(x - spears[i].cX, 2)) + (pow(y - spears[i].cY, 2)) <= (pow(r/2,2) - r) ) {
        c = red;
        stab.trigger();
        gameOver = true; 
        spears[i].score+=1;
      }
      else {
        println(""); 
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
