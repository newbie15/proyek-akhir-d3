void terima(){
  String s;
  boolean start = false;
  while(Serial.available() > 0){
    char data = Serial.read();
    if(data == '#'){
     start = false;
     sudut = stoi(s);
     s = s + " ";
     lcd.setCursor(0,0);
     lcd.print("ADC");
     lcd.setCursor(0,1);
     lcd.print(s);
    }
    if(start){
      s += data;    
    }
    if(data == '*'){
      start = true;  
    }
  }
  //delay(10);
}
