FROM downloads.unstructured.io/unstructured-io/unstructured-api:latest

# Set environment variables
ENV PORT=8000
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Expose the port the app runs on
EXPOSE ${PORT}

# The official image already includes the correct CMD
# No need to override it as it's already set to:
# CMD ["uvicorn", "--host", "0.0.0.0", "--port", "8000", "unstructured.api:app"]
