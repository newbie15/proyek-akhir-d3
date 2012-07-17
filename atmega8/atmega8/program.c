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
unsigned int sudut;
unsigned char count, counter, start;
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
void putar_kanan(){
	if(counter == 1){
		PORTC = 0b00001000;
		counter = 5;		
	}else if(counter == 2){
		PORTC = 0b00000010;	
	}else if(counter == 3){
		PORTC = 0b00000100;
	}else if(counter == 4){
		PORTC = 0b00000001;
	}
	counter--;	
	_delay_ms(50);
	PORTC = 0b00000000;
	_delay_ms(200);	
}

void putar_kiri(){
	counter++;	
	if(counter == 1){
		PORTC = 0b00001000;
	}else if(counter == 2){
		PORTC = 0b00000010;	
	}else if(counter == 3){
		PORTC = 0b00000100;
	}else if(counter == 4){
		PORTC = 0b00000001;
		counter = 0;		
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
	char kalimat[4];
	
	//mode_kirim();
	mode_kirim();
	//mode_terima();
	sudut = 0;
	
	while(1)
    {
		//parse data fix
		
		while(uart_available() > 0){
			c = uart_getc();
			if (c == '#')
			{
				mode_kirim();
				_delay_ms(10);
				//itoa(count,kalimat,10);
				//uart_puts(kalimat);
				//sprintf(kalimat,"%c",buffer);
				
				uart_puts(buffer);
				uart_puts("\n");
				_delay_ms(10);
				mode_terima();
				start = 0;
				clear_buffer();

				count = 0;
				start = 0;
			}
			if (start == 1)
			{
				buffer[count] = c;
				count++;
			}
			if (c == '*')
			{
				start = 1;
				count = 0;
			}
			
			if (c == 'l')
			{
				putar_kanan();
			}
			if (c == 'r')
			{
				putar_kiri();
			}
		}
		mode_terima();


    }
	
	return 0;
}