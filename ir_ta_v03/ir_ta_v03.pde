/*
    include all your header here
*/

#include <avr/interrupt.h>
#include <avr/delay.h>
/* 
   i'm using this IR library from
   http://www.arcfn.com/2009/08/multi-protocol-infrared-remote-library.html
   Thank's for Ken Shirriff
*/
#include <IRremote.h>

#include <EEPROM.h>
#include <LiquidCrystal.h>

/*
    define all your magic set-thing
*/

#define REMOTE
#define RECV_PIN 3

#ifdef REMOTE
#define SATU 0xC03F00FF
#define DUA 0xC03F08F7
#define TIGA 0xC03F8877
#define EMPAT 0xC03FC837
#define LIMA 0xC03F28D7
#define ENAM 0xC03FA857
#define TUJUH 0xC03FE817
#define DELAPAN 0xC03F18E7
#define SEMBILAN 0xC03F9867
#define NOL 0xC03F38C7

#define MENU 0xC03F728D
#define KANAN 0xC03FD22D
#define KIRI 0xC03F926D
#define BAWAH 0xC03FB24D
#define ATAS 0xC03FE21D
#define OK 0xC03F52AD

#else

#define SATU 0xFF906F
#define DUA 0xFFB847
#define TIGA 0xFFF807
#define EMPAT 0xFFB04F
#define LIMA 0xFF9867
#define ENAM 0xFFD827
#define TUJUH 0xFF8877
#define DELAPAN 0xFFA857
#define SEMBILAN 0xFFE817

#define MENU 0xFFE01F
#define KANAN 0xFF02FD
#define KIRI 0xFFE21D
#define ATAS 0xFF609F
#define BAWAH 0xFF22DD
#define OK 0xFFC837

#endif

#define TERIMA digitalWrite(2,LOW); //PORTD |= 0b00000100;
#define KIRIM digitalWrite(2,HIGH); //PORTD &= 0b11111011;

/*
    mapping eeporm
    
    penyimpanan channel 
    0-99  jika mode adc 8-bit
    0-199 jika mode adc 10-bit
    
    penyimpanan setting
    500-511
    
    500 untuk mode
*/

#define eMODE 500

/*
    create your object here
*/
//LiquidCrystal lcd(2, 3, 4, 5, 6, 7);
LiquidCrystal lcd(19, 18, 17, 16, 15, 14);

IRrecv irrecv(RECV_PIN);
decode_results decode;
decode_results dec;


byte c1[8] = {  B11111,  B11111,  B00000,  B00000,  B00000,  B00000,  B00000,  B00000 };
byte c2[8] = {  B00000,  B00000,  B00000,  B00000,  B00000,  B00000,  B11111,  B11111 };
byte c3[8] = {  B11111,  B11111,  B00000,  B00000,  B00000,  B00000,  B11111,  B11111 };
byte c4[8] = {  B11111,  B11111,  B11111,  B11111,  B11111,  B11111,  B11111,  B11111 };
byte c5[8] = {  B00000,  B00000,  B00000,  B00000,  B00000,  B00000,  B00000,  B00000 };

/*
    initialize your variable here
*/
unsigned char i, z, menu, maxnum, num, timer;
unsigned int sudut;
boolean manual, c = true, gerak = false;
boolean baca = true;
String string;
byte buffer;

/*
    main program goes here
*/
int main(){
  pinMode(2,OUTPUT);
  pinMode(9,OUTPUT);
  lcd.begin(16,2);
  lcd.createChar(0,c1);
  lcd.createChar(1,c2);
  lcd.createChar(2,c3);
  lcd.createChar(3,c4);
  lcd.createChar(4,c5);

  lcd.setCursor(0,0);
  lcd.print("  proyek akhir");
  lcd.setCursor(0,1);
  lcd.print("   7109030019   ");
  _delay_ms(1000);
  
  i = EEPROM.read(eMODE);
  if(i == 0){
    manual = true;
  }else{
    manual = false;
  }
  i=255;
  lcd.clear();
  
  Serial.begin(9600);
  irrecv.enableIRIn(); // Start the receiver
  irrecv.blink13(true);
  /*
  lcd.clear();
  while(1){
    TERIMA
    terima();
  }
  */
  /*lcd.clear();
  while(1){
    lcd.setCursor(0,0);
    lcd.print("lcd test");
    lcd.setCursor(0,1);
    lcd.print("TA 2012");
  }
  */
  /*
  //code for show data ir in lcd
  String data;
  while(1){
    if (irrecv.decode(&decode)) {
      if(decode.value != REPEAT){
        lcd.clear();
        lcd.setCursor(0,0);
        data = decode.value;
        lcd.print(data);       
      }
      irrecv.resume();
    }
  }
  */
  while(1){
    digitalWrite(9,LOW);
    while(manual){
      baca_manual();
    } 
    digitalWrite(9,HIGH);
    while(!manual){
      baca_otomatis();
    }
  }
  return 0;
}

void baca_manual(){
  if (irrecv.decode(&decode)) {
    baca_tombol();    
    if (i==100){
      showmenu();
    }
    if (gerak){
      en_timer();
      lcd.setCursor(11,0);
      lcd.print("gerak");
      lcd.setCursor(11,1);
      
      if(i==101){
        lcd.print("kanan");
        KIRIM
        Serial.println("r");
        TERIMA
        terima();
      }else{
        lcd.print("kiri ");
        KIRIM 
        Serial.println("l");
        TERIMA
        terima();
      }
      
      //manual = true;
    }
    irrecv.resume(); // Receive the next value
  }
}


void baca_otomatis(){
  if (irrecv.decode(&decode)) {
      baca_angka();

      if (decode.value == MENU) {
        i=100;
        irrecv.resume();
        showmenu();
      }

      if (decode.value != REPEAT && i != 255){
        if(c){
          c = false;
          cetak_angka(0,255);
          cetak_angka(4,i);
          buffer = i;

          en_timer();
        }else{
          c = true;
          //di_timer();
          cetak_angka(0,buffer);
          cetak_angka(4,i);
          buffer = (buffer*10) + i;
          ganti_channel();
        }
        i = 255;
      }
      irrecv.resume(); // Receive the next value
    }
}


void baca_tombol(){
    if (decode.value == MENU) {
      i=100; gerak=false;
      irrecv.resume();
      showmenu();
    }else if (decode.value == KANAN) {
      i=101; gerak=true;
    }else if (decode.value == KIRI) {
      i=102; gerak=true;
    }else if (decode.value == ATAS) {
      i=103; gerak=false;
    }else if (decode.value == BAWAH) {
      i=104; gerak=false;
    }else if (decode.value == OK){
      i=105; gerak=false;
    }
}

void showmenu(){
  menu = 0; num = 1; maxnum = 3;
  lcd.clear();
  while(i==100){
    if(menu == 0){
      lcd.setCursor(0,0);
      lcd.print("MENU");
           if(num == 1){ string = "|-MODE  "; }
      else if(num == 2){ string = "|-SIMPAN"; }
      else if(num == 3){ string = "|-RESET "; }
      else if(num == 4){ string = "|-DOLOR "; }
    }else if(menu == 1){
      lcd.setCursor(0,0);
      lcd.print("|-MODE");
           if(num == 1){ string = " |-MANUAL  "; }
      else if(num == 2){ string = " |-OTOMATIS"; }
    }else if(menu == 2){
      lcd.clear();
      menu_simpan();
      //menu_reset();
      string = "";
      i = 255;
      c = true;
    }else if(menu == 3){
      lcd.clear();
      menu_reset();
      //menu_simpan();
      string = "";
      i = 255;
      c = true;
    }
    lcd.setCursor(0,1);
    lcd.print(string);

    if(irrecv.decode(&decode)){
      if(decode.value == MENU){
        i = 255;
        lcd.clear();
      }else if(decode.value == BAWAH){
        if(num < maxnum){ num++; }
      }else if(decode.value == ATAS){
        if(num > 1){ num--; }
      }else if(decode.value == OK){
        if(menu==0){
          if(num == 1){ menu = num; num = 1; maxnum = 2;}
          if(num == 2){ menu = num; num = 1; maxnum = 2;}
          if(num == 3){ menu = num; num = 1; maxnum = 2;}
        }else if(menu ==1){
               if(num == 1){ manual = true;  EEPROM.write(eMODE,0);}
          else if(num == 2){ manual = false; EEPROM.write(eMODE,1);}
          i = 255;
          lcd.clear();
        }
      }
      irrecv.resume();
    }
  }
}
void ganti_channel(){
    lcd.setCursor(8,0);
    lcd.print("ganti");
    lcd.setCursor(8,1);
    lcd.print("channel");
    if (z == 0){
      sudut = load_channel(buffer);
      kirim();
    }
    //buka database di eeprom dan kirim melalui serial;
}
void en_timer(){
  TCNT1 = 0x0000;
  TIMSK1 = 0x01; // enabled global and timer overflow interrupt;
  TCCR1B = 0x04; // start timer/ set clock
}

void di_timer(){
  TIMSK1 = 0x00; // disabled global and timer overflow interrupt;
  TCCR1B = 0x00; // stop timer/ set clock
}

ISR(TIMER1_OVF_vect){
  if(!manual){
    //ganti channel dan reset c
    baca = false;
    ganti_channel();
    c = true;
    z++;
  }
  //matikan timer
  if(timer == 3){
    lcd.clear();
    di_timer();
    timer=0;
    baca = true;
    z = 0;
  }
  timer++;
}


