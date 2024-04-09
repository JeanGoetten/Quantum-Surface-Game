class Shoot{
  
  float x_hit, y_hit, speed_hit, bulletSize; // posição, velocidade e tamanho 
  
  float y_correction = 0; // correção para o deslocamento vertical 
  
  boolean shouldRemove; // controle da remoção do tiro 
  
  color R = color(255, 0, 0, 150);  // Define color red
  color G = color(0, 255, 0, 150);  // Define color green
  color B = color(100, 100, 255, 200);  // Define color blue
  
  color myColor = B; 
  
  Shoot(float x, float y, float speed, float bulletSize){ // método constr7utor 
    if(level < 6){ // verifica o level e atribui valores distintos para cor e deslocamento vertical 
      myColor = B; 
    }else if(level == 6){
      myColor = G; 
    }else if(level == 7){
      y_correction = -50; 
      myColor = G; 
    }else if(level == 8){
      y_correction = -100; 
      myColor = G; 
    }if(level >= 9){
      y_correction = -200; 
      myColor = R; 
    }
    this.x_hit = x; 
    this.y_hit = y - y_correction; 
    this.speed_hit = speed; 
    this.bulletSize = bulletSize; 
    
    shouldRemove = false; //seta a variável de controle para falso 
  }
  
  public void update(){ // atualiza a dinâmica do projétil 
    //a_hit = atan2(y_hit, x_hit); // retorna o ângulo em radianos -pi a pi
    y_hit -= speed_hit; // desloca o tiro no eixo y (vertical) incrementando o valor de 'velocidade' 
    
    //println(a_hit); 
    
    //println(y_hit); 
    
  }

  void display() { // método para desenhar o tiro na tela 
    
    render(); // o aspecto visual do tiro
    
  }
  
  public void render(){ // aspectos visuais do projétil 
    pushMatrix();
    //translate(x_hit, y_hit); // centraliza as coordenadas 
    rotate(0); // ajeita o posicionamento ângular
    stroke(255, 255, 0, 0); // cor do contorno 
    fill(myColor);
    circle(x_hit, y_hit-20, bulletSize); // linha 
    popMatrix();
  
  }
  
  void checkRemove(){ // verifica se o tiro saiu da tela 
    if(x_hit < -100 || x_hit > width+100 || y_hit < 0 || y_hit > height){ // verifica a posição atual do tiro em relação aos limites da tela
      shouldRemove = true; // seta a variável de controle para verdadeiro 
    }
  }
  
  float getHitX(){
    return this.x_hit; 
  }
  float getHitY(){
    return this.y_hit; 
  }
  
  boolean OnCollisionEnter(Enemy enemy){ // verifica colisão tendo como parâmetros x e y (coordenada canto superior esquerdo da img) de 2 objetos e seus s (raio)
    float distanciaMinima = (enemy.getSize()+bulletSize)/2; // armazena a média do tamanho dos dois objetos como 'box collider'
    
    float distancia = dist(enemy.x, enemy.y, x_hit, y_hit); 
    
    // debug
    stroke(255, 0, 0);
    strokeWeight(1);
    noFill(); // sem preenchimento 
    //circle(x1, y1, s1); 
    //circle(x2, y2, s2); 
    
    strokeWeight(.5);
    stroke(255,255,0, 40);
    line(enemy.x, enemy.y, x_hit, y_hit-(bulletSize*2)); // desenha uma linha entre os objetos (debug)
    textSize(18); // define o tamanho do texto 
    fill(255); // define a cor do texto 
    //text(distancia, x2_center - x1_center, y2_center - y1_center); // mostra o texto de debug na posição (tá zoado)
    stroke(255);
    strokeWeight(1);

    if (distancia <= distanciaMinima) { // Verifica se a distância é menor ou igual à distância mínima para considerar uma colisão
        return true; // Colisão detectada
    } else {
        return false; // Não há colisão
    }
  }
  
  
}
