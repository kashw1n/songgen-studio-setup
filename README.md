# SongGeneration Studio Setup

## Requirements
- NVIDIA GPU 10GB+ VRAM (24GB recommended)
- CUDA 12.x
- Python 3.11
- 50GB disk space

## Quick Setup

```bash
cd /workspace/setup
chmod +x install.sh start.sh
./install.sh
./start.sh
```

## Access via SSH Tunnel

From your local machine:
```bash
ssh -L 7860:localhost:7860 root@<SERVER_IP> -p <SSH_PORT>
```

Then open: http://localhost:7860

## What install.sh does
1. Clones BazedFrog/SongGeneration-Studio repo
2. Clones Tencent's SongGeneration repo into app/
3. Creates Python venv, installs PyTorch with CUDA 12.4
4. Installs dependencies from tested requirements
5. Fixes hydra-core for Python 3.11 compatibility
6. Downloads models from HuggingFace (~14GB)
7. Copies custom UI files and patches

## Notes
- First run: download a model via web UI (~10GB)
- Generation takes 3-6 min per song
- Uses ~10-15GB VRAM during generation
