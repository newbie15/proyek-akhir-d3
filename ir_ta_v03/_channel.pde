void simpan_channel(byte channel, unsigned int posisi){
  byte low,high,lc,hc;

  low = (byte)posisi;  
  high = (byte)(posisi >> 8);
  lc = channel * 2;
  hc = lc + 1;
  EEPROM.write(lc,low);
  EEPROM.write(hc,high);
}

unsigned int load_channel(byte channel){
  byte low,high,lc,hc;
  
  lc = channel * 2;
  hc = lc + 1;
  low = EEPROM.read(lc);
  high = EEPROM.read(hc);

  unsigned int posisi = (high << 8) | low;
  return (int)posisi;
}

