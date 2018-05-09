// Váriaveis globais
int grossura;
int altura1, comprimento1;
int altura2, comprimento2;
int altura3, comprimento3;
int altura4, comprimento4;
boolean crescer1, crescer2, crescer3, crescer4;

// Função de inicialização
void setup(){
  size(800,600);
  background(#39B7D8);
  grossura=6;
  altura1=400; comprimento1=200;
  altura2=50; comprimento2=20;
  altura3=550; comprimento3=20;
  altura4=300; comprimento4=200;
  crescer1=true; crescer2=false; crescer3=true; crescer4=false;
  strokeWeight(grossura);
}

// Função de repetição
void draw(){
  background(mouseX, mouseY, mouseButton*10);
  
  // Animação do retângulo
  fill(#3522E3);
  rect(400, 50, comprimento1, altura1);
  if(crescer1==true){
    comprimento1--;
    altura1++;
  } 
  else{
    comprimento1++;
    altura1--;
  }
  if(altura1>500){
    crescer1=false;
  }
  if(altura1<100){
    crescer1=true;
  }
  
  // Animação da elipse
  fill(#BDE024);
  ellipse(200, 200, comprimento2, altura2);
  if(crescer2==true){
    comprimento2-=3;
    altura2++;
  }
  else{
    comprimento2+=3;
    altura2--;
  }
  if(altura2>300){
    crescer2=false;
  }
  if(altura2<40){
    print("tuntz(8) ");
    crescer2=true;
  }
  
  // Animação de outro retangulo
  fill(#E05A24);
  rect(100, 300, comprimento3, altura3);
  if(crescer3==true){
    comprimento3--;
    altura3+=10;
  }
  else{
    comprimento3++;
    altura3-=10;
  }
  if(altura3>300){
    crescer3=false;
  }
  if(altura3<40){
    crescer3=true;
  }
  
  // Animação de outra elipse
  fill(#3CE024);
  ellipse(600,500, comprimento4, altura4);
  if(crescer4==true){
    comprimento4+=10;
    altura4--;
  } 
  else{
    comprimento4-=10;
    altura4++;
  }
  if(comprimento4>550){
    crescer4=false;
  }
  if(comprimento4<50){
    crescer4=true;
  }
  
  if(mouseButton==LEFT){
    print("tuntz(8) ");
  }
  if(mouseButton==RIGHT){
    print("tchitchitchi(8) ");
  }
  if(mouseButton==LEFT){
    print("tuntz(8) ");
  }
  if(mouseButton==CENTER){
    print("BIIIIIIRRRRRRLLLLLLLLLLL(8) ");
  }
}
