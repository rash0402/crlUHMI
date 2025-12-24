# UHTP - Unified HMI Tracking Platform

**統合型HMI追従実験プラットフォーム**

[![Status](https://img.shields.io/badge/Status-PoC%20Development-green)]()
[![Julia](https://img.shields.io/badge/Julia-1.10+-blue)]()
[![Python](https://img.shields.io/badge/Python-3.11+-blue)]()

## 概要

UHTPは、Human-Machine Interaction (HMI) 研究のための**微分可能リアルタイム制御プラットフォーム**です。

3つの研究プロジェクト（STA, IMM, HA-VAE）の共通検証基盤として、国際標準タスク（SoS, CIT, Fitts）と動的パラメータランダム化機能を統合し、Julia言語による高速制御とPythonによる柔軟な可視化を組み合わせた実験環境を提供します。

## 特徴

- **2プロセスハイブリッド構成**: Julia（1kHz制御）+ Python（60Hz可視化）
- **2次元XY平面操作**: 軸ごとにパラメータ設定可能
- **複数入力デバイス対応**: トラックパッド、キーボード、マウス、Auto-PD、UDPハプティック
- **標準タスク実装**: Sum-of-Sines、Critical Instability Task、Fitts' Law
- **リアルタイム可視化**: ライブプロット、結果サマリー画面

## アーキテクチャ

```
Julia Core (1kHz)              Python Viewer (60Hz)
┌──────────────────┐           ┌──────────────────┐
│ PhysicsEngine    │           │ UDPReceiver      │
│ InputHandler     │──UDP──────│ Visualizer       │
│ TaskEngine       │           │ GUI Controller   │
│ UDPSender        │           │ DataLogger       │
└──────────────────┘           └──────────────────┘
```

## ディレクトリ構成

```
crlUHMI/
├── julia/          # Julia Core Process
│   ├── src/        # ソースコード
│   └── test/       # テスト
├── python/         # Python Viewer Process
│   ├── src/        # ソースコード
│   └── tests/      # テスト
├── config/         # 設定ファイル（YAML）
├── doc/            # ドキュメント
│   ├── AI-DLC_base_UnifiedHMITrackingPlatform.md  # 設計仕様書
│   └── UHTP_Implementation_Requirements.md        # 実装要件定義書
└── data/           # 実験データ（gitignore）
```

## 必要環境

### Julia (v1.10+)

```toml
# 主要パッケージ
StaticArrays = "1.9+"
Sockets (stdlib)
YAML
```

### Python (3.11+)

```
vispy>=0.14.0
pygame>=2.5.0
pyqt6>=6.6.0
h5py>=3.10.0
numpy>=1.26.0
pyyaml>=6.0.1
```

## クイックスタート

```bash
# リポジトリのクローン
git clone https://github.com/rash0402/crlUHMI.git
cd crlUHMI

# Julia依存関係のインストール
cd julia
julia --project=. -e 'using Pkg; Pkg.instantiate()'

# Python依存関係のインストール
cd ../python
pip install -r requirements.txt

# 実行（2つのターミナルで）
# Terminal 1: Julia Core
cd julia && julia --project=. src/UHTP.jl

# Terminal 2: Python Viewer
cd python && python -m src.main
```

## ドキュメント

| ドキュメント | 説明 |
|-------------|------|
| [設計仕様書](doc/AI-DLC_base_UnifiedHMITrackingPlatform.md) | 研究設計・理論的基盤 |
| [実装要件定義書](doc/UHTP_Implementation_Requirements.md) | 機能要件・アーキテクチャ |
| [CLAUDE.md](CLAUDE.md) | Claude Code用ガイド |

## 物理モデル

XY独立の2次遅れ系ダイナミクス:

```
Mx*c̈x + Bx*ċx + Kx*cx = uhx + usysx + wx  (X軸)
My*c̈y + By*ċy + Ky*cy = uhy + usysy + wy  (Y軸)
```

- 状態ベクトル: [cx, cy, vx, vy]ᵀ ∈ ℝ⁴
- パラメータ（M, B, K）は軸ごとにYAML設定可能

## 実験タスク

| タスク | 目的 | 評価指標 |
|--------|------|---------|
| **SoS** (Sum-of-Sines) | 周波数応答解析 | RMSE, 位相遅れ, クロスオーバー周波数 |
| **CIT** (Critical Instability) | 制御限界測定 | 臨界不安定パラメータ λc |
| **Fitts** (ISO 9241-9) | 弾道予測能力 | スループット, エラー率 |

## 開発状況

- [x] 設計仕様書作成
- [x] 実装要件定義書作成
- [ ] Phase 1: MVP（UDP通信 + マウス入力 + 基本描画）
- [ ] Phase 2: 全タスク + 全デバイス
- [ ] Phase 3: データログ + 可視化機能

## ライセンス

研究目的での使用を想定しています。詳細は別途定めます。

## 著者

- AI-DLC Team
- Tokyo Denki University

## 謝辞

本プロジェクトはAI-DLC（AI-Driven Development Life Cycle）手法に基づいて設計されました。
