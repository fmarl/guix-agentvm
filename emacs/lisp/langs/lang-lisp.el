;;; lang-lisp.el --- Common Lisp development setup -*- lexical-binding: t; -*-

;; SPDX-FileCopyrightText: 2026 Florian Marrero Liestmann
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(use-package sly
  :defer t
  :custom (inferior-lisp-program "sbcl"))

(provide 'lang-lisp)

;;; lang-lisp.el ends here
