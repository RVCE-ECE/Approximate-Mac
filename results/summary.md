# Approximate MAC Project Results Summary

## 1. Project Overview

This project implements a configurable signed INT8 Multiply-Accumulate (MAC) architecture with runtime-selectable exact and approximate multiplication modes.

The objective is to quantify the trade-off between numerical accuracy and hardware cost. The project includes exhaustive functional verification and SKY130 standard-cell synthesis.

---

## 2. Verification

### Exact Multiplier

The signed 8-bit × 8-bit exact multiplier was exhaustively tested.

* Total input combinations: 65,536
* Errors found: 0
* Result: **PASS**

### Configurable Multiplier

All 65,536 signed INT8 input combinations were evaluated for each operating mode.

| Mode | Operation | Error Rate | MAE | MSE | Maximum Error |
|---|---|---:|---:|---:|---:|
| `00` | Exact | 0.000000% | 0.000000 | 0.000000 | 0 |
| `01` | Medium approximation | 74.609375% | 53.333984 | 5461.750000 | 255 |
| `10` | Strong approximation | 93.164062% | 149.784302 | 38236.250000 | 759 |
| `11` | Exact default | 0.000000% | 0.000000 | 0.000000 | 0 |

### Configurable MAC

The self-checking MAC testbench verified:

* Reset
* Exact accumulation
* Signed negative multiplication
* Medium approximation mode
* Strong approximation mode
* Clear operation
* Enable/hold behavior

Final result:

**PASS — CONFIGURABLE MAC SELF-CHECK PASSED**

---

## 3. Approximation Architecture

### Exact Mode

The full signed INT8 × INT8 multiplication is performed.

### Medium Approximation

Each signed operand is arithmetically right-shifted by 1 bit. The resulting 7-bit operands are multiplied, and the product is left-shifted by 2 bits to restore the binary weight.

This implements an effective signed 7-bit × 7-bit multiplication.

### Strong Approximation

Each signed operand is arithmetically right-shifted by 2 bits. The resulting 6-bit operands are multiplied, and the product is left-shifted by 4 bits to restore the binary weight.

This implements an effective signed 6-bit × 6-bit multiplication.

---

## 4. SKY130 Synthesis Results

Technology mapping was performed using Yosys, ABC, and the SKY130 HD standard-cell library.

| Design | Cells | Chip Area |
|---|---:|---:|
| Exact Multiplier | 295 | 2310.966400 |
| Medium Approximate Multiplier | 211 | 1776.704000 |
| Strong Approximate Multiplier | 149 | 1259.958400 |
| Configurable Multiplier | 636 | 5342.624000 |
| Configurable MAC | 885 | 7213.168000 |

The configurable MAC was synthesized with sequential-cell mapping enabled, so the reported area includes the mapped accumulator flip-flops and associated sequential logic.

---

## 5. Hardware Savings Relative to Exact Multiplier

| Approximation | Cell Reduction | Area Reduction |
|---|---:|---:|
| Medium | 28.475% | 23.118% |
| Strong | 49.492% | 45.479% |

### Medium Approximation

* Cells: 295 → 211
* Cell reduction: **28.475%**
* Area: 2310.966400 → 1776.704000
* Area reduction: **23.118%**

### Strong Approximation

* Cells: 295 → 149
* Cell reduction: **49.492%**
* Area: 2310.966400 → 1259.958400
* Area reduction: **45.479%**

---

## 6. Baseline Output-Truncation Approximations

The project also includes baseline approximate multipliers based on output-bit truncation.

| Design | Approximation | Error Rate | MAE | Maximum Error |
|---|---|---:|---:|---:|
| Exact | No approximation | 0.000000% | 0.000000 | 0 |
| V1 | Product LSB truncated | 25.000000% | 0.250000 | 1 |
| V2 | Two product LSBs truncated | 50.000000% | 1.000000 | 3 |

These baseline designs demonstrate controlled numerical error but limited hardware savings because the full multiplication hardware is still present.

---

## 7. Conclusion

This project demonstrates a configurable approximate computing architecture that can dynamically trade numerical accuracy for hardware cost.

The architectural approximation results show a clear accuracy-versus-hardware trade-off:

* **Medium mode:** lower error with 28.475% cell reduction and 23.118% area reduction.
* **Strong mode:** higher error with 49.492% cell reduction and 45.479% area reduction.

The configurable MAC supports runtime selection between exact and approximate computation while providing signed INT32 accumulation and verified control behavior.

The final design was exhaustively characterized at the multiplier level, verified with a self-checking MAC testbench, and synthesized using the SKY130 HD standard-cell library.
