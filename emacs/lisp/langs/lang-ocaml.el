;;; lang-ocaml.el --- OCaml development setup -*- lexical-binding: t; -*-

;; SPDX-FileCopyrightText: 2026 Florian Marrero Liestmann
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(use-package tuareg
  :mode (("\\.mlp?\\'" . tuareg-mode)
         ("\\.mli\\'" . tuareg-interface-mode)
         ("\\.ocamlinit\\'" . tuareg-mode))
  :hook (tuareg-mode . eglot-ensure))

(provide 'lang-ocaml)

;;; lang-ocaml.el ends here
