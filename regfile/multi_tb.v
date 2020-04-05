module multi_tb;
    reg[31:0] i_1,i_2,i_3,i_4;
    reg[1:0] sig;
    wire[31:0] out;
    mutliplexer testalu(sig,i_1,i_2,i_3,i_4,out);
    initial
    begin
        i_1 = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        i_2 = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        i_3 = 32'b1111_1111_1111_1111_0000_0000_0000_0000;
        i_4 = 32'b0000_0000_0000_0000_1111_1111_1111_1111;
        #10 sig = 2'b00;
        #10 sig = 2'b01;
        #10 sig = 2'b10;
        #10 sig = 2'b11;
        #10 $stop;
    end
endmodule