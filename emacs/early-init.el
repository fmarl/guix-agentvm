;;; early-init.el --- Pre-init setup -*- lexical-binding: t; -*-

;; SPDX-FileCopyrightText: 2026 Florian Marrero Liestmann
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Code:

(dolist (dir '("lisp/lib/" "lisp/configs/" "lisp/langs/"))
  (add-to-list 'load-path (expand-file-name dir user-emacs-directory)))

(require 'my-cache)

(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 64 1024 1024))))

(defvar native-comp-async-report-warnings-errors)
(setq native-comp-async-report-warnings-errors 'silent)

(advice-add #'display-startup-echo-area-message :override #'ignore)

(when (featurep 'native-compile)
  (startup-redirect-eln-cache (my/cache-file "eln-cache/")))

(push '(menu-bar-lines . 0) default-frame-alist)

;;; early-init.el ends here
