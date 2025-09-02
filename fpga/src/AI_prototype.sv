// Blink LED at 2 Hz using UP5K internal HFOSC (12 MHz divided down)
module AI_prototype (
    output logic led    // active-high LED output
);

    // Internal high-frequency oscillator primitive
    logic clk_hf, clk_en;

    // Instantiate iCE40UP5K HFOSC
    // CLKHF_DIV options: "0b00"=48MHz, "0b01"=24MHz, "0b10"=12MHz
SB_HFOSC #(
    .CLKHF_DIV("0b10")   // 48 MHz / 4 = 12 MHz
) hfosc_inst (
    .CLKHF(clk_hf),      // clock output
    .CLKHFEN(1'b1),      // enable
    .CLKHFPU(1'b1)       // power up
);


    // Counter to divide 12 MHz down to 2 Hz (toggle every 6M cycles)
    localparam int unsigned DIVISOR = 6_000_000;
    localparam int COUNTER_WIDTH = $clog2(DIVISOR);

    logic [COUNTER_WIDTH-1:0] counter;

    // Clock divider logic
    always_ff @(posedge clk_hf) begin
        if (counter == DIVISOR-1) begin
            counter <= '0;
            led <= ~led;   // toggle LED
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
