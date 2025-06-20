`timescale 1ns / 1ps

module PasswordLockFSM (
    input clk,
    input reset,
    input admin_mode,
    input [3:0] key_in,
    input key_valid,
    output reg unlock,
    output reg locked_out,
    output reg error_led,
    output reg [2:0] state  // For debug
);

// FSM States
localparam IDLE         = 3'd0,
           INPUT_1      = 3'd1,
           INPUT_2      = 3'd2,
           INPUT_3      = 3'd3,
           INPUT_4      = 3'd4,
           UNLOCKED     = 3'd5,
           LOCKED       = 3'd6;

reg [3:0] stored_password[3:0]; // 4-digit password
reg [3:0] user_input[3:0];
reg [1:0] input_index;
reg [1:0] attempt_count;
reg [3:0] lockout_timer;
reg [3:0] timeout_counter;

wire input_timeout = (timeout_counter >= 4'd10);

integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        unlock <= 0;
        locked_out <= 0;
        error_led <= 0;
        attempt_count <= 0;
        lockout_timer <= 0;
        timeout_counter <= 0;

        // Default password: 4'b1010_0101_0011_1100
        stored_password[0] <= 4'b1010;
        stored_password[1] <= 4'b0101;
        stored_password[2] <= 4'b0011;
        stored_password[3] <= 4'b1100;

    end else begin
        timeout_counter <= timeout_counter + 1;

        // Lockout mode
        if (locked_out) begin
            lockout_timer <= lockout_timer - 1;
            if (lockout_timer == 0) begin
                locked_out <= 0;
                attempt_count <= 0;
                state <= IDLE;
            end
        end

        if (!locked_out) begin
            case (state)
                IDLE: begin
                    unlock <= 0;
                    error_led <= 0;
                    input_index <= 0;
                    if (key_valid) begin
                        user_input[0] <= key_in;
                        input_index <= 1;
                        state <= INPUT_1;
                        timeout_counter <= 0;
                    end
                end

                INPUT_1, INPUT_2, INPUT_3: begin
                    if (key_valid) begin
                        user_input[input_index] <= key_in;
                        input_index <= input_index + 1;
                        state <= state + 1;
                        timeout_counter <= 0;
                    end else if (input_timeout) begin
                        state <= IDLE;
                    end
                end

                INPUT_4: begin
                    if (key_valid) begin
                        user_input[3] <= key_in;
                        timeout_counter <= 0;

                        if (admin_mode) begin
                            // Change password
                            for (i = 0; i < 4; i = i + 1)
                                stored_password[i] <= user_input[i];
                            state <= IDLE;
                        end else begin
                            // Check password
                            if ((user_input[0] == stored_password[0]) &&
                                (user_input[1] == stored_password[1]) &&
                                (user_input[2] == stored_password[2]) &&
                                (user_input[3] == stored_password[3])) begin
                                unlock <= 1;
                                error_led <= 0;
                                state <= UNLOCKED;
                            end else begin
                                attempt_count <= attempt_count + 1;
                                error_led <= 1;
                                unlock <= 0;

                                if (attempt_count == 2) begin
                                    locked_out <= 1;
                                    lockout_timer <= 4'd10;
                                    state <= LOCKED;
                                end else begin
                                    state <= IDLE;
                                end
                            end
                        end
                    end else if (input_timeout) begin
                        state <= IDLE;
                    end
                end

                UNLOCKED: begin
                    // Unlock will stay for a short period
                    unlock <= 0;
                    state <= IDLE;
                end

                LOCKED: begin
                    // Wait handled above
                    error_led <= 0;
                    unlock <= 0;
                end

            endcase
        end
    end
end

endmodule
