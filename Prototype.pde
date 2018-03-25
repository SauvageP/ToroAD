import processing.serial.*;
Serial myPort;
/**
 * Bounce. 
 * 
 * When the shape hits the edge of the window, it reverses its direction. 
 */

int rad = 20;        // Width of the shape
float xpos, ypos;    // Starting position of shape    

float xspeed = random(2, 5);  // Speed of the shape
float yspeed = random(2, 5);  // Speed of the shape
float paddleX = 10;
float paddleY = 10;

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom
int diam, res;
int recSize = 100;
boolean gameStart = false;
String myString; 
String results;

void setup() 
{
  size(600, 400);
  noStroke();
  //smooth();
  frameRate(30);
  ellipseMode(RADIUS);
  // Set the starting position of the shape
  xpos = random(0, width-10);
  ypos = random(0, height-10);
  paddleX = width - rad;
  // List all the available serial ports:
  //printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, Serial.list()[7], 9600);
  myPort.bufferUntil('\n');
}

void draw() 
{
  background(155);
  // Draw the shape
  ellipse(xpos, ypos, rad, rad);

  fill(255);
  rect(width/2 - 50, height - rad, recSize, 20);

  fill(255);
  rect(0,0, width, 20);  
  //rect(0, 0, recSize, 20);

  if (gameStart) {
    // Update the position of the shape
    xpos = xpos + ( xspeed * xdirection );
    ypos = ypos + ( yspeed * ydirection );

    // Test to see if the shape exceeds the boundaries of the screen
    // If it does, reverse its direction by multiplying by -1
    if (xpos > width-rad || xpos < rad) {
      xdirection *= -1;
      xpos = xpos + ( xspeed * xdirection );
    }
    if (ypos > height-rad || ypos < rad) {
      ydirection *= -1;
      ypos = ypos + (yspeed * ydirection );
    }
  }

  // Expand array size to the number of bytes you expect
  byte[] inBuffer = new byte[7];
  while (myPort.available() > 0) {
    inBuffer = myPort.readBytes();
    myPort.readBytes(inBuffer);
    if (inBuffer != null) {
      myString = new String(inBuffer);
      println(myString);
    }
  }
}


void mousePressed() {
  gameStart = !gameStart;
}
