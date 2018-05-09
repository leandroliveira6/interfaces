import processing.serial.*;

class Navetangulo{
  int x, y, largura, altura, vida;
  public Navetangulo(){
    largura = 30;
    altura = 50;
    vida = 5;
  }
  
  public void draw(int x, int y){
    this.x = x;
    this.y = y;
    
    fill(100);  // Set fill to gray
    rect(x, y, largura, altura);
  }
  
  public int[] obterPosicao(){
    return new int[]{x, y};
  }
  
  public int[] obterDimensoes(){
    return new int[]{largura, altura};
  }
  
  public void decrementarVida(){
    vida--;
  }
  
  public int obterVida(){
    return vida;
  }
}

class Bolha{
  int x, y;
  int tamanho = 20;
  public Bolha(int x, int y){
    this.x = x;
    this.y = y;
  }
  public void draw(){
    ellipse(x, y, tamanho, tamanho);
    y-=10;
  }
  
  public boolean saiuDaTela(){
    if(y<-10){
      return true;
    }
    return false;
  }
  
  public boolean tratarColisao(){
    for(int i = meteoros.size()-1; i>=0; i--){
      int[] posicaoMeteoro = meteoros.get(i).obterPosicao();
      if(posicaoMeteoro[0] > x-precisao && posicaoMeteoro[0] < x+precisao && posicaoMeteoro[1] > y-precisao && posicaoMeteoro[1] < y+precisao){
        meteoros.remove(i);
        acertos++;
        return true;
      }      
    }    
    return false;
  }
}

class Meteoro{
  int x, y;
  int tamanho = 10;
  public Meteoro(){
    this.x = (int)random(0, width);
    this.y = 0;
  }
  public void draw(){
    ellipse(x, y, tamanho, tamanho);
    y+=5;
  }
  
  public boolean saiuDaTela(){
    if(y>(height+10)){
      return true;
    }
    return false;
  }
  
  public int[] obterPosicao(){
    return new int[]{x, y};
  }
  
  public boolean tratarColisao(){
    int[] posicaoNavetangulo = navetangulo.obterPosicao();
    int[] dimensoesNavetangulo = navetangulo.obterDimensoes();
    if(x+tamanho > posicaoNavetangulo[0] && x-tamanho < posicaoNavetangulo[0]+dimensoesNavetangulo[0] && y+tamanho > posicaoNavetangulo[1] && y-tamanho < posicaoNavetangulo[1]+dimensoesNavetangulo[1]){
        navetangulo.decrementarVida();
        return true;
      }
      return false;
  }
}

float[] cores;
int horizontalLocation, verticalLocation;
int precisao, vidaMundo;
int proximoAumentoDeDificuldade, intervaloEntreMeteoros, ultimoMeteoro, tempoDecorrido;
int ultimoDisparo, intervaloDisparos, acertos;
boolean gameOver;
ArrayList<Bolha> bolhas;
ArrayList<Meteoro> meteoros;
Navetangulo navetangulo;
Serial conexao = null;

void setup() {
  size(800, 600);
  rectMode(CENTER);
  navetangulo = new Navetangulo();
  horizontalLocation = width/2;
  verticalLocation = height-20;
  precisao = 20;
  vidaMundo = 10;
  proximoAumentoDeDificuldade = 10;
  tempoDecorrido = 0;
  intervaloEntreMeteoros = 5000;
  ultimoMeteoro = 0;
  ultimoDisparo = 0;
  acertos = 0;
  intervaloDisparos = 50;
  gameOver = false;
  cores = new float[]{0, 0, 0};
  bolhas = new ArrayList();
  meteoros = new ArrayList();

  // Criação de uma conexao com a porta serial do arduino
  if(conexao==null){
    conexao = new Serial(this, Serial.list()[0], 9600);
    conexao.bufferUntil('\n');
  }
}

void drawInformacoes(){
  fill(0, 102, 153);
  textSize(32);
  if(gameOver){  
    textAlign(CENTER);
    if(vidaMundo==0){
      text("Que pena, o mundo acabou :(", width/2, 30);
    }
    else{
      text("Que pena, sua nave foi destruída :(", width/2, height/2);
    }
    text("Pressione enter para recomeçar...", width/2, height/2+40);
    if(keyPressed && keyCode == SHIFT){
      setup();
    }
  }
  else{
    textAlign(LEFT);
    text("Tempo decorrido: "+tempoDecorrido+"s", 10, 30);
    text("Acertos: "+acertos, 10, 60);
    textAlign(RIGHT);
    text("Vida mundo: "+vidaMundo, width, 30);
    text("Vida nave: "+navetangulo.obterVida(), width-10, 60);
  }
}

void draw() {
  if(vidaMundo>0 && navetangulo.obterVida()>0){
    if(keyPressed){
      horizontalLocation = mouseX;
      verticalLocation = mouseY;
    }
    background(cores[0], cores[1], cores[2]);
    navetangulo.draw(horizontalLocation, verticalLocation);
    for(int i=bolhas.size()-1; i>=0; i--){
      Bolha bolha = bolhas.get(i);
      bolha.draw();
      if(bolha.saiuDaTela() || bolha.tratarColisao()){
        bolhas.remove(i);
      }
    }
    for(int i=meteoros.size()-1; i>=0; i--){
      Meteoro meteoro = meteoros.get(i);
      meteoro.draw();
      if(meteoro.saiuDaTela() || meteoro.tratarColisao()){
        meteoros.remove(i);
        vidaMundo--;
      }
    }
    tempoDecorrido = millis()/1000;
    if(intervaloEntreMeteoros > 500 && tempoDecorrido > proximoAumentoDeDificuldade){
      println("Aumentando dificuldade!");
      proximoAumentoDeDificuldade += 10;
      intervaloEntreMeteoros -= 500;
    }
    if((millis()-ultimoMeteoro)>intervaloEntreMeteoros){
      meteoros.add(new Meteoro());
      ultimoMeteoro=millis();
    }
  }
  else{
    gameOver = true;
  }
  drawInformacoes();
}

void serialEvent(Serial conexao) {
  String mensagem = conexao.readStringUntil('\n'); // Lê o que for printado no arduino até a quebra de linha
  if (mensagem != null) {
    mensagem = trim(mensagem);
    int[] mensagens = int(split(mensagem, ",")); // Separa a mensagem pelas virgulas, criando um vetor com varias mensagens
    if (mensagens.length >= 3) {
      for(int i=0; i<cores.length; i++){
        cores[i] = map(mensagens[i], 0, 1023, 0, 255);
      }
      if(!keyPressed){
        horizontalLocation = (int)map(mensagens[0], 0, 1023, 0, width);
        verticalLocation = (int)map(mensagens[1], 0, 1023, height, 0);
      }
      if(mensagens[2]==0 && (millis()-ultimoDisparo)>intervaloDisparos){
        bolhas.add(new Bolha(horizontalLocation, verticalLocation));
        ultimoDisparo = millis();
      }
    }
  }
}

void mousePressed(){
  bolhas.add(new Bolha(mouseX, mouseY));
}
