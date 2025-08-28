# Build from a LINUX lightweight version of Anaconda
FROM continuumio/miniconda3

# Update packages and install nano unzip and curl, etc
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    nano \
    unzip \
    curl \
 && rm -rf /var/lib/apt/lists/*


# Install AWS cli - Necessary since we are going to interact with S3 
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install


RUN useradd -m -u 1000 user

USER user

ENV HOME=/home/user \
    PATH=/home/user/.local/bin:$PATH


WORKDIR $HOME/app


COPY --chown=user . $HOME/app


COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt


CMD sh -c "mlflow server --host 0.0.0.0 --port 7860 --backend-store-uri ${BACKEND_STORE_URI} --default-artifact-root ${ARTIFACT_STORE_URI}"
