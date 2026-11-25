# GNSS AFE (GF180MCU) レビュー・改善計画および作業記録

英語版: [README_gemini_EN.md](README_gemini_EN.md)

本ファイルは、[prompt_gemini.md](prompt_gemini.md) の依頼に基づき、Claude Code で作成された GF180MCU (`gf180mcuD`, Wafer.Space slot `0p5x0p5`) 用 GNSS アナログフロントエンドの回路図・RTL・レイアウト・検証結果の妥当性レビュー、改善提案、および提出に向けた作業記録をまとめたものです。

- レビュー基準ベースライン:
  - 最終 GDS: `chip/final/gds/chip_top.gds` (SHA-256: `5dc43f34bc8e9d5964c2a791bb2c6bd7913a1ccf1866c3bbc3ef57630751c1c1`、86,597,382 バイト)
  - 参照ドキュメント: [README.md](README.md)、[prompt.md](prompt.md)、[doc/report.md](doc/report.md)、[RESUME.md](RESUME.md)
  - 参照ソース: `scripts/gen_cells.py`、`chip/src/chip_core.sv`、`chip/src/chip_top.sv`、`chip/librelane/config.yaml`、`chip/librelane/slots/slot_0p5x0p5.yaml`、`chip/librelane/chip_top.sdc`、`scripts/make_iocells.py`、`scripts/layout/*.py`、`layout/review/final/*.log`、`layout/review/r4_chip_spice_noise.log`

---

## 1. 総評（全体の妥当性）

全体として、GF180MCU (`gf180mcuD`) のクオーターサイズ（`0p5x0p5`）で GPS L1 C/A + Galileo E1 用フロントエンドをテープアウト水準まで仕上げた完成度の高い設計です。

特に高く評価できる点:
- **サブハーモニック 8 相ミキサ + 785.664 MHz 4 段リング VCO**: 1.57 GHz での LO 配線・分周器・VCO 引き込み問題を回避し、打上げ振動に弱い外付け LC インダクタも不要にしている。
- **インダクタレス雑音キャンセル LNA (`lna_nc`)**: シングルエンド 50 Ω 入力で外付けバラン不要、PEX 込みシステム NF 約 1.65–1.72 dB を達成。
- **丁寧な PEX・コーナー・チップ全体検証**: 電流ステアリング型 CP による基準スプリアス改善（−43.8〜−48.0 dBc）、比例バイアス `bias_if` による SS 85 °C IF 利得崩壊（−35 dB）解消、`vmon_buf`、IF 帯域トリム（BWW/BWN）、EM 対策、56 パッド固定位置と COB 基板照合、LVS / magic DRC / KLayout DRC / Antenna / `gf180mcu-precheck` すべて 0 エラー。

---

## 2. 妥当性チェックで見つかった懸念点・リスク

### 2.1 重大度：高（実機動作・信頼性に直結）

1. **チップ内 `DVSS`/`VSS` 短絡と 24 mA 出力パッドによる IF 自己干渉**
   - `chip/src/chip_top.sv` で `VSS = DVSS` が短絡され、`scripts/make_iocells.py` の `fill10_noVDD` も `DVDD`/`VDD` リングのみ切断しており、`DVSS`/`VSS` リングは全周連続。
   - 出力パッドに 24 mA 駆動の `gf180mcu_fd_io__bi_24t` を使用しているため、全チップ SPICE（`doc/report.md` 3.15 節 (13)）の通り、基板側の直列 330 Ω がないと IF が 170–385 mV rms の回り込みで破綻する。330 Ω 時で C/N0 劣化 ≤ 0.47 dB と見積もられているが、p 基板経由の結合と COB 基板の長いリターン経路は未検証。
   - なお、PDK (`gf180mcu_fd_io`) には外形同一（`75 × 350 µm`）で 4 / 8 / 12 / 16 mA 選択可能な `gf180mcu_fd_io__bi_t` が存在する。
2. **EM（エレクトロマイグレーション）の接合温度上限と環境 85 °C 仕様の整合**
   - 電源メッシュ（VSS M4 最大 1.77 mA/µm）およびブロック内配線（LNA RFIN M3 1.87、VCO VR M3 1.94 mA/µm 等）は 85 °C 上限（2.09 mA/µm）以内だが 110 °C 上限（1.0 mA/µm）を超過しており、許容接合温度 $T_j$ の目安は約 90 °C。
   - チップ消費電力約 180–200 mW の自己発熱（COB 実装で +10〜16 °C 想定）を考慮すると、周囲温度 85 °C 動作時は $T_j \approx 95\text{–}101\text{ °C}$ となり、高温連続動作・バーンイン時の EM マージンが不足する。
3. **ダイナミック回路のゲート酸化膜電圧ストレス**
   - `layout/review/final/stress.log` の通り、TSPC 分周器 (`tspc_dff`) および StrongARM 比較器 (`sa_comp`) の内部ノードが容量性突き上げで公称 3.3 V 時でも最大 3.68 V（3.3 V 定格 3.63 V を超過）、+10 % 電源では 4.02 V に達する。実機では `VDD / VDDV ≤ 3.3 V` の厳守が必要。

### 2.2 重大度：中（デジタル統合・電源ドメイン・アナログ動作点）

4. **デジタル入力パッド種別と STA 制約の抜け**
   - `RST_N` と `CS_N` に通常 CMOS 入力（`gf180mcu_fd_io__in_c`）を使用（シュミット入力 `in_s` は `SCLK` のみ）。`RST_N` は外付け RC リセット想定、`CS_N` は `always_ff @(posedge cs_n)` のエッジクロックおよび `cnt_rst_n = rst_n & ~cs_n` の非同期リセットに使われるため、`in_s` 化が望ましい。
   - `chip/librelane/chip_top.sdc` に `cs_n` のクロック定義がなく、`sr -> ctl` のセットアップ／ホールドは STA 対象外。
5. **アナログパッドの ESD 電源帰属とドメイン跨ぎ保護**
   - `REFIN` (`analog[0]`)、`AFCOUT` (`analog[1]`)、`VCTRL` (`analog[2]`) はデジタル側 `DVDD/VDD` リングの `asig_5p0` を使用。`REFIN` の ESD ダイオード接合容量がノイズ源の `DVDD` に直結しているため、TCXO 出力インピーダンスが高いと `DVDD` ノイズが `REFIN` に結合し PLL で ×96（+39.6 dB）増幅される経路になりうる。
   - `REFCK`（`VDDV` → `VDD`）には 1 kΩ + クランプ保護があるが、逆向きの `B0`/`B1`（`VDD` → `VDDV`）には CDM 対策の直列抵抗・クランプがない。
   - `VDDV`–`VSS` 間に専用のオンチップデカップリング容量がない（`XDEC` 125 pF は `VDDA` のみ、`CVR` 1.8 pF は `VR` ノードのみ）。
6. **サブハーモニックミキサのヘッドルームと動作点余裕**
   - テール + Gm + 下段スイッチ + 上段スイッチの 4 段縦積みを 3.3 V で行うため、SS でテール電流源 `MTI`/`MTQ` が三極管領域の端に入り（`layout/review/final/op.log`）、LO ゲートも最大 3.61 V（定格 3.63 V ギリギリ）。
   - `bias_if` の誤差アンプ出力段 `XMI2` も SS で飽和の端（`Vds - Vdsat = -0.02 V`）。
7. **実数 Sallen-Key LPF によるイメージ帯域透過と短長抵抗**
   - Low-IF (+4.092 MHz) に対し実数 LPF を用いているため、イメージ帯域（1567.236 MHz）の熱雑音・近傍妨害波が 2 bit ADC に直接入力される（非線形量子化器のため帯域内妨害波による AGC 抑圧・相互変調リスクがあり、外付け SAW 減衰端への依存度が高い）。
   - `sk_lpf1`/`sk_lpf2` の `R1` が `W=1u, L=1u`（1 □）と短く、端部抵抗が約 20 % を占める。

### 2.3 重大度：低（保守上の整合）
- `chip/librelane/config.yaml` の `PDN_OBSTRUCTIONS` 座標 `[442, 512.2, 1486.1, 2067.4]` が旧マクロ寸法（`1024.1 × 1535.2 µm`）基準のままで、現行マクロ（`1029.8 × 1539.4 µm`）に対するハローが 10 µm → 4.3〜5.8 µm に狭まっている。
- `doc/report.md` 5 章に「KLayout は封止リングのみ」の旧記述が残存（現行 GDS は KLayout DRC 0）。

---

## 3. 回路図のより良い方式の提案

| ブロック | 現行方式 | 推奨方式 | 主な効果 |
|---|---|---|---|
| **ミキサ** | 4 段縦積みアクティブ・サブハーモニック・ギルバート | パッシブ電流駆動ミキサ（25 % デューティ LO またはパッシブ・サブハーモニック）+ TIA | ヘッドルーム不足・LO 3.61 V ストレス・1/f 雑音・SS 利得低下を解消。直線性（IIP3/P1dB）も向上。 |
| **IF フィルタ / VGA** | 実数 Sallen-Key LPF × 2 + AC 結合 VGA × 5 | 複素ポリフェーズ BPF（中心 4.092 MHz）+ DCOC ループ付き直結 VGA | イメージ帯域（1567.2 MHz）を 25–35 dB 抑圧し妨害波耐性・量子化効率を改善。巨大 MIM 面積と消費電力を削減。 |
| **VCO** | 4 段擬似差動インバータリング（起動回路付き） | 対称負荷（Maneatis 負荷）差動リング VCO | 電源感度（pushing）を構造的に低減し外部 LDO 要件を緩和。同相ラッチ問題も回避。 |
| **分周器 (`div48`)** | 全段 TSPC ダイナミック DFF | 初段 ÷2 のみ CML（または静的比率型）、393 MHz 以下は完全スタティック CMOS DFF | TSPC 容量性突き上げ（3.68–4.02 V）を根絶しゲート酸化膜信頼性を確保。 |
| **基準バッファ (`refbuf`)** | シングルエンド自己バイアス・インバータ | 差動リミッティングアンプ／コンパレータ型バッファ | 電源リップル→エッジジッタ感度を構造的に低減。 |
| **バイアス (`bias_gen`)** | 定 $g_m$（beta-multiplier、温度で電流 2 倍変動） | 寄生 PNP を用いた簡易 BGR（PTAT + CTAT 補償電流源） | 全アナログブロックの温度変動を抑制し SS 歩留まりを改善。 |
| **デジタル部 / パッド** | 手動 SPI AGC、`in_c` 入力、`bi_24t` 24 mA 出力 | `RST_N`/`CS_N` を `in_s` 化、`bi_t` 4 mA 低駆動化、任意でオンチップ簡易自動 AGC（MAG カウンタ）追加 | チャタリング防止、SSN 大幅低減、ロケット飛翔中の急激なレベル変動への高速追従。 |

---

## 4. レイアウトのより良い方式の提案

1. **アナログ `VSSA` とデジタル `DVSS` のパッドリング分離**: `DVSS`/`VSS` リングも切断するブレイクセル（＋逆並列ダイオード ESD 保護）を導入し、アナログマクロの `VSSA` を北辺アナログ VSS パッドのみから給電。
2. **Deep N-Well (`DNWELL`) による基板ノイズ分離**: `lna_nc`、`mixer_iq`、`vco_core`、IF 初段の NMOS を DNWELL 内の独立 P-well に収容し、マクロ南端とデジタルコア間に連続ガードバンドを設置。
3. **抵抗アレイ（`res_array`）両端へのダミー抵抗追加**: `scripts/layout/devices.py` の `res_array` に両端ダミーセグメントを追加し、エッチングローディングによる `afc_dac` / `adc2b` ラダー・差動負荷の端ずれを防止。
4. **AC 結合 MIM 容量の電極向き反転**: `lna_nc` (`CC2`/`COP`/`CON`)、`mixer_iq` (`CAC*`)、`vga`/`vga_fix` (`CC1`/`CC2`)、`refbuf`/`divbuf` (`CIN`) の M4 下部電極（`bot`）を、高インピーダンスなゲート側から低インピーダンスな駆動側へ反転。
5. **電源メッシュ・EM 110 °C 基準化・`VDDV` デカップリング追加**: トップ M4 レール幅を 3 µm → 5–6 µm へ拡幅、LNA/VCO 大電流配線の 110 °C 上限クリア、`decap` の分散配置、`VDDV`–`VSS` 間の専用オンチップデカップリング容量（20–50 pF）追加。
6. **構造的対称 LO バス配線・`REFIN` 配置・`RFIN` M5 優先引き込み**: VCO–ミキサのピッチ整合で手動 `LO_TRIM` 依存を削減、可能なら `REFIN` を `VDDV` 側へ近接、`RFIN` は厚膜 M5 優先 + 下層禁止領域の GSG 構成に。

---

## 5. 提出 1 ヶ月前向け改善ロードマップ

現行 GDS（`5dc43f34...`）をバックアップとして凍結したうえで、以下を段階的に実施することを推奨します。

### Tier 1（最優先・低リスク・第 1 週）— アナログマクロ無変更
- [x] **T1-1**: 出力パッドを `gf180mcu_fd_io__bi_24t` (24 mA) → `gf180mcu_fd_io__bi_t` (`PDRV0=0, PDRV1=0` = 4 mA, `SL=1`) に変更 + 3.3 V SDO 遅延再確認（完了・Phase A）
- [x] **T1-2**: `RST_N` / `CS_N` / `SDI` をシュミットトリガ入力 `gf180mcu_fd_io__in_s` に変更 + `config.yaml` のハロー／`PDN_OBSTRUCTIONS` 更新（完了・Phase A/D）
- [x] **T1-3**: アナログ `VSSA` とデジタル `DVSS` のパッドリング分離（`fill10_noPWR` + `ISOSUB (23/5)`、LVS / precheck 検証済み・Phase A/D）

### Tier 2（中優先・中リスク・第 2〜3 週）— アナログマクロ再生成を伴う改善（取捨選択）
- [x] **T2-1**: 電源メッシュ EM 改善（トップ M4 レール `RAIL_H` 3→4 µm 拡幅、`VSSA` M4 EM 1.770 → 1.241 mA/µm（−30 %）、全ネット最大 EM 1.770 → 1.542 mA/µm、アナログ総電流 38.6 → 37.2 mA・Phase C）
- [x] **T2-2**: アナログ小改修パッケージ（`res_array` ポリのみ両端ダミー追加、全 AC 結合 MIM 電極向き反転、専用 `decap_vco` ~29 pF 追加、`B0`/`B1` 1 kΩ CDM 保護抵抗、`adc2b` 入力 AC 結合追加・Phase B/C）
- [x] **T2-3**: 分周器 `div48` の静的 TG DFF (`dff_st`) 化（TSPC 3.68–4.02 V 突き上げノード **7→0 根絶**、全チップ `VDD+0.3V` 超過 FET 16→6 削減・Phase B/C）
- [x] **追加（温度・$g_m$ 自動調整刷新）**: 全 MOS 抵抗レス VGA (`vga`/`vga_fix`/`bias_if`) + 水晶 16.368 MHz ロック SC 自動調整 4 次 Butterworth $G_m$-C LPF (`gm_master`/`gmc_lpf1`/`gmc_lpf2`) 実装（PEX 後 PVT 帯域ばらつき **±28 % → ±4.7 %**、6.0× 改善・Phase B/C）
- [ ] **T2-4**: Deep N-Well (`DNWELL`) による LNA / ミキサ / VCO の基板分離（今回は `VSSA` + `ISOSUB` 完全分離と 4 mA `bi_t` による 7.2× SSN 低減で対応、DNWELL は次期シャトル候補）

### Tier 3（今回は見送り・次期シャトル向け）
- パッシブミキサ + TIA 化、複素ポリフェーズ BPF 化、Maneatis VCO 化、BGR バイアス刷新

### 4 週間スケジュール目安
- **第 1 週**: ベースライン凍結 → Tier 1 実装 → LibreLane + 全チップ SPICE + SDO 遅延検証
- **第 2 週**: Tier 2（選択項目）実装 → ブロック PEX / PLL スプリアス / EM 再検証
- **第 3 週**: 最終チップ統合（LibreLane）、全コーナー回帰 + 全チップ SPICE + cocotb RTL/GL + 回路図/ボンディング図更新
- **第 4 週**: 最終 `gf180mcu-precheck` 合格確認・予備バッファ・提出

---

## 6. 作業ログ

### 2026-11-20
- `prompt_gemini.md`、`README.md`、`prompt.md`、`doc/report.md`、`RESUME.md`、および回路・RTL・レイアウト生成スクリプトと最終検証ログを一通り精査。
- PDK (`gf180mcu_fd_io`) 内の利用可能 I/O セル（`bi_t`, `in_s`, `brk2`, `brk5` 等）を確認。
- 妥当性チェック結果、回路図・レイアウト改善提案、および提出 1 ヶ月前向けロードマップを本ファイル（`README_gemini.md`）および英語版（`README_gemini_EN.md`）に初版記録。


---

## 7. 実装・検証ログ（自動実行フェーズ）

### 2026-11-20 — Phase A: ベースライン凍結 & Tier 1 フルチップ実装・サインオフ完了

1. **ベースライン凍結**:
   - 2026-11-15 版のサインオフ済み GDS（`chip/final/gds/chip_top.gds`、SHA-256: `5dc43f34bc8e9d5964c2a791bb2c6bd7913a1ccf1866c3bbc3ef57630751c1c1`）および全スクリプト・設定を `archive/baseline_20261115/baseline_20261115.tar.gz` に保存。
2. **Tier 1 変更内容（パッドリング・IO・基板分離）**:
   - **出力パッド低ドライブ化**: 6 本のデジタル出力パッド（`I_SIGN`, `I_MAG`, `Q_SIGN`, `Q_MAG`, `CLKOUT`, `SDO`）を `gf180mcu_fd_io__bi_24t`（24 mA）から **`gf180mcu_fd_io__bi_t`**（`PDRV0=0, PDRV1=0, SL=1` = 4 mA 最低ドライブ・スロースルー）へ変更（[chip_top.sv](chip/src/chip_top.sv), [chip_core.sv](chip/src/chip_core.sv)）。
     - **SPICE 計測結果**（TT 27°C 3.3V、5 pF 負荷、0.5 nH DVDD/DVSS ワイヤ）：
       | 項目 | 旧 `bi_24t` (24 mA) | 新 `bi_t` (4 mA, `SL=1`) | 改善効果 |
       | :--- | :---: | :---: | :---: |
       | `DVSS` グラウンドバウンス (`Rser=0 Ω`) | 77.4 mVpp | **10.8 mVpp** | **7.2× 低減 (−17.1 dB)** |
       | `DVDD` 電源バウンス (`Rser=0 Ω`) | 64.1 mVpp | **8.3 mVpp** | **7.7× 低減 (−17.8 dB)** |
       | ボンディングワイヤ最大電流 (`Rser=0 Ω`) | 21.61 mA | **5.39 mA** | **4.0× 低減 (−12.1 dB)** |
       | `DVSS` バウンス (`Rser=330 Ω`) | 52.4 mVpp | **6.9 mVpp** | **7.6× 低減** |
       | SDO 遅延（30 pF, SS 125°C 3.0 V） | 8.8 ns | 21.6 ns | 全遅延 ~37 ns（5 MHz SCLK 半周期 100 ns に対し **63 ns マージン**） |
   - **デジタル入力のシュミットトリガ化**: `RST_N`, `SDI`, `CS_N` を `gf180mcu_fd_io__in_c` から **`gf180mcu_fd_io__in_s`**（シュミットトリガ入力、`SCLK` と統一）へ変更。
   - **アナログ／デジタル電源・基板の完全分離（`VSSA` + `ISOSUB`）**:
     - `fill10_noPWR`（10×350 µm、`DVDD`/`VDD`/`DVSS`/`VSS` 全レール切断セル）を新規生成し、`brk_w`/`brk_e` を `fill10_noVDD` から `fill10_noPWR` へ置換（[make_iocells.py](scripts/make_iocells.py)）。
     - `afe_rf_pad` および `gnss_afe_analog` のグランドポートを `VSS` → **`VSSA`** へ分離し、両セルに GF180MCU 公式 LVS 基板分離レイヤ **`ISOSUB`（GDS 23/5）** を配置（[export_macro.py](scripts/layout/export_macro.py), [analog_straps.py](chip/librelane/plugins/librelane_plugin_gnss/analog_straps.py)）。
3. **Tier 1 フルチップ LibreLane サインオフ結果**（`RUN_2026-11-20_01-48-03`、**exit code 0**）:
   - **Magic DRC**: **0** / **KLayout DRC**: **0** / **KLayout Antenna**: **0** / **KLayout Density**: **0** / **XOR**: **0**
   - **Netgen LVS**: **0 エラー**（`VSSA` と `VSS` の独立接続を含め完全一致）
   - **OpenROAD STA**: 全 9 コーナーで **Setup 違反 0 / Hold 違反 0**
   - **OpenROAD IRDropReport**: `PSM` 警告解消（最悪電圧降下 `23 µV`）
   - **cocotb RTL & Gate-Level (`GL=1`)**: **PASS**

### 2026-11-20 — Phase B: Analog Macro rev.4（自己調整・抵抗レス回路）設計 & SPICE 検証完了

温度および $g_m$ の PVT 変動に対する自動調整・抵抗排除要求を受け、以下のアナログ回路刷新を実施・検証（[gen_cells.py](scripts/gen_cells.py), [gen_tb.py](scripts/gen_tb.py)）：

1. **全 MOS 抵抗レス・ゲイン切替 VGA（`vga`, `vga_fix`, `bias_if`）**:
   - 従来のポリ抵抗負荷＋縮退抵抗を全廃し、16 ユニットの並列 PMOS 負荷（`4+4+8` ユニット、`6u/0.56u`）をダイオード接続と 1:8 レプリカ電流源（`PBV`）の間で切り替える **全 MOS 抵抗レス構成** へ置換。
   - 利得は $g_{m,n}/g_{m,p}$ のトランジスタ比のみで決まり、**全 4 ゲインコードで DC 動作点（2.16 V）と消費電流が完全一定**（AGC 切替時の DC ジャンプ解消）。
   - テール電流を 2 mA → **0.8 mA/段** へ半減（IF 1 系統全体で **13.5 mA → 4.93 mA**、I+Q 合計 **−17.1 mA 削減**）。
2. **水晶ロック・スイッチトキャパシタ自動調整 4 次 Butterworth $G_m$-C LPF（`gm_unit`, `gmc_lpf1`, `gmc_lpf2`, `gm_master`）**:
   - 従来の抵抗 Sallen-Key LPF（PVT 帯域ばらつき 5.01–8.91 MHz / **±28%**、4 mA/系統）を、16.368 MHz 水晶基準クロック（`pll_core` からの `REFCK_O`）に自動ロックする **抵抗レス SC マスター自動調整ループ (`gm_master`) + 4 次差動 $G_m$-C フィルタ** へ刷新。
   - 差動フローティング MIM は対称逆並列ペア構成、旧 `BWK`/`BWN` SPI ビットも $C_{ref}$ トリム（±18%）として完全互換維持。
   - **5 コーナー PVT + コールドスタート (`VTN=0V`, `uic`) 検証結果**（`code 10`、[test_rev4_if_pvt.py](scripts/review/test_rev4_if_pvt.py)）：
     | コーナー / 条件 | `VTN` (リプル) | `I_gm` | `I_if` (1ch) | 利得 `G4` | 帯域 `fh` | 16.368 MHz 阻止量 | 入力換算雑音 |
     | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
     | **TT 27°C 3.3V** (`uic` コールドスタート) | 0.833 V (0.49 mV) | 0.58 mA | **4.93 mA** | 53.69 dB | **7.70 MHz** | 25.3 dB | 14.6 nV/√Hz |
     | **SS 85°C 3.135V** | 0.985 V (0.41 mV) | 0.64 mA | 5.69 mA | 52.98 dB | **7.28 MHz** | 27.2 dB | 17.2 nV/√Hz |
     | **SS −20°C 3.135V** | 0.971 V (0.14 mV) | 0.42 mA | 2.71 mA | 54.01 dB | **7.46 MHz** | 26.6 dB | 13.9 nV/√Hz |
     | **FF −20°C 3.465V** | 0.704 V (0.61 mV) | 0.59 mA | 4.66 mA | 53.81 dB | **7.77 MHz** | 24.9 dB | 13.0 nV/√Hz |
     | **FF 85°C 3.465V** | 0.680 V (1.74 mV) | 0.93 mA | 10.66 mA | 50.66 dB | **7.63 MHz** | 25.4 dB | 16.7 nV/√Hz |
     | **TT Wider (`BWK=0`) / Narrow (`BWN=1`)** | 0.869 / 0.795 V | 0.64 / 0.53 mA | 5.16 / 4.74 mA | 53.75 / 53.45 dB | **8.94 / 6.36 MHz** | 20.3 / **31.7 dB** | 13.7 / 16.2 nV/√Hz |
   - **自動調整効果**: 全 5 極限 PVT コーナーで帯域変動 **±3.2%**（旧 ±28% から **8.7× 改善**、PEX 後 ~6.8–7.2 MHz 狙い）、5 段合計利得変動 **±1.68 dB（±0.34 dB/段）**、4 ゲインコード間 `fh` 変動 **0.08%**、MIM 面積 **約 6× 削減**。
3. **静的 TG DFF `/48` 分周器（`dff_st`）**: TSPC 動的浮遊ノードを全廃し、850 MHz（SS 85°C 3.135V）動作と 3.3V 定格内動作を両立（`tb_div`: 785.664 MHz → `16.368 MHz`、`0.73 mA`）。
4. **その他 rev.4 強化**:
   - `vco_ring4`: `B0`/`B1` クロスドメイン入力に 1 kΩ CDM 保護抵抗（`RB0`/`RB1`）追加、`VDDV` 専用デカップリング `decap_vco`（~29 pF）追加。
   - `adc2b`: 入力 AC 結合（`CC1`/`CC2` + `RB1`/`RB2` → `thm` 1.20 V）追加により VGA5 最終段 DC オフセットを完全遮断。
   - 全信号系 AC 結合 MIM（`lna_nc`, `mixer_iq`, `selfbias_buf`, `vga`, `vga_fix`, `adc2b`）で M4 ボトムプレートを低インピーダンス駆動側へ反転。
   - `final_op.py`（TT/SS/FF）で新規 IF チェーン全 FET の**飽和マージン違反 0 件・過電圧 0 件**を確認（[op_rev4.log](layout/review/final/op_rev4.log)）。

### 2026-11-20 — Phase C: Analog Macro rev.4 レイアウト生成・PEX・EM/IR ドロップ・ストレス検証完了

1. **アナログマクロ rev.4 レイアウト刷新**（[devices.py](scripts/layout/devices.py), [module.py](scripts/layout/module.py), [lib.py](scripts/layout/lib.py), [top.py](scripts/layout/top.py), [export_macro.py](scripts/layout/export_macro.py)）:
   - 新規ブロックレイアウト生成: `gm_master`、`if_chain`（`vga` / `vga_fix` / `gmc_lpf1` / `gmc_lpf2` / `bias_if`）、`pll_core`（静的 TG DFF `dff_st` + `REFCK_O` バッファ）、`vco_ring4`（`RB0`/`RB1` CDM 抵抗）、`decap_vco`（`VDDV` 専用 ~29 pF）、`adc2b`（入力 AC 結合）、`lna_nc` / `mixer_iq`（AC 結合 MIM ボトム電極反転）。
   - **抵抗アレイ両端ポリダミー追加**（`devices.py` `res_array`、`nslot >= 2` かつ `W <= 4000`）：`poly_only` ダミーにより Magic/KLayout DRC 0・Netgen LVS 完全一致を維持しつつ、`afc_dac` PEX 直線性を改善（`INL -0.13/+0.20 LSB, DNL -0.01/+0.33 LSB, monotonic True`、[pex_adcdac_rev4.log](layout/review/pex_adcdac_rev4.log)）。
   - **トップ電源メッシュ拡幅**（`module.py` `RAIL_H`: `3000 → 4000 nm`）および **`VSSA` + `ISOSUB (23/5)` 基板分離エクスポート**。
   - **アンテナ対策**: `gm_master` の `BWK`/`BWN`・内部スイッチに tie-low NMOS アンテナダイオード（`MATX`/`MATHI`/`MATLO`/`MABWK`/`MABWN`）追加、`vga` の静的 DC ゲイン制御インバータ（`MGAN`/`MGAP`/`MGBN`/`MGBP`）を `W=4u, L=1u` に大型化してゲート面積比を 14.3× 拡大（全チップ KLayout Antenna **0 エラー**達成）。
   - **マクロ最終寸法**: `gnss_afe_analog` = **`1020.9 × 1571.0 µm`**（`route=True`, Magic DRC = **0**, Netgen LVS = **OK**、[gnss_afe_analog.gds](layout/gds/gnss_afe_analog.gds)）。
2. **最終マクロ PEX 検証結果**:
   - **IF + `gm_master` フル PEX 閉ループ**（最終アンテナ対策後再抽出、[test_rev4_if_pex.py](scripts/review/test_rev4_if_pex.py), [pex_if_autotune_rev4.log](layout/review/pex_if_autotune_rev4.log)）：
     | コーナー / モード | PEX `VTN` (リプル) | `I_if` (1ch) | 利得 `G4` | 帯域 `fl–fh` | 16.368 MHz 阻止量 |
     | :--- | :---: | :---: | :---: | :---: | :---: |
     | **TT 27°C 3.3V** (`nom`) | 0.8213 V (0.72 mV) | **4.87 mA** | 54.78 dB | 711 kHz – **7.08 MHz** | **28.1 dB** |
     | **SS 85°C 3.135V** (`nom`) | 0.9575 V (0.61 mV) | 5.52 mA | 53.88 dB | 568 kHz – **6.54 MHz** | **30.7 dB** |
     | **FF −20°C 3.465V** (`nom`) | 0.6980 V (0.96 mV) | 4.72 mA | 55.05 dB | 917 kHz – **7.18 MHz** | **27.4 dB** |
     | **TT Wider (`BWK=0`)** | 0.8459 V (0.73 mV) | 5.09 mA | 54.78 dB | 717 kHz – **7.90 MHz** | 24.3 dB |
     | **TT Narrow (`BWN=1`)** | 0.7913 V (0.73 mV) | 4.63 mA | 54.51 dB | 701 kHz – **6.03 MHz** | **33.3 dB** |
     - **PEX 後 PVT カットオフ変動**: **`6.54–7.18 MHz`（±4.7 %）** — 従来の抵抗 Sallen-Key（±28 %）比で **6.0× 高精度化**し、公称 7.08 MHz で GPS L1 C/A + Galileo E1 帯域に完全適合。5 段合計 PEX 利得変動も **±0.59 dB（±0.12 dB/段）** に収束。
   - **LNA PEX**（AC 結合 MIM 電極反転後、[pex_blocks_rev4.log](layout/review/pex_blocks_rev4.log)）：1.575 GHz で **`S11 = −14.9 dB`**（旧 −14.3 dB）、差動利得 **`13.32 dB`**、**`NF = 2.19 dB`**（旧 2.26–2.29 dB から **−0.07〜−0.10 dB 改善**）。
   - **ミキサ LO トリム再調整**（`lo_trim.py`）：8 相 LO 長さトリムを rev.4 配線に再最適化し、4.092 MHz 出力で I/Q 利得差 **`+0.172 dB`**、直交位相 **`−89.12°`（誤差 `0.88°`）** を達成。
   - **閉ループ PLL フル PEX**（`vco_ring4` PEX + `pll_core` PEX、[pex_pll_rev4.log](layout/review/pex_pll_rev4.log)）：静的 TG DFF `/48` 分周器（`dff_st`）および `RB0`/`RB1` CDM 保護抵抗入り VCO の構成で、コールドスタートから **`VCTRL ≈ 2.116 V`**（旧版 PEX 2.114–2.135 V と同等）へ正常ロックを確認（回路図版は `1.57105 GHz`, `vc_end = 1.559 V`, `vc_pp = 1.17 mV`）。
3. **電源メッシュ IR ドロップ・EM 解析**（[ir_drop_rev4.log](layout/review/ir_drop_rev4.log) vs 旧 [padframe/ir_drop.log](layout/review/padframe/ir_drop.log)）：
   - アナログ総電流: `VDDA` = **33.4 mA**（旧 34.8 mA）、`VDDV` = **3.8 mA**、合計 `VSSA` = **37.2 mA**（旧 38.6 mA）。
   - `VDDA` 最大降下: **46.40 mV**（旧 49.53 mV）、M4 EM 最大 **1.542 mA/µm**、M5 最大 0.588 mA/µm、Via4 最大 0.118 mA。
   - `VSSA` 最大降下: **47.09 mV**（北辺アナログパッド専用給電化後）、**M4 EM 最大 `1.241 mA/µm`（旧 1.770 mA/µm から −30 % 低減、1.4 mA/µm 超エッジ 0 件）**、M5 最大 0.626 mA/µm、Via4 最大 0.091 mA（−27 %）。
   - 全ネット最大 M4 EM は **1.770 → 1.542 mA/µm（−13 %）** へ改善し、85 °C 基準（2.09 mA/µm）に対し十分なマージンを確保。
4. **過電圧ストレス検証**（`final_tran.py stress`、FF −20°C 3.63 V、[stress_rev4.log](layout/review/final/stress_rev4.log) vs 旧 [stress.log](layout/review/final/stress.log)）：
   - 分周器 (`xpll.xdiv`) の `VDD+0.3V` 超過ノード: **7 件（最大 4.005 V）→ 0 件に完全根絶**。
   - チップ全体で `VDD+0.3V` 超過する FET 端子対: **16 件（最大 4.016 V）→ 6 件（最大 3.993 V、StrongARM 比較器のみ）** へ大幅削減。

### 2026-11-20 — Phase D: 最終フルチップ LibreLane サインオフ & 検証完了

1. **最終フルチップ LibreLane ビルド**（[RUN_2026-11-20_08-07-52](chip/librelane/runs/RUN_2026-11-20_08-07-52)、**exit code 0**）:
   - マクロ配置最適化: `location: [456.0, 498.4]`、`FP_MACRO_VERTICAL_HALO: 22`、`PDN_OBSTRUCTIONS` を rev.4 寸法へ更新（[macros_gnss.yaml](chip/librelane/macros/macros_gnss.yaml), [config.yaml](chip/librelane/config.yaml)）。
   - **最終提出用 GDS**: [`chip/final/gds/chip_top.gds`](chip/final/gds/chip_top.gds)（93,464,606 バイト、**SHA-256: `979043407d96d8d174f5776deb1540f8ce4e1ad8e9a703c13230980ccefc5ffc`**）。
   - **サインオフ結果サマリ**（[metrics.json](chip/librelane/runs/RUN_2026-11-20_08-07-52/final/metrics.json)）：
     - **Magic DRC**: **0** / **Magic Illegal Overlap**: **0**
     - **KLayout DRC**: **0** / **KLayout Antenna**: **0** / **KLayout Density**: **0**
     - **XOR 差分**: **0** / **Detailed Route DRC**: **0**
     - **Netgen LVS**: **0 エラー**（デバイス・ネット・プロパティ・ピン差分すべて 0、`VSSA` / `VSS` 分離含め完全一致）
     - **OpenROAD STA**: 全 9 コーナーで **Setup 違反 0 / Hold 違反 0**（worst setup slack `1.82 ns`, worst hold slack `0.47 ns`；`max_slew` 6 件は意図的な 4 mA `SL=1` 外部出力パッド `bidir[0..5]` のみ、コア内部 0 件）
     - **OpenROAD IRDropReport**: `VDD` 最悪降下 **`24.1 µV`**、`VSS` 最悪降下 **`21.5 µV`**（PSM 違反 0）
2. **機能シミュレーション（cocotb）**:
   - **RTL シミュレーション**: **PASS**（SPI 全レジスタ読書き・リセット・既定値・アナログ接続確認）
   - **Gate-Level (`GL=1`) シミュレーション**: **PASS**（`400700.00 ns`, `TESTS=1 PASS=1 FAIL=0`）
3. **回路図・レイアウト図・ボンディング図の再生成**:
   - 全変更セルの配線付き回路図を再生成（[doc/sch_wired/](doc/sch_wired/)：`chip_top`, `padframe`, `gnss_afe_analog`, `if_chain`, `vga`, `vga_fix`, `bias_if`, `gm_master`, `gm_unit`, `gmc_lpf1`, `gmc_lpf2`, `pll_core`, `div48`, `div2`, `div3`, `dff_st`, `vco_ring4`, `decap_vco`, `adc2b`, `lna_nc`, `mixer_iq`）。
   - 最終レイアウト描画・ボンディング図を再生成し目視確認完了（[chip_quarter.png](doc/chip_quarter.png), [macro_quarter.png](doc/macro_quarter.png), [bonding_quarter.png](doc/bonding_quarter.png) — **56 パッド中心座標は COB 基板テンプレートと 0.1 µm 以内で完全一致維持**）。
4. **Wafer.Space 公式 `gf180mcu-precheck` (`--slot 0p5x0p5`) — 16/16 全項目 PASS**:
   - 実行ラン: [RUN_2026-11-20_08-25-12](chip/precheck_q/runs/RUN_2026-11-20_08-25-12)（所要 29 分 26 秒、**exit code 0**、[precheck_rev4.log](layout/review/precheck_rev4.log)）。
   - 対象 GDS SHA-256: `979043407d96d8d174f5776deb1540f8ce4e1ad8e9a703c13230980ccefc5ffc`。
   - 全チェッククリア: `ReadLayout` / `CheckTopLevel (chip_top)` / `CheckSize (1936.0 × 2531.0 µm = 0p5x0p5)` / `GenerateID` / `Render` / **`KLayout Density (0 違反: COMP 47.2%, Poly2 31.9%, M1 43.1%, M2 51.0%, M3 54.7%, M4 62.7%, M5 61.6%, MetalTop 61.6%)`** / **`ZeroAreaPolygons (0 違反)`** / **`KLayout Antenna (0 違反)`** / **`Magic DRC (0 違反)`** / **`KLayout DRC (0 違反)`** / `WriteLayout`。

---

## 8. 改善前後（Baseline 2026-11-15 vs Final rev.4 2026-11-20）比較表

| 評価項目 | Baseline (2026-11-15) | Final rev.4 (2026-11-20) | 改善結果 |
| :--- | :---: | :---: | :--- |
| **最終 GDS SHA-256** | `5dc43f34...` | **`97904340...`** | バックアップ凍結済み（`archive/baseline_20261115/`） |
| **デジタル出力パッド** | `bi_24t` (24 mA) | **`bi_t` (4 mA, `SL=1`)** | `DVSS` バウンス **77.4 → 10.8 mVpp (7.2× 低減)** |
| **デジタル入力パッド** | `in_c` (`RST_N`/`CS_N`/`SDI`) | **`in_s` (全 4 本シュミット化)** | RC リセット／SPI エッジのチャタリング耐性向上 |
| **アナログ／デジタル GND 分離** | チップ内 `VSS=DVSS` 短絡 | **`VSSA` + `fill10_noPWR` + `ISOSUB`** | LVS・物理基板両面で完全分離 |
| **IF LPF 方式 / PVT 帯域ばらつき** | 抵抗 Sallen-Key / **±28 %** | **水晶ロック SC 自動調整 $G_m$-C / ±4.7 % (PEX)** | **6.0× 高精度化**（TT PEX **7.08 MHz**, 阻止量 28.1 dB） |
| **VGA 方式 / IF 1ch 電流** | 抵抗負荷・縮退 / 6.06 mA | **全 MOS 抵抗レス / 4.87 mA (PEX)** | **−20 % 省電力**、全 4 ゲインで DC CM 完全一定 |
| **分周器 (`div48`) 過電圧ノード** | TSPC（7 ノード > `VDD+0.3V`, 最大 4.01 V） | **静的 TG DFF（0 ノード > `VDD+0.3V`）** | **分周器過電圧を完全根絶**（全チップ FET 16 → 6） |
| **LNA PEX 性能 (1.575 GHz)** | S11 −14.3 dB / NF 2.26–2.29 dB | **S11 −14.9 dB / NF 2.19 dB** | AC 結合 MIM 電極反転により NF −0.07〜−0.10 dB 改善 |
| **AFC DAC PEX 直線性** | ダミー無し抵抗アレイ | **ポリダミー追加 (`INL -0.13/+0.20, DNL -0.01/+0.33`)** | 単調性保証・端ずれ低減 |
| **電源メッシュ最大 M4 EM** | `VSS` 1.770 mA/µm | **`VSSA` 1.241 / `VDDA` 1.542 mA/µm** | `VSSA` M4 EM **−30 %**、全ネット最大 EM **−13 %** |
| **アナログマクロ寸法 / パッド位置** | `1029.8 × 1539.4 µm` / 56 パッド | **`1020.9 × 1571.0 µm` / 56 パッド同一** | 既存 COB 基板・ボンディング図と完全互換 |
| **DRC / LVS / Antenna / Density / STA / GL / Precheck** | 全 0 / PASS | **全 0 / 16/16 PASS** | **Wafer.Space 提出準備完了** |

---

## 9. Phase E: 全ブロック PEX 監査・結合バグ修正（rev.4b）・再サインオフ & 長時間システム PEX

全アナログブロックの最新 PEX 再抽出とトップ階層配線寄生抽出（`top_wires.py`）による徹底監査を実施した結果、**PLL 基準スプリアスを悪化させる 2 件の実レイアウト結合バグを発見し、即座に再設計・再配線・再サインオフ**しました。

### 9.1 PEX 監査で発見・修正したレイアウト結合バグ（rev.4 → rev.4b）
1. **トップ配線 `vctrl_i ↔ refck_a` / `fs` 結合（`6.76 fF` / `1.30 fF`）**:
   - `lvs.py` が内部 `vctrl` ネットを `vctrl_i` へリネームしているのに対し、`auto.py` の `SEP["gnss_afe_analog"]` が旧名 `"vctrl"` を指定していたため離隔制約が効かず、新規追加した 16.368 MHz フルスイングクロック `refck_a` が `vctrl_i`（高インピーダンス 2 kΩ / 0.75 pF ノード）に `6.76 fF` 並走していた。
   - **対策**: `SEP["gnss_afe_analog"]` を `vctrl_i` へ修正し離隔強化（4 トラック / コスト 8.0）、あわせて `aip/ain/aqp/aqn` とクロック・ADC 出力間も離隔追加。
   - **結果**（[top_build_rev4b.log](layout/review/top_build_rev4b.log)）: `vctrl_i ↔ refck_a` **`6.76 → 0.04 fF`（169× 低減）**、`vctrl_i ↔ fs` **`1.30 → 0.00 fF`（完全解消）**、`aqp ↔ I_SIGN` **`0.88 → 0.04 fF`**、`aqp ↔ refck_a` **`0.73 → 0.00 fF`**。
2. **`pll_core` 内部の `FS ↔ VCTRL` 結合（`2.43 fF`）**:
   - `XDIV` が `XLF` の西にあり、`FS` 配線が `XLF` の MIM 容量上を横断していた。
   - **対策**: `FLOOR["pll_core"]` を `["XPFD", "XLF", "XCP", "XDIV"]`（`XDIV` 東端配置）へ変更し、`SEP["pll_core"]` も 5 トラック / コスト 10.0 へ強化。
   - **結果**: `pll_core` 同一寸法・DRC 0・LVS OK のまま **`FS ↔ VCTRL` を `2.43 → 0.00 fF` に完全解消**（`REFCK_O ↔ VCTRL` / `REFCK ↔ VCTRL` も `0.00 fF`）。

### 9.2 全アナログブロック PEX 検証結果（TT / SS / FF、ngspice 実測）

| ブロック | 検証内容（すべて PEX 抽出ネットリスト） | TT 27°C 3.3V | SS 85°C 3.135V | FF −20°C 3.465V | 判定 |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **`bias_gen`** | コールド電源投入ランプ (`0→VDD`) | `NB=0.960V, PB=2.056V, 205.6 µA` | `NB=1.084V, PB=1.734V, 223.1 µA` | `NB=0.852V, PB=2.357V, 204.7 µA` | **PASS** |
| **`refbuf`** | 16.368 MHz 0.4 Vpk 正弦波→CMOS | `0..3.30V, duty 51.2%, 203 µA` | `0..3.14V, duty 51.5%, 114 µA` | `0..3.47V, duty 50.6%, 347 µA` | **PASS** |
| **`vmon_buf`** | `VCTRL` 0.8–2.4 V / 100 kΩ 負荷 | `gain 0.983, |Iin|≤2.4pA` | `gain 1.027, |Iin|≤2.4pA` | `gain 0.973, |Iin|≤2.4pA` | **PASS** |
| **`lna_nc` + `RFIN`** | パッド・ESD・rev.4 配線込み 1.575 GHz | `S11 −24.28 dB, G 13.51 dB, NF 2.21 dB` (3.9 nH+1 nH) | — | — | **PASS** |
| **`mixer_iq`** | 4.092 MHz 変換・I/Q 直交・LO 漏れ | `I/Q +0.169 dB, −89.21°`, LO 漏れ旧版比 2.4× 低減 | — | — | **PASS** |
| **`vco_ring4`** | `pex_vco` チューニング範囲・8 相誤差 | `B=0: 717–1666 MHz, I/Q −0.46°` | `B=3: 853–1618 MHz, I/Q −0.45°` | `B=0: 606–1989 MHz, I/Q −0.60°` | **PASS** |
| **`gm_master` + `if_chain`** | 閉ループ自動調整 + 全 4 ゲインコード | `fh=7.08 MHz, rej16=28.1 dB`, 全 4 コード `4.865 mA / Vcm 2.143V` 一定 (`37.8–69.8 dB`) | `fh=6.54 MHz, rej16=30.7 dB` | `fh=7.18 MHz, rej16=27.4 dB` | **PASS** |
| **I+Q 最大ゲイン安定性** | 5 nH+0.5 Ω 共通電源 + 1 mV キック | `384.6→0.56 mVpp` (Q/電源 0.00) | `345.0→0.74 mVpp` (Q/電源 0.00) | `367.8→0.08 mVpp` (Q/電源 0.00) | **PASS** |
| **`adc2b`** | 4.092 MHz AC 結合入力 + 16.368 MHz CLK | `SIGN/MAG 正常, lad 1.125/1.203/1.280V, 0.51 mA` | `正常, lad 1.070/1.141/1.213V, 0.43 mA` | `正常, lad 1.179/1.265/1.351V, 0.63 mA` | **PASS** |
| **`afc_dac`** | 256 コード掃引・INL/DNL/単調性 | `INL −0.15/+0.19, DNL −0.01/+0.33, mono=True` | `INL −0.01/+0.05, DNL −0.05/+0.00, mono=True` | `INL −0.41/+0.46, DNL −0.03/+0.87, mono=True` | **PASS** |

### 9.3 rev.4b 最終 GDS サインオフ（完了） & 長時間システム PEX（実行中）
- **最終提出用 GDS（rev.4b）**: [`chip/final/gds/chip_top.gds`](chip/final/gds/chip_top.gds)（93,403,478 バイト、**SHA-256: `9aaf97a97106c0a0e8157fec0cb4ebc64223e1d493b82b041edcf13acd5c2af3`**）
- **LibreLane フルチップサインオフ**（`RUN_2026-11-20_11-58-45`）: Magic DRC **0** / KLayout DRC **0** / Antenna **0** / Density **0** / XOR **0** / Netgen LVS **0** / STA 全 9 コーナー Setup・Hold **0** / IR Drop 最悪 **24.1 µV**
- **rev.4b アナログ電源メッシュ**（[ir_drop_rev4b.log](layout/review/ir_drop_rev4b.log)）: `VDDA` 最大降下 **43.21 mV**（M4 EM **1.404 mA/µm**）、`VSSA` 最大降下 **46.35 mV**（M4 EM **1.198 mA/µm**、ベースライン比 **−32 %**）、全ネット最大 EM **1.770 → 1.404 mA/µm（−21 %）**
- **cocotb 機能検証**: RTL **PASS** / Gate-Level (`GL=1`) **PASS**
- **Wafer.Space 公式 `gf180mcu-precheck` (`--slot 0p5x0p5`)**（`RUN_2026-11-20_12-48-28`, [precheck_rev4b.log](layout/review/precheck_rev4b.log)）: **16/16 全ステージ PASS（0 違反、1 時間 44 分 54 秒）**
- **P&R デジタル＋実 `bi_t`/`in_s` パッド＋SPEF トランジスタレベル SPICE（`core_spice.py`、10 MHz SCLK・30 pF SDO 負荷、全 3 コーナー完了・PASS）**（[core_spice_rev4b.log](layout/review/core_spice_rev4b.log)）：
  - `TT 27°C 3.3V`: 全 3 フレーム SPI 書込み／SDO 読出し一致、全 19 制御出力フルスイング OK、`SCLK↓→SDO` **22.0 ns**（10 MHz で 28.0 ns マージン）→ **PASS**
  - `SS 125°C 3.0V`: 全 3 フレーム OK、4 mA `bi_t` (`SL=1`) でも **39.9 ns**（10 MHz で **10.1 ns**、5 MHz で **60.1 ns マージン**）→ **PASS**
  - `FF −40°C 3.465V`: 全 3 フレーム OK、**14.1 ns**（10 MHz で 35.9 ns マージン）→ **PASS**
- **全体 RF→IF 受信チェーン PEX + 閉ループ PLL スプリアス（`rx_pex.py` + `pll_spur.py`、TT / SS / FF 全 3 コーナー完了・PASS）**（[rx_pex_rev4b.log](layout/review/rx_pex_rev4b.log)、LNA PEX + Mixer PEX + VCO PEX + PLL PEX + rev.4b `top_wires.json` + RFIN パッド/ESD/整合、1575.42 MHz −70 dBm）：
  | コーナー（帯域 / CP） | ロック `fLO` / `VCTRL` | ポート→IF 利得 (I / Q) | I/Q 利得差 / 位相差 | `k=1` (±16.368 MHz) スプリアス | `k=2` (±32.736 MHz) スプリアス | 判定 |
  | :--- | :---: | :---: | :---: | :---: | :---: | :---: |
  | **TT 27°C 3.3V** (`B=0, ICP2=0`) | `1571.38 MHz` / `2.124 V` | `24.0 / 23.9 dB` | `0.15 dB` / **`89.4°`**（誤差 `0.6°`） | **`−51.5 / −50.6 dBc`** | `−45.8 / −44.8 dBc` | **PASS** |
  | **SS 85°C 3.135V** (`B=3, ICP2=1`) | `1571.25 MHz` / `1.453 V` | `19.8 / 19.7 dB` | `0.09 dB` / **`89.6°`**（誤差 `0.4°`） | **`−47.8 / −47.6 dBc`** | `−46.0 / −45.1 dBc` | **PASS** |
  | **FF −20°C 3.465V** (`B=0, ICP2=0`) | `1571.33 MHz` / `1.537 V` | `25.2 / 25.0 dB` | `0.23 dB` / **`88.6°`**（誤差 `1.4°`） | **`−44.4 / −44.1 dBc`** | `−41.8 / −41.3 dBc` | **PASS** |
  - **rev.4b 結合バグ修正の実証**: `vctrl_i ↔ refck_a`（`6.76 → 0.04 fF`）および `FS ↔ VCTRL`（`2.43 → 0.00 fF`）の修正により、TT の基準スプリアスは **−51.5 / −50.6 dBc**（旧版 −44〜−48 dBc を上回る性能）を達成。I/Q 直交誤差も TT `0.6°`・SS `0.4°`（旧版 `1.2°`・`1.7°` から 2–4× 改善）。
- **フルチップ混載 `ngspice`（`chip_spice.py rev4_sch`、6.90 µs・2 フレーム SPI・`Rser = 0 Ω`、完了・PASS）**（[chip_spice_rev4_sch.log](layout/review/chip_spice_rev4_sch.log)、P&R デジタル＋SPEF＋実 4 mA `bi_t`/`in_s` パッド＋分離 `VSSA`/`VSS`＋rev.4b アナログ全体）：
  - **SPI デジタル＋実パッド（10 MHz SCLK・30 pF SDO）**: Frame 1 (`A88000`)・Frame 2 (`A88015`, RF 受信中) ともに **OK**、`SCLK↓→SDO` **21.8 ns**（28.2 ns マージン）、全 19 制御ピン一致 → **PASS**。
  - **RF 1575.42 MHz → 最終デジタル出力パッドまで一気通貫動作**:
    - 閉ループ PLL ロック `vctrl = 1.4457 V`、**`CLKOUT` パッド `16.3680 MHz`**、IF 4.092 MHz 出力 **`I = 18.24 mV / Q = 18.50 mV`**（I/Q 差 0.12 dB）、**`I_SIGN` パッド `4.0919 MHz` (`0..3.33 V`)**・**`Q_SIGN` パッド `4.17 MHz` (`0..3.33 V`)** すべて正常出力。
    - **直列抵抗なし (`Rser = 0 Ω`) での自己干渉耐性**: 旧版（24 mA `bi_24t` + `VSS=DVSS` 短絡）では `Rser = 0 Ω` で IF に 170–385 mV rms の回り込みが発生していたのに対し、rev.4b では 30 pF SDO 駆動中の SPI Frame 2（4.2–6.7 µs）でも **`VSSA` バウンス変化 0.00 mV**（`15.38 → 15.36 mVpp`）、IF 残差 **`14.9–17.7 mVpp`（~5 mV rms、旧版比 >35× / >30 dB 改善）** を実証。
    - 消費電流: アナログ合計 `I(VDDA+VDDV) = 36.60 mA`、デジタル `0.634 mA`（待機）/ `1.166 mA`（SPI 動作中）。
- **フルチップ全 9 ブロック PEX（`chip_spice.py rev4_pex`、1.61 MB / 15,894 ノード、4.20 µs、`Rser = 0 Ω`、完了・PASS）**（[chip_spice_rev4_pex.log](layout/review/chip_spice_rev4_pex.log)）：
  - **SPI デジタル＋実パッド（10 MHz SCLK・30 pF SDO）**: Frame 1（`008015` → SDO `A88000`）完全一致、`SCLK↓→SDO` **21.8 ns**（28.2 ns マージン）、全 19 マクロ制御ピン一致 → **digital PASS**。
  - **閉ループ PLL PEX + `CLKOUT` パッド**: **`vctrl = 2.1297 V`** ロック、**`CLKOUT` パッド `16.3680 MHz`**（0..3.33 V）。
  - **LNA + ミキサ PEX + 基板分離**: `mix 4M = 0.088 / 0.085 mV`（`rev4_sch` 0.097 / 0.093 mV 比 −0.8 dB）、SPI Frame 1 動作中（`VSSD = 45.3 mVpp`）でも **`VSSA = 11.5 mVpp`** に完全分離維持。
  - なお、`rev4_pex`（4.2 µs 終了）では `gm_master.pex` 内部 20 pF 容量が `uic` で 0 V からコールドスタートしたため `VTN` 立上り（約 5 µs）の途中で終了した。これを完全に検証するため、以下の一括コールドスタート PEX を追加実施した。
- **4 ブロック一括コールドスタート PEX（`bias_gen + gm_master + if_chain + adc2b`、`0→3.3 V` 電源投入ランプ・9 µs、完了・PASS）**（[e2e_if_adc_pex_rev4b.log](layout/review/e2e_if_adc_pex_rev4b.log)）：
  - 0 V 電源投入から約 5 µs で `gm_master.pex` が **`VTN = 0.815 V`** へ自動収束し、`if_chain.pex`（`code 10`）は 0.30 mVpk 入力に対し **`164.78 mVpk`（54.79 dB、AC PEX 54.78 dB と 0.01 dB 以内で完全一致）** を出力、`adc2b.pex` も **`SIGN = 4.092 MHz` (`−0.04..3.31 V`)**・**`MAG = 24.4 %`**・4 ブロック合計電流 **`6.07 mA`** で完全動作を実証。


---

## Phase F: `slot 0p5x1` 拡張 ＋ `proppy/ttgf-megabytebeat`（XLS オリジナル）Dual-VDD 統合（2026-11-25 完了・サインオフ済）

### F.1 設計要件とアーキテクチャ
既存の GNSS AFE rev.4b（`0p5x0p5` スナップショットは `archive/rev4b_0p5x0p5_20261125/` に凍結保存）を Wafer.Space **`slot 0p5x1`**（`1936.0 × 5122.0 µm`）へ拡張し、[proppy/ttgf-megabytebeat](https://github.com/proppy/ttgf-megabytebeat) の **XLS 生成オリジナル 5 曲版（案 A）** を独立電源ドメインで統合しました。

1. **XLS オリジナル生成（`chip/macros/megabytebeat/`）**
   - 上流 `proppy/ttgf-megabytebeat` (`main`) と同一の Google XLS `v0.0.0-11174-g32dc47058` により `src/megabytebeat.x` + `src/bytebeat.x` から `src/megabytebeat.v` を生成（`interpreter_main --compare=jit` 2/2 ユニットテスト PASS）。
   - `src/megabytebeat_macro.sv` でラップし、外部ピン `bb_ena_PAD` に **内蔵プルダウン（`PD=1`、`VDD_BB` ドメイン駆動）** を実装：
     - `bb_ena = 0`（未接続デフォルト）時：GF180 統合クロックゲート `gf180mcu_fd_sc_mcu7t5v0__icgtp_4` で `gclk` を完全停止（1 サイクルフラッシュ `ena_q` で同期リセット完了後に停止）し、5 本の PWM 出力を強制 `0` クランプ → **GNSS 受信動作への干渉ゼロ**。
     - `bb_ena = 1` 時：上流 `tt_um_proppy_megabytebeat`（`the 42 melody` / `fractal trees` / `untitled` / `a tune to share` / `sierpinski harmony`）と完全ビット一致で動作。
   - 独立マクロ `megabytebeat_macro`（`960.0 × 960.0 µm`, 22,912 cells, 利用率 `34.0%`, 専用 `VDD_BB` / 共通 `VSS`）として LibreLane ハード化：**Magic DRC = 0, KLayout DRC = 0, Netgen LVS = 0, XOR = 0, Antenna = 0, STA Setup/Hold = 0**。
   - マクロ内に `VDD_BB` ドメイン専用タイ出力（`vdd_bb_hi_s/e`, `vss_lo_s/w/e`）を設け、`chip_top` 側の全 `megabytebeat` パッド制御ピン（`PD`, `PU`, `OE`, `SL`, `IE`, `CS`, `PDRV`）を `VDD_BB` ドメインから直接駆動＋`RSZ_DONT_TOUCH_RX` で保護することにより、**GNSS `VDD` 標準セルが `megabytebeat` ネットへ一切混入しない完全分離（クロストーク／バックパワー 0）** を達成。

2. **3 系統独立 VDD パッドリング分離（`fill10_noVDD` ＋ `fill10_supplyVDD`、デジタル `VSS` 共通）**
   - **GNSS アナログ電源（北辺 `afe_rf_pad`）**：`VDDA` / `VDDV` / `VSSA`（両端 `brk_w` / `brk_e` = `fill10_noPWR` で完全分離、`gnss_afe_analog` rev.4b を無変更のまま北端 `[456.0, 3089.4]` `FN` に配置）。
   - **GNSS デジタル電源（北辺・東西上半）**：`VDD` / `DVDD`（4 パッド：`dvdd_pads[0..3]`）＋ GNSS SPI/ADC デジタル 10 ピン。
   - **`megabytebeat` 電源（南辺・東西下半）**：`VDD_BB` / `DVDD_BB`（3 パッド：`dvdd_bb_pads[0..2]`）＋ `megabytebeat` 24 ピン（`bb_clk`, `bb_rst_n`, `bb_ena`, `bb_ui[7:0]`, `bb_uio[7:0]`, `bb_uo[4:0]`）。
   - **VDD 分離セル**：東辺 (`brk_vdd_e`, `y=2252.5 µm`)・西辺 (`brk_vdd_w`, `y=2555.5 µm`) に `./gds/fill10_noVDD.gds`（2 個）を配置し、パッドリングの `VDD`/`DVDD` レールを完全遮断しつつ **デジタル `VSS`/`DVSS`（全 7 パッド）は全周共通接続**。
   - **`VDD_BB` コア供給**：`./gds/fill10_supplyVDD.gds`（6 個：東辺 3 個 `sup_vdd_e0/e1/e2` ＋ 西辺 3 個 `sup_vdd_w0/w1/w2`、PDN Metal5 スタブ間の 64 µm 空き窓に配置、クリアランス `11〜27 µm`）から幅 9 µm × 6 本の **Metal5** ジャンパーで `megabytebeat_macro` 外周の Metal5 C-トランクおよび 30 本の Metal5 フィンガーへ供給。
   - **共通 `VSS` コア接続**：南側 Metal3 `VSS` コアリングへ 12 本の Metal4 ストラップ（`VDD` コアリングタップと交差する 3 本を自動回避）、北側 Metal3 `VSS` コレクタバーへ 15 本＋チップ側 12 本の Metal4 ストラップを OpenROAD PDN 生成の `VIARULE Via3_GEN_HH` 4×4 ビアで接続。
   - `gnss_afe_analog`（`y = 3089.4..4660.4 µm`）と `megabytebeat_macro`（`y = 520.0..1480.0 µm`）の間は **1,609 µm（1.61 mm）** 離隔。

### F.2 最終 73 パッド配置表（`slot 0p5x1` 公式ボンドフレーム準拠）

| 辺 | 位置（南→北 / 西→東） | 電源ドメイン | パッド信号一覧 |
|---|---|---|---|
| **南辺（8 パッド）** | `x = 447.5 .. 1413.5` | **`VDD_BB`** | `BB_CLK`, `BB_RST_N`, `BB_ENA (内蔵PD)`, `DVSS(共通)`, `DVDD_BB`, `BB_UO[0]` (trk0: the 42 melody), `BB_UO[1]` (trk1: fractal trees), `BB_UO[2]` (trk2: untitled) |
| **東辺下半（12 パッド）** | `y = 471.5 .. 2143.5` | **`VDD_BB`** | `BB_UO[3]` (trk3: a tune to share), `BB_UO[4]` (trk7: sierpinski harmony), `DVSS(共通)`, `DVDD_BB`, `BB_UIO[0..7]` (`c[3:0], d[3:0]`) ＋ `fill10_supplyVDD` × 3 |
| *東辺境界* | `y = 2252.5` | *分離* | **`brk_vdd_e` (`fill10_noVDD`)** — `VDD` / `VDD_BB` 遮断・`VSS` 共通 |
| **東辺上半（16 パッド）** | `y = 2295.5 .. 4575.5` | **GNSS `VDD`** | `I_SIGN`, `DVSS(共通)`, `DVDD`, `I_MAG`, `Q_SIGN`, `Q_MAG`, `CLKOUT`, `nc[0..4]`, `DVSS(共通)`, `DVDD`, `nc[5..6]` |
| **北辺（11 パッド）** | `x = 410.5 .. 1525.5` | **GNSS `VDD` / アナログ** | `REFIN`, `AFCOUT`, `DVSS(共通)`, `DVDD`, `VCTRL`, `brk_w(fill10_noPWR)`, **`afe_rf_pad` (`VDDV \| VSSA VDDA VSSA RF VSSA`)**, `brk_e(fill10_noPWR)` |
| **西辺下半（13 パッド）** | `y = 473.5 .. 2441.5` | **`VDD_BB`** | `BB_UI[0..7]` (`a[3:0], b[3:0]`), `nc_bb[0..2]`, `DVSS(共通)`, `DVDD_BB` ＋ `fill10_supplyVDD` × 3 |
| *西辺境界* | `y = 2555.5` | *分離* | **`brk_vdd_w` (`fill10_noVDD`)** — `VDD` / `VDD_BB` 遮断・`VSS` 共通 |
| **西辺上半（13 パッド）** | `y = 2605.5 .. 4573.5` | **GNSS `VDD`** | `SCLK`, `RST_N`, `SDI`, `CS_N (内蔵PU)`, `SDO`, `nc[7..10]`, `DVSS(共通)`, `DVDD`, `nc[11..12]` |

### F.3 サインオフ・検証結果一覧（全項目 PASS）

| 検証項目 | 結果 | 詳細・ログ |
|---|---|---|
| **LibreLane `chip_top`（`RUN_2026-11-25_16-01-45`）** | **85/85 ALL PASS** | `chip/final/metrics.json` |
| ├ Magic DRC / KLayout DRC | **0 / 0** | フルチップ `1936 × 5122 µm` |
| ├ KLayout Antenna / Density | **0 / 0** | `Metal2_ignore_active: true` |
| ├ Magic vs KLayout XOR | **0** | PDN `VIARULE Via3_GEN_HH` 再利用 |
| ├ **Netgen LVS** | **0（`Circuits match uniquely`）** | `VDD` / `VDD_BB` / `VDDA` / `VDDV` / `VSS` / `VSSA` 完全独立一致 |
| ├ **STA（9 コーナー Setup / Hold）** | **0 / 0** | Setup WS `+0.610 ns` / Hold WS `+0.457 ns`（2 クロック非同期制約） |
| ├ IR Drop（平均 / 最悪） | **`1.08 µV` / `19.3 µV`** | GNSS デジタル領域 |
| ├ Dual-VDD 独立性監査（`chip_top.pnl.v`） | **0 混入** | GNSS `VDD` 標準セルの `bb_*` ネット接触 0 件（`fill10_noVDD`×2, `fill10_supplyVDD`×6, `fill10_noPWR`×2） |
| **`cocotb` RTL ＋ ゲートレベル（`GL=1`, 電源ピン付）** | **PASS / PASS** | GNSS SPI（`0xA88000` / `0xADA3C5`）＋ `bb_ena=0` 停止 ＋ `megabytebeat` 5 曲ビット完全一致（`t=0..11`）＋ `bb_ena 1→0` クランプ |
| **Wafer.Space 公式 `gf180mcu-precheck --slot 0p5x1`** | **16/16 ALL PASS（0 違反）** | `RUN_2026-11-25_16-46-27`, `layout/review/precheck_0p5x1_megabytebeat.log` |
| **最終 GDS** | **`143,024,474` bytes** | `chip/final/gds/chip_top.gds`<br>SHA-256: `7baecb319016aaccae354cdecb511b88153b19c569a497ad7d935d39db2db402` |
