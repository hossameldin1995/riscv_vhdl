-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 18.0 (Release Build #614)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2018 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from FP_ADD_SUB_64
-- VHDL created on Sat Jun 20 10:39:20 2020


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity FP_ADD_SUB_64 is
    port (
        a : in std_logic_vector(63 downto 0);  -- float64_m52
        b : in std_logic_vector(63 downto 0);  -- float64_m52
        opSel : in std_logic_vector(0 downto 0);  -- ufix1
        q : out std_logic_vector(63 downto 0);  -- float64_m52
        clk : in std_logic;
        areset : in std_logic
    );
end FP_ADD_SUB_64;

architecture normal of FP_ADD_SUB_64 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signB_uid6_fpAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal restB_uid7_fpAddSubTest_b : STD_LOGIC_VECTOR (62 downto 0);
    signal invSignB_uid8_fpAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal muxSignB_uid9_fpAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal muxSignB_uid9_fpAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal bOperand_uid10_fpAddSubTest_q : STD_LOGIC_VECTOR (63 downto 0);
    signal expFracX_uid15_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (62 downto 0);
    signal expFracY_uid16_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (62 downto 0);
    signal xGTEy_uid17_fpAddSubTest_ieeeAdd_a : STD_LOGIC_VECTOR (64 downto 0);
    signal xGTEy_uid17_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (64 downto 0);
    signal xGTEy_uid17_fpAddSubTest_ieeeAdd_o : STD_LOGIC_VECTOR (64 downto 0);
    signal xGTEy_uid17_fpAddSubTest_ieeeAdd_n : STD_LOGIC_VECTOR (0 downto 0);
    signal fracY_uid18_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (51 downto 0);
    signal expY_uid19_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (10 downto 0);
    signal sigY_uid20_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal ypn_uid21_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (63 downto 0);
    signal aSig_uid25_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal aSig_uid25_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (63 downto 0);
    signal bSig_uid26_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal bSig_uid26_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (63 downto 0);
    signal cstAllOWE_uid27_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (10 downto 0);
    signal cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (51 downto 0);
    signal cstAllZWE_uid29_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (10 downto 0);
    signal exp_aSig_uid30_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (62 downto 0);
    signal exp_aSig_uid30_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (10 downto 0);
    signal frac_aSig_uid31_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (51 downto 0);
    signal frac_aSig_uid31_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (51 downto 0);
    signal excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid33_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid34_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid34_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid35_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_aSig_uid36_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_aSig_uid37_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_aSig_uid37_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid38_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid39_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_aSig_uid40_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal exp_bSig_uid44_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (62 downto 0);
    signal exp_bSig_uid44_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (10 downto 0);
    signal frac_bSig_uid45_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (51 downto 0);
    signal frac_bSig_uid45_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (51 downto 0);
    signal excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid47_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid48_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid49_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_bSig_uid50_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_bSig_uid50_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_bSig_uid51_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_bSig_uid51_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid52_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid53_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_bSig_uid54_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_bSig_uid54_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigA_uid59_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal sigB_uid60_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal effSub_uid61_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracBz_uid65_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracBz_uid65_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (51 downto 0);
    signal oFracB_uid68_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (52 downto 0);
    signal expAmExpB_uid69_fpAddSubTest_ieeeAdd_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expAmExpB_uid69_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expAmExpB_uid69_fpAddSubTest_ieeeAdd_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expAmExpB_uid69_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (11 downto 0);
    signal cWFP2_uid70_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (5 downto 0);
    signal shiftedOut_uid72_fpAddSubTest_ieeeAdd_a : STD_LOGIC_VECTOR (13 downto 0);
    signal shiftedOut_uid72_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (13 downto 0);
    signal shiftedOut_uid72_fpAddSubTest_ieeeAdd_o : STD_LOGIC_VECTOR (13 downto 0);
    signal shiftedOut_uid72_fpAddSubTest_ieeeAdd_c : STD_LOGIC_VECTOR (0 downto 0);
    signal padConst_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (53 downto 0);
    signal rightPaddedIn_uid74_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal iShiftedOut_uid76_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (106 downto 0);
    signal alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (106 downto 0);
    signal alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal cmpEQ_stickyBits_cZwF_uid80_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invCmpEQ_stickyBits_cZwF_uid81_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal invCmpEQ_stickyBits_cZwF_uid81_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal effSubInvSticky_uid83_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal zocst_uid85_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (1 downto 0);
    signal fracAAddOp_uid86_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (55 downto 0);
    signal fracBAddOp_uid89_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (55 downto 0);
    signal fracBAddOpPostXor_uid90_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (55 downto 0);
    signal fracBAddOpPostXor_uid90_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (55 downto 0);
    signal fracAddResult_uid91_fpAddSubTest_ieeeAdd_a : STD_LOGIC_VECTOR (56 downto 0);
    signal fracAddResult_uid91_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (56 downto 0);
    signal fracAddResult_uid91_fpAddSubTest_ieeeAdd_o : STD_LOGIC_VECTOR (56 downto 0);
    signal fracAddResult_uid91_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (55 downto 0);
    signal rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (55 downto 0);
    signal fracGRS_uid93_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal cAmA_uid95_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (5 downto 0);
    signal aMinusA_uid96_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracPostNorm_uid98_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (55 downto 0);
    signal oneCST_uid99_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (10 downto 0);
    signal expInc_uid100_fpAddSubTest_ieeeAdd_a : STD_LOGIC_VECTOR (11 downto 0);
    signal expInc_uid100_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (11 downto 0);
    signal expInc_uid100_fpAddSubTest_ieeeAdd_o : STD_LOGIC_VECTOR (11 downto 0);
    signal expInc_uid100_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (11 downto 0);
    signal expPostNorm_uid101_fpAddSubTest_ieeeAdd_a : STD_LOGIC_VECTOR (12 downto 0);
    signal expPostNorm_uid101_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (12 downto 0);
    signal expPostNorm_uid101_fpAddSubTest_ieeeAdd_o : STD_LOGIC_VECTOR (12 downto 0);
    signal expPostNorm_uid101_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (12 downto 0);
    signal Sticky0_uid102_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (0 downto 0);
    signal Sticky0_uid102_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Sticky1_uid103_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (1 downto 0);
    signal Sticky1_uid103_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Round_uid104_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (2 downto 0);
    signal Round_uid104_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Guard_uid105_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (3 downto 0);
    signal Guard_uid105_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal LSB_uid106_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (4 downto 0);
    signal LSB_uid106_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rndBitCond_uid107_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (4 downto 0);
    signal cRBit_uid108_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (4 downto 0);
    signal rBi_uid109_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal roundBit_uid110_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracPostNormRndRange_uid111_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (54 downto 0);
    signal fracPostNormRndRange_uid111_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (52 downto 0);
    signal expFracR_uid112_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (65 downto 0);
    signal rndExpFrac_uid113_fpAddSubTest_ieeeAdd_a : STD_LOGIC_VECTOR (66 downto 0);
    signal rndExpFrac_uid113_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (66 downto 0);
    signal rndExpFrac_uid113_fpAddSubTest_ieeeAdd_o : STD_LOGIC_VECTOR (66 downto 0);
    signal rndExpFrac_uid113_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (66 downto 0);
    signal wEP2AllOwE_uid114_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (12 downto 0);
    signal rndExp_uid115_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (65 downto 0);
    signal rndExp_uid115_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (12 downto 0);
    signal rOvfEQMax_uid116_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rndExpFracOvfBits_uid118_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (65 downto 0);
    signal rndExpFracOvfBits_uid118_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rOvfExtraBits_uid119_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rOvf_uid120_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal wEP2AllZ_uid121_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (12 downto 0);
    signal rUdfEQMin_uid122_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rUdfExtraBit_uid123_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (65 downto 0);
    signal rUdfExtraBit_uid123_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rUdf_uid124_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPreExc_uid125_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (52 downto 0);
    signal fracRPreExc_uid125_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (51 downto 0);
    signal expRPreExc_uid126_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (63 downto 0);
    signal expRPreExc_uid126_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (10 downto 0);
    signal regInputs_uid127_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal regInputs_uid127_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZeroVInC_uid128_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (4 downto 0);
    signal excRZero_uid129_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal rInfOvf_uid130_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInfVInC_uid131_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (5 downto 0);
    signal excRInf_uid132_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN2_uid133_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAIBISub_uid134_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaN_uid135_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExc_uid136_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREnc_uid137_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (1 downto 0);
    signal invAMinusA_uid138_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRReg_uid139_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigBBInf_uid140_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigAAInf_uid141_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInf_uid142_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excAZBZSigASigB_uid143_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excBZARSigA_uid144_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRZero_uid145_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInfRZRReg_uid146_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal signRInfRZRReg_uid146_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcRNaN_uid147_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid148_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oneFracRPostExc2_uid149_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (51 downto 0);
    signal fracRPostExc_uid152_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExc_uid152_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (51 downto 0);
    signal expRPostExc_uid156_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExc_uid156_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (10 downto 0);
    signal R_uid157_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (63 downto 0);
    signal zs_uid159_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (31 downto 0);
    signal rVStage_uid160_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (31 downto 0);
    signal vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal mO_uid162_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (6 downto 0);
    signal vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (24 downto 0);
    signal vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (24 downto 0);
    signal cStage_uid164_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (31 downto 0);
    signal vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (31 downto 0);
    signal zs_uid167_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (15 downto 0);
    signal zs_uid173_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (7 downto 0);
    signal vCount_uid175_lzCountVal_uid94_fpAddSubTest_ieeeAdd_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal vCount_uid175_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (7 downto 0);
    signal zs_uid179_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vCount_uid181_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (3 downto 0);
    signal zs_uid185_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (1 downto 0);
    signal vCount_uid187_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid192_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal vCount_uid193_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (5 downto 0);
    signal wIntCst_uid198_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (6 downto 0);
    signal shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_a : STD_LOGIC_VECTOR (13 downto 0);
    signal shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (13 downto 0);
    signal shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_o : STD_LOGIC_VECTOR (13 downto 0);
    signal shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_n : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage0Idx1Rng32_uid200_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (74 downto 0);
    signal rightShiftStage0Idx1_uid202_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage0Idx2Rng64_uid203_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (42 downto 0);
    signal rightShiftStage0Idx2Pad64_uid204_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (63 downto 0);
    signal rightShiftStage0Idx2_uid205_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage0Idx3Rng96_uid206_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (10 downto 0);
    signal rightShiftStage0Idx3Pad96_uid207_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (95 downto 0);
    signal rightShiftStage0Idx3_uid208_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage1Idx1Rng8_uid211_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (98 downto 0);
    signal rightShiftStage1Idx1_uid213_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage1Idx2Rng16_uid214_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (90 downto 0);
    signal rightShiftStage1Idx2_uid216_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage1Idx3Rng24_uid217_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (82 downto 0);
    signal rightShiftStage1Idx3Pad24_uid218_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (23 downto 0);
    signal rightShiftStage1Idx3_uid219_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage2Idx1Rng2_uid222_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (104 downto 0);
    signal rightShiftStage2Idx1_uid224_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage2Idx2Rng4_uid225_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (102 downto 0);
    signal rightShiftStage2Idx2_uid227_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage2Idx3Rng6_uid228_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (100 downto 0);
    signal rightShiftStage2Idx3Pad6_uid229_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (5 downto 0);
    signal rightShiftStage2Idx3_uid230_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage3Idx1Rng1_uid233_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (105 downto 0);
    signal rightShiftStage3Idx1_uid235_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal zeroOutCst_uid238_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (106 downto 0);
    signal leftShiftStage0Idx1Rng16_uid244_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (40 downto 0);
    signal leftShiftStage0Idx1Rng16_uid244_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (40 downto 0);
    signal leftShiftStage0Idx1_uid245_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage0Idx2_uid248_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage0Idx3Pad48_uid249_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (47 downto 0);
    signal leftShiftStage0Idx3Rng48_uid250_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (8 downto 0);
    signal leftShiftStage0Idx3Rng48_uid250_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (8 downto 0);
    signal leftShiftStage0Idx3_uid251_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage1Idx1Rng4_uid255_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (52 downto 0);
    signal leftShiftStage1Idx1Rng4_uid255_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (52 downto 0);
    signal leftShiftStage1Idx1_uid256_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage1Idx2Rng8_uid258_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (48 downto 0);
    signal leftShiftStage1Idx2Rng8_uid258_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (48 downto 0);
    signal leftShiftStage1Idx2_uid259_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage1Idx3Pad12_uid260_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (11 downto 0);
    signal leftShiftStage1Idx3Rng12_uid261_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (44 downto 0);
    signal leftShiftStage1Idx3Rng12_uid261_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (44 downto 0);
    signal leftShiftStage1Idx3_uid262_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage2Idx1Rng1_uid266_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (55 downto 0);
    signal leftShiftStage2Idx1Rng1_uid266_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (55 downto 0);
    signal leftShiftStage2Idx1_uid267_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage2Idx2Rng2_uid269_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (54 downto 0);
    signal leftShiftStage2Idx2Rng2_uid269_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (54 downto 0);
    signal leftShiftStage2Idx2_uid270_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage2Idx3Pad3_uid271_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (2 downto 0);
    signal leftShiftStage2Idx3Rng3_uid272_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in : STD_LOGIC_VECTOR (53 downto 0);
    signal leftShiftStage2Idx3Rng3_uid272_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b : STD_LOGIC_VECTOR (53 downto 0);
    signal leftShiftStage2Idx3_uid273_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q : STD_LOGIC_VECTOR (56 downto 0);
    signal rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_in : STD_LOGIC_VECTOR (6 downto 0);
    signal rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_d : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_e : STD_LOGIC_VECTOR (0 downto 0);
    signal stickyBits_uid78_fpAddSubTest_ieeeAdd_merged_bit_select_b : STD_LOGIC_VECTOR (51 downto 0);
    signal stickyBits_uid78_fpAddSubTest_ieeeAdd_merged_bit_select_c : STD_LOGIC_VECTOR (54 downto 0);
    signal rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b : STD_LOGIC_VECTOR (15 downto 0);
    signal rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c : STD_LOGIC_VECTOR (15 downto 0);
    signal rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_d : STD_LOGIC_VECTOR (1 downto 0);
    signal redist0_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_c_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist1_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_d_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist2_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist3_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c_1_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist4_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_d_1_q : STD_LOGIC_VECTOR (1 downto 0);
    signal redist5_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_e_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist6_r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q : STD_LOGIC_VECTOR (5 downto 0);
    signal redist7_vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist8_vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b_1_q : STD_LOGIC_VECTOR (24 downto 0);
    signal redist9_vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_aMinusA_uid96_fpAddSubTest_ieeeAdd_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist11_fracGRS_uid93_fpAddSubTest_ieeeAdd_q_1_q : STD_LOGIC_VECTOR (56 downto 0);
    signal redist12_rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_b_1_q : STD_LOGIC_VECTOR (55 downto 0);
    signal redist13_effSub_uid61_fpAddSubTest_ieeeAdd_q_4_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist14_sigB_uid60_fpAddSubTest_ieeeAdd_b_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist15_sigB_uid60_fpAddSubTest_ieeeAdd_b_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_sigA_uid59_fpAddSubTest_ieeeAdd_b_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist17_sigA_uid59_fpAddSubTest_ieeeAdd_b_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist18_excR_bSig_uid54_fpAddSubTest_ieeeAdd_q_5_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist19_excN_bSig_uid51_fpAddSubTest_ieeeAdd_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist20_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_5_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist21_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist22_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_5_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist23_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_6_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist24_frac_bSig_uid45_fpAddSubTest_ieeeAdd_b_1_q : STD_LOGIC_VECTOR (51 downto 0);
    signal redist25_exp_bSig_uid44_fpAddSubTest_ieeeAdd_b_1_q : STD_LOGIC_VECTOR (10 downto 0);
    signal redist26_excI_aSig_uid36_fpAddSubTest_ieeeAdd_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist27_fracXIsZero_uid34_fpAddSubTest_ieeeAdd_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist28_excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3_q : STD_LOGIC_VECTOR (51 downto 0);
    signal redist30_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_1_q : STD_LOGIC_VECTOR (10 downto 0);
    signal redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_q : STD_LOGIC_VECTOR (10 downto 0);
    signal redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3_inputreg_q : STD_LOGIC_VECTOR (51 downto 0);
    signal redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_inputreg_q : STD_LOGIC_VECTOR (10 downto 0);
    signal redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_outputreg_q : STD_LOGIC_VECTOR (10 downto 0);

begin


    -- cAmA_uid95_fpAddSubTest_ieeeAdd(CONSTANT,94)
    cAmA_uid95_fpAddSubTest_ieeeAdd_q <= "111001";

    -- zs_uid159_lzCountVal_uid94_fpAddSubTest_ieeeAdd(CONSTANT,158)
    zs_uid159_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "00000000000000000000000000000000";

    -- signB_uid6_fpAddSubTest(BITSELECT,5)@0
    signB_uid6_fpAddSubTest_b <= STD_LOGIC_VECTOR(b(63 downto 63));

    -- invSignB_uid8_fpAddSubTest(LOGICAL,7)@0
    invSignB_uid8_fpAddSubTest_q <= not (signB_uid6_fpAddSubTest_b);

    -- muxSignB_uid9_fpAddSubTest(MUX,8)@0
    muxSignB_uid9_fpAddSubTest_s <= opSel;
    muxSignB_uid9_fpAddSubTest_combproc: PROCESS (muxSignB_uid9_fpAddSubTest_s, invSignB_uid8_fpAddSubTest_q, signB_uid6_fpAddSubTest_b)
    BEGIN
        CASE (muxSignB_uid9_fpAddSubTest_s) IS
            WHEN "0" => muxSignB_uid9_fpAddSubTest_q <= invSignB_uid8_fpAddSubTest_q;
            WHEN "1" => muxSignB_uid9_fpAddSubTest_q <= signB_uid6_fpAddSubTest_b;
            WHEN OTHERS => muxSignB_uid9_fpAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- restB_uid7_fpAddSubTest(BITSELECT,6)@0
    restB_uid7_fpAddSubTest_b <= b(62 downto 0);

    -- bOperand_uid10_fpAddSubTest(BITJOIN,9)@0
    bOperand_uid10_fpAddSubTest_q <= muxSignB_uid9_fpAddSubTest_q & restB_uid7_fpAddSubTest_b;

    -- sigY_uid20_fpAddSubTest_ieeeAdd(BITSELECT,19)@0
    sigY_uid20_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(bOperand_uid10_fpAddSubTest_q(63 downto 63));

    -- expY_uid19_fpAddSubTest_ieeeAdd(BITSELECT,18)@0
    expY_uid19_fpAddSubTest_ieeeAdd_b <= bOperand_uid10_fpAddSubTest_q(62 downto 52);

    -- fracY_uid18_fpAddSubTest_ieeeAdd(BITSELECT,17)@0
    fracY_uid18_fpAddSubTest_ieeeAdd_b <= bOperand_uid10_fpAddSubTest_q(51 downto 0);

    -- ypn_uid21_fpAddSubTest_ieeeAdd(BITJOIN,20)@0
    ypn_uid21_fpAddSubTest_ieeeAdd_q <= sigY_uid20_fpAddSubTest_ieeeAdd_b & expY_uid19_fpAddSubTest_ieeeAdd_b & fracY_uid18_fpAddSubTest_ieeeAdd_b;

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- expFracY_uid16_fpAddSubTest_ieeeAdd(BITSELECT,15)@0
    expFracY_uid16_fpAddSubTest_ieeeAdd_b <= bOperand_uid10_fpAddSubTest_q(62 downto 0);

    -- expFracX_uid15_fpAddSubTest_ieeeAdd(BITSELECT,14)@0
    expFracX_uid15_fpAddSubTest_ieeeAdd_b <= a(62 downto 0);

    -- xGTEy_uid17_fpAddSubTest_ieeeAdd(COMPARE,16)@0
    xGTEy_uid17_fpAddSubTest_ieeeAdd_a <= STD_LOGIC_VECTOR("00" & expFracX_uid15_fpAddSubTest_ieeeAdd_b);
    xGTEy_uid17_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR("00" & expFracY_uid16_fpAddSubTest_ieeeAdd_b);
    xGTEy_uid17_fpAddSubTest_ieeeAdd_o <= STD_LOGIC_VECTOR(UNSIGNED(xGTEy_uid17_fpAddSubTest_ieeeAdd_a) - UNSIGNED(xGTEy_uid17_fpAddSubTest_ieeeAdd_b));
    xGTEy_uid17_fpAddSubTest_ieeeAdd_n(0) <= not (xGTEy_uid17_fpAddSubTest_ieeeAdd_o(64));

    -- bSig_uid26_fpAddSubTest_ieeeAdd(MUX,25)@0
    bSig_uid26_fpAddSubTest_ieeeAdd_s <= xGTEy_uid17_fpAddSubTest_ieeeAdd_n;
    bSig_uid26_fpAddSubTest_ieeeAdd_combproc: PROCESS (bSig_uid26_fpAddSubTest_ieeeAdd_s, a, ypn_uid21_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (bSig_uid26_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => bSig_uid26_fpAddSubTest_ieeeAdd_q <= a;
            WHEN "1" => bSig_uid26_fpAddSubTest_ieeeAdd_q <= ypn_uid21_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => bSig_uid26_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigB_uid60_fpAddSubTest_ieeeAdd(BITSELECT,59)@0
    sigB_uid60_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(bSig_uid26_fpAddSubTest_ieeeAdd_q(63 downto 63));

    -- redist14_sigB_uid60_fpAddSubTest_ieeeAdd_b_3(DELAY,297)
    redist14_sigB_uid60_fpAddSubTest_ieeeAdd_b_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigB_uid60_fpAddSubTest_ieeeAdd_b, xout => redist14_sigB_uid60_fpAddSubTest_ieeeAdd_b_3_q, clk => clk, aclr => areset );

    -- aSig_uid25_fpAddSubTest_ieeeAdd(MUX,24)@0
    aSig_uid25_fpAddSubTest_ieeeAdd_s <= xGTEy_uid17_fpAddSubTest_ieeeAdd_n;
    aSig_uid25_fpAddSubTest_ieeeAdd_combproc: PROCESS (aSig_uid25_fpAddSubTest_ieeeAdd_s, ypn_uid21_fpAddSubTest_ieeeAdd_q, a)
    BEGIN
        CASE (aSig_uid25_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => aSig_uid25_fpAddSubTest_ieeeAdd_q <= ypn_uid21_fpAddSubTest_ieeeAdd_q;
            WHEN "1" => aSig_uid25_fpAddSubTest_ieeeAdd_q <= a;
            WHEN OTHERS => aSig_uid25_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigA_uid59_fpAddSubTest_ieeeAdd(BITSELECT,58)@0
    sigA_uid59_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(aSig_uid25_fpAddSubTest_ieeeAdd_q(63 downto 63));

    -- redist16_sigA_uid59_fpAddSubTest_ieeeAdd_b_3(DELAY,299)
    redist16_sigA_uid59_fpAddSubTest_ieeeAdd_b_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigA_uid59_fpAddSubTest_ieeeAdd_b, xout => redist16_sigA_uid59_fpAddSubTest_ieeeAdd_b_3_q, clk => clk, aclr => areset );

    -- effSub_uid61_fpAddSubTest_ieeeAdd(LOGICAL,60)@3
    effSub_uid61_fpAddSubTest_ieeeAdd_q <= redist16_sigA_uid59_fpAddSubTest_ieeeAdd_b_3_q xor redist14_sigB_uid60_fpAddSubTest_ieeeAdd_b_3_q;

    -- exp_bSig_uid44_fpAddSubTest_ieeeAdd(BITSELECT,43)@0
    exp_bSig_uid44_fpAddSubTest_ieeeAdd_in <= bSig_uid26_fpAddSubTest_ieeeAdd_q(62 downto 0);
    exp_bSig_uid44_fpAddSubTest_ieeeAdd_b <= exp_bSig_uid44_fpAddSubTest_ieeeAdd_in(62 downto 52);

    -- redist25_exp_bSig_uid44_fpAddSubTest_ieeeAdd_b_1(DELAY,308)
    redist25_exp_bSig_uid44_fpAddSubTest_ieeeAdd_b_1 : dspba_delay
    GENERIC MAP ( width => 11, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => exp_bSig_uid44_fpAddSubTest_ieeeAdd_b, xout => redist25_exp_bSig_uid44_fpAddSubTest_ieeeAdd_b_1_q, clk => clk, aclr => areset );

    -- exp_aSig_uid30_fpAddSubTest_ieeeAdd(BITSELECT,29)@0
    exp_aSig_uid30_fpAddSubTest_ieeeAdd_in <= aSig_uid25_fpAddSubTest_ieeeAdd_q(62 downto 0);
    exp_aSig_uid30_fpAddSubTest_ieeeAdd_b <= exp_aSig_uid30_fpAddSubTest_ieeeAdd_in(62 downto 52);

    -- redist30_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_1(DELAY,313)
    redist30_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_1 : dspba_delay
    GENERIC MAP ( width => 11, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => exp_aSig_uid30_fpAddSubTest_ieeeAdd_b, xout => redist30_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_1_q, clk => clk, aclr => areset );

    -- expAmExpB_uid69_fpAddSubTest_ieeeAdd(SUB,68)@1
    expAmExpB_uid69_fpAddSubTest_ieeeAdd_a <= STD_LOGIC_VECTOR("0" & redist30_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_1_q);
    expAmExpB_uid69_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR("0" & redist25_exp_bSig_uid44_fpAddSubTest_ieeeAdd_b_1_q);
    expAmExpB_uid69_fpAddSubTest_ieeeAdd_o <= STD_LOGIC_VECTOR(UNSIGNED(expAmExpB_uid69_fpAddSubTest_ieeeAdd_a) - UNSIGNED(expAmExpB_uid69_fpAddSubTest_ieeeAdd_b));
    expAmExpB_uid69_fpAddSubTest_ieeeAdd_q <= expAmExpB_uid69_fpAddSubTest_ieeeAdd_o(11 downto 0);

    -- cWFP2_uid70_fpAddSubTest_ieeeAdd(CONSTANT,69)
    cWFP2_uid70_fpAddSubTest_ieeeAdd_q <= "110110";

    -- shiftedOut_uid72_fpAddSubTest_ieeeAdd(COMPARE,71)@1 + 1
    shiftedOut_uid72_fpAddSubTest_ieeeAdd_a <= STD_LOGIC_VECTOR("00000000" & cWFP2_uid70_fpAddSubTest_ieeeAdd_q);
    shiftedOut_uid72_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR("00" & expAmExpB_uid69_fpAddSubTest_ieeeAdd_q);
    shiftedOut_uid72_fpAddSubTest_ieeeAdd_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            shiftedOut_uid72_fpAddSubTest_ieeeAdd_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            shiftedOut_uid72_fpAddSubTest_ieeeAdd_o <= STD_LOGIC_VECTOR(UNSIGNED(shiftedOut_uid72_fpAddSubTest_ieeeAdd_a) - UNSIGNED(shiftedOut_uid72_fpAddSubTest_ieeeAdd_b));
        END IF;
    END PROCESS;
    shiftedOut_uid72_fpAddSubTest_ieeeAdd_c(0) <= shiftedOut_uid72_fpAddSubTest_ieeeAdd_o(13);

    -- iShiftedOut_uid76_fpAddSubTest_ieeeAdd(LOGICAL,75)@2
    iShiftedOut_uid76_fpAddSubTest_ieeeAdd_q <= not (shiftedOut_uid72_fpAddSubTest_ieeeAdd_c);

    -- zeroOutCst_uid238_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(CONSTANT,237)
    zeroOutCst_uid238_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

    -- rightShiftStage3Idx1Rng1_uid233_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,232)@2
    rightShiftStage3Idx1Rng1_uid233_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q(106 downto 1);

    -- rightShiftStage3Idx1_uid235_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,234)@2
    rightShiftStage3Idx1_uid235_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= GND_q & rightShiftStage3Idx1Rng1_uid233_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- rightShiftStage2Idx3Pad6_uid229_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(CONSTANT,228)
    rightShiftStage2Idx3Pad6_uid229_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= "000000";

    -- rightShiftStage2Idx3Rng6_uid228_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,227)@2
    rightShiftStage2Idx3Rng6_uid228_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q(106 downto 6);

    -- rightShiftStage2Idx3_uid230_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,229)@2
    rightShiftStage2Idx3_uid230_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage2Idx3Pad6_uid229_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q & rightShiftStage2Idx3Rng6_uid228_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- zs_uid179_lzCountVal_uid94_fpAddSubTest_ieeeAdd(CONSTANT,178)
    zs_uid179_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "0000";

    -- rightShiftStage2Idx2Rng4_uid225_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,224)@2
    rightShiftStage2Idx2Rng4_uid225_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q(106 downto 4);

    -- rightShiftStage2Idx2_uid227_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,226)@2
    rightShiftStage2Idx2_uid227_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= zs_uid179_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q & rightShiftStage2Idx2Rng4_uid225_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- zs_uid185_lzCountVal_uid94_fpAddSubTest_ieeeAdd(CONSTANT,184)
    zs_uid185_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "00";

    -- rightShiftStage2Idx1Rng2_uid222_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,221)@2
    rightShiftStage2Idx1Rng2_uid222_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q(106 downto 2);

    -- rightShiftStage2Idx1_uid224_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,223)@2
    rightShiftStage2Idx1_uid224_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= zs_uid185_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q & rightShiftStage2Idx1Rng2_uid222_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- rightShiftStage1Idx3Pad24_uid218_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(CONSTANT,217)
    rightShiftStage1Idx3Pad24_uid218_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= "000000000000000000000000";

    -- rightShiftStage1Idx3Rng24_uid217_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,216)@1
    rightShiftStage1Idx3Rng24_uid217_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q(106 downto 24);

    -- rightShiftStage1Idx3_uid219_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,218)@1
    rightShiftStage1Idx3_uid219_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage1Idx3Pad24_uid218_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q & rightShiftStage1Idx3Rng24_uid217_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- zs_uid167_lzCountVal_uid94_fpAddSubTest_ieeeAdd(CONSTANT,166)
    zs_uid167_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "0000000000000000";

    -- rightShiftStage1Idx2Rng16_uid214_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,213)@1
    rightShiftStage1Idx2Rng16_uid214_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q(106 downto 16);

    -- rightShiftStage1Idx2_uid216_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,215)@1
    rightShiftStage1Idx2_uid216_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= zs_uid167_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q & rightShiftStage1Idx2Rng16_uid214_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- zs_uid173_lzCountVal_uid94_fpAddSubTest_ieeeAdd(CONSTANT,172)
    zs_uid173_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "00000000";

    -- rightShiftStage1Idx1Rng8_uid211_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,210)@1
    rightShiftStage1Idx1Rng8_uid211_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q(106 downto 8);

    -- rightShiftStage1Idx1_uid213_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,212)@1
    rightShiftStage1Idx1_uid213_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= zs_uid173_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q & rightShiftStage1Idx1Rng8_uid211_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- rightShiftStage0Idx3Pad96_uid207_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(CONSTANT,206)
    rightShiftStage0Idx3Pad96_uid207_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

    -- rightShiftStage0Idx3Rng96_uid206_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,205)@1
    rightShiftStage0Idx3Rng96_uid206_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightPaddedIn_uid74_fpAddSubTest_ieeeAdd_q(106 downto 96);

    -- rightShiftStage0Idx3_uid208_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,207)@1
    rightShiftStage0Idx3_uid208_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage0Idx3Pad96_uid207_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q & rightShiftStage0Idx3Rng96_uid206_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- rightShiftStage0Idx2Pad64_uid204_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(CONSTANT,203)
    rightShiftStage0Idx2Pad64_uid204_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= "0000000000000000000000000000000000000000000000000000000000000000";

    -- rightShiftStage0Idx2Rng64_uid203_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,202)@1
    rightShiftStage0Idx2Rng64_uid203_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightPaddedIn_uid74_fpAddSubTest_ieeeAdd_q(106 downto 64);

    -- rightShiftStage0Idx2_uid205_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,204)@1
    rightShiftStage0Idx2_uid205_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage0Idx2Pad64_uid204_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q & rightShiftStage0Idx2Rng64_uid203_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- rightShiftStage0Idx1Rng32_uid200_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITSELECT,199)@1
    rightShiftStage0Idx1Rng32_uid200_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= rightPaddedIn_uid74_fpAddSubTest_ieeeAdd_q(106 downto 32);

    -- rightShiftStage0Idx1_uid202_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(BITJOIN,201)@1
    rightShiftStage0Idx1_uid202_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= zs_uid159_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q & rightShiftStage0Idx1Rng32_uid200_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b;

    -- cstAllZWE_uid29_fpAddSubTest_ieeeAdd(CONSTANT,28)
    cstAllZWE_uid29_fpAddSubTest_ieeeAdd_q <= "00000000000";

    -- excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd(LOGICAL,45)@1
    excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q <= "1" WHEN redist25_exp_bSig_uid44_fpAddSubTest_ieeeAdd_b_1_q = cstAllZWE_uid29_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- InvExpXIsZero_uid53_fpAddSubTest_ieeeAdd(LOGICAL,52)@1
    InvExpXIsZero_uid53_fpAddSubTest_ieeeAdd_q <= not (excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q);

    -- cstZeroWF_uid28_fpAddSubTest_ieeeAdd(CONSTANT,27)
    cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q <= "0000000000000000000000000000000000000000000000000000";

    -- frac_bSig_uid45_fpAddSubTest_ieeeAdd(BITSELECT,44)@0
    frac_bSig_uid45_fpAddSubTest_ieeeAdd_in <= bSig_uid26_fpAddSubTest_ieeeAdd_q(51 downto 0);
    frac_bSig_uid45_fpAddSubTest_ieeeAdd_b <= frac_bSig_uid45_fpAddSubTest_ieeeAdd_in(51 downto 0);

    -- redist24_frac_bSig_uid45_fpAddSubTest_ieeeAdd_b_1(DELAY,307)
    redist24_frac_bSig_uid45_fpAddSubTest_ieeeAdd_b_1 : dspba_delay
    GENERIC MAP ( width => 52, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => frac_bSig_uid45_fpAddSubTest_ieeeAdd_b, xout => redist24_frac_bSig_uid45_fpAddSubTest_ieeeAdd_b_1_q, clk => clk, aclr => areset );

    -- fracBz_uid65_fpAddSubTest_ieeeAdd(MUX,64)@1
    fracBz_uid65_fpAddSubTest_ieeeAdd_s <= excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q;
    fracBz_uid65_fpAddSubTest_ieeeAdd_combproc: PROCESS (fracBz_uid65_fpAddSubTest_ieeeAdd_s, redist24_frac_bSig_uid45_fpAddSubTest_ieeeAdd_b_1_q, cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (fracBz_uid65_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => fracBz_uid65_fpAddSubTest_ieeeAdd_q <= redist24_frac_bSig_uid45_fpAddSubTest_ieeeAdd_b_1_q;
            WHEN "1" => fracBz_uid65_fpAddSubTest_ieeeAdd_q <= cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => fracBz_uid65_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oFracB_uid68_fpAddSubTest_ieeeAdd(BITJOIN,67)@1
    oFracB_uid68_fpAddSubTest_ieeeAdd_q <= InvExpXIsZero_uid53_fpAddSubTest_ieeeAdd_q & fracBz_uid65_fpAddSubTest_ieeeAdd_q;

    -- padConst_uid73_fpAddSubTest_ieeeAdd(CONSTANT,72)
    padConst_uid73_fpAddSubTest_ieeeAdd_q <= "000000000000000000000000000000000000000000000000000000";

    -- rightPaddedIn_uid74_fpAddSubTest_ieeeAdd(BITJOIN,73)@1
    rightPaddedIn_uid74_fpAddSubTest_ieeeAdd_q <= oFracB_uid68_fpAddSubTest_ieeeAdd_q & padConst_uid73_fpAddSubTest_ieeeAdd_q;

    -- rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(MUX,209)@1
    rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s <= rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_b;
    rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_combproc: PROCESS (rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s, rightPaddedIn_uid74_fpAddSubTest_ieeeAdd_q, rightShiftStage0Idx1_uid202_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q, rightShiftStage0Idx2_uid205_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q, rightShiftStage0Idx3_uid208_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s) IS
            WHEN "00" => rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightPaddedIn_uid74_fpAddSubTest_ieeeAdd_q;
            WHEN "01" => rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage0Idx1_uid202_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN "10" => rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage0Idx2_uid205_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN "11" => rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage0Idx3_uid208_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select(BITSELECT,276)@1
    rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_in <= expAmExpB_uid69_fpAddSubTest_ieeeAdd_q(6 downto 0);
    rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_b <= rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_in(6 downto 5);
    rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_c <= rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_in(4 downto 3);
    rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_d <= rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_in(2 downto 1);
    rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_e <= rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_in(0 downto 0);

    -- rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(MUX,220)@1 + 1
    rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s <= rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_c;
    rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s) IS
                WHEN "00" => rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage0_uid210_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
                WHEN "01" => rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage1Idx1_uid213_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
                WHEN "10" => rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage1Idx2_uid216_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
                WHEN "11" => rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage1Idx3_uid219_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
                WHEN OTHERS => rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- redist4_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_d_1(DELAY,287)
    redist4_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_d_1 : dspba_delay
    GENERIC MAP ( width => 2, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_d, xout => redist4_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_d_1_q, clk => clk, aclr => areset );

    -- rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(MUX,231)@2
    rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s <= redist4_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_d_1_q;
    rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_combproc: PROCESS (rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s, rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q, rightShiftStage2Idx1_uid224_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q, rightShiftStage2Idx2_uid227_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q, rightShiftStage2Idx3_uid230_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s) IS
            WHEN "00" => rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage1_uid221_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN "01" => rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage2Idx1_uid224_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN "10" => rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage2Idx2_uid227_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN "11" => rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage2Idx3_uid230_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist5_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_e_1(DELAY,288)
    redist5_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_e_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_e, xout => redist5_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_e_1_q, clk => clk, aclr => areset );

    -- rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(MUX,236)@2
    rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s <= redist5_rightShiftStageSel6Dto5_uid209_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_merged_bit_select_e_1_q;
    rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_combproc: PROCESS (rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s, rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q, rightShiftStage3Idx1_uid235_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage2_uid232_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN "1" => rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage3Idx1_uid235_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- wIntCst_uid198_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(CONSTANT,197)
    wIntCst_uid198_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= "1101011";

    -- shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(COMPARE,198)@1 + 1
    shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_a <= STD_LOGIC_VECTOR("00" & expAmExpB_uid69_fpAddSubTest_ieeeAdd_q);
    shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR("0000000" & wIntCst_uid198_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q);
    shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_o <= STD_LOGIC_VECTOR(UNSIGNED(shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_a) - UNSIGNED(shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_b));
        END IF;
    END PROCESS;
    shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_n(0) <= not (shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_o(13));

    -- r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd(MUX,238)@2
    r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s <= shiftedOut_uid199_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_n;
    r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_combproc: PROCESS (r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s, rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q, zeroOutCst_uid238_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= rightShiftStage3_uid237_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN "1" => r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= zeroOutCst_uid238_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd(LOGICAL,76)@2 + 1
    alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((106 downto 1 => iShiftedOut_uid76_fpAddSubTest_ieeeAdd_q(0)) & iShiftedOut_uid76_fpAddSubTest_ieeeAdd_q));
    alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_qi <= r_uid239_alignmentShifter_uid73_fpAddSubTest_ieeeAdd_q and alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_b;
    alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 107, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_qi, xout => alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- stickyBits_uid78_fpAddSubTest_ieeeAdd_merged_bit_select(BITSELECT,277)@3
    stickyBits_uid78_fpAddSubTest_ieeeAdd_merged_bit_select_b <= alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_q(51 downto 0);
    stickyBits_uid78_fpAddSubTest_ieeeAdd_merged_bit_select_c <= alignFracBPostShiftOut_uid77_fpAddSubTest_ieeeAdd_q(106 downto 52);

    -- fracBAddOp_uid89_fpAddSubTest_ieeeAdd(BITJOIN,88)@3
    fracBAddOp_uid89_fpAddSubTest_ieeeAdd_q <= GND_q & stickyBits_uid78_fpAddSubTest_ieeeAdd_merged_bit_select_c;

    -- fracBAddOpPostXor_uid90_fpAddSubTest_ieeeAdd(LOGICAL,89)@3
    fracBAddOpPostXor_uid90_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((55 downto 1 => effSub_uid61_fpAddSubTest_ieeeAdd_q(0)) & effSub_uid61_fpAddSubTest_ieeeAdd_q));
    fracBAddOpPostXor_uid90_fpAddSubTest_ieeeAdd_q <= fracBAddOp_uid89_fpAddSubTest_ieeeAdd_q xor fracBAddOpPostXor_uid90_fpAddSubTest_ieeeAdd_b;

    -- zocst_uid85_fpAddSubTest_ieeeAdd(CONSTANT,84)
    zocst_uid85_fpAddSubTest_ieeeAdd_q <= "01";

    -- frac_aSig_uid31_fpAddSubTest_ieeeAdd(BITSELECT,30)@0
    frac_aSig_uid31_fpAddSubTest_ieeeAdd_in <= aSig_uid25_fpAddSubTest_ieeeAdd_q(51 downto 0);
    frac_aSig_uid31_fpAddSubTest_ieeeAdd_b <= frac_aSig_uid31_fpAddSubTest_ieeeAdd_in(51 downto 0);

    -- redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3_inputreg(DELAY,315)
    redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3_inputreg : dspba_delay
    GENERIC MAP ( width => 52, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => frac_aSig_uid31_fpAddSubTest_ieeeAdd_b, xout => redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3_inputreg_q, clk => clk, aclr => areset );

    -- redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3(DELAY,312)
    redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3 : dspba_delay
    GENERIC MAP ( width => 52, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3_inputreg_q, xout => redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3_q, clk => clk, aclr => areset );

    -- cmpEQ_stickyBits_cZwF_uid80_fpAddSubTest_ieeeAdd(LOGICAL,79)@3
    cmpEQ_stickyBits_cZwF_uid80_fpAddSubTest_ieeeAdd_q <= "1" WHEN stickyBits_uid78_fpAddSubTest_ieeeAdd_merged_bit_select_b = cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- effSubInvSticky_uid83_fpAddSubTest_ieeeAdd(LOGICAL,82)@3
    effSubInvSticky_uid83_fpAddSubTest_ieeeAdd_q <= effSub_uid61_fpAddSubTest_ieeeAdd_q and cmpEQ_stickyBits_cZwF_uid80_fpAddSubTest_ieeeAdd_q;

    -- fracAAddOp_uid86_fpAddSubTest_ieeeAdd(BITJOIN,85)@3
    fracAAddOp_uid86_fpAddSubTest_ieeeAdd_q <= zocst_uid85_fpAddSubTest_ieeeAdd_q & redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3_q & GND_q & effSubInvSticky_uid83_fpAddSubTest_ieeeAdd_q;

    -- fracAddResult_uid91_fpAddSubTest_ieeeAdd(ADD,90)@3
    fracAddResult_uid91_fpAddSubTest_ieeeAdd_a <= STD_LOGIC_VECTOR("0" & fracAAddOp_uid86_fpAddSubTest_ieeeAdd_q);
    fracAddResult_uid91_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR("0" & fracBAddOpPostXor_uid90_fpAddSubTest_ieeeAdd_q);
    fracAddResult_uid91_fpAddSubTest_ieeeAdd_o <= STD_LOGIC_VECTOR(UNSIGNED(fracAddResult_uid91_fpAddSubTest_ieeeAdd_a) + UNSIGNED(fracAddResult_uid91_fpAddSubTest_ieeeAdd_b));
    fracAddResult_uid91_fpAddSubTest_ieeeAdd_q <= fracAddResult_uid91_fpAddSubTest_ieeeAdd_o(56 downto 0);

    -- rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd(BITSELECT,91)@3
    rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_in <= fracAddResult_uid91_fpAddSubTest_ieeeAdd_q(55 downto 0);
    rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_b <= rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_in(55 downto 0);

    -- redist12_rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_b_1(DELAY,295)
    redist12_rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_b_1 : dspba_delay
    GENERIC MAP ( width => 56, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_b, xout => redist12_rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_b_1_q, clk => clk, aclr => areset );

    -- invCmpEQ_stickyBits_cZwF_uid81_fpAddSubTest_ieeeAdd(LOGICAL,80)@3 + 1
    invCmpEQ_stickyBits_cZwF_uid81_fpAddSubTest_ieeeAdd_qi <= not (cmpEQ_stickyBits_cZwF_uid80_fpAddSubTest_ieeeAdd_q);
    invCmpEQ_stickyBits_cZwF_uid81_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => invCmpEQ_stickyBits_cZwF_uid81_fpAddSubTest_ieeeAdd_qi, xout => invCmpEQ_stickyBits_cZwF_uid81_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- fracGRS_uid93_fpAddSubTest_ieeeAdd(BITJOIN,92)@4
    fracGRS_uid93_fpAddSubTest_ieeeAdd_q <= redist12_rangeFracAddResultMwfp3Dto0_uid92_fpAddSubTest_ieeeAdd_b_1_q & invCmpEQ_stickyBits_cZwF_uid81_fpAddSubTest_ieeeAdd_q;

    -- rVStage_uid160_lzCountVal_uid94_fpAddSubTest_ieeeAdd(BITSELECT,159)@4
    rVStage_uid160_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b <= fracGRS_uid93_fpAddSubTest_ieeeAdd_q(56 downto 25);

    -- vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd(LOGICAL,160)@4
    vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "1" WHEN rVStage_uid160_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b = zs_uid159_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- redist9_vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1(DELAY,292)
    redist9_vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q, xout => redist9_vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q, clk => clk, aclr => areset );

    -- vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd(BITSELECT,162)@4
    vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_in <= fracGRS_uid93_fpAddSubTest_ieeeAdd_q(24 downto 0);
    vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b <= vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_in(24 downto 0);

    -- mO_uid162_lzCountVal_uid94_fpAddSubTest_ieeeAdd(CONSTANT,161)
    mO_uid162_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "1111111";

    -- cStage_uid164_lzCountVal_uid94_fpAddSubTest_ieeeAdd(BITJOIN,163)@4
    cStage_uid164_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b & mO_uid162_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;

    -- vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd(MUX,165)@4
    vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s <= vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;
    vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_combproc: PROCESS (vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s, rVStage_uid160_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b, cStage_uid164_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= rVStage_uid160_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b;
            WHEN "1" => vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= cStage_uid164_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select(BITSELECT,278)@4
    rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b <= vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(31 downto 16);
    rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c <= vStagei_uid166_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(15 downto 0);

    -- vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd(LOGICAL,168)@4
    vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "1" WHEN rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b = zs_uid167_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- redist7_vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1(DELAY,290)
    redist7_vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q, xout => redist7_vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q, clk => clk, aclr => areset );

    -- vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd(MUX,171)@4
    vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s <= vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;
    vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_combproc: PROCESS (vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s, rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b, rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b;
            WHEN "1" => vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= rVStage_uid168_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select(BITSELECT,279)@4
    rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b <= vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(15 downto 8);
    rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c <= vStagei_uid172_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(7 downto 0);

    -- vCount_uid175_lzCountVal_uid94_fpAddSubTest_ieeeAdd(LOGICAL,174)@4 + 1
    vCount_uid175_lzCountVal_uid94_fpAddSubTest_ieeeAdd_qi <= "1" WHEN rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b = zs_uid173_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q ELSE "0";
    vCount_uid175_lzCountVal_uid94_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => vCount_uid175_lzCountVal_uid94_fpAddSubTest_ieeeAdd_qi, xout => vCount_uid175_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- redist3_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c_1(DELAY,286)
    redist3_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c_1 : dspba_delay
    GENERIC MAP ( width => 8, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c, xout => redist3_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c_1_q, clk => clk, aclr => areset );

    -- redist2_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b_1(DELAY,285)
    redist2_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b_1 : dspba_delay
    GENERIC MAP ( width => 8, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b, xout => redist2_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b_1_q, clk => clk, aclr => areset );

    -- vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd(MUX,177)@5
    vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s <= vCount_uid175_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;
    vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_combproc: PROCESS (vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s, redist2_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b_1_q, redist3_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c_1_q)
    BEGIN
        CASE (vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= redist2_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b_1_q;
            WHEN "1" => vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= redist3_rVStage_uid174_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c_1_q;
            WHEN OTHERS => vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select(BITSELECT,280)@5
    rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b <= vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(7 downto 4);
    rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c <= vStagei_uid178_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(3 downto 0);

    -- vCount_uid181_lzCountVal_uid94_fpAddSubTest_ieeeAdd(LOGICAL,180)@5
    vCount_uid181_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "1" WHEN rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b = zs_uid179_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd(MUX,183)@5
    vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s <= vCount_uid181_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;
    vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_combproc: PROCESS (vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s, rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b, rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b;
            WHEN "1" => vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= rVStage_uid180_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select(BITSELECT,281)@5
    rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b <= vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(3 downto 2);
    rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c <= vStagei_uid184_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(1 downto 0);

    -- vCount_uid187_lzCountVal_uid94_fpAddSubTest_ieeeAdd(LOGICAL,186)@5
    vCount_uid187_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "1" WHEN rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b = zs_uid185_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd(MUX,189)@5
    vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s <= vCount_uid187_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;
    vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_combproc: PROCESS (vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s, rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b, rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_s) IS
            WHEN "0" => vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_b;
            WHEN "1" => vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= rVStage_uid186_lzCountVal_uid94_fpAddSubTest_ieeeAdd_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid192_lzCountVal_uid94_fpAddSubTest_ieeeAdd(BITSELECT,191)@5
    rVStage_uid192_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b <= vStagei_uid190_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(1 downto 1);

    -- vCount_uid193_lzCountVal_uid94_fpAddSubTest_ieeeAdd(LOGICAL,192)@5
    vCount_uid193_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= "1" WHEN rVStage_uid192_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b = GND_q ELSE "0";

    -- r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd(BITJOIN,193)@5
    r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q <= redist9_vCount_uid161_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q & redist7_vCount_uid169_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q & vCount_uid175_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q & vCount_uid181_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q & vCount_uid187_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q & vCount_uid193_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;

    -- redist6_r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1(DELAY,289)
    redist6_r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1 : dspba_delay
    GENERIC MAP ( width => 6, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q, xout => redist6_r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q, clk => clk, aclr => areset );

    -- aMinusA_uid96_fpAddSubTest_ieeeAdd(LOGICAL,95)@6
    aMinusA_uid96_fpAddSubTest_ieeeAdd_q <= "1" WHEN redist6_r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q = cAmA_uid95_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- invAMinusA_uid138_fpAddSubTest_ieeeAdd(LOGICAL,137)@6
    invAMinusA_uid138_fpAddSubTest_ieeeAdd_q <= not (aMinusA_uid96_fpAddSubTest_ieeeAdd_q);

    -- redist17_sigA_uid59_fpAddSubTest_ieeeAdd_b_6(DELAY,300)
    redist17_sigA_uid59_fpAddSubTest_ieeeAdd_b_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist16_sigA_uid59_fpAddSubTest_ieeeAdd_b_3_q, xout => redist17_sigA_uid59_fpAddSubTest_ieeeAdd_b_6_q, clk => clk, aclr => areset );

    -- cstAllOWE_uid27_fpAddSubTest_ieeeAdd(CONSTANT,26)
    cstAllOWE_uid27_fpAddSubTest_ieeeAdd_q <= "11111111111";

    -- expXIsMax_uid47_fpAddSubTest_ieeeAdd(LOGICAL,46)@1
    expXIsMax_uid47_fpAddSubTest_ieeeAdd_q <= "1" WHEN redist25_exp_bSig_uid44_fpAddSubTest_ieeeAdd_b_1_q = cstAllOWE_uid27_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- invExpXIsMax_uid52_fpAddSubTest_ieeeAdd(LOGICAL,51)@1
    invExpXIsMax_uid52_fpAddSubTest_ieeeAdd_q <= not (expXIsMax_uid47_fpAddSubTest_ieeeAdd_q);

    -- excR_bSig_uid54_fpAddSubTest_ieeeAdd(LOGICAL,53)@1 + 1
    excR_bSig_uid54_fpAddSubTest_ieeeAdd_qi <= InvExpXIsZero_uid53_fpAddSubTest_ieeeAdd_q and invExpXIsMax_uid52_fpAddSubTest_ieeeAdd_q;
    excR_bSig_uid54_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excR_bSig_uid54_fpAddSubTest_ieeeAdd_qi, xout => excR_bSig_uid54_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- redist18_excR_bSig_uid54_fpAddSubTest_ieeeAdd_q_5(DELAY,301)
    redist18_excR_bSig_uid54_fpAddSubTest_ieeeAdd_q_5 : dspba_delay
    GENERIC MAP ( width => 1, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => excR_bSig_uid54_fpAddSubTest_ieeeAdd_q, xout => redist18_excR_bSig_uid54_fpAddSubTest_ieeeAdd_q_5_q, clk => clk, aclr => areset );

    -- redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_inputreg(DELAY,316)
    redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_inputreg : dspba_delay
    GENERIC MAP ( width => 11, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist30_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_1_q, xout => redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_inputreg_q, clk => clk, aclr => areset );

    -- redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6(DELAY,314)
    redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6 : dspba_delay
    GENERIC MAP ( width => 11, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_inputreg_q, xout => redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_q, clk => clk, aclr => areset );

    -- redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_outputreg(DELAY,317)
    redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_outputreg : dspba_delay
    GENERIC MAP ( width => 11, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_q, xout => redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_outputreg_q, clk => clk, aclr => areset );

    -- expXIsMax_uid33_fpAddSubTest_ieeeAdd(LOGICAL,32)@6
    expXIsMax_uid33_fpAddSubTest_ieeeAdd_q <= "1" WHEN redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_outputreg_q = cstAllOWE_uid27_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- invExpXIsMax_uid38_fpAddSubTest_ieeeAdd(LOGICAL,37)@6
    invExpXIsMax_uid38_fpAddSubTest_ieeeAdd_q <= not (expXIsMax_uid33_fpAddSubTest_ieeeAdd_q);

    -- excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd(LOGICAL,31)@6
    excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q <= "1" WHEN redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_outputreg_q = cstAllZWE_uid29_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- InvExpXIsZero_uid39_fpAddSubTest_ieeeAdd(LOGICAL,38)@6
    InvExpXIsZero_uid39_fpAddSubTest_ieeeAdd_q <= not (excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q);

    -- excR_aSig_uid40_fpAddSubTest_ieeeAdd(LOGICAL,39)@6
    excR_aSig_uid40_fpAddSubTest_ieeeAdd_q <= InvExpXIsZero_uid39_fpAddSubTest_ieeeAdd_q and invExpXIsMax_uid38_fpAddSubTest_ieeeAdd_q;

    -- signRReg_uid139_fpAddSubTest_ieeeAdd(LOGICAL,138)@6
    signRReg_uid139_fpAddSubTest_ieeeAdd_q <= excR_aSig_uid40_fpAddSubTest_ieeeAdd_q and redist18_excR_bSig_uid54_fpAddSubTest_ieeeAdd_q_5_q and redist17_sigA_uid59_fpAddSubTest_ieeeAdd_b_6_q and invAMinusA_uid138_fpAddSubTest_ieeeAdd_q;

    -- redist15_sigB_uid60_fpAddSubTest_ieeeAdd_b_6(DELAY,298)
    redist15_sigB_uid60_fpAddSubTest_ieeeAdd_b_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist14_sigB_uid60_fpAddSubTest_ieeeAdd_b_3_q, xout => redist15_sigB_uid60_fpAddSubTest_ieeeAdd_b_6_q, clk => clk, aclr => areset );

    -- redist22_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_5(DELAY,305)
    redist22_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_5 : dspba_delay
    GENERIC MAP ( width => 1, depth => 5, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q, xout => redist22_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_5_q, clk => clk, aclr => areset );

    -- excAZBZSigASigB_uid143_fpAddSubTest_ieeeAdd(LOGICAL,142)@6
    excAZBZSigASigB_uid143_fpAddSubTest_ieeeAdd_q <= excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q and redist22_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_5_q and redist17_sigA_uid59_fpAddSubTest_ieeeAdd_b_6_q and redist15_sigB_uid60_fpAddSubTest_ieeeAdd_b_6_q;

    -- excBZARSigA_uid144_fpAddSubTest_ieeeAdd(LOGICAL,143)@6
    excBZARSigA_uid144_fpAddSubTest_ieeeAdd_q <= redist22_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_5_q and excR_aSig_uid40_fpAddSubTest_ieeeAdd_q and redist17_sigA_uid59_fpAddSubTest_ieeeAdd_b_6_q;

    -- signRZero_uid145_fpAddSubTest_ieeeAdd(LOGICAL,144)@6
    signRZero_uid145_fpAddSubTest_ieeeAdd_q <= excBZARSigA_uid144_fpAddSubTest_ieeeAdd_q or excAZBZSigASigB_uid143_fpAddSubTest_ieeeAdd_q;

    -- fracXIsZero_uid48_fpAddSubTest_ieeeAdd(LOGICAL,47)@1
    fracXIsZero_uid48_fpAddSubTest_ieeeAdd_q <= "1" WHEN cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q = redist24_frac_bSig_uid45_fpAddSubTest_ieeeAdd_b_1_q ELSE "0";

    -- excI_bSig_uid50_fpAddSubTest_ieeeAdd(LOGICAL,49)@1 + 1
    excI_bSig_uid50_fpAddSubTest_ieeeAdd_qi <= expXIsMax_uid47_fpAddSubTest_ieeeAdd_q and fracXIsZero_uid48_fpAddSubTest_ieeeAdd_q;
    excI_bSig_uid50_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excI_bSig_uid50_fpAddSubTest_ieeeAdd_qi, xout => excI_bSig_uid50_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- redist20_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_5(DELAY,303)
    redist20_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_5 : dspba_delay
    GENERIC MAP ( width => 1, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => excI_bSig_uid50_fpAddSubTest_ieeeAdd_q, xout => redist20_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_5_q, clk => clk, aclr => areset );

    -- sigBBInf_uid140_fpAddSubTest_ieeeAdd(LOGICAL,139)@6
    sigBBInf_uid140_fpAddSubTest_ieeeAdd_q <= redist15_sigB_uid60_fpAddSubTest_ieeeAdd_b_6_q and redist20_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_5_q;

    -- fracXIsZero_uid34_fpAddSubTest_ieeeAdd(LOGICAL,33)@3 + 1
    fracXIsZero_uid34_fpAddSubTest_ieeeAdd_qi <= "1" WHEN cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q = redist29_frac_aSig_uid31_fpAddSubTest_ieeeAdd_b_3_q ELSE "0";
    fracXIsZero_uid34_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid34_fpAddSubTest_ieeeAdd_qi, xout => fracXIsZero_uid34_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- redist27_fracXIsZero_uid34_fpAddSubTest_ieeeAdd_q_3(DELAY,310)
    redist27_fracXIsZero_uid34_fpAddSubTest_ieeeAdd_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid34_fpAddSubTest_ieeeAdd_q, xout => redist27_fracXIsZero_uid34_fpAddSubTest_ieeeAdd_q_3_q, clk => clk, aclr => areset );

    -- excI_aSig_uid36_fpAddSubTest_ieeeAdd(LOGICAL,35)@6
    excI_aSig_uid36_fpAddSubTest_ieeeAdd_q <= expXIsMax_uid33_fpAddSubTest_ieeeAdd_q and redist27_fracXIsZero_uid34_fpAddSubTest_ieeeAdd_q_3_q;

    -- sigAAInf_uid141_fpAddSubTest_ieeeAdd(LOGICAL,140)@6
    sigAAInf_uid141_fpAddSubTest_ieeeAdd_q <= redist17_sigA_uid59_fpAddSubTest_ieeeAdd_b_6_q and excI_aSig_uid36_fpAddSubTest_ieeeAdd_q;

    -- signRInf_uid142_fpAddSubTest_ieeeAdd(LOGICAL,141)@6
    signRInf_uid142_fpAddSubTest_ieeeAdd_q <= sigAAInf_uid141_fpAddSubTest_ieeeAdd_q or sigBBInf_uid140_fpAddSubTest_ieeeAdd_q;

    -- signRInfRZRReg_uid146_fpAddSubTest_ieeeAdd(LOGICAL,145)@6 + 1
    signRInfRZRReg_uid146_fpAddSubTest_ieeeAdd_qi <= signRInf_uid142_fpAddSubTest_ieeeAdd_q or signRZero_uid145_fpAddSubTest_ieeeAdd_q or signRReg_uid139_fpAddSubTest_ieeeAdd_q;
    signRInfRZRReg_uid146_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => signRInfRZRReg_uid146_fpAddSubTest_ieeeAdd_qi, xout => signRInfRZRReg_uid146_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- fracXIsNotZero_uid49_fpAddSubTest_ieeeAdd(LOGICAL,48)@1
    fracXIsNotZero_uid49_fpAddSubTest_ieeeAdd_q <= not (fracXIsZero_uid48_fpAddSubTest_ieeeAdd_q);

    -- excN_bSig_uid51_fpAddSubTest_ieeeAdd(LOGICAL,50)@1 + 1
    excN_bSig_uid51_fpAddSubTest_ieeeAdd_qi <= expXIsMax_uid47_fpAddSubTest_ieeeAdd_q and fracXIsNotZero_uid49_fpAddSubTest_ieeeAdd_q;
    excN_bSig_uid51_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_bSig_uid51_fpAddSubTest_ieeeAdd_qi, xout => excN_bSig_uid51_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- redist19_excN_bSig_uid51_fpAddSubTest_ieeeAdd_q_6(DELAY,302)
    redist19_excN_bSig_uid51_fpAddSubTest_ieeeAdd_q_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 5, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_bSig_uid51_fpAddSubTest_ieeeAdd_q, xout => redist19_excN_bSig_uid51_fpAddSubTest_ieeeAdd_q_6_q, clk => clk, aclr => areset );

    -- fracXIsNotZero_uid35_fpAddSubTest_ieeeAdd(LOGICAL,34)@6
    fracXIsNotZero_uid35_fpAddSubTest_ieeeAdd_q <= not (redist27_fracXIsZero_uid34_fpAddSubTest_ieeeAdd_q_3_q);

    -- excN_aSig_uid37_fpAddSubTest_ieeeAdd(LOGICAL,36)@6 + 1
    excN_aSig_uid37_fpAddSubTest_ieeeAdd_qi <= expXIsMax_uid33_fpAddSubTest_ieeeAdd_q and fracXIsNotZero_uid35_fpAddSubTest_ieeeAdd_q;
    excN_aSig_uid37_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excN_aSig_uid37_fpAddSubTest_ieeeAdd_qi, xout => excN_aSig_uid37_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- excRNaN2_uid133_fpAddSubTest_ieeeAdd(LOGICAL,132)@7
    excRNaN2_uid133_fpAddSubTest_ieeeAdd_q <= excN_aSig_uid37_fpAddSubTest_ieeeAdd_q or redist19_excN_bSig_uid51_fpAddSubTest_ieeeAdd_q_6_q;

    -- redist13_effSub_uid61_fpAddSubTest_ieeeAdd_q_4(DELAY,296)
    redist13_effSub_uid61_fpAddSubTest_ieeeAdd_q_4 : dspba_delay
    GENERIC MAP ( width => 1, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => effSub_uid61_fpAddSubTest_ieeeAdd_q, xout => redist13_effSub_uid61_fpAddSubTest_ieeeAdd_q_4_q, clk => clk, aclr => areset );

    -- redist21_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_6(DELAY,304)
    redist21_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist20_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_5_q, xout => redist21_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_6_q, clk => clk, aclr => areset );

    -- redist26_excI_aSig_uid36_fpAddSubTest_ieeeAdd_q_1(DELAY,309)
    redist26_excI_aSig_uid36_fpAddSubTest_ieeeAdd_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excI_aSig_uid36_fpAddSubTest_ieeeAdd_q, xout => redist26_excI_aSig_uid36_fpAddSubTest_ieeeAdd_q_1_q, clk => clk, aclr => areset );

    -- excAIBISub_uid134_fpAddSubTest_ieeeAdd(LOGICAL,133)@7
    excAIBISub_uid134_fpAddSubTest_ieeeAdd_q <= redist26_excI_aSig_uid36_fpAddSubTest_ieeeAdd_q_1_q and redist21_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_6_q and redist13_effSub_uid61_fpAddSubTest_ieeeAdd_q_4_q;

    -- excRNaN_uid135_fpAddSubTest_ieeeAdd(LOGICAL,134)@7
    excRNaN_uid135_fpAddSubTest_ieeeAdd_q <= excAIBISub_uid134_fpAddSubTest_ieeeAdd_q or excRNaN2_uid133_fpAddSubTest_ieeeAdd_q;

    -- invExcRNaN_uid147_fpAddSubTest_ieeeAdd(LOGICAL,146)@7
    invExcRNaN_uid147_fpAddSubTest_ieeeAdd_q <= not (excRNaN_uid135_fpAddSubTest_ieeeAdd_q);

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- signRPostExc_uid148_fpAddSubTest_ieeeAdd(LOGICAL,147)@7
    signRPostExc_uid148_fpAddSubTest_ieeeAdd_q <= invExcRNaN_uid147_fpAddSubTest_ieeeAdd_q and signRInfRZRReg_uid146_fpAddSubTest_ieeeAdd_q;

    -- cRBit_uid108_fpAddSubTest_ieeeAdd(CONSTANT,107)
    cRBit_uid108_fpAddSubTest_ieeeAdd_q <= "01000";

    -- leftShiftStage2Idx3Rng3_uid272_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITSELECT,271)@6
    leftShiftStage2Idx3Rng3_uid272_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in <= leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(53 downto 0);
    leftShiftStage2Idx3Rng3_uid272_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b <= leftShiftStage2Idx3Rng3_uid272_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in(53 downto 0);

    -- leftShiftStage2Idx3Pad3_uid271_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(CONSTANT,270)
    leftShiftStage2Idx3Pad3_uid271_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= "000";

    -- leftShiftStage2Idx3_uid273_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITJOIN,272)@6
    leftShiftStage2Idx3_uid273_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage2Idx3Rng3_uid272_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b & leftShiftStage2Idx3Pad3_uid271_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;

    -- leftShiftStage2Idx2Rng2_uid269_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITSELECT,268)@6
    leftShiftStage2Idx2Rng2_uid269_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in <= leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(54 downto 0);
    leftShiftStage2Idx2Rng2_uid269_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b <= leftShiftStage2Idx2Rng2_uid269_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in(54 downto 0);

    -- leftShiftStage2Idx2_uid270_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITJOIN,269)@6
    leftShiftStage2Idx2_uid270_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage2Idx2Rng2_uid269_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b & zs_uid185_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;

    -- leftShiftStage2Idx1Rng1_uid266_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITSELECT,265)@6
    leftShiftStage2Idx1Rng1_uid266_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in <= leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(55 downto 0);
    leftShiftStage2Idx1Rng1_uid266_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b <= leftShiftStage2Idx1Rng1_uid266_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in(55 downto 0);

    -- leftShiftStage2Idx1_uid267_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITJOIN,266)@6
    leftShiftStage2Idx1_uid267_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage2Idx1Rng1_uid266_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b & GND_q;

    -- leftShiftStage1Idx3Rng12_uid261_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITSELECT,260)@6
    leftShiftStage1Idx3Rng12_uid261_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in <= leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(44 downto 0);
    leftShiftStage1Idx3Rng12_uid261_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b <= leftShiftStage1Idx3Rng12_uid261_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in(44 downto 0);

    -- leftShiftStage1Idx3Pad12_uid260_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(CONSTANT,259)
    leftShiftStage1Idx3Pad12_uid260_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= "000000000000";

    -- leftShiftStage1Idx3_uid262_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITJOIN,261)@6
    leftShiftStage1Idx3_uid262_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage1Idx3Rng12_uid261_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b & leftShiftStage1Idx3Pad12_uid260_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;

    -- leftShiftStage1Idx2Rng8_uid258_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITSELECT,257)@6
    leftShiftStage1Idx2Rng8_uid258_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in <= leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(48 downto 0);
    leftShiftStage1Idx2Rng8_uid258_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b <= leftShiftStage1Idx2Rng8_uid258_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in(48 downto 0);

    -- leftShiftStage1Idx2_uid259_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITJOIN,258)@6
    leftShiftStage1Idx2_uid259_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage1Idx2Rng8_uid258_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b & zs_uid173_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;

    -- leftShiftStage1Idx1Rng4_uid255_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITSELECT,254)@6
    leftShiftStage1Idx1Rng4_uid255_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in <= leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(52 downto 0);
    leftShiftStage1Idx1Rng4_uid255_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b <= leftShiftStage1Idx1Rng4_uid255_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in(52 downto 0);

    -- leftShiftStage1Idx1_uid256_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITJOIN,255)@6
    leftShiftStage1Idx1_uid256_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage1Idx1Rng4_uid255_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b & zs_uid179_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;

    -- leftShiftStage0Idx3Rng48_uid250_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITSELECT,249)@5
    leftShiftStage0Idx3Rng48_uid250_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in <= redist11_fracGRS_uid93_fpAddSubTest_ieeeAdd_q_1_q(8 downto 0);
    leftShiftStage0Idx3Rng48_uid250_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b <= leftShiftStage0Idx3Rng48_uid250_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in(8 downto 0);

    -- leftShiftStage0Idx3Pad48_uid249_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(CONSTANT,248)
    leftShiftStage0Idx3Pad48_uid249_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= "000000000000000000000000000000000000000000000000";

    -- leftShiftStage0Idx3_uid251_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITJOIN,250)@5
    leftShiftStage0Idx3_uid251_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage0Idx3Rng48_uid250_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b & leftShiftStage0Idx3Pad48_uid249_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;

    -- redist8_vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b_1(DELAY,291)
    redist8_vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b_1 : dspba_delay
    GENERIC MAP ( width => 25, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b, xout => redist8_vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b_1_q, clk => clk, aclr => areset );

    -- leftShiftStage0Idx2_uid248_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITJOIN,247)@5
    leftShiftStage0Idx2_uid248_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= redist8_vStage_uid163_lzCountVal_uid94_fpAddSubTest_ieeeAdd_b_1_q & zs_uid159_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;

    -- leftShiftStage0Idx1Rng16_uid244_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITSELECT,243)@5
    leftShiftStage0Idx1Rng16_uid244_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in <= redist11_fracGRS_uid93_fpAddSubTest_ieeeAdd_q_1_q(40 downto 0);
    leftShiftStage0Idx1Rng16_uid244_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b <= leftShiftStage0Idx1Rng16_uid244_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_in(40 downto 0);

    -- leftShiftStage0Idx1_uid245_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(BITJOIN,244)@5
    leftShiftStage0Idx1_uid245_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage0Idx1Rng16_uid244_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_b & zs_uid167_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q;

    -- redist11_fracGRS_uid93_fpAddSubTest_ieeeAdd_q_1(DELAY,294)
    redist11_fracGRS_uid93_fpAddSubTest_ieeeAdd_q_1 : dspba_delay
    GENERIC MAP ( width => 57, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracGRS_uid93_fpAddSubTest_ieeeAdd_q, xout => redist11_fracGRS_uid93_fpAddSubTest_ieeeAdd_q_1_q, clk => clk, aclr => areset );

    -- leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select(BITSELECT,282)@5
    leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_b <= r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(5 downto 4);
    leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_c <= r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(3 downto 2);
    leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_d <= r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q(1 downto 0);

    -- leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(MUX,252)@5 + 1
    leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s <= leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_b;
    leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s) IS
                WHEN "00" => leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= redist11_fracGRS_uid93_fpAddSubTest_ieeeAdd_q_1_q;
                WHEN "01" => leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage0Idx1_uid245_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
                WHEN "10" => leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage0Idx2_uid248_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
                WHEN "11" => leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage0Idx3_uid251_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
                WHEN OTHERS => leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- redist0_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_c_1(DELAY,283)
    redist0_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_c_1 : dspba_delay
    GENERIC MAP ( width => 2, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_c, xout => redist0_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_c_1_q, clk => clk, aclr => areset );

    -- leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(MUX,263)@6
    leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s <= redist0_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_c_1_q;
    leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_combproc: PROCESS (leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s, leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q, leftShiftStage1Idx1_uid256_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q, leftShiftStage1Idx2_uid259_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q, leftShiftStage1Idx3_uid262_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s) IS
            WHEN "00" => leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage0_uid253_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
            WHEN "01" => leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage1Idx1_uid256_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
            WHEN "10" => leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage1Idx2_uid259_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
            WHEN "11" => leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage1Idx3_uid262_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist1_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_d_1(DELAY,284)
    redist1_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_d_1 : dspba_delay
    GENERIC MAP ( width => 2, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_d, xout => redist1_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_d_1_q, clk => clk, aclr => areset );

    -- leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd(MUX,274)@6
    leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s <= redist1_leftShiftStageSel5Dto4_uid252_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_merged_bit_select_d_1_q;
    leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_combproc: PROCESS (leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s, leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q, leftShiftStage2Idx1_uid267_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q, leftShiftStage2Idx2_uid270_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q, leftShiftStage2Idx3_uid273_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_s) IS
            WHEN "00" => leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage1_uid264_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
            WHEN "01" => leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage2Idx1_uid267_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
            WHEN "10" => leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage2Idx2_uid270_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
            WHEN "11" => leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= leftShiftStage2Idx3_uid273_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- LSB_uid106_fpAddSubTest_ieeeAdd(BITSELECT,105)@6
    LSB_uid106_fpAddSubTest_ieeeAdd_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(4 downto 0));
    LSB_uid106_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(LSB_uid106_fpAddSubTest_ieeeAdd_in(4 downto 4));

    -- Guard_uid105_fpAddSubTest_ieeeAdd(BITSELECT,104)@6
    Guard_uid105_fpAddSubTest_ieeeAdd_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(3 downto 0));
    Guard_uid105_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(Guard_uid105_fpAddSubTest_ieeeAdd_in(3 downto 3));

    -- Round_uid104_fpAddSubTest_ieeeAdd(BITSELECT,103)@6
    Round_uid104_fpAddSubTest_ieeeAdd_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(2 downto 0));
    Round_uid104_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(Round_uid104_fpAddSubTest_ieeeAdd_in(2 downto 2));

    -- Sticky1_uid103_fpAddSubTest_ieeeAdd(BITSELECT,102)@6
    Sticky1_uid103_fpAddSubTest_ieeeAdd_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(1 downto 0));
    Sticky1_uid103_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(Sticky1_uid103_fpAddSubTest_ieeeAdd_in(1 downto 1));

    -- Sticky0_uid102_fpAddSubTest_ieeeAdd(BITSELECT,101)@6
    Sticky0_uid102_fpAddSubTest_ieeeAdd_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(0 downto 0));
    Sticky0_uid102_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(Sticky0_uid102_fpAddSubTest_ieeeAdd_in(0 downto 0));

    -- rndBitCond_uid107_fpAddSubTest_ieeeAdd(BITJOIN,106)@6
    rndBitCond_uid107_fpAddSubTest_ieeeAdd_q <= LSB_uid106_fpAddSubTest_ieeeAdd_b & Guard_uid105_fpAddSubTest_ieeeAdd_b & Round_uid104_fpAddSubTest_ieeeAdd_b & Sticky1_uid103_fpAddSubTest_ieeeAdd_b & Sticky0_uid102_fpAddSubTest_ieeeAdd_b;

    -- rBi_uid109_fpAddSubTest_ieeeAdd(LOGICAL,108)@6
    rBi_uid109_fpAddSubTest_ieeeAdd_q <= "1" WHEN rndBitCond_uid107_fpAddSubTest_ieeeAdd_q = cRBit_uid108_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- roundBit_uid110_fpAddSubTest_ieeeAdd(LOGICAL,109)@6
    roundBit_uid110_fpAddSubTest_ieeeAdd_q <= not (rBi_uid109_fpAddSubTest_ieeeAdd_q);

    -- oneCST_uid99_fpAddSubTest_ieeeAdd(CONSTANT,98)
    oneCST_uid99_fpAddSubTest_ieeeAdd_q <= "00000000001";

    -- expInc_uid100_fpAddSubTest_ieeeAdd(ADD,99)@6
    expInc_uid100_fpAddSubTest_ieeeAdd_a <= STD_LOGIC_VECTOR("0" & redist31_exp_aSig_uid30_fpAddSubTest_ieeeAdd_b_6_outputreg_q);
    expInc_uid100_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR("0" & oneCST_uid99_fpAddSubTest_ieeeAdd_q);
    expInc_uid100_fpAddSubTest_ieeeAdd_o <= STD_LOGIC_VECTOR(UNSIGNED(expInc_uid100_fpAddSubTest_ieeeAdd_a) + UNSIGNED(expInc_uid100_fpAddSubTest_ieeeAdd_b));
    expInc_uid100_fpAddSubTest_ieeeAdd_q <= expInc_uid100_fpAddSubTest_ieeeAdd_o(11 downto 0);

    -- expPostNorm_uid101_fpAddSubTest_ieeeAdd(SUB,100)@6
    expPostNorm_uid101_fpAddSubTest_ieeeAdd_a <= STD_LOGIC_VECTOR("0" & expInc_uid100_fpAddSubTest_ieeeAdd_q);
    expPostNorm_uid101_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR("0000000" & redist6_r_uid194_lzCountVal_uid94_fpAddSubTest_ieeeAdd_q_1_q);
    expPostNorm_uid101_fpAddSubTest_ieeeAdd_o <= STD_LOGIC_VECTOR(UNSIGNED(expPostNorm_uid101_fpAddSubTest_ieeeAdd_a) - UNSIGNED(expPostNorm_uid101_fpAddSubTest_ieeeAdd_b));
    expPostNorm_uid101_fpAddSubTest_ieeeAdd_q <= expPostNorm_uid101_fpAddSubTest_ieeeAdd_o(12 downto 0);

    -- fracPostNorm_uid98_fpAddSubTest_ieeeAdd(BITSELECT,97)@6
    fracPostNorm_uid98_fpAddSubTest_ieeeAdd_b <= leftShiftStage2_uid275_fracPostNormExt_uid97_fpAddSubTest_ieeeAdd_q(56 downto 1);

    -- fracPostNormRndRange_uid111_fpAddSubTest_ieeeAdd(BITSELECT,110)@6
    fracPostNormRndRange_uid111_fpAddSubTest_ieeeAdd_in <= fracPostNorm_uid98_fpAddSubTest_ieeeAdd_b(54 downto 0);
    fracPostNormRndRange_uid111_fpAddSubTest_ieeeAdd_b <= fracPostNormRndRange_uid111_fpAddSubTest_ieeeAdd_in(54 downto 2);

    -- expFracR_uid112_fpAddSubTest_ieeeAdd(BITJOIN,111)@6
    expFracR_uid112_fpAddSubTest_ieeeAdd_q <= expPostNorm_uid101_fpAddSubTest_ieeeAdd_q & fracPostNormRndRange_uid111_fpAddSubTest_ieeeAdd_b;

    -- rndExpFrac_uid113_fpAddSubTest_ieeeAdd(ADD,112)@6 + 1
    rndExpFrac_uid113_fpAddSubTest_ieeeAdd_a <= STD_LOGIC_VECTOR("0" & expFracR_uid112_fpAddSubTest_ieeeAdd_q);
    rndExpFrac_uid113_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR("000000000000000000000000000000000000000000000000000000000000000000" & roundBit_uid110_fpAddSubTest_ieeeAdd_q);
    rndExpFrac_uid113_fpAddSubTest_ieeeAdd_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            rndExpFrac_uid113_fpAddSubTest_ieeeAdd_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            rndExpFrac_uid113_fpAddSubTest_ieeeAdd_o <= STD_LOGIC_VECTOR(UNSIGNED(rndExpFrac_uid113_fpAddSubTest_ieeeAdd_a) + UNSIGNED(rndExpFrac_uid113_fpAddSubTest_ieeeAdd_b));
        END IF;
    END PROCESS;
    rndExpFrac_uid113_fpAddSubTest_ieeeAdd_q <= rndExpFrac_uid113_fpAddSubTest_ieeeAdd_o(66 downto 0);

    -- expRPreExc_uid126_fpAddSubTest_ieeeAdd(BITSELECT,125)@7
    expRPreExc_uid126_fpAddSubTest_ieeeAdd_in <= rndExpFrac_uid113_fpAddSubTest_ieeeAdd_q(63 downto 0);
    expRPreExc_uid126_fpAddSubTest_ieeeAdd_b <= expRPreExc_uid126_fpAddSubTest_ieeeAdd_in(63 downto 53);

    -- rndExpFracOvfBits_uid118_fpAddSubTest_ieeeAdd(BITSELECT,117)@7
    rndExpFracOvfBits_uid118_fpAddSubTest_ieeeAdd_in <= rndExpFrac_uid113_fpAddSubTest_ieeeAdd_q(65 downto 0);
    rndExpFracOvfBits_uid118_fpAddSubTest_ieeeAdd_b <= rndExpFracOvfBits_uid118_fpAddSubTest_ieeeAdd_in(65 downto 64);

    -- rOvfExtraBits_uid119_fpAddSubTest_ieeeAdd(LOGICAL,118)@7
    rOvfExtraBits_uid119_fpAddSubTest_ieeeAdd_q <= "1" WHEN rndExpFracOvfBits_uid118_fpAddSubTest_ieeeAdd_b = zocst_uid85_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- wEP2AllOwE_uid114_fpAddSubTest_ieeeAdd(CONSTANT,113)
    wEP2AllOwE_uid114_fpAddSubTest_ieeeAdd_q <= "0011111111111";

    -- rndExp_uid115_fpAddSubTest_ieeeAdd(BITSELECT,114)@7
    rndExp_uid115_fpAddSubTest_ieeeAdd_in <= rndExpFrac_uid113_fpAddSubTest_ieeeAdd_q(65 downto 0);
    rndExp_uid115_fpAddSubTest_ieeeAdd_b <= rndExp_uid115_fpAddSubTest_ieeeAdd_in(65 downto 53);

    -- rOvfEQMax_uid116_fpAddSubTest_ieeeAdd(LOGICAL,115)@7
    rOvfEQMax_uid116_fpAddSubTest_ieeeAdd_q <= "1" WHEN rndExp_uid115_fpAddSubTest_ieeeAdd_b = wEP2AllOwE_uid114_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- rOvf_uid120_fpAddSubTest_ieeeAdd(LOGICAL,119)@7
    rOvf_uid120_fpAddSubTest_ieeeAdd_q <= rOvfEQMax_uid116_fpAddSubTest_ieeeAdd_q or rOvfExtraBits_uid119_fpAddSubTest_ieeeAdd_q;

    -- regInputs_uid127_fpAddSubTest_ieeeAdd(LOGICAL,126)@6 + 1
    regInputs_uid127_fpAddSubTest_ieeeAdd_qi <= excR_aSig_uid40_fpAddSubTest_ieeeAdd_q and redist18_excR_bSig_uid54_fpAddSubTest_ieeeAdd_q_5_q;
    regInputs_uid127_fpAddSubTest_ieeeAdd_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => regInputs_uid127_fpAddSubTest_ieeeAdd_qi, xout => regInputs_uid127_fpAddSubTest_ieeeAdd_q, clk => clk, aclr => areset );

    -- rInfOvf_uid130_fpAddSubTest_ieeeAdd(LOGICAL,129)@7
    rInfOvf_uid130_fpAddSubTest_ieeeAdd_q <= regInputs_uid127_fpAddSubTest_ieeeAdd_q and rOvf_uid120_fpAddSubTest_ieeeAdd_q;

    -- excRInfVInC_uid131_fpAddSubTest_ieeeAdd(BITJOIN,130)@7
    excRInfVInC_uid131_fpAddSubTest_ieeeAdd_q <= rInfOvf_uid130_fpAddSubTest_ieeeAdd_q & redist19_excN_bSig_uid51_fpAddSubTest_ieeeAdd_q_6_q & excN_aSig_uid37_fpAddSubTest_ieeeAdd_q & redist21_excI_bSig_uid50_fpAddSubTest_ieeeAdd_q_6_q & redist26_excI_aSig_uid36_fpAddSubTest_ieeeAdd_q_1_q & redist13_effSub_uid61_fpAddSubTest_ieeeAdd_q_4_q;

    -- excRInf_uid132_fpAddSubTest_ieeeAdd(LOOKUP,131)@7
    excRInf_uid132_fpAddSubTest_ieeeAdd_combproc: PROCESS (excRInfVInC_uid131_fpAddSubTest_ieeeAdd_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRInfVInC_uid131_fpAddSubTest_ieeeAdd_q) IS
            WHEN "000000" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "000001" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "000010" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "000011" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "000100" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "000101" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "000110" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "000111" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "001000" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "001001" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "001010" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "001011" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "001100" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "001101" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "001110" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "001111" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "010000" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "010001" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "010010" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "010011" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "010100" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "010101" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "010110" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "010111" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "011000" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "011001" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "011010" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "011011" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "011100" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "011101" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "011110" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "011111" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "100000" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "100001" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "100010" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "100011" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "100100" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "100101" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "100110" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "100111" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "101000" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "101001" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "101010" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "101011" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "101100" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "101101" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "101110" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "101111" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "110000" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "110001" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "110010" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "110011" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "110100" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "110101" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "110110" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "110111" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "111000" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "111001" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "111010" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "111011" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "111100" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "111101" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "111110" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "111111" => excRInf_uid132_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRInf_uid132_fpAddSubTest_ieeeAdd_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- redist10_aMinusA_uid96_fpAddSubTest_ieeeAdd_q_1(DELAY,293)
    redist10_aMinusA_uid96_fpAddSubTest_ieeeAdd_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => aMinusA_uid96_fpAddSubTest_ieeeAdd_q, xout => redist10_aMinusA_uid96_fpAddSubTest_ieeeAdd_q_1_q, clk => clk, aclr => areset );

    -- rUdfExtraBit_uid123_fpAddSubTest_ieeeAdd(BITSELECT,122)@7
    rUdfExtraBit_uid123_fpAddSubTest_ieeeAdd_in <= STD_LOGIC_VECTOR(rndExpFrac_uid113_fpAddSubTest_ieeeAdd_q(65 downto 0));
    rUdfExtraBit_uid123_fpAddSubTest_ieeeAdd_b <= STD_LOGIC_VECTOR(rUdfExtraBit_uid123_fpAddSubTest_ieeeAdd_in(65 downto 65));

    -- wEP2AllZ_uid121_fpAddSubTest_ieeeAdd(CONSTANT,120)
    wEP2AllZ_uid121_fpAddSubTest_ieeeAdd_q <= "0000000000000";

    -- rUdfEQMin_uid122_fpAddSubTest_ieeeAdd(LOGICAL,121)@7
    rUdfEQMin_uid122_fpAddSubTest_ieeeAdd_q <= "1" WHEN rndExp_uid115_fpAddSubTest_ieeeAdd_b = wEP2AllZ_uid121_fpAddSubTest_ieeeAdd_q ELSE "0";

    -- rUdf_uid124_fpAddSubTest_ieeeAdd(LOGICAL,123)@7
    rUdf_uid124_fpAddSubTest_ieeeAdd_q <= rUdfEQMin_uid122_fpAddSubTest_ieeeAdd_q or rUdfExtraBit_uid123_fpAddSubTest_ieeeAdd_b;

    -- redist23_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_6(DELAY,306)
    redist23_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_6 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist22_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_5_q, xout => redist23_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_6_q, clk => clk, aclr => areset );

    -- redist28_excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q_1(DELAY,311)
    redist28_excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q, xout => redist28_excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q_1_q, clk => clk, aclr => areset );

    -- excRZeroVInC_uid128_fpAddSubTest_ieeeAdd(BITJOIN,127)@7
    excRZeroVInC_uid128_fpAddSubTest_ieeeAdd_q <= redist10_aMinusA_uid96_fpAddSubTest_ieeeAdd_q_1_q & rUdf_uid124_fpAddSubTest_ieeeAdd_q & regInputs_uid127_fpAddSubTest_ieeeAdd_q & redist23_excZ_bSig_uid26_uid46_fpAddSubTest_ieeeAdd_q_6_q & redist28_excZ_aSig_uid25_uid32_fpAddSubTest_ieeeAdd_q_1_q;

    -- excRZero_uid129_fpAddSubTest_ieeeAdd(LOOKUP,128)@7
    excRZero_uid129_fpAddSubTest_ieeeAdd_combproc: PROCESS (excRZeroVInC_uid128_fpAddSubTest_ieeeAdd_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRZeroVInC_uid128_fpAddSubTest_ieeeAdd_q) IS
            WHEN "00000" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "00001" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "00010" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "00011" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "00100" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "00101" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "00110" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "00111" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "01000" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "01001" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "01010" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "01011" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "01100" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "01101" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "01110" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "01111" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "10000" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "10001" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "10010" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "10011" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "10100" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "10101" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "10110" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "10111" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "11000" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "11001" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "11010" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "11011" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "11100" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "1";
            WHEN "11101" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "11110" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN "11111" => excRZero_uid129_fpAddSubTest_ieeeAdd_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRZero_uid129_fpAddSubTest_ieeeAdd_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- concExc_uid136_fpAddSubTest_ieeeAdd(BITJOIN,135)@7
    concExc_uid136_fpAddSubTest_ieeeAdd_q <= excRNaN_uid135_fpAddSubTest_ieeeAdd_q & excRInf_uid132_fpAddSubTest_ieeeAdd_q & excRZero_uid129_fpAddSubTest_ieeeAdd_q;

    -- excREnc_uid137_fpAddSubTest_ieeeAdd(LOOKUP,136)@7
    excREnc_uid137_fpAddSubTest_ieeeAdd_combproc: PROCESS (concExc_uid136_fpAddSubTest_ieeeAdd_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExc_uid136_fpAddSubTest_ieeeAdd_q) IS
            WHEN "000" => excREnc_uid137_fpAddSubTest_ieeeAdd_q <= "01";
            WHEN "001" => excREnc_uid137_fpAddSubTest_ieeeAdd_q <= "00";
            WHEN "010" => excREnc_uid137_fpAddSubTest_ieeeAdd_q <= "10";
            WHEN "011" => excREnc_uid137_fpAddSubTest_ieeeAdd_q <= "10";
            WHEN "100" => excREnc_uid137_fpAddSubTest_ieeeAdd_q <= "11";
            WHEN "101" => excREnc_uid137_fpAddSubTest_ieeeAdd_q <= "11";
            WHEN "110" => excREnc_uid137_fpAddSubTest_ieeeAdd_q <= "11";
            WHEN "111" => excREnc_uid137_fpAddSubTest_ieeeAdd_q <= "11";
            WHEN OTHERS => -- unreachable
                           excREnc_uid137_fpAddSubTest_ieeeAdd_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExc_uid156_fpAddSubTest_ieeeAdd(MUX,155)@7
    expRPostExc_uid156_fpAddSubTest_ieeeAdd_s <= excREnc_uid137_fpAddSubTest_ieeeAdd_q;
    expRPostExc_uid156_fpAddSubTest_ieeeAdd_combproc: PROCESS (expRPostExc_uid156_fpAddSubTest_ieeeAdd_s, cstAllZWE_uid29_fpAddSubTest_ieeeAdd_q, expRPreExc_uid126_fpAddSubTest_ieeeAdd_b, cstAllOWE_uid27_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (expRPostExc_uid156_fpAddSubTest_ieeeAdd_s) IS
            WHEN "00" => expRPostExc_uid156_fpAddSubTest_ieeeAdd_q <= cstAllZWE_uid29_fpAddSubTest_ieeeAdd_q;
            WHEN "01" => expRPostExc_uid156_fpAddSubTest_ieeeAdd_q <= expRPreExc_uid126_fpAddSubTest_ieeeAdd_b;
            WHEN "10" => expRPostExc_uid156_fpAddSubTest_ieeeAdd_q <= cstAllOWE_uid27_fpAddSubTest_ieeeAdd_q;
            WHEN "11" => expRPostExc_uid156_fpAddSubTest_ieeeAdd_q <= cstAllOWE_uid27_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => expRPostExc_uid156_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid149_fpAddSubTest_ieeeAdd(CONSTANT,148)
    oneFracRPostExc2_uid149_fpAddSubTest_ieeeAdd_q <= "0000000000000000000000000000000000000000000000000001";

    -- fracRPreExc_uid125_fpAddSubTest_ieeeAdd(BITSELECT,124)@7
    fracRPreExc_uid125_fpAddSubTest_ieeeAdd_in <= rndExpFrac_uid113_fpAddSubTest_ieeeAdd_q(52 downto 0);
    fracRPreExc_uid125_fpAddSubTest_ieeeAdd_b <= fracRPreExc_uid125_fpAddSubTest_ieeeAdd_in(52 downto 1);

    -- fracRPostExc_uid152_fpAddSubTest_ieeeAdd(MUX,151)@7
    fracRPostExc_uid152_fpAddSubTest_ieeeAdd_s <= excREnc_uid137_fpAddSubTest_ieeeAdd_q;
    fracRPostExc_uid152_fpAddSubTest_ieeeAdd_combproc: PROCESS (fracRPostExc_uid152_fpAddSubTest_ieeeAdd_s, cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q, fracRPreExc_uid125_fpAddSubTest_ieeeAdd_b, oneFracRPostExc2_uid149_fpAddSubTest_ieeeAdd_q)
    BEGIN
        CASE (fracRPostExc_uid152_fpAddSubTest_ieeeAdd_s) IS
            WHEN "00" => fracRPostExc_uid152_fpAddSubTest_ieeeAdd_q <= cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q;
            WHEN "01" => fracRPostExc_uid152_fpAddSubTest_ieeeAdd_q <= fracRPreExc_uid125_fpAddSubTest_ieeeAdd_b;
            WHEN "10" => fracRPostExc_uid152_fpAddSubTest_ieeeAdd_q <= cstZeroWF_uid28_fpAddSubTest_ieeeAdd_q;
            WHEN "11" => fracRPostExc_uid152_fpAddSubTest_ieeeAdd_q <= oneFracRPostExc2_uid149_fpAddSubTest_ieeeAdd_q;
            WHEN OTHERS => fracRPostExc_uid152_fpAddSubTest_ieeeAdd_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- R_uid157_fpAddSubTest_ieeeAdd(BITJOIN,156)@7
    R_uid157_fpAddSubTest_ieeeAdd_q <= signRPostExc_uid148_fpAddSubTest_ieeeAdd_q & expRPostExc_uid156_fpAddSubTest_ieeeAdd_q & fracRPostExc_uid152_fpAddSubTest_ieeeAdd_q;

    -- xOut(GPOUT,4)@7
    q <= R_uid157_fpAddSubTest_ieeeAdd_q;

END normal;
