#include "main.h"

int delayDuration = DEFAULT_DURATION;
int powerDuration = DEFAULT_DURATION;
int isGrow = FALSE;

int main(void)
{
	RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;	//включить тактирование GPIOC
	
	GPIOC->CRH &= ~GPIO_CRH_MODE8;	//зануляем MODE
	GPIOC->CRH &= ~GPIO_CRH_CNF8;	//зануляем CNF
	GPIOC->CRH |= GPIO_CRH_MODE8_1;	//инициализируем
	
	//Бесконечный цикл
	while(1) {
		if (isGrow == TRUE) {
		powerDuration += DIFF;
		delayDuration -= DIFF;
		if (delayDuration == DIFF) {
			isGrow = FALSE;
		}
	} else {
		delayDuration += DIFF;
		powerDuration -= DIFF;
		if (powerDuration == DIFF) {
			isGrow = TRUE;
		}
	}
	
		LED8_ON();
		delay(powerDuration);				//вызов подпрограммы задержки
		LED8_OFF();	
		delay(delayDuration);				//вызов подпрограммы задержки
	}
}

void delay(uint32_t takts)
{
	uint32_t i;
	
	for (i = 0; i < takts; i++) {};
}
