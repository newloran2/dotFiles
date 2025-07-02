(setq package-native-compile t)
;;primeiro precisa configurar o package para usar o repositorio melpa
(eval-when-compile

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Configure use-package to use straight.el by default
(use-package straight
             :custom (straight-use-package-by-default t))
  
  (setq use-package-always-ensure 't)
)

;;gosto do monokai
(use-package monokai-pro-theme
  :config (load-theme 'monokai-pro t))


;; (use-package eglot
;;   :ensure t
;;   :hook
;;   (go-mode . eglot-ensure)
;;   (rustic-mode . eglot-ensure)
;;   )
;; configurando o ls
(use-package lsp-mode                   
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  (setq read-process-output-max (* 1024 1024))
  (setq gc-cons-threshold 25000000)

  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (go-mode . lsp)
         (swift-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui
  :commands lsp-ui-mode
  :ensure t)

;; optional if you want which-key integration
(use-package which-key
  :config
  (which-key-mode))



(use-package company
  :defer t
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous))
  :init
  (setq company-idle-delay .1) ;; sim eu gosto do popup de autocomplete aparecendo rapidamente
  (global-company-mode)
)
(use-package go-mode :defer t)
(use-package lua-mode :defer t)
(use-package swift-mode :defer t)
(use-package json-mode :defer t)
;; (use-package lsp-sourcekit
;;   :after lsp-mode
;;   :config
;;   (setq lsp-sourcekit-executable "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"))

;;(use-package rust-mode :defer t)
(use-package rustic
  :defer t
  :config
  (setq lsp-rust-analyzer-server-display-inlay-hints t)
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status)))
(use-package yaml-mode :defer t)



(use-package elfeed
  :commands elfeed
  :bind (("C-x w" . cle/hydra-elfeed/body)
         :map elfeed-search-mode-map
         ("R" . elfeed-update)
         ("A" . cle/elfeed-add-to-emms)
         ("B" . ar/elfeed-search-browse-background-url))
  :config
  (defhydra cle/hydra-elfeed ()
    "Elfeed"
    ("e" (cle/open-elfeed-filtered "@6-month-ago +emacs +unread") "emacs")
    ("m"(cle/open-elfeed-filtered "@6-month-ago +mac +unread") "mac")
    ("x"(cle/open-elfeed-filtered "@6-month-ago +xbox +unread") "xbox")
    ("p"(cle/open-elfeed-filtered "@2-ek-ago +podcast") "podcast")
    ("a"(cle/open-elfeed-filtered "@6-month-ago +unread") "todos não lidos")
  )
  (setq browse-url-browser-function 'eww-browse-url)
  ;;(setq browse-url-browser-function 'w3m-browse-url)
  (setq elfeed-feeds
        '( 
          ("https://www.xboxpower.com.br/feed/" xbox)
          ("https://www.trueachievements.com/newsrss.aspx" xbox)
          ("https://www.promocaogames.com.br/feeds/posts/default" xbox)
          ("https://sachachua.com/blog/feed/" sasha_Chua emacs)
          ;; ("https://www.reddit.com/r/macmini/.rss" reddit mac)
          ("https://macmagazine.com.br/feed/" mac)
          ("https://emacsredux.com/atom.xml" emacs)
          ("http://ergoemacs.org/emacs/blog.xml" mac)
          ("https://irreal.org/blog/?feed=atom" mac)
          ("http://td1p.com/feed/podcast/" podcast podtrash)
          )
        )
  )



(use-package org-bullets :hook (org-mode . org-bullets-mode))

;; ;;snippets
;; (use-package yasnippet
;;   :hook
;;   ('emacs-lisp-mode-hook '(yas-minor-mode))
;;   ('go-mode-hook '(yas-minor-mode)))
;; (use-package yasnippet-snippets)

;; ;; git
(use-package magit :commands magit)
(use-package git-timemachine)
(use-package restclient :defer t)
(use-package jq-mode :defer t)

(use-package avy
  :bind
  ("M-g" . 'avy-goto-char-timer)
  ("M-o" . 'ace-window))

;; ;;Hydra
(use-package hydra)
;; ;;Apenas Para Testar Package Sem Necessáriamente instalar
(use-package try :commands try)


(use-package undo-tree
  :init (global-undo-tree-mode)
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  )
(use-package eshell-toggle
  :bind
  ("C-c t t" . eshell-toggle))

(use-package dumb-jump
  :bind (
         ("C-c j o" . dumb-jump-hydra/body )
         ("s-j" . dumb-jump-go )
         ("s-b" . pop-global-mark)
         ))


(defhydra dumb-jump-hydra (:color blue :columns 3)
    "Dumb Jump"
    ("j" dumb-jump-go "Go")
    ("o" dumb-jump-go-other-window "Other window")
    ("e" dumb-jump-go-prefer-external "Go external")
    ("x" dumb-jump-go-prefer-external-other-window "Go external other window")
    ("i" dumb-jump-go-prompt "Prompt")
    ("l" dumb-jump-quick-look "Quick look")
    ("b" dumb-jump-back "Back"))



(use-package ivy
  :ensure t
  :demand)

(use-package counsel
  :ensure t
  :demand
  :config (counsel-mode))


(use-package rainbow-delimiters :defer t)
(use-package web-mode :defer t)
(use-package flycheck
  :ensure
  :defer t)

(use-package restclient :defer t)

(use-package evil
  :ensure t
  :config
  (evil-mode))


