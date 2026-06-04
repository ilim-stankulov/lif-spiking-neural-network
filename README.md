![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# LIF Spiking Neural Network

A 4-neuron spiking neural network on GF180nm, submitted to Tiny Tapeout.

Each neuron implements the Leaky Integrate-and-Fire model — intake input current, leak over each clock cycle,
fire when the voltage reaches threshold. The four neurons are fully connected through a programmable
weight matrix.

## How to use

1. Reset the chip
2. Program 128 weight bits via the serial interface
3. Enable the network and observe spikes on the output pins

See [docs/info.md](docs/info.md) for full documentation.

## Pin mapping

Inputs: 
`ui[0]` - serial weight data
`ui[1]` - serial clock enable
`ui[2]` - programming mode.

Outputs: 
`uo[0..3]` - spike outputs for each neuron
`uo[4]` - goes high when weight programming is complete.
