
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif

// the pin # neo pixel is connected to 
#define LED_PIN    6

#define LED_COUNT 16

#define BUTTON_COUNT 16



// Declare our NeoPixel strip object:
Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);
// Argument 1 = Number of pixels in NeoPixel strip
// Argument 2 = Arduino pin number (most are valid)
// Argument 3 = Pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
//   NEO_RGBW    Pixels are wired for RGBW bitstream (NeoPixel RGBW products)

// the frequency LEDs are randomly picked and displayed, gets incresed during the course of the game
int frequency;

//listing all the pins for 16 buttons
int button1 = 2;
int button2 = 3;
int button3 = 4;
int button4 = 5;
//6 is LED PIN
int button5 = 7;
int button6 = 8;
int button7 = 9;
int button8 = 10;
int button9 = 11;
int button10 = 12;
int button11 = 13;
int button12 = A0;
int button13 = A1;
int button14 = A2;
int button15 = A3;
int button16 = A4;

//flags for communication
int pressed = -1;
int reading = false;

//counters
int score = 0;
int lives = 3;
float timer = 0;
int ballCount = 6;

//flags for current state
int outOfTime = false;
int start = false;
int disp = false;
int capture = false;
int check = false;
int prizeDrag = false;

#define INITIAL 1
#define DISP 2
#define TIME_OUT 3
#define WRONG 4
#define PRIZE 5
#define TOO_SOON 6
#define ADD_SCORE 7
#define RED 8
#define YELLOW 9
#define GREEN 10
#define BLUE 11
#define FINISH 12

int light1 = -1;
int light2 = -1;
int answer1 = -1;
int answer2 = -1;


// 
int colors[] = {strip.Color(255, 0, 0), strip.Color(255, 255, 0), strip.Color(0, 255, 0), strip.Color(0, 0, 255),
                strip.Color(0, 0, 255), strip.Color(255, 0, 0), strip.Color(255, 255, 0), strip.Color(0, 255, 0),
                strip.Color(0, 255, 0), strip.Color(0, 0, 255), strip.Color(255, 0, 0), strip.Color(255, 255, 0),
                strip.Color(255, 255, 0), strip.Color(0, 255, 0), strip.Color(0, 0, 255), strip.Color(255, 0, 0)
               };

void setup() {
  // These lines are specifically to support the Adafruit Trinket 5V 16 MHz.
  // Any other board, you can remove this part (but no harm leaving it):
#if defined(__AVR_ATtiny85__) && (F_CPU == 16000000)
  clock_prescale_set(clock_div_1);
#endif
  // END of Trinket-specific code.
  strip.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  strip.show();            // Turn OFF all pixels ASAP
  strip.setBrightness(10); // Set BRIGHTNESS to about 1/5 (max = 255)
  frequency = 400;
  pinMode(button1, INPUT);
  pinMode(button2, INPUT);
  pinMode(button3, INPUT);
  pinMode(button4, INPUT);
  pinMode(button5, INPUT);
  pinMode(button6, INPUT);
  pinMode(button7, INPUT);
  pinMode(button8, INPUT);
  pinMode(button9, INPUT);
  pinMode(button10, INPUT);
  pinMode(button11, INPUT);
  pinMode(button12, INPUT);
  pinMode(button13, INPUT);
  pinMode(button14, INPUT);
  pinMode(button15, INPUT);
  pinMode(button16, INPUT);
  Serial.begin(9600);
      Serial.println("Press any key to begin");
  Serial.println(INITIAL);
}



void loop() {

  if (!start) {
    Set4Colors();
    // LEDs are lit up to 4 colors (red, green , blue , yellow) initially before the game starts
     getPressInput();

    strip.clear();
    if (pressed != -1 && !reading) {
      pressed = -1;
      score = 0;
      lives = 3;
      start = true;
      disp = true;
      Serial.println(DISP);
    }
  }
  else {

    if (lives > 0) {
      
      if (disp) {
        
        light1 = RandomLightUp1(strip.Color(0, 0, 255));
        delay(frequency);


        delay(100);
        strip.clear();
        if (frequency > 100) {
          //decrease the frequency to make the display of led faster
          frequency -= 40;
        }
        disp = false;
        capture = true;
        timer = 0;
      }
      else if (capture) {

        getPressInput();
        timer = timer + 0.1;

        if (timer > frequency * 10) {
          timer = 0;
          outOfTime = true;
          capture = false;
          check = true;
        }
        else {
          if (answer1 == -1) {
            if (pressed != -1 && !reading) {
                            Serial.print("a1");
                            Serial.println(pressed);
              answer1 = pressed;
              pressed = -1;
            }
          }

          if (answer1 != -1) {
            capture = false;
            check = true;
            timer = 0;
          }
        }
      } //end of capture
      else if (check) {
        if (outOfTime) {
          lives--;
          Serial.println(TIME_OUT);
          outOfTime = false;
          strip.setPixelColor( light1, strip.Color(255, 255, 0));
        }
        else {
          if (answer1 == light1) {
            score += 10;
           Serial.println(ADD_SCORE);
            strip.setPixelColor( answer1, strip.Color(0, 255, 0));
          }
          else {
            lives--;
            Serial.println(WRONG);
            strip.setPixelColor( answer1, strip.Color(255, 0, 0));
          }

        }
        check = false;
        disp = true;
        answer1 = -1;
        strip.show();
        Serial.println(DISP);
        delay(50);
        strip.clear();
        delay(frequency);
      }

    }
    else if (score > 500 &&!prizeDrag) {
// when scores over 500, enter prize mode
      Serial.println(PRIZE);
      prizeDrag = true;
    }
    else if (prizeDrag){
      Set4Colors();

      getPressInput();
      if (pressed != -1 && !reading) {
        // checking the color of the pressed button
        if (pressed == 0||pressed == 4||pressed == 10||pressed == 14) {
          Serial.println(8); // I don't know why but Serial.println(RED) doesn't send integer 8 as defined in the beginning so I send the number directly
        // Serial.println("RED");
        }
        else if (pressed == 1||pressed == 7||pressed == 11||pressed == 13) {
          Serial.println(9);
          //Serial.println("YELLOW");
        }
        else if (pressed == 2||pressed == 6||pressed == 8||pressed == 12) {
          Serial.println(10);
          //Serial.println("GREEN");
        }
        else {
          Serial.println(11);
         //Serial.println("BLUE");
        }
        ballCount--;
        pressed = -1;
    
      }
      if (ballCount == 0) {
          start = false;
          prizeDrag = false;
          ballCount = 6;
          Serial.println(FINISH); //have press to begin, but not clearing the drag interface
        }
    }
    else {
      //die too soon}
      // send dead message to processing
                Serial.println("Out of lives!");
                Serial.print("Score: ");

      Serial.println(score);
      Serial.println(TOO_SOON);
          Serial.println("Press any key to begin");
      
      Serial.println(FINISH);
      //has the dead message + enter to start
      start = false;
    }
  }
}

void getPressInput() {


  int switchVal[] = {digitalRead(button1), digitalRead(button2), digitalRead(button3),
                     digitalRead(button4), digitalRead(button5), digitalRead(button6), digitalRead(button7),
                     digitalRead(button8), digitalRead(button9), digitalRead(button10), digitalRead(button11),
                     digitalRead(button12), digitalRead(button13), digitalRead(button14), digitalRead(button15),
                     digitalRead(button16)
                    };

  if (!reading) {
    for (int i = 0; i < BUTTON_COUNT; i++) {
      if (switchVal[i]) {
        reading = true;
        pressed = i;
        break;
      }
    }
  }
  else {
    reading = false;
    for (int i = 0; i < BUTTON_COUNT; i++) {
      reading = reading || switchVal[i];
// if any of the button is pressed, program will keep capturing and only return the first pressed button
    }
  }

}


// randomly choose a botton from the strip to light up
int RandomLightUp1(uint32_t color) {

  int index = random(0, strip.numPixels());
  strip.setPixelColor( index, color);
  strip.show();
  return index;
}



// in the prize mode, the LEDs are set to red, yellow, blue, green for the users to generate balls of the same colors
void Set4Colors() {
  strip.setPixelColor( 0, strip.Color(255, 0, 0));
  strip.setPixelColor( 1, strip.Color(255, 255, 0));
  strip.setPixelColor( 2, strip.Color(0, 255, 0));
  strip.setPixelColor( 3, strip.Color(0, 0, 255));

  strip.setPixelColor( 4, strip.Color(255, 0, 0));
  strip.setPixelColor( 5, strip.Color(0, 0, 255));
  strip.setPixelColor( 6, strip.Color(0, 255, 0));
  strip.setPixelColor( 7, strip.Color(255, 255, 0));

  strip.setPixelColor( 8, strip.Color(0, 255, 0));
  strip.setPixelColor( 9, strip.Color(0, 0, 255));
  strip.setPixelColor( 10, strip.Color(255, 0, 0));
  strip.setPixelColor( 11, strip.Color(255, 255, 0));

  strip.setPixelColor( 12, strip.Color(0, 255, 0));
  strip.setPixelColor( 13, strip.Color(255, 255, 0));
  strip.setPixelColor( 14, strip.Color(255, 0, 0));
  strip.setPixelColor( 15, strip.Color(0, 0, 255));

  strip.show();

}
