# Use a lightweight Python image
FROM python:3.12-slim-bookworm

# Set the working directory inside the container
WORKDIR /app
# Copy all files from the project directory to the container
COPY . .
# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*
# Download and install uv
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Install FastAPI and Uvicorn
RUN pip install fastapi uvicorn

# Install required Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Ensure uv is on PATH
ENV PATH="/root/.local/bin:$PATH"


# Expose port 8000 for the API
EXPOSE 8000

# Load environment variables from .env (Optional: If using python-dotenv)
COPY .env .env
RUN python -m dotenv load_env

# Run the FastAPI application with Uvicorn
CMD ["uv", "run", "app:app"]
