#include "main.h"

int main(void)
{
	RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;	//включить тактирование GPIOC
	
	
	GPIOC->CRH &= ~GPIO_CRH_MODE8;	//LD2, выход 2МГц
	GPIOC->CRH &= ~GPIO_CRH_CNF8;	//LD2, выход 2МГц
	GPIOC->CRH |= GPIO_CRH_MODE8_1;	//LD2, выход 2МГц
	
	//Бесконечный цикл
	while(1) {
		GPIOC->BSRR |= GPIO_BSRR_BS8;
		delay(DELAY_VAL);				//вызов подпрограммы задержки
		GPIOC->BSRR |= GPIO_BSRR_BR8;					//выключить первый светодиод	
				delay(DELAY_VAL);				//вызов подпрограммы задержки

	}
}

void delay(uint32_t takts)
{
	uint32_t i;
	
	for (i = 0; i < takts; i++) {};
}
