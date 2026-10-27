module battery_id_reg (
    input logic clk,
    input logic rst_n,
    input logic [31:0] serial_num_in,
    input logic [15:0] chemistry_in,
    input logic [15:0] rated_capacity_in,
    input logic config_lock,
    output logic [31:0] serial_num_out,
    output logic [15:0] chemistry_out,
    output logic [15:0] rated_capacity_out
);

    logic [31:0] s_num;
    logic [15:0] s_chem;
    logic [15:0] s_cap;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_num <= 32'h0;
            s_chem <= 16'h0;
            s_cap <= 16'h0;
        end else if (!config_lock) begin
            s_num <= serial_num_in;
            s_chem <= chemistry_in;
            s_cap <= rated_capacity_in;
        end
    end

    assign serial_num_out = s_num;
    assign chemistry_out = s_chem;
    assign rated_capacity_out = s_cap;

endmodule
