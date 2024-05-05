(require 'package)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

;; (setq package-selected-packages '(clojure-mode lsp-mode cider lsp-treemacs flycheck company paredit))
;; (when (cl-find-if-not #'package-installed-p package-selected-packages)
;;   (package-refresh-contents)
;;   (mapc #'package-install package-selected-packages))

(setq use-package-always-ensure t)

;; miscellania
(setq ring-bell-function 'ignore)
(menu-bar-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(line-number-mode 1)
(delete-selection-mode 1)
(savehist-mode 1)
;; (load-theme 'tango-dark)
(savehist-mode 1)
(winner-mode 1)
(show-paren-mode 1)
(windmove-default-keybindings)

(use-package no-littering
  :ensure t
  :config (no-littering-theme-backups))

(use-package diminish :ensure t)

(setq custom-file (no-littering-expand-etc-file-name "custom.el"))
(load custom-file)

(use-package recentf
  :config
  (recentf-mode 1)
  (add-to-list 'recentf-exclude
               (recentf-expand-file-name no-littering-var-directory))
  (add-to-list 'recentf-exclude
               (recentf-expand-file-name no-littering-etc-directory)))

(use-package undo-tree
  :diminish undo-tree-mode
  :config (global-undo-tree-mode))

(use-package multiple-cursors
  :defer t
  :bind
  (("C-S-c C-S-c" . mc/edit-lines)
   ("C-S-<mouse-1>" . mc/add-cursor-on-click)
   ("ESC <down>" . mc/mark-next-like-this)
   ("ESC <up>" . mc/mark-previous-like-this)))

(use-package expand-region
  :bind ("M-SPC" . er/expand-region))

(use-package ivy
  :diminish ivy-mode
  :config
  (ivy-mode 1)
  (setq ivy-magic-tilde nil)
  (setq ivy-use-virtual-buffers t)
  (add-to-list 'ivy-ignore-buffers "\\*Ibuffer")
  (add-to-list 'ivy-ignore-buffers "\\*Messages\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Customize")
  (add-to-list 'ivy-ignore-buffers "\\*EGLOT")
  (add-to-list 'ivy-ignore-buffers "\\*Help\\*")
  (add-to-list 'ivy-ignore-buffers "\\*Flymake log\\*"))

(use-package counsel
  :bind (("M-y" . counsel-yank-pop)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . counsel-minibuffer-history))
  :custom
  (counsel-find-file-at-point 't))

(use-package company
  :diminish company-mode
  :init (global-company-mode 1))

(use-package smex
  :after (ivy)
  :config (smex-initialize))

(use-package ivy-xref
  :init
  (setq xref-show-definitions-function #'ivy-xref-show-defs)
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns x))
  :config
  (setq exec-path-from-shell-variables '("PATH" "GOPATH"))
  (exec-path-from-shell-initialize))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 1))

(use-package eldoc
  :diminish eldoc-mode)

(if (display-graphic-p)
    (use-package git-gutter-fringe
      :ensure t
      :init (global-git-gutter-mode))
  (use-package git-gutter
    :ensure t
    :init (global-git-gutter-mode)))


(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode))
  :init
  (add-hook 'clojure-mode-hook #'yas-minor-mode)         
  (add-hook 'clojure-mode-hook #'linum-mode)             
  (add-hook 'clojure-mode-hook #'subword-mode)           
  (add-hook 'clojure-mode-hook #'smartparens-mode)       
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'clojure-mode-hook #'eldoc-mode)             
  (add-hook 'clojure-mode-hook #'idle-highlight-mode))

(use-package cider
  :ensure t
  :defer t
  :init (add-hook 'cider-mode-hook #'clj-refactor-mode)
  :diminish subword-mode
  :config
  (setq nrepl-log-messages t                  
	cider-auto-select-error-buffer t
	cider-repl-history-file "~/.emacs.d/cider-history"
	cider-repl-pop-to-buffer-on-connect t
	cider-repl-wrap-history t
	cider-show-error-buffer t
        cider-font-lock-dynamically '(macro core function var)
        cider-overlays-use-font-lock t
        cider-prompt-save-file-on-load 'always-save
        cider-repl-display-in-current-window t
        cider-repl-use-clojure-font-lock t    
        nrepl-hide-special-buffers t)            
  (cider-repl-toggle-pretty-printing))

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-minimum-prefix-length 1
      ;; lsp-enable-indentation nil ; uncomment to use cider indentation instead of lsp
      ;; lsp-enable-completion-at-point nil ; uncomment to use cider completion instead of lsp
      )

;; https://www.gnu.org/software/emacs/manual/html_node/efaq-w32/Shell-echo.html
(add-hook 'comint-mode-hook (lambda ()
			      (setq comint-process-echoes t)))

(defun gleyzer-nano-mode ()
  "Custom clone of nano-mode"
  (interactive)

  ;; Use nano fonts
  (setq nano-fonts-use t)

  ;; No startup  screen
  (setq inhibit-startup-screen t)

  ;; No startup message
  (setq inhibit-startup-message t)
  (setq inhibit-startup-echo-area-message t)

  ;; No message in scratch buffer
  (setq initial-scratch-message nil)

  ;; Initial buffer
  (setq initial-buffer-choice nil)

  ;; No frame title
  ;; (setq frame-title-format nil)

  ;; No file dialog
  (setq use-file-dialog nil)

  ;; No dialog box
  (setq use-dialog-box nil)

  ;; No popup windows
  (setq pop-up-windows nil)

  ;; No empty line indicators
  (setq indicate-empty-lines nil)

  ;; No cursor in inactive windows
  (setq cursor-in-non-selected-windows nil)

  ;; Text mode is initial mode
  (setq initial-major-mode 'text-mode)

  ;; Text mode is default major mode
  (setq default-major-mode 'text-mode)

  ;; Moderate font lock
  (setq font-lock-maximum-decoration t)

  ;; No limit on font lock (obsolete)
  ;; (setq font-lock-maximum-size nil)

  ;; No line break space points
  (setq auto-fill-mode nil)

  ;; Fill column at 80
  (setq fill-column 80)

  ;; Bar cursor
  ;; (setq-default cursor-type '(hbar .  4))
  ;; (setq blink-cursor-mode nil)
  (setq-default cursor-in-non-selected-windows nil)
  (set-cursor-color "red")
  
  ;; No tooltips
  (tooltip-mode -1)

  ;; No scroll bars
  (scroll-bar-mode -1)

  ;; No toolbar
  (tool-bar-mode -1)

  ;; Default frame settings
  (setq default-frame-alist
        (append (list
                 '(min-height . 1)  '(height . 45)
                 '(min-width  . 1)  '(width  . 81)
                 '(vertical-scroll-bars . nil)
                 '(internal-border-width . 10)
                 '(left-fringe . 0)
                 '(right-fringe . 0)
                 '(undecorated-round . t) ;; emacs-plu@29 only
                 '(tool-bar-lines . 0)
                 '(menu-bar-lines . 0))))

  ;; Line spacing (in pixels)
  ;; (setq line-spacing 0)

  ;; Vertical window divider
  (setq window-divider-default-right-width 24)
  (setq window-divider-default-places 'right-only)
  (window-divider-mode 1)

  ;; Nicer glyphs for continuation and wrap
  (set-display-table-slot standard-display-table
                          'truncation (make-glyph-code ?… 'nano-faded))
  (set-display-table-slot standard-display-table
                          'wrap (make-glyph-code ?- 'nano-faded))

  ;; Nerd font for glyph icons
  (let ((roboto-nerd (font-spec :name "RobotoMono Nerd Font Mono")))
    (if (find-font roboto-nerd)
        (set-fontset-font t '(#xe000 . #xffdd) roboto-nerd)
      (message "Roboto Mono Nerd font has not been found on your system"))))

(use-package nano-theme
  :ensure t
  :bind
  ("ESC <f7>" . 'nano-theme-toggle)
  :config
  (load-theme 'nano-light t)
  (gleyzer-nano-mode))
