class Enemy{
  float x, y, w, h, vx, vy, a, size, rng_x; 
  float speed; 
  
  boolean shouldRemove; 
  
  color R = color(255, 0, 0, 255);  // Define color red
  color G = color(0, 150, 0, 255);  // Define color green
  color B = color(100, 100, 255, 255);  // Define color blue
  
  color myColor = R; 
  int renderType; 
  
  Enemy(){ // construtor 
    rng_x = random(width); // spawna em local aleatório no eixo horizontal 
    //y = random(height - 200) + 100; 
    
    y = PI; 
    speed = 1.1; 
    size = 25; 
    
    shouldRemove = false; 
    
    renderType = 1; 
    
    float rng = random(100);
    if(rng > 67){ // seleciona a cor com 1/3 de chance 
      renderType = 1; 
    }else if(rng < 33){
     renderType = 2; 
    }else{
      renderType = 3; 
    }
  }
  
  void update(){ // atualiza o movimento da nave 
  
    switch(renderType){
      case 1: 
        myColor = R; 
        x =  (sin(y/4)*(10+level)) + rng_x; // incrementa de forma senoidal o movimento horizontal em relação a x
        y = y + (PI/2); // movimento vertical 
        break; 
      case 2: 
        myColor = G; 
        x =  (sin(y/15)*(25+level)) + rng_x; // incrementa de forma senoidal o movimento horizontal em relação a x
        y = y + (PI/2.5); // movimento vertical 
        break;  
      case 3: 
        myColor = B; 
        x =  (sin(y/40)*(50+level)) + rng_x; // incrementa de forma senoidal o movimento horizontal em relação a x
        y = y + (PI/3); // movimento vertical 
        break;   
      default: 
        myColor = R; 
        y += speed; // desloca na vertical 
        break; 
    }
    
    if(y > height){
      
      y = 0; 
    }
  }
  
  void display(){
    //a = atan2(x, y); // retorna o ângulo em radianos -pi a pi
    render(); // o aspecto visual da nave
    
  }
  
  void render() { // aparência da nave 
    pushMatrix();
    translate(x, y);
    rotate(PI);
    stroke(myColor);
    noFill();
    line(0, -10, 10, 10);
    line(10, 10, 0, 5);
    line(0, 5, -10, 10);
    line(-10, 10, 0, -10);
    popMatrix();
  }
  
  float getSize(){
    return this.size; 
  }
  void setSize(float value){
    this.size = value; 
  }
}
