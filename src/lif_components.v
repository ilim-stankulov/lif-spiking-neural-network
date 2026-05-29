`default_nettype none

module lif_neuron #(parameter THRESH = 8'sd64, SHIFT = 3) (
    input  wire clk, input  wire rst_n, input  wire ena,
    input  wire signed [7:0] current_in,
    output reg  spike, output reg signed [7:0] v_mem
);
    wire signed [7:0] leak = v_mem >>> SHIFT;
    wire signed [7:0] v_next = v_mem - leak + current_in;

    always @(posedge clk) begin
        if (!rst_n) begin
            v_mem <= 8'sd0;
            spike <= 1'b0;
        end else if (ena) begin
            if (spike) begin
                v_mem <= 8'sd0;
                spike <= 1'b0;
            end else if (v_next >= THRESH) begin
                v_mem <= 8'sd0;
                spike <= 1'b1;
            end else begin
                v_mem <= v_next;
                spike <= 1'b0;
            end
        end
    end
endmodule

