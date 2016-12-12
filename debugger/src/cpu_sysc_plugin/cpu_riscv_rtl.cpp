/**
 * @file
 * @copyright  Copyright 2016 GNSS Sensor Ltd. All right reserved.
 * @author     Sergey Khabarov - sergeykhbr@gmail.com
 * @brief      CPU synthesizable SystemC class declaration.
 */

#include "api_core.h"
#include "cpu_riscv_rtl.h"

namespace debugger {

CpuRiscV_RTL::CpuRiscV_RTL(const char *name)  
    : IService(name), IHap(HAP_ConfigDone) {
    registerInterface(static_cast<IThread *>(this));
    registerInterface(static_cast<IClock *>(this));
    registerInterface(static_cast<IHap *>(this));
    registerAttribute("Bus", &bus_);
    registerAttribute("FreqHz", &freqHz_);

    bus_.make_string("");
    freqHz_.make_uint64(1);
    RISCV_event_create(&config_done_, "config_done");
    RISCV_register_hap(static_cast<IHap *>(this));
    sc_set_default_time_unit(1, SC_NS);
#if GENERATE_VCD
    i_vcd_ = sc_create_vcd_trace_file("i_river");
    i_vcd_->set_time_unit(1, SC_PS);
    o_vcd_ = sc_create_vcd_trace_file("o_river");
    o_vcd_->set_time_unit(1, SC_PS);
#else
    i_vcd_ = 0;
    o_vcd_ = 0;
#endif
    /** Create all objects, then initilize SystemC context: */
    wrapper_ = new RtlWrapper("wrapper");
    registerInterface(static_cast<ICpuRiscV *>(wrapper_));
    w_clk = wrapper_->o_clk;
    wrapper_->o_nrst(w_nrst);
    wrapper_->i_time(wb_time);
    wrapper_->o_req_mem_ready(w_req_mem_ready);
    wrapper_->i_req_mem_valid(w_req_mem_valid);
    wrapper_->i_req_mem_write(w_req_mem_write);
    wrapper_->i_req_mem_addr(wb_req_mem_addr);
    wrapper_->i_req_mem_strob(wb_req_mem_strob);
    wrapper_->i_req_mem_data(wb_req_mem_data);
    wrapper_->o_resp_mem_data_valid(w_resp_mem_data_valid);
    wrapper_->o_resp_mem_data(wb_resp_mem_data);
    wrapper_->o_interrupt(w_interrupt);
    wrapper_->o_dport_valid(w_dport_valid);
    wrapper_->o_dport_write(w_dport_write);
    wrapper_->o_dport_region(wb_dport_region);
    wrapper_->o_dport_addr(wb_dport_addr);
    wrapper_->o_dport_wdata(wb_dport_wdata);
    wrapper_->i_dport_ready(w_dport_ready);
    wrapper_->i_dport_rdata(wb_dport_rdata);


    top_ = new RiverTop("top", i_vcd_, o_vcd_);
    top_->i_clk(wrapper_->o_clk);
    top_->i_nrst(w_nrst);
    top_->i_req_mem_ready(w_req_mem_ready);
    top_->o_req_mem_valid(w_req_mem_valid);
    top_->o_req_mem_write(w_req_mem_write);
    top_->o_req_mem_addr(wb_req_mem_addr);
    top_->o_req_mem_strob(wb_req_mem_strob);
    top_->o_req_mem_data(wb_req_mem_data);
    top_->i_resp_mem_data_valid(w_resp_mem_data_valid);
    top_->i_resp_mem_data(wb_resp_mem_data);
    top_->i_ext_irq(w_interrupt);
    top_->o_time(wb_time);
    top_->i_dport_valid(w_dport_valid);
    top_->i_dport_write(w_dport_write);
    top_->i_dport_region(wb_dport_region);
    top_->i_dport_addr(wb_dport_addr);
    top_->i_dport_wdata(wb_dport_wdata);
    top_->o_dport_ready(w_dport_ready);
    top_->o_dport_rdata(wb_dport_rdata);

    sc_start(0, SC_NS);
}

CpuRiscV_RTL::~CpuRiscV_RTL() {
    RISCV_event_close(&config_done_);
}

void CpuRiscV_RTL::postinitService() {
    IBus *ibus = static_cast<IBus *>(
       RISCV_get_service_iface(bus_.to_string(), IFACE_BUS));

    if (!ibus) {
        RISCV_error("Bus interface '%s' not found", 
                    bus_.to_string());
        return;
    }
    wrapper_->setBus(ibus);

    if (!run()) {
        RISCV_error("Can't create thread.", NULL);
        return;
    }

    wrapper_->setClockHz(freqHz_.to_int());
}

void CpuRiscV_RTL::predeleteService() {
    stop();
}

void CpuRiscV_RTL::hapTriggered(IFace *isrc, EHapType type,
                                const char *descr) {
    RISCV_event_set(&config_done_);
}

void CpuRiscV_RTL::stop() {
    sc_stop();
    if (i_vcd_) {
        //sc_close_vcd_trace_file(vcd_);
    }

    IThread::stop();
}

void CpuRiscV_RTL::busyLoop() {
    RISCV_event_wait(&config_done_);

    sc_start();
}

}  // namespace debugger

