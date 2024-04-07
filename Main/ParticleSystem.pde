class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  
  color pColor;
  
  int particleMax; 
  int particleIsDeadCounter; 

  ParticleSystem(PVector position, color pColor) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
   
   this.pColor = pColor; 
   
   particleMax = 10; 
   particleIsDeadCounter = 0; 
  }

  void addParticle() {
    if(particles.size()-1 < particleMax){
      particles.add(new Particle(origin, pColor));
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
        particleIsDeadCounter++; 
      }
    }
  }
}
