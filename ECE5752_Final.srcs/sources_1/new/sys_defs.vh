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
`define INT_WRITE_PORTS 6
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
// major opcodes used by the decode stage : bits [40:37]
//

`define ALU_INST     4'h0

