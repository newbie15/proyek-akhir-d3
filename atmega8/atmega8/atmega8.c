/*
 * atmega8.c
 *
 * Created: 6/16/2012 11:22:11 AM
 *  Author: newbie15
 */ 

#include <avr/io.h>

#ifndef F_CPU
#define F_CPU 11059200UL
#endif

#include <avr/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>

#include "uart.h"

#define UART_BAUD_RATE      9600


#define ADC_MAX 1023
#define ADC_MIN 44
//unsigned char count = 1;
char buffer[5];
char kalimat[4];
unsigned int sudut;
unsigned char count,counter,start,step,satu;
int diff;
unsigned int c,x;

// initialize adc
void adc_init()
{
    // AREF = AVcc
    ADMUX = (1<<REFS0);

    // ADC Enable and prescaler of 128
    // 16000000/128 = 125000
    ADCSRA = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
}

// read adc value
uint16_t adc_read(uint8_t ch)
{
    // select the corresponding channel 0~7
    // ANDing with '7' will always keep the value
    // of 'ch' between 0 and 7
    ch &= 0b00000111;  // AND operation with 7
    ADMUX = (ADMUX & 0xF8)|ch;     // clears the bottom 3 bits before ORing

    // start single conversion
    // write '1' to ADSC
    ADCSRA |= (1<<ADSC);

    // wait for conversion to complete
    // ADSC becomes '0' again
    // till then, run loop continuously
    while(ADCSRA & (1<<ADSC));
	
    return (ADC);
}
/*
void putar_kanan(){
	if(count == 1){
		PORTC = 0b00001000;
		count = 5;		
	}else if(count == 2){
		PORTC = 0b00000010;	
	}else if(count == 3){
		PORTC = 0b00000100;
	}else if(count == 4){
		PORTC = 0b00000001;
	}
	count--;	
	_delay_ms(50);
	PORTC = 0b00000000;
	_delay_ms(200);	
}
*/


//putar kanan fix
void putar_kanan(){
	if (count == 5)
	{
		count = 1;
	}
	count++;	
	if(count == 1){
		//PORTC = 0b00001000;
		PORTC = 0b00001010;
	}else if(count == 2){
		//PORTC = 0b00000010;
		PORTC = 0b00000110;
	}else if(count == 3){
		//PORTC = 0b00000100;
		PORTC = 0b00000101;
	}else if(count == 4){
		//PORTC = 0b00000001;
		PORTC = 0b00001001;
		count = 0;		
	}
	//count++;
	_delay_ms(50);
	PORTC = 0b00000000;
	_delay_ms(200);	
}

void putar_kiri(){
	if (count == 0)
	{
		count = 5;
	}
	count--;	
	if(count == 1){
		//PORTC = 0b00001000;
		PORTC = 0b00001010;
		count = 5;		
	}else if(count == 2){
		//PORTC = 0b00000010;
		PORTC = 0b00000110;	
	}else if(count == 3){
		//PORTC = 0b00000100;
		PORTC = 0b00000101;
	}else if(count == 4){
		//PORTC = 0b00000001;
		PORTC = 0b00001001;
	}
	//count++;
	_delay_ms(50);
	PORTC = 0b00000000;
	_delay_ms(200);	
}
void mode_terima(){
	PORTD &= 0b11111011;
}
void mode_kirim(){
	PORTD |= 0b00000100;
}
void clear_buffer(){
	for(unsigned char i=0;i<=count;i++){
		buffer[i]=' ';
	}
}
void kalibrasi(){
	count = 0;
	x = adc_read(5);
	while(x > 47){
		putar_kiri();
		_delay_ms(500);
		x = adc_read(5);
	}
}
void putar_ke(){
	x = adc_read(5);
	mode_kirim();
	itoa(sudut,kalimat,10);
	uart_puts("sudut ");
	uart_puts(kalimat);
	uart_puts("\n");
	diff = (int)sudut - (int)x;
	itoa(diff,kalimat,10);
	uart_puts("diff ");
	uart_puts(kalimat);
	uart_puts("\n");
	if(diff > 0){
		while(!((diff > -15) && (diff < 15))){
			if (diff > 0)
			{
				putar_kanan();
			}else{
				putar_kiri();
			}
			//putar_kanan();
			_delay_ms(500);
			x = adc_read(5);
			//uart_puts("kanan\n");
			diff = (int)sudut - (int)x;
			/*
			itoa(diff,kalimat,10);
			uart_puts("diff ");
			uart_puts(kalimat);
			uart_puts("\n");
			itoa(x,kalimat,10);
			uart_puts("x ");
			uart_puts(kalimat);
			uart_puts("\n");
			*/
		}	
	}else{
		diff = (int)x - (int)sudut;
		while(!((diff > -15) && (diff < 15))){
			if (diff < 0)
			{
				putar_kanan();
			}else{
				putar_kiri();
			}
			_delay_ms(500);
			x = adc_read(5);
			//uart_puts("kiri\n");
			diff = (int)x - (int)sudut;
			/*
			itoa(diff,kalimat,10);
			uart_puts("diff ");
			uart_puts(kalimat);
			uart_puts("\n");
			itoa(x,kalimat,10);
			uart_puts("x ");
			uart_puts(kalimat);
			uart_puts("\n");
			*/
		}			
	}
	
}

int main(){
	DDRC |= 0b00001111; // stepper
	DDRD |= 0b00000100;
	
	uart_init(UART_BAUD_SELECT(UART_BAUD_RATE,F_CPU));
	sei();
	adc_init();
    
	count = 0;
	//kalibrasi();
	//for (int i=0;i<5;i++)
	//{
	//	putar_kanan();		
	//}
	char data[4];
	
	mode_kirim();
	//while(1){
		x = adc_read(5);
		itoa(x,kalimat,10);
		uart_puts("*"); uart_puts(kalimat); uart_puts("#\n");
	//}	
	mode_terima();
	step = 0;
	unsigned char a = 0;
	while(1)
    {
		//x = adc_read(5);
		
		/*
		if (a == 0)
		{
			if (step < 48)
			{
				putar_kanan();
				step++;
				_delay_ms(1000);
			}else{
				a = 1;
			}
		}else if (a == 1)
		{
			if (step > 0)
			{
				putar_kiri();
				step--;
				_delay_ms(1000);
			}else{
				a = 0;
			}

		}
		*/
		
		//putar_kanan();
		//_delay_ms(1500);
		
		while(uart_available() > 0){
			c = uart_getc();
			if (c == '$')
			{
				x = adc_read(5);
				itoa(x,kalimat,10);
				mode_kirim();
				_delay_ms(10);
				uart_puts("*");
				uart_puts(kalimat);
				uart_puts("#");
				_delay_ms(10);
				mode_terima();
			}
			if (c == '#' || start == 2)
			{
				mode_kirim();
				_delay_ms(10);
				sudut = atoi(buffer);
				
				uart_puts(buffer);
				uart_puts("\n");
				_delay_ms(10);
				mode_terima();
				start = 0;
				clear_buffer();
				putar_ke(sudut);
				counter = 0;
				start = 0;
			}
			if (start == 1)
			{
				buffer[counter] = c;
				counter++;
				if (counter == 4)
				{
					start = 2;
				}
			}
			if (c == '*')
			{
				start = 1;
				counter = 0;
			}
			
			if (c == 'l')
			{
				uart_flush();
				putar_kiri();
				_delay_ms(500);
				step = 1;
			}
			if (c == 'r')
			{
				uart_flush();
				putar_kanan();
				_delay_ms(500);
				step = 1;
			}
			
			if (step == 1 && satu == 0){
				step++;
				satu = 1;
				x = adc_read(5);
				itoa(x,kalimat,10);
				
				mode_kirim();
				_delay_ms(10);
				uart_puts("*");
				uart_puts(kalimat);
				uart_puts("#");
				_delay_ms(10);
			}
		}
		
		satu = 0;
		mode_terima();
    }
	
	return 0;
}