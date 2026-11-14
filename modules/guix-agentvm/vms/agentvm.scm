;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Florian Marrero Liestmann <f.m.liestmann@fx-ttr.de>

(define-module (guix-agentvm vms agentvm)
  #:use-module (gnu)
  #:use-module (sagittarius packages emacs-xyz)
  #:use-module (sagittarius packages pi)
  #:use-module (guix-agentvm packages workspace)
  #:use-module (guix-microvm base)
  #:use-module (guix-microvm microvm)
  #:export (%agentvm-system
            agentvm))

(use-package-modules compression curl emacs emacs-xyz less linux ncurses ocaml
                     rust-apps tmux tree-sitter version-control)

;;;; Packages

(define %emacs-packages
  (list emacs-no-x
        emacs-pi
        emacs-ace-window
        emacs-apheleia
        emacs-avy
        emacs-cape
        emacs-consult
        emacs-consult-eglot
        emacs-corfu
        emacs-diff-hl
        emacs-dirvish
        emacs-embark
        emacs-geiser-guile
        emacs-magit
        emacs-marginalia
        emacs-markdown-mode
        emacs-modus-themes
        emacs-orderless
        emacs-paredit
        emacs-rainbow-delimiters
        emacs-sly
        emacs-tuareg
        emacs-vertico
        emacs-wgrep
        emacs-yasnippet
        emacs-yasnippet-snippets
        tree-sitter-bash
        tree-sitter-json
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-yaml))

;;;; System

(define %agentvm-system
  (operating-system
    (inherit %base-vm)
    (host-name "agentvm")
    (packages (append (list pi
                            pi-workspace
                            tmux
                            ncurses
                            git
                            gnu-make
                            ripgrep
                            fd
                            curl
                            less
                            gzip
                            procps)
                      %emacs-packages
                      %base-packages))
    (services %microvm-base-services)))

(define agentvm
  (microvm
    (operating-system %agentvm-system)
    (secrets '("ANTHROPIC_API_KEY"
               "OPENAI_API_KEY"
               "GEMINI_API_KEY"
               "MISTRAL_API_KEY"
               "OPENROUTER_API_KEY"))))
