#ifndef __MAIN_H
#define	__MAIN_H

#include "stm32f10x.h"  

// Величина задержки между вкл/выкл светодиодов
#define DELAY_VAL	500000

#define TRUE 1
#define FALSE 0

/* Управление светодиодами */
#define	LED8_ON()	GPIOC->BSRR |= GPIO_BSRR_BS8
#define	LED8_OFF()	GPIOC->BSRR |= GPIO_BSRR_BR8
#define DEFAULT_DURATION 1500
#define DIFF 10

/* Прототипы функций */
void delay(uint32_t takts);

#endif
