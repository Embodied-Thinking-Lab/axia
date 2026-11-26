#ifndef UART_PRINT_H
#define UART_PRINT_H

void uart_send_char(char c);
void uart_print(const char *str);
void uart_init(void);

#endif
