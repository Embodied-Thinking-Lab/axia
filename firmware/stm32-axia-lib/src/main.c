#include "main.h"
#include "stm32f446xx.h"
#include "system_stm32f4xx.h"
#include "uart_print.h"
#include "voltage.h"
#include <stdint.h>

#define STEP_PIN	8
#define DIR_PIN		4
#define ENN_PIN		5

static void delay_us(uint32_t us) {
	uint32_t start = DWT->CYCCNT;
	uint32_t cycles = (SystemCoreClock / 1000000U) * us;

	while ((DWT->CYCCNT - start) < cycles) {}
}

static void gpio_init(void) {
	// Enable GPIOA and GPIOB clocks.
	RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
	RCC->AHB1ENR |= RCC_AHB1ENR_GPIOBEN;

	// Initialize output states before configuring pin modes.
	GPIOA->BSRR = (1U << (STEP_PIN + 16));
	GPIOB->BSRR = (1U << (DIR_PIN + 16));
	GPIOB->BSRR = (1U << ENN_PIN); // Disable driver initially.

	// PB8: STEP output.
	GPIOB->MODER &= ~(3U << (STEP_PIN * 2));
	GPIOB->MODER |= (1U << (STEP_PIN * 2));

	// PB4: DIR output.
	GPIOB->MODER &= ~(3U << (DIR_PIN * 2));
	GPIOB->MODER |= (1U << (DIR_PIN * 2));

	// PB5: ENN output.
	GPIOB->MODER &= ~(3U << (ENN_PIN * 2));
	GPIOB->MODER |= (1U << (ENN_PIN * 2));
}

static void timer_init(void) {
	// Enable the Cortex-M4 DWT cycle counter.
	CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
	DWT->CYCCNT = 0;
	DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
}

static void enable_motor(void) {
	GPIOB->BSRR = (1U << (ENN_PIN + 16)); // ENN LOW.
	delay_us(10000);
}

static void set_direction(int direction) {
	if (direction)
		GPIOB->BSRR = (1U << DIR_PIN);
	else
		GPIOB->BSRR = (1U << (DIR_PIN + 16));

	delay_us(10);
}

// static void step_motor(uint32_t steps) {
// 	for (uint32_t i = 0; i < steps; i++) {
// 		// Rising edge: driver registers one step.
// 		GPIOA->BSRR = (1U << STEP_PIN);
// 		delay_us(5);
//
// 		// Falling edge.
// 		GPIOA->BSRR = (1U << (STEP_PIN + 16));
// 		delay_us(9995);
// 	}
// }

static void step_motor(uint32_t steps)
{
	for (uint32_t i = 0; i < steps; i++)
	{
		GPIOB->BSRR = (1U << STEP_PIN);
		delay_us(100);

		GPIOB->BSRR = (1U << (STEP_PIN + 16));
		delay_us(100);
	}
}


int main(void) {
	SystemCoreClockUpdate();
	timer_init();
	gpio_init();
	enable_motor();

	uart_init();
	adcInit();

	uart_print("STM32 & UART running and active!\r\n");

	while (1) {
		// float voltage = adcReadSupplyVoltage();
		// uart_print("voltage: ");
		// char volt_str[32]; snprintf(volt_str, sizeof(volt_str), "%f", voltage);
		// uart_print(volt_str);
		// uart_print("\r\n");

		set_direction(1);
		step_motor(12800);	// 4 revolutions

		delay_us(1000000);	// 1 second

		set_direction(0);
		step_motor(12800);	// 4 revolutions opposite direction

		delay_us(1000000);	// 1 second
		{
		}
	}
}
