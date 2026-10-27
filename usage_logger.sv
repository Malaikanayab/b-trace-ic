module usage_logger (
    input logic clk,
    input logic rst_n,
    input logic charge_pulse,
    input logic discharge_pulse,
    output logic [15:0] cycle_count,
    output logic [31:0] total_energy_counter
);

    logic [15:0] cycles;
    logic [31:0] energy;
    logic prev_charge;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycles <= 16'h0;
            energy <= 32'h0;
            prev_charge <= 1'b0;
        end else begin
            prev_charge <= charge_pulse;
            
            // Increment energy metric on active use
            if (charge_pulse || discharge_pulse) begin
                energy <= energy + 1;
            end

            // Count a full cycle transition (rising edge of charge pulse after discharge)
            if (charge_pulse && !prev_charge) begin
                cycles <= cycles + 1;
            end
        end
    end

    assign cycle_count = cycles;
    assign total_energy_counter = energy;

endmodule
