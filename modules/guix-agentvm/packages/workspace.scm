;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Florian Marrero Liestmann <f.m.liestmann@fx-ttr.de>

(define-module (guix-agentvm packages workspace)
  #:use-module (guix build-system trivial)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages tmux)
  #:use-module (sagittarius packages emacs-xyz)
  #:use-module (sagittarius packages pi))

;;;; Configuration

;; guix pull keeps the whole checkout of the channel, not just its modules.
(define %top-directory
  (canonicalize-path
   (string-append (dirname (search-path %load-path
                                        "guix-agentvm/packages/workspace.scm"))
                  "/../../..")))

(define %emacs-configuration
  (local-file (string-append %top-directory "/emacs") "emacs" #:recursive? #t))

(define %tmux-configuration
  (local-file (string-append %top-directory "/tmux.conf")))

;; Pi would list a lone store file under its hash.
(define %pi-extensions
  (local-file (string-append %top-directory "/pi/extensions") "pi-extensions"
              #:recursive? #t))

;;;; Launcher

;; tmux matches a target by prefix unless it starts with =.  It reads -f only
;; when it starts the server, so the configuration is sourced instead.
(define %agent
  (program-file "agent"
    #~(let ((tmux #$(file-append tmux "/bin/tmux"))
            (directory (getcwd)))
        (if (zero? (call-with-output-file "/dev/null"
                     (lambda (null)
                       (with-error-to-port null
                         (lambda ()
                           (system* tmux "has-session" "-t" "=agent"))))))
            (execl tmux "tmux" "attach-session" "-t" "=agent")
            (execl tmux "tmux" "source-file" #$%tmux-configuration
                   ";" "new-session" "-s" "agent" "-c" directory
                   #$(file-append emacs-no-x "/bin/emacs") "-nw"
                   (string-append "--init-directory=" #$%emacs-configuration)
                   ";" "split-window" "-d" "-h" "-l" "40%" "-c" directory
                   #$(file-append pi "/bin/pi")
                   "-e" #$(file-append emacs-pi
                                       "/share/pi/extensions/emacs-bridge")
                   "-e" #$(file-append %pi-extensions "/confirm-git.ts"))))))

(define-public pi-workspace
  (package
    (name "pi-workspace")
    (version "0.1")
    (source
     #f)
    (build-system trivial-build-system)
    (arguments
     (list
      #:modules '((guix build utils))
      #:builder
      #~(begin
          (use-modules (guix build utils))
          (mkdir-p (string-append #$output "/bin"))
          (symlink #$%agent
                   (string-append #$output "/bin/agent")))))
    (home-page "https://github.com/fmarl/guix-agentvm")
    (synopsis "Emacs and Pi side by side in tmux")
    (description
     "This package provides @command{agent}, which opens Emacs and the Pi
coding agent side by side in a tmux session, or attaches to the running one.
Emacs uses a terminal configuration of its own.  Pi loads the Emacs bridge
of @code{emacs-pi} and asks before it runs a command that commits, merges or
talks to a remote.")
    (license license:gpl3+)))
