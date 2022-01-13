;;; Declarative setup with `use-package'.
(require 'package)
(setq package-archives
      `(,@package-archives
        ("melpa" . "https://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))
(package-initialize)

(setq package-enable-at-startup nil)

;; Danger?
(setq package-check-signature nil)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(put 'use-package 'lisp-indent-function 1)
(setq use-package-always-ensure t)
(setq use-package-verbose t)
(setq use-package-minimum-reported-time 0.01)

(use-package system-packages
  :custom
  (system-packages-noconfirm t))

(use-package use-package-ensure-system-package)

;; :diminish keyword
(use-package diminish)

;; :bind keyword
(use-package bind-key)

;; :quelpa keyword
(use-package quelpa)
(use-package quelpa-use-package)

(use-package use-package-secrets
  :ensure nil
  :custom
  (use-package-secrets-default-directory "~/.emacs.d/secrets")
  :quelpa
  (use-package-secrets :repo "a13/use-package-secrets" :fetcher github :version original))

(use-package paradox
  :config
  (paradox-enable))

;; Auto-complete replaced with `company-mode'
;; (use-package auto-complete
;;   :ensure t
;;   :config (ac-config-default))

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package emacs
  :ensure nil
  :init
  (setq system-time-locale "C")
  (set-default 'truncate-lines t)
  (set-scroll-bar-mode 'nil)

  (add-to-list 'auto-mode-alist '("\\.post\\'" . markdown-mode)) ; blog posts assoc with markdown
  (add-to-list 'auto-mode-alist '("\\.page\\'" . markdown-mode))
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e") ;; Emails: Mu4e
  (put 'narrow-to-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (set-face-attribute 'default nil :height 150 :family "Iosevka Extended")
  (set-face-attribute 'fixed-pitch nil :family "Iosevka Extended")
  (set-face-attribute 'variable-pitch nil :family "Iosevka Extended")
  ;; (add-hook 'after-init-hook 'global-company-mode)

  ;; Agda-mode set manually:
  ;; (load-file (let ((coding-system-for-read 'utf-8))
  ;;              (shell-command-to-string "agda-mode locate")))

  (let ((default-directory "~/.emacs.d/lisp-dev/"))
    (normal-top-level-add-subdirs-to-load-path))

  ;; For Rust dynamic modules.
  ;; https://github.com/ubolonton/emacs-module-rs/tree/master/rs-module
  ;;NOTE: Subject to many possible changes/reorganizations.
  (add-to-list 'load-path (file-truename "~/.emacs.d/dynmods"))
  (when (file-exists-p (file-truename "~/emacs.d/dynmods/rs_module.so"))
    (module-load (file-truename "~/emacs.d/dynmods/rs_module.so"))
    (defun load-rs-module (mod-name)
      (rs-module/load
       (file-truename
        (format "~/emacs.d/dynmods/%s.so" mod-name)))))

  :custom
  (scroll-step 1)
  (inhibit-startup-screen t "Don't show splash screen")
  (use-dialog-box nil "Disable dialog boxes")
  (enable-recursive-minibuffers t "Allow minibuffer commands in the minibuffer")
  (indent-tabs-mode nil "Spaces!")
  (delete-old-versions -1)
  (version-control nil)
  ;; (vc-make-backup-files t)
  ;; (vc-follow-symlinks t)
  (backup-directory-alist `(("." . "~/.emacs.d/backups")))
  (auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))
  (ring-bell-function 'ignore)
  (coding-system-for-read 'utf-8)
  (coding-system-for-write 'utf-8)
  (sentence-end-double-space nil)
  (default-fill-column 80)
  (initial-scratch-message ";;; Good morning, Captain!\n\n")
  (debug-on-quit nil)
  (column-number-mode 1)
  (reb-re-syntax 'string)

  :config
  ;;  Appearance
  (use-package modus-operandi-theme
    :ensure t)

  (use-package modus-vivendi-theme
    :ensure t
    :config
    (blink-cursor-mode 0)
    (menu-bar-mode -1)
    (tool-bar-mode -1)
    (load-theme 'modus-vivendi t))

  (setq default-frame-alist
        (append default-frame-alist
                '((cursor-color . "MediumSlateBlue")))))
;; (unsplittable . t)  ; unsplittable does not play nicely with magit


(use-package calc                       ; should I move it to calc.el?
  :config
  (setq var-ff "0.0483776900146")       ; thtr flux conversion factor

  (eval-after-load "calc-units"
    '(progn
       (setq math-additional-units
             '((Bohr  "5.29177249*10^(-11) m"
                      "Bohr radius [ hbar^2/(m*e^2) ]" atU)
               (Eryd  "2.1798741*10^(-18) J"
                      "Rydberg energy [ e^2/(2*a0) ]" atU)
               (Ehart "4.3597482*10^(-18) J"
                      "Hartree energy [ e^2/a0 ]" atU)
               (tryd  "4.83776865318*10^(-17) s"
                      "Rydberg time unit [ hbar/E_Ryd ]" atU)
               (thart "2.41888432659*10^(-17) s"
                      "Hartree time unit [ hbar/E_Hart ]" atU)
               (vryd "1.09384563182*10^(6) m s^(-1)"
                     "Rydberg velocity unit [ a0*E_Ryd/hbar ]" atU)
               (vhart  "2.18769126364*10^(6) m s^(-1)"
                       "Hartree velocity unit [ a0*E_Hart/hbar ]" atU))
             math-units-table nil))))


(use-package all-the-icons
  :config
  (load (expand-file-name "~/Grimoire/org/category-icons.el")))
;; M-x all-the-icons-install-fonts


(use-package mood-line
  :config
  (mood-line-mode))


(use-package files
  :ensure nil
  :hook
  (before-save . delete-trailing-whitespace)
  :custom
  (require-final-newline t)
  ;; backup settings
  (backup-by-copying t)
  ;; (backup-directory-alist
  ;;  '(("." . "~/.cache/emacs/backups")))
  (delete-old-versions t)
  (kept-new-versions 6)
  (kept-old-versions 2)
  (version-control t))

(use-package autorevert
  :ensure nil
  :diminish auto-revert-mode)

(use-package iqa
  :custom
  (iqa-user-init-file (concat user-emacs-directory "README.org") "Edit README.org by default.")
  :config
  (iqa-setup-default))

(use-package cus-edit
  :ensure nil
  :custom
  ;; alternatively, one can use `(make-temp-file "emacs-custom")'
  ;; (custom-file null-device "Don't store customizations")
  (custom-file (make-temp-file "emacs-custom")))

(use-package epa
  :ensure nil
  :custom
  (epg-gpg-program "gpg")
  (epa-pinentry-mode nil))

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'forward))

(use-package which-key
  :ensure t
  :custom
  (which-key-idle-delay 0.5)
  (which-key-add-column-padding 2)
  :config
  (which-key-mode))


(use-package bm
  :ensure t
  :bind (("<C-f2>" . bm-toggle)
         ("<f2>"   . bm-next)
         ("<S-f2>" . bm-previous)))


(use-package yasnippet
  :ensure yasnippet-snippets
  :config
  (setq yas-snippet-dirs
        (append '("~/Grimoire/snippets") yas-snippet-dirs)))


(use-package tramp
  :secret
  (counsel-tramp "~/.passwd/workspaces.el.gpg")
  :defer t
  :config
  ;; (put 'temporary-file-directory 'standard-value '("/tmp"))

  ;;; 4magit remote
  ;; (add-to-list 'tramp-remote-path ws-tramp-remote-path-to-git)
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
                                        ;(setq magit-git-executable "git")

  :custom
  ;; (tramp-backup-directory-alist backup-directory-alist)
  ;; (tramp-default-proxies-alist nil)
  (tramp-default-method "ssh"))


;;; Elisp development tools packages section:
(use-package s
  :ensure nil
  :quelpa (s :repo "magnars/s.el" :fetcher github))
(use-package dash
  :ensure nil
  :quelpa (dash :repo "magnars/dash.el" :fetcher github))
(use-package ht
  :ensure nil
  :quelpa (ht :repo "Wilfred/ht.el" :fetcher github))

(use-package unidecode)                 ; unicode-to ASCII + sanitizer = `slugify' function base

;; (use-package arrows
;;   :ensure nil
;;   :quelpa (arrows :repo "vdikan/arrow-macros-for-emacs" :fetcher github))


(use-package mu4e
  :ensure nil
  :init
  (require 'org-mu4e)
  (require 'smtpmail)
  (setq message-send-mail-function 'smtpmail-send-it
        starttls-use-gnutls t
        smtpmail-stream-type 'ssl
        smtpmail-starttls-credentials
        ;; '(("mail.vivaldi.net" 465 nil nil))
        '(("smtp.vivaldi.net" 465 nil nil))
        ;; smtpmail-default-smtp-server "mail.vivaldi.net"
        ;; smtpmail-smtp-server  "mail.vivaldi.net"
        smtpmail-default-smtp-server "smtp.vivaldi.net"
        smtpmail-smtp-server  "smtp.vivaldi.net"
        smtpmail-smtp-service 465
        smtpmail-debug-info t)
  :custom
  (mu4e-maildir (expand-file-name "~/Maildir/"))
  (mu4e-drafts-folder "/Drafts")
  (mu4e-sent-folder   "/Sent")
  (mu4e-trash-folder  "/Trash")
  (mu4e-refile-folder "/Archive")
  (mu4e-sent-messages-behavior 'sent)
  (mu4e-get-mail-command "offlineimap")
  (user-mail-address "vdikan@vivaldi.net")
  (user-full-name "Vladimir Dikan")
  :config
  (use-package evil-mu4e
    :ensure t)
  (add-to-list 'mu4e-view-actions
               '("ViewInBrowser" . mu4e-action-view-in-browser)
               t)
  (add-hook 'mu4e-compose-mode-hook
            (defun my-do-compose-stuff ()
              "My settings for message composition."
              ;; (org-mu4e-compose-org-mode)
              (flyspell-mode))))


(use-package gnuplot)

(use-package gnuplot-mode)


(use-package nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))


(use-package ob-racket
  :ensure nil
  :quelpa (ob-racket :repo "hasu/emacs-ob-racket" :fetcher github))


(use-package ob-async
  :ensure t)


(use-package org
  ;; to be sure we have latest Org version
  :ensure org-plus-contrib
  :init                                 ; Constant definitions mainly for Org-capture templates
                                        ; funcalls in templates' bodies do not work
  (defconst *lvar-grimoire-dir* "~/Grimoire")
  (defconst *lvar-org-scrot-dir* "~/Grimoire/org/scrot")
  (defconst *lvar-org-roam-dir*  "~/Grimoire/org/roam")
  (defconst *lvar-org-agenda-file* "~/Grimoire/org/roam/agenda.org"
    "General todos and schedule planner.
Used to be part of my Brain setup, now moved into Roam partition.")
  (defconst *lvar-org-journal-file* "~/Grimoire/org/journal.org.gpg"
    "LEGACY: kept for rememberance Dear Diary...")

  (setq org-agenda-files (list *lvar-org-roam-dir*))

  :config
  (require 'ob-clojure)
  (defun insert-worklog-preamble ()
    "Standard preamble to insert for org->latex export."
    (interactive)
    (let ((title (org-element-property
                  :title (org-element-at-point))))
      (beginning-of-buffer)
      (insert (cl-concatenate 'string
                              "\#+LATEX_CLASS: article
\#+LATEX_CLASS_OPTIONS: [11pt, a4paper]
\#+LATEX_HEADER: \\usepackage[margin=0.5in]{geometry}
\#+LATEX_HEADER: \\usepackage[T1,T2A]{fontenc}
\#+LATEX_HEADER: \\setlength\\parindent{0pt}
\#+OPTIONS: email:t author:nil toc:nil num:nil
\#+EMAIL: " *lvar-email-address* "\n"
                              "\#+TITLE: " title "\n"))))

  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (lisp . t)
     (clojure . t)
     (shell . t)
     (gnuplot . t)
     (python . t)
     (fortran . t)
     (racket . t)
     (ditaa . t)))

  :custom
  (org-image-actual-width nil)
  (org-babel-lisp-eval-fn #'sly-eval)
  (org-confirm-babel-evaluate nil)
  (org-startup-indented t)
  (org-hide-leading-stars nil)
  (org-enforce-todo-dependencies t)
  (org-agenda-todo-list-sublevels nil)
  (org-cycle-separator-lines -1)
  (org-log-repeat nil)
  ;; (org-extend-today-until 3)
  (org-agenda-span 1)
  (org-blank-before-new-entry '((heading . t) (plain-list-item . nil)))
  (org-src-tab-acts-natively nil)
  (org-ditaa-jar-path "~/bin/ditaa/ditaa-0.11.0-standalone.jar")
  (org-capture-templates
   '(;; ("w" "worklog"
     ;;  plain (file (lambda ()
     ;;                (concat *lvar-org-dir* "/worklog"
     ;;                        (format-time-string "/%Y-%m-%d/%Y-%m-%d.org"
     ;;                                            (current-time)))))
     ;;  "* %^{entry title}\n %?"
     ;;  :empty-lines 1
     ;;  :unnarrowed t)
     ("t" "Todo" entry (file+headline *lvar-org-agenda-file* "Agenda")
      "* TODO  %?\n  %i\n  %a"))))


(use-package ox-rst)
(use-package ox-reveal
  :custom
  (org-reveal-root
   (format "file://%s/talks/_org_reveal/reveal.js"
           (file-truename *lvar-grimoire-dir*))))


(use-package org-bullets
  :custom
  ;; org-bullets-bullet-list
  ;; default: "◉ ○ ✸ ✿"
  ;; large: ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
  ;; Small: ► • ★ ▸
  (org-bullets-bullet-list '("☢"))
  ;; others: ▼, ↴, ⬎, ⤷,…, and ⋱.
  (org-ellipsis nil)
  ;; (org-ellipsis "↴")
  ;; (org-ellipsis "…")
  :hook
  (org-mode . org-bullets-mode))


(use-package org-auto-tangle
  :defer t
  :init (setf org-auto-tangle-default t)
  :hook (org-mode . org-auto-tangle-mode))


(use-package org-present
  :ensure t ;hide-mode-line
  :hook
  (org-present-mode . hide-mode-line-mode)
  :bind (("s-." . org-present-next)
         ("s-," . org-present-prev)))


(use-package org-books
  :custom (org-books-file
           (file-truename (format "%s/books_revised.org" *lvar-org-roam-dir*))))


(use-package elfeed
  :ensure elfeed-org
  :custom
  ;; Entries older than 2 weeks are marked as read
  (elfeed-search-filter "@2-weeks-ago +unread -reddit")
  :config
  ;; (add-hook 'elfeed-show-mode-hook
  ;;           (lambda ()
  ;;             (set-face-attribute
  ;;              'variable-pitch (selected-frame)
  ;;              :font (font-spec :family "Anonymous Pro" :size 30))))
  (setq elfeed-db-directory "~/Feeds/elfeed-db")
  (add-hook 'elfeed-new-entry-hook
            (elfeed-make-tagger :before "2 weeks ago"
                                :remove 'unread))
  (elfeed-org)
  (setq rmh-elfeed-org-files
        (list
         (file-truename (format "%s/feeds.org" *lvar-org-roam-dir*))
         (file-truename (format "%s/podcasts.org" *lvar-org-roam-dir*)))))


(use-package golden-ratio)

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :custom
  (rainbow-identifiers-cie-l*a*b*-lightness 18)
  (rainbow-identifiers-cie-l*a*b*-saturation 80)
  (rainbow-identifiers-choose-face-function
   #'rainbow-identifiers-cie-l*a*b*-choose-face))
  ;; :hook
  ;; (emacs-lisp-mode . rainbow-identifiers-mode)
  ;; (prog-mode . rainbow-identifiers-mode)


(use-package rainbow-mode
  :diminish rainbow-mode
  :hook prog-mode)

(use-package ag
  :defer t
  :ensure-system-package (ag . silversearcher-ag)
  :custom
  (ag-highlight-search t "Highlight the current search term."))

(use-package wgrep)

(use-package ivy
  :ensure t
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d) ")
  :config
  (ivy-mode 1))

(use-package ivy-yasnippet)

(use-package ivy-bibtex :ensure t)

(use-package counsel)

(use-package smex)

(use-package swiper)

(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-set-undo-system 'undo-tree)
  (evil-mode 1))

(use-package evil-leader)


(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))


(use-package projectile
  :custom
  ;; (projectile-indexing-method 'alien)
  (projectile-completion-system 'ivy)
  :config
  (use-package counsel-projectile
    :ensure t)
  (counsel-projectile-mode)
  (projectile-load-known-projects)
  :diminish projectile-mode)


(use-package paren
  :ensure nil
  :config
  (show-paren-mode t))


(use-package evil-cleverparens
  :hook
  (sly-mode . evil-cleverparens-mode)
  (emacs-lisp-mode . evil-cleverparens-mode)
  (clojure-mode . evil-cleverparens-mode))


(use-package highlight-defined
  :ensure t
  :hook
  (emacs-lisp-mode . highlight-defined-mode))


(use-package highlight-quoted
  :ensure t
  :hook
  (emacs-lisp-mode . highlight-quoted-mode))


(use-package elpy
  :custom (python-shell-interpreter "python3")) ; Python should burn in Hell

;; (use-package lua-mode)


(use-package paredit
  :hook
  (emacs-lisp-mode . paredit-mode)
  (common-lisp-mode . paredit-mode)
  (sly-mode . paredit-mode)
  (lisp-mode . paredit-mode)
  (racket-mode . paredit-mode)
  (scheme-mode . paredit-mode)
  (clojure-mode . paredit-mode))


(use-package parinfer-rust-mode
  :hook
  (emacs-lisp-mode . parinfer-rust-mode)
  (common-lisp-mode . parinfer-rust-mode)
  (sly-mode . parinfer-rust-mode)
  (lisp-mode . parinfer-rust-mode)
  (racket-mode . parinfer-rust-mode)
  (scheme-mode . parinfer-rust-mode)
  (clojure-mode . parinfer-rust-mode)
  :init
  (setq parinfer-rust-auto-download t))


(use-package eros
  :hook
  (emacs-lisp-mode . eros-mode))

(use-package suggest
  :defer t)

(use-package geiser)

(use-package racket-mode
  :custom
  (racket-documentation-search-location 'local))

(use-package scheme
  :custom
  (scheme-program-name "nc bay00 12345")) ; toying w/scheme on Nostromo

(use-package fennel-mode)
  ;; :config
  ;; (setq inferior-lisp-program "/usr/local/bin/fennel")


(use-package haskell-mode)

(use-package idris-mode
  :config
  (idris-define-evil-keys))

;; (use-package arduino-mode :ensure t :pin "melpa")

(use-package company-glsl)

(use-package graphviz-dot-mode)

(use-package yaml-mode)

(use-package dockerfile-mode
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

(use-package sly
  :config
  (setq inferior-lisp-program "sbcl"))


(use-package counsel-dash
  ;;https://github.com/dash-docs-el/counsel-dash
  :custom
  (dash-docs-docsets-path "~/Grimoire/docsets")
  (dash-docs-docsets-url "https://raw.github.com/Kapeli/feeds/master")
  ;; (counsel-dash-docsets-url "https://raw.github.com/Kapeli/feeds/master")
  (dash-docs-use-workaround-for-emacs-bug nil) ; for 26.3 fixes conn bug
  (counsel-dash-browser-func 'browse-url)      ; or 'eww
  :hook
  (c-mode . (lambda () (setq-local counsel-dash-docsets '("C"))))
  (c++-mode . (lambda () (setq-local counsel-dash-docsets '("C++"))))
  (f90-mode . (lambda () (setq-local counsel-dash-docsets '("Fortran" "MPI" "OpenMP"))))
  (fortran-mode . (lambda () (setq-local counsel-dash-docsets '("Fortran" "MPI" "OpenMP"))))
  (scheme-mode . (lambda () (setq-local counsel-dash-docsets '("R5RS"))))
  (sly-mode . (lambda () (setq-local counsel-dash-docsets '("Common Lisp"))))
  (emacs-lisp-mode . (lambda () (setq-local counsel-dash-docsets '("Emacs Lisp"))))
  (dockerfile-mode . (lambda () (setq-local counsel-dash-docsets '("Docker")))))


(use-package counsel-tramp)


(use-package rust-mode :ensure t)
(use-package rustic
  :ensure t
  :config
  ;; uncomment for less flashiness
  (setq lsp-eldoc-hook nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-ui-doc-enable nil)
  ;; (setq lsp-ui-mode-hook nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t))


(use-package lsp-mode
  :secret
  ;; (lsp-register-client "~/.passwd/workspaces.el.gpg")  ; doesn't work dunno why
  (default-remote-fortls-connection "~/.passwd/workspaces.el.gpg") ; explicit defun
  :ensure t
  ;;FIXME: clang support for cpp
  ;; :init
  ;; (require 'lsp-clients)
  :hook
  (f90-mode . lsp-deferred)
  (fortran-mode . lsp-deferred)
  (c++-mode . lsp-deferred)
  (c-mode . lsp-deferred)
  ;; (lsp-mode . lsp-ui-mode)
  :commands (lsp lsp-deferred)
  :custom
  (lsp-enable-snippet t)
  (lsp-auto-guess-root nil)

  ;; NOTE: eldoc clogging fortls trouble, switched off:
  (lsp-eldoc-enable-hover nil)

  (lsp-eldoc-enable-signature-help nil)
  (lsp-eldoc-prefer-signature-help t)
  (lsp-signature-render-all nil)
  (lsp-eldoc-render-all nil)

  (lsp-clients-fortls-args '("--lowercase_intrinsics"
                             "--use_signature_help"
                             "--variable_hover"
                             "--hover_signature"))

  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-server-display-inlay-hints t)

  :config
  (use-package lsp-ui
    :ensure t
    :config
    (set-face-attribute 'lsp-ui-doc-background  nil :height 140
                        :family "Iosevka" :background "MediumPurple4")
    :custom
    ;; lsp-ui-doc
    (lsp-ui-doc-enable t)
    (lsp-ui-doc-header t)
    (lsp-ui-doc-include-signature t)
    (lsp-ui-doc-position 'top) ;; top, bottom, or at-point
    (lsp-ui-doc-max-width 120)
    (lsp-ui-doc-max-height 30)
    (lsp-ui-doc-use-childframe t)
    (lsp-ui-doc-use-webkit nil)

    ;; lsp-ui-sideline
    (lsp-ui-sideline-enable nil)

    ;; lsp-ui-peek
    (lsp-ui-peek-enable t)
    (lsp-ui-peek-peek-height 25)
    (lsp-ui-peek-list-width 35)
    (lsp-ui-peek-fontify 'on-demand))

  ;; never, on-demand, or always
  ;; syntax checking
  ;; (lsp-prefer-flymake nil)
  ;; :after flycheck

  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
  (add-hook 'lsp-mode-hook 'yas-minor-mode)

  (add-to-list 'lsp-language-id-configuration '(fortran-mode . "fortran"))
  (add-to-list 'lsp-language-id-configuration '(f90-mode . "fortran"))
  (add-to-list 'lsp-language-id-configuration '(c-mode . "c")))

;; Lsp on remote: keep these commented for possible reference:
;; (defun default-remote-fortls-connection ()
;;   "Use when connecting to fortls on default remote."
;;   (cons ws-remote-fortls lsp-clients-fortls-args))

;; (lsp-register-client
;;  (make-lsp-client :new-connection
;;                   (lsp-tramp-connection #'default-remote-fortls-connection)
;;                   ;; (lsp-tramp-connection (lambda () (cons ws-remote-fortls
;;                   ;;                                        lsp-clients-fortls-args)))
;;                   :major-modes '(fortran-mode f90-mode)
;;                   :remote? t
;;                   :priority 1
;;                   :server-id 'fortls-remote))


(use-package erc
  :secret
  (go-social-with-bitlbee "~/.passwd/bitlbee.el.gpg")
  :config
  (defun go-social-with-bitlbee ()
    "Connect to IM networks using bitlbee."
    (interactive)
    (erc :server "localhost" :port 6667 :nick bitlbee-username))

  (defun bitlbee-identify ()
    (when (and (string= "localhost" erc-session-server)
               (string= "&bitlbee" (buffer-name)))
      (erc-message "PRIVMSG" (format "%s identify %s %s"
                                     (erc-default-target)
                                     bitlbee-username
                                     bitlbee-password))))

  (add-hook 'erc-join-hook #'bitlbee-identify))


;;; (so far) manually added `contrib`. From telega.el thread:
;; > you need to load it, before use
;; > add contrib/ to your load-path and then
;; > (require 'telega-status-history)
;; > after this you can use M-x telega-status-history-mode RET directly
;; > or add this func to the telega-load-hook
(use-package telega
  :load-path "~/install/telega.el/telega.el"
  :commands (telega)
  :defer t
  :custom
  (telega-mode-line-mode 1)
  :config
  (require 'ol-telega))                 ; <- can also play with shortened urls


;;; Declare/describe custom shortcuts with `general' and `which-key'
(use-package general
  :ensure t
  :config
  (general-define-key
   ;; replace default keybindings
   "C-s" 'swiper             ; search for string in current buffer
   "M-x" 'counsel-M-x)       ; replace default M-x with ivy backend
  ;; "M-]" 'scheme-smart-complete)

  (general-create-definer my-leader-def
    ;; :prefix my-leader
    :prefix "M-SPC")

  (general-create-definer my-local-leader-def
    ;; :prefix my-local-leader
    :prefix "M-SPC m")

  (my-leader-def
    :states '(normal visual emacs)

    ;; Root
    "/"   'counsel-ag
    "TAB" 'dired-sidebar-toggle-sidebar
    ;; "TAB" '(switch-to-next-buffer :which-key "next buffer")

    ;; Windows
    "w"   '(:ignore t :which-key "Windows")
    "ww"  'other-window
    "wh"  'split-window-below
    "wv"  'split-window-right
    "wo"  'delete-other-windows
    "wd"  'delete-window

    ;; Commands
    "c"   '(:ignore t :which-key "Commands")
    "cc"  'org-capture
    "cf"  'flyspell-correct-word-before-point
    "cd"  '(:ignore t :which-key "Counsel-Dash")
    "cda"  'dash-docs-activate-docset
    "cdd"  'counsel-dash-at-point
    "cl"  'org-store-link
    "ct"  'counsel-tramp
    "cy"  '(:ignore t :which-key "Yas")
    "cyy" 'yas-insert-snippet
    "cyn" 'yas-new-snippet
    "cyv" 'yas-visit-snippet-file

    ;; Applications
    "a"   '(:ignore t :which-key "Applications")
    "ad"  'dired
    "am"  'mu4e
    ;; "aa"  'org-ref                      ; spawns HELM-ish interface
    "af"  'elfeed
    "ao"  'org-agenda
    "at"  'telega
    "ae"  'go-social-with-bitlbee
    "as"  '(:ignore t :which-key "Shell selection")
    "ass" 'shell
    "ase" 'eshell
    "asa" 'ansi-term

    ;; Projects
    "p"   '(:keymap projectile-command-map
                    :package projectile
                    :which-key "Projectile (Counsel)")
    ;; ...versions
    ;; "v"   '(:keymap vc-prefix-map :which-key "Version Control")

    ;; Smerge
    "s" '(:keymap smerge-basic-map
                  :package smerge-mode
                  :which-key "Smerge")

    ;; Toggles
    "t"   '(:ignore t :which-key "Toggles")
    "tg"  'golden-ratio-mode
    "tl"  'toggle-truncate-lines
    "ts"  'toggle-scroll-bar
    "tr"  'rainbow-identifiers-mode

    ;; Buffers
    "b"   '(:ignore t :which-key "Buffers")
    "bb"  'ivy-switch-buffer
    "bk"  'kill-buffer
    "ba"  'auto-fill-mode
    "bf"  'flyspell-buffer

    ;; Shortcuts
    "e"   '(:ignore t :which-key "Edit")
    "ed"  '((lambda() (interactive)
              (switch-to-buffer
               (find-file-noselect "~/.emacs.d/init.el")))
            :which-key "dotemacs config")
    "es"  '((lambda() (interactive)
              (switch-to-buffer
               (find-file-noselect "~/.stumpwmrc")))
            :which-key "stumpwm config")

    ;; Org-mode
    ;; Contains links to Grimoire
    "o"   '(:ignore t :which-key "Open local")
    "ot"  '((lambda() (interactive)
              (switch-to-buffer
               (find-file-noselect *lvar-org-agenda-file*)))
            :which-key "Todos and Agenda")
    "oj"  '((lambda() (interactive)
              (switch-to-buffer
               (find-file-noselect
                (format "%s/org/journal.org.gpg" *lvar-grimoire-dir*))))
            :which-key "my olde Journal (for reference, no new edits)")
    "or" '((lambda() (interactive)
             (switch-to-buffer
              (find-file-noselect "~/Refs/phd.bib")))
           :which-key "Main Bibtex file")
    "on" '((lambda() (interactive)
             (switch-to-buffer
              (find-file-noselect
               (file-truename (format "%s/papers.org" *lvar-org-roam-dir*)))))
           :which-key "Research Notes")


    ;; LSP-enhanced programming control
    "l"   '(:ignore t :which-key "Language Commands")
    ;; NOTE: not using flycheck at this point
    ;; "ll"   '(:keymap flycheck-command-map
    ;;          :package flycheck
    ;;          :which-key "Flycheck")
    "lm" 'imenu
    "lq" 'lsp-shutdown-workspace
    "lw" 'lsp-restart-workspace
    "lh" 'lsp-describe-thing-at-point
    "lr" 'lsp-rename
    "ld" 'lsp-find-definition
    "li" 'lsp-find-references
    "lp" 'lsp-ui-peek-find-references
    "lu" 'lsp-ui-mode))


(use-package browse-kill-ring
  :general
  (my-leader-def
    :states '(normal visual emacs)
    "y" 'browse-kill-ring))


(use-package magit
  :ensure t
  :general
  (my-leader-def
    :states '(normal visual emacs)
    "g"   'magit-status
    "M-g" 'magit-dispatch))


(use-package org-ref
  :after (org ivy-bibtex) ;FIXME :after + :defer + 'org-ref-ivy
  :general                ; first time I use :general kw in 'use-package
  (:keymaps 'org-mode-map "C-c ]" 'org-ref-insert-link)
  :custom
  (bibtex-completion-bibliography '("~/Refs/phd.bib" ; default references file
                                    "~/Refs/cs.bib"
                                    "~/Refs/math.bib"
                                    "~/Refs/formal.bib"))
  (bibtex-completion-library-path '("~/Refs/pdfs/"))
  (bibtex-completion-notes-path
   (file-truename (format "%s/papers.org" *lvar-org-roam-dir*)))
  (bibtex-completion-additional-search-fields '(keywords))
  (bibtex-completion-pdf-open-function (lambda (fpath)
                                         (call-process "atril" nil 0 nil fpath)))
  ;; autokey formatting:
  (bibtex-autokey-year-length 4)
  (bibtex-autokey-name-year-separator "-")
  (bibtex-autokey-year-title-separator "-")
  (bibtex-autokey-titleword-separator "-")
  (bibtex-autokey-titlewords 2)
  (bibtex-autokey-titlewords-stretch 1)
  (bibtex-autokey-titleword-length 5)
  ;; Ivy backend:
  (org-ref-insert-link-function 'org-ref-insert-link-hydra/body)
  (org-ref-insert-cite-function 'org-ref-cite-insert-ivy)
  (org-ref-insert-label-function 'org-ref-insert-label-link)
  (org-ref-insert-ref-function 'org-ref-insert-ref-link)
  (org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body)))
  :init (require 'org-ref-ivy))


(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename *lvar-org-roam-dir*))
  (org-roam-db-location
   (file-truename (format "%s/org/org-roam.db" *lvar-grimoire-dir*)))

  ;; Daily note taking
  (org-roam-dailies-directory "daily/")
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+head "%<%Y-%m-%d>.org"
                         "#+title: %<%Y-%m-%d>\n"))))

  ;; Generic capture templates. Mind the subdirs in
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :target (file+head "${slug}.org"
                         "#+title: ${title}\n#+auto_tangle: nil\n")
      :unnarrowed t)
     ("l" "Lit-Notes" plain "%?"
      :target (file+head "literature/${slug}.org"
                         "#+category: books\n#+title: ${title}\n#+auto_tangle: nil\n#+filetags: read\n")
      :unnarrowed t)
     ("m" "Media" plain "%?"
      :target (file+head "media/${slug}.org"
                         "#+category: media\n#+title: ${title}\n#+auto_tangle: nil\n#+filetags: media\n")
      :unnarrowed t)
     ("k" "Kata-Log" plain "%?"
      :target (file+head "kata-log/${slug}.org"
                         "#+title: ${title}\n#+auto_tangle: nil\n#+filetags: kata\n")
      :unnarrowed t)
     ("p" "Projects" plain "%?"
      :target (file+head "projects/${slug}.org"
                         "#+category: projects\n#+title: ${title}\n#+auto_tangle: nil\n#+filetags: project\n")
      :unnarrowed t)
     ("g" "Gaming" plain "%?"
      :target (file+head "gaming/${slug}.org"
                         "#+category: prpgs\n#+title: ${title}\n#+auto_tangle: nil\n#+filetags: gaming\n")
      :unnarrowed t)
     ("a" "Art" plain "%?"
      :target (file+head "art/${slug}.org"
                         "#+title: ${title}\n#+auto_tangle: nil\n#+filetags: art\n")
      :unnarrowed t)
     ("r" "Research" plain "%?"
      :target (file+head "research/${slug}.org"
                         "#+title: ${title}\n#+auto_tangle: nil\n#+filetags: research\n")
      :unnarrowed t)
     ("t" "Engineering & Tech" plain "%?"
      :target (file+head "tech/${slug}.org"
                         "#+title: ${title}\n#+auto_tangle: nil\n#+filetags: tech\n")
      :unnarrowed t)
     ("u" "Setup & Utilities" plain "%?"
      :target (file+head "setup-utils/${slug}.org"
                         "#+title: ${title}\n#+auto_tangle: nil\n#+filetags: setup\n")
      :unnarrowed t)))

  :config
  (require 'my-org)
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-direction)
                 (direction . right)
                 (window-width . 0.26)
                 (window-height . fit-window-to-buffer)))
  (org-roam-db-autosync-mode)
  :general
  (my-leader-def
    :states '(normal visual emacs)
    "ar"  '(:ignore t :which-key "Org-Roam")
    "arr" 'org-roam-node-find
    "arh" 'my-org/roamify-header
    "ari" 'org-roam-node-insert
    "arb" 'org-roam-buffer-toggle
    "arc" 'org-roam-capture
    "ard" 'org-roam-dailies-goto-date
    "ar." 'org-roam-dailies-find-today))


(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory org-roam-directory))


(use-package org-download
  :ensure t
  :defer t
  :after org
  :init
  (with-eval-after-load 'org (org-download-enable))
  :custom
  (org-download-screenshot-method "mate-screenshot -a")
  (org-download-image-org-width 800)
  ;; :bind
  ;; (:map org-mode-map
  ;;       (("s-Y" . org-download-screenshot)
  ;;        ("s-y" . org-download-yank)))
  :config
  (setq-default org-download-image-dir *lvar-org-scrot-dir*))


(use-package proof-general)

(use-package company-coq
  :hook (coq-mode . company-coq-mode))
