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

#ifndef __DEBUGGER_RIVERLIB_DCACHE_LRU_H__
#define __DEBUGGER_RIVERLIB_DCACHE_LRU_H__

#include <systemc.h>
#include "../river_cfg.h"
#include "dwaymem.h"
#include "ilru.h"

namespace debugger {

#define DBG_DCACHE_LRU_TB

SC_MODULE(DCacheLru) {
    sc_in<bool> i_clk;
    sc_in<bool> i_nrst;
    // Control path:
    sc_in<bool> i_req_ctrl_valid;
    sc_in<sc_uint<BUS_ADDR_WIDTH>> i_req_ctrl_addr;
    sc_out<bool> o_req_ctrl_ready;
    sc_out<bool> o_resp_ctrl_valid;
    sc_out<sc_uint<BUS_ADDR_WIDTH>> o_resp_ctrl_addr;
    sc_out<sc_uint<RISCV_ARCH>> o_resp_ctrl_data;
    sc_out<bool> o_resp_ctrl_load_fault;
    sc_out<bool> o_resp_ctrl_executable;
    sc_out<bool> o_resp_ctrl_writable;
    sc_out<bool> o_resp_ctrl_readable;
    sc_in<bool> i_resp_ctrl_ready;
    // Memory interface:
    sc_in<bool> i_req_mem_ready;
    sc_out<bool> o_req_mem_valid;
    sc_out<bool> o_req_mem_write;
    sc_out<sc_uint<BUS_ADDR_WIDTH>> o_req_mem_addr;
    sc_out<sc_uint<BUS_DATA_BYTES>> o_req_mem_strob;
    sc_out<sc_uint<BUS_DATA_WIDTH>> o_req_mem_data;
    sc_out<sc_uint<8>> o_req_mem_len;       // burst transactions num
    sc_out<sc_uint<2>> o_req_mem_burst;     // "01" INCR; "10" burst WRAP
    sc_out<bool> o_req_mem_last;            // last in sequence flag
    sc_in<bool> i_resp_mem_data_valid;
    sc_in<sc_uint<BUS_DATA_WIDTH>> i_resp_mem_data;
    sc_in<bool> i_resp_mem_load_fault;
    // Mpu interface
    sc_out<sc_uint<BUS_ADDR_WIDTH>> o_mpu_addr;
    sc_in<bool> i_mpu_cachable;
    sc_in<bool> i_mpu_executable;
    sc_in<bool> i_mpu_writable;
    sc_in<bool> i_mpu_readable;
    // Debug interface
    sc_in<sc_uint<BUS_ADDR_WIDTH>> i_flush_address;
    sc_in<bool> i_flush_valid;
    sc_out<sc_uint<2>> o_istate;

    void comb();
    void registers();

    SC_HAS_PROCESS(DCacheLru);

    DCacheLru(sc_module_name name_, bool async_reset, int index_width);
    virtual ~DCacheLru();

    void generateVCD(sc_trace_file *i_vcd, sc_trace_file *o_vcd);

 private:
    static const uint32_t FLUSH_ALL_ADDR = 0xFFFF0000;

    static const uint8_t MISS = static_cast<uint8_t>(CFG_ICACHE_WAYS);

    enum EState {
        State_Idle,
        State_CheckHit,
        State_CheckMPU,
        State_WaitGrant,
        State_WaitResp,
        State_WriteLine,
        State_CheckResp,
        State_SetupReadAdr,
        State_Flush
    };

    struct TagMemInType {
        sc_signal<sc_uint<BUS_ADDR_WIDTH>> radr;
        sc_signal<sc_uint<BUS_ADDR_WIDTH>> wadr;
        sc_signal<sc_uint<4*BUS_DATA_BYTES>> wstrb;
        sc_signal<bool> wvalid;
        sc_signal<sc_biguint<4*BUS_DATA_WIDTH>> wdata;
        sc_signal<bool> load_fault;
        sc_signal<bool> executable;
        sc_signal<bool> readable;
        sc_signal<bool> writable;
    };

    // to comply with vhdl (signals cannot be ceated in process)
    struct TagMemInTypeVariable {
        sc_uint<BUS_ADDR_WIDTH> radr;
        sc_uint<BUS_ADDR_WIDTH> wadr;
        sc_uint<4*BUS_DATA_BYTES> wstrb;
        bool wvalid;
        sc_biguint<4*BUS_DATA_WIDTH> wdata;
        bool load_fault;
        bool executable;
        bool readable;
        bool writable;
    };

    struct TagMemOutType {
        sc_signal<sc_uint<CFG_DTAG_WIDTH>> rtag;
        sc_signal<sc_biguint<4*BUS_DATA_WIDTH>> rdata;
        sc_signal<bool> valid;
        sc_signal<bool> load_fault;
        sc_signal<bool> executable;
        sc_signal<bool> readable;
        sc_signal<bool> writable;
    };

    struct WayMuxType {
        sc_uint<3> hit;
        sc_biguint<4*BUS_DATA_WIDTH> rdata;
        bool valid;
        bool load_fault;
        bool executable;
        bool readable;
        bool writable;
    };

    struct DisplaceLineType {
        sc_uint<CFG_DTAG_WIDTH> rtag;
        sc_biguint<4*BUS_DATA_WIDTH> rdata;
        bool valid;
        bool load_fault;
        bool executable;
        bool readable;
        bool writable;
        bool durty;
    };

    struct LruInType {
        sc_signal<bool> init;
        sc_signal<sc_uint<CFG_DINDEX_WIDTH>> radr;
        sc_signal<sc_uint<CFG_DINDEX_WIDTH>> wadr;
        sc_signal<bool> we;
        sc_signal<sc_uint<2>> lru;
    };

    // to comply with vhdl (signals cannot be ceated in process)
    struct LruInTypeVariable {
        bool init;
        sc_uint<CFG_DINDEX_WIDTH> radr;
        sc_uint<CFG_DINDEX_WIDTH> wadr;
        bool we;
        sc_uint<2> lru;
    };

    struct RegistersType {
        sc_signal<bool> requested;
        sc_signal<sc_uint<BUS_ADDR_WIDTH>> req_addr;
        sc_signal<sc_uint<BUS_ADDR_WIDTH>> mpu_addr;
        sc_signal<sc_uint<4>> state;
        sc_signal<bool> req_mem_valid;
        sc_signal<sc_uint<BUS_ADDR_WIDTH>> mem_addr;
        sc_signal<sc_uint<2>> burst_cnt;
        sc_signal<sc_uint<4>> burst_rstrb;
        sc_signal<sc_uint<2>> lru_wr;
        sc_signal<bool> cached;
        sc_signal<bool> executable;
        sc_signal<bool> writable;
        sc_signal<bool> readable;
        sc_signal<bool> load_fault;
        sc_signal<bool> write_first;
        sc_signal<bool> req_flush;
        sc_signal<sc_uint<BUS_ADDR_WIDTH>> req_flush_addr;
        sc_signal<sc_uint<CFG_IINDEX_WIDTH+1>> req_flush_cnt;
        sc_signal<sc_uint<CFG_IINDEX_WIDTH+1>> flush_cnt;
        sc_signal<sc_biguint<4*BUS_DATA_WIDTH>> cache_line_i;
        sc_signal<sc_biguint<4*BUS_DATA_WIDTH>> cache_line_o;
    } v, r;

    void R_RESET(RegistersType &iv) {
        iv.requested = 0;
        iv.req_addr = 0;
        iv.mpu_addr = 0;
        iv.state = State_Flush;
        iv.req_mem_valid = 0;
        iv.mem_addr = FLUSH_ALL_ADDR;
        iv.burst_cnt = 0;
        iv.burst_rstrb = ~0ul;
        iv.lru_wr = 0;
        iv.cached = 0;
        iv.executable = 0;
        iv.writable = 0;
        iv.readable = 0;
        iv.load_fault = 0;
        iv.write_first = 0;
        iv.req_flush = 0;           // init flush request
        iv.req_flush_addr = 0;   // [0]=1 flush all
        iv.req_flush_cnt = 0;
        iv.flush_cnt = ~0ul;
        iv.cache_line_i = 0;
        iv.cache_line_o = 0;
    }

    DWayMem *wayx[CFG_DCACHE_WAYS];

    ILru *lru;

    TagMemInType way_i;
    TagMemOutType way_o[CFG_DCACHE_WAYS];
    WayMuxType waysel;
    DisplaceLineType waydisplace;
    sc_signal<bool> wb_ena[CFG_DCACHE_WAYS];

    LruInType lrui;
    sc_signal<sc_uint<2>> wb_lru;

    bool async_reset_;
    int index_width_;
};


#ifdef DBG_DCACHE_LRU_TB
SC_MODULE(DCacheLru_tb) {
    void comb0();
    void comb_fetch();
    void comb_bus();
    void registers() {
        r = v;
        rbus = vbus;
    }

    SC_HAS_PROCESS(DCacheLru_tb);

    DCacheLru_tb(sc_module_name name_);

private:
    DCacheLru *tt;

    sc_clock w_clk;
    sc_signal<bool> w_nrst;
    // Control path:
    sc_signal<bool> w_req_ctrl_valid;
    sc_signal<sc_uint<BUS_ADDR_WIDTH>> wb_req_ctrl_addr;
    sc_signal<bool> w_req_ctrl_ready;
    sc_signal<bool> w_resp_ctrl_valid;
    sc_signal<sc_uint<BUS_ADDR_WIDTH>> wb_resp_ctrl_addr;
    sc_signal<sc_uint<RISCV_ARCH>> wb_resp_ctrl_data;
    sc_signal<bool> w_resp_ctrl_load_fault;
    sc_signal<bool> w_resp_ctrl_executable;
    sc_signal<bool> w_resp_ctrl_writable;
    sc_signal<bool> w_resp_ctrl_readable;
    sc_signal<bool> w_resp_ctrl_ready;
    // Memory interface:
    sc_signal<bool> w_req_mem_ready;
    sc_signal<bool> w_req_mem_valid;
    sc_signal<bool> w_req_mem_write;
    sc_signal<sc_uint<BUS_ADDR_WIDTH>> wb_req_mem_addr;
    sc_signal<sc_uint<BUS_DATA_BYTES>> wb_req_mem_strob;
    sc_signal<sc_uint<BUS_DATA_WIDTH>> wb_req_mem_data;
    sc_signal<sc_uint<8>> wb_req_mem_len;       // burst transactions num
    sc_signal<sc_uint<2>> wb_req_mem_burst;     // "01" INCR; "10" burst WRAP
    sc_signal<bool> w_req_mem_last;            // last in sequence flag
    sc_signal<bool> w_resp_mem_data_valid;
    sc_signal<sc_uint<BUS_DATA_WIDTH>> wb_resp_mem_data;
    sc_signal<bool> w_resp_mem_load_fault;
    sc_signal<sc_uint<BUS_ADDR_WIDTH>> wb_mpu_addr;
    sc_signal<bool> w_mpu_cachable;
    sc_signal<bool> w_mpu_executable;
    sc_signal<bool> w_mpu_writable;
    sc_signal<bool> w_mpu_readable;
    sc_signal<sc_uint<BUS_ADDR_WIDTH>> wb_flush_address;
    sc_signal<bool> w_flush_valid;
    sc_signal<sc_uint<2>> wb_istate;

    struct RegistersType {
        sc_signal<sc_uint<32>> clk_cnt;
    } v, r;

    enum EBusState {
        BUS_Idle,
        BUS_Read,
        BUS_ReadLast
    };

    struct BusRegistersType {
        sc_signal<sc_uint<2>> state;
        sc_signal<sc_uint<BUS_ADDR_WIDTH>> burst_addr;
        sc_signal<sc_uint<8>> burst_cnt;
    } vbus, rbus;

    sc_trace_file *tb_vcd;
};
#endif  // DBG_DCACHE_LRU_TB

}  // namespace debugger

#endif  // __DEBUGGER_RIVERLIB_DCACHE_LRU_H__
