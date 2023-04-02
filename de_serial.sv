`timescale 1ns / 1ps

//Written by sleepy_h(Kosyanov Oleg) and Dmitriy Aminev

// de_serial - is parametric module of  Serializer(Deserializer).
// IN - width of input bus.
// OUT - width of output bus.
// if IN < OUT, then work like deserializer.
// if IN > OUT, then work like serializer.
// if IN = OUT, the work like limited FIFO.

module de_serial (in, clk_in, clk_out, out);
    parameter IN = 12;
    parameter OUT = 25;
    localparam IN_WIDTH = $clog2(IN);
    localparam OUT_WIDTH = $clog2(OUT);

    input [IN-1:0] in;
    input clk_in, clk_out;
    output [OUT-1:0] out;

    reg [OUT_WIDTH-1:0] cnt_in;
    reg [IN_WIDTH-1:0] cnt_out;
    reg [IN*OUT-1:0] data;
    wire [IN*OUT-1:0] data_in;
    wire [OUT-1:0] data_out [IN:0];
    
    assign data_out[0] = {OUT{1'bX}};
    assign out = data_out[IN];
        
    genvar i;
    
    generate
        for (i = 0; i < OUT; i = i + 1) begin  
            assign data_in[IN*(i+1)-1:i*IN] = (cnt_in == i) ? in : data[IN*(i + 1) - 1:i*IN];
        end
        for (i = 0; i < IN; i = i + 1) begin  
            assign data_out[i + 1] = (cnt_out == i) ? data[OUT*(i+1)-1:OUT*i] : data_out[i];
        end
    endgenerate
    
    initial cnt_in = 0;
    initial cnt_out = 0;
    
    always@(posedge clk_in) begin 
        data <= data_in;
        cnt_in = cnt_in + 1;
        if (cnt_in == OUT)
            cnt_in = 0;
    end
    
    always@(posedge clk_out) begin 
        cnt_out = cnt_out + 1;
        if (cnt_out == IN)
            cnt_out = 0;
    end
endmodule
