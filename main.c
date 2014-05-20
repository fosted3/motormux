#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define IN 0x08
#define OUT 0x10

int main(void) 
{
	DDRB |= OUT;
	DDRB &= ~IN;
	unsigned int count = 0;
	while(1)
	{
		if (PINB & IN)
		{	count = 0;
			while (PINB & IN)
			{
				count ++;
				_delay_us(10);
			}
			if (count > 160)
			{
				PORTB |= OUT;
			}
			else if (count < 140)
			{
				PORTB &= ~OUT;
			}			
		}
	}
	return 0;
}
