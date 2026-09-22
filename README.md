# Hierarchical 6-Bit FPGA Adder

A VHDL reconstruction and extension of a University of Guelph ENGG3050 course lab. The design builds a parameterized ripple-carry adder from half- and full-adder modules, then connects two six-bit switch inputs to LEDs and a multiplexed seven-segment display on a Digilent Nexys A7-100T.

> Provenance: the original course submission is not present in this repository. This implementation was recreated from the recovered assignment requirements and simulation evidence. It should not be represented as the untouched original submission.

## Architecture

```text
SW[5:0] ─────── A ─┐
                   ├─> generic ripple-carry adder ─> COUT & SUM ─> decimal display
SW[11:6] ────── B ─┘              │
                                  └─> six generated full adders
                                       └─> two half adders each
```

Two unsigned six-bit operands cover `0..63`. Their complete result is seven bits and covers `0..126`.

## Repository layout

```text
rtl/         synthesizable VHDL modules
sim/         self-checking VHDL testbench
constraints/ Nexys A7-100T pin constraints
docs/        design and verification notes
.github/     GHDL continuous-integration workflow
```

## Verification

`tb_ripple_carry_adder.vhd` exhaustively checks all 8,192 combinations of six-bit inputs and carry-in and asserts both the six-bit sum and carry output.

With GHDL or NVC installed:

```bash
sh scripts/test.sh
```

The recovered original Vivado waveform showed representative cases including `0+0`, `1+1`, `5+3`, `15+1`, `31+1`, `63+63`, and `1+1` with carry-in enabled. The reconstructed exhaustive testbench passed on NVC 1.23.0 on September 22, 2026. All RTL files, including the display controller and top level, also passed analysis. Display behavior and physical hardware remain unverified.

## Hardware flow

1. Add the files in `rtl/` to a Vivado project.
2. Set `adder_top` as the top design source.
3. Add `constraints/NexysA7_100T.xdc`.
4. Run synthesis, implementation and bitstream generation.
5. Program a Nexys A7-100T.
6. Use `SW0..SW5` for operand A and `SW6..SW11` for operand B. LEDs mirror the inputs and the three rightmost seven-segment digits show the decimal result.

## Design choices

- The arithmetic path is structural and parameterized so the hierarchy is visible and reusable.
- `COUT & SUM` preserves the seventh result bit; otherwise `63 + 63` would be truncated.
- The display controller uses a refresh counter to select the ones, tens and hundreds anodes in rapid succession.
- Anodes and segment cathodes are active-low on the Nexys A7.

## Current limits

- The reconstruction has not yet been synthesized or programmed on the physical board.
- Decimal conversion uses integer division/modulo for clarity; synthesis results should be reviewed before treating it as a production-quality display path.
- Only the three rightmost digits are used because the maximum result is 126.
