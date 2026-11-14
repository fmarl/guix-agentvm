;;; my-secrets.el --- Which files hold secrets -*- lexical-binding: t; -*-

;; SPDX-FileCopyrightText: 2026 Florian Marrero Liestmann
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(defun my/secret-file-p (name)
  (string-match-p
   (rx (or (seq "/." (or "aws" "gnupg" "kube" "password-store" "ssh") "/")
           "/secrets/"
           (seq "/." (or "authinfo" "netrc") (? ".gpg") eos)
           (seq ".env" (? "." (* (not "/"))) eos)))
   name))

(provide 'my-secrets)

;;; my-secrets.el ends here
