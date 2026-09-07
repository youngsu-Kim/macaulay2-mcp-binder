# Binder image for the macaulay2-mcp demo.
#
# Base: Canonical's Ubuntu 24.04 amd64 rootfs of 2026-08-10, pinned by its
# immutable dated tag (upstream lineage: cloud-images Launchpad tag
# dist-noble-amd64-20260810-461fbe29). The floating tags (24.04,
# ubuntu-24.04) and the jupyter docker-stacks tags are NOT used: an upstream
# rebuild silently removed curl mid-project and broke a previously green
# build. Everything the demo needs is spelled out below; nothing floats.

FROM ubuntu:noble-20260810

ENV DEBIAN_FRONTEND=noninteractive

# --- Macaulay2 1.26 (official PPA) + python3/venv base tooling ---
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates python3 python3-venv software-properties-common && \
    add-apt-repository -y ppa:macaulay2/macaulay2 && \
    apt-get install -y --no-install-recommends macaulay2 && \
    rm -rf /var/lib/apt/lists/* && \
    M2 --version

# --- Jupyter + uv + the demo's python MCP client in one venv (no conda,
#     no curl-pipe installers: uv ships as a plain PyPI wheel) ---
RUN python3 -m venv /opt/venv
ENV PATH=/opt/venv/bin:${PATH}
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir jupyterlab uv -r /tmp/requirements.txt

# --- Pre-warm the published MCP server; runs during the build, so the
#     first notebook launch is instant and a broken image never ships ---
RUN uvx macaulay2-mcp selftest

# --- demo materials ---
COPY . /srv/repo
WORKDIR /srv/repo
EXPOSE 8888
CMD ["jupyter", "lab", \
     "--allow-root", \
     "--ip=0.0.0.0", "--port=8888", "--no-browser", \
     "--ServerApp.token=", "--ServerApp.password=", \
     "--ServerApp.allow_origin=*", \
     "--ServerApp.root_dir=/srv/repo"]
