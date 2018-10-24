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

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(put 'use-package 'lisp-indent-function 1)
(setq use-package-always-ensure t)

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

(use-package emacs
  :ensure nil
  :init
  (put 'narrow-to-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (set-face-attribute 'default nil :height 180)
  (set-face-attribute 'mode-line           nil :background "dark slate blue" :foreground "gainsboro")
  (set-face-attribute 'mode-line-buffer-id nil :background "RoyalBlue3" :foreground "white smoke")
  (set-face-attribute 'mode-line-highlight nil :box nil :background "steel blue" :foreground "white")
  (set-face-attribute 'mode-line-inactive  nil :inherit 'default)
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
  (column-number-mode 1)
  )

;;; Appearance
(blink-cursor-mode 0)
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(load-theme 'tango 'no-confirm)

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

(use-package org
  ;; to be sure we have latest Org version
  :ensure org-plus-contrib
  :custom
  (org-src-tab-acts-natively t))

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

(use-package counsel)

(use-package swiper)

(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package projectile
  :custom
  ;; (projectile-indexing-method 'alien)
  (projectile-completion-system 'ivy))

(defun generate-fortran-project-tags ()  ;; TODO: hide in fortran-tags use-package
  "Generate FORTAGS file used by `fortran-tags` in the project root."
  (interactive)
  (compile
   (concat "fortran-tags.py -g "
           ;; NOTE: Fortags has troubles with lowcase file extensions. Report this.
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
  (f90-mode . (lambda ()
                (setq comment-start "!!")
                ;; f90-directive-comment-re "!!$"
                ;; f90-indented-comment-re "!!"
                ;; (generate-fortran-tags)
                (setq fortran-tags-path  ;; doesnt work?
                      (concat (projectile-project-root) "FORTAGS"))
                )))

;; TODO fork for quelpa
;; (use-package fortran-tags
;;   :ensure nil
;;   :quelpa (fortran-tags :repo "raullaasner/fortran-tags" :fetcher github))
(load-file "~/code/python/fortran-tags/fortran-tags.el")

(use-package general
  :ensure t
  :config
  (general-define-key
   ;; replace default keybindings
   "C-s" 'swiper             ; search for string in current buffer
   "M-x" 'counsel-M-x        ; replace default M-x with ivy backend
  )
  (general-define-key
   :states '(normal visual emacs)
   :prefix "SPC"

   ;; Root
   "/"   'counsel-ag
   "TAB" '(switch-to-next-buffer :which-key "next buffer")

   ;; Applications
   "a"   '(:ignore t :which-key "Applications")
   "ad"  'dired

   ;; Projects
   "p"   '(:keymap projectile-command-map :package projectile
           :which-key "Projectile")
   ;; ...versions
   "v"   '(:keymap vc-prefix-map :which-key "Version Control")

   ;; Language-specific
   ;; TODO rework into keymaps
   ;; "l"   '(:ignore t :which-key "Language-specific commands")
   ;; "lf"  '(:ignore t :which-key "Fortran bindings")
   ",f" 'fortran-find-tag
   ",p" 'fortran-pop-tag-mark
   ",n" 'fortran-goto-next
   ",g" 'fortran-find-proc-calls
   ",d" 'fortran-procedures-in-buffer

   ;; Buffers
   "b"   '(:ignore t :which-key "Buffers")
   "bb"  'ivy-switch-buffer
   "bk"  'kill-buffer

   ;; Shortcuts
   "e"   '(:ignore t :which-key "Edit")
   "ed"  '((lambda() (interactive)
             (find-file "~/.emacs.d/init.el"))
           :which-key "dotemacs config")
  ))
