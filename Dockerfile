FROM python:3.13-slim

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Copy dependency files first for layer caching
COPY pyproject.toml uv.lock ./

# Install dependencies (no project install yet, sync from lock file)
RUN uv sync --frozen --no-install-project

# Copy application code
COPY __main__.py ./

# Install the project itself
RUN uv sync --frozen

ENV FREQTRADE_API_URL=http://127.0.0.1:8080
ENV FREQTRADE_USERNAME=Freqtrader
ENV FREQTRADE_PASSWORD=SuperSecret1!

CMD ["uv", "run", "python", "__main__.py"]
