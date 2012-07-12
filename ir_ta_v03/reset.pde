void reset(){
  for (int i = 0; i < 199; i++){
    analogWrite(9,i);
    EEPROM.write(i, 0);
  }
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("reset berhasil");
  _delay_ms(1000);
}
