FROM python:3.13 as builder

RUN pip3 install poetry==3.1.0
WORKDIR /app
COPY pyproject.toml poetry.lock /app/

ENV POETRY_NO_INTERACTION=1 \
POETRY_VIRTUALENVS_IN_PROJECT=1 \
POETRY_VIRTUALENVS_CREATE=true \
POETRY_CACHE_DIR=/tmp/poetry_cache

RUN --mount=type=cache,target=/tmp/poetry_cache poetry install --only main --no-root
RUN poetry install

FROM python:3.13 as runner
COPY src /app/src/

COPY --from=builder /app/.venv /app/.venv
ENV PATH="/app/.env/bin:$PATH"

ENTRYPOINT ["/app/.env/bin/python", "src/jon_applications/main.py"]
