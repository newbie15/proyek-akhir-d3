void menu_reset(){
  boolean terus = true;
  boolean ya = false;
  boolean ok;
  lcd.setCursor(0,0);
  lcd.print("apa anda yakin ?");
  lcd.setCursor(0,1);
  lcd.print(0x7E,BYTE);
  lcd.print("tidak");
  lcd.setCursor(14,1);
  lcd.print("ya");
  while(terus){
    if(irrecv.decode(&decode)){
      //baca_angka();
      if (decode.value == OK){
        if(ya){
          reset();
        }else{
        
        }
        terus = false;
        lcd.setCursor(0,0);
        lcd.print("false");
      }
      if (decode.value == MENU){
        terus = false;
        ok = false;
      }
      if (decode.value == KANAN && ya == false){
        lcd.setCursor(0,1);
        lcd.print(0x8F,BYTE);
        lcd.setCursor(13,1);
        lcd.print(0x7E,BYTE);
        ya = true;
      }
      if (decode.value == KIRI && ya == true){
        lcd.setCursor(13,1);
        lcd.print(0x8F,BYTE);
        lcd.setCursor(0,1);
        lcd.print(0x7E,BYTE);
        ya = false;
      }
      irrecv.resume(); 
    }    
  }
  if(manual){
    digitalWrite(9,LOW);
  }else{
    digitalWrite(9,HIGH);
  }
  lcd.clear();
  //lcd.setCursor(0,0);
  //lcd.print("exit");
  //_delay_ms(1000);
}
