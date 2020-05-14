`include "alu.v"
`include "ctrl_encode_def.v"
`include "EXT.v"
`include "mux.v"
`include "NPC.v"
`include "PC.v"
`include "RF.v"
`include "IM.v"
`include "DM.v"
`include "Control.v"
`include "Register.v"

module MIPS(clk,rst);
    input clk;
    input rst;

    //PC_MUX
    wire [31:0] PC_i; //从NPC出来的数据
    wire [31:0] ALUResult; //ALU中算出的地址，用于处理jalr和jr。ALU实际做+0操作
    wire PCSrc; 
    wire [31:0] finalPC_i;//最终写入PC的值
    mux2 PC_MUX(.d0(PC_i),.d1(ALUResult),.s(PCSrc),.y(finalPC_i));
    
    //PC module OK
    wire [31:0] PC_i; 
    wire [31:0] PC_o;
    wire PC_Write_Final;
    PC my_PC(.clk(clk),.rst(rst),.NPC(PC_i),.PC(PC_o),.PC_Write_Final(PC_Write_Final));

    //IM module OK
    wire [31:0] Instruction;
    IM my_IM(.PC(PC_o),.Instruction(Instruction));

    //Instruction Regsiter OK
    wire IRWrite;
    wire [31:0] Instr_o;
    Regsiter(.clk(clk),.WriteSignal(IRWrite),.in(Instruction),.out(Instr_o));

    //MUX RegSrc OK
    wire [4:0]writeRegister;//写回寄存器号数
    wire [4:0] reg_ra = 5'b11111;//31号寄存器
    mux4_5 muxRegDst(.d0(Instr_o[20:16]),.d1(Instr_o[15:11]),.d2(reg_ra),.s(RegDst),.y(writeRegister));//5位 3选1

    //RF module OK
    wire RegWrite;
    wire [31:0]ReadData1;
    wire [31:0]ReadData2;
    wire WriteDataFinal;
    RF my_RF(.clk(clk),.rst(rst),
    .RFWr(RegWrite),
    .A1(Instruction[25:21]),
    .A2(Instruction[20:16]),
    .A3(writeRegister),
    .WD(WriteDataFinal),.RD1(ReadData1),.RD2(ReadData2));//last 2 param
    
    //RegisterA OK
    wire [31:0] RegA_o;
    Register  RegA(.clk(clk),.WriteSignal(1'b1),.in(ReadData1),.out(RegA_o));
    
    //RegisterB OK
    wire [31:0] RegB_o;
    Register  RegA(.clk(clk),.WriteSignal(1'b1),.in(ReadData2),.out(RegB_o));

    //MUX ALUSrcA OK
    wire [1:0] Sig_ALUSrcA
    wire [31:0] ALUSrcA;
    mux4 MUX_ALUSrcA(.d0(RegA_o),.d1(PC_o),.d2(Instr_o[10:6]),.s(Sig_ALUSrcA),.y(ALUSrcA));

    //EXT16 Instr[15:0] -> 31:0 SignEXT OK
    wire EXTOp;
    wire [31:0] Instr_32;
    EXT16 my_EXT(.Imm16(Instr_o[15:0]),.EXTOp(EXTOp),.Imm32(Instr_32));

    //MUX ALUSrcB OK
    wire [1:0] Sig_ALUSrcB
    wire [31:0] ALUSrcB;
    mux4 MUX_ALUSrcA(.d0(RegB_o),.d1(32'd4),.d2(Instr_32),.d3(Instr_32 << 2),.s(Sig_ALUSrcB),.y(ALUSrcB));

    //ALU OK
    wire [3:0] ALUOp;
    wire [31:0] ALUResult;
    wire zero;
    alu ALU(.A(ALUSrcA),.B(ALUSrcB),.ALUOp(ALUOp),.C(ALUResult),.Zero(zero));

    //ALUOut OK
    wire ALUOut_o;
    Regsiter ALUOut(.clk(clk),.WriteSignal(1'b1),.in(ALUResult),.out(ALUOut_o));

    //DM OK
    wire MemR;
    wire MemWr;
    wire [1:0] MemWrBits;
    wire [2:0] MemRBits;
    wire [31:0]ReadData;
    DM DataMemory(.clk(clk),.MemR(MemR),.MemWr(MemWr).MemWrBits(MemWrBits),.MemRBits(MemRBits),.addr(ALUOut_o),.data(ALUSrcB),.ReadData(ReadData));

    //MemData Register OK
    wire MemData_o;
    Register MemDataReg(.clk(clk),.WriteSignal(1'b1),.in(ReadData),.out(MemData_o));

    //WriteBack MUX OK
    wire MemtoReg;
    mux4 MUX_WriteBack(.d0(MemData_o),.d1(ALUOut_o),d2(PC_o),.s(MemtoReg),.y(WriteDataFinal));

    //MUX PCSrc
    wire [1:0] PCSrc
    mux4 MUX_PCSrc(.d0(ALUOut_o),.d1(ALUResult)
    ,.d2({PC_o[31:28],Instr_o[26:0]<<2,2'b00})
    ,.s(PCSrc),.y(PC_i));

    //Control
    Control




endmodule

    