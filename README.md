# macaulay2-mcp — Binder demo

[![Launch on Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/youngsu-Kim/macaulay2-mcp-binder/main?urlpath=lab/tree/demo.ipynb)

A **zero-install playground** for the [macaulay2 MCP server](https://github.com/youngsu-Kim/macaulay2-mcp).

Click the badge, log in with GitHub (free), wait ~2–4 minutes on the first launch, then open **`demo.ipynb`**. The notebook runs the MCP server inside your browser session and drives it with the standard Model Context Protocol — the same way Claude Code or opencode use it on your machine. You can play with Groebner bases, resolutions, Betti tables, and package loading without installing anything.

> **Status (2026-11-07): verified fixed on this fleet with the 10.8.14rc1 wheel.**
>
> - Upstream rebuilt the kernel wheel for a baseline CPU target ([passagemath#3001](https://github.com/passagemath/passagemath/issues/3001) → [PR #3004](https://github.com/passagemath/passagemath/pull/3004)); this branch pins `passagemath-macaulay2==10.8.14rc1`
> - Captured on a live session: the node is an AMD EPYC-Milan VM exposing only `avx`/`avx2` (`lscpu` + `/proc/cpuinfo` — the condition that SIGILL'd the old wheel), and on that same node the server's selftest passes end to end with the wheel kernel (this image ships no system Macaulay2)
> - The wrapper bug ([passagemath#3002](https://github.com/passagemath/passagemath/issues/3002)) remains open upstream, so the server-side libs workaround stays load-bearing
> - Branch [`psm-m2`](https://github.com/youngsu-Kim/macaulay2-mcp-binder/tree/psm-m2) keeps the stable pin and stays blocked until 10.8.14 ships non-rc

## How it works

- This repo only provides the *environment* (a `Dockerfile`) and the demo notebook.
- **This branch (`psm-m2-rc1`)** installs **no system Macaulay2**: the server comes from PyPI (`macaulay2-mcp==0.1.5`) and the kernel from the pinned `passagemath-macaulay2==10.8.14rc1` wheel (one `uvx` command), exercising the wheel fallback end to end. Sibling branches: [`psm-m2`](https://github.com/youngsu-Kim/macaulay2-mcp-binder/tree/psm-m2) is the same demo on the stable wheel (currently blocked upstream — see Status above), [`ppa`](https://github.com/youngsu-Kim/macaulay2-mcp-binder/tree/ppa) uses the official Ubuntu PPA kernel instead.
- `demo.ipynb` is a plain **Python 3** notebook (no Macaulay2 Jupyter kernel): its cells act as an MCP *client*, spawning the MCP *server* over stdio and calling its tools.

## For real work

Binder sessions are temporary (they disappear when you stop using them). For everyday use, install the server on your own machine and connect Claude Code, opencode, Claude Desktop, or Gemini CLI — see the main repository's README:

<https://github.com/youngsu-Kim/macaulay2-mcp>

## License

Same as the main project: [GPL-3.0-or-later](LICENSE).
