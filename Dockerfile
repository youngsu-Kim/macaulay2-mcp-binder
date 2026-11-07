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

# --- python3/venv base tooling only: NO system Macaulay2 on this branch.
#     The kernel ships inside the image via the passagemath-macaulay2 PyPI
#     wheels, exercising the server's wheel fallback (official-first
#     discovery finds no M2 on PATH, so the sage_wheels copy is used). ---
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates git python3 python3-venv && \
    rm -rf /var/lib/apt/lists/*

# --- Jupyter + uv + the demo's python MCP client in one venv (no conda,
#     no curl-pipe installers: uv ships as a plain PyPI wheel) ---
RUN python3 -m venv /opt/venv
ENV PATH=/opt/venv/bin:${PATH}
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir jupyterlab uv -r /tmp/requirements.txt

# --- Pre-warm the published MCP server; runs during the build, so the
#     first notebook launch is instant and a broken image never ships ---
# Pre-warm = build-time E2E of the wheel fallback: no M2 is on PATH here,
# so the server's selftest can only pass by discovering the kernel that
# --with passagemath-macaulay2 placed into the ephemeral environment.
# This branch pins the wheel to 10.8.14rc1 — the first build carrying the
# AVX-512 fix (upstream passagemath#3001, fat-binary rebuild #3004); the
# stable 10.8.13 SIGILLs on avx/avx2-only fleet nodes (that variant lives
# on branch psm-m2, unchanged). Server from PyPI 0.1.5 rather than the
# parked passagemath-support git branch (tombstoned for deletion ~Dec 1).
RUN uvx --from 'macaulay2-mcp==0.1.5' --with 'passagemath-macaulay2==10.8.14rc1' macaulay2-mcp selftest || (echo '=== DEBUG ==='; M2B=$(find /root/.cache/uv -name M2 -type f | head -1); BDIR=$(dirname "$M2B"); SPK=$(dirname "$(dirname "$BDIR")"); echo "binary: $M2B"; echo "libs dir exists: $(ls -d "$SPK/passagemath_macaulay2.libs" 2>&1)"; ls "$SPK/passagemath_macaulay2.libs" 2>/dev/null | head -3; "$M2B" --version 2>&1; echo "wrapper exit=$?"; LD_LIBRARY_PATH="$SPK/passagemath_macaulay2.libs" "$BDIR/M2-binary" --version 2>&1; echo "binary-with-libs exit=$?"; grep -m1 -o 'avx[0-9a-z_]*' /proc/cpuinfo | head -5; ulimit -s; cat /etc/os-release | head -2; exit 1)

# --- demo materials ---
# world-writable so ANY uid a Binder cluster may run the pod under
# (2i2c hubs sometimes use random UIDs) can save, copy, and modify the notebook.
COPY . /srv/repo
RUN chmod -R a+rwX /srv/repo
WORKDIR /srv/repo
EXPOSE 8888
CMD ["jupyter", "lab", \
     "--allow-root", \
     "--ip=0.0.0.0", "--port=8888", "--no-browser", \
     "--ServerApp.token=", "--ServerApp.password=", \
     "--ServerApp.allow_origin=*", \
     "--ServerApp.root_dir=/srv/repo"]
