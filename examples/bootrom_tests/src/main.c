/*
 *  Copyright 2019 Sergey Khabarov, sergeykhbr@gmail.com
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include <string.h>
#include "axi_maps.h"
#include "encoding.h"
#include "fw_api.h"

void allocate_exception_table(void);
int test_fpu(void);
void test_timer(void);
void test_timer_multicycle_instructions(void);
void test_missaccess(void);
void test_stackprotect(void);
void start_application(void);
int wait(int n);

int main() {
    io_per io_per_d;
    int err_cnt;
    
    uart_map *uart = (uart_map *)ADDR_BUS0_XSLV_UART1;
    irqctrl_map *p_irq = (irqctrl_map *)ADDR_BUS0_XSLV_IRQCTRL;
    io_per_d.registers = (volatile void *)ADDR_BUS0_XSLV_GPIO;

    if (fw_get_cpuid() != 0) {
        while (1) {}
    }

    // mask all interrupts in interrupt controller to avoid
    // unpredictable behaviour after elf-file reloading via debug port.
    p_irq->irq_mask = 0xFFFFFFFF;
    p_irq->isr_table = 0;

    p_irq->irq_lock = 1;
    fw_malloc_init();
    
    allocate_exception_table();

    uart_isr_init();   // enable printf_uart function and Tx irq=1
    p_irq->irq_lock = 0;
 
    /* LEDG = 1*/
    io_per_set_output(&io_per_d, LEDG, 0, LED_ON);
    io_per_set_output(&io_per_d, RWD, 0, 0);
    printf_uart("*************************************************\n\r");
    printf_uart("******************** Booting ********************\n\r");
    printf_uart("*************************************************\n\r");

#if 1
    printf_uart("  HARTID . . . . . %d\r\n", fw_get_cpuid());

    /* LEDG = 2*/
    io_per_set_output(&io_per_d, LEDG, 0, LED_OFF);
    io_per_set_output(&io_per_d, LEDG, 1, LED_ON);
    io_per_set_output(&io_per_d, RWD, 0, 0);

    err_cnt = test_fpu();
    if (err_cnt) {
        io_per_set_output(&io_per_d, LEDR, 0, LED_ON);
        io_per_set_output(&io_per_d, LEDR, 1, LED_OFF);
        io_per_set_output(&io_per_d, LEDR, 2, LED_ON);
        io_per_set_output(&io_per_d, LEDR, 3, LED_OFF);
        io_per_set_output(&io_per_d, LEDR, 4, LED_ON);
        io_per_set_output(&io_per_d, LEDR, 5, LED_OFF);
        io_per_set_output(&io_per_d, LEDR, 6, LED_ON);
        io_per_set_output(&io_per_d, LEDR, 7, LED_OFF);
        io_per_set_output(&io_per_d, LEDR, 8, LED_ON);
        io_per_set_output(&io_per_d, LEDR, 9, LED_OFF);
        io_per_set_output(&io_per_d, RWD, 0, 0);
        printf_uart("  This could happend when using -Ofast or -O3 in compilling the project\n\r");
        printf_uart("  If you want to continue press KEY0\n\r");
        while(1){
            io_per_set_output(&io_per_d, RWD, 0, 0);
            if (io_per_get_input(&io_per_d, KEY, 0)) {
                io_per_set_output(&io_per_d, LEDR, 0, LED_OFF);
                io_per_set_output(&io_per_d, LEDR, 2, LED_OFF);
                io_per_set_output(&io_per_d, LEDR, 4, LED_OFF);
                io_per_set_output(&io_per_d, LEDR, 6, LED_OFF);
                io_per_set_output(&io_per_d, LEDR, 8, LED_OFF);
                break;
            }
        }
    }

    /* LEDG = 4*/
    io_per_set_output(&io_per_d, LEDG, 1, LED_OFF);
    io_per_set_output(&io_per_d, LEDG, 2, LED_ON);
    io_per_set_output(&io_per_d, RWD, 0, 0);
    test_timer();      // Enabling timer[0] with 1 sec interrupts
#else
    test_timer_multicycle_instructions();
#endif

    /* LEDG = 8*/
    io_per_set_output(&io_per_d, LEDG, 2, LED_OFF);
    io_per_set_output(&io_per_d, LEDG, 3, LED_ON);
    io_per_set_output(&io_per_d, RWD, 0, 0);

    printf_uart("  Done testing\n\r");


    printf_uart("*************************************************\n\r");
    printf_uart("*************** Start Appilcation ***************\n\r");
    printf_uart("*************************************************\n\r");


    /* LEDG = 0*/
    io_per_set_output(&io_per_d, LEDG, 3, LED_OFF);
    io_per_set_output(&io_per_d, RWD, 0, 0);

    start_application(); // no return

    return 0;
}

int wait(volatile int n) {
    volatile int i = 0;
    while(i<n){i++;};
    return i;
}

void start_application(void) {
    volatile int i;
    int is_found;
    int index = 0;
    int gpio_values;
    int mul;
    int div;
    double double_v;
    double d_v;
    io_per io_per_d;

    io_per_d.registers = (volatile void *)ADDR_BUS0_XSLV_GPIO;

    printf_uart("Hellow World - %d!!!!\n\r", 1);

    while(1) {
        io_per_set_output(&io_per_d, RWD, 0, 0);
        i = wait(900000);

        printf_uart("Wait : %d\n\r", i);
        printf_uart("Index: %d\n\r", index);


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

        printf_uart("gpio_values: %d\n\r", gpio_values);
        printf_uart("mul_i      : %d\r\n", mul);
        printf_uart("div_i      : %d\r\n", div);

        is_found = 0;
        d_v = 0.0;
        for(i = 0; i < 10; i++) {
            if (double_v < d_v) {
                is_found = 1;
                printf_uart("double_v < 0.%d\n\r", i);
                break;
            }
            d_v += 0.1;
        }

        if (!is_found) {
            d_v = 1.0;
            for(i = 0; i < 10; i++) {
                if (double_v < d_v) {
                    is_found = 1;
                    printf_uart("double_v < 1.%d\n\r", i);
                    break;
                }
                d_v += 0.1;
            }
        }
        
        if (!is_found) {
            printf_uart("double_v > 1.9\n\r");
        }

        while (io_per_get_input(&io_per_d, SW, 0) == 1){ // Halt the system
           io_per_set_output(&io_per_d, RWD, 0, 0);
        }

        index++;
    }
}