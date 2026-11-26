# Hosted, replay-only Paper Trading Lab (no Dhan feed, no credentials).
FROM python:3.12-slim

# LightGBM needs the OpenMP runtime.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libgomp1 \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PORT=8000 \
    MAX_RUNNING=2

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY src/ src/
COPY model.txt .
COPY data/ data/
COPY experiments/ experiments/

EXPOSE 8000
# Shell form so $PORT (set by Railway) and $MAX_RUNNING expand at start-up.
CMD python -m src.main --portal --no-feed --host 0.0.0.0 --port "$PORT" --max-running "$MAX_RUNNING"
