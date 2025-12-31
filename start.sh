#!/bin/bash
cd /root/SongGeneration-Studio/app
source env/bin/activate
python main.py --host 0.0.0.0 --port 7860
