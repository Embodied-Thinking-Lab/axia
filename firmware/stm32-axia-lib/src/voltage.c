#include "main.h"
#include "stm32f446xx.h"
#include <stdint.h>

void adcInit(void) {
	/* Enable ADC1 clock */
	RCC->APB2ENR |= RCC_APB2ENR_ADC1EN;

	/* Enable internal temperature sensor and VREFINT */
	ADC->CCR |= ADC_CCR_TSVREFE;

	/* Configure ADC1 for single conversion */
	ADC1->CR1 = 0;
	ADC1->CR2 = 0;

	/* Select channel 17 (VREFINT) */
	ADC1->SQR3 = 17;

	/* Sampling time: 480 ADC cycles */
	ADC1->SMPR1 |= (7U << 21);

	/* Enable ADC1 */
	ADC1->CR2 |= ADC_CR2_ADON;
}

uint16_t adcReadVref(void) {

	/**
		This sets the software bit which tells ADC to start measuring
		the selected channel now. The ADC begins sampling & converting
		channel 17.
	 */
	ADC1->CR2 |= ADC_CR2_SWSTART;

	/**
		SR: ADC status register
		EOC: end of conversation
		If the ADC status register is == EOC then we know the ADC has
		finished.
	 */
	while (!(ADC1->SR & ADC_SR_EOC)) {}

	/**
		When converstion is finished ADC puts the result in the
		DR register (ADC Data Register) which then is casted to a
		16 bit unsigned int.
	 */
	return (uint16_t)ADC1->DR;
}

float adcReadSupplyVoltage(void) {
	uint16_t reading = adcReadVref();

	/* prevent division by 0 */
	if (reading == 0)
	{
		return 0.0f;
	}

	/**
		ADC measures VREFINT which has a nominal voltage of ~1.21V
		ADC converstion relationship:
			ADC = \frac{V_{input}, V_{DDA}}\times 4095
			V_{DDA} = \frac{V_{input}, ADC_{reading}}\times 4095
	 */
	return (1.21f * 4095.0f) / reading;
}
