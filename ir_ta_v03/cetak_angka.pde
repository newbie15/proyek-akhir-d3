void cetak_angka(unsigned char posisi, unsigned char value){
  lcd.setCursor(posisi,0);
  switch(value){
    case 0:
      lcd.write(3);lcd.write(0);lcd.write(3);
      lcd.setCursor(posisi,1);
      lcd.write(3);lcd.write(1);lcd.write(3);
    break;
    case 1:
      lcd.write(0);lcd.write(3);lcd.write(4);
      lcd.setCursor(posisi,1);
      lcd.write(1);lcd.write(3);lcd.write(1);
    break;
    case 2:
      lcd.write(2);lcd.write(2);lcd.write(3);
      lcd.setCursor(posisi,1);
      lcd.write(3);lcd.write(1);lcd.write(1);
    break;
    case 3:
      lcd.write(0);lcd.write(2);lcd.write(3);
      lcd.setCursor(posisi,1);
      lcd.write(1);lcd.write(1);lcd.write(3);
    break;
    case 4:
      lcd.write(3);lcd.write(1);lcd.write(3);
      lcd.setCursor(posisi,1);
      lcd.write(4);lcd.write(4);lcd.write(3);
    break;
    case 5:
      lcd.write(3);lcd.write(2);lcd.write(2);
      lcd.setCursor(posisi,1);
      lcd.write(1);lcd.write(1);lcd.write(3);
    break;
    case 6:
      lcd.write(3);lcd.write(2);lcd.write(2);
      lcd.setCursor(posisi,1);
      lcd.write(3);lcd.write(1);lcd.write(3);
    break;
    case 7:
      lcd.write(0);lcd.write(0);lcd.write(3);
      lcd.setCursor(posisi,1);
      lcd.write(4);lcd.write(4);lcd.write(3);
    break;
    case 8:
      lcd.write(3);lcd.write(2);lcd.write(3);
      lcd.setCursor(posisi,1);
      lcd.write(3);lcd.write(1);lcd.write(3);
    break;
    case 9:
      lcd.write(3);lcd.write(2);lcd.write(3);
      lcd.setCursor(posisi,1);
      lcd.write(1);lcd.write(1);lcd.write(3);
    break;
    case 255:
      lcd.write(4);lcd.write(4);lcd.write(4);
      lcd.setCursor(posisi,1);
      lcd.write(4);lcd.write(4);lcd.write(4);
    break;
  } 
}

