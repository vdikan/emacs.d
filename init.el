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
  (setq system-time-locale "C")
  (put 'narrow-to-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
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
  (delete-old-versions -1 )
  (version-control t )
  (vc-make-backup-files t )
  (backup-directory-alist `(("." . "~/.emacs.d/backups")) )
  (vc-follow-symlinks t )
  (auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) )
  (ring-bell-function 'ignore )
  (coding-system-for-read 'utf-8 )
  (coding-system-for-write 'utf-8 )
  (sentence-end-double-space nil)
  (default-fill-column 80)
  (initial-scratch-message ";;; Good morning, Captain!\n\n")
  (debug-on-quit nil)
  (column-number-mode 1))


;;  Appearance
(blink-cursor-mode 0)
(menu-bar-mode -1)
(tool-bar-mode -1)
(load-theme 'tango 'no-confirm)
(setq system-time-locale "C")           ; English locale everywhere
(setq default-frame-alist
      (append default-frame-alist
       '((background-color . "#efeff9")
         (cursor-color . "DodgerBlue3"))))


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

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (gnuplot . t)
     (python . t)
     (fortran . t)
     (racket . t)))

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
  (elfeed-org))


(use-package pdf-tools
  :pin manual ;; manually update
  :config
  ;; initialise
  (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward))


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
  (projectile-completion-system 'ivy))

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


(use-package lua-mode)


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
  (racket-mode . eros-mode))

(use-package suggest
  :defer t)


(use-package racket-mode)


(use-package slime
  :disabled
  :config
  (setq inferior-lisp-program "sbcl"
        lisp-indent-function 'common-lisp-indent-function
        slime-complete-symbol-function 'slime-fuzzy-complete-symbol
        slime-startup-animation nil)
  (slime-setup '(slime-fancy))
  (setq slime-net-coding-system 'utf-8-unix))


(use-package fortran-tags
  :ensure nil
  :quelpa (fortran-tags :repo "vdikan/fortran-tags" :fetcher github)
  :config
  (setenv "PATH"
          (concat quelpa-dir "/build/fortran-tags:"
                  (getenv "PATH"))))


(defun generate-fortran-project-tags ()
  "Generate FORTAGS file used by `fortran-tags` in the project root."
  (interactive)
  (compile
   (concat "fortran-tags.py -g "
           (projectile-project-root) "Src/**/*.F "
           (projectile-project-root) "Src/**/*.F90 "
           ;; " -o " (file-name-directory buffer-file-name) "TAGS"))
           " -o " (projectile-project-root) "FORTAGS")))


(use-package f90
  :custom
  (f90-if-indent 2
   f90-type-indent 2
   f90-program-indent 2
   f90-continuation-indent 2
   f90-comment-region "!"
   f90-break-before-delimiters t
   f90-beginning-ampersand nil
   )
  :hook
  (fortran-mode . (lambda ()
                    (setq comment-start "!!")
                    (setq fortran-tags-path
                          (concat (projectile-project-root) "FORTAGS"))))
  (f90-mode . (lambda ()
                (setq comment-start "!!")
                ;; f90-directive-comment-re "!!$"
                ;; f90-indented-comment-re "!!"
                (setq fortran-tags-path
                      (concat (projectile-project-root) "FORTAGS")))))


;;; Declare/describe custom shortcuts with `general' and `which-key'
(use-package general
  :ensure t
  :config
  (general-define-key
   ;; replace default keybindings
   "C-s" 'swiper             ; search for string in current buffer
   "M-x" 'counsel-M-x        ; replace default M-x with ivy backend
   "M-]" 'scheme-smart-complete
   ))

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
  "TAB" '(switch-to-next-buffer :which-key "next buffer")

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

  ;; Projects
  "p"   '(:keymap projectile-command-map :package projectile
          :which-key "Projectile")
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
          :which-key "local settings file")

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
         :which-key "Research Notes"))


(my-local-leader-def                  ; Fortran
  :states 'normal
  :keymaps '(fortran-mode-map f90-mode-map)
  "f" 'fortran-find-tag
  "p" 'fortran-pop-tag-mark
  "n" 'fortran-goto-next
  "g" 'fortran-find-proc-calls
  "d" 'fortran-procedures-in-buffer)
