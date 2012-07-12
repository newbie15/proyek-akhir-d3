void kirim(){
  if(sudut != 0xffff){
    KIRIM
    Serial.print("*");
    Serial.print(sudut,DEC);
    Serial.print("#");
  }
}
