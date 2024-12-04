FROM python:3.9-slim

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install Rust compiler
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Set working directory
WORKDIR /app

# Install Python dependencies with fixed versions for security
RUN pip install --no-cache-dir "unstructured[all-docs]==0.10.30" "unstructured-api==0.10.30" "uvicorn[standard]==0.24.0.post1"

# Copy application files
COPY --chown=appuser:appuser . .

# Set environment variables
ENV PORT=8000
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Switch to non-root user
USER appuser

# Expose the port the app runs on
EXPOSE ${PORT}

# Command to run the API with worker limit
CMD ["uvicorn", "unstructured.api:app", "--host", "0.0.0.0", "--port", "${PORT}", "--workers", "4"]
