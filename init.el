;;; First, load machine-specific variables from linked `local-settings.el'
(let ((local-settings-file (locate-user-emacs-file "local-settings.el")))
  (if (file-exists-p local-settings-file)
      (load local-settings-file)))


;;; Declarative setup with `use-package'.
(require 'package)
(setq package-archives
      `(,@package-archives
        ("melpa" . "https://melpa.org/packages/")
        ;; ("marmalade" . "https://marmalade-repo.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ;; ("user42" . "https://download.tuxfamily.org/user42/elpa/packages/")
        ;; ("emacswiki" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/emacswiki/")
        ;; ("sunrise" . "http://joseito.republika.pl/sunrise-commander/")
        ))
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
  (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e") ;; Emails: Mu4e
  (setq system-time-locale "C")
  (put 'narrow-to-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (set-face-attribute 'region nil :background "LightSteelBlue")
  (set-face-attribute 'mode-line           nil :background "dark slate blue" :foreground "gainsboro")
  (set-face-attribute 'mode-line-buffer-id nil :background "DodgerBlue3" :foreground "white smoke")
  (set-face-attribute 'mode-line-highlight nil :box nil :background "steel blue" :foreground "white")
  (set-face-attribute 'mode-line-inactive  nil :inherit 'default)
  (set-face-attribute 'default nil :height *lvar-default-font-height*)
  ;; (add-hook 'after-init-hook 'global-company-mode)
  :custom
  (scroll-step 1)
  (inhibit-startup-screen t "Don't show splash screen")
  (use-dialog-box nil "Disable dialog boxes")
  (enable-recursive-minibuffers t "Allow minibuffer commands in the minibuffer")
  (indent-tabs-mode nil "Spaces!")
  (delete-old-versions -1)
  (version-control t)
  (vc-make-backup-files t)
  (backup-directory-alist `(("." . "~/.emacs.d/backups")))
  (vc-follow-symlinks t)
  (auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))
  (ring-bell-function 'ignore)
  (coding-system-for-read 'utf-8)
  (coding-system-for-write 'utf-8)
  (sentence-end-double-space nil)
  (default-fill-column 80)
  (initial-scratch-message ";;; Good morning, Captain!\n\n")
  (debug-on-quit nil)
  (column-number-mode 1)
  (reb-re-syntax 'string))


;;  Appearance
(blink-cursor-mode 0)
(menu-bar-mode -1)
(tool-bar-mode -1)
(load-theme 'tango 'no-confirm)
;; (setq system-time-locale "C")
(setq default-frame-alist
      (append default-frame-alist
              '((background-color . "#efeff9")
                (cursor-color . "DodgerBlue3"))))


;; (use-package vscode-icon
;;   :ensure t
;;   :commands (vscode-icon-for-file)
;;   :config
;;   (setq vscode-icon-size 23))


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
  (custom-file null-device "Don't store customizations"))

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
  :ensure yasnippet-snippets)


(use-package tramp
  :defer t
  :config
  ;; (put 'temporary-file-directory 'standard-value '("/tmp"))
  :custom
  ;; (tramp-backup-directory-alist backup-directory-alist)
  ;; (tramp-default-proxies-alist nil)
  (tramp-default-method "ssh"))


(use-package magit
  :ensure t
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch))
  :config
  (global-magit-file-mode))


(use-package evil-magit
  :after (magit evil))


(use-package mu4e
  :ensure nil
  :init
  (require 'smtpmail)
  (setq message-send-mail-function 'smtpmail-send-it
        starttls-use-gnutls t
        smtpmail-stream-type 'ssl
        smtpmail-starttls-credentials
        '(("smtp.vivaldi.net" 465 nil nil))
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
    :ensure t))


(use-package gnuplot)

(use-package gnuplot-mode)


(use-package nov)  ; epub reader


(use-package ob-racket
  :ensure nil
  :quelpa (ob-racket :repo "hasu/emacs-ob-racket" :fetcher github))


(use-package org
  ;; to be sure we have latest Org version
  :ensure org-plus-contrib
  :init                                 ; Constant definitions mainly for Org-capture templates
                                        ; funcalls in templates' bodies do not work
  (defconst *lvar-org-agenda-file*
    (format "%s/org/agenda.org.gpg" *lvar-grimoire-dir*)
    "General todos and schedule planner.")
  (defconst *lvar-org-journal-file*
    (format "%s/org/journal.org.gpg" *lvar-grimoire-dir*)
    "Dear Diary...")
  (defconst *lvar-org-notes-file*
    (format "%s/org/notes.org.gpg" *lvar-grimoire-dir*)
    "Research notes file")
  (setq org-agenda-files
        (list *lvar-org-agenda-file*
              *lvar-org-journal-file*
              *lvar-org-notes-file*))

  :config
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

  (defun worklog-capture-hook ()
    "Hook to pair `worklog' and `journal' capture templates."
    (when (string= "w" (plist-get org-capture-plist :key))
      (org-capture-string
       (concat "file:" "../worklog"
               (format-time-string "/%Y/%m/%d/%d-%m-%Y.org.gpg"
                                   (current-time))) "l")))
  (add-hook 'org-capture-mode-hook #'worklog-capture-hook)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (gnuplot . t)
     (python . t)
     (fortran . t)
     (racket . t)
     (ditaa . t)))

  :custom
  (org-confirm-babel-evaluate nil)
  (org-startup-indented t)
  (org-hide-leading-stars nil)
  (org-enforce-todo-dependencies t)
  (org-agenda-todo-list-sublevels nil)
  (org-log-repeat nil)
  ;; (org-extend-today-until 3)
  (org-agenda-span 1)
  (org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))
  (org-src-tab-acts-natively nil)
  (org-ditaa-jar-path "/usr/bin/ditaa")
  (org-capture-templates
   '(("w" "Grimoire worklog"
      plain (file (lambda ()
                    (concat *lvar-grimoire-dir* "/worklog"
                            (format-time-string "/%Y/%m/%d/%d-%m-%Y.org.gpg"
                                                (current-time)))))
      "* %^{entry title}\n %?"
      :empty-lines 1
      :unnarrowed t)
     ("t" "Todo" entry (file+headline *lvar-org-agenda-file* "Tasks")
      "* TODO  %?\n  %i\n  %a")
     ("j" "Journal" entry (file+datetree *lvar-org-journal-file*)
      "* %?\n\n  %a" :empty-lines 1)
     ("q" "Quote to Journal" entry (file+datetree *lvar-org-journal-file*)
      "* \n#+begin_quote\n %?\n%i\n#+end_quote\nEntered on %U\n  %a" :empty-lines 1)
     ("l" "(hooked) Link worklog to journal" entry
      (file+datetree *lvar-org-journal-file*)
      "* Worklog entry: %u  :work:log: \n %i\n"
      :empty-lines 1)))
  )


(use-package org-bullets
  :custom
  ;; org-bullets-bullet-list
  ;; default: "◉ ○ ✸ ✿"
  ;; large: ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
  ;; Small: ► • ★ ▸
  (org-bullets-bullet-list '("☢"))
  ;; others: ▼, ↴, ⬎, ⤷,…, and ⋱.
  (org-ellipsis "↴")
  ;; (org-ellipsis "…")
  :hook
  (org-mode . org-bullets-mode))


(use-package elfeed
  :ensure elfeed-org
  :config
  (add-hook 'elfeed-show-mode-hook
            (lambda ()
              (set-face-attribute 'variable-pitch (selected-frame)
                                  :font (font-spec :family "LiberationMono"
                                                   :size 20))))
  ;; Entries older than 2 weeks are marked as read
  (add-hook 'elfeed-new-entry-hook
            (elfeed-make-tagger :before "2 weeks ago"
                                :remove 'unread))
  (elfeed-org))


(use-package pdf-tools
  :pin manual ;; manually update
  ;; :quelpa (pdf-tools :repo "politza/pdf-tools" :fetcher github)
  :config
  ;; initialise
  (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  (setq pdf-view-resize-factor 1.2))


(use-package ivy-bibtex
  :ensure t
  :custom
  (ivy-re-builders-alist
   '((ivy-bibtex . ivy--regex-ignore-order)
     (t . ivy--regex-plus)))
  (bibtex-completion-notes-path
   (format "%s/org/notes.org.gpg" *lvar-grimoire-dir*))
  (bibtex-completion-bibliography *lvar-bibtex-list*)
  (bibtex-completion-pdf-field "file")
  (bibtex-completion-notes-template-one-file
   "\n* ${author-or-editor} (${year}): ${title}
:PROPERTIES:
:Custom_ID: ${=key=}
:Cite_IDs:
:AUTHOR: ${author}
:JOURNAL: ${journaltitle}
:YEAR: ${year}
:DOI: ${doi}
:DIGRAPH_OUT: t
:DIGRAPH_CLUSTER: nil
:DIGRAPH_SUMMARY:
:END:\n\n"))


(use-package golden-ratio)

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package rainbow-identifiers
  :custom
  (rainbow-identifiers-cie-l*a*b*-lightness 18)
  (rainbow-identifiers-cie-l*a*b*-saturation 80)
  (rainbow-identifiers-choose-face-function
   #'rainbow-identifiers-cie-l*a*b*-choose-face)
  :hook
  (emacs-lisp-mode . rainbow-identifiers-mode)
  ;; (prog-mode . rainbow-identifiers-mode)
  )

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
  :ensure ivy-yasnippet
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d) ")
  :config
  (ivy-mode 1))

(use-package ivy-bibtex)

(use-package counsel)

(use-package smex)

(use-package swiper)


(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))


(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))


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
  (projectile-load-known-projects))


(use-package paren
  :ensure nil
  :config
  (show-paren-mode t))

(use-package electric-pair
  :ensure nil
  :hook
  (emacs-lisp-mode . electric-pair-mode))

(use-package highlight-defined
  :ensure t
  :hook
  (emacs-lisp-mode . highlight-defined-mode))

(use-package highlight-quoted
  :ensure t
  :hook
  (emacs-lisp-mode . highlight-quoted-mode))


;; Hack to install julia-mode: AucTEX needs this
(defconst debian-emacs-flavor 'emacs25
  "A symbol representing the particular debian flavor of emacs running.
 Something like 'emacs20, 'xemacs20, etc.")
;; This should be corrected, because:
;; https://stackoverflow.com/questions/7311268/symbols-value-as-variable-is-void-debian-emacs-flavor-when-running-ispell-on-t

(use-package julia-mode
  :ensure julia-repl
  :config
  (setenv "JULIA_NUM_THREADS" "2")
  (add-hook 'julia-mode-hook 'julia-repl-mode)
  ;; :hook
  ;; (julia-mode-hook . julia-repl-mode)
  )


(use-package elpy)                      ;  Python should burn in Hell

(use-package lua-mode)


(use-package parinfer
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
            pretty-parens  ; different paren styles for different modes.
            evil           ; If you use Evil.
            ;lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
            paredit        ; Introduce some paredit commands.
            smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
            smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'racket-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))


(use-package cider
  :defer t
  ;; :custom
  ;; (cider-repl-display-help-banner nil)
  ;; :config
  ;; sadly, we can't use :diminish keyword here, yet
  ;; (diminish 'cider-mode
  ;;           '(:eval (format " 🍏%s" (cider--modeline-info))))
  )


(use-package eros
  :hook
  (emacs-lisp-mode . eros-mode)
  (racket-mode . eros-mode)
  ;; (fennel-mode . eros-mode)
  )

(use-package suggest
  :defer t)


(use-package racket-mode)

(use-package fennel-mode
  ;; :config
  ;; (setq inferior-lisp-program "/usr/local/bin/fennel")
  )

(use-package haskell-mode)


(use-package arduino-mode :ensure t :pin "melpa")


(use-package slime
  ;; :disabled
  :ensure slime-company
  :config
  (load (expand-file-name "~/quicklisp/slime-helper.el")) ; comes from:
  ;; https://kaashif.co.uk/2015/06/28/hacking-stumpwm-with-common-lisp/

  (setq inferior-lisp-program "sbcl"
        lisp-indent-function 'common-lisp-indent-function
        slime-complete-symbol-function 'slime-fuzzy-complete-symbol
        slime-startup-animation nil)
  ;; (slime-setup '(slime-fancy))
  (slime-setup '(slime-company))
  (setq slime-net-coding-system 'utf-8-unix))


;; (use-package flycheck
;;   :config
;;   (add-hook 'after-init-hook #'global-flycheck-mode))


;; NOTE: a bug in fortran-language-server was fixed in v.1.10.2
(use-package lsp-mode
  :hook
  (f90-mode . lsp-deferred)
  (fortran-mode . lsp-deferred)
  (lsp-mode . lsp-ui-mode)
  :commands (lsp lsp-deferred)
  :custom
  ;; (lsp-enable-snippet t)
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

  :config
  (use-package lsp-ui
    :ensure t
    :config
    (set-face-attribute 'lsp-ui-doc-background  nil :background "PowderBlue")
    :custom
    ;; lsp-ui-doc
    (lsp-ui-doc-enable t)
    (lsp-ui-doc-header t)
    (lsp-ui-doc-include-signature t)
    (lsp-ui-doc-position 'top) ;; top, bottom, or at-point
    (lsp-ui-doc-max-width 120)
    (lsp-ui-doc-max-height 30)
    (lsp-ui-doc-use-childframe nil)
    (lsp-ui-doc-use-webkit nil)

    ;; lsp-ui-sideline
    (lsp-ui-sideline-enable nil)

    ;; lsp-ui-peek
    (lsp-ui-peek-enable t)
    (lsp-ui-peek-peek-height 25)
    (lsp-ui-peek-list-width 35)
    (lsp-ui-peek-fontify 'on-demand)) ;; never, on-demand, or always

  ;; syntax checking
  ;; (lsp-prefer-flymake nil)
  ;; :after flycheck

  (add-to-list 'lsp-language-id-configuration '(fortran-mode . "fortran"))
  (push 'company-lsp company-backends))


(use-package company-lsp
  :custom
  (company-lsp-cache-candidates t) ;; auto, t(always using a cache), or nil
  (company-lsp-async t)
  (company-lsp-enable-snippet t)
  (company-lsp-enable-recompletion t))


(use-package telega
  :quelpa (telega :repo "zevlg/telega.el" :fetcher github)
  :commands (telega)
  :defer t
  :custom
  (telega-mode-line-mode 1))


;;; Declare/describe custom shortcuts with `general' and `which-key'
;; NOTE: Wanna drop `general' in favor to `use-package' bindings at some point.
(use-package general
  :ensure t
  :config
  (general-define-key
   ;; replace default keybindings
   "C-s" 'swiper             ; search for string in current buffer
   "M-x" 'counsel-M-x        ; replace default M-x with ivy backend
   "M-]" 'scheme-smart-complete)

  (general-create-definer my-leader-def
      ;; :prefix my-leader
      :prefix "SPC")

  (general-create-definer my-local-leader-def
      ;; :prefix my-local-leader
      :prefix "SPC m")

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

    ;; Applications
    "a"   '(:ignore t :which-key "Applications")
    "ad"  'dired
    "ab"  'ivy-bibtex
    "ao"  'org-agenda
    "ar"  're-builder
    "as"  '(:ignore t :which-key "Shell selection")
    "ass" 'shell
    "ase" 'eshell
    "asa" 'ansi-term

    ;; Projects
    "p"   '(:keymap projectile-command-map
            :package projectile
            :which-key "Projectile (Counsel)")
    ;; ...versions
    "v"   '(:keymap vc-prefix-map :which-key "Version Control")

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

    ;; Shortcuts
    "e"   '(:ignore t :which-key "Edit")
    "ed"  '((lambda() (interactive)
                   (switch-to-buffer
                    (find-file-noselect "~/.emacs.d/init.el")))
            :which-key "dotemacs config")
    "el"  '((lambda() (interactive)
                   (switch-to-buffer
                    (find-file-noselect "~/.emacs.d/local-settings.el")))
            :which-key "local emacs config")
    "es"  '((lambda() (interactive)
                   (switch-to-buffer
                    (find-file-noselect "~/.stumpwmrc")))
            :which-key "stumpwm config")

    ;; Org-mode
    ;; Contains links to Grimoire
    "o"   '(:ignore t :which-key "Open local")
    "ot"  '((lambda() (interactive)
                   (switch-to-buffer
                    (find-file-noselect
                     (format "%s/org/agenda.org.gpg" *lvar-grimoire-dir*))))
            :which-key "Todos and Agenda")
    "oj"  '((lambda() (interactive)
                   (switch-to-buffer
                    (find-file-noselect
                     (format "%s/org/journal.org.gpg" *lvar-grimoire-dir*))))
            :which-key "my Journal")
    "or" '((lambda() (interactive)
                  (switch-to-buffer
                   (find-file-noselect
                    (format "%s/org/notes.org.gpg" *lvar-grimoire-dir*))))
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


;; LSP for selected programming modes
;; FIXME: doesn't hook-up by 'my-local-leader-def
;; (my-local-leader-def
;;     :states '(normal visual emacs)
;;   :keymaps '(f90-mode-map fortran-mode-map)
;; "m" 'imenu
;; "q" 'lsp-shutdown-workspace
;; "w" 'lsp-restart-workspace
;; "h" 'lsp-describe-thing-at-point
;; "r" 'lsp-rename
;; "d" 'lsp-find-definition
;; "i" 'lsp-find-references
;; "p" 'lsp-ui-peek-find-references))

;; (put 'dired-find-alternate-file 'disabled nil)

;; (setq browse-url-browser-function 'browse-url-generic
;;       browse-url-generic-program "sensible-browser")
