/*
  place this function inside IR reading
  ex : 
  if(irrecv.decode(&decode)){
    baca_angka();
  }
*/
void baca_angka(){
  if(baca){
  // jika lcd belum clear maka belum bisa baca angka lagi
      if (decode.value == SATU) {
        i=1; 
      }else if (decode.value == DUA) {
        i=2; 
      }else if (decode.value == TIGA) {
        i=3; 
      }else if (decode.value == EMPAT) {
        i=4; 
      }else if (decode.value == LIMA) {
        i=5; 
      }else if (decode.value == ENAM) {
        i=6; 
      }else if (decode.value == TUJUH) {
        i=7; 
      }else if (decode.value == DELAPAN) {
        i=8; 
      }else if (decode.value == SEMBILAN) {
        i=9; 
      }else if (decode.value == NOL) {
        i=0; 
      }
  }
  //gerak = false;
}

