# Configurable Approximate Multiply-Accumulate (MAC)

## Overview

This project implements a configurable signed 8-bit Multiply-Accumulate (MAC) architecture with selectable exact and approximate multiplication modes.

The design explores the trade-off between **computational accuracy and hardware cost**. It includes exact multiplication, baseline approximate multipliers, architectural approximate multipliers, a configurable multiplier, and a clocked configurable MAC.

The design was verified using exhaustive simulation and synthesized using the SKY130 standard-cell library.

---

## Key Features

* Signed INT8 × INT8 multiplication
* Exact multiplication mode
* Multiple approximate multiplication modes
* Runtime-selectable accuracy modes
* Signed INT32 accumulation
* Reset, clear, and enable controls
* Exhaustive functional verification
* SKY130 standard-cell technology mapping

---

## Architecture

```text
        +---------------------------+
A ----->|                           |
B ----->|  Configurable Multiplier  |---- Product
Mode --->|                           |
        +-------------+-------------+
                      |
                      v
               +-------------+
Clock -------->|             |
Reset -------->|     MAC     |---- ACC[31:0]
Clear -------->| Accumulator |
Enable ------->|             |
               +-------------+
```

### Operating Modes

| Mode | Operation                          |
| ---- | ---------------------------------- |
| `00` | Exact multiplication               |
| `01` | Medium architectural approximation |
| `10` | Strong architectural approximation |
| `11` | Reserved / exact default           |

---

## Results

### Exact vs Approximate SKY130 Comparison

| Design                                      | Cells |   Chip Area |
| ------------------------------------------- | ----: | ----------: |
| Exact Multiplier                            |   295 | 2310.966400 |
| Medium Architectural Approximate Multiplier |   211 | 1776.704000 |

The medium architectural approximation achieved:

* **28.475% cell-count reduction**
* **23.118% area reduction**

### Approximation Accuracy

| Mode   | Error Rate |        MAE | Maximum Error |
| ------ | ---------: | ---------: | ------------: |
| Exact  |  0.000000% |   0.000000 |             0 |
| Medium | 74.609375% |  53.333984 |           255 |
| Strong | 93.164062% | 149.784302 |           759 |

---

## Repository Structure

```text
approximate_mac/
├── rtl/                    # SystemVerilog RTL designs
├── tb/                     # Self-checking testbenches
├── scripts/                # Synthesis scripts
├── results/
│   ├── synthesis/          # SKY130 synthesis logs
│   ├── netlists/           # Technology-mapped netlists
│   └── summary.md          # Final project results
├── docs/                   # Documentation
└── README.md
```

---

## Verification

The exact multiplier was exhaustively tested using all 65,536 possible signed INT8 input combinations.

The configurable multiplier was also exhaustively characterized across its operating modes.

The configurable MAC was verified using a self-checking testbench covering:

* Reset
* Exact multiplication
* Negative multiplication
* Approximate modes
* Accumulation
* Clear
* Enable/hold operation

Final result:

```text
PASS: CONFIGURABLE MAC SELF-CHECK PASSED.
```

---

## Technology

* **RTL:** SystemVerilog
* **Simulation:** Icarus Verilog
* **Synthesis:** Yosys
* **Technology Mapping:** ABC
* **PDK:** SKY130
* **Standard Cell Library:** sky130_fd_sc_hd

---

## Conclusion

Architectural approximation provides measurable hardware savings compared with simple output truncation. This project demonstrates a configurable MAC that can dynamically trade numerical accuracy for reduced hardware complexity.
