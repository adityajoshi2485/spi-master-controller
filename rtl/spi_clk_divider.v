`timescale 1ns / 1ps
module spi_clk_divider(
    input  clk, 
    input  rst, 
    output reg sclk
);
    reg [5:0] counter;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 6'd0;
            sclk    <= 1'b0;
        end
        else if (counter == 6'd49) begin 
            counter <= 6'd0;
            sclk    <= ~sclk;
        end    
        else 
            counter <= counter + 1;
    end
endmodule