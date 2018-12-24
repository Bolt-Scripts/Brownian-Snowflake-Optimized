// Coding Challenge 127: Brownian Motion Snowflake
// Daniel Shiffman
// https://thecodingtrain.com/CodingChallenges/127-brownian-snowflake.html
// https://youtu.be/XUA8UREROYE
// https://editor.p5js.org/codingtrain/sketches/SJcAeCpgE

class Particle {

  PVector pos;
  float radius;
  float dSq;
  float diameter;

  Particle(float snowflakeRadius, float angle) {
    pos = PVector.fromAngle(angle);
    pos.mult(snowflakeRadius);
    radius = particleSize;
    diameter = radius * 2;
    dSq = diameter * diameter;
  }

  void update() {
    pos.x -= 1;
    pos.y += random(-particlePosFluctuation, particlePosFluctuation);

    float angle = pos.heading();
    angle = constrain(angle, 0, PI/6);
    float magnitude = pos.mag();
    pos = PVector.fromAngle(angle);
    pos.setMag(magnitude);
  }

  void show() {
    if (drawAsLines) {
      stroke(255, 100);
      strokeWeight(radius);
      line(last.pos.x, last.pos.y, pos.x, pos.y);
    } else {
      stroke(255, 200);
      strokeWeight(diameter);
      point(pos.x, pos.y);
    }
  }

  boolean intersects() {
    ArrayList<Particle> queryPoints = bsp.Query(new Rectangle(pos.x, pos.y, diameter, diameter), 0);
    for (Particle s : queryPoints) {
      float sqrDist =  PVector.sub(s.pos, pos).magSq();
      if (sqrDist < dSq) {
        return true;
      }
    }
    return false;
  }

  boolean finished() {
    return (pos.x < 1);
  }
}
