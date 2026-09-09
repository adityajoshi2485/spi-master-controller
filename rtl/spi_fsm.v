`timescale 1ns / 1ps
module spi_fsm(
    input      clk,
    input      rst,
    input      start,
    input      done,
    input      sclk_re,   // rising edge pulse of sclk
    output reg ss,
    output reg load,
    output reg enable
);
    reg [1:0] current_state;

    parameter IDLE     = 2'b00,
              LOAD     = 2'b01,
              TRANSFER = 2'b10,
              DONE     = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            ss            <= 1'b1;
            load          <= 1'b0;
            enable        <= 1'b0;
        end else begin
            // defaults each cycle
            load   <= 1'b0;
            enable <= 1'b0;

            case (current_state)
                IDLE: begin
                    ss <= 1'b1;
                    if (start) begin
                        current_state <= LOAD;
                    end
                end

                LOAD: begin
                    ss            <= 1'b0;
                    load          <= 1'b1;   // one clk pulse
                    current_state <= TRANSFER;
                end

                TRANSFER: begin
                    ss     <= 1'b0;
                    enable <= 1'b1;
                    if (sclk_re && done) begin
                        current_state <= DONE;
                    end
                end

                DONE: begin
                    ss            <= 1'b1;
                    current_state <= IDLE;
                end
            endcase
        end
    end
endmodule