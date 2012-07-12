void menu_simpan(){
  lcd.setCursor(8,0);
  lcd.print("masukkan");
  lcd.setCursor(8,1);
  lcd.print("channel");
  boolean terus = true;
  boolean ok;
  while(terus){
    if(irrecv.decode(&decode)){
      baca_angka();
      if (decode.value == OK){
        terus = false;
        ok = true;
      }
      if (decode.value == MENU){
        terus = false;
        ok = false;
      }
      if (decode.value != REPEAT && i != 255){
        if(c){
          c = false;
          cetak_angka(0,255);
          cetak_angka(4,i);
          buffer = i;
        }else{
          c = true;
          cetak_angka(0,buffer);
          cetak_angka(4,i);
          buffer = (buffer*10) + i;
        }
        i = 255;
      }
      irrecv.resume(); 
    }    
  }
  lcd.clear();
  lcd.setCursor(0,0);
  if(ok){
    lcd.print("tersimpan");
    byte lokasi = (byte)buffer;
    simpan_channel(lokasi,sudut);
    KIRIM
    Serial.println(buffer,DEC);
    Serial.println(buffer,HEX);
    Serial.println(lokasi,HEX);
    _delay_ms(1000);
    lcd.clear();
  }
}
