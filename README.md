# guix-agentvm
A [guix-microvm](https://github.com/fmarl/guix-microvm) VM for coding agents
with Emacs and [Pi](https://pi.dev) side by side in tmux, connected by
[pi.el](https://github.com/fmarl/pi.el).

```scheme
(cons (channel
        (name 'guix-agentvm)
        (url "https://github.com/fmarl/guix-agentvm")
        (branch "main")
        (introduction
         (make-channel-introduction
          "d74a4689ba4ec6fb86c9b85ba3fa78a25ead1f19"
          (openpgp-fingerprint
           "F2E3 8B47 808B AF7B 81D5  B27F 52C5 7B54 89B5 819D"))))
      %default-channels)
```

## Usage
```
guix microvm --vm=agentvm
agent
```

The VM gets `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `GEMINI_API_KEY`,
`MISTRAL_API_KEY` and `OPENROUTER_API_KEY` from the host's environment or
from files of these names in `~/.local/share/guix-microvm/agentvm/secrets/`.

Emacs is set up for Rust, OCaml, Guile and Common Lisp.  Compilers and
language servers come from the project's `manifest.scm`.
