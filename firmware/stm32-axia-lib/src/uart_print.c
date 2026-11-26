#include "stm32f446xx.h"

void uart_send_char(char c) {
	while (!(USART2->SR & USART_SR_TXE)) {
	}

	USART2->DR = c;
}

void uart_print(const char *str) {
	while (*str) {
		uart_send_char(*str++);
	}

	while (!(USART2->SR & USART_SR_TC))
	{
	}
}

void uart_init(void) {
	RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
	RCC->APB1ENR |= RCC_APB1ENR_USART2EN;

	/* PA2: Alternate function mode */
	GPIOA->MODER &= ~(3U << 4);
	GPIOA->MODER |= (2U << 4);

	/* PA2: AF7 (USART2_TX) */
	GPIOA->AFR[0] &= ~(0xFU << 8);
	GPIOA->AFR[0] |= (7U << 8);

	/* 115200 baud, assuming PCLK1 = 16 MHz */
	USART2->BRR = 0x008B;

	USART2->CR1 = USART_CR1_TE | USART_CR1_UE;
}
