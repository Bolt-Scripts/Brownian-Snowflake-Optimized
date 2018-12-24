// Coding Challenge 127: Brownian Motion Snowflake
// Daniel Shiffman
// Modifications by BoltMan
// https://thecodingtrain.com/CodingChallenges/127-brownian-snowflake.html
// https://youtu.be/XUA8UREROYE

Particle current;
Particle last;
QuadTree bsp;
boolean completed = false;
float flakeRadius;
int maxRadius;


//-------------------params (change these)-------------------//
boolean animate = true;
int animateIterations = 25;

boolean drawAsLines = false; // creates spiderweb-like snowflakes!

float particleSize = 1.5;
int particlePosFluctuation = 5; // higher values can look cool but past like 10 it stops working

float newFlakeDelayInSeconds = 0.25; //how long to pause at the end of each snowflake
//-------------------params (change these)-------------------//

void setup() {
  size(800, 800);
  //fullScreen();
  maxRadius = min(width, height) / 2;

  if (animate)
    ResetSnowflake();
}

void ResetSnowflake() {  
  completed = false;
  background(20);

  if (bsp != null)
    delay(int(newFlakeDelayInSeconds * 1000));

  flakeRadius = maxRadius - random(0, maxRadius/3);
  bsp = new QuadTree(new Rectangle(width / 2, height / 2, width / 2, height / 2), null);

  last = new Particle(0, 0);
  current = new Particle(flakeRadius, 0);
}




void draw() {
  translate(width/2, height/2);
  rotate(PI/6);

  if (!animate)
    ResetSnowflake();

  while (!completed) {
    for (int i = 0; i < animateIterations; i++) {
      current = new Particle(flakeRadius, 0);

      int count = 0;
      while (!current.finished() && !current.intersects()) {
        current.update();
        count++;
      }

      ///draw particles with radial symetry
      for (int rot = 0; rot < 6; rot++) {
        rotate(PI/3);
        current.show();

        pushMatrix();
        scale(1, -1);
        current.show();
        popMatrix();
      }
      
      //insert our latest new particle int the bsp tree so new particles can check against it
      bsp.Insert(current);
      
      
      last = current;

      // If a particle doesn't move at all we're done
      // This is an exit condition not implemented in the video
      if (count == 0) {
        completed = true;
        println("snowflake completed");
        break;
      }
    }

    if (completed && animate)
      ResetSnowflake();

    if (animate || completed)
      break;
  }
}
