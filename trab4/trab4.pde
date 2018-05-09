class Bola{
  float x, y;
  float velocidade_x, velocidade_y;
  float velocidade, angulo, alpha;
  int diametro;
  boolean colidiu;
  
  // Inicia a bola e suas variaveis
  public Bola(){
    x = width/2; // Cooedenada X no centro da horizontal
    y = height/2; // Coordenada Y no centro da vertical
    diametro = 20; // Diametro da bola
    alpha = 255; // Opacidade completa
    colidiu = false; // Informa externamente que o jogo terminou
    
    // Gera um ângulo aceitável para a partida, repetindo até conseguir
    float angulo_limite = degrees(atan(float(height)/float(width)));
    angulo = random(360);
    while((angulo>angulo_limite && angulo<(180-angulo_limite)) || (angulo>(180+angulo_limite) && angulo<(360-angulo_limite)) || angulo<15 || angulo>345 || (angulo>165 && angulo<195)){
      angulo = random(360);
    }
        
    // Calcula as componentes da velocidade com base no ângulo encontrado
    angulo = radians(angulo);
    velocidade = 5;
    velocidade_x = velocidade*cos(angulo); 
    velocidade_y = velocidade*sin(angulo);
  }
  
  // Mostra a bola
  void mostrar(){
    fill(255, 255, 255, alpha);
    ellipse(x, y, diametro, diametro);
  }
  
  // Reflete a bola pra onde ela deve ir
  void recalcular_tragetoria(){
    if(y>height || y<0){
      velocidade_y = -velocidade_y;
    }
    else if(x<0){
      velocidade_x = -velocidade_x;
    }
  }
  
  // Rebate a bola e aumenta a dificuldade, aumentando a velocidade e diminuindo a raquete
  void rebater_bola(){
    if(placar.dificuldade < 8){
      velocidade_x = -1.5*velocidade_x;
      placar.dificuldade_aumentou();
      raquete.altura -= 10;
    }
    else{
      velocidade_x = -velocidade_x;
    }
  }
  
  // Verifica se a bola bateu na parede direita
  void verifica_colisao(){
    if(x>width){
        // Fim de jogo
        colidiu = true;
        
        // Mantem a bola no mesmo lugar
        x-=velocidade_x; y-=velocidade_y;
        
        // Efeito de explosão
        diametro++;
        alpha-=2.5;
      }
  }
  
  // Move a bola enquanto a bola for visivel
  void mover(){
    if(alpha>0){
      x+=velocidade_x; y+=velocidade_y;
      recalcular_tragetoria();
      verifica_colisao();
    }
  }
  
  // Define um fim para o jogo
  boolean houve_colisao(){
    return colidiu;
  }
}

class Raquete{
  float x, y;
  int altura, espessura;
  
  // Inicia a raquete e suas variaveis
  public Raquete(){
    x = width-20;
    y = height/2-20;
    altura = 120;
    espessura = 5;
  }
  
  // Mostra a raquete
  void mostrar(){
    fill(255, 255, 255);
    rect(x, y, espessura, altura);
  }
  
  // Move a raquete pelo eixo y
  void mover(int passos){
    y+=passos;
  }
  
  // Rebate a bola quando a mesma entra em contato com a raquete
  void verifica_colisao(Bola bola){
    if((bola.x+bola.diametro/2) >= x && bola.y >= y && bola.y <= (y+altura)){
      bola.rebater_bola();
    }
  }
}

class Placar{
  int tempo_inicial, tempo_decorrido, maior_tempo, dificuldade;
  boolean rolando;
  
  // Inicia placar e suas variaveis
  public Placar(){
    tempo_inicial = 0;
    tempo_decorrido = 0;
    maior_tempo = 0;
    dificuldade = 1;
    rolando = true;
  }
  
  // Inicia ou reinicia placar corrente, mantendo o record
  void iniciar_tempo(){
    tempo_inicial = millis();
    rolando=true;
    dificuldade=1;
  }
  
  // Mostra o placar ou a mensagem de fim de jogo
  void mostrar(){
    if(rolando){
      textAlign(LEFT);
      tempo_decorrido = millis()-tempo_inicial;
      textSize(16);
      text("Tempo decorrido: " + tempo_decorrido/1000 + "." + tempo_decorrido%1000 + "s", 100, 100);
      text("Maior tempo: " + maior_tempo/1000 + "." + maior_tempo%1000 + "s", 100, 120);
      text("Dificuldade: " + dificuldade, 100, 140);
    }
    else{
      textAlign(CENTER);
      fill(255);
      textSize(48);
      if(tempo_decorrido == maior_tempo){
        text("RECORD!", (width/2), -60+height/2);
      }
      text("Tempo decorrido: " + tempo_decorrido/1000 + "." + tempo_decorrido%1000 + "s", (width/2), height/2);
      textSize(16);
      text("Aperte um botão do mouse para voltar a jogar", (width/2), 40+height/2);
    }
  }
  
  // Para o tempo quando há uma colisão
  void parar_tempo(){
    rolando = false;
    if(tempo_decorrido>maior_tempo){
      maior_tempo = tempo_decorrido;
    }
  }
  
  // Incrementa a dificuldade em 1
  void dificuldade_aumentou(){
    dificuldade++;
  }
}

Bola bola;
Raquete raquete;
Placar placar;

void setup(){
  size(1200,600);
  background(0);
  bola = new Bola();
  raquete = new Raquete();
  placar = new Placar();
  placar.iniciar_tempo();
}

void draw(){
  background(0);
  bola.mover();
  bola.mostrar();
  placar.mostrar();
  if(bola.houve_colisao()){
    placar.parar_tempo();
  }
  else{
    raquete.mostrar();
    raquete.verifica_colisao(bola);
  }
}

void keyPressed(){
  if(keyCode == UP && raquete.y > 0){
    raquete.mover(-20);
  }
  else if(keyCode == DOWN && (raquete.y+raquete.altura)<height){
    raquete.mover(20);
  }
}

void mousePressed(){
  bola = new Bola();
  raquete = new Raquete();
  placar.iniciar_tempo();
}
