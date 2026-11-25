# GNSS AFE (GF180MCU) Review, Improvement Plan, and Work Log

Japanese version: [README_gemini.md](README_gemini.md)

This document records the design review, improvement proposals, pre-tapeout action plan, and work log requested in [prompt_gemini.md](prompt_gemini.md) for the GF180MCU (`gf180mcuD`, Wafer.Space slot `0p5x0p5`) GNSS Analog Front-End chip originally designed with Claude Code.

- Reviewed baseline:
  - Final GDS: `chip/final/gds/chip_top.gds` (SHA-256: `5dc43f34bc8e9d5964c2a791bb2c6bd7913a1ccf1866c3bbc3ef57630751c1c1`, 86,597,382 bytes)
  - Reference documentation: [README_EN.md](README_EN.md), [doc/report_EN.md](doc/report_EN.md), [RESUME_EN.md](RESUME_EN.md), [prompt.md](prompt.md)
  - Reference sources: `scripts/gen_cells.py`, `chip/src/chip_core.sv`, `chip/src/chip_top.sv`, `chip/librelane/config.yaml`, `chip/librelane/slots/slot_0p5x0p5.yaml`, `chip/librelane/chip_top.sdc`, `scripts/make_iocells.py`, `scripts/layout/*.py`, `layout/review/final/*.log`, `layout/review/r4_chip_spice_noise.log`

---

## 1. Executive Summary

Overall, this is a very thorough, tapeout-grade inductorless GPS L1 C/A + Galileo E1 analog front-end fitting inside the Wafer.Space quarter slot (`0p5x0p5`).

Key strengths:
- **Sub-harmonic 8-phase mixer + 785.664 MHz 4-stage ring VCO**: Avoids 1.57 GHz LO routing/divider/pulling bottlenecks and eliminates vibration-sensitive off-chip LC inductors for launch-vehicle environments.
- **Inductorless noise-cancelling LNA (`lna_nc`)**: Single-ended 50 Ω input (no external balun needed) achieving ~1.65–1.72 dB system NF with PEX.
- **Rigorous PEX, corner, and full-chip verification**: Current-steering charge pump achieving −43.8 to −48.0 dBc reference spurs, ratiometric IF bias (`bias_if`) resolving the SS 85 °C −35 dB gain collapse, buffered VCTRL monitor (`vmon_buf`), IF bandwidth trim (`BWW`/`BWN`), EM fixes, fixed 56-pad COB alignment, and clean LVS / magic DRC / KLayout DRC / Antenna / `gf180mcu-precheck` sign-off (0 errors).

---

## 2. Design Review Findings & Risks

### 2.1 High Severity (Direct Silicon / Reliability Impact)

1. **On-chip `DVSS`/`VSS` short and 24 mA output pads causing IF self-interference**
   - `chip/src/chip_top.sv` shorts `VSS = DVSS`, and `fill10_noVDD` in `scripts/make_iocells.py` only breaks the `DVDD`/`VDD` padring bands while leaving `DVSS`/`VSS` continuous around the entire die.
   - Because 24 mA output pads (`gf180mcu_fd_io__bi_24t`) are used, full-chip SPICE (`doc/report_EN.md` §3.15 (13)) showed 170–385 mV rms of switching coupling into the IF chain without external 330 Ω series resistors. Even with 330 Ω (estimated C/N0 loss ≤ 0.47 dB), p-substrate coupling and long COB return paths remain unmodeled.
   - Inspection of `gf180mcu_fd_io` confirmed that **`gf180mcu_fd_io__bi_t`** (identical `75 × 350 µm` footprint, selectable 4 / 8 / 12 / 16 mA drive via `PDRV0`/`PDRV1`) is available in the PDK.
2. **Electromigration (EM) junction-temperature margin vs. 85 °C ambient spec**
   - Power mesh (VSS M4 max 1.77 mA/µm) and several block nets (LNA RFIN M3 1.87 mA/µm, VCO VR M3 1.94 mA/µm, etc.) pass the 85 °C limit (2.09 mA/µm) but exceed the 110 °C limit (1.0 mA/µm), giving a max allowable junction temperature $T_j \approx 90\text{ °C}$.
   - With ~180–200 mW chip dissipation (~10–16 °C self-heating on COB), operating at 85 °C ambient puts $T_j \approx 95\text{–}101\text{ °C}$, leaving no EM margin for prolonged high-temperature testing or burn-in.
3. **Gate-oxide overvoltage stress in dynamic nodes**
   - Per `layout/review/final/stress.log`, capacitive kick on floating dynamic nodes in the TSPC divider (`tspc_dff`) and StrongARM comparator (`sa_comp`) reaches 3.68 V even at nominal 3.3 V (above the 3.63 V rating) and 4.02 V at +10 % supply. Strict `VDD / VDDV ≤ 3.3 V` operation is required on silicon.

### 2.2 Medium Severity (Digital Integration, Power Domains, Analog Operating Points)

4. **Digital input pad selection & STA constraint gaps**
   - `RST_N` and `CS_N` use standard CMOS input pads (`gf180mcu_fd_io__in_c`) rather than Schmitt-trigger pads (`gf180mcu_fd_io__in_s`, currently used only on `SCLK`). Because `RST_N` may be driven by an external RC circuit and `CS_N` acts as both an edge clock (`always_ff @(posedge cs_n)`) and async reset (`cnt_rst_n = rst_n & ~cs_n`), `in_s` is strongly recommended for both.
   - `chip/librelane/chip_top.sdc` does not define a clock for `cs_n`, leaving `sr -> ctl` setup/hold unchecked by STA.
5. **Analog pad ESD rail assignment and cross-domain protection**
   - `REFIN` (`analog[0]`), `AFCOUT` (`analog[1]`), and `VCTRL` (`analog[2]`) are `asig_5p0` cells located in the noisy digital `DVDD`/`VDD` padring section. The `REFIN` ESD diode capacitance couples `DVDD` noise onto `REFIN`, where it is multiplied by N = 96 (+39.6 dB) in the PLL if the TCXO output impedance is non-negligible.
   - While `REFCK` (`VDDV` → `VDD`) has a 1 kΩ series resistor + diode clamps, `B0`/`B1` (`VDD` → `VDDV`) cross the domain boundary directly into `XB0`/`XB1` gates without CDM protection.
   - There is no dedicated on-chip `VDDV`–`VSS` decoupling capacitor (`XDEC` 125 pF is on `VDDA` only; `CVR` 1.8 pF is on internal `VR` only).
6. **Sub-harmonic mixer headroom & operating margins**
   - Stacking 4 NMOS levels (tail + Gm + lower switch + upper switch) under 3.3 V pushes the tail current sources `MTI`/`MTQ` to the edge of triode in SS (`layout/review/final/op.log`), and LO switch gate peaks reach 3.61 V (just below 3.63 V rating).
   - `bias_if` error-amp output `XMI2` is also at the edge of saturation in SS (`Vds - Vdsat = -0.02 V`).
7. **Real Sallen-Key LPF image-band pass-through & 1-square resistors**
   - Real LPFs in a Low-IF (+4.092 MHz) architecture pass the image band (1567.236 MHz) directly into the nonlinear 2-bit ADC, increasing sensitivity to image-band blockers and relying heavily on external SAW roll-off.
   - `R1` in `sk_lpf1`/`sk_lpf2` is `W=1u, L=1u` (1 square), where end resistance accounts for ~20 % of the total resistance.

### 2.3 Low Severity (Maintenance Consistency)
- `PDN_OBSTRUCTIONS` in `chip/librelane/config.yaml` (`[442, 512.2, 1486.1, 2067.4]`) still reflects the previous macro size (`1024.1 × 1535.2 µm`), reducing the halo to 4.3–5.8 µm around the final `1029.8 × 1539.4 µm` macro (clean in current DRC/LVS, but fragile for rebuilds).
- `doc/report.md` §5 still contains an outdated sentence noting sealring-only KLayout DRC errors (final GDS has 0 KLayout DRC errors).

---

## 3. Schematic Architecture Improvement Proposals

| Block | Current Approach | Proposed Better Approach | Expected Benefits |
|---|---|---|---|
| **Mixer** | 4-stack active sub-harmonic Gilbert | Passive current-driven mixer (25 % duty LO or passive sub-harmonic) + TIA | Eliminates 4-stack headroom pinch, 3.61 V LO gate stress, 1/f noise, and SS gain drop; improves IIP3/P1dB. |
| **IF Filter / VGA** | Real Sallen-Key LPF × 2 + 5 AC-coupled VGAs | Complex polyphase BPF (centered at 4.092 MHz) + DC-coupled VGA with DCOC servo loop | 25–35 dB image rejection (1567.2 MHz), better blocker immunity & 2-bit quantization efficiency, much smaller MIM area & lower power. |
| **VCO** | 4-stage pseudo-differential inverter ring + start-up kick | Symmetric-load (Maneatis) differential ring VCO | Inherently low supply pushing (relaxes external LDO spec) and avoids common-mode latch states. |
| **Divider (`div48`)** | All-TSPC dynamic DFFs | CML (or ratioed static) for first ÷2 stage, fully static CMOS DFFs below 393 MHz | Completely eliminates 3.68–4.02 V capacitive kick stress on gate oxides. |
| **Ref Buffer (`refbuf`)** | Single-ended self-biased inverter | Differential limiting amplifier / comparator with supply-independent bias | Structurally suppresses supply-ripple-to-edge-jitter conversion. |
| **Bias (`bias_gen`)** | Constant-$g_m$ beta-multiplier (~2× current over temp) | Simple parasitic-PNP BGR (PTAT + CTAT zero-TC current reference) | Tightens PVT spread across all blocks and improves SS yield. |
| **Digital / Pads** | Manual SPI AGC, `in_c` inputs, 24 mA `bi_24t` outputs | `in_s` on `RST_N`/`CS_N`, 4 mA `bi_t` outputs, optional on-chip auto-AGC (MAG counter) | Glitch immunity, much lower SSN, faster autonomous tracking during rocket flight dynamics. |

---

## 4. Layout Improvement Proposals

1. **Separate analog `VSSA` and digital `DVSS` on-chip**: Break `DVSS`/`VSS` padring bands (with anti-parallel ESD clamp diodes between ground domains) so the analog macro connects only to the north analog VSS pads.
2. **Use GF180MCU Deep N-Well (`DNWELL`) substrate isolation**: Place NMOS devices in `lna_nc`, `mixer_iq`, `vco_core`, and the first IF stage inside isolated P-wells in `DNWELL`, plus a continuous guard band between the analog macro south edge and the digital core.
3. **Add dummy resistor segments to `res_array`**: Unlike `mos_rows` (which adds end dummy poly), `scripts/layout/devices.py` `res_array` lacks end dummy segments. Adding them improves matching on `afc_dac`, `adc2b`, differential loads, and SK filter resistors.
4. **Flip AC-coupling MIM capacitor plate orientation**: In `lna_nc` (`CC2`/`COP`/`CON`), `mixer_iq` (`CAC*`), `vga`/`vga_fix` (`CC1`/`CC2`), and `refbuf`/`divbuf` (`CIN`), the M4 bottom plate (`bot`) is currently tied to the high-impedance gate node. Orienting M4 toward the low-impedance driving side reduces parasitic loading and substrate coupling.
5. **Strengthen power mesh, 110 °C EM margin, and `VDDV` decoupling**: Widen top-level horizontal M4 rails (`RAIL_H` 3 → 5–6 µm), meet 110 °C EM limits on LNA/VCO high-current nets, distribute `decap` across IF/PLL/LNA, and add 20–50 pF dedicated `VDDV`–`VSS` on-chip decap.
6. **Structurally matched LO bus, `REFIN` placement, and M5-priority `RFIN`**: Match VCO-to-mixer pitch with equal-length shielded 8-phase routing to eliminate manual `LO_TRIM` retuning; place `REFIN` near the `VDDV` domain if possible; route `RFIN` on thick M5 with lower-layer keepout as a GSG coplanar line.

---

## 5. Pre-Tapeout Roadmap (1 Month Remaining)

Freeze the current passing GDS (`5dc43f34...`) as a safe fallback baseline, then execute changes in risk-ordered tiers:

### Tier 1 (Highest Priority, Low Risk, Week 1) — No Analog Macro Changes
- [x] **T1-1**: Replace `gf180mcu_fd_io__bi_24t` (24 mA) with `gf180mcu_fd_io__bi_t` (`PDRV0=0, PDRV1=0` = 4 mA, `SL=1`) + re-verify 3.3 V SDO delay (Done, Phase A).
- [x] **T1-2**: Switch `RST_N`, `CS_N`, and `SDI` to Schmitt-trigger `gf180mcu_fd_io__in_s`, and update macro halo / `PDN_OBSTRUCTIONS` in `config.yaml` (Done, Phase A/D).
- [x] **T1-3**: Separate analog `VSSA` and digital `DVSS` in the padring (`fill10_noPWR` + `ISOSUB (23/5)`, verified by LVS / precheck — Done, Phase A/D).

### Tier 2 (Medium Priority, Moderate Risk, Weeks 2–3) — Analog Macro Rebuild (Selective)
- [x] **T2-1**: Power-mesh EM improvement (widened top M4 rail `RAIL_H` 3→4 µm; `VSSA` M4 EM cut from 1.770 → 1.241 mA/µm (−30%), worst-case EM across all nets 1.770 → 1.542 mA/µm, analog current 38.6 → 37.2 mA — Done, Phase C).
- [x] **T2-2**: Analog polish package (`res_array` poly-only end dummies, flipped AC-coupling MIM orientation, ~29 pF dedicated `decap_vco`, 1 kΩ `B0`/`B1` CDM series resistors, AC-coupled `adc2b` input — Done, Phase B/C).
- [x] **T2-3**: Replace TSPC `div48` stages with static TG DFFs (`dff_st`), eliminating **7 → 0** divider overvoltage nodes and cutting chip-wide `VDD+0.3V` FET pairs from 16 → 6 (Done, Phase B/C).
- [x] **Added (Temperature / $g_m$ Auto-Tuning Overhaul)**: All-MOS resistor-free VGA (`vga`/`vga_fix`/`bias_if`) + 16.368 MHz crystal-locked SC auto-tuned 4th-order Butterworth $G_m$-C LPF (`gm_master`/`gmc_lpf1`/`gmc_lpf2`), tightening post-layout PEX PVT cutoff spread from **±28% → ±4.7%** (6.0× tighter — Done, Phase B/C).
- [ ] **T2-4**: Add `DNWELL` substrate isolation for LNA / mixer / VCO (mitigated via full `VSSA` + `ISOSUB` separation and 7.2× lower SSN from 4 mA `bi_t`; DNWELL deferred to next shuttle).

### Tier 3 (Defer to Next Shuttle)
- Passive mixer + TIA, complex polyphase BPF, Maneatis VCO, BGR bias overhaul.

### Suggested 4-Week Schedule
- **Week 1**: Freeze baseline → Implement Tier 1 → LibreLane + full-chip SPICE + SDO delay check.
- **Week 2**: Implement selected Tier 2 items → Block PEX / PLL spur / EM re-verification.
- **Week 3**: Final chip integration (LibreLane), corner regression, full-chip SPICE, cocotb RTL/GL, schematic/bonding diagram updates.
- **Week 4**: Final `gf180mcu-precheck` sign-off, contingency buffer, submission.

---

## 6. Work Log

### 2026-11-20
- Completed full review of `prompt_gemini.md`, `README.md`, `prompt.md`, `doc/report.md`, `RESUME.md`, schematic/RTL/layout generator scripts, and final verification logs.
- Verified available PDK I/O cells in `gf180mcu_fd_io` (`bi_t`, `in_s`, `brk2`, `brk5`, etc.).
- Created initial Japanese ([README_gemini.md](README_gemini.md)) and English ([README_gemini_EN.md](README_gemini_EN.md)) review reports, improvement proposals, and 4-week pre-tapeout roadmap.


---

## 7. Implementation & Verification Log (Autonomous Execution Phase)

### 2026-11-20 — Phase A: Baseline Freeze & Tier 1 Full-Chip Signoff Complete

1. **Baseline Archive Frozen**:
   - Archived the verified 2026-11-15 GDS (`chip/final/gds/chip_top.gds`, SHA-256 `5dc43f34bc8e9d5964c2a791bb2c6bd7913a1ccf1866c3bbc3ef57630751c1c1`) and all scripts/configs to `archive/baseline_20261115/baseline_20261115.tar.gz`.
2. **Tier 1 Padring / IO / Substrate Isolation Upgrades**:
   - **Lower-Drive Digital Outputs**: Replaced all 6 digital output pads (`I_SIGN`, `I_MAG`, `Q_SIGN`, `Q_MAG`, `CLKOUT`, `SDO`) from `gf180mcu_fd_io__bi_24t` (24 mA) to **`gf180mcu_fd_io__bi_t`** (`PDRV0=0, PDRV1=0, SL=1` = 4 mA lowest drive, slow slew) ([chip_top.sv](chip/src/chip_top.sv), [chip_core.sv](chip/src/chip_core.sv)).
     - **SPICE Benchmark** (TT 27°C 3.3V, 5 pF load, 0.5 nH DVDD/DVSS wires):
       | Metric | Old `bi_24t` (24 mA) | New `bi_t` (4 mA, `SL=1`) | Improvement |
       | :--- | :---: | :---: | :---: |
       | `DVSS` ground bounce (`Rser=0 Ω`) | 77.4 mVpp | **10.8 mVpp** | **7.2× lower (−17.1 dB)** |
       | `DVDD` supply bounce (`Rser=0 Ω`) | 64.1 mVpp | **8.3 mVpp** | **7.7× lower (−17.8 dB)** |
       | Peak bond-wire current (`Rser=0 Ω`) | 21.61 mA | **5.39 mA** | **4.0× lower (−12.1 dB)** |
       | `DVSS` bounce (`Rser=330 Ω`) | 52.4 mVpp | **6.9 mVpp** | **7.6× lower** |
       | SDO pad delay (30 pF, SS 125°C 3.0 V) | 8.8 ns | 21.6 ns | Total ~37 ns (**63 ns margin** vs 100 ns half-period at 5 MHz SCLK) |
   - **Schmitt-Trigger Digital Inputs**: Upgraded `RST_N`, `SDI`, `CS_N` from `gf180mcu_fd_io__in_c` to **`gf180mcu_fd_io__in_s`** (matching `SCLK`).
   - **Full Analog/Digital Power & Substrate Isolation (`VSSA` + `ISOSUB`)**:
     - Created `fill10_noPWR` (10×350 µm empty breaker cutting `DVDD`/`VDD`/`DVSS`/`VSS`) and replaced `brk_w`/`brk_e` ([make_iocells.py](scripts/make_iocells.py)).
     - Separated analog ground port (`VSS` → **`VSSA`**) on `afe_rf_pad` and `gnss_afe_analog`, adding the official GF180MCU LVS substrate-cut layer **`ISOSUB` (GDS 23/5)** over both ([export_macro.py](scripts/layout/export_macro.py), [analog_straps.py](chip/librelane/plugins/librelane_plugin_gnss/analog_straps.py)).
3. **Tier 1 Full-Chip LibreLane Signoff** (`RUN_2026-11-20_01-48-03`, **clean exit code 0**):
   - **Magic DRC**: **0** | **KLayout DRC**: **0** | **KLayout Antenna**: **0** | **KLayout Density**: **0** | **XOR**: **0**
   - **Netgen LVS**: **0 errors** (exact match including separated `VSSA` vs `VSS`)
   - **OpenROAD STA**: **0 setup / 0 hold violations** across all 9 corners
   - **OpenROAD IRDropReport**: `PSM` warnings resolved (worst drop `23 µV`)
   - **cocotb RTL & Gate-Level (`GL=1`)**: **PASS**

### 2026-11-20 — Phase B: Analog Macro rev.4 (Self-Adjusting & Resistor-Free Circuits) SPICE Verified

To address temperature and $g_m$ PVT variations by replacing resistor-dependent stages with transistor-based / self-adjusting circuits ([gen_cells.py](scripts/gen_cells.py), [gen_tb.py](scripts/gen_tb.py)):

1. **All-MOS Resistor-Free Gain-Switched VGA (`vga`, `vga_fix`, `bias_if`)**:
   - Eliminated all load and degeneration poly resistors; switched 16 parallel PMOS load units (`4+4+8` of `6u/0.56u`) between diode-connected and 1:8 replica current source (`PBV`).
   - Gain is defined purely by MOS $g_{m,n}/g_{m,p}$ ratio; DC common-mode (`2.16 V`) and bias current stay constant across all 4 gain codes (eliminating AGC DC jumps).
   - Tail current halved from 2 mA → **0.8 mA/stage**, cutting total IF current from **13.5 mA → 4.93 mA per channel** (**−17.1 mA total I+Q savings**).
2. **Crystal-Locked Switched-Capacitor Auto-Tuned 4th-Order Butterworth $G_m$-C LPF (`gm_unit`, `gmc_lpf1`, `gmc_lpf2`, `gm_master`)**:
   - Replaced the resistor Sallen-Key LPF (PVT bandwidth 5.01–8.91 MHz / **±28%**, 4 mA/ch) with a **100% resistor-free SC master auto-tuning loop (`gm_master`)** locked to the 16.368 MHz crystal clock (`REFCK_O` from `pll_core`) driving two symmetric anti-parallel-MIM $G_m$-C biquads.
   - Retained full SPI compatibility on `BWK`/`BWN` as ±18% $C_{ref}$ trim switches.
   - **5-Corner PVT + Cold Startup (`VTN=0V`, `uic`) Verification** (`code 10`, [test_rev4_if_pvt.py](scripts/review/test_rev4_if_pvt.py)):
     | Corner / Mode | `VTN` (ripple) | `I_gm` | `I_if` (1ch) | Gain `G4` | Cutoff `fh` | 16.368 MHz Rej. | Input Noise |
     | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
     | **TT 27°C 3.3V** (`uic` cold start) | 0.833 V (0.49 mV) | 0.58 mA | **4.93 mA** | 53.69 dB | **7.70 MHz** | 25.3 dB | 14.6 nV/√Hz |
     | **SS 85°C 3.135V** | 0.985 V (0.41 mV) | 0.64 mA | 5.69 mA | 52.98 dB | **7.28 MHz** | 27.2 dB | 17.2 nV/√Hz |
     | **SS −20°C 3.135V** | 0.971 V (0.14 mV) | 0.42 mA | 2.71 mA | 54.01 dB | **7.46 MHz** | 26.6 dB | 13.9 nV/√Hz |
     | **FF −20°C 3.465V** | 0.704 V (0.61 mV) | 0.59 mA | 4.66 mA | 53.81 dB | **7.77 MHz** | 24.9 dB | 13.0 nV/√Hz |
     | **FF 85°C 3.465V** | 0.680 V (1.74 mV) | 0.93 mA | 10.66 mA | 50.66 dB | **7.63 MHz** | 25.4 dB | 16.7 nV/√Hz |
     | **TT Wider (`BWK=0`) / Narrow (`BWN=1`)** | 0.869 / 0.795 V | 0.64 / 0.53 mA | 5.16 / 4.74 mA | 53.75 / 53.45 dB | **8.94 / 6.36 MHz** | 20.3 / **31.7 dB** | 13.7 / 16.2 nV/√Hz |
   - **Auto-Tuning Impact**: Cutoff PVT spread reduced to **±3.2%** (**8.7× tighter** than old ±28%, targeting ~6.8–7.2 MHz post-PEX), 5-stage gain spread **±1.68 dB (±0.34 dB/stage)**, `fh` shift across 4 gain codes **0.08%**, MIM area **~6× smaller**.
3. **Static TG DFF `/48` Divider (`dff_st`)**: Eliminated TSPC floating-node overvoltage boost while verified up to 850 MHz at SS 85°C 3.135V (`tb_div`: 785.664 MHz → `16.368 MHz`, `0.73 mA`).
4. **Additional rev.4 Improvements**:
   - `vco_ring4`: Added 1 kΩ CDM series resistors (`RB0`/`RB1`) on `VDD→VDDV` band-select crossings and dedicated `decap_vco` (~29 pF) on `VDDV`.
   - `adc2b`: Added input AC coupling (`CC1`/`CC2` + `RB1`/`RB2` to `thm = 1.20 V`), eliminating final-stage VGA5 DC offset.
   - Flipped all AC-coupling MIM capacitors (`lna_nc`, `mixer_iq`, `selfbias_buf`, `vga`, `vga_fix`, `adc2b`) so M4 bottom plates face the low-Z driving side.
   - `final_op.py` (TT/SS/FF) confirmed **0 saturation-margin violations and 0 overvoltage violations** across all transistors in the new IF chain ([op_rev4.log](layout/review/final/op_rev4.log)).

### 2026-11-20 — Phase C: Analog Macro rev.4 Layout, PEX, EM/IR Drop & Stress Verification Complete

1. **Analog Macro rev.4 Layout Generation** ([devices.py](scripts/layout/devices.py), [module.py](scripts/layout/module.py), [lib.py](scripts/layout/lib.py), [top.py](scripts/layout/top.py), [export_macro.py](scripts/layout/export_macro.py)):
   - Built layouts for all new/updated blocks: `gm_master`, `if_chain` (`vga` / `vga_fix` / `gmc_lpf1` / `gmc_lpf2` / `bias_if`), `pll_core` (static TG DFF `dff_st` + `REFCK_O` buffer), `vco_ring4` (`RB0`/`RB1` CDM resistors), `decap_vco` (~29 pF on `VDDV`), `adc2b` (AC-coupled input), and `lna_nc` / `mixer_iq` (flipped AC-coupling MIM plates).
   - **Poly-Only End Dummies on `res_array`** (`devices.py`, `nslot >= 2` and `W <= 4000`): Clean Magic/KLayout DRC=0 and Netgen LVS while improving `afc_dac` PEX linearity (`INL -0.13/+0.20 LSB, DNL -0.01/+0.33 LSB, monotonic True`, [pex_adcdac_rev4.log](layout/review/pex_adcdac_rev4.log)).
   - **Widened Top-Level Power Rails** (`module.py` `RAIL_H`: `3000 → 4000 nm`) and **`VSSA` + `ISOSUB (23/5)` substrate-cut export**.
   - **Antenna Cleanliness**: Added tie-low NMOS antenna diodes (`MATX`/`MATHI`/`MATLO`/`MABWK`/`MABWN`) in `gm_master` and sized static DC gain inverters (`MGAN`/`MGAP`/`MGBN`/`MGBP`) in `vga` to `W=4u, L=1u` (14.3× larger gate area), achieving **0 KLayout Antenna violations** chip-wide.
   - **Final Macro Dimensions**: `gnss_afe_analog` = **`1020.9 × 1571.0 µm`** (`route=True`, Magic DRC = **0**, Netgen LVS = **OK**, [gnss_afe_analog.gds](layout/gds/gnss_afe_analog.gds)).
2. **Final Post-Layout PEX Results**:
   - **Full PEX Auto-Tuned IF Chain (`gm_master.pex + if_chain.pex`)** (re-extracted after antenna fixes, [test_rev4_if_pex.py](scripts/review/test_rev4_if_pex.py), [pex_if_autotune_rev4.log](layout/review/pex_if_autotune_rev4.log)):
     | Corner / Mode | PEX `VTN` (ripple) | `I_if` (1ch) | Gain `G4` | Passband `fl–fh` | 16.368 MHz Rej. |
     | :--- | :---: | :---: | :---: | :---: | :---: |
     | **TT 27°C 3.3V** (`nom`) | 0.8213 V (0.72 mV) | **4.87 mA** | 54.78 dB | 711 kHz – **7.08 MHz** | **28.1 dB** |
     | **SS 85°C 3.135V** (`nom`) | 0.9575 V (0.61 mV) | 5.52 mA | 53.88 dB | 568 kHz – **6.54 MHz** | **30.7 dB** |
     | **FF −20°C 3.465V** (`nom`) | 0.6980 V (0.96 mV) | 4.72 mA | 55.05 dB | 917 kHz – **7.18 MHz** | **27.4 dB** |
     | **TT Wider (`BWK=0`)** | 0.8459 V (0.73 mV) | 5.09 mA | 54.78 dB | 717 kHz – **7.90 MHz** | 24.3 dB |
     | **TT Narrow (`BWN=1`)** | 0.7913 V (0.73 mV) | 4.63 mA | 54.51 dB | 701 kHz – **6.03 MHz** | **33.3 dB** |
     - **Post-PEX PVT Cutoff Spread**: **`6.54–7.18 MHz` (±4.7%)** — **6.0× tighter** than the baseline resistor Sallen-Key (±28%), centered right at **7.08 MHz** for GPS L1 C/A + Galileo E1. Five-stage PEX gain spread is **±0.59 dB (±0.12 dB/stage)**.
   - **LNA PEX** (after MIM plate flip, [pex_blocks_rev4.log](layout/review/pex_blocks_rev4.log)): at 1.575 GHz, **`S11 = −14.9 dB`** (was −14.3 dB), differential gain **`13.32 dB`**, **`NF = 2.19 dB`** (improved by **−0.07 to −0.10 dB** vs 2.26–2.29 dB).
   - **Mixer LO Length Trim** (`lo_trim.py`): Retuned 8-phase LO bus for rev.4 routing, achieving 4.092 MHz I/Q gain imbalance **`+0.172 dB`** and quadrature phase **`−89.12°` (`0.88°` error)**.
   - **Closed-Loop PLL Full PEX** (`vco_ring4` PEX + `pll_core` PEX, [pex_pll_rev4.log](layout/review/pex_pll_rev4.log)): Confirmed clean cold-start lock to **`VCTRL ≈ 2.116 V`** (matching baseline PEX 2.114–2.135 V) with the static TG DFF `/48` divider (`dff_st`) and `RB0`/`RB1` CDM resistors in `vco_ring4` (schematic locked at `1.57105 GHz`, `vc_end = 1.559 V`, `vc_pp = 1.17 mV`).
3. **Power Mesh IR Drop & EM Analysis** ([ir_drop_rev4.log](layout/review/ir_drop_rev4.log) vs baseline [padframe/ir_drop.log](layout/review/padframe/ir_drop.log)):
   - Total analog current: `VDDA` = **33.4 mA** (was 34.8 mA), `VDDV` = **3.8 mA**, total `VSSA` = **37.2 mA** (was 38.6 mA).
   - `VDDA`: max drop **46.40 mV** (was 49.53 mV), M4 EM max **1.542 mA/µm**, M5 max 0.588 mA/µm, Via4 max 0.118 mA.
   - `VSSA`: max drop **47.09 mV** (fed exclusively from north analog pads), **M4 EM max `1.241 mA/µm` (−30% vs 1.770 mA/µm; 0 edges > 1.4 mA/µm)**, M5 max 0.626 mA/µm, Via4 max 0.091 mA (−27%).
   - Worst-case M4 EM across all rails improved from **1.770 → 1.542 mA/µm (−13%)**, safely within the 85 °C limit (`2.09 mA/µm`).
4. **Overvoltage Stress Check** (`final_tran.py stress`, FF −20°C 3.63 V, [stress_rev4.log](layout/review/final/stress_rev4.log) vs baseline [stress.log](layout/review/final/stress.log)):
   - Divider (`xpll.xdiv`) nodes exceeding `VDD+0.3V`: **7 (max 4.005 V) → 0 (completely eliminated)**.
   - Chip-wide FET terminal pairs exceeding `VDD+0.3V`: **16 (max 4.016 V) → 6 (max 3.993 V, StrongARM comparators only)**.

### 2026-11-20 — Phase D: Final Full-Chip LibreLane Signoff & Verification Complete

1. **Final Full-Chip LibreLane Run** ([RUN_2026-11-20_08-07-52](chip/librelane/runs/RUN_2026-11-20_08-07-52), **clean exit code 0**):
   - Macro placement aligned to `location: [456.0, 498.4]` with `FP_MACRO_VERTICAL_HALO: 22` and updated `PDN_OBSTRUCTIONS` ([macros_gnss.yaml](chip/librelane/macros/macros_gnss.yaml), [config.yaml](chip/librelane/config.yaml)).
   - **Final Submission GDS**: [`chip/final/gds/chip_top.gds`](chip/final/gds/chip_top.gds) (93,464,606 bytes, **SHA-256: `979043407d96d8d174f5776deb1540f8ce4e1ad8e9a703c13230980ccefc5ffc`**).
   - **Signoff Scorecard** ([metrics.json](chip/librelane/runs/RUN_2026-11-20_08-07-52/final/metrics.json)):
     - **Magic DRC**: **0** | **Magic Illegal Overlap**: **0**
     - **KLayout DRC**: **0** | **KLayout Antenna**: **0** | **KLayout Density**: **0**
     - **XOR Difference**: **0** | **Detailed Route DRC**: **0**
     - **Netgen LVS**: **0 errors** (0 device/net/property/pin mismatches, including separated `VSSA` vs `VSS`)
     - **OpenROAD STA**: **0 setup / 0 hold violations** across all 9 corners (worst setup slack `1.82 ns`, worst hold slack `0.47 ns`; the 6 `max_slew` flags are strictly on the intentional 4 mA `SL=1` external `bidir[0..5]` pads, 0 internal core violations)
     - **OpenROAD IRDropReport**: worst `VDD` drop **`24.1 µV`**, worst `VSS` drop **`21.5 µV`** (0 PSM violations)
2. **Functional Simulation (`cocotb`)**:
   - **RTL Simulation**: **PASS** (full SPI register read/write, reset defaults, analog control wiring).
   - **Gate-Level (`GL=1`) Simulation**: **PASS** (`400700.00 ns`, `TESTS=1 PASS=1 FAIL=0`).
3. **Regenerated Schematics, Layout Renders & Bonding Diagram**:
   - Regenerated wired schematics for all updated/new cells ([doc/sch_wired/](doc/sch_wired/): `chip_top`, `padframe`, `gnss_afe_analog`, `if_chain`, `vga`, `vga_fix`, `bias_if`, `gm_master`, `gm_unit`, `gmc_lpf1`, `gmc_lpf2`, `pll_core`, `div48`, `div2`, `div3`, `dff_st`, `vco_ring4`, `decap_vco`, `adc2b`, `lna_nc`, `mixer_iq`).
   - Regenerated and visually verified layout renders and bonding diagram ([chip_quarter.png](doc/chip_quarter.png), [macro_quarter.png](doc/macro_quarter.png), [bonding_quarter.png](doc/bonding_quarter.png) — **all 56 bond pad centers remain within 0.1 µm of the COB template**).
4. **Official Wafer.Space `gf180mcu-precheck` (`--slot 0p5x0p5`) — 16/16 ALL PASS**:
   - Run: [RUN_2026-11-20_08-25-12](chip/precheck_q/runs/RUN_2026-11-20_08-25-12) (29 min 26 s, **clean exit code 0**, [precheck_rev4.log](layout/review/precheck_rev4.log)).
   - Input GDS SHA-256: `979043407d96d8d174f5776deb1540f8ce4e1ad8e9a703c13230980ccefc5ffc`.
   - All stages clear: `ReadLayout` / `CheckTopLevel (chip_top)` / `CheckSize (1936.0 × 2531.0 µm = 0p5x0p5)` / `GenerateID` / `Render` / **`KLayout Density (0 violations: COMP 47.2%, Poly2 31.9%, M1 43.1%, M2 51.0%, M3 54.7%, M4 62.7%, M5 61.6%, MetalTop 61.6%)`** / **`ZeroAreaPolygons (0 violations)`** / **`KLayout Antenna (0 violations)`** / **`Magic DRC (0 violations)`** / **`KLayout DRC (0 violations)`** / `WriteLayout`.

---

## 8. Before vs. After Comparison (Baseline 2026-11-15 vs. Final rev.4 2026-11-20)

| Metric | Baseline (2026-11-15) | Final rev.4 (2026-11-20) | Improvement |
| :--- | :---: | :---: | :--- |
| **Final GDS SHA-256** | `5dc43f34...` | **`97904340...`** | Baseline frozen in `archive/baseline_20261115/` |
| **Digital Output Pads** | `bi_24t` (24 mA) | **`bi_t` (4 mA, `SL=1`)** | `DVSS` bounce **77.4 → 10.8 mVpp (7.2× lower)** |
| **Digital Input Pads** | `in_c` (`RST_N`/`CS_N`/`SDI`) | **`in_s` (all 4 Schmitt)** | Glitch immunity on RC reset & SPI edges |
| **Analog/Digital Ground Isolation** | On-chip `VSS=DVSS` short | **`VSSA` + `fill10_noPWR` + `ISOSUB`** | Full electrical & LVS substrate separation |
| **IF LPF Architecture / PVT Spread** | Resistor Sallen-Key / **±28%** | **XTAL-locked SC Auto-Tuned $G_m$-C / ±4.7% (PEX)** | **6.0× tighter** (TT PEX **7.08 MHz**, 28.1 dB rej.) |
| **VGA Architecture / IF 1ch Current** | Poly-R load & degen / 6.06 mA | **All-MOS Resistor-Free / 4.87 mA (PEX)** | **−20% power**, constant DC CM across all 4 gain codes |
| **Divider (`div48`) Overvoltage Nodes** | TSPC (7 nodes > `VDD+0.3V`, max 4.01 V) | **Static TG DFF (0 nodes > `VDD+0.3V`)** | **100% eliminated** in divider (chip-wide FETs 16 → 6) |
| **LNA PEX Performance (1.575 GHz)** | S11 −14.3 dB / NF 2.26–2.29 dB | **S11 −14.9 dB / NF 2.19 dB** | Flipped AC-coupling MIMs: −0.07 to −0.10 dB NF |
| **AFC DAC PEX Linearity** | No end dummies | **Poly dummies (`INL -0.13/+0.20, DNL -0.01/+0.33`)** | Guaranteed monotonic, reduced edge mismatch |
| **Power Mesh Worst M4 EM** | `VSS` 1.770 mA/µm | **`VSSA` 1.241 / `VDDA` 1.542 mA/µm** | `VSSA` M4 EM **−30%**, worst rail EM **−13%** |
| **Analog Macro Size / Pad Frame** | `1029.8 × 1539.4 µm` / 56 pads | **`1020.9 × 1571.0 µm` / 56 pads unchanged** | 100% compatible with existing COB board |
| **DRC / LVS / Antenna / Density / STA / GL / Precheck** | All 0 / PASS | **All 0 / 16/16 PASS** | **Ready for Wafer.Space tapeout submission** |

---

## 9. Phase E: Full-Block PEX Audit, Coupling Fixes (rev.4b), Re-Signoff & Long System PEX

A comprehensive fresh PEX audit across all 12 analog blocks and top-level inter-block routing (`top_wires.py`) uncovered **two real layout coupling bugs that would have degraded PLL reference spurs**, which were immediately fixed, re-routed, re-extracted, and re-signed off as **rev.4b**.

### 9.1 Coupling Bugs Found & Fixed by PEX Audit (rev.4 → rev.4b)
1. **Top-level `vctrl_i ↔ refck_a` / `fs` coupling (`6.76 fF` / `1.30 fF`)**:
   - `lvs.py` renames internal `vctrl` to `vctrl_i` before routing, while `SEP["gnss_afe_analog"]` in `auto.py` still referenced `"vctrl"`. Consequently, the new 16.368 MHz full-swing `refck_a` clock ran right next to the high-impedance `vctrl_i` node (2 kΩ / 0.75 pF) with `6.76 fF` coupling (`fs` also coupled `1.30 fF`).
   - **Fix**: Corrected `SEP["gnss_afe_analog"]` to `vctrl_i` with stronger separation (4 tracks / cost 8.0), and added separation between `aip/ain/aqp/aqn` and clocks / ADC outputs.
   - **Result** ([top_build_rev4b.log](layout/review/top_build_rev4b.log)): `vctrl_i ↔ refck_a` **`6.76 → 0.04 fF` (169× reduction)**, `vctrl_i ↔ fs` **`1.30 → 0.00 fF` (eliminated)**, `aqp ↔ I_SIGN` **`0.88 → 0.04 fF`**, `aqp ↔ refck_a` **`0.73 → 0.00 fF`**.
2. **Internal `pll_core` `FS ↔ VCTRL` coupling (`2.43 fF`)**:
   - `XDIV` sat west of `XLF`, causing `FS` to cross over `XLF`'s MIM capacitor.
   - **Fix**: Reordered `FLOOR["pll_core"]` to `["XPFD", "XLF", "XCP", "XDIV"]` (placing `XDIV` directly at the east `FS` pin) and tightened `SEP["pll_core"]` to 5 tracks / cost 10.0.
   - **Result**: Same `pll_core` size, DRC 0, LVS OK, and **`FS ↔ VCTRL` cut from `2.43 → 0.00 fF`** (`REFCK_O ↔ VCTRL` and `REFCK ↔ VCTRL` also `0.00 fF`).

### 9.2 All-Block Post-Layout PEX Verification Summary (TT / SS / FF, ngspice)

| Block | Post-Layout PEX Check | TT 27°C 3.3V | SS 85°C 3.135V | FF −20°C 3.465V | Verdict |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **`bias_gen`** | Cold power-on ramp (`0→VDD`) | `NB=0.960V, PB=2.056V, 205.6 µA` | `NB=1.084V, PB=1.734V, 223.1 µA` | `NB=0.852V, PB=2.357V, 204.7 µA` | **PASS** |
| **`refbuf`** | 16.368 MHz 0.4 Vpk sine → CMOS | `0..3.30V, duty 51.2%, 203 µA` | `0..3.14V, duty 51.5%, 114 µA` | `0..3.47V, duty 50.6%, 347 µA` | **PASS** |
| **`vmon_buf`** | `VCTRL` 0.8–2.4 V / 100 kΩ load | `gain 0.983, |Iin|≤2.4pA` | `gain 1.027, |Iin|≤2.4pA` | `gain 0.973, |Iin|≤2.4pA` | **PASS** |
| **`lna_nc` + `RFIN`** | Pad + ESD + rev.4 wire at 1.575 GHz | `S11 −24.28 dB, G 13.51 dB, NF 2.21 dB` (3.9 nH+1 nH) | — | — | **PASS** |
| **`mixer_iq`** | 4.092 MHz conv., I/Q quad., LO leak | `I/Q +0.169 dB, −89.21°`, LO leak 2.4× lower vs baseline | — | — | **PASS** |
| **`vco_ring4`** | `pex_vco` tuning range & 8-phase err | `B=0: 717–1666 MHz, I/Q −0.46°` | `B=3: 853–1618 MHz, I/Q −0.45°` | `B=0: 606–1989 MHz, I/Q −0.60°` | **PASS** |
| **`gm_master` + `if_chain`** | Closed-loop auto-tune + all 4 codes | `fh=7.08 MHz, rej16=28.1 dB`, constant `4.865 mA / Vcm 2.143V` across all 4 codes (`37.8–69.8 dB`) | `fh=6.54 MHz, rej16=30.7 dB` | `fh=7.18 MHz, rej16=27.4 dB` | **PASS** |
| **Dual I+Q Max-Gain Stab.** | Shared 5 nH+0.5 Ω supply + 1 mV kick | `384.6→0.56 mVpp` (Q/sup 0.00) | `345.0→0.74 mVpp` (Q/sup 0.00) | `367.8→0.08 mVpp` (Q/sup 0.00) | **PASS** |
| **`adc2b`** | 4.092 MHz AC-coupled + 16.368 MHz CLK | `SIGN/MAG exact, lad 1.125/1.203/1.280V, 0.51 mA` | `exact, lad 1.070/1.141/1.213V, 0.43 mA` | `exact, lad 1.179/1.265/1.351V, 0.63 mA` | **PASS** |
| **`afc_dac`** | 256-code sweep INL/DNL/mono | `INL −0.15/+0.19, DNL −0.01/+0.33, mono=True` | `INL −0.01/+0.05, DNL −0.05/+0.00, mono=True` | `INL −0.41/+0.46, DNL −0.03/+0.87, mono=True` | **PASS** |

### 9.3 rev.4b Final GDS Signoff (Complete) & Long System PEX (Running)
- **Final Submission GDS (rev.4b)**: [`chip/final/gds/chip_top.gds`](chip/final/gds/chip_top.gds) (93,403,478 bytes, **SHA-256: `9aaf97a97106c0a0e8157fec0cb4ebc64223e1d493b82b041edcf13acd5c2af3`**)
- **LibreLane Full-Chip Signoff** (`RUN_2026-11-20_11-58-45`): Magic DRC **0** | KLayout DRC **0** | Antenna **0** | Density **0** | XOR **0** | Netgen LVS **0** | STA 0 setup / 0 hold across all 9 corners | IR Drop worst **24.1 µV**
- **rev.4b Analog Power Mesh** ([ir_drop_rev4b.log](layout/review/ir_drop_rev4b.log)): `VDDA` max drop **43.21 mV** (M4 EM **1.404 mA/µm**), `VSSA` max drop **46.35 mV** (M4 EM **1.198 mA/µm**, **−32%** vs baseline), worst rail M4 EM **1.770 → 1.404 mA/µm (−21%)**
- **cocotb Verification**: RTL **PASS** | Gate-Level (`GL=1`) **PASS**
- **Official Wafer.Space `gf180mcu-precheck` (`--slot 0p5x0p5`)** (`RUN_2026-11-20_12-48-28`, [precheck_rev4b.log](layout/review/precheck_rev4b.log)): **16/16 ALL PASS (0 violations, 1h 44m 54s)**
- **P&R Digital Core + Real `bi_t`/`in_s` Pads + SPEF Transistor-Level SPICE (`core_spice.py`, 10 MHz SCLK, 30 pF SDO load — ALL 3 CORNERS PASS)** ([core_spice_rev4b.log](layout/review/core_spice_rev4b.log)):
  - `TT 27°C 3.3V`: all 3 SPI frames & 19 macro control outputs full-swing OK, `SCLK↓→SDO` **22.0 ns** (28.0 ns margin at 10 MHz) → **PASS**
  - `SS 125°C 3.0V`: all 3 frames OK, 4 mA `bi_t` (`SL=1`) **39.9 ns** (**10.1 ns margin** at 10 MHz, **60.1 ns margin** at 5 MHz) → **PASS**
  - `FF −40°C 3.465V`: all 3 frames OK, **14.1 ns** (35.9 ns margin at 10 MHz) → **PASS**
- **Full RF-to-IF Receiver PEX + Closed-Loop PLL Reference Spurs (`rx_pex.py` + `pll_spur.py`, TT / SS / FF — ALL 3 CORNERS PASS)** ([rx_pex_rev4b.log](layout/review/rx_pex_rev4b.log); LNA PEX + Mixer PEX + VCO PEX + PLL PEX + rev.4b `top_wires.json` + RFIN pad/ESD/match, 1575.42 MHz at −70 dBm):
  | Corner (`B` / `ICP2`) | Locked `fLO` / `VCTRL` | Port→IF Gain (I / Q) | I/Q Imb. / Phase | `k=1` (±16.368 MHz) Spur | `k=2` (±32.736 MHz) Spur | Verdict |
  | :--- | :---: | :---: | :---: | :---: | :---: | :---: |
  | **TT 27°C 3.3V** (`B=0, ICP2=0`) | `1571.38 MHz` / `2.124 V` | `24.0 / 23.9 dB` | `0.15 dB` / **`89.4°`** (`0.6°` err) | **`−51.5 / −50.6 dBc`** | `−45.8 / −44.8 dBc` | **PASS** |
  | **SS 85°C 3.135V** (`B=3, ICP2=1`) | `1571.25 MHz` / `1.453 V` | `19.8 / 19.7 dB` | `0.09 dB` / **`89.6°`** (`0.4°` err) | **`−47.8 / −47.6 dBc`** | `−46.0 / −45.1 dBc` | **PASS** |
  | **FF −20°C 3.465V** (`B=0, ICP2=0`) | `1571.33 MHz` / `1.537 V` | `25.2 / 25.0 dB` | `0.23 dB` / **`88.6°`** (`1.4°` err) | **`−44.4 / −44.1 dBc`** | `−41.8 / −41.3 dBc` | **PASS** |
  - **Direct Proof of rev.4b Coupling Fix**: Fixing `vctrl_i ↔ refck_a` (`6.76 → 0.04 fF`) and `FS ↔ VCTRL` (`2.43 → 0.00 fF`) delivered **−51.5 / −50.6 dBc** TT reference spurs (exceeding baseline −44 to −48 dBc), and tightened I/Q quadrature error to `0.6°` TT / `0.4°` SS (2–4× better than baseline `1.2°` / `1.7°`).
- **Full-Chip Mixed-Signal `ngspice` (`chip_spice.py rev4_sch`, 6.90 µs, 2 SPI frames, `Rser = 0 Ω` — PASS)** ([chip_spice_rev4_sch.log](layout/review/chip_spice_rev4_sch.log); P&R digital + SPEF + real 4 mA `bi_t`/`in_s` pads + separated `VSSA`/`VSS` + full rev.4b analog):
  - **SPI Digital + Real Pads (10 MHz SCLK, 30 pF SDO)**: Frame 1 (`A88000`) & Frame 2 (`A88015`, during active RF reception) **OK**, `SCLK↓→SDO` **21.8 ns** (28.2 ns margin), all 19 macro control inputs matched → **PASS**.
  - **End-to-End 1575.42 MHz RF → Digital Output Pads**:
    - Closed-loop PLL locked at `vctrl = 1.4457 V`, **`CLKOUT` pad `16.3680 MHz`**, 4.092 MHz IF tone **`I = 18.24 mV / Q = 18.50 mV`** (0.12 dB balance), **`I_SIGN` pad `4.0919 MHz` (`0..3.33 V`)**, **`Q_SIGN` pad `4.17 MHz` (`0..3.33 V`)**.
    - **Self-Interference Immunity with ZERO External Series Resistors (`Rser = 0 Ω`)**: Unlike the baseline (24 mA `bi_24t` + shorted `VSS=DVSS`, which suffered 170–385 mV rms IF corruption at `Rser = 0 Ω`), rev.4b showed **0.00 mV `VSSA` bounce increase** (`15.38 → 15.36 mVpp`) during active 30 pF SDO SPI Frame 2 (4.2–6.7 µs), keeping IF residual to **`14.9–17.7 mVpp` (~5 mV rms, >35× / >30 dB cleaner than baseline)**.
    - Supply currents: total analog `I(VDDA+VDDV) = 36.60 mA`, digital `0.634 mA` (idle) / `1.166 mA` (SPI active).
- **Full-Chip 9-Block PEX (`chip_spice.py rev4_pex`, 1.61 MB / 15,894 nodes, 4.20 µs, `Rser = 0 Ω` — PASS)** ([chip_spice_rev4_pex.log](layout/review/chip_spice_rev4_pex.log)):
  - **SPI Digital + Real Pads (10 MHz SCLK, 30 pF SDO)**: Frame 1 (`008015` → SDO `A88000`) exact match, `SCLK↓→SDO` **21.8 ns** (28.2 ns margin), all 19 macro control inputs matched → **digital PASS**.
  - **Closed-Loop PLL PEX + `CLKOUT` Pad**: locked at **`vctrl = 2.1297 V`**, **`CLKOUT` pad `16.3680 MHz`** (`0..3.33 V`).
  - **LNA + Mixer PEX + Ground Isolation**: `mix 4M = 0.088 / 0.085 mV` (−0.8 dB vs `rev4_sch` 0.097 / 0.093 mV); during active SPI Frame 1 (`VSSD = 45.3 mVpp`), **`VSSA` stayed isolated at `11.5 mVpp`**.
  - Note: Because `gm_master.pex`'s internal 20 pF loop capacitor started from 0 V under `uic` (5 µs cold startup), `rev4_pex` ended at 4.2 µs right as `VTN` reached 0.80 V. Complete post-lock operation was confirmed by the dedicated 9 µs cold-start end-to-end PEX below.
- **4-Block Cold-Start End-to-End PEX (`bias_gen + gm_master + if_chain + adc2b`, `0→3.3 V` power-on ramp, 9 µs — PASS)** ([e2e_if_adc_pex_rev4b.log](layout/review/e2e_if_adc_pex_rev4b.log)):
  - From 0 V power-on, `gm_master.pex` self-locks to **`VTN = 0.815 V`** in ~5 µs; `if_chain.pex` (`code 10`) amplifies 0.30 mVpk to **`164.78 mVpk` (54.79 dB, matching AC PEX 54.78 dB within 0.01 dB)**; `adc2b.pex` outputs rail-to-rail **`SIGN = 4.092 MHz` (`−0.04..3.31 V`)** and **`MAG = 24.4%`** at **`6.07 mA`** total 4-block current.


---

## Phase F: `slot 0p5x1` Expansion + `proppy/ttgf-megabytebeat` (XLS Original) Dual-VDD Integration (2026-11-25, Signed Off)

### F.1 Requirements & Architecture
Expanded the signed-off GNSS AFE rev.4b chip (frozen `0p5x0p5` snapshot archived at `archive/rev4b_0p5x0p5_20261125/`) to Wafer.Space **`slot 0p5x1`** (`1936.0 × 5122.0 µm`) and integrated the **exact XLS-generated 5-track original** of [proppy/ttgf-megabytebeat](https://github.com/proppy/ttgf-megabytebeat) in an independent `VDD_BB` power domain.

1. **Exact XLS Original Macro (`chip/macros/megabytebeat/`)**
   - Compiled `src/megabytebeat.x` + `src/bytebeat.x` using the exact upstream Google XLS release `v0.0.0-11174-g32dc47058` into `src/megabytebeat.v` (`interpreter_main --compare=jit`: 2/2 unit tests PASS).
   - Wrapped in `src/megabytebeat_macro.sv` with an **internal pull-down (`PD=1`, `VDD_BB`-driven) on `bb_ena_PAD`**:
     - `bb_ena = 0` (unconnected default): GF180 integrated clock gate `gf180mcu_fd_sc_mcu7t5v0__icgtp_4` completely stops `gclk` (after a 1-cycle `ena_q` synchronous reset flush) and clamps all 5 PWM outputs to `0` → **zero disturbance during GNSS operation**.
     - `bb_ena = 1`: bit-identical to upstream `tt_um_proppy_megabytebeat` across all 5 tracks (`the 42 melody`, `fractal trees`, `untitled`, `a tune to share`, `sierpinski harmony`).
   - Hardened `megabytebeat_macro` (`960.0 × 960.0 µm`, 22,912 cells, `34.0%` utilization, dedicated `VDD_BB` / shared `VSS`) with LibreLane: **Magic DRC = 0, KLayout DRC = 0, Netgen LVS = 0, XOR = 0, Antenna = 0, STA Setup/Hold = 0**.
   - Exported dedicated `VDD_BB`-domain tie outputs (`vdd_bb_hi_s/e`, `vss_lo_s/w/e`) from `megabytebeat_macro` to drive all static `megabytebeat` I/O pad control pins (`PD`, `PU`, `OE`, `SL`, `IE`, `CS`, `PDRV`), paired with `RSZ_DONT_TOUCH_RX` on all `bb_*` nets → **zero GNSS-`VDD` standard cells touch any `megabytebeat` net (zero cross-domain leakage / back-powering)**.

2. **Three Independent VDD Padring Islands (`fill10_noVDD` + `fill10_supplyVDD`, Shared Digital `VSS`)**
   - **GNSS Analog (`afe_rf_pad`, North)**: `VDDA` / `VDDV` / `VSSA` isolated by `brk_w` / `brk_e` (`fill10_noPWR`); untouched rev.4b `gnss_afe_analog` placed at `[456.0, 3089.4]` `FN`.
   - **GNSS Digital (North + Upper East/West)**: `VDD` / `DVDD` (4 pads: `dvdd_pads[0..3]`) + 10 GNSS SPI/ADC digital pins.
   - **`megabytebeat` Digital (South + Lower East/West)**: `VDD_BB` / `DVDD_BB` (3 pads: `dvdd_bb_pads[0..2]`) + 24 `megabytebeat` pins (`bb_clk`, `bb_rst_n`, `bb_ena`, `bb_ui[7:0]`, `bb_uio[7:0]`, `bb_uo[4:0]`).
   - **VDD Domain Breaks**: 2× `./gds/fill10_noVDD.gds` (`brk_vdd_e` at `y = 2252.5 µm`, `brk_vdd_w` at `y = 2555.5 µm`) cleanly sever `VDD`/`DVDD` between GNSS digital and `megabytebeat` while keeping **digital `VSS`/`DVSS` (all 7 pads) continuous around the ring**.
   - **`VDD_BB` Core Delivery**: 6× `./gds/fill10_supplyVDD.gds` (3 East `sup_vdd_e0/e1/e2`, 3 West `sup_vdd_w0/w1/w2`, centered in the 64 µm gaps between PDN Metal5 stubs with `11–27 µm` clearance) feed 9 µm-wide **Metal5** jumpers into a Metal5 C-trunk and 30 Metal5 fingers directly onto `megabytebeat_macro`.
   - **Shared `VSS` Core Connection**: 12 South Metal4 straps to the South Metal3 `VSS` core ring (auto-skipping the 3 `LCM(60, 75) = 300 µm` aligned `VDD` ring taps) + 15 North macro / 12 North chip Metal4 straps joined via a North Metal3 `VSS` collector bar using PDN's `VIARULE Via3_GEN_HH` 4×4 vias.
   - Physical spacing between `gnss_afe_analog` (`y = 3089.4..4660.4 µm`) and `megabytebeat_macro` (`y = 520.0..1480.0 µm`): **`1,609 µm` (1.61 mm)**.

### F.2 Final 73-Pad Pinout (`slot 0p5x1` Template Bonding Frame)

| Side | Span (`µm`) | Power Domain | Pad Signals |
|---|---|---|---|
| **South (8 pads)** | `x = 447.5 .. 1413.5` | **`VDD_BB`** | `BB_CLK`, `BB_RST_N`, `BB_ENA (int PD)`, `DVSS(shared)`, `DVDD_BB`, `BB_UO[0]` (trk0: the 42 melody), `BB_UO[1]` (trk1: fractal trees), `BB_UO[2]` (trk2: untitled) |
| **East Lower (12 pads)** | `y = 471.5 .. 2143.5` | **`VDD_BB`** | `BB_UO[3]` (trk3: a tune to share), `BB_UO[4]` (trk7: sierpinski harmony), `DVSS(shared)`, `DVDD_BB`, `BB_UIO[0..7]` (`c[3:0], d[3:0]`) + 3× `fill10_supplyVDD` |
| *East Break* | `y = 2252.5` | *Break* | **`brk_vdd_e` (`fill10_noVDD`)** — cuts `VDD`/`VDD_BB`, keeps `VSS` shared |
| **East Upper (16 pads)** | `y = 2295.5 .. 4575.5` | **GNSS `VDD`** | `I_SIGN`, `DVSS(shared)`, `DVDD`, `I_MAG`, `Q_SIGN`, `Q_MAG`, `CLKOUT`, `nc[0..4]`, `DVSS(shared)`, `DVDD`, `nc[5..6]` |
| **North (11 pads)** | `x = 410.5 .. 1525.5` | **GNSS `VDD` / Analog** | `REFIN`, `AFCOUT`, `DVSS(shared)`, `DVDD`, `VCTRL`, `brk_w(fill10_noPWR)`, **`afe_rf_pad` (`VDDV \| VSSA VDDA VSSA RF VSSA`)**, `brk_e(fill10_noPWR)` |
| **West Lower (13 pads)** | `y = 473.5 .. 2441.5` | **`VDD_BB`** | `BB_UI[0..7]` (`a[3:0], b[3:0]`), `nc_bb[0..2]`, `DVSS(shared)`, `DVDD_BB` + 3× `fill10_supplyVDD` |
| *West Break* | `y = 2555.5` | *Break* | **`brk_vdd_w` (`fill10_noVDD`)** — cuts `VDD`/`VDD_BB`, keeps `VSS` shared |
| **West Upper (13 pads)** | `y = 2605.5 .. 4573.5` | **GNSS `VDD`** | `SCLK`, `RST_N`, `SDI`, `CS_N (int PU)`, `SDO`, `nc[7..10]`, `DVSS(shared)`, `DVDD`, `nc[11..12]` |

### F.3 Signoff & Verification Summary (ALL PASS)

| Check | Result | Details / Artifact |
|---|---|---|
| **LibreLane `chip_top` (`RUN_2026-11-25_16-01-45`)** | **85/85 ALL PASS** | `chip/final/metrics.json` |
| ├ Magic DRC / KLayout DRC | **0 / 0** | Full chip `1936 × 5122 µm` |
| ├ KLayout Antenna / Density | **0 / 0** | `Metal2_ignore_active: true` |
| ├ Magic vs KLayout XOR | **0** | Reuses PDN `VIARULE Via3_GEN_HH` |
| ├ **Netgen LVS** | **0 (`Circuits match uniquely`)** | `VDD` / `VDD_BB` / `VDDA` / `VDDV` / `VSS` / `VSSA` all uniquely matched & isolated |
| ├ **STA (9 corners Setup / Hold)** | **0 / 0** | Setup WS `+0.610 ns` / Hold WS `+0.457 ns` (2 asynchronous clocks) |
| ├ IR Drop (avg / worst) | **`1.08 µV` / `19.3 µV`** | GNSS digital grid |
| ├ Dual-VDD Isolation Audit (`chip_top.pnl.v`) | **0 cross-domain** | 0 GNSS-`VDD` stdcells on any `bb_*` net (`fill10_noVDD`×2, `fill10_supplyVDD`×6, `fill10_noPWR`×2) |
| **`cocotb` RTL + Gate-Level (`GL=1`, powered netlist)** | **PASS / PASS** | GNSS SPI (`0xA88000`/`0xADA3C5`) + `bb_ena=0` quiet clamping + bit-exact 5-track PWM (`t=0..11`) + `bb_ena 1→0` disable |
| **Wafer.Space Official `gf180mcu-precheck --slot 0p5x1`** | **16/16 ALL PASS (0 violations)** | `RUN_2026-11-25_16-46-27`, `layout/review/precheck_0p5x1_megabytebeat.log` |
| **Final GDS** | **`143,024,474` bytes** | `chip/final/gds/chip_top.gds`<br>SHA-256: `7baecb319016aaccae354cdecb511b88153b19c569a497ad7d935d39db2db402` |
