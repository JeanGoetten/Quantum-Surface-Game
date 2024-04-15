import ddf.minim.*; // importa a referida biblioteca de audio

Ship ship_zero; // cria uma variável do tipo Ship
ArrayList<Enemy> enemies; // cria uma lista do tipo Enemy 
ArrayList<ParticleSystem> ps = new ArrayList<>(); // cria uma lista do tipo ParticleSystem 

boolean left, right, up, down, shoot; // cria variáveis booleanas para receber os valores de verdadeiro e falso ao manter a tecla correspondente pressionada 

int activeEnemies; // registra o número de inimigos ativos 

int score, lastScore; // registra a pontuação do jogador 

int level; // registra o nível durante o gameplay 

float shootCadence, shootSpeed, bulletSize; // registra características do projétil - cadência, velocidade e tamanho 

boolean start; // registra se o jogo está em execução ou na tela de menu inicial 

Minim minim; // cria uma variável do tipo específico da biblioteca de audio 
Minim minim2; 
Minim minim3; 
Minim minim4; 

AudioPlayer sfx_start; // cria um tipo AudioPlayer da biblioteca de audio
AudioPlayer sfx_end; 
AudioPlayer sfx_explosion; 
AudioPlayer sfx_shoot; 

AudioPlayer musicTheme; 

float max_distance; // distância máxima no deslocamento do mouse para efeito 'fog' na tela de jogo

void setup() { // inicializa as variáveis 
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
  
  shoot = false; // começa o jogo não atirando 
  
  activeEnemies = 4;  // começa o jogo com 4 inimigos ativos - altere para mudar a curva de dificuldade 
  
  score = 0; // inicia com zero pontos 
  lastScore = 1; // começa com 1 para evitar divisão por zero 
  
  level = 1; // começa com 1 para evitar divisão por zero 
  
  max_distance = dist(0, 0, width, height); // distância máxima para o efeito visual 'fog' na tela de jogo
  
  start = false; // começa o jogo na tela de menu inicial 
  
  // SOUND
  minim = new Minim(this); // instancia um novo objeto do tipo da biblioteca de audio 
  minim2 = new Minim(this); 
  minim3 = new Minim(this); 
  minim4 = new Minim(this); 
  
  sfx_start = minim2.loadFile("start.wav"); // atribui o arquivo de audio à variável AudioPlayer da biblioteca de audio 
  sfx_end = minim3.loadFile("end.wav"); 
  sfx_explosion = minim4.loadFile("start_02.wav"); 
  sfx_shoot = minim.loadFile("reload_02.wav"); 
  
  musicTheme = minim.loadFile("theme.mp3");
  
  musicTheme.rewind(); // rebobina o audio específico (necessário para evitar multa)
  musicTheme.loop(); // define o comportamento do audio específico como repetível ao chegar ao fim 
  musicTheme.play(); // inicia a música junto com o programa 
}

void draw() { // main loop 
  background(10); // redefine a cor de fundo a cada frame 
  
  if(start){ // verifica se o jogador clicou a tecla de start 
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
    reset(); // reseta o jogo 
    mainMenu(); // tela inicial 
  }
    
}

void keyPressed() { // códigos do teclado (println(keycode);) - shift = 16 space = 32 left = 37 up = 38 right = 39 down = 40 - registra quando o jogador aperta a tecla 
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
        start = true; // inicia o game 
        sfx_start.rewind(); // rebobina o audio específico 
        sfx_start.play(); // executa o audio específico 
        break; 
    }
}

void keyReleased() { // registra quando o jogador solta a tecla 
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
void mousePressed() { // registra quando o jogador aperta um botão do mouse 
  if (mouseButton == LEFT) {
    shoot = true; // permite o jogador atirar no jogo 
  } else if (mouseButton == RIGHT) {
    //println("Shield"); // não implementado nessa versão do jogo 
  } 
}

void mouseReleased(){ // registra quando o jogador solta um botão do mouse 
  if (mouseButton == LEFT) {
    shoot = false; // proibe atirar 
  }
}

boolean OnCollisionEnter(float x1, float y1, float x2, float y2, float s1, float s2){ // verifica colisão tendo como parâmetros x e y (coordenada canto superior esquerdo da img) de 2 objetos e seus s (raio)
    float distanciaMinima = (s1+s2)/2; // armazena a média do tamanho dos dois objetos como 'box collider'
    
    float distancia = dist(x1, y1, x2, y2); 
    //println(distancia); 
    
    // debug line 
    strokeWeight(.5);
    stroke(255, 0, 0, 80); 
    line(x1, y1, x2, y2); // desenha uma linha entre os objetos (debug) - aspecto estético nessa versão do jogo 
    textSize(18); // define o tamanho do texto 
    fill(255); // define a cor do texto 

    if (distancia <= distanciaMinima) { // Verifica se a distância é menor ou igual à distância mínima para considerar uma colisão
        return true; // Colisão detectada
    } else {
        return false; // Não há colisão
    }
}

void spawnEnemies(){ // adiciona inimigos ao jogo 
  if(enemies.size() < activeEnemies){ // verifica as quantidades 
    enemies.add(new Enemy()); // adiciona um inimigo à lista
  }
  for(int i = 0; i < enemies.size(); i++){ // atualiza a aparência e a dinâmica de cada inimigo na lista 
    enemies.get(i).update(); // chama o método update da classe Ship para o objeto particular na posição - atualiza a movimentação do objeto 
    enemies.get(i).display(); // chama o método display da classe Ship para o objeto particular na posição - atualiza a aparência do objeto
  }
}

void checkCollision(){ // verifica a colisão do player com os inimigos 
  if(enemies.size() > 0){ // acessa apenas quando há inimigos 
    for(Enemy enemy : enemies){ // corre a lista de inimigos 
      if(OnCollisionEnter(ship_zero.x, ship_zero.y, enemy.x, enemy.y, 25, 25)){ // verifica a colisão com o inimigo
        
        sfx_end.rewind(); // rebobina o audio 
        sfx_end.play(); // executa o audio 
        
        start = false; // enceraa o loop de jogo 
      }
    }
  }
}

void checkTargetHit(){ // verifica se o tiro acertou o inimigo 
  for(int i = ship_zero.shoots.size() -1; i > 0; i--){ // corre a lista de tiros 
    for(int j = enemies.size() -1; j >= 0; j--){ // corre a lista de inimigos
      if(ship_zero.shoots.get(i).OnCollisionEnter(enemies.get(j))){ // verifica a colisão do inimigo com o tiro
        
        ps.add(new ParticleSystem(new PVector(enemies.get(j).x, enemies.get(j).y), enemies.get(j).myColor)); // adiciona uma particula na posição e cor do inimigo 
        
        sfx_explosion.rewind(); // rebobina o audio específico 
        sfx_explosion.play(); // executa o sound effect específico 
        
        ship_zero.shoots.get(i).shouldRemove = true; // marca como removível o projétil da lista 
        enemies.remove(j); // remove o inimigo da lista de inimigos instanciados 
        score++; // incrementa o score 
      }
    }
  }
  for(int z = ps.size() - 1; z > 0; z--){ // passa a lista de sistema de partículas instanciados de trás pra frente 
    ps.get(z).addParticle(); // chama a função de adicionar partículas do sistema de partículas 
    ps.get(z).run(); // executa o sistema de partículas da posição na lista 
            
    if(ps.get(z).particleIsDeadCounter > ps.get(z).particleMax){ // verifica se o número de partículas "mortas" é maior que o número de partículas na lista 
      ps.remove(z); // remove o sistema de partículas da posição na lista 
    }
  }
}

void HUD(){ // elementos de head up display 
  textSize(42);
  stroke(255);
  fill(255); 
  //text(score, 25, 50); // texto de score - oculto por motivos estéticos, mas necessário para cálculo de progressão 
  //text(level, width-50, 50); // texto de level - oculto por motivos estéticos, mas necessário para cálculo de progressão  
}

void leveling(){ // calculo de progressão de jogo 
  if((score > lastScore * 1.5) && level < 10){ // verifica se o score é maior que o score do último progresso e o range de level 
    level++; // incrementa o level 
    lastScore = score; // registro o último progresso 
    activeEnemies++; // incrementa a quantidade de inimigos ativos no jogo 
    ship_zero.shieldEllipseSizeX = level + 15; // incremeenta o tamanho do círculo ao entorno da nave do jogador 
    ship_zero.shieldEllipseSizeY = level + 15; // idem 
    if(level < 10){ // verifica o range de level numa subrotina 
      shootSpeed = shootSpeed * 2; // incremento na velocidade do projétil 
      shootCadence = shootCadence/3; // incremento da cadência de tiro 
      bulletSize -= 1; // corrige o tamanho do projétil para o level específico 
    }
    if(level > 7 && level < 10){ // verifica outro range de level 
      bulletSize += 5; // corrige o tamanho do projétil para o level específico 
    }
  }else if((score > lastScore * 1.5) && level >= 10){ // atribui valores específicos para um range de level específico 
    // reboot 
    level = 1; 
    lastScore = score; 
    activeEnemies++; 
    shootSpeed = 8;
    shootCadence = 50; 
  }
  ship_zero.setShootSpeed(shootSpeed); // atualiza as características de tiro 
  ship_zero.setShootCadence(shootCadence); // idem 
  ship_zero.setBulletSize(bulletSize*(level)); // idem 
}

void BGWave(){ // efeito visual estilo 'fog' na tela de jogo 
  //println(max_distance); 
  for(int i = 0; i <= width; i += 20) { // verifica o limite horizontal da tela 
    for(int j = 0; j <= height; j += 20) { // verifica o limite vertical da tela 
      float size = dist(mouseX, mouseY, i, j); // registra a distância em relação as coordenadas do mouse 
      size = size/max_distance * 72; // registra o tamanho e o corrige 
      noStroke(); // sem linhas 
      fill(11, 11, 11, 150); // cor de preenchimento 
      ellipse(i, j, size, size); // desenha cada elipse na posição 
    }
  }
}

void mainMenu(){ // tela de menu 
    BGMainMenu(); // efeito visual no fundo da tela de menu 
    
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

void reset(){ // reinicializa as variáveis de jogo 
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
  
  activeEnemies = 4;  // para melhor coerência, use o mesmo valor do setup 
  
  score = 0; 
  lastScore = 1; 
  
  level = 1; 
  
  max_distance = dist(0, 0, width, height);
  
  start = false; 
}

void BGMainMenu(){ // efeito visual no fundo da tela de menu 
  int gridSize = 40; // tamanho do grid relativo ao efeito visual 

  for (int x = gridSize; x <= width - gridSize; x += gridSize) { // grid 1 
    for (int y = gridSize; y <= height - gridSize; y += gridSize) {
      noStroke();
      fill(150, 150, 5*((mouseY/25)+(mouseX/25)), 3); // altera o valor de B com o deslocamento do mouse - corrige (/25) para o range 0 - 255
      rect(x-1, y-1, 3, 1);
      stroke(100, 100, 255, 5);
      line(x, y, width/2, height/2);
    }
  }
  for (int x = gridSize; x <= width - gridSize; x += gridSize) { // grid 2
    for (int y = gridSize; y <= height - gridSize; y += gridSize) {
      noStroke();
      fill(150, 150, 5*((mouseY/25)+(mouseX/25)), 5); // altera o valor de B com o deslocamento do mouse  - corrige (/25) para o range 0 - 255
      rect(x-1, y-1, 3, 1);
      stroke(100, 255, 100, 10);
      line(x, y, width/3, height/3);
    }
  }
  for (int x = gridSize; x <= width - gridSize; x += gridSize) { // grid 3
    for (int y = gridSize; y <= height - gridSize; y += gridSize) {
      noStroke();
      fill(150, 150, 5*((mouseY/25)+(mouseX/25)), 7); // altera o valor de B com o deslocamento do mouse  - corrige (/25) para o range 0 - 255
      rect(x-1, y-1, 3, 1);
      stroke(255, 100, 100, 15);
      line(x, y, width/5, height/5);
    }
  }
  for (int i = 0; i < 200; i += 40) { // desenha um efeito bezier que muda de cor e movimenta com o deslocamento do cursor do mouse 
    bezier(mouseX-(i/2.0), 40+i, 410, 20, 440, 300, 240-(i/16.0), 300+(i/8.0));
  }
}
