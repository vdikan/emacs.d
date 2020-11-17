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
  (add-to-list 'auto-mode-alist '("\\.post\\'" . markdown-mode)) ; blog posts assoc with markdown
  (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e") ;; Emails: Mu4e
  (setq system-time-locale "C")
  (put 'narrow-to-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  ;; manual modeline colors:
  ;; (set-face-attribute 'region nil :background "LightSteelBlue")
  ;; (set-face-attribute 'mode-line           nil :background "dark slate blue" :foreground "gainsboro")
  ;; (set-face-attribute 'mode-line-buffer-id nil :background "DodgerBlue3" :foreground "white smoke")
  ;; (set-face-attribute 'mode-line-highlight nil :box nil :background "steel blue" :foreground "white")
  ;; (set-face-attribute 'mode-line-inactive  nil :inherit 'default)
  (set-face-attribute 'default nil :height 180 :family "Anonymous Pro")
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


(use-package calc
  :config
  (eval-after-load "calc-units"
    '(progn
       (setq math-additional-units
             '((Bohr  "5.29177249*10^(-11) m"
                      "Bohr radius [ hbar^2/(m*e^2) ]" atU)
               (Eryd  "2.1798741*10^(-18) J"
                      "Rydberg energy [ e^2/(2*a0) ]" atU)
               (Eh    "4.3597482*10^(-18) J"
                      "Hartree energy [ e^2/a0 ]" atU))
             math-units-table nil))))


;;  Appearance
(use-package modus-vivendi-theme
  :ensure t
  :config
  (blink-cursor-mode 0)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (load-theme 'modus-vivendi t)
  (setq default-frame-alist
        (append default-frame-alist
                '(;(background-color . "#efeff9")
                  (cursor-color . "MediumSlateBlue")))))


;; (use-package vscode-icon
;;   :ensure t
;;   :commands (vscode-icon-for-file)
;;   :config
;;   (setq vscode-icon-size 23))


(use-package all-the-icons
  :config
  ;; Category icons displayed in the `org-brain` wiki:
  (load (expand-file-name "~/Grimoire/org/category-icons.el")))
;; M-x all-the-icons-install-fonts


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
  :after (lsp-mode)
  :ensure yasnippet-snippets
  :custom
  (yas-snippet-dirs
   (append '("~/Grimoire/snippets")
           yas-snippet-dirs)))


(use-package reverse-im
  :ensure t
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t))


(use-package tramp
  :secret
  (counsel-tramp "~/.passwd/workspaces.el.gpg")
  :defer t
  :config
  ;; (put 'temporary-file-directory 'standard-value '("/tmp"))

  ;;; 4magit remote
  (add-to-list 'tramp-remote-path ws-tramp-remote-path-to-git)
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
                                        ;(setq magit-git-executable "git")

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
  (defconst *lvar-org-brain-dir* "~/Grimoire/org/brain")
  (defconst *lvar-org-agenda-file* "~/Grimoire/org/agenda.org.gpg"
    "General todos and schedule planner.")
  (defconst *lvar-org-journal-file* "~/Grimoire/org/journal.org.gpg"
    "Dear Diary...")
  ;; Research Notes are part of the Brain now
  ;; (defconst *lvar-org-notes-file* "~/Refs/notes.org.gpg"
  ;;   "Research notes file")

  (setq org-agenda-files
        (list *lvar-org-agenda-file*
              *lvar-org-journal-file*
              *lvar-org-brain-dir*))

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
     (lisp . t)
     (shell . t)
     (gnuplot . t)
     (python . t)
     (fortran . t)
     (racket . t)
     (ditaa . t)))

  :custom
  (org-babel-lisp-eval-fn #'sly-eval)
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
  (org-ditaa-jar-path "~/bin/ditaa/ditaa-0.11.0-standalone.jar")
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
     ("m" "Org-Mu4e Link" entry (file+datetree *lvar-org-journal-file*)
      "* TODO %a %?\nDEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+2d\"))")
     ("l" "(hooked) Link worklog to journal" entry
      (file+datetree *lvar-org-journal-file*)
      "* Worklog entry: %u  :work:log: \n %i\n"
      :empty-lines 1))))


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


(use-package org-books
  :custom (org-books-file (format "%s/Books.org" *lvar-org-brain-dir*)))


;; Allows you to edit entries directly from org-brain-visualize
;; (use-package polymode
;;   :config
;;   (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))


(use-package org-brain
  :ensure t
  :init
  (setq org-brain-path *lvar-org-brain-dir*)
  ;; For Evil users
  (with-eval-after-load 'evil
    (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
  :config
  ;; Decorations in Brain-buffers
  (custom-set-faces
   '(org-brain-button ((t (:foreground "CornflowerBlue" :underline nil))))
   '(org-brain-parent ((t (:foreground "plum2" :underline nil))))
   '(org-brain-title  ((t (:foreground "PaleGreen1" :underline nil)))))
  (defun org-brain-insert-resource-icon (link)
    "Insert an icon, based on content of org-mode LINK."
    (insert (format "%s "
                    (cond ((string-prefix-p "brain:" link)
                           (all-the-icons-fileicon "brain"))
                          ((string-prefix-p "info:" link)
                           (all-the-icons-octicon "info"))
                          ((string-prefix-p "help:" link)
                           (all-the-icons-material "help"))
                          ((string-prefix-p "http" link)
                           (all-the-icons-icon-for-url link))
                          (t
                           (all-the-icons-icon-for-file link))))))
  (add-hook 'org-brain-after-resource-button-functions
            #'org-brain-insert-resource-icon)
  ;; (bind-key "C-c b" 'org-brain-prefix-map org-mode-map)
  (setq org-id-track-globally t)
  (setq org-id-locations-file "~/Grimoire/org/.org-id-locations")
  (add-hook 'before-save-hook #'org-brain-ensure-ids-in-buffer)
  (push '("b" "Brain" plain (function org-brain-goto-end)
          "* %i%?" :empty-lines 1)
        org-capture-templates)
  (push 'org-brain-entry-todo-state
        org-brain-vis-current-title-prepend-functions)
  (setq org-brain-visualize-default-choices 'all)
  (setq org-brain-title-max-length 22)
  (setq org-brain-include-file-entries nil
        org-brain-file-entries-use-title nil))


(use-package elfeed
  :ensure elfeed-org
  :custom
  ;; Entries older than 2 weeks are marked as read
  (elfeed-search-filter "@2-weeks-ago +unread -reddit")
  :config
  (add-hook 'elfeed-show-mode-hook
            (lambda ()
              (set-face-attribute
               'variable-pitch (selected-frame)
               :font (font-spec :family "Anonymous Pro" :size 30))))
  (setq elfeed-db-directory "~/Grimoire/feeds/elfeed-db")
  (add-hook 'elfeed-new-entry-hook
            (elfeed-make-tagger :before "2 weeks ago"
                                :remove 'unread))
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/Grimoire/org/brain/Feeds.org"
                                   "~/Grimoire/org/brain/Podcasts.org")))


;; (use-package pdf-tools
;;   :pin manual ;; manually update
;;   ;; :quelpa (pdf-tools :repo "politza/pdf-tools" :fetcher github)
;;   :config
;;   ;; initialise
;;   (pdf-tools-install)
;;   ;; open pdfs scaled to fit page
;;   (setq-default pdf-view-display-size 'fit-page)
;;   ;; automatically annotate highlights
;;   (setq pdf-annot-activate-created-annotations t)
;;   ;; use normal isearch
;;   (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
;;   (setq pdf-view-resize-factor 1.2))


;; (use-package ivy-bibtex
;;   :ensure t
;;   :custom
;;   (ivy-re-builders-alist
;;    '((ivy-bibtex . ivy--regex-ignore-order)
;;      (t . ivy--regex-plus)))
;;   (bibtex-completion-notes-path
;;    (format "%s/org/notes.org.gpg" *lvar-grimoire-dir*))
;;   (bibtex-completion-bibliography *lvar-bibtex-list*)
;;   (bibtex-completion-pdf-field "file")
;;   (bibtex-completion-notes-template-one-file
;;    "\n* ${author-or-editor} (${year}): ${title}
;; :PROPERTIES:
;; :Custom_ID: ${=key=}
;; :Cite_IDs:
;; :AUTHOR: ${author}
;; :JOURNAL: ${journaltitle}
;; :YEAR: ${year}
;; :DOI: ${doi}
;; :DIGRAPH_OUT: t
;; :DIGRAPH_CLUSTER: nil
;; :DIGRAPH_SUMMARY:
;; :END:\n\n"))


(use-package org-ref
  :after (org)
  :custom
  (org-ref-completion-library 'org-ref-ivy-cite)
  (reftex-default-bibliography '("~/Refs/refs.bib"))
  ;; (org-ref-bibliography-notes "~/Refs/notes.org.gpg")
  (org-ref-bibliography-notes "~/Grimoire/org/brain/Papers.org")
  (org-ref-default-bibliography '("~/Refs/refs.bib"))
  (org-ref-pdf-directory "~/Refs/pdfs/")
  (biblio-download-directory "~/Refs/!incoming/")
  ;; autokey formatting:
  (bibtex-autokey-year-length 4)
  (bibtex-autokey-name-year-separator "-")
  (bibtex-autokey-year-title-separator "-")
  (bibtex-autokey-titleword-separator "-")
  (bibtex-autokey-titlewords 2)
  (bibtex-autokey-titlewords-stretch 1)
  (bibtex-autokey-titleword-length 5)
  :bind (("s-b" . org-ref-open-citation-at-point)
         ("s-k" . org-ref-ivy-set-keywords)
         ("s-n" . org-ref-open-notes-at-point)
         ("s-p" . org-ref-open-pdf-at-point)
         ("s-i" . org-ref-ivy-insert-cite-link)
         ("s-m" . org-ref-ivy-mark-candidate)
         ("s-d" . doi-utils-add-bibtex-entry-from-doi))
  ;; Open pdf in system viewer:
  ;; (bibtex-completion-pdf-open-function 'helm-open-file-with-default-tool))
  :config (setcdr (assoc "\\.pdf\\'" org-file-apps) "atril %s"))


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
  ;; :hook
  ;; (emacs-lisp-mode . rainbow-identifiers-mode)
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


(use-package counsel)

(use-package smex)

(use-package swiper)


(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))


;; (use-package evil-collection
;;   :after evil
;;   :ensure t
;;   :config
;;   (evil-collection-init))


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


;; (use-package electric-pair
;;   :ensure nil
;;   :hook
;;   (emacs-lisp-mode . electric-pair-mode))


(use-package evil-cleverparens
  :hook
  (sly-mode . evil-cleverparens-mode)
  ;(slime-mode . evil-cleverparens-mode)
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


;; ;; Hack to install julia-mode: AucTEX needs this
;; (defconst debian-emacs-flavor 'emacs25
;;   "A symbol representing the particular debian flavor of emacs running.
;;  Something like 'emacs20, 'xemacs20, etc.")
;; ;; This should be corrected, because:
;; ;; https://stackoverflow.com/questions/7311268/symbols-value-as-variable-is-void-debian-emacs-flavor-when-running-ispell-on-t

;; (use-package julia-mode
;;   :ensure julia-repl
;;   :config
;;   (setenv "JULIA_NUM_THREADS" "2")
;;   (add-hook 'julia-mode-hook 'julia-repl-mode)
;;   ;; :hook
;;   ;; (julia-mode-hook . julia-repl-mode)
;;   )


(use-package elpy
  :custom (python-shell-interpreter "python3")) ; Python should burn in Hell

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


;;(use-package cider
;;  :defer t
  ;; :custom
  ;; (cider-repl-display-help-banner nil)
  ;; :config
  ;; sadly, we can't use :diminish keyword here, yet
  ;; (diminish 'cider-mode
  ;;           '(:eval (format " 🍏%s" (cider--modeline-info))))
;;  )


(use-package eros
  :hook
  (emacs-lisp-mode . eros-mode))

(use-package suggest
  :defer t)

;; (use-package geiser)
;; (use-package racket-mode)

(use-package scheme
  :custom
  (scheme-program-name "nc bay00 12345")) ; toying w/scheme on Nostromo

(use-package fennel-mode
  ;; :config
  ;; (setq inferior-lisp-program "/usr/local/bin/fennel")
  )

(use-package haskell-mode)

(use-package arduino-mode :ensure t :pin "melpa")

(use-package company-glsl)

(use-package graphviz-dot-mode)

(use-package sly
  :config
  (setq inferior-lisp-program "sbcl"))

;; (use-package slime
;;   ;; :disabled
;;   :ensure slime-company
;;   :config
;;   (load (expand-file-name "~/.quicklisp/slime-helper.el")) ; comes from:
;;   ;; https://kaashif.co.uk/2015/06/28/hacking-stumpwm-with-common-lisp/

;;   (setq inferior-lisp-program "sbcl"
;;         lisp-indent-function 'common-lisp-indent-function
;;         slime-complete-symbol-function 'slime-fuzzy-complete-symbol
;;         slime-startup-animation nil)
;;   ;; (slime-setup '(slime-fancy))
;;   (slime-setup '(slime-company))
;;   (setq slime-net-coding-system 'utf-8-unix))


(use-package counsel-dash
  ;;https://github.com/dash-docs-el/counsel-dash
  :custom
  (dash-docs-docsets-path "~/Grimoire/docsets")
  (counsel-dash-docsets-url "https://raw.githubusercontent.com/Kapeli/feeds/master")
  :hook
  (f90-mode . (lambda () (setq-local counsel-dash-docsets '("Fortran" "MPI" "OpenMP"))))
  (fortran-mode . (lambda () (setq-local counsel-dash-docsets '("Fortran" "MPI" "OpenMP"))))
  (scheme-mode . (lambda () (setq-local counsel-dash-docsets '("R5RS"))))
  (sly-mode . (lambda () (setq-local counsel-dash-docsets '("Common Lisp")))))


(use-package counsel-tramp)


;; (use-package flycheck
;;   :config
;;   (add-hook 'after-init-hook #'global-flycheck-mode))


(use-package lsp-mode
  :secret
  ;; (lsp-register-client "~/.passwd/workspaces.el.gpg")  ; doesn't work dunno why
  (default-remote-fortls-connection "~/.passwd/workspaces.el.gpg") ; explicit defun
  :ensure t
  :init
  (require 'lsp-clients)
  :hook
  (f90-mode . lsp-deferred)
  (fortran-mode . lsp-deferred)
  (c++-mode . lsp-deferred)
  (lsp-mode . lsp-ui-mode)
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

  :config
  (use-package lsp-ui
    :ensure t
    :config
    (set-face-attribute 'lsp-ui-doc-background  nil :height 160
                        :family "Anonymous Pro" :background "MediumPurple4")
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
    (lsp-ui-peek-fontify 'on-demand)) ;; never, on-demand, or always

  ;; syntax checking
  ;; (lsp-prefer-flymake nil)
  ;; :after flycheck

  (add-to-list 'lsp-language-id-configuration '(fortran-mode . "fortran"))
  (add-to-list 'lsp-language-id-configuration '(f90-mode . "fortran"))
  (add-to-list 'lsp-language-id-configuration '(c++-mode . "c++"))
  (push 'company-lsp company-backends)

  (defun default-remote-fortls-connection ()
    "Use when connecting to fortls on default remote."
    (cons ws-remote-fortls lsp-clients-fortls-args))

  (lsp-register-client
   (make-lsp-client :new-connection
                    (lsp-tramp-connection #'default-remote-fortls-connection)
                    ;; (lsp-tramp-connection (lambda () (cons ws-remote-fortls
                    ;;                                        lsp-clients-fortls-args)))
                    :major-modes '(fortran-mode f90-mode)
                    :remote? t
                    :priority 1
                    :server-id 'fortls-remote)))


(use-package company-lsp
  :custom
  (company-lsp-cache-candidates t) ;; auto, t(always using a cache), or nil
  (company-lsp-async t)
  (company-lsp-enable-snippet t)
  (company-lsp-enable-recompletion t))


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
  ;; :quelpa ((telega :repo "zevlg/telega.el" :fetcher github :branch "master")
  ;;          (upgrade t))
  :commands (telega)
  :defer t
  :custom
  (telega-mode-line-mode 1)
  :config
  (require 'ol-telega))                 ; <- can also play with shortened urls


;;; Declare/describe custom shortcuts with `general' and `which-key'
;; NOTE: Wanna drop `general' in favor to `use-package' bindings at some point.
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
    "cb"  'counsel-brain
    "cc"  'org-capture
    "cf"  'flyspell-correct-word-before-point
    "cd"  '(:ignore t :which-key "Counsel-Dash")
    "cda"  'dash-docs-activate-docset
    "cdd"  'counsel-dash-at-point
    "cl"  'org-store-link
    "cb"  'counsel-brain
    "ct"  'counsel-tramp
    "cy"  '(:ignore t :which-key "Yas")
    "cyy" 'yas-insert-snippet
    "cyn" 'yas-new-snippet
    "cyv" 'yas-visit-snippet-file

    ;; Applications
    "a"   '(:ignore t :which-key "Applications")
    "ad"  'dired
    "am"  'mu4e
    "aa"  'org-ref                      ; spawns HELM-ish interface
    "ab"  '(:ignore t :which-key "Brain")
    "abn" 'org-brain-add-entry
    "abb" 'org-brain-visualize
    "af"  'elfeed
    "ao"  'org-agenda
    "ar"  're-builder
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
              (find-file-noselect "~/Refs/refs.bib")))
           :which-key "Main Bibtex file")
    "on" '((lambda() (interactive)
             (switch-to-buffer
              (find-file-noselect "~/Grimoire/org/brain/Papers.org")))
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
