FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

WORKDIR /app
ADD . .
RUN chmod +x ./start.sh

RUN apt-get update
RUN apt-get install -y ffmpeg software-properties-common

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN uv sync --frozen

ENTRYPOINT ["uv", "run", "bash", "./start.sh"]
