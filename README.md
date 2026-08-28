
# Configurable Approximate Multiply-Accumulate (MAC)

## Overview

This project implements a configurable signed INT8 Multiply-Accumulate (MAC) architecture with runtime-selectable exact and approximate multiplication modes.

The objective is to quantify the trade-off between numerical accuracy and hardware cost. The project includes exhaustive functional verification and SKY130 standard-cell synthesis.

---

## Operating Modes

| Mode | Operation                               |
| ---- | --------------------------------------- |
| `00` | Exact signed INT8 × INT8 multiplication |
| `01` | Medium architectural approximation      |
| `10` | Strong architectural approximation      |
| `11` | Exact default                           |

---

## Approximation Method

### Exact Mode

The full signed INT8 × INT8 multiplication is performed without approximation.

### Medium Approximation

Each signed operand is arithmetically right-shifted by 1 bit. The resulting 7-bit operands are multiplied, and the product is left-shifted by 2 bits to restore the binary weight.

```text
A' = A >>> 1
B' = B >>> 1
P  = (A' × B') <<< 2
```

This implements an effective signed 7-bit × 7-bit multiplication.

### Strong Approximation

Each signed operand is arithmetically right-shifted by 2 bits. The resulting 6-bit operands are multiplied, and the product is left-shifted by 4 bits to restore the binary weight.

```text
A' = A >>> 2
B' = B >>> 2
P  = (A' × B') <<< 4
```

This implements an effective signed 6-bit × 6-bit multiplication.

---

## Accuracy Results

All 65,536 possible signed INT8 input combinations were evaluated.

| Mode   | Error Rate |        MAE |          MSE | Maximum Error |
| ------ | ---------: | ---------: | -----------: | ------------: |
| Exact  |  0.000000% |   0.000000 |     0.000000 |             0 |
| Medium | 74.609375% |  53.333984 |  5461.750000 |           255 |
| Strong | 93.164062% | 149.784302 | 38236.250000 |           759 |

---

## SKY130 Synthesis Results

| Design                        | Cells |   Chip Area |
| ----------------------------- | ----: | ----------: |
| Exact Multiplier              |   295 | 2310.966400 |
| Medium Approximate Multiplier |   211 | 1776.704000 |
| Strong Approximate Multiplier |   149 | 1259.958400 |
| Configurable Multiplier       |   636 | 5342.624000 |
| Configurable MAC              |   885 | 7213.168000 |

The configurable MAC result includes sequential-cell mapping for the accumulator.

---

## Hardware Savings vs Exact Multiplier

| Approximation | Cell Reduction | Area Reduction |
| ------------- | -------------: | -------------: |
| Medium        |        28.475% |        23.118% |
| Strong        |        49.492% |        45.479% |

---

## Verification

### Exact Multiplier

All 65,536 signed INT8 input combinations were tested.

**Result: PASS — 0 errors**

### Configurable Multiplier

All 65,536 signed INT8 input combinations were evaluated for every operating mode.

### Configurable MAC

The self-checking testbench verifies:

* Reset
* Exact accumulation
* Signed negative multiplication
* Medium approximation
* Strong approximation
* Clear operation
* Enable/hold behavior

Final result:

**PASS: CONFIGURABLE MAC SELF-CHECK PASSED.**

---

## Repository Structure

```text
approximate_mac/
├── rtl/        # SystemVerilog RTL
├── tb/         # Self-checking testbenches
├── scripts/    # Synthesis scripts
├── results/    # Synthesis logs and netlists
├── docs/       # Documentation and figures
└── README.md
```

---

## Running Configurable MAC Verification

```bash
iverilog -g2012 -s configurable_mac_check_tb \
    -o configurable_mac_check_sim \
    rtl/configurable_mac.sv \
    rtl/configurable_multiplier.sv \
    tb/configurable_mac_check_tb.sv

vvp configurable_mac_check_sim
```

Expected result:

```text
PASS: CONFIGURABLE MAC SELF-CHECK PASSED.
```

---

## Conclusion

This project demonstrates a configurable approximate computing architecture that dynamically trades numerical accuracy for hardware cost.

The architectural approximations show a clear accuracy-versus-hardware trade-off:

* **Medium mode:** 28.475% cell-count reduction and 23.118% area reduction.
* **Strong mode:** 49.492% cell-count reduction and 45.479% area reduction.

The configurable MAC supports runtime selection between exact and approximate computation with signed INT32 accumulation.

The design was exhaustively characterized at the multiplier level, verified with a self-checking MAC testbench, and synthesized using the SKY130 HD standard-cell library.
