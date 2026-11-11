/*
 * Copyright (c) 2026 Ilim Stankulov
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_lif_snn (
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire ena,
    input wire clk,
    input wire rst_n
);

    wire [3:0] spikes;
    wire prog_done;
    wire [127:0] weights;

    weight_storage ws (
        .clk(clk),
        .rst_n(rst_n),
        .s_data(ui_in[0]),
        .s_clk_en(ui_in[1]),
        .mode_prog(ui_in[2]),
        .weights(weights),
        .prog_done(prog_done)
    );

    reg [4:0] sync_a, sync_b;
    reg obs_step_d;
    reg [1:0] obs_sel;
    wire [3:0] stim = sync_b[4:1];
    wire obs_step = sync_b[0];

    always @(posedge clk) begin
        if (!rst_n) begin
            sync_a <= 5'b0;
            sync_b <= 5'b0;
            obs_step_d <= 1'b0;
            obs_sel <= 2'b0;
        end else begin
            sync_a <= ui_in[7:3];
            sync_b <= sync_a;
            obs_step_d <= obs_step;
            if (obs_step && !obs_step_d) obs_sel <= obs_sel + 2'd1;
        end
    end

    wire [7:0] all_spikes = {stim, spikes};
    wire signed [7:0] i0, i1, i2, i3;

    synapse_matrix sm (
        .all_spikes(all_spikes),
        .w(weights),
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .i3(i3)
    );

    wire signed [7:0] v0, v1, v2, v3;

    lif_neuron neuron0 (.clk(clk), .rst_n(rst_n), .ena(ena),
        .current_in(i0), .spike(spikes[0]), .v_mem(v0));
    lif_neuron neuron1 (.clk(clk), .rst_n(rst_n), .ena(ena),
        .current_in(i1), .spike(spikes[1]), .v_mem(v1));
    lif_neuron neuron2 (.clk(clk), .rst_n(rst_n), .ena(ena),
        .current_in(i2), .spike(spikes[2]), .v_mem(v2));
    lif_neuron neuron3 (.clk(clk), .rst_n(rst_n), .ena(ena),
        .current_in(i3), .spike(spikes[3]), .v_mem(v3));

    reg [7:0] v_obs;
    always @(*) begin
        case (obs_sel)
            2'd0: v_obs = v0;
            2'd1: v_obs = v1;
            2'd2: v_obs = v2;
            default: v_obs = v3;
        endcase
    end

    assign uio_out = v_obs;
    assign uio_oe = 8'hFF;
    assign uo_out = {1'b0, obs_sel, prog_done, spikes};
    wire _unused = &{uio_in, 1'b0};

endmodule
