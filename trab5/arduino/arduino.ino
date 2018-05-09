void setup() {
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, OUTPUT);
  pinMode(A3, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, INPUT);
  pinMode(9, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  int x = analogRead(A1);
  int y = analogRead(A0);
  int x_map = map(x, 0, 1023, 0, 255);
  int y_map = map(y, 0, 1023, 0, 255);
  int s = digitalRead(8);
  analogWrite(A2, x_map);
  analogWrite(A3, y_map);
  
  if(s==0){
    digitalWrite(7, HIGH);
    tone(9, 500, 100);
  }
  else{
    digitalWrite(7, LOW);
  }
  Serial.print(x);
  Serial.print(",");
  Serial.print(y);
  Serial.print(",");
  Serial.println(s);
}
