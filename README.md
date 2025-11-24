# sync_serial_multiplier_radix16
This project implements a **synchronous serial multiplier** using the **Radix-16 (shift-and-add)** method in **VHDL**.  
The design includes:
- **Control Unit** (FSM-based)
- **Execution Unit**
- **Top-Level Integration**
- **Simulation testbench**
- **Synthesis results**

## Project Overview
The goal of this project is to implement an efficient serial multiplier that multiplies two binary numbers using radix-16, which processes 4 bits per clock cycle.  
By using this method, the number of cycles required is reduced by x4 compared to a standard serial multiplier. The design makes use of a generic parameter (`DATA_WIDTH`) which allows the multiplier to support different operand sizes without changing the VHDL architecture.

## Project Structure
- Control_Unit.vhd #FSM based control logic
- Exec_Unit.vhd #Radix-16 execution logic
- sync_serial_multiplier.vhd #Top-Level integration
- TB_sync_serial_multiplier.vhd  #Testbench

### Control Unit 
Implements a FSM with four states:
IDLE → LOAD → EXEC → DONE

**Responsibilities:**
- Waits for `start = '1'` signal to begin the operation.
- Asserts `load_clear = '1'` to initialize registers.
- Generates `shift_enable = '1'` to trigger computation.
- Monitors the `finish` signal from the Execution Unit.
- Raises `done = '1'` when the multiplication is completed.
This unit controls the **timing and sequencing** of the entire multiplier.

### Execution Unit
Performs the actual multiplication using the **shift-and-add method** and **Radix-16** approach.

**Operation:**
1. Inputs `A` and `B` are stored inside internal registers.
2. Every clock cycle, **4 bits of `B` are processed** (Radix-16).
3. Four partial products (`pp0`–`pp3`) are generated based on the lowest bits of `B`.
4. A shifted partial product is added into the accumulator (`ACC_reg`).
5. `B_reg` is shifted left by 4 bits, and a digit counter increments.
6. When all bits are processed, `finish = '1'` is asserted.
7. The final result is stored in `p_reg`.

### Top-Level Integration Unit
This module connects:
- The **Control Unit** ↔ The **Execution Unit**
- Control signals: `shift_enable`, `load_clear`, `finish`.
- Main outputs: `p` (result) and `done`.
It does **not** perform additional logic — its purpose is clean integration, making the system modular and easy to scale or upgrade.

### Simulation
A testbench (`TB_sync_serial_multiplier.vhd`) is included.
It tests multiple values of `A` and `B` and verifies:
- Correct output `p`
- Proper FSM behavior
- Timing of `shift_enable`, `load_clear`, `finish`, and `done`


📌 Simulation waveform and synthesis images have been added to the `/simulation_and_synthesis/` folder.

📌 All VHDL source files have been added to the `/codes/` folder.
