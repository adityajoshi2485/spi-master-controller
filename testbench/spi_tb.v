`timescale 1ns / 1ps
module tb_spi_master_top;

    reg        clk;
    reg        rst;
    reg        start;
    reg  [7:0] data_in;
    wire       mosi;
    wire       sclk;
    wire       ss;

    // Instantiate DUT
    spi_master_top uut (
        .clk     (clk),
        .rst     (rst),
        .start   (start),
        .data_in (data_in),
        .mosi    (mosi),
        .sclk    (sclk),
        .ss      (ss)
    );

    // 100 MHz clock
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst     = 1;
        start   = 0;
        data_in = 8'b10110011;   // 0xB3

        // Hold reset for 10 cycles
        repeat(10) @(posedge clk);
        rst = 0;

        // FIX: align start to clock edge
        repeat(5) @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        // 8 bits × 1000ns + margin
        #15000;

        // Second transfer
        data_in = 8'b11001100;   // 0xCC
        repeat(5) @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        #15000;

        $display("Simulation complete.");
        $finish;
    end

    initial begin
        $monitor("Time=%0t | ss=%b | sclk=%b | mosi=%b",
                  $time, ss, sclk, mosi);
    end

endmodule