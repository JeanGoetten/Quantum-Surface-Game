import ddf.minim.*; 

Ship ship_zero; // cria uma variável do tipo Ship
ArrayList<Enemy> enemies; // cria uma lista do tipo Enemy 
ArrayList<ParticleSystem> ps = new ArrayList<>(); 

boolean left, right, up, down, shoot; // cria variáveis booleanas para receber os valores de verdadeiro e falso ao manter a tecla correspondente pressionada 

int activeEnemies; 

int score, lastScore; 

int level; 

float shootCadence, shootSpeed, bulletSize; 

boolean reborn, start;

Minim minim; 
Minim minim2; 
Minim minim3; 
Minim minim4; 

AudioPlayer sfx_start; 
AudioPlayer sfx_end; 
AudioPlayer sfx_explosion; 
AudioPlayer sfx_shoot; 

AudioPlayer musicTheme; 

void setup() {
  size(700, 700); // o bom e velho tamanho da tela 
  
  ship_zero = new Ship(); // instancia um novo objeto do tipo Ship - cria uma nova instância da classe Ship e a atribui como valor na variável do mesmo tipo
  ship_zero.setSpeed(2); // chama o metódo de atribuição de valor de velocidade através do método setSpeed e passa um valor como parâmetro 
  
  shootCadence = 200; 
  shootSpeed = 2; 
  bulletSize = 10; 
  ship_zero.setShootCadence(shootCadence); // chama o metódo de atribuição de valor de velocidade através do método setShootCadence e passa um valor como parâmetro e definir a velocidade do tiro
  ship_zero.setShootSpeed(shootSpeed); // seta a velocidade inicial do tiro 
  ship_zero.setBulletSize(bulletSize); // seta o tamanho inicial do projétil 
  
  enemies = new ArrayList<>(); // cria uma lista de inimigos
  
  left = false; // inicializa a variável verificadora de botão pressionado
  right = false; // inicializa a variável verificadora de botão pressionado
  up = false; // inicializa a variável verificadora de botão pressionado
  down = false; // inicializa a variável verificadora de botão pressionado
  
  shoot = false; 
  
  activeEnemies = 4;  
  
  score = 0; 
  lastScore = 1; 
  
  level = 1; 
  
  max_distance = dist(0, 0, width, height);
  
  start = false; 
  
  // SOUND
  minim = new Minim(this); 
  minim2 = new Minim(this); 
  minim3 = new Minim(this); 
  minim4 = new Minim(this); 
  
  sfx_start = minim2.loadFile("start.wav"); 
  sfx_end = minim3.loadFile("end.wav"); 
  sfx_explosion = minim4.loadFile("start_02.wav"); 
  sfx_shoot = minim.loadFile("reload_02.wav"); 
  
  musicTheme = minim.loadFile("theme.mp3");
  musicTheme.rewind(); 
  musicTheme.loop(); 
  musicTheme.play(); 
}

void draw() {
  background(10); // redefine a cor de fundo
  
  if(start){
    // PLAYER SHIP
    ship_zero.update(); // chama o método update da classe Ship para o objeto particular - atualiza a movimentação do objeto 
    ship_zero.display(); // chama o método display da classe Ship para o objeto particular - atualiza a aparência do objeto
    //ship_zero.setBulletSize(10); // chama o método setBulletSize da classe Ship para o objeto particular - atualiza o tamanho do projétil
    
    // ENEMIES
    spawnEnemies(); // adiciona ao jogo novos inimigos 
    
    // COLISÕES 
    checkCollision(); // verifica se o player colidiu com um inimigo 
    checkTargetHit(); // verifica se o player acertou tiro num inimigo 
    
    // Progressão
    leveling(); 
    
    // BG 
    BGWave(); 
    
    // Elementos de interface do usuário
    HUD(); 
    
  }else{
    mainMenu(); 
  }
    
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
      case 10: // Enter
        start = true; 
        sfx_start.rewind();
        sfx_start.play();
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
      case 8: // Backspace
        start = false; 
        break; 
    }
}
void mousePressed() {
  if (mouseButton == LEFT) {
    shoot = true; 
  } else if (mouseButton == RIGHT) {
    //println("Shield"); 
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
    //println(distancia); 
    
    // debug
    stroke(255, 0, 0);
    strokeWeight(1);
    noFill(); // sem preenchimento 
    //circle(x1, y1, s1); 
    //circle(x2, y2, s2); 
    
    strokeWeight(.5);
    stroke(255, 0, 0, 80); 
    line(x1, y1, x2, y2); // desenha uma linha entre os objetos (debug)
    textSize(18); // define o tamanho do texto 
    fill(255); // define a cor do texto 
    //text(distancia, x2 - x1, y2 - y1); // mostra o texto de debug na posição (tá zoado)
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

void checkCollision(){ // verifica a colisão do player com os inimigos 
  if(enemies.size() > 0){ // acessa apenas quando há inimigos 
    for(Enemy enemy : enemies){ // corre a lista de inimigos 
      if(OnCollisionEnter(ship_zero.x, ship_zero.y, enemy.x, enemy.y, 25, 25)){ // verifica a colisão com o inimigo
        
        sfx_end.rewind();
        sfx_end.play();
        
        start = false; 
        reset(); 
      }
    }
  }
}

void checkTargetHit(){ // verifica se o tiro acertou o inimigo 
  for(int i = ship_zero.shoots.size() -1; i > 0; i--){ // corre a lista de tiros 
    for(int j = enemies.size() -1; j >= 0; j--){ // corre a lista de inimigos
      if(ship_zero.shoots.get(i).OnCollisionEnter(enemies.get(j))){ // verifica a colisão do inimigo com o tiro
        
        ps.add(new ParticleSystem(new PVector(ship_zero.shoots.get(i).getHitX(), ship_zero.shoots.get(i).getHitY()), enemies.get(j).myColor));
        
        sfx_explosion.rewind();
        sfx_explosion.play();
        
        ship_zero.shoots.get(i).shouldRemove = true; 
        enemies.remove(j); 
        score++; 
      }
    }
  }
  for(int z = ps.size() - 1; z > 0; z--){
    ps.get(z).addParticle();
    ps.get(z).run();
            
    if(ps.get(z).particleIsDeadCounter > ps.get(z).particleMax){
      ps.remove(z); 
    }
  }
}

void HUD(){
  textSize(42);
  stroke(255);
  fill(255); 
  //text(score, 25, 50);
  //text(level, width-50, 50);
}

void leveling(){
  if((score > lastScore * 1.5) && level < 10){
    level++; 
    lastScore = score; 
    activeEnemies++; 
    ship_zero.shieldEllipseSizeX = level + 15; 
    ship_zero.shieldEllipseSizeY = level + 15; 
    if(level < 10){
      shootSpeed = shootSpeed * 2;
      shootCadence = shootCadence/3; 
      bulletSize -= 1; 
    }
    if(level > 7 && level < 10){
      bulletSize += 5; 
    }
  }else if((score > lastScore * 1.5) && level >= 10){
    // reboot 
    level = 1; 
    lastScore = score; 
    activeEnemies++; 
    shootSpeed = 8;
    shootCadence = 50; 
  }
  ship_zero.setShootSpeed(shootSpeed); 
  ship_zero.setShootCadence(shootCadence); 
  ship_zero.setBulletSize(bulletSize*(level)); 
}

float max_distance;

void BGWave(){
  println(max_distance); 
  for(int i = 0; i <= width; i += 20) {
    for(int j = 0; j <= height; j += 20) {
      float size = dist(mouseX, mouseY, i, j);
      size = size/max_distance * 72;
      noStroke(); 
      fill(11, 11, 11, 150);
      ellipse(i, j, size, size);
    }
  }
}

void mainMenu(){
    BGMainMenu();
    
    fill(0, 408, 612, 204);
    textSize(36);
    text("Press Enter...", 470, 670); 
    
    fill(0, 408, 612, 204);
    textSize(18);
    text("Controles: ", 20, 500); 
    textSize(16);
    text("WASD", 20, 550); 
    text("Mouse Left Click", 20, 570); 
    
    fill(0, 408, 612, 204);
    textSize(18);
    text("Jean Goetten", 20, 650); 
    text("Recursos Matemáticos - PUCPR", 20, 670); 
    
    stroke(255);
    fill(0, 408, 612, 204);
    textSize(78);
    text("Quantum", 300, 300); 
    text("Surface", 400, 400); 
}

void reset(){
  ship_zero = new Ship(); // instancia um novo objeto do tipo Ship - cria uma nova instância da classe Ship e a atribui como valor na variável do mesmo tipo
  ship_zero.setSpeed(2); // chama o metódo de atribuição de valor de velocidade através do método setSpeed e passa um valor como parâmetro 
  
  shootCadence = 200; 
  shootSpeed = 2; 
  bulletSize = 10; 
  ship_zero.setShootCadence(shootCadence); // chama o metódo de atribuição de valor de velocidade através do método setShootCadence e passa um valor como parâmetro e definir a velocidade do tiro
  ship_zero.setShootSpeed(shootSpeed); // seta a velocidade inicial do tiro 
  ship_zero.setBulletSize(bulletSize); // seta o tamanho inicial do projétil 
  
  enemies = new ArrayList<>(); // cria uma lista de inimigos
  
  left = false; // inicializa a variável verificadora de botão pressionado
  right = false; // inicializa a variável verificadora de botão pressionado
  up = false; // inicializa a variável verificadora de botão pressionado
  down = false; // inicializa a variável verificadora de botão pressionado
  
  shoot = false; 
  
  activeEnemies = 4;  
  
  score = 0; 
  lastScore = 1; 
  
  level = 1; 
  
  max_distance = dist(0, 0, width, height);
  
  start = false; 
}

void BGMainMenu(){
  int gridSize = 40;

  for (int x = gridSize; x <= width - gridSize; x += gridSize) {
    for (int y = gridSize; y <= height - gridSize; y += gridSize) {
      noStroke();
      fill(150, 150, 5*((mouseY/25)+(mouseX/25)), 3);
      rect(x-1, y-1, 3, 1);
      stroke(100, 100, 255, 5);
      line(x, y, width/2, height/2);
    }
  }
  for (int x = gridSize; x <= width - gridSize; x += gridSize) {
    for (int y = gridSize; y <= height - gridSize; y += gridSize) {
      noStroke();
      fill(150, 150, 5*((mouseY/25)+(mouseX/25)), 5);
      rect(x-1, y-1, 3, 1);
      stroke(100, 255, 100, 10);
      line(x, y, width/3, height/3);
    }
  }
  for (int x = gridSize; x <= width - gridSize; x += gridSize) {
    for (int y = gridSize; y <= height - gridSize; y += gridSize) {
      noStroke();
      fill(150, 150, 5*((mouseY/25)+(mouseX/25)), 7);
      rect(x-1, y-1, 3, 1);
      stroke(255, 100, 100, 15);
      line(x, y, width/5, height/5);
    }
  }
  for (int i = 0; i < 200; i += 40) {
    bezier(mouseX-(i/2.0), 40+i, 410, 20, 440, 300, 240-(i/16.0), 300+(i/8.0));
  }
}
