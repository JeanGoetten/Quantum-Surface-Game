class Ship {
  float x, y, a;
  float speedX, speedY, maxSpeed, shootCadence, timeToShoot, bulletSize; 
  
  float delta; // armazena a diferença de tempo entre dois momentos 
  float lastTime; // armazena o tempo de um determinado evento (cool down de pulo)
  float tempoNaoJogado; // armazena o tempo não jogado para subtrair do score
  
  ArrayList<Shoot> shoots =  new ArrayList<>(); 
  
  Ship() { // construtor 
    x = width/2; // posição horizontal inicial 
    y = height - 100; // posição vertical inicial 
    
    maxSpeed = 5; // velocidade máxima da nave: altere para mudar a velocidade 
    speedX = 0; // inicializa parado na horizontal - será incrementado quando o jogador apertar a tecla correspondente
    speedY = 0; // inicializa parado na vertical - será incrementado quando o jogador apertar a tecla correspondente
    
    this.shootCadence = 10; 
    timeToShoot = 0; 
    
    delta = 0; // inicia o delta tempo
    lastTime = 0; // inicializa o registro de tempo do evento pulo
    tempoNaoJogado = 0; 
    
    bulletSize = 10; 
  }
  void display() { // método para desenhar a nave na tela 
    //a = atan2(mouseY - y, mouseX - x); // retorna o ângulo em radianos -pi a pi
    render(); // o aspecto visual da nave
    
  }
  
  void render() { // aparência da nave
    pushMatrix();
    translate(x, y); // centraliza as coordenadas 
    //rotate(a+90); // ajeita o posicionamento ângular
    stroke(255); // cor do contorno 
    noFill(); // sem preenchimento 
    line(0, -10, 10, 10); // linha 
    line(10, 10, 0, 5); // linha 
    line(0, 5, -10, 10); // linha 
    line(-10, 10, 0, -10); // linha 
    popMatrix();
  }
  
  void update(){ // atualiza o movimento da nave 
    // horizontal 
    if(left){ 
      // speedY = 0; // descomente para movimento em linha
      speedX = -maxSpeed; // incrementa o movimento horizontal para a esquerda - reta 
    }
    if(right){
      // speedY = 0; // descomente para movimento em linha
      speedX = maxSpeed; // incrementa o movimento horizontal para a direita - reta
    }
    if((!left && !right) || (left && right)){ // define a nave como parada 
      speedX = 0; 
    }
    
    // vertical 
    if(up){ 
      // speedX = 0; // movimento em linha
      speedY = -maxSpeed; 
    }
    if(down){
      // speedX = 0; // movimento em linha
      speedY = maxSpeed; 
    }
    if((!up && !down) || (up && down)){
      speedY = 0; 
    }
    
    checkBounds(); // verifica se a nave ultrapassou os limites da tela
    
    x += speedX; // atualiza a posição horizontal - // reta horizontal  
    y += speedY; // atualiza a posição vertical  - // reta vertical 
    
    // tiro 
    delta = (millis() - lastTime)/1000; // captura a difença de tempo
    //println(timeToShoot); 
    if(timeToShoot >= shootCadence){ // verifica se a diferença de tempo é maior que o cool down do tiro
      if(shoot){
        shoot(); 
        timeToShoot = 0; 
        lastTime = millis(); 
      }
    }else{
      timeToShoot += delta; 
    }   
    if(shoots.size() > 0){
        for(Shoot hShoot : shoots){
          hShoot.update(); 
          hShoot.display(); 
          hShoot.checkRemove(); 
        }
        for(int i = shoots.size() - 1; i >= 0; i--){
          Shoot hShoot = shoots.get(i); 
          
          if(hShoot.shouldRemove == true){
            shoots.remove(hShoot); 
          } 
        }
      }
  }
  
  void checkBounds(){
    if(x > width){ x = 0;} // se passar do limite direito da tela, transporta para a esquerda 
    if(x < 0){ x = width;} // se passar do limite esquerdo da tela, transporta para a direita 
    if(y > height){ y = 0;} // se passar do limite inferior da tela, transporta para o inferior 
    if(y < 0){ y = height;} // se passar do limite superior da tela, transporta para o superior  
  }
  
  void shoot(){
    //float shootX = x; 
    float shootY = y; 
    //float shootA = a; 
    shoots.add(new Shoot(x, shootY, 10, 10)); 
    //println(shoots.size()); 
  }
  
  void setSpeed(float value){ // atribui o valor de retorno à velocidade 
    this.maxSpeed = value; 
  }
  
  void setShootCadence(float value){ // atribui o valor de retorno à velocidade 
    this.shootCadence = value; 
  }
  
  void setBulletSize(float value){ // atribui o valor de retorno à velocidade 
    this.bulletSize = value; 
  }
}
