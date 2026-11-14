;;; config-agentvm.el --- Agent VM: terminal Emacs next to Pi -*- lexical-binding: t; -*-

;; SPDX-FileCopyrightText: 2026 Florian Marrero Liestmann
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(require 'seq)
(require 'my-cache)

;;;; Terminal

(xterm-mouse-mode)

(setopt xterm-extra-capabilities '(modifyOtherKeys setSelection)
        xterm-tmux-extra-capabilities '(modifyOtherKeys setSelection))

(declare-function modus-themes-load-theme "modus-themes")
(defun my/agentvm-default-theme ()
  (unless (seq-difference custom-enabled-themes '(modus-vivendi-tinted))
    (modus-themes-load-theme 'modus-vivendi-tinted)))
(add-hook 'after-init-hook #'my/agentvm-default-theme)

(declare-function diff-hl-margin-mode "diff-hl-margin")
(with-eval-after-load 'diff-hl
  (diff-hl-margin-mode))

(setq delayed-warnings-list
      (seq-remove (lambda (warning)
                    (pcase (car warning)
                      (`(files missing-lexbind-cookie
                               ,(rx "/sly-autoloads.el" eos))
                       t)))
                  delayed-warnings-list))

(setopt yas-snippet-dirs (list (my/cache-file "snippets/")))
(make-directory (my/cache-file "snippets/") t)

;;;; Pi

(use-package pi
  :bind-keymap ("C-c a" . pi-command-map)
  :init (pi-mode))

(use-package server
  :functions server-running-p
  :config
  (unless (server-running-p)
    (server-start)))

(provide 'config-agentvm)

;;; config-agentvm.el ends here
