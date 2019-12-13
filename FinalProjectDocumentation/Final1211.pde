/*
The project is a recreation of a responsive game where the user has to press the pad with its LED turned on in a given time. 
If the user doesn’t get to press the pad in an allocated time, s/he loses a life (out of 3) and the yellow LED turns on.
If the user presses the wrong button where blue LED is not turned on, s.he loses a life and the red LED turns on. 
In order to enter a ‘prize mode’ and have a chance to win a treat, the user has to score more than 500 points. 
When the user scores more than 500, s/he gets to press any button on the game console. 
This button will randomly generate a ball with a corresponding color of the button’s LED and land into one of the four boxes. 
These four boxes red, blue, green and yellow; if the user’s luck allows his/her ball to fall in the box of the same color as the ball, s/he wins a treat.
 */


import processing.serial.*;

Serial myPort; 
int inByte; // the variable storing the communication
int score; // initially 0, a tracker for scores player get
int lives; 
int chances; // the counter in the prize mode

import processing.sound.*;
SoundFile bgm;
SoundFile correct; //sound effect for correct press
SoundFile wrong; //sound effect for wrong press
SoundFile prize; //bgm for prize mode

//The Arduino sends messages in integer strings 
// At first I tried to make Arduino send self-explanatory strings as messages 
//such as "begin" but (message =="begin") always return false so I switch to numbers instead
static int INITIAL=1;
static int DISP=2;
static int TIME_OUT =3;
static int WRONG =4;
static int PRIZE =5;
static int TOO_SOON =6;
static int ADD_SCORE =7;
static int RED =8;
static int YELLOW =9;
static int GREEN =10;
static int BLUE =11;
static int FINISH =12;

PFont f;
String message;

//useful flags
boolean used = true; 
boolean prizeMode = false;
boolean ballFinish = true;
color ballColor;
// an array of color for the score bar to get bluer as the score goes up
color[] score_colors = {color(230,254,255), color(220,253,255),color(210,252,255),
            color(200,250,255),color(190,249,255),color(180,248,255),
            color(170,247,255),color(160,245,255),color(150,242,255),
            color(140,240,255),color(130,236,255),color(120,232,255),
            color(110,230,255),color(100,228,255),color(90,224,255),
            color(80,222,255),color(70,220,255), color(60,216,255),color(54,212,255),
            color(45,210,255),color(40,207,255),color(34,204,255),
            color(20,201,255),color(0,196,255)};
//color scoreColor;
int scoreColorIndex;
int ballRadius =30;

//array to 
ArrayList<Ball> balls;

float CIRCLESIZE = 30;
float r;
int count;
int prizeCount;
int bw; // box width used in prize mode
float rb1 ; //red box border
float rb2 ; //red box border
float yb1 ; //yellow box border
float yb2 ; //yellow box border
float gb1 ; //green box border
float gb2  ; //green box border
float bb1 ; //blue box border
float bb2 ; //blue box border

//class for the balls in prizeMode
class Ball {

  PVector loc;
  PVector vel;
  PVector grav;
  float drag= .4;
  //maximum of bounces a ball should make
  int bounce = 8;
  color c; 
  boolean finished = false;
  Ball(color given) {
//ball initialized with random location and velocity but given color
    loc = new PVector(random(r, width-r), r);
    vel= new PVector(random(-1.5, 1.5), 0);
    grav= new PVector (0, 1);
    c = given;
  }

  void run() {

    check();
    update();
  }

//update the position of the ball and draws it on canvas
  void update() {
    if (bounce>0) {
      loc.add(vel);
      vel.add(grav);
    }
    pushMatrix();
    fill(c);
    ellipse(loc.x, loc.y, CIRCLESIZE, CIRCLESIZE);
    popMatrix();
  }
  
// checking if the ball hits the boundary of any box or the screen, 
// if so, decrease and reverse the direction of its velocity
  void check() {

    if (loc.x>bb2-r) {
      vel.x *= -drag;
      loc.x = bb2-r;
    } else if (loc.x<bb1+r &&loc.x>bb1-bw) {
      vel.x *= -drag;
      loc.x = bb1+r;
    } else if (loc.x<gb2+bw &&loc.x>gb2-r) {
      vel.x *= -drag;
      loc.x = gb2-r;
    } else if (loc.x<gb1+r &&loc.x>gb1-bw) {
      vel.x *= -drag;
      loc.x = gb1+r;
    } else if (loc.x<yb2+bw &&loc.x>yb2-r) {
      vel.x *= -drag;
      loc.x = yb2-r;
    } else if (loc.x<yb1+r &&loc.x>yb1-bw) {
      vel.x *= -drag;
      loc.x = yb1+r;
    } else if (loc.x<rb2+bw &&loc.x>rb2-r) {
      vel.x *= -drag;
      loc.x = rb2-r;
    } else if (loc.x<rb1+r) {
      vel.x *= -drag;
      loc.x = rb1+r;
    }

    if (loc.y>=height-r-bw) {
      vel.y *= -drag;
      loc.y = height-r-bw;
      bounce--;
    }
    
    //limiting the time of bounces of each ball so they don't bounce infinitely
    if (bounce ==0) {

      if (c ==color(255, 0, 0)&&loc.x<rb2&&loc.x>rb1) {
        prizeCount++;
      }
      if (c ==color(255, 255, 0)&&loc.x<yb2&&loc.x>yb1) {
        prizeCount++;
      }
      if (c ==color(0, 255, 0)&&loc.x<gb2&&loc.x>gb1) {
        prizeCount++;
      }
      if (c ==color(0, 0, 255)&&loc.x<bb2&&loc.x>bb1) {
        prizeCount++;
      }
      ballFinish = true;
    };
  }
}

void setup () {
  // set the window size:
  size(1430, 800);
  f = createFont("American Typewriter", 20);
  textFont(f, 40);

  myPort = new Serial(this, Serial.list()[1], 9600);

  // don't generate a ser ialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  // set initial background:
  background(0);
  stroke(255);
  lives =3;
  scoreColorIndex = 0;


  bgm =  new SoundFile(this, "bgm.mp3");
  //lowering the bgm volume
bgm.amp(0.5);
correct =  new SoundFile(this, "correct.mp3");;
wrong =  new SoundFile(this, "false.mp3");;
prize =  new SoundFile(this, "prize.mp3");;
  
bgm.loop();


  //wait for communication
  delay(1000);

}
PVector pos = new PVector(width/2, height/2);
void draw () {

  if (!prizeMode) {
    if (!used) {
      //if last message not processed yet
//inByte stores the last unprocessed message
      if (inByte == INITIAL) {
        //initial interface when the game program first starts
         message = "Press any button that's lit up till it turns green! ";
        String message1 = "If you get 500 points or more, you will get a chance to win a treat!";
        text(message, width/2-textWidth(message)/2, (height/2));
        text(message1, width/2-textWidth(message1)/2, (height/2)+50);
        message = "-Press any button to start-";
        text(message, width/2-textWidth(message)/2, height*3/4);
      }
      if (inByte == DISP) {
        //displaying current socre & lives
        background(0);
        text("Score", (width/2)-70, 300);
        text(score,(width/2)+10 + textWidth("Score"),300);
        pushMatrix();
        noStroke();
        fill(score_colors[scoreColorIndex]);
        // using a score bar with incresing length to visualize the score
        rect(width/2-score*width/1000, (height/2)-60, score*width/500 ,30);
        popMatrix();
        pushMatrix();
        fill(255);
        text("Lives:", width-textWidth("Lives:")-200, 30);
        popMatrix();
        //loop to display remaining lives in filled/shallow circles
        for (int i =0; i<lives; i++) {
          fill(255);
          ellipse(width-20-70*i, 30, 30, 30);
        }
        for (int i =2; i>lives-1; i--) {
          noFill();
          stroke(255);
          ellipse(width-20-70*i, 30, 30, 30);
        }
      }
      if (inByte == TIME_OUT) {
      //when player doesn't press within time limit
        message = "Out of Time!";
        text(message, width/2-textWidth(message)/2, height*3/4);
        lives--;

         wrong.play();

      }
      if (inByte == WRONG) {
        lives--;
        message = "Wrong button pressed!";
        text(message, width/2-textWidth(message)/2, height*3/4);
         wrong.play();

      }
      if (inByte == PRIZE) {
        //displaying instructions for the prize mode 
        message = "Try your luck to win treats! ";
        String message1 = "Each button you press, a ball of the same color will be generated randomly";
        String message2 = "Wait till one ball finishes bouncing before pressing another button!";
        String message3 = "You get a total of 5 chances";
        String message4 = "If your ball falls into box of the same color, you win a treat";
        String message5 = "Now start the first trial!";
        text(message, width/2-textWidth(message)/2, (height/2)+20);
        text(message1, width/2-textWidth(message1)/2, (height/2)+70);
         text(message2, width/2-textWidth(message2)/2, (height/2)+120);
          text(message3, width/2-textWidth(message3)/2, (height/2)+170);
          text(message4, width/2-textWidth(message4)/2, (height/2)+220);
          text(message5, width/2-textWidth(message5)/2, (height/2)+270);
        prizeMode = true;
//make new array for the balls from this user
        balls = new ArrayList<Ball>();
        count = 5;
        prizeCount =0;

        bw = 20;
        rb1 = bw; //red box border
        rb2 = width/4 -bw; //red box border
        yb1 = width/4 +bw; //yellow box border
        yb2 = width/2 -bw; //yellow box border
        gb1 = width/2 +bw; //green box border
        gb2 = width/4*3-bw ; //green box border
        bb1 = width/4*3 +bw; //blue box border
        bb2 = width -bw; //blue box border
        r = CIRCLESIZE/2;
prize.play();


      }
      if (inByte == TOO_SOON) {
        //if the play run out of lives before getting 500 points
        message = "Out of lives! Try again";
        text(message, width/2-textWidth(message)/2, height/2);
        
       
      }

      if (inByte == ADD_SCORE) {
        //when user gets a correct click
        score+=10;
        if(scoreColorIndex<score_colors.length-1){
        scoreColorIndex++;}
         correct.play();

      }
      if (inByte == FINISH) {
        // end of game, displaying messages to start the next round
        fill(255);
         message = "Press any button that's lit up till it turns green! ";
        String message1 = "If you get 250 points or more, you will get a chance to win a treat!";
        text(message, width/2-textWidth(message)/2, (height/2)+50);
        text(message1, width/2-textWidth(message1)/2, (height/2)+100);
        message = "-Press any button to start-";
        text(message, width/2-textWidth(message)/2, height*3/4);
        lives =3;
        score =0;
        scoreColorIndex = 0;
      }
    } 
    used = true;
  } else {
    //inside prize mode 
    if (ballFinish)
    {if(!used){
      // if last press for ball taken has not been used, generate a ball with the same color
      if (inByte == RED) {
        if (count>0) { 
          ballColor = color(255, 0, 0);
          balls.add(new Ball(ballColor));
          count--;
          ballFinish=false;
        }
      }
      if (inByte == YELLOW) {
        if (count>0) { 
          ballColor = color(255, 255, 0);
          balls.add(new Ball(ballColor));
          count--;
          ballFinish=false;
        }
      }
      if (inByte == GREEN) {
        if (count>0) { 
          ballColor = color(0, 255, 0);
          balls.add(new Ball(ballColor));
          count--;
          ballFinish=false;
        }
      }
      if (inByte == BLUE) {
        if (count>0) { 
          ballColor = color(0, 0, 255);
          balls.add(new Ball(ballColor));
          count--;
          ballFinish=false;
        }
      }

      if (inByte == FINISH) {
        //end of prize mode, display treat count and prompt for the next round


        prizeMode = false;
        stroke(255);
        fill(255);
        message = "You've won           treat(s)";
        text(message, width/2-textWidth(message)/2, height/4);
        text(prizeCount, width/2+30, height/4);
        print("prize:");
        println(prizeCount);
         message = "Press any button that's lit up till it turns green! ";
        String message1 = "If you get 250 points or more, you will get a chance to win a treat!";
        text(message, width/2-textWidth(message)/2, (height/2));
        text(message1, width/2-textWidth(message1)/2, (height/2)+50);
        message = "-Press any button to start-";
        text(message, width/2-textWidth(message)/2, height*3/4);
        lives =3;
        score =0;
        scoreColorIndex = 0;
      }
      used = true;
    }
    } else {
//when the last ball hasn't stopped bouncing, draw the bouncing ball along with the other stationary balls generated so far
      background(0);
      DrawBoxBoarder();
      for (int i=0; i <balls.size(); i++) {
        Ball p = balls.get(i);
        p.run();
      }
      stroke(255);
      text("Score:", 0, 30);
      text(score, textWidth("Score:")+80, 30);
      text("Lives:", width-textWidth("Lives:")-200, 30);
      for (int i =2; i>lives-1; i--) {
        noFill();
        ellipse(width-20-70*i, 30, 30, 30);
      }
    }
  }
}

// function to draw the border of 4 colored boxes in the prize mode
void DrawBoxBoarder() {
  pushMatrix();
  fill(255, 0, 0);
  stroke(255, 0, 0);
  rect(rb1-bw, height/5*4, bw, height/5);
  rect(rb2, height/5*4, bw, height/5);
  rect(rb1, height-bw, rb2-rb1, bw);
  fill(255, 255, 0);
  stroke(255, 255, 0);
  rect(yb1-bw, height/5*4, bw, height/5);
  rect(yb2, height/5*4, bw, height/5);
  rect(yb1, height-bw, yb2-yb1, bw);
  fill(0, 255, 0);
  stroke(0, 255, 0);
  rect(gb1-bw, height/5*4, bw, height/5);
  rect(gb2, height/5*4, bw, height/5);
  rect(gb1, height-bw, gb2-gb1, bw);
  fill(0, 0, 255);
  stroke(0, 0, 255);
  rect(bb1-bw, height/5*4, bw, height/5);
  rect(bb2, height/5*4, bw, height/5);
  rect(bb1, height-bw, bb2-bb1, bw);
  popMatrix();
}

// taking the input from the serial port 
void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    inByte = int(inString);
    used=false;
    delay(50);
  }
}
