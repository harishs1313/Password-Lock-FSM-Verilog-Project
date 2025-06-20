
---

```markdown
# 🔐 Password Lock FSM – Verilog Project

A **Verilog-based Finite State Machine (FSM)** that simulates a secure **4-digit digital password lock system**. The system includes features like multiple retry attempts, lockout mode, admin password change, and clear visual status outputs.

---

## 🚀 Features

- ✅ **Correct Password Unlocks**
- ❌ **Wrong Password Retry (3 attempts)**
- 🔒 **Lockout Mode** after 3 incorrect attempts
- 🛠 **Admin Mode** for password change
- ⏳ **Timeout-based lockout exit**
- 🧠 **Readable FSM states**
- 💡 **Output signals:** `unlock`, `locked_out`, `error_led`

---

## 📁 Files Structure

PasswordLockFSM/
│
├── PasswordLockFSM.v         # Main FSM module
├── PasswordLockFSM\_tb.v      # Testbench
├── PasswordLockFSM.vcd       # Generated waveform (from simulation)
├── README.md                 # Project Summary


---

## 🧠 FSM Design

States:
- `IDLE`: Waiting for input
- `VERIFY`: Checking user-entered digits
- `UNLOCKED`: Access granted
- `LOCKED_OUT`: Too many wrong attempts
- `ADMIN_CHANGE`: New password via admin
- `ERROR`: For handling inconsistencies

Transitions are determined by:
- Password match
- Attempt count
- Admin mode
- Emergency reset

---

## 🛠 How It Works

- **Default Password**: `A 5 3 C` (Hex)
- **Input Interface**: `key_in` (4-bit), `key_valid` pulses input
- **Admin Mode**: `admin_mode = 1` before entering new 4-digit password
- **Lockout**: Triggered after 3 wrong attempts, clears automatically after time

---

## 📊 Simulation

Run with tools like **Icarus Verilog** and **GTKWave**:

```bash
iverilog -o PasswordLockFSM_tb PasswordLockFSM.v PasswordLockFSM_tb.v
vvp PasswordLockFSM_tb
gtkwave PasswordLockFSM.vcd
````

---

## 🧪 Sample Testbench Flow

```verilog
send_digit(4'hA);  // Input 1st digit
send_digit(4'h5);  // Input 2nd digit
send_digit(4'h3);  // Input 3rd digit
send_digit(4'hC);  // Input 4th digit
#50;               // Wait and observe output
```

* Automatically shows FSM in action
* Can simulate admin password change
* Handles time-based lockout recovery

---

## 📷 Waveform Snapshot

View `.vcd` in GTKWave to monitor:

* `unlock`, `locked_out`, `state`
* Password attempts and transitions

---

## 👨‍💻 Author

Developed by Harish S
Beginner-friendly FSM Verilog Project
Perfect for ECE/Digital Design portfolios!

---

## 🏁 Getting Started

Install:

* Icarus Verilog (`sudo apt install iverilog`)
* GTKWave (`sudo apt install gtkwave`)

Run:

```bash
iverilog -o sim PasswordLockFSM.v PasswordLockFSM_tb.v
vvp sim
gtkwave PasswordLockFSM.vcd
```

---

## 🧠 Learning Outcome

This project helps you understand:

* FSM design in Verilog
* Modular coding
* Digital logic testing with testbenches
* Simulation waveform analysis

```
