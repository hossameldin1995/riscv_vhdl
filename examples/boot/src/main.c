/*
 *  Copyright 2018 Sergey Khabarov, sergeykhbr@gmail.com
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

static const int FW_IMAGE_SIZE_BYTES = 1 << 16;

int fw_get_cpuid() {
    int ret;
    asm("csrr %0, mhartid" : "=r" (ret));
    return ret;
}

void print_uart(const char *buf, int sz) {
    uart_map *uart = (uart_map *)ADDR_BUS0_XSLV_UART1;
    for (int i = 0; i < sz; i++) {
        while (uart->status & UART_STATUS_TX_FULL) {}
        uart->data = buf[i];
    }
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

void copy_image() { 
    uint64_t *fwrom = (uint64_t *)ADDR_BUS0_XSLV_FWIMAGE;
    uint64_t *sram = (uint64_t *)ADDR_BUS0_XSLV_SRAM;

    memcpy(sram, fwrom, FW_IMAGE_SIZE_BYTES);

#if 0
    /** Just to check access to DSU and read MCPUID via this slave device.
     *  Verification is made on time diagram (ModelSim), no other purposes of 
     *  these operations.
     *        DSU base address = 0x80080000: 
     *        CSR address: Addr[15:4] = 16 bytes alignment
     *  3296 ns - reading (iClkCnt = 409)
     *  3435 ns - writing (iClkCnt = 427)
     */
    uint64_t *arr_csrs = (uint64_t *)0x80080000;
    uint64_t x1 = arr_csrs[CSR_MCPUID<<1]; 
    pnp->fwdbg1 = x1;
    arr_csrs[CSR_MCPUID<<1] = x1;
#endif
}

/** This function will be used during video recording to show
 how tochange npc register value on core[1] while core[0] is running
 Zephyr OS
*/
void timestamp_output() {
    gptimers_map *tmr = (gptimers_map *)ADDR_BUS0_XSLV_GPTIMERS;
    uint64_t start = tmr->highcnt;
    while (1) {
        if (tmr->highcnt < start || (start + SYS_HZ) < tmr->highcnt) {
            start = tmr->highcnt;
            print_uart("HIGHCNT: ", 9);
            print_uart_hex(start);
            print_uart("\r\n", 2);
        }
    }
}

void _init() {
    uart_map *uart = (uart_map *)ADDR_BUS0_XSLV_UART1;
    irqctrl_map *p_irq = (irqctrl_map *)ADDR_BUS0_XSLV_IRQCTRL;
    io_per io_per_d;
    
    io_per_d.registers = (volatile void *)ADDR_BUS0_XSLV_GPIO;
  
    if (fw_get_cpuid() != 0) {
        // TODO: waiting event or something
        while(1) {
            // Just do something
            uint64_t *sram = (uint64_t *)ADDR_BUS0_XSLV_SRAM;
            uint64_t tdata = sram[16*1024];
            sram[16*1024] = tdata;
        }
    }

    // mask all interrupts in interrupt controller to avoid
    // unpredictable behaviour after elf-file reloading via debug port.
    p_irq->irq_mask = 0xFFFFFFFF;

    // Half period of the uart = Fbus / 115200 / 2 = 70 MHz / 115200 / 2:
    uart->scaler = SYS_HZ / 115200 / 2;
    
    io_per_set_output(&io_per_d, LEDG, 0, LED_ON); // LED = 1
    io_per_set_output(&io_per_d, RWD, 0, 0);
    //print_uart("Booting . . .\n\r", 15);
    
    io_per_set_output(&io_per_d, LEDG, 1, LED_ON); // LEDG = 2
    io_per_set_output(&io_per_d, LEDG, 0, LED_OFF);
    io_per_set_output(&io_per_d, RWD, 0, 0);

    copy_image();
    
    io_per_set_output(&io_per_d, LEDG, 2, LED_ON); // LEDG = 4
    io_per_set_output(&io_per_d, LEDG, 1, LED_OFF);
    io_per_set_output(&io_per_d, RWD, 0, 0);
    //print_uart("Application image copied to RAM\r\n", 33);

    io_per_set_output(&io_per_d, LEDR, 9, LED_ON); // LEDR = 0x200
    io_per_set_output(&io_per_d, LEDG, 2, LED_OFF);
    io_per_set_output(&io_per_d, RWD, 0, 0);
    //print_uart("Jump to Application in RAM\r\n", 28);

    
}

/** Not used actually */
int main() {
    while (1) {}

    return 0;
}
