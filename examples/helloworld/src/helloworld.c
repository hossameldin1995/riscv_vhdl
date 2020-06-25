/*****************************************************************************
 * @file
 * @author   Sergey Khabarov
 * @brief    Firmware example. 
 ****************************************************************************/

#include <inttypes.h>
#include <string.h>
#include <stdio.h>
#include "axi_maps.h"

extern char _end;

/**
 * @name sbrk
 * @brief Increase program data space.
 * @details Malloc and related functions depend on this.
 */
char *sbrk(int incr) {
    return &_end;
}


void print_uart(const char *buf, int sz) {
    uart_map *uart = (uart_map *)ADDR_BUS0_XSLV_UART1;
    for (int i = 0; i < sz; i++) {
        while (uart->status & UART_STATUS_TX_FULL) {}
        uart->data = buf[i];
    }
}

// Read data from Rx FIFO
int uart_read_data(char *buf) {
    uart_map *uart = (uart_map *)ADDR_BUS0_XSLV_UART1;
    int ret = 0;
    while ((uart->status & UART_STATUS_RX_EMPTY) == 0) {
        buf[ret++] = (char)uart->data;
    }
    return ret;
}

void print_uart_hex(long val) {
    unsigned char t, s;
    uart_map *uart = (uart_map *)ADDR_BUS0_XSLV_UART1;
    for (int i = 0; i < 16; i++) {
        while (uart->status & UART_STATUS_TX_FULL) {}
        
        t = (unsigned char)((val >> ((15 - i) * 4)) & 0xf);
        if (t < 10) {
            s = t + '0';
        } else {
            s = (t - 10) + 'a';
        }
        uart->data = s;
    }
}

int wait(int n) {
    int i = 0;
    while(i<n){i++;};
    return i;
}

void helloWorld() {
    char ss[256];
    int ss_len;
    int i;
    int index = 0;
    int gpio_values;
    int mul;
    int div;
    double double_v;
    io_per io_per_d;
    //float x;

    io_per_d.registers = (volatile void *)ADDR_BUS0_XSLV_GPIO;
    
    io_per_set_output(&io_per_d, LEDG, 0, LED_ON);
    io_per_set_output(&io_per_d, LEDG, 7, LED_ON);

    ss_len = sprintf(ss, "Hellow World - %d!!!!\n\r", 1);
    //print_uart(ss, ss_len);

    while(1) {
        io_per_set_output(&io_per_d, RWD, 0, 0);
        //i = wait(900000);

        ss_len = sprintf(ss, "Wait: %d\n\r", i);
        //print_uart(ss, ss_len); 
        ss_len = sprintf(ss, "Index: %d\n\r", index);
        //print_uart(ss, ss_len); 


        gpio_values =  io_per_get_input(&io_per_d, SW, 1)+
                    io_per_get_input(&io_per_d, SW, 2)+
                    io_per_get_input(&io_per_d, SW, 3)+
                    io_per_get_input(&io_per_d, SW, 4)+
                    io_per_get_input(&io_per_d, SW, 5)+
                    io_per_get_input(&io_per_d, SW, 6)+
                    io_per_get_input(&io_per_d, SW, 7)+
                    io_per_get_input(&io_per_d, SW, 8)+
                    io_per_get_input(&io_per_d, SW, 9);
                    
        mul = gpio_values * 3; 
        div = gpio_values / 3;
        double_v = (double)gpio_values / 3.0;

        //print_uart("mul=", 4);
        //print_uart_hex(mul);
        //print_uart(", div=", 6);
        //print_uart_hex(div);

        ss_len = sprintf(ss, "\n\rgpio_values: %d\n\r", gpio_values);
        print_uart(ss, ss_len);
        ss_len = sprintf(ss, "\n\rdouble_v: %f\n\r", double_v);
        print_uart(ss, ss_len);

        /*x = (float) gpio_values + 3.3;

        ss_len = sprintf(ss, "float x: %f\n\r", x);
        print_uart(ss, ss_len);*/

        while (io_per_get_input(&io_per_d, SW, 0) == 1){
           io_per_set_output(&io_per_d, RWD, 0, 0);
        }

        index++;
    }
}

