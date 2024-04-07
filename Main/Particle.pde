class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  
  color pColor; 

  Particle(PVector l, color pColor) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-2, 2), random(-2, 2));
    position = l.copy();
    lifespan = 200.0;
    
    this.pColor = pColor; 
  }

  void run() {
    update();
    display();
  }
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= pow(2, (lifespan/50));
  }

  void display() {
    stroke(pColor, lifespan);
    fill(pColor, lifespan);
    rect(position.x, position.y, 15, 15);
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
