module crypto_validator (
    input logic [31:0] data_in,
    output logic [7:0] checksum_out
);
    // Lightweight 8-bit XOR checksum validation block for passport records
    always_comb begin
        checksum_out = data_in[31:24] ^ data_in[23:16] ^ data_in[15:8] ^ data_in[7:0];
    end
endmodule
