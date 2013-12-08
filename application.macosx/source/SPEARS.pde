import procontroll.*;
import java.io.*;
import ddf.minim.*;
 
ControllIO controll;
Minim minim;
AudioSample clink, stab;


boolean gameOver = false;

PFont font;

String xBoxController = "Gamepad for Xbox 360";
String lTechController = "Logitech(R) Precision(TM) Gamepad";

color blue = color(0,150,205);
color purple = color(130,240,90);
color clearB = color(0,150,205,150);
color clearP = color(130,240,90,180);

int p1homeX = 240;
int p1homeY = 280;
int p2homeX = 580;
int p2homeY = 280;


Spear[] spears = new Spear[2];

void setup() {
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

void draw() {
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

void displayGameBoard() {
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

void waitForButton() {
  for (int i=0;i<spears.length;i++) {
    if (spears[i].button.pressed()) {
      resetSpears();
    }
  }
}

void resetSpears() {

  spears[0].setCoordinates(p1homeX,p1homeY);
  spears[1].setCoordinates(p2homeX,p2homeY);

  for (int i=0;i<spears.length;i++) {
    spears[i].resetColor();
    spears[i].update();
  }

  gameOver = false; 
}
