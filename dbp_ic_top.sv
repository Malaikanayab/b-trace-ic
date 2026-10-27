module dbp_ic_top (
    input logic clk,
    input logic rst_n,
    input logic [31:0] serial_num_in,
    input logic [15:0] chemistry_in,
    input logic [15:0] rated_capacity_in,
    input logic config_lock,
    input logic charge_pulse,
    input logic discharge_pulse,
    input logic over_voltage,
    input logic under_voltage,
    input logic over_temp,
    output logic [15:0] cycle_count_out,
    output logic [3:0] fault_flags_out,
    output logic [7:0] passport_checksum
);

    logic [31:0] s_num;
    logic [15:0] s_chem;
    logic [15:0] s_cap;
    logic [31:0] total_energy;
    logic fault_lock;

    // Instantiate Battery ID Register Block
    battery_id_reg u_id_reg (
        .clk(clk),
        .rst_n(rst_n),
        .serial_num_in(serial_num_in),
        .chemistry_in(chemistry_in),
        .rated_capacity_in(rated_capacity_in),
        .config_lock(config_lock),
        .serial_num_out(s_num),
        .chemistry_out(s_chem),
        .rated_capacity_out(s_cap)
    );

    // Instantiate Usage Logger Block
    usage_logger u_usage (
        .clk(clk),
        .rst_n(rst_n),
        .charge_pulse(charge_pulse),
        .discharge_pulse(discharge_pulse),
        .cycle_count(cycle_count_out),
        .total_energy_counter(total_energy)
    );

    // Instantiate Fault Detector Block
    fault_detector u_faults (
        .clk(clk),
        .rst_n(rst_n),
        .over_voltage(over_voltage),
        .under_voltage(under_voltage),
        .over_temp(over_temp),
        .fault_flags(fault_flags_out),
        .fault_locked(fault_lock)
    );

    // Instantiate Validation/Checksum Block
    crypto_validator u_validator (
        .data_in(s_num),
        .checksum_out(passport_checksum)
    );

endmodule
