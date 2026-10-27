module fault_detector (
    input logic clk,
    input logic rst_n,
    input logic over_voltage,
    input logic under_voltage,
    input logic over_temp,
    output logic [3:0] fault_flags,
    output logic fault_locked
);

    logic [3:0] faults;
    logic lock;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            faults <= 4'b0000;
            lock <= 1'b0;
        end else begin
            if (over_voltage) begin
                faults[0] <= 1'b1;
                lock <= 1'b1;
            end
            if (under_voltage) begin
                faults[1] <= 1'b1;
                lock <= 1'b1;
            end
            if (over_temp) begin
                faults[2] <= 1'b1;
                lock <= 1'b1;
            end
        end
    end

    assign fault_flags = faults;
    assign fault_locked = lock;

endmodule
