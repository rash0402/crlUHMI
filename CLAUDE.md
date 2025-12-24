# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Unified HMI Tracking Platform (UHTP)** - A Human-Machine Interaction research platform for differentiable control experiments. The platform serves as a common validation infrastructure for three research projects: STA (control), IMM (estimation), and HA-VAE (prediction).

**Status**: 🟢 PoC Approved - Ready for implementation

## Key Documents

| Document | Description |
|----------|-------------|
| `doc/AI-DLC_base_UnifiedHMITrackingPlatform.md` | Research design specification (v2.1.0) |
| `doc/UHTP_Implementation_Requirements.md` | Implementation requirements (v1.0.0) |

## Architecture

Two-process hybrid system with loose coupling via UDP:

```
Julia Core (1kHz)              Python Viewer (60Hz)
┌──────────────────┐           ┌──────────────────┐
│ PhysicsEngine    │           │ UDPReceiver      │
│ InputHandler     │──UDP──────│ Visualizer       │
│ TaskEngine       │           │ GUI Controller   │
│ UDPSender        │           │ DataLogger       │
└──────────────────┘           └──────────────────┘
```

### Julia Core Process ("The Brain") - 1kHz Real-time
- Physics simulation with `DifferentialEquations.jl`
- Automatic differentiation with `Enzyme.jl` (zero-allocation gradients) - *PoC後に実装*
- Bayesian inference with `RxInfer.jl` - *PoC後に実装*
- Stack allocation with `StaticArrays.jl` to avoid GC

### Python Viewer Process ("The Face") - 60Hz Soft Real-time
- Visualization with VisPy (OpenGL) or PyGame
- Data logging with h5py (HDF5) and CSV
- GUI controls with PyQt6

## Input Devices (GUI Selectable)

| Device | Input Type | Priority |
|--------|-----------|----------|
| Trackpad (MacBook M2) | 2D position → force | High |
| Keyboard (Arrow keys) | Discrete force | High |
| Mouse (USB/Bluetooth) | Relative/absolute | High |
| Auto-PD | PD control + noise | High |
| UDP Haptic | External force | Future |

## Experiment Tasks

- **Sum-of-Sines (SoS)**: Frequency response analysis using prime-multiple frequencies
- **Critical Instability Task (CIT)**: Control limit measurement with unstable 1st-order dynamics (λ parameter)
- **Fitts' Law Task (ISO 9241-9)**: Ballistic prediction measurement with circular target arrangement

## Core Dynamics (2D)

XY-independent second-order dynamics on 2D plane:
```
Mx*c̈x + Bx*ċx + Kx*cx = uhx + usysx + wx  (X-axis)
My*c̈y + By*ċy + Ky*cy = uhy + usysy + wy  (Y-axis)
```
- State vector: [cx, cy, vx, vy]ᵀ ∈ ℝ⁴
- Parameters (Mx, Bx, Kx, My, By, Ky) configurable per axis in YAML
- Input sampling: Zero-order hold (OS events ~60-120Hz → 1kHz control)

## Performance Requirements

| Metric | Target | Tolerance |
|--------|--------|-----------|
| Control loop | 1ms (1kHz) | ≤1.5ms |
| WCET | 165μs | <600μs |
| GC allocation | 0 bytes | 0 bytes |
| UDP jitter | <0.5ms | <2ms |
| Display FPS | 60Hz | ≥30Hz |

## Project Structure (Target)

```
crlUHMI/
├── julia/                # Julia Core
│   ├── src/
│   │   ├── UHTP.jl       # Main module
│   │   ├── physics/      # Dynamics, integrator
│   │   ├── input/        # Device handlers
│   │   ├── tasks/        # SoS, CIT, Fitts
│   │   └── network/      # UDP sender
│   └── test/
├── python/               # Python Viewer
│   ├── src/
│   │   ├── main.py
│   │   ├── network/      # UDP receiver
│   │   ├── visualization/
│   │   ├── gui/
│   │   └── data/         # HDF5/CSV writers
│   └── tests/
├── config/               # YAML configurations
├── doc/                  # Specifications
└── data/                 # Experiment data (gitignore)
```

## Development Phases

1. **Phase 1 (MVP)**: UDP communication + mouse input + basic 2D visualization
2. **Phase 2**: All 3 tasks (SoS, CIT, Fitts) + all input devices + device selection GUI
3. **Phase 3**: HDF5 logging + real-time plot + results summary screen + tests

**PoC Completion Criteria**: All 3 tasks × All 5 devices working

## Language

Project documentation is in Japanese. Code comments may use Japanese or English.
