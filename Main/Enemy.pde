class Enemy{
  float x, y, w, h, vx, vy, a, size; 
  float speed; 
  
  boolean shouldRemove; 
  
  Enemy(){ // construtor 
    x = random(width); 
    //y = random(height - 200) + 100; 
    
    vx = 0; 
    vy = 0; 
    speed = 1.1; 
    size = 25; 
    
    shouldRemove = false; 
  }
  
  void update(){ // atualiza o movimento da nave 
    y += speed; // reta vertical 
    
    if(y > height){
      x = random(width); 
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
    stroke(255, 0, 0);
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
