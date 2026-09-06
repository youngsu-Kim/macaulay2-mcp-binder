# Binder build for the macaulay2-mcp demo.
#
# Why a Dockerfile instead of postBuild: repo2docker's Ubuntu 24.04 base
# migration removed passwordless sudo from the build user, so system-package
# installs from postBuild are no longer reliable across Binder's clusters.
# A Dockerfile controls the build identity explicitly (USER root / USER
# jovyan), needs no sudo anywhere, and repo2docker delegates to it entirely.

FROM quay.io/jupyter/base-notebook:ubuntu-24.04

USER root

# --- Macaulay2 1.26 (official PPA; ships a noble release) ---
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:macaulay2/macaulay2 && \
    apt-get install -y --no-install-recommends macaulay2 && \
    rm -rf /var/lib/apt/lists/* && \
    M2 --version

# --- uv/uvx on the system PATH (no shell-profile tricks needed at runtime) ---
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh

USER ${NB_UID}

# --- Python MCP client, plus pre-warm the published server so the demo's
#     first `uvx macaulay2-mcp` is instant (cache lands under /home/jovyan) ---
COPY requirements.txt ./
RUN python -m pip install --no-cache-dir -r requirements.txt && \
    uvx macaulay2-mcp selftest

# --- demo materials into the notebook home ---
COPY --chown=jovyan:users . ${HOME}
