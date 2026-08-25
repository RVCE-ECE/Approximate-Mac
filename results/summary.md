# Approximate MAC Project Results Summary

## 1. Project Overview

This project implements a configurable signed INT8 Multiply-Accumulate (MAC) architecture with exact and approximate multiplication modes.

The objective is to explore the trade-off between **numerical accuracy and hardware cost**. The project includes exhaustive functional verification and SKY130 standard-cell synthesis.

---

## 2. Exact Multiplier Verification

The signed 8-bit × 8-bit exact multiplier was exhaustively tested.

* Total input combinations: 65,536
* Errors found: 0
* Result: **PASS**

---

## 3. Baseline Approximation Results

| Design | Approximation              | Error Rate |      MAE |      MSE | Maximum Error |
| ------ | -------------------------- | ---------: | -------: | -------: | ------------: |
| Exact  | No approximation           |  0.000000% | 0.000000 | 0.000000 |             0 |
| V1     | Product LSB truncated      | 25.000000% | 0.250000 | 0.250000 |             1 |
| V2     | Two product LSBs truncated | 50.000000% | 1.000000 | 2.250000 |             3 |

These designs provide controlled error but limited hardware savings because the full multiplication is still performed internally.

---

## 4. Architectural Approximate Multiplier

A more advanced approximation was implemented by reducing operand precision before multiplication, thereby reducing the complexity of the multiplication hardware.

### Medium Approximation Results

* Total tests: 65,536
* Error count: 48,896
* Error rate: 74.609375%
* MAE: 53.333984
* MSE: 5,461.750000
* Maximum error: 255

---

## 5. SKY130 Synthesis Results

Technology mapping was performed using Yosys, ABC, and the SKY130 HD standard-cell library.

| Design                                      | Cells |   Chip Area |
| ------------------------------------------- | ----: | ----------: |
| Exact Multiplier                            |   295 | 2310.966400 |
| Medium Architectural Approximate Multiplier |   211 | 1776.704000 |

### Hardware Savings

* Cell reduction: **84 cells**
* Cell reduction: **28.475%**
* Area reduction: **23.118%**

This demonstrates that architectural approximation provides measurable hardware savings compared with exact multiplication.

---

## 6. Configurable Multiplier Results

| Mode | Operation            | Error Rate |        MAE | Maximum Error |
| ---- | -------------------- | ---------: | ---------: | ------------: |
| 00   | Exact                |  0.000000% |   0.000000 |             0 |
| 01   | Medium Approximation | 74.609375% |  53.333984 |           255 |
| 10   | Strong Approximation | 93.164062% | 149.784302 |           759 |
| 11   | Exact Default        |  0.000000% |   0.000000 |             0 |

The design allows runtime selection between higher accuracy and stronger approximation.

---

## 7. Configurable MAC

The configurable MAC integrates:

* Signed INT8 inputs
* Configurable multiplier
* Signed INT16 product
* Signed INT32 accumulator
* Clocked accumulation
* Reset, clear, and enable controls

The self-checking testbench verified reset, exact operation, approximate modes, accumulation, clear, and hold behavior.

**Result: PASS — CONFIGURABLE MAC SELF-CHECK PASSED**

---

## 8. Configurable Design Synthesis

| Design                  | Cells |   Chip Area |
| ----------------------- | ----: | ----------: |
| Configurable Multiplier |   647 | 5428.956800 |
| Configurable MAC        |   808 | 6264.758400 |

The configurable designs require additional hardware because they support multiple operating modes and selection logic.

---

## 9. Conclusion

The project shows that simple output truncation introduces approximation with limited hardware savings, while architectural approximation can significantly reduce implementation cost.

The medium architectural approximate multiplier achieved:

* **28.475% reduction in cell count**
* **23.118% reduction in SKY130 mapped area**

The configurable MAC further allows the system to dynamically select between exact and approximate computation depending on application requirements.
