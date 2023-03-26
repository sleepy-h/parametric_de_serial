`timescale 1ns / 1ps

//Written by sleepy_h(Kosyanov Oleg)

// Parametric testbench of de_serial module
// IN - width of input bus.
// OUT - width of output bus.
// BASE_DELAY - delay between starts of clk_in and clk_out. 

module de_serial_tb;
    parameter IN = 12;
    parameter OUT = 25;
    parameter BASE_DELAY = OUT * IN;
    
    reg [IN-1:0] in;
    reg clk_in, clk_out; 
    wire [OUT-1:0] out;
        
    de_serial #(.IN(IN), .OUT(OUT)) uut (
        .in(in),
        .clk_in(clk_in),
        .clk_out(clk_out),
        .out(out)
    );
    
    initial in = 0;
    initial clk_in = 0;
    initial clk_out = 0;
    always #(IN) clk_in = ~clk_in;
    always #(2*IN) in = in + 1;
    //always #(OUT) clk_out = ~clk_out;
    
    initial begin
        #(BASE_DELAY); 
        forever
            #(OUT) clk_out = ~clk_out;
    end 
endmodule