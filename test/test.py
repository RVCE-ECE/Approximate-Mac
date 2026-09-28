# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, RisingEdge, ReadOnly, Timer

def signed8_to_u8(value):
    """Encode a signed integer into the 8-bit input representation."""
    return value & 0xFF


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start TinyTapeout wrapper test")

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Reset the MAC.
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)
    await Timer(2, unit="ns")
    await ReadOnly()

    assert dut.uo_out.value.to_unsigned() == 0

    # Deassert reset away from the active clock edge.
    await FallingEdge(dut.clk)
    dut.rst_n.value = 1

    # The wrapper uses exact multiplication and continuously accumulates.
    expected_acc = 0

    test_vectors = [
        (5, 3),
        (-5, 3),
        (7, 5),
        (-8, 4),
        (10, -2),
    ]

    for a, b in test_vectors:
        # Drive inputs before the active rising edge.
        await FallingEdge(dut.clk)
        dut.ui_in.value = signed8_to_u8(a)
        dut.uio_in.value = signed8_to_u8(b)

        # MAC updates on the rising edge.
        await RisingEdge(dut.clk)
        await Timer(2, unit="ns")
        await ReadOnly()

        expected_acc += a * b
        expected_out = expected_acc & 0xFF

        actual_out = dut.uo_out.value.to_unsigned()

        assert actual_out == expected_out, (
            f"A={a}, B={b}, expected accumulator={expected_acc}, "
            f"expected uo_out=0x{expected_out:02X}, "
            f"got=0x{actual_out:02X}"
        )

    # The wrapper does not drive the bidirectional pins.
    assert dut.uio_oe.value.to_unsigned() == 0
    assert dut.uio_out.value.to_unsigned() == 0

    dut._log.info("PASS: TinyTapeout wrapper test completed")
