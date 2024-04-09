class ParticleSystem {
  ArrayList<Particle> particles; // cria uma lista do tipo Particle 
  PVector origin; // cria um vetor para receber as coordenadas iniciais 
  
  color pColor; // variável do tipo cor 
  
  int particleMax; // número máximo de partículas 
  int particleIsDeadCounter; // contador de partículas que já completaram seu ciclo dinâmico 

  ParticleSystem(PVector position, color pColor) { // construtor que pede as coordenadas de posição e cor (a nave que explode, no caso específico)
    origin = position.copy(); // pega as coordenadas e atribui como origem 
    particles = new ArrayList<Particle>(); // instancia a lista de partículas 
   
   this.pColor = pColor; // recebe a cor 
   
   particleMax = 10; // define o número máximo de partículas - altere para variar o efeito 
   particleIsDeadCounter = 0; // inicia a dinâmica com zero partículas mortas 
  }

  void addParticle() { // método para adicionar partículas à lista 
    if(particles.size()-1 < particleMax){ // verifica se a lista ainda comporta mais partículas de acordo com o pré estalecido máximo 
      particles.add(new Particle(origin, pColor)); // adiciona uma nova partícula com as características recebidas do objeto a ser ilustrado 
    }
  }

  void run() { // atualiza a dinâmica e o aspecto visual de cada partícula na lista 
    for (int i = particles.size()-1; i >= 0; i--) { // passa a lista de partículas de trás pra frente 
      Particle p = particles.get(i); // cria um tipo partícula e recbe a partícula na posição da lista 
      p.run(); // atualiza as características da partícula 
      if (p.isDead()) { // verifica se essa partícula já terminou seu ciclo 
        particles.remove(i); // remove essa partícula da lista 
        particleIsDeadCounter++; // incrementa essa partícula como morta 
      }
    }
  }
}
