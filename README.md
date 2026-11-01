# macaulay2-mcp — Binder demo

[![Launch on Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/youngsu-Kim/macaulay2-mcp-binder/main?urlpath=lab/tree/demo.ipynb)

A **zero-install playground** for the [macaulay2 MCP server](https://github.com/youngsu-Kim/macaulay2-mcp).

Click the badge, log in with GitHub (free), wait ~2–4 minutes on the first launch, then open **`demo.ipynb`**. The notebook runs the MCP server inside your browser session and drives it with the standard Model Context Protocol — the same way Claude Code or opencode use it on your machine. You can play with Groebner bases, resolutions, Betti tables, and package loading without installing anything.

## How it works

- This repo only provides the *environment* (a `Dockerfile`) and the demo notebook.
- At image build time, the `Dockerfile` installs **Macaulay2 1.26** (latest stable, from the official PPA) and **uv**, and pre-warms the MCP server so sessions start quickly.
- **This branch (`ppa`)** runs the server from the [`passagemath-support`](https://github.com/youngsu-Kim/macaulay2-mcp/tree/passagemath-support) feature branch, with the **official PPA kernel**. The sibling branch [`psm-m2`](https://github.com/youngsu-Kim/macaulay2-mcp-binder/tree/psm-m2) instead ships the kernel inside the image via the passagemath PyPI wheels — a live demo of that branch's wheel fallback.
- `demo.ipynb` is a plain **Python 3** notebook (no Macaulay2 Jupyter kernel): its cells act as an MCP *client*, spawning the MCP *server* over stdio and calling its tools.

## For real work

Binder sessions are temporary (they disappear when you stop using them). For everyday use, install the server on your own machine and connect Claude Code, opencode, Claude Desktop, or Gemini CLI — see the main repository's README:

<https://github.com/youngsu-Kim/macaulay2-mcp>

## License

Same as the main project: [GPL-3.0-or-later](LICENSE).
