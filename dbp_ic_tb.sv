`timescale 1ns / 1ps

module dbp_ic_tb;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic [31:0] serial_num_in;
    logic [15:0] chemistry_in;
    logic [15:0] rated_capacity_in;
    logic config_lock;
    logic charge_pulse;
    logic discharge_pulse;
    logic over_voltage;
    logic under_voltage;
    logic over_temp;
    
    // Outputs from DUT (Device Under Test)
    logic [15:0] cycle_count_out;
    logic [3:0] fault_flags_out;
    logic [7:0] passport_checksum;

    // Instantiate the Top Module (DUT)
    dbp_ic_top u_dut (
        .clk(clk),
        .rst_n(rst_n),
        .serial_num_in(serial_num_in),
        .chemistry_in(chemistry_in),
        .rated_capacity_in(rated_capacity_in),
        .config_lock(config_lock),
        .charge_pulse(charge_pulse),
        .discharge_pulse(discharge_pulse),
        .over_voltage(over_voltage),
        .under_voltage(under_voltage),
        .over_temp(over_temp),
        .cycle_count_out(cycle_count_out),
        .fault_flags_out(fault_flags_out),
        .passport_checksum(passport_checksum)
    );

    // Clock Generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    // Test Procedure
    initial begin
        // Initialize Signals
        clk = 0;
        rst_n = 0;
        serial_num_in = 32'h12345678;
        chemistry_in = 16'h1001;      // e.g., LiFePO4 code
        rated_capacity_in = 16'h3000; // e.g., 3000 mAh
        config_lock = 0;
        charge_pulse = 0;
        discharge_pulse = 0;
        over_voltage = 0;
        under_voltage = 0;
        over_temp = 0;

        // Apply Reset
        #20;
        rst_n = 1;
        #10;

        // Step 1: Lock configuration after initial setup
        $display("[%0t] Locking battery configuration registers...", $time);
        config_lock = 1;
        #20;

        // Step 2: Simulate Battery Usage (Charge/Discharge Cycles)
        $display("[%0t] Simulating charge/discharge cycles...", $time);
        
        // Cycle 1
        discharge_pulse = 1;
        #40;
        discharge_pulse = 0;
        #20;
        charge_pulse = 1;   // Rising edge completes a cycle
        #40;
        charge_pulse = 0;
        #20;

        // Cycle 2
        discharge_pulse = 1;
        #40;
        discharge_pulse = 0;
        #20;
        charge_pulse = 1;
        #40;
        charge_pulse = 0;
        #20;

        // Step 3: Inject a Fault Event (e.g., Over-voltage warning)
        $display("[%0t] Injecting Over-Voltage Fault...", $time);
        over_voltage = 1;
        #20;
        over_voltage = 0;
        #40;

        // Final Status Display
        $display("----------------------------------------");
        $display("Simulation Complete!");
        $display("Final Cycle Count: %0d", cycle_count_out);
        $display("Fault Flags: 0x%h", fault_flags_out);
        $display("Passport Checksum: 0x%h", passport_checksum);
        $display("----------------------------------------");
        
        $finish;
    end

endmodule
