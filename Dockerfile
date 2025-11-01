FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# 1. BASE SYSTEM (FAST AND CACHED)
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    python3.10-venv \
    git \
    ffmpeg \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/python3.10 /usr/bin/python

WORKDIR /folkstory-app

# FIX: Copy to CURRENT directory (which is /folkstory-app)
COPY requirements.txt .

# FIX: Use python (not python3.10) - we made a shortcut
RUN python -m pip install --upgrade pip
RUN python -m pip install \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

RUN python -m pip install -r requirements.txt

# FIX: Copy everything to CURRENT directory
COPY . .

CMD ["python", "download_models.py"]