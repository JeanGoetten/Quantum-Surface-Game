class Shoot{
  
  float x_hit, y_hit, speed_hit, bulletSize; 
  
  boolean shouldRemove; // controle da remoção do tiro 
  
  Shoot(float x, float y, float speed, float bulletSize){ // método constr7utor 
    this.x_hit = x; 
    this.y_hit = y; 
    this.speed_hit = speed; 
    this.bulletSize = bulletSize; 
  }
  
  public void update(){
    //a_hit = atan2(y_hit, x_hit); // retorna o ângulo em radianos -pi a pi
    y_hit -= speed_hit;
    
    //println(a_hit);
    
    shouldRemove = false; //seta a variável de controle para falso 
    
    
  }

  void display() { // método para desenhar o tiro na tela 
    
    render(); // o aspecto visual do tiro
    
  }
  
  public void render(){
    pushMatrix();
    //translate(x_hit, y_hit); // centraliza as coordenadas 
    rotate(0); // ajeita o posicionamento ângular
    stroke(255); // cor do contorno 
    noFill(); // sem preenchimento 
    circle(x_hit, y_hit-20, bulletSize); // linha 
    popMatrix();
  
  }
  
  void checkRemove(){ // verifica se o tiro saiu da tela 
    if(x_hit < 0 || x_hit > width || y_hit < 0 || y_hit > height){ // verifica a posição atual do tiro em relação aos limites da tela
      shouldRemove = true; // seta a variável de controle para verdadeiro 
    }
  }
  
  float getHitX(){
    return this.x_hit; 
  }
  float getHitY(){
    return this.y_hit; 
  }

}
