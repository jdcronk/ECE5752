/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  sys_defs.vh                                         //
//                                                                     //
//  Description :  This file has the macro-defines for macros used in  //
//                 the design.                                         //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////
//
// Register file defines
//
//////////////////////////////////////////////

`define INT_READ_PORTS 8
`define INT_WRITE_PORTS 4
`define NUM_INT_REGS 32

//////////////////////////////////////////////
//
// Error codes
//
//////////////////////////////////////////////

`define NO_ERROR 4'h0
`define HALTED_ON_MEMORY_ERROR 4'h1
`define HALTED_ON_HALT 4'h2
`define HALTED_ON_ILLEGAL 4'h3

//////////////////////////////////////////////
//
// Memory/testbench attribute definitions
//
//////////////////////////////////////////////


`define NUM_MEM_TAGS           31

`define MEM_SIZE_IN_BYTES      (64*1024)
`define MEM_128BIT_LINES        (`MEM_SIZE_IN_BYTES/16) //Each line will be 128 bits or 16 bytes

// probably not a good idea to change this second one
`define VIRTUAL_CLOCK_PERIOD   5.01 // Clock period from dc_shell
`define VERILOG_CLOCK_PERIOD   10.0 // Clock period from test bench

`define MEM_LATENCY_IN_CYCLES (100.0/`VIRTUAL_CLOCK_PERIOD+0.49999)
// the 0.49999 is to force ceiling(100/period).  The default behavior for
// float to integer conversion is rounding to nearest

`define SD #1

//
// Memory bus commands control signals
//
`define BUS_NONE       2'h0
`define BUS_LOAD       2'h1
`define BUS_STORE      2'h2

//
// useful boolean single-bit definitions
//
`define FALSE	1'h0
`define TRUE	1'h1

//
// register that always has the value zero
//
`define ZERO_REG        5'd31

//
// ALU op mux controls
//
`define ALU_OPA_IS_REGA     2'b00

`define ALU_OPB_IS_REGB     2'b00
`define ALU_OPB_IS_IMM      2'b01

`define NOOP_INST 41'h7FFFFFFFF

//
// ALU function codes
//
`define ALU_ADD     5'h00
`define ALU_ADD_P1  5'h01
`define ALU_SUB     5'h02
`define ALU_SUB_M1  5'h03
`define ALU_AND     5'h04
`define ALU_OR      5'h05
`define ALU_XOR     5'h06
`define ALU_CMPLT   5'h07
`define ALU_CMPGT   5'h08
`define ALU_CMPEQ   5'h09
`define ALU_CMPNE   5'h0A
`define ALU_CMPLE   5'h0B
`define ALU_CMPGE   5'h0C
`define ALU_SLL     5'h0D
`define ALU_SRL     5'h0E

//
// major opcodes used by the decode stage : bits [40:33]
//

`define ADD_INST        8'h80
`define ADD_P1_INST     8'h81
`define ADD_IMM_INST    8'h82 
`define SUB_INST        8'h83
`define SUB_M1_INST     8'h84
`define SUB_IMM_INST    8'h85
`define AND_INST        8'h86
`define OR_INST         8'h87
`define XOR_INST        8'h88
`define AND_IMM_INST    8'h89
`define OR_IMM_INST     8'h8A
`define XOR_IMM_INST    8'h8B
`define CMP_LT_INST     8'h8C
`define CMP_GT_INST     8'h8D
`define CMP_EQ_INST     8'h8E
`define CMP_NE_INST     8'h8F
`define CMP_LE_INST     8'h90
`define CMP_GE_INST     8'h91
`define SLL_INST        8'h92
`define SRL_INST        8'h93
