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

#include "dcache_lru.h"

namespace debugger {

DCacheLru::DCacheLru(sc_module_name name_, bool async_reset,
    int index_width) : sc_module(name_),
    i_clk("i_clk"),
    i_nrst("i_nrst"),
    i_req_valid("i_req_valid"),
    i_req_write("i_req_write"),
    i_req_addr("i_req_addr"),
    i_req_wdata("i_req_wdata"),
    i_req_wstrb("i_req_wstrb"),
    o_req_ctrl_ready("o_req_ctrl_ready"),
    o_resp_ctrl_valid("o_resp_ctrl_valid"),
    o_resp_ctrl_addr("o_resp_ctrl_addr"),
    o_resp_ctrl_data("o_resp_ctrl_data"),
    o_resp_ctrl_load_fault("o_resp_ctrl_load_fault"),
    o_resp_ctrl_executable("o_resp_ctrl_executable"),
    o_resp_ctrl_writable("o_resp_ctrl_writable"),
    o_resp_ctrl_readable("o_resp_ctrl_readable"),
    i_resp_ctrl_ready("i_resp_ctrl_ready"),
    i_req_mem_ready("i_req_mem_ready"),
    o_req_mem_valid("o_req_mem_valid"),
    o_req_mem_write("o_req_mem_write"),
    o_req_mem_addr("o_req_mem_addr"),
    o_req_mem_strob("o_req_mem_strob"),
    o_req_mem_data("o_req_mem_data"),
    o_req_mem_len("o_req_mem_len"),
    o_req_mem_burst("o_req_mem_burst"),
    o_req_mem_last("o_req_mem_last"),
    i_resp_mem_data_valid("i_resp_mem_data_valid"),
    i_resp_mem_data("i_resp_mem_data"),
    i_resp_mem_load_fault("i_resp_mem_load_fault"),
    o_mpu_addr("o_mpu_addr"),
    i_mpu_cachable("i_mpu_cachable"),
    i_mpu_executable("i_mpu_executable"),
    i_mpu_writable("i_mpu_writable"),
    i_mpu_readable("i_mpu_readable"),
    i_flush_address("i_flush_address"),
    i_flush_valid("i_flush_valid"),
    o_istate("o_istate") {
    async_reset_ = async_reset;
    index_width_ = index_width;

    mem = new DLineMem("mem0", async_reset);
    mem->i_clk(i_clk);
    mem->i_nrst(i_nrst);
    mem->i_cs(line_cs_i);
    mem->i_flush(line_flush_i);
    mem->i_addr(line_addr_i);
    mem->i_wdata(line_wdata_i);
    mem->i_wstrb(line_wstrb_i);
    mem->i_wdirty(line_wdirty_i);
    mem->i_wload_fault(r.load_fault);
    mem->i_wexecutable(r.executable);
    mem->i_wreadable(r.readable);
    mem->i_wwritable(r.writable);
    mem->o_raddr(line_raddr_o);
    mem->o_rdata(line_rdata_o);
    mem->o_rvalid(line_rvalid_o);
    mem->o_rdirty(line_rdirty_o);
    mem->o_rload_fault(line_rload_fault_o);
    mem->o_rexecutable(line_rexecutable_o);
    mem->o_rreadable(line_rreadable_o);
    mem->o_rwritable(line_rwritable_o);


    SC_METHOD(comb);
    sensitive << i_nrst;
    sensitive << i_req_valid;
    sensitive << i_req_write;
    sensitive << i_req_addr;
    sensitive << i_req_wdata;
    sensitive << i_req_wstrb;
    sensitive << i_resp_mem_data_valid;
    sensitive << i_resp_mem_data;
    sensitive << i_resp_mem_load_fault;
    sensitive << i_resp_ctrl_ready;
    sensitive << i_flush_address;
    sensitive << i_flush_valid;
    sensitive << i_req_mem_ready;
    sensitive << i_mpu_cachable;
    sensitive << i_mpu_executable;
    sensitive << line_raddr_o;
    sensitive << line_rdata_o;
    sensitive << line_rvalid_o;
    sensitive << line_rdirty_o;
    sensitive << line_rload_fault_o;
    sensitive << line_rexecutable_o;
    sensitive << line_rreadable_o;
    sensitive << line_rwritable_o;
    sensitive << r.requested;
    sensitive << r.req_addr;
    sensitive << r.state;
    sensitive << r.req_mem_valid;
    sensitive << r.mem_addr;
    sensitive << r.burst_cnt;
    sensitive << r.burst_rstrb;
    sensitive << r.cached;
    sensitive << r.load_fault;
    sensitive << r.write_first;
    sensitive << r.req_flush;
    sensitive << r.req_flush_addr;
    sensitive << r.req_flush_cnt;
    sensitive << r.flush_cnt;
    sensitive << r.cache_line_i;
    sensitive << r.cache_line_o;

    SC_METHOD(registers);
    sensitive << i_nrst;
    sensitive << i_clk.pos();
};

DCacheLru::~DCacheLru() {
    delete mem;
}

void DCacheLru::generateVCD(sc_trace_file *i_vcd, sc_trace_file *o_vcd) {
    if (o_vcd) {
        sc_trace(o_vcd, i_nrst, i_nrst.name());
        sc_trace(o_vcd, i_req_valid, i_req_valid.name());
        sc_trace(o_vcd, i_req_write, i_req_write.name());
        sc_trace(o_vcd, i_req_addr, i_req_addr.name());
        sc_trace(o_vcd, i_req_wdata, i_req_wdata.name());
        sc_trace(o_vcd, i_req_wstrb, i_req_wstrb.name());
        sc_trace(o_vcd, o_req_ctrl_ready, o_req_ctrl_ready.name());
        sc_trace(o_vcd, o_resp_ctrl_valid, o_resp_ctrl_valid.name());
        sc_trace(o_vcd, o_resp_ctrl_addr, o_resp_ctrl_addr.name());
        sc_trace(o_vcd, o_resp_ctrl_data, o_resp_ctrl_data.name());
        sc_trace(o_vcd, o_resp_ctrl_load_fault, o_resp_ctrl_load_fault.name());
        sc_trace(o_vcd, i_resp_ctrl_ready, i_resp_ctrl_ready.name());
        sc_trace(o_vcd, o_resp_ctrl_executable, o_resp_ctrl_executable.name());

        sc_trace(o_vcd, i_req_mem_ready, i_req_mem_ready.name());
        sc_trace(o_vcd, o_req_mem_valid, o_req_mem_valid.name());
        sc_trace(o_vcd, o_req_mem_write, o_req_mem_write.name());
        sc_trace(o_vcd, o_req_mem_addr, o_req_mem_addr.name());
        sc_trace(o_vcd, o_req_mem_strob, o_req_mem_strob.name());
        sc_trace(o_vcd, o_req_mem_data, o_req_mem_data.name());
        sc_trace(o_vcd, o_req_mem_len, o_req_mem_len.name());
        sc_trace(o_vcd, o_req_mem_burst, o_req_mem_burst.name());
        sc_trace(o_vcd, o_req_mem_last, o_req_mem_last.name());
        sc_trace(o_vcd, i_resp_mem_data_valid, i_resp_mem_data_valid.name());
        sc_trace(o_vcd, i_resp_mem_data, i_resp_mem_data.name());
        sc_trace(o_vcd, i_resp_mem_load_fault, i_resp_mem_load_fault.name());

        sc_trace(o_vcd, i_flush_address, i_flush_address.name());
        sc_trace(o_vcd, i_flush_valid, i_flush_valid.name());
        sc_trace(o_vcd, o_istate, o_istate.name());

        std::string pn(name());
        sc_trace(o_vcd, r.requested, pn + ".r_requested");
        sc_trace(o_vcd, r.state, pn + ".r_state");
        sc_trace(o_vcd, r.req_addr, pn + ".r_req_addr");
        sc_trace(o_vcd, line_addr_i, pn + ".linei_addr_i");
        sc_trace(o_vcd, line_wstrb_i, pn + ".linei_wstrb_i");
        sc_trace(o_vcd, r.load_fault, pn + ".r_load_fault");
        sc_trace(o_vcd, r.cached, pn + ".r_cached");
        sc_trace(o_vcd, r.cache_line_i, pn + ".r_cache_line_i");
        sc_trace(o_vcd, r.cache_line_o, pn + ".r_cache_line_o");
        sc_trace(o_vcd, r.executable, pn + ".r_executable");
        sc_trace(o_vcd, r.write_first, pn + ".r_write_first");
        sc_trace(o_vcd, r.burst_cnt, pn + ".r_burst_cnt");
    }
    mem->generateVCD(i_vcd, o_vcd);
}

void DCacheLru::comb() {
    sc_biguint<4*BUS_DATA_WIDTH> vb_req_line_wdata;
    sc_biguint<4*BUS_DATA_BYTES> vb_req_line_wstrb;
    
    bool w_last;
    bool v_req_ctrl_ready;
    sc_uint<8> v_req_mem_len;
    sc_biguint<4*BUS_DATA_WIDTH> t_cache_line_i;
    sc_uint<RISCV_ARCH> vb_cached_data;
    sc_uint<RISCV_ARCH> vb_uncached_data;
    bool v_resp_valid;
    sc_uint<RISCV_ARCH> vb_resp_data;
    bool v_resp_load_fault;
    bool v_resp_executable;
    bool v_resp_readable;
    bool v_resp_writable;
    bool v_flush;
    bool v_line_cs;
    sc_uint<BUS_ADDR_WIDTH> vb_line_addr;
    sc_biguint<4*BUS_DATA_WIDTH> vb_line_wdata;
    sc_uint<4*BUS_DATA_BYTES> vb_line_wstrb;
    sc_biguint<BUS_DATA_WIDTH> vb_req_mask;
    bool v_line_wdirty;
   
    v = r;

    v_req_ctrl_ready = 0;
    v_resp_valid = 0;
    v_flush = 0;
    vb_cached_data = line_rdata_o.read()(RISCV_ARCH-1, 0);
    v_resp_load_fault = line_rload_fault_o;
    v_resp_executable = line_rexecutable_o;
    v_resp_readable = line_rreadable_o;
    v_resp_writable = line_rwritable_o;
    for (unsigned i = 1; i < 4; i++) {
        if (r.req_addr.read()(4, 3).to_uint() == i) {
            vb_cached_data =
                line_rdata_o.read()((i+1)*RISCV_ARCH-1, i*RISCV_ARCH);
        }
    }
    vb_uncached_data = r.cache_line_i.read()(RISCV_ARCH-1, 0);


    if (i_flush_valid.read() == 1) {
        v.req_flush = 1;
        if (i_flush_address.read()[0] == 1) {
            v.req_flush_cnt = ~0u;
            v.req_flush_addr = 0;
        } else if (i_flush_address.read()(CFG_IOFFSET_WIDTH-1, 1) == 0xF) {
            v.req_flush_cnt = 1;
            v.req_flush_addr = i_flush_address.read();
        } else {
            v.req_flush_cnt = 0;
            v.req_flush_addr = i_flush_address.read();
        }
    }

    vb_req_mask = 0;
    for (int i = 0; i < BUS_DATA_BYTES; i++) {
        if (r.req_wstrb.read()[i] == 1) {
            vb_req_mask(8*i+7, 8*i) = ~0u;
        }
    }
    
    int tdx = r.req_addr.read()(4, 3).to_int();
    vb_req_line_wdata = line_rdata_o.read();
    vb_req_line_wdata(BUS_DATA_WIDTH*(tdx+1)-1, BUS_DATA_WIDTH*tdx) =
        (vb_req_line_wdata(BUS_DATA_WIDTH*(tdx+1)-1, BUS_DATA_WIDTH*tdx) & ~vb_req_mask)
      | (r.req_wdata.read() & vb_req_mask);
    vb_req_line_wstrb = 0;
    vb_req_line_wstrb(BUS_DATA_BYTES*(tdx+1)-1, BUS_DATA_BYTES*tdx) = r.req_wstrb.read();

    v_line_cs = 0;
    vb_line_addr = r.req_addr.read();
    vb_line_wdata = r.cache_line_i.read();
    v_line_wdirty = 0;
    vb_line_wstrb = 0;



    // System Bus access state machine
    w_last = 0;
    
    v_req_mem_len = 3;

    switch (r.state.read()) {
    case State_Idle:
        if (r.req_flush.read() == 1) {
            v.state = State_Flush;
            t_cache_line_i = 0;
            v.cache_line_i = ~t_cache_line_i;
            if (r.req_flush_addr.read()[0] == 1) {
                v.req_addr = 0;
                v.flush_cnt = ~0u;
            } else {
                v.req_addr = r.req_flush_addr.read();
                v.flush_cnt = r.req_flush_cnt.read();
            }
        } else {
            v_line_cs = i_req_valid.read();
            v_req_ctrl_ready = 1;
            vb_line_addr = i_req_addr.read();
            if (i_req_valid.read() == 1) {
                v.requested = 1;
                v.req_addr = i_req_addr.read();
                v.req_wstrb = i_req_wstrb.read();
                v.req_wdata = i_req_wdata.read();
                v.req_write = i_req_write.read();
                v.state = State_CheckHit;
            } else {
                v.requested = 0;
            }
        }
        break;
    case State_CheckHit:
        vb_resp_data = vb_cached_data;
        if (line_rvalid_o.read() == 1) {
            // Hit
            v_resp_valid = 1;
            if (r.req_write.read() == 1) {
                v_line_cs = 1;
                v_line_wdirty = 1;
                vb_line_wstrb = vb_req_line_wstrb;
                vb_line_wdata = vb_req_line_wdata;
                if (i_resp_ctrl_ready.read() == 0) {
                    // Do nothing: wait accept
                } else {
                    v.state = State_Idle;
                    v.requested = 0;
                }
            } else {
                v_req_ctrl_ready = 1;
                if (i_resp_ctrl_ready.read() == 0) {
                    // Do nothing: wait accept
                } else if (i_req_valid.read() == 1) {
                    v.state = State_CheckHit;
                    v_line_cs = i_req_valid.read();
                    v.req_addr = i_req_addr.read();
                    v.req_wstrb = i_req_wstrb.read();
                    v.req_wdata = i_req_wdata.read();
                    v.req_write = i_req_write.read();
                    vb_line_addr = i_req_addr.read();
                } else {
                    v.state = State_Idle;
                    v.requested = 0;
                }
            }
        } else {
            // Miss
            v.state = State_CheckMPU;
        }
        break;
    case State_CheckMPU:
        v.req_mem_valid = 1;
        v.state = State_WaitGrant;

        v.cache_line_o = line_rdata_o;

        if (i_mpu_cachable.read() == 1) {
            if (line_rvalid_o == 1) {
                v.write_first = 1;
                v.mem_addr = line_raddr_o.read()(BUS_ADDR_WIDTH-1,
                            CFG_DOFFSET_WIDTH) << CFG_DOFFSET_WIDTH;
            } else {
                v.mem_addr = r.req_addr.read()(BUS_ADDR_WIDTH-1,
                            CFG_DOFFSET_WIDTH) << CFG_DOFFSET_WIDTH;
            }
            v.burst_cnt = 3;
            v.cached = 1;
        } else {
            v.mem_addr = r.req_addr.read()(BUS_ADDR_WIDTH-1, 3) << 3;
            v.burst_cnt = 0;
            v.cached = 0;
            v_req_mem_len = 0;  // default cached = 3
        }
        v.burst_rstrb = 0x1;
        v.cache_line_i = 0;
        v.load_fault = 0;
        v.executable = i_mpu_executable.read();
        v.writable = i_mpu_writable.read();
        v.readable = i_mpu_readable.read();
        break;
    case State_WaitGrant:
        if (i_req_mem_ready.read()) {
            if (r.write_first.read() == 1) {
                v.state = State_WriteLine;
            } else {
                v.state = State_WaitResp;
            }
            v.req_mem_valid = 0;
        }
        if (r.cached.read() == 0) {
            v_req_mem_len = 0;
        }
        break;
    case State_WaitResp:
        if (r.burst_cnt.read() == 0) {
            w_last = 1;
        }
        if (i_resp_mem_data_valid.read()) {
            t_cache_line_i = r.cache_line_i.read();
            for (int k = 0; k < 4; k++) {
                if (r.burst_rstrb.read()[k] == 1) {
                    t_cache_line_i((k+1)*BUS_DATA_WIDTH-1,
                                    k*BUS_DATA_WIDTH) = i_resp_mem_data.read();
                }
            }
            v.cache_line_i = t_cache_line_i;
            if (r.burst_cnt.read() == 0) {
                v.state = State_CheckResp;
            } else {
                v.burst_cnt = r.burst_cnt.read() - 1;
            }
            v.burst_rstrb = r.burst_rstrb.read() << 1;
            if (i_resp_mem_load_fault.read() == 1) {
                v.load_fault = 1;
            }
        }
        break;
    case State_CheckResp:
        if (r.cached.read() == 1) {
            v.state = State_SetupReadAdr;
            v_line_cs = 1;
            vb_line_wstrb = ~0ul;  // write full line
        } else {
            v_resp_valid = 1;
            vb_resp_data = vb_uncached_data;
            v_resp_load_fault = r.load_fault;
            v_resp_executable = r.executable;
            v_resp_writable = r.writable;
            v_resp_readable = r.readable;
            if (i_resp_ctrl_ready.read() == 1) {
                v.state = State_Idle;
                v.requested = 0;
            }
        }
        break;
    case State_SetupReadAdr:
        v.state = State_CheckHit;
        break;
    case State_WriteLine:
        if (r.burst_cnt.read() == 0) {
            w_last = 1;
        }
        if (i_resp_mem_data_valid.read()) {
            // Shift right to send lower part on AXI
            v.cache_line_o =
                (0, r.cache_line_o.read()(4*BUS_DATA_WIDTH-1, BUS_DATA_WIDTH));
            if (r.burst_cnt.read() == 0) {
                v.mem_addr = r.req_addr.read()(BUS_ADDR_WIDTH-1, CFG_DOFFSET_WIDTH)
                            << CFG_DOFFSET_WIDTH;
                v.req_mem_valid = 1;
                v.burst_cnt = 3;
                v.write_first = 0;
                v.state = State_WaitGrant;
            } else {
                v.burst_cnt = r.burst_cnt.read() - 1;
            }
            //if (i_resp_mem_store_fault.read() == 1) {
            //    v.store_fault = 1;
            //}
        }
        break;
    case State_Flush:
        v_line_cs = 1;
        v_flush = 1;
        vb_line_wstrb = ~0ul;  // write full line
        if (r.flush_cnt.read() == 0) {
            v.req_flush = 0;
            v.state = State_Idle;
        } else {
            v.flush_cnt = r.flush_cnt.read() - 1;
            v.req_addr = r.req_addr.read() + (1 << CFG_DOFFSET_WIDTH);
        }
        break;
    default:;
    }

    if (!async_reset_ && !i_nrst.read()) {
        R_RESET(v);
    }


    line_cs_i = v_line_cs;
    line_addr_i = vb_line_addr;
    line_wdata_i = vb_line_wdata;
    line_wstrb_i = vb_line_wstrb;
    line_wdirty_i = v_line_wdirty;
    line_flush_i = v_flush;

    o_req_ctrl_ready = v_req_ctrl_ready;

    o_req_mem_valid = r.req_mem_valid.read();
    o_req_mem_addr = r.mem_addr.read();
    o_req_mem_write = r.write_first.read();
    o_req_mem_strob = 0;
    o_req_mem_data = r.cache_line_o.read()(BUS_DATA_WIDTH-1, 0).to_uint64();
    o_req_mem_len = v_req_mem_len;
    o_req_mem_burst = 1;    // 00=FIX; 01=INCR; 10=WRAP
    o_req_mem_last = w_last;

    o_resp_ctrl_valid = v_resp_valid;
    o_resp_ctrl_data = vb_resp_data;
    o_resp_ctrl_addr = r.req_addr.read();
    o_resp_ctrl_load_fault = v_resp_load_fault;
    o_resp_ctrl_executable = v_resp_executable;
    o_resp_ctrl_writable = v_resp_writable;
    o_resp_ctrl_readable = v_resp_readable;
    o_mpu_addr = r.req_addr.read();
    o_istate = r.state.read()(1, 0);
}

void DCacheLru::registers() {
    if (async_reset_ && i_nrst.read() == 0) {
        R_RESET(r);
    } else {
        r = v;
    }
}

#ifdef DBG_DCACHE_LRU_TB
DCacheLru_tb::DCacheLru_tb(sc_module_name name_) : sc_module(name_),
    w_clk("clk0", 10, SC_NS) {
    SC_METHOD(comb0);
    sensitive << w_nrst;
    sensitive << r.clk_cnt;

    SC_METHOD(comb_fetch);
    sensitive << w_nrst;
    sensitive << w_req_ctrl_ready;
    sensitive << w_resp_ctrl_valid;
    sensitive << wb_resp_ctrl_addr;
    sensitive << wb_resp_ctrl_data;
    sensitive << w_resp_ctrl_load_fault;
    sensitive << r.clk_cnt;

    SC_METHOD(comb_bus);
    sensitive << w_nrst;
    sensitive << w_req_mem_valid;
    sensitive << w_req_mem_write;
    sensitive << wb_req_mem_addr;
    sensitive << wb_req_mem_strob;
    sensitive << wb_req_mem_data;
    sensitive << rbus.state;
    sensitive << rbus.burst_addr;
    sensitive << rbus.burst_cnt;

    SC_METHOD(registers);
    sensitive << w_clk.posedge_event();

    tt = new DCacheLru("tt", 0, CFG_IINDEX_WIDTH);
    tt->i_clk(w_clk);
    tt->i_nrst(w_nrst);
    tt->i_req_valid(w_req_valid);
    tt->i_req_write(w_req_write);
    tt->i_req_addr(wb_req_addr);
    tt->i_req_wdata(wb_req_wdata);
    tt->i_req_wstrb(wb_req_wstrb);
    tt->o_req_ctrl_ready(w_req_ctrl_ready);
    tt->o_resp_ctrl_valid(w_resp_ctrl_valid);
    tt->o_resp_ctrl_addr(wb_resp_ctrl_addr);
    tt->o_resp_ctrl_data(wb_resp_ctrl_data);
    tt->o_resp_ctrl_load_fault(w_resp_ctrl_load_fault);
    tt->o_resp_ctrl_executable(w_resp_ctrl_executable);
    tt->o_resp_ctrl_writable(w_resp_ctrl_writable);
    tt->o_resp_ctrl_readable(w_resp_ctrl_readable);
    tt->i_resp_ctrl_ready(w_resp_ctrl_ready);
    // memory interface
    tt->i_req_mem_ready(w_req_mem_ready);
    tt->o_req_mem_valid(w_req_mem_valid);
    tt->o_req_mem_write(w_req_mem_write);
    tt->o_req_mem_addr(wb_req_mem_addr);
    tt->o_req_mem_strob(wb_req_mem_strob);
    tt->o_req_mem_data(wb_req_mem_data);
    tt->o_req_mem_len(wb_req_mem_len);
    tt->o_req_mem_burst(wb_req_mem_burst);
    tt->o_req_mem_last(w_req_mem_last);
    tt->i_resp_mem_data_valid(w_resp_mem_data_valid);
    tt->i_resp_mem_data(wb_resp_mem_data);
    tt->i_resp_mem_load_fault(w_resp_mem_load_fault);
    // MPU interface
    tt->o_mpu_addr(wb_mpu_addr);
    tt->i_mpu_cachable(w_mpu_cachable);
    tt->i_mpu_executable(w_mpu_executable);
    tt->i_mpu_writable(w_mpu_writable);
    tt->i_mpu_readable(w_mpu_readable);
    // Debug interface
    tt->i_flush_address(wb_flush_address);
    tt->i_flush_valid(w_flush_valid);
    tt->o_istate(wb_istate);

    tb_vcd = sc_create_vcd_trace_file("DCacheLru_tb");
    tb_vcd->set_time_unit(1, SC_PS);
    sc_trace(tb_vcd, w_nrst, "w_nrst");
    sc_trace(tb_vcd, w_clk, "w_clk");
    sc_trace(tb_vcd, r.clk_cnt, "clk_cnt");
    sc_trace(tb_vcd, w_req_valid, "w_req_valid");
    sc_trace(tb_vcd, w_req_write, "w_req_write");
    sc_trace(tb_vcd, wb_req_addr, "wb_req_addr");
    sc_trace(tb_vcd, wb_req_wdata, "wb_req_wdata");
    sc_trace(tb_vcd, wb_req_wstrb, "wb_req_wstrb");
    sc_trace(tb_vcd, w_req_ctrl_ready, "w_req_ctrl_ready");
    sc_trace(tb_vcd, w_resp_ctrl_valid, "w_resp_ctrl_valid");
    sc_trace(tb_vcd, wb_resp_ctrl_addr, "wb_resp_ctrl_addr");
    sc_trace(tb_vcd, wb_resp_ctrl_data, "wb_resp_ctrl_data");
    sc_trace(tb_vcd, w_resp_ctrl_ready, "w_resp_ctrl_ready");
    sc_trace(tb_vcd, w_req_mem_ready, "w_req_mem_ready");
    sc_trace(tb_vcd, w_req_mem_valid, "w_req_mem_valid");
    sc_trace(tb_vcd, w_req_mem_write, "w_req_mem_write");
    sc_trace(tb_vcd, wb_req_mem_addr, "wb_req_mem_addr");
    sc_trace(tb_vcd, wb_req_mem_strob, "wb_req_mem_strob");
    sc_trace(tb_vcd, wb_req_mem_data, "wb_req_mem_data");
    sc_trace(tb_vcd, w_resp_mem_data_valid, "w_resp_mem_data_valid");
    sc_trace(tb_vcd, wb_resp_mem_data, "wb_resp_mem_data");
    sc_trace(tb_vcd, wb_istate, "wb_istate");
    sc_trace(tb_vcd, rbus.burst_addr, "rbus_burst_addr");
    sc_trace(tb_vcd, rbus.burst_cnt, "rbus_burst_cnt");

    tt->generateVCD(tb_vcd, tb_vcd);
}


void DCacheLru_tb::comb0() {
    v = r;
    v.clk_cnt = r.clk_cnt.read() + 1;

    w_flush_valid = 0;
    wb_flush_address = 0;

    if (r.clk_cnt.read() < 10) {
        w_nrst = 0;
    } else {
        w_nrst = 1;
    }

}


void DCacheLru_tb::comb_fetch() {
    w_req_valid = 0;
    w_req_write = 0;
    wb_req_addr = 0;
    wb_req_wdata = 0;
    wb_req_wstrb = 0;
    w_resp_ctrl_ready = 1;

    w_mpu_cachable = 1;
    w_mpu_executable = 1;
    w_mpu_writable = 1;
    w_mpu_readable = 1;

    const unsigned START_POINT = 10 + 1 + (1 << (CFG_IINDEX_WIDTH+1));
    const unsigned START_POINT2 = START_POINT + 500;

    switch (r.clk_cnt.read()) {
    case START_POINT:
        w_req_valid = 1;
        wb_req_addr = 0x00000008;
        break;

    case START_POINT + 10:
        w_req_valid = 1;
        wb_req_addr = 0x00010008;
        break;

    case START_POINT + 25:
        w_req_valid = 1;
        wb_req_addr = 0x00011008;
        break;

    case START_POINT + 40:
        w_req_valid = 1;
        wb_req_addr = 0x00012008;
        break;

    case START_POINT + 55:
        w_req_valid = 1;
        wb_req_addr = 0x00013010;
        break;


    case START_POINT2:
        w_req_valid = 1;
        w_req_write = 1;
        wb_req_addr = 0x00012008;
        wb_req_wdata = 0x000000000000CC00ull;
        wb_req_wstrb = 0x02;
        break;

    default:;
    }
}

void DCacheLru_tb::comb_bus() {
    vbus = rbus;

    w_req_mem_ready = 0;
    w_resp_mem_data_valid = 0;
    wb_resp_mem_data = 0;

    switch (rbus.state.read()) {
    case BUS_Idle:
        w_req_mem_ready = 1;
        if (w_req_mem_valid.read() == 1) {
            if (wb_req_mem_len.read() == 0) {
                vbus.state = BUS_ReadLast;
            } else {
                vbus.state = BUS_Read;
            }
            vbus.burst_addr = wb_req_mem_addr.read();
            vbus.burst_cnt = wb_req_mem_len;
        }
        break;
    case BUS_Read:
        w_resp_mem_data_valid = 1;
        wb_resp_mem_data = 0x2000000010000000ull + rbus.burst_addr.read();
        vbus.burst_cnt = rbus.burst_cnt.read() - 1;
        vbus.burst_addr = rbus.burst_addr.read() + 8;
        if (rbus.burst_cnt.read() == 1) {
            vbus.state = BUS_ReadLast;
        }
        break;
    case BUS_ReadLast:
        w_req_mem_ready = 1;
        w_resp_mem_data_valid = 1;
        wb_resp_mem_data = 0x2000000010000000ull + rbus.burst_addr.read();
        if (w_req_mem_valid.read() == 1) {
            if (wb_req_mem_len.read() == 0) {
                vbus.state = BUS_ReadLast;
            } else {
                vbus.state = BUS_Read;
            }
            vbus.burst_addr = wb_req_mem_addr.read();
            vbus.burst_cnt = wb_req_mem_len;
        } else {
            vbus.state = BUS_Idle;
            vbus.burst_cnt = 0;
        }
        break;
    default:;
    }

    if (w_nrst.read() == 0) {
        vbus.state = BUS_Idle;
        vbus.burst_addr = 0;
        vbus.burst_cnt = 0;
    }
}

#endif

}  // namespace debugger
