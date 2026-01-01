#!/bin/bash
# SongGeneration Studio - Full Setup Script
set -e

cd /root

echo "=== SongGeneration Studio Setup ==="

# 1. Clone BazedFrog repo
echo "[1/8] Cloning SongGeneration-Studio repo..."
git clone https://github.com/BazedFrog/SongGeneration-Studio.git
cd SongGeneration-Studio

# 2. Clone Tencent repo
echo "[2/8] Cloning Tencent SongGeneration repo..."
git clone https://github.com/tencent-ailab/SongGeneration app

# 3. Create venv & install PyTorch
echo "[3/8] Creating venv and installing PyTorch..."
python3 -m venv app/env
source app/env/bin/activate
pip install --upgrade pip wheel
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# 4. Copy tested requirements & install
echo "[4/8] Installing dependencies..."
cp requirements.txt app/
cp requirements_nodeps.txt app/
pip install -r app/requirements.txt
pip install -r app/requirements_nodeps.txt --no-deps

# 5. Fix hydra-core for Python 3.11
echo "[5/8] Fixing hydra-core compatibility..."
pip install hydra-core==1.3.2 omegaconf==2.3.0 --no-deps

# 6. Download models from HuggingFace (~14GB)
echo "[6/8] Downloading models from HuggingFace (~14GB)..."
cd app
huggingface-cli download lglg666/SongGeneration-Runtime --local-dir .
cd ..

# 7. Copy custom files
echo "[7/8] Copying custom files..."
cp main.py generation.py model_server.py models.py gpu.py config.py schemas.py sse.py timing.py app/
cp -r web/static/* app/web/static/

# 8. Apply patches
echo "[8/9] Applying patches..."
cp patches/builders.py app/codeclm/models/builders.py
cp patches/demucs/apply.py app/third_party/demucs/models/apply.py
mkdir -p app/tools/gradio
cp patches/gradio/levo_inference_lowmem.py app/tools/gradio/

# 9. Fix torch.load for PyTorch 2.6+ (weights_only=False)
echo "[9/9] Fixing torch.load for PyTorch 2.6+..."
sed -i 's/torch\.load(auto_prompt_path)/torch.load(auto_prompt_path, weights_only=False)/g' app/tools/gradio/levo_inference_lowmem.py
sed -i 's/torch\.load(self\.pt_path, map_location=.cpu.)/torch.load(self.pt_path, map_location="cpu", weights_only=False)/g' app/tools/gradio/levo_inference_lowmem.py
sed -i 's/torch\.load(ckpt_path, map_location=.cpu.)/torch.load(ckpt_path, map_location="cpu", weights_only=False)/g' app/codeclm/trainer/codec_song_pl.py

echo ""
echo "=== Setup complete! ==="
echo "Run: /workspace/setup/start.sh"
