# macaulay2-mcp — Binder demo

[![Launch on Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/youngsu-Kim/macaulay2-mcp-binder/main?urlpath=lab/tree/demo.ipynb)

A **zero-install playground** for the [macaulay2 MCP server](https://github.com/youngsu-Kim/macaulay2-mcp).

Click the badge, log in with GitHub (free), wait ~2–4 minutes on the first launch, then open **`demo.ipynb`**. The notebook runs the MCP server inside your browser session and drives it with the standard Model Context Protocol — the same way Claude Code or opencode use it on your machine. You can play with Groebner bases, resolutions, Betti tables, and package loading without installing anything.

> **Status (2026-11-01): blocked upstream.** The build fails at the selftest because the wheel's `M2-binary` is compiled for AVX-512 (10,936 `zmm` instructions, e.g. `vfmadd231pd %zmm…`) while this fleet's AMD nodes expose only avx/avx2 — the process dies with SIGILL (exit 132) at startup. Needs an upstream rebuild for a baseline CPU target (x86-64-v2/v3) or tiered wheels; tracked in [macaulay2-mcp#2](https://github.com/youngsu-Kim/macaulay2-mcp/issues/2).

## How it works

- This repo only provides the *environment* (a `Dockerfile`) and the demo notebook.
- **This branch (`psm-m2`)** installs **no system Macaulay2**: the kernel arrives via the [passagemath-macaulay2](https://pypi.org/project/passagemath-macaulay2/) PyPI wheels together with the server (one `uvx --with` command), running the [`passagemath-support`](https://github.com/youngsu-Kim/macaulay2-mcp/tree/passagemath-support) feature branch's wheel fallback. The sibling branch [`ppa`](https://github.com/youngsu-Kim/macaulay2-mcp-binder/tree/ppa) uses the official Ubuntu PPA kernel instead.
- `demo.ipynb` is a plain **Python 3** notebook (no Macaulay2 Jupyter kernel): its cells act as an MCP *client*, spawning the MCP *server* over stdio and calling its tools.

## For real work

Binder sessions are temporary (they disappear when you stop using them). For everyday use, install the server on your own machine and connect Claude Code, opencode, Claude Desktop, or Gemini CLI — see the main repository's README:

<https://github.com/youngsu-Kim/macaulay2-mcp>

## License

Same as the main project: [GPL-3.0-or-later](LICENSE).
