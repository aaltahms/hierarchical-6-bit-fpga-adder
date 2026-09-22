# Verification notes

## Recovered evidence

The original Vivado waveform shows six-bit `A`, `B`, `SUM`, `COUT`, `CIN` and generic `N=6`. Visible representative cases include:

| A | B | CIN | SUM | COUT | Interpretation |
| ---: | ---: | ---: | ---: | ---: | --- |
| 0 | 0 | 0 | 0 | 0 | zero case |
| 1 | 1 | 0 | 2 | 0 | simple addition |
| 5 | 3 | 0 | 8 | 0 | carry propagation within the word |
| 15 | 1 | 0 | 16 | multi-bit ripple |
| 31 | 1 | 0 | 32 | multi-bit ripple |
| 63 | 63 | 0 | 62 | 1 | seven-bit result 126 |
| 1 | 1 | 1 | 3 | 0 | carry-in behavior |

The recovered synthesis screenshot records an integration error: Vivado could not find the `seven_segment_display` design unit while elaborating `adder_top`. It demonstrates a real development failure, but not the final fix. In a public case study, use it to explain library/source inclusion and top-level integration rather than claiming a completed hardware result.

## Reconstructed testbench

The self-checking testbench enumerates all `64 x 64 x 2 = 8,192` combinations, including both carry-in values, and compares `COUT & SUM` with integer addition. All combinations passed under NVC 1.23.0 on September 22, 2026. All five RTL modules passed VHDL-2008 analysis. Display behavior, synthesis, constraints and board programming remain unverified.

## Hardware test matrix

After synthesis and programming, capture these board cases:

| A | B | Expected display |
| ---: | ---: | ---: |
| 0 | 0 | 000 |
| 1 | 0 | 001 |
| 1 | 1 | 002 |
| 5 | 3 | 008 |
| 31 | 1 | 032 |
| 63 | 1 | 064 |
| 63 | 63 | 126 |
