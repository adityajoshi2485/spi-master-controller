`timescale 1ns / 1ps
module spi_bit_counter(
    input            clk,
    input            rst,
    input            load,
    input            count_en,   // count enable - sclk rising edge pulse
    output reg [2:0] count,
    output           done
);
    always @(posedge clk or posedge rst) begin
        if (rst || load)
            count <= 3'd0;
        else if (count_en && count < 3'd7)
            count <= count + 1;
    end

    assign done = (count == 3'd7);
endmodule