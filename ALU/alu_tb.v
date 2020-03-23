`timescale 1ns/1ps
`include "alu.v"
module alu_tb;
    reg[31:0] a,b;
    reg[2:0] opcode;
    wire[2:0] d;
    wire[31:0] c;

    parameter  sla = 3'b000,
               sra = 3'b001,
               add = 3'b010,
               sub = 3'b011,
               mul = 3'b100,
               andd = 3'b101,
               ord = 3'b110,
               notd= 3'b111;

    alu testalu(a,b,opcode,c,d);

    initial
    begin
        //arith left shift
        //#10表示两条语句之间延迟10个单位时间

        #10 a = 32'b1100_0010_1001_1011_0010_1100_1100_0001;
        opcode = sla;
        #10 a = 32'b1000_0010_1001_1011_0010_1100_1100_0001;
        opcode = sla;
        #10 a = 32'b0010_0010_1001_1011_0010_1100_1100_0001;
        opcode = sla;
        #10 a = 32'b0110_0010_1001_1011_0010_1100_1100_0001;
        opcode = sla;
        #10 a = 32'b1100_0010_1001_1011_0010_1100_1100_0001;
        opcode = notd;
        #10 a = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        opcode = notd;
	    #10 a = 32'b1100_0010_1001_1011_0010_1100_1100_0001;
	    b = 32'b1101_0010_1101_0010_0011_0010_0001_0010;
	    opcode = andd;
	    #10 a = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
	    b = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
	    opcode = andd;
	    #10 a = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
	    b = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
	    opcode = ord;
	    #10 a = 32'b1100_0010_1001_1011_0010_1100_1100_0001;
	    b = 32'b1101_0010_1101_0010_0011_0010_0001_0010;
	    opcode = ord;
        //负数相加未溢出
        #10 a = 32'b1001_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b1000_0010_1101_0010_0011_0010_0001_0010;
        opcode = add;
        //负数相加溢出
        #10 a = 32'b1101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b1100_0010_1101_0010_0011_0010_0001_0010;
        opcode = add;
        //正数相加未
        #10 a = 32'b0001_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b0000_0010_1101_0010_0011_0010_0001_0010;
        opcode = add;
        //正数相加溢出
        #10 a = 32'b1101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b1100_0010_1101_0010_0011_0010_0001_0010;
        opcode = add;
        //正负相加
        #10 a = 32'b0101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b1100_0010_1101_0010_0011_0010_0001_0010;
        opcode = add;

        //负数相减溢出
        #10 a = 32'b1000_0010_0000_0000_0000_0000_0000_0000;
        b = 32'b1000_0010_1101_0010_0011_0010_0001_0010;
        opcode = sub;
        //负数相减未溢出
        #10 a = 32'b1101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        opcode = sub;
        //正数相减未
        #10 a = 32'b0001_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b0000_0010_1101_0010_0011_0010_0001_0010;
        opcode = sub;
        //正-负溢出
        #10 a = 32'b1101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b1000_0010_0000_0000_0000_0000_0000_0000;
        opcode = sub;
        //正-负未
        #10 a = 32'b0101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        opcode = sub;
        //负-正溢出
        #10 a = 32'b1000_0010_0000_0000_0000_0000_0000_0000;
        b = 32'b0011_1111_1111_1111_1111_1111_1111_1111;
        opcode = sub;
        //负-正未
        #10 a = 32'b1000_0010_0000_0000_0000_0000_0000_0000;
        b = 32'b0000_0010_0000_0000_0000_0000_0000_0001;
        opcode = sub;
        //-为0
        #10 a = 32'b0101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b0101_0010_1001_1011_0010_1100_1100_0001;
        opcode = sub;
        //负负溢出
        #10 a = 32'b1000_0010_0000_0000_0000_0000_0000_0000;
        b = 32'b1000_0010_0000_0000_0000_0000_0000_1111;
        opcode = mul;
        //负负未溢出
        #10 a = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        b = 32'b1000_0010_0000_0000_0000_0000_0000_1111;
        opcode = mul;
        //正正溢出
        #10 a = 32'b0101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b0101_0010_1001_1011_0010_1100_1100_0001;
        opcode = mul;
        //正正未溢出
        #10 a = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        b = 32'b0101_0010_1001_1011_0010_1100_1100_0001;
        opcode = mul;
        //正负溢出
        #10 a = 32'b0101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b1000_0010_0000_0000_0000_0000_0000_1111;
        opcode = mul;
        //正负未溢出
        #10 a = 32'b0000_0000_0000_0000_0000_0000_0000_1001;
        b = 32'b1111_1111_1111_1111_1111_1111_1111_0011;
        opcode = mul;
        //乘0
        #10 a = 32'b0101_0010_1001_1011_0010_1100_1100_0001;
        b = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        opcode = mul;
        #10 $finish;
    end
endmodule
    

