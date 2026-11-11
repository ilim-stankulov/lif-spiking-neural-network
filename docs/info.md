<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements the Leaky Integrate-and-Fire model in a simple 4-neuron spiking neural network chip designed for TinyTapeout GF180nm

Every neuron has a membrane potential and an incoming current. Each clock cycle, the neuron receives input current from neurons that fired in the previous cycle and leaks a fraction of its current voltage (1/8 of the current voltage) according to the following equation:

V[t+1] = V[t] - V[t]/8 + I[t]

Once the voltage inside a neuron reaches 64, it fires a spike and resets its membrane potential to 0.

Each neuron has eight synapses: four from the other neurons' spikes and four from external
stimulus inputs on ui[7:4]. Positive weights push the membrane potential towards threshold,
negative weights pull it away. The potential saturates at -128 and 127 instead of wrapping.

## How to test

1) Hold rst_n low for at least 3 clock cycles, then release. All membrane potentials and spike outputs clear to zero.

2) Assert ui[2] high (mode_prog = 1). Shift in 128 bits MSB-first by toggling ui[1] (s_clk_en) while driving ui[0] (s_data) with each bit. After 128 bits, uo[4] (prog_done) goes high confirming the weight matrix is fully loaded. De-assert ui[2].

3) Assert ena = 1 and drive one or more stimulus inputs high on ui[7:4]. Spike outputs appear
on uo[3:0], one bit per neuron. With all stimulus inputs low the network stays at rest.

4) Pulse ui[3] to step through the neurons; uo[6:5] shows which neuron is selected and
uio[7:0] shows its membrane potential as a signed 8-bit value.

## External hardware

No external hardware is required.