class Particle {
  PVector position; // cria um tipo vetorial para receber os valores da posição 
  PVector velocity; // cria um tipo vetorial para receber os valores de velocidade 
  PVector acceleration; // cria um tipo vetorial para receber os valores de aceleração  
  float lifespan; // cria um tipo numérico de ponto flutuante para receber o tempo de vida da partícula 
  
  color pColor; // cria um tipo cor 

  Particle(PVector l, color pColor) { // constrói o objeto do tipo da classe recebendo como parâmetro as coordenadas x e y de posição e a cor 
    acceleration = new PVector(0, 0.05); // define a aceleração 
    velocity = new PVector(random(-2, 2), random(-2, 2)); // define a velocidade dentro de um range, dando organicidade às partículas 
    position = l.copy(); // recebe as corrdenadas passadas no parâmetro 
    lifespan = 200.0; // define o tempo de vida 
    
    this.pColor = pColor; // recebe a cor passada no parâmetro 
  }

  void run() { // executa a aparência e a dinâmica da partícula 
    update();
    display();
  }
  void update() { // atualiza as características dinâmicas da partícula 
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= pow(2, (lifespan/50));
  }

  void display() { // atualiza as características estéticas da partícula 
    stroke(pColor, lifespan);
    fill(pColor, lifespan);
    rect(position.x, position.y, 15, 15);
  }

  boolean isDead() { // método para verificar se a partícula já "terminou seu ciclo dinâmico" (morreu...) 
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
