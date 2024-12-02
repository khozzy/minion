ARG PYTHON_BASE=3.13-slim

# build stage
FROM python:$PYTHON_BASE AS builder

RUN pip install -U pdm
ENV PDM_CHECK_UPDATE=false

COPY pyproject.toml pdm.lock README.md /project/
COPY src/ /project/src

WORKDIR /project
RUN pdm build

# run stage
FROM python:$PYTHON_BASE

COPY --from=builder /project/dist/*.whl /project/
RUN pip install /project/*.whl

WORKDIR /project
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "--worker-class", "sync", "--worker-connections", "1000", "--timeout", "30", "--keep-alive", "2", "--access-logfile", "-", "--error-logfile", "-", "--log-level", "info", "--limit-request-line", "4094", "--limit-request-fields", "100", "minion.app:app"]