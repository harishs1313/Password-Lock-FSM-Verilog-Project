`timescale 1ns / 1ps

module PasswordLockFSM_tb;

reg clk, reset, admin_mode, key_valid;
reg [3:0] key_in;
wire unlock, locked_out, error_led;
wire [2:0] state;

PasswordLockFSM dut (
    .clk(clk),
    .reset(reset),
    .admin_mode(admin_mode),
    .key_in(key_in),
    .key_valid(key_valid),
    .unlock(unlock),
    .locked_out(locked_out),
    .error_led(error_led),
    .state(state)
);

// Clock generation
initial clk = 0;
always #5 clk = ~clk;

task enter_password;
    input [15:0] password;
    integer i;
    begin
        for (i = 12; i >= 0; i = i - 4) begin
            key_in = password[i +: 4];
            key_valid = 1;
            #10;
            key_valid = 0;
            #10;
        end
    end
endtask

initial begin
    $dumpfile("PasswordLockFSM.vcd");
    $dumpvars(0, PasswordLockFSM_tb);

    reset = 1; key_valid = 0; admin_mode = 0;
    #20 reset = 0;

    // ✅ Correct password: A5 3 C
    $display("✅ Entering correct password");
    enter_password(16'b1010010100111100);
    #40;

    // ❌ Wrong attempts
    $display("❌ Wrong attempt 1");
    enter_password(16'b0000000000000000); #40;
    $display("❌ Wrong attempt 2");
    enter_password(16'b0000000000000000); #40;
    $display("❌ Wrong attempt 3 - should lock");
    enter_password(16'b0000000000000000); #100;

    // 🔧 Admin mode: Change password to 1 2 3 4
    admin_mode = 1;
    $display("🔧 Admin sets new password: 1 2 3 4");
    enter_password(16'b0001001000110100);
    admin_mode = 0; #40;

    // ✅ Test new password
    $display("✅ Trying new password: 1 2 3 4");
    enter_password(16'b0001001000110100);
    #40;

    $finish;
end

endmodule
