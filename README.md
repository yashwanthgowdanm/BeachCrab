# BeachCrab — Autonomous Beach Cleaning Robot (MATLAB Simulation)

A tiny MATLAB project that simulates a beach-cleaning “crab” robot that roams a grid world, avoids obstacles, and collects **metallic** and **non‑metallic** waste while live‑plotting its state.

## Features
- Grid‑based world with randomly spawned obstacles and two waste types
- Simple reactive navigation + heading control, with a temporary **leap** speed for escapes
- Pickup logic that increments **metallic** and **non‑metallic** counters
- Live visualization (`plotSimulation.m`) and an end‑of‑run summary

## Files
- `CrabRobot.m` — robot class: state (x, y, heading), kinematics, sensing, waste pickup
- `main_simulation.m` — entry script: builds the world, runs the loop, tracking stats
- `plotSimulation.m` — lightweight plotting of the robot and counters

## Quickstart
1. Open MATLAB (R2020a+ recommended).
2. Add the folder to the path: `addpath(genpath('BeachCrabApp'))`
3. Run: `main_simulation`

## Configuration
Key knobs in `main_simulation.m` (adjust to taste):
- `gridSize` — world size (e.g., 200)
- spawn counts for obstacles / metallic / non‑metallic waste
- robot parameters in `CrabRobot`: `normalSpeed`, `leapSpeed`, `turnRate`, `sensorRange`

© 2025 • BeachCrab — MATLAB mini‑sim
