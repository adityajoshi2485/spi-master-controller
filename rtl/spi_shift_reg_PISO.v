`timescale 1ns / 1ps
module spi_shift_reg_PISO(
    input        clk,
    input        rst,
    input        load,
    input        shift,    // shift enable - sclk rising edge pulse
    input  [7:0] data_in,
    output       mosi
);
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            shift_reg <= 8'd0;
        else if (load)
            shift_reg <= data_in;
        else if (shift)
            shift_reg <= shift_reg << 1;
    end

    assign mosi = shift_reg[7];
endmodule