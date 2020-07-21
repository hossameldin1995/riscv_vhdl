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
#include "test_arithmetic.h"

void allocate_exception_table(void);
uint32_t test_fpu(void);
void test_timer(void);
void start_application(void);
uint64_t double2hex(double x);

uint32_t main() {
    io_per io_per_d;
    uint32_t err_cnt = 0;
    
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

    printf_uart("  HARTID . . . . . %d\r\n", fw_get_cpuid());

    /* LEDG = 2*/
    io_per_set_output(&io_per_d, LEDG, 0, LED_OFF);
    io_per_set_output(&io_per_d, LEDG, 1, LED_ON);
    io_per_set_output(&io_per_d, RWD, 0, 0);

    //err_cnt = test_fpu();
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

uint64_t double2hex(double x) {
    uint64_t *p;
    p = (void*)&x;
    return *p;

}

uint32_t check_arithmetic(uint32_t gpio_value, 
                          uint32_t int_mul,  uint32_t int_div, 
                          double double_mul, double double_div) {
    uint32_t error_arithmetic = 0;


    if ((int_mul - test_int_mul[gpio_value]) > 0.0000000000001) {
        error_arithmetic++;
        printf_uart("%d int_mul\n\r", gpio_value);
    }
    if ((int_div - test_int_div[gpio_value]) > 0.0000000000001) {
        error_arithmetic++;
        printf_uart("%d int_div\n\r", gpio_value);
    }
    if ((double_mul - test_double_mul[gpio_value]) > 0.0000000000001) {
        error_arithmetic++;
        printf_uart("%d double_mul\n\r", gpio_value);
        print_uart_hex(double2hex(double_mul));
        print_uart("\n\r", 2);
    }
    if ((double_div - test_double_div[gpio_value]) > 0.0000000000001) {
        error_arithmetic++;
        printf_uart("%d double_div\n\r", gpio_value);
        print_uart_hex(double2hex(double_div));
        print_uart("\n\r", 2);
    }
    

    return error_arithmetic;
}

// ***************************************
// ******* LED CODE **********************
// ***************************************
// LEDG 0      >> Application init done
//      1      >> Application init done
//      2      >>
//      3      >>
//      4      >>
//      5      >>
//      6      >>
//      7      >>
//
// LEDR 0      >> TON0 E_T
//      1      >> TON0 Q
//      2      >> PWM0 Q
//      3      >> 
//      4      >> 
//      5      >> 
//      6      >> 
//      7      >> 
//      8      >> 
//      9      >> Error Arithmetic

void start_application(void) {
    uint32_t int_mul;
    uint32_t int_div;
    uint32_t error_arithmetic = 0;
    uint32_t is_first_time = 1;
    uint32_t gpio_value;
    double double_mul;
    double double_div;

    time_measurement time_measurement_d;
    io_per io_per_d;
    timer_hw TON0;
    pwm_hw PWM0;

    time_measurement_d.registers = (volatile void *)ADDR_BUS0_XSLV_MEASUREMENT;
    io_per_d.registers = (volatile void *)ADDR_BUS0_XSLV_GPIO;
    TON0.registers = (volatile void *)ADDR_BUS0_XSLV_TON0;
    PWM0.registers = (volatile void *)ADDR_BUS0_XSLV_PWM0;

    io_per_set_output(&io_per_d, LEDG, 0, LED_ON);
    io_per_set_output(&io_per_d, LEDG, 1, LED_ON);
    io_per_set_output(&io_per_d, RWD, 0, 0);



    while(1) {
        start_time(&time_measurement_d);
        io_per_set_output(&io_per_d, RWD, 0, 0);

        // ***************************************
        // ******* TON0 **************************
        // ***************************************
		uint32_t var0 = io_per_get_input(&io_per_d, SW, 0);
		timer_hw_send_preset_time(&TON0, (uint64_t)SYS_HZ);
		timer_hw_send_in(&TON0, var0);
		uint64_t E_T = timer_hw_recieve_elapsed_time(&TON0);
		io_per_set_output(&io_per_d, LEDR, 1, timer_hw_recieve_Q(&TON0));
		io_per_set_output(&io_per_d, LEDR, 0, E_T);

        // ***************************************
        // ******* PWM0 **************************
        // ***************************************
        pwm_hw_send_frequency_duty_cycle(&PWM0, 1, 50);
        io_per_set_output(&io_per_d, LEDR, 2, pwm_hw_recieve_Q(&PWM0));
        
        // ***************************************
        // ******* Print gpio_valeu **************
        // ***************************************
        if (io_per_get_input(&io_per_d, KEY, 0) && is_first_time) {
            printf_uart("gpio_value: %02d\n\r", gpio_value);
            is_first_time = 0;
        } else if (io_per_get_input(&io_per_d, KEY, 0) == 0){
            is_first_time = 1;
        }

        // ***************************************
        // ******* Arithmetic Test ***************
        // ***************************************
        gpio_value =  io_per_get_input(&io_per_d, SW, 0)+
                    io_per_get_input(&io_per_d, SW, 1)+
                    io_per_get_input(&io_per_d, SW, 2)+
                    io_per_get_input(&io_per_d, SW, 3)+
                    io_per_get_input(&io_per_d, SW, 4)+
                    io_per_get_input(&io_per_d, SW, 5)+
                    io_per_get_input(&io_per_d, SW, 6)+
                    io_per_get_input(&io_per_d, SW, 7)+
                    io_per_get_input(&io_per_d, SW, 8)+
                    io_per_get_input(&io_per_d, SW, 9);
                    
        int_mul = gpio_value * 3; 
        int_div = gpio_value / 3;
        double_mul = (double)gpio_value * 3.2;
        double_div = (double)gpio_value / 3.2;

        error_arithmetic += check_arithmetic(gpio_value, int_mul, int_div, double_mul, double_div);

        if (error_arithmetic) {
            io_per_set_output(&io_per_d, LEDR, 9, LED_ON);
        }

        stop_time(&time_measurement_d);
    }
}