import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import procontroll.*; 
import java.io.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SPEARS extends PApplet {




 
ControllIO controll;
Minim minim;
AudioSample clink, stab;


boolean gameOver = false;

PFont font;

String xBoxController = "Gamepad for Xbox 360";
String lTechController = "Logitech(R) Precision(TM) Gamepad";

int blue = color(0,150,205);
int purple = color(130,240,90);
int clearB = color(0,150,205,150);
int clearP = color(130,240,90,180);

int p1homeX = 240;
int p1homeY = 280;
int p2homeX = 580;
int p2homeY = 280;


Spear[] spears = new Spear[2];

public void setup() {
  size(800, 600);
  smooth();
  frameRate(60);
  
  minim = new Minim(this);
  clink = minim.loadSample("clink.mp3");
  stab = minim.loadSample("stab.mp3");
  
  font = loadFont("Silom-48.vlw");
  textFont(font, 80);

  controll = ControllIO.getInstance(this);

  spears[0] = new Spear(p1homeX, p1homeY, xBoxController, blue, 40, 300, clearB);
  spears[1] = new Spear(p2homeX, p2homeY, lTechController, purple, 690, 300, clearP);

  
  println("SPEARS");
}

public void draw() {
  displayGameBoard();
  
  if (gameOver == false) {
    for (int i=0;i<spears.length;i++) {
      spears[i].update(); 
    }
    if ( (pow(spears[0].cX - spears[1].cX, 2)) + (pow(spears[0].cY - spears[1].cY, 4)) <= 2) {
      println("clink!");
      clink.trigger();
    //  stop();
    }
  }
  else {
    for (int i=0;i<spears.length;i++) {
      spears[i].render();
    }
    waitForButton();
  }
  
  for (int i=0;i<spears.length;i++) {
    spears[i].printScore(); 
  }
  
}

public void displayGameBoard() {
  //dither effect
  fill(240,240,240,90);
  rect(0,0,width,height);
  //center line
  strokeWeight(20);
  stroke(205,100,100,100);
  line(width/2,80,width/2,520);
  //circle
  stroke(160,0,205, 60);
  noFill();
  ellipse(width/2, height/2, 350,350);
  //wall
  stroke(40,20,20,60);
  rect(130,80,540,440); 
}

public void waitForButton() {
  for (int i=0;i<spears.length;i++) {
    if (spears[i].button.pressed()) {
      resetSpears();
    }
  }
}

public void resetSpears() {

  spears[0].setCoordinates(p1homeX,p1homeY);
  spears[1].setCoordinates(p2homeX,p2homeY);

  for (int i=0;i<spears.length;i++) {
    spears[i].resetColor();
    spears[i].update();
  }

  gameOver = false; 
}
class Spear {
  
  float x, y, cX, cY, rad, r;
  int deg=0;
  int c, scoreC, playerC;
  int red = color(180, 0,50);
  ControllDevice device;
  ControllStick stick;
  ControllButton button, leftTrigger, rightTrigger;
  boolean isColliding = false;
  String path;
  int scoreX, scoreY;
  int score;
  
  Spear(int xx, int yy, String d, int cc, int scX, int scY, int scC) {
    x = xx;
    y = yy;
    r = 20.0f;
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
  
  public void render() {
    strokeWeight(1);
    stroke(40);
    line(x,y,cX,cY);
    fill(c);
    noStroke();
    ellipse(x,y,r,r);
    fill(scoreC);
    ellipse(cX,cY, 3, 3);
  }
  
  public void spin(int direction) {
    if (direction == 6) {
      deg -= 5;
    }
    else if (direction == 4 ) {
      deg += 5;
    }
  }
  
  public void update() {
    controls();
    rad = (PI/180)*deg;
    cX = sin(rad)*100 + x;
    cY = cos(rad)*100 + y;
    render();
    
    checkForCollision();
  }
    
  public void controls() {
    if (rightTrigger.pressed()) {
      spin(6); 
    }
    if (leftTrigger.pressed()) {
      spin(4); 
    }
    
    if (path=="Gamepad for Xbox 360") {
      ControllStick stick2 = device.getStick(1);
      if (stick2.getY() > 0.33f) {
        spin(6);
      } 
      if (stick2.getY() < -(0.33f)) {
        spin(4);
      } 
    }
    move();
  }
  
  public void move() {
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
  
  public void setCoordinates(int xx, int yy) {
    x = xx;
    y = yy; 
  }
  
  
  public void checkForCollision() {
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
  
  public void resetColor() {
    c = playerC; 
  }
  
  public void printScore() {
    fill(scoreC);
    text(str(score),scoreX,scoreY);  
  }
  
}
class Wall {
  
  Wall() {
   
  } 
  
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "SPEARS" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
