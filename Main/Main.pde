Ship ship_zero; // cria uma variável do tipo Ship
ArrayList<Enemy> enemies; // cria uma lista do tipo Enemy
boolean left, right, up, down, shoot; // cria variáveis booleanas para receber os valores de verdadeiro e falso ao manter a tecla correspondente pressionada 

int activeEnemies; 

float score; 

void setup() {
  size(700, 700); // o bom e velho tamanho da tela 
  
  ship_zero = new Ship(); // instancia um novo objeto do tipo Ship - cria uma nova instância da classe Ship e a atribui como valor na variável do mesmo tipo
  ship_zero.setSpeed(2); // chama o metódo de atribuição de valor de velocidade através do método setSpeed e passa um valor como parâmetro 
  ship_zero.setShootCadence(20); // chama o metódo de atribuição de valor de velocidade através do método setSpeed e passa um valor como parâmetro 
  
  enemies = new ArrayList<>(); // cria uma lista de inimigos
  
  left = false; // inicializa a variável verificadora de botão pressionado
  right = false; // inicializa a variável verificadora de botão pressionado
  up = false; // inicializa a variável verificadora de botão pressionado
  down = false; // inicializa a variável verificadora de botão pressionado
  
  shoot = false; 
  
  activeEnemies = 2;  
  
  score = 0; 
}

void draw() {
  background(0); // define a cor de fundo
  //translate(width/2, height/2); 
  
  // PLAYER SHIP
  ship_zero.update(); // chama o método update da classe Ship para o objeto particular - atualiza a movimentação do objeto 
  ship_zero.display(); // chama o método display da classe Ship para o objeto particular - atualiza a aparência do objeto
  ship_zero.setBulletSize(10); // chama o método setBulletSize da classe Ship para o objeto particular - atualiza o tamanho do projétil
  
  // ENEMIES
  spawnEnemies(); // adiciona ao jogo novos inimigos 
  
  // COLISÕES 
  checkCollision(); // verifica se o player colidiu com um inimigo 
  checkTargetHit(); // verifica se o player acertou tiro num inimigo 

}

void keyPressed() { // códigos do teclado (println(keycode);) - shift = 16 space = 32 left = 37 up = 38 right = 39 down = 40 
    switch(keyCode){
      case 87: // W
        up = true; 
        break; 
      case 65: // A
        left = true; 
        break; 
      case 83: // S
        down = true; 
        break;
      case 68: // D
        right = true; 
        break; 
    }
}

void keyReleased() {
    switch(keyCode){
      case 87: // W
        up = false; 
        break; 
      case 65: // A
        left = false; 
        break; 
      case 83: // S
        down = false; 
        break;
      case 68: // D
        right = false; 
        break; 
    }
}
void mousePressed() {
  if (mouseButton == LEFT) {
    shoot = true; 
  } else if (mouseButton == RIGHT) {
    println("Shield"); 
  } 
}

void mouseReleased(){
  if (mouseButton == LEFT) {
    shoot = false; 
  }
}

boolean OnCollisionEnter(float x1, float y1, float x2, float y2, float s1, float s2){ // verifica colisão tendo como parâmetros x e y (coordenada canto superior esquerdo da img) de 2 objetos e seus s (raio)
    float distanciaMinima = (s1+s2)/2; // armazena a média do tamanho dos dois objetos como 'box collider'
    
    float distancia = dist(x1, y1, x2, y2); 
    
    // debug
    stroke(255, 0, 0);
    strokeWeight(1);
    noFill(); // sem preenchimento 
    circle(x1, y1, s1); 
    circle(x2, y2, s2); 
    
    strokeWeight(.5);
    line(x1, y1, x2, y2); // desenha uma linha entre os objetos (debug)
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

void spawnEnemies(){
  if(enemies.size() < activeEnemies){
    enemies.add(new Enemy()); // adiciona um inimigo à lista
  }
  for(int i = 0; i < enemies.size(); i++){
    enemies.get(i).update(); // chama o método update da classe Ship para o objeto particular na posição - atualiza a movimentação do objeto 
    enemies.get(i).display(); // chama o método display da classe Ship para o objeto particular na posição - atualiza a aparência do objeto
  }
}

void checkCollision(){
  if(enemies.size() > 0){ // acessa apenas quando há inimigos 
    for(Enemy enemy : enemies){ // corre a lista de inimigos 
      if(OnCollisionEnter(ship_zero.x, ship_zero.y, enemy.x, enemy.y, 25, 25)){ // verifica a colisão com o inimigo
        println("Colidiu!");
      }
    }
  }
}

void checkTargetHit(){
  if(ship_zero.shoots.size() > 0){ // acessa apenas quando há tiros
    for(int i = ship_zero.shoots.size() - 1; i >= 0; i--){ // corre a lista de tiros 
      for(int j = enemies.size() - 1; j >= 0; j--){ // corre a lista de inimigos através do índice 
        if(OnCollisionEnter(enemies.get(j).x, enemies.get(j).y, ship_zero.shoots.get(i).getHitX(), ship_zero.shoots.get(i).getHitY(), 25, 10)){ // verifica a colisão do inimigo com o tiro
          enemies.remove(j); // remove o inimigo da lista na posição do ínmdice 
          //println("Hittou! " + i);
          ship_zero.shoots.remove(i); // remove o tiro da lista na posição do índice
          score++; // incrementa o score
        }
      }
    }
  }
  println("Inimigos: " + enemies.size()); 
  println("Tiros: " + ship_zero.shoots.size()); 
}
