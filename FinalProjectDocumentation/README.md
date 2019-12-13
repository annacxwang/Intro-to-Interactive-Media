Overall project concept and description


The project is a recreation of a responsive game where the user has to press the pad with its LED turned on in a given time. If the user doesn’t get to press the pad in an allocated time, s/he loses a life (out of 3) and the yellow LED turns on. If the user presses the wrong button where blue LED is not turned on, s.he loses a life and the red LED turns on. 
In order to enter a ‘prize mode’ and have a chance to win a treat, the user has to score more than 500 points. 
When the user scores more than 500, s/he gets to press any button on the game console. This button will randomly generate a ball with a corresponding color of the button’s LED and land into one of the four boxes. These four boxes red, blue, green and yellow; if the user’s luck allows his/her ball to fall in the box of the same color as the ball, s/he wins a treat.
The user gets to have a total of 5 trials.



Overall picture(s)





System diagram of the hardware and software


List of important parts (don’t include wires, resistors, etc.)


16 mounted buttons
3mm frosted/translucent acrylic
3mm black acrylic
neopixel

Pictures of the electronics



Explain how your project works and how you built it.


In terms of the hardware, we inserted another layer into the box to mount the buttons and glue the neopixels. On that layer, we laser-cut 16 holes for the buttons. We also made the dimension of the layer to be shorter in width so that the wires that are soldered onto the neopixels can fit into the box without extending out of the box. On of the sides, we made a small hole that just fits the red cable connecting arduino to the laptop; all the connections and wires from the neopixels and switches to the arduino were secured and stored inside the box.

Discuss what problems you ran into and how you resolved them or worked around them


We initially wanted to make a console that was 4 by 4 inches; each buttons/ frosted acrylic that we glue on the mounted buttons will be 1 inch by 1 inch. However, we couldn’t find a way to fit the neopixel and a button within the proposed dimension so we ended up enlarging the console to about 15cm by 15cm. 
We tried to hot glue the frosted acrylic onto the red mounted buttons but the color was more dominant than the LEDs so we put masking tape onto the buttons before hot-glueing the acrylics.
We found it difficult to bring the extended working space of our circuits and arduinos back into the box because the wires were stiffer than we thought. And while doing so, some of the wires in the breadboard got disconnected so we had to bend the edges of the wires so that they don’t easily come off the breadboard. 
The connections seemed quite fragile so we taped the sides and the bottom part of the box so that we can open it up again and fix it if anything happens during the showcase (which it didn’t thankfully)


On the software side, initially we want to make two LEDs lit up at the same time so the user will have to play with two hands (which would have been more fun). But when we program it, it was very difficult to capture two buttons pressed at the same time. Also, according to our program with different stages, the LED colors won't change according to if the correct button is pressed until the second button is pressed, giving user the delay of response for the first button pressed. In order to fix these issues, we modify the program so it light up and capture the pressing of one button at a time and it is now more responsive to presses ( corresponding lights will be lit up immediately after user pressing).


Discuss feedback you received during user testing, and what changes you made


After the user testing, we got some feedback about the buttons. When we designed and constructed it, we weren’t thinking too much about how people press the buttons and how much strength they put into it. One of the suggestions was to provide them with instructions to press the button in a certain way or warn them to not press the buttons too hard. We didn’t really want them to focus too much on the fragility of the hardware when playing our game so we decided not to say anything about it, but after our first player almost broke our button by slamming it, we decided to gently inform the users. 
Another suggestion was the instructions. One thing we noticed when people were playing our games was that although they read the instructions, they don’t really understand what they have to do. So before the showcase, we decided to edit the instructions and list them sequentially so that it’s easier for them to read. 


Evaluation from our showcase


We had a variety of users that made us happy and surprised at the same time. One of our very first users just before the showcase almost broke the button by pressing the corner of the frosted acrylic. We thought having a circular masking tape show through the frosted acrylic would be pretty intuitive enough but because they were too focused on getting a score higher than 500, they were very reckless with the way they handled our console. 
During the showcase, we were asked to shout out the scores displayed on the laptop screen because they couldn’t play and look at the same time. Initially, we had just the score displayed as a number on the screen but we thought they would be able to see their score better if we visualized the score into a colored bar that stands out from the black background (the score bar would increment together with the score). If we had another chance to work on this project, we would have redesigned the box so that the LCD panel is attached; this would have made it easier for the users to see their scores.
Some of the users also complained about the fact that they couldn’t enter their names for their score because we didn’t have a scoreboard. We thought rewarding them with treats was good enough but it wasn’t! :) So to improve, we would also have a scoreboard appear everytime they achieve the highest score.
It was extremely rewarding and entertaining to watch people play what we’ve made and although the point of the prize mode was to award all players who achieved more than 500 with treats, some were very unlucky to miss all the chance. 

