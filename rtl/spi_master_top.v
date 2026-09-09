`timescale 1ns / 1ps
module spi_master_top(
    input        clk,
    input        rst,
    input        start,
    input  [7:0] data_in,
    output       mosi,
    output       sclk,
    output       ss
);
    wire        load;
    wire        enable;
    wire        done;
    wire [2:0]  count;


    reg sclk_prev;
    wire sclk_re;

    always @(posedge clk or posedge rst) begin
        if (rst) sclk_prev <= 1'b0;
        else     sclk_prev <= sclk;
    end

    assign sclk_re = (sclk == 1'b1) && (sclk_prev == 1'b0);

    
    spi_clk_divider clk_div (
        .clk  (clk),
        .rst  (rst),
        .sclk (sclk)
    );

   
    spi_fsm fsm (
        .clk     (clk),
        .rst     (rst),
        .start   (start),
        .done    (done),
        .sclk_re (sclk_re),
        .ss      (ss),
        .load    (load),
        .enable  (enable)
    );

    
    spi_shift_reg_PISO shift_reg (
        .clk     (clk),
        .rst     (rst),
        .load    (load),
        .shift   (sclk_re && enable),
        .data_in (data_in),
        .mosi    (mosi)
    );

   
    spi_bit_counter bit_ctr (
        .clk      (clk),
        .rst      (rst),
        .load     (load),
        .count_en (sclk_re && enable),
        .count    (count),
        .done     (done)
    );

endmodule