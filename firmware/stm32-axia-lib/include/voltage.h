#ifndef VOLTAGE_H
#define VOLTAGE_H

void adcInit(void);
uint16_t adcReadVref(void);
float adcReadSupplyVoltage(void);


#endif
