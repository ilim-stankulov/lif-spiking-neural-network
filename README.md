![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# LIF Spiking Neural Network

A 4-neuron spiking neural network on GF180nm, submitted to Tiny Tapeout.

Each neuron implements the Leaky Integrate-and-Fire model: it integrates input current,
leaks a fraction of its membrane potential every clock cycle, and fires when the potential
reaches threshold. Each neuron has eight programmable synapses: four from the other neurons
and four from external stimulus inputs.

## How to use

1. Reset the chip
2. Program 128 weight bits via the serial interface
3. Drive stimulus spikes on `ui[7:4]` and observe spikes on `uo[3:0]`
4. Pulse `ui[3]` to choose which neuron's membrane potential appears on `uio[7:0]`

See [docs/info.md](docs/info.md) for full documentation.

## Pin mapping

Inputs
- `ui[0]` serial weight data
- `ui[1]` serial clock enable
- `ui[2]` programming mode
- `ui[3]` step to the next observed neuron
- `ui[7:4]` external stimulus spikes

Outputs
- `uo[3:0]` spike outputs, one per neuron
- `uo[4]` high when weight programming is complete
- `uo[6:5]` index of the observed neuron
- `uio[7:0]` membrane potential of the observed neuron
