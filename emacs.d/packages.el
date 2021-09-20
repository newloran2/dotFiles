;;primeiro precisa configurar o package para usar o repositorio melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;inicializa de fato o use package
;;caso não tenha o package use package instalado instala.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

;;gosto do monokai
(use-package monokai-pro-theme
  :config (load-theme 'monokai-pro t))

;; configurando o lsp
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (go-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode :ensure t)

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
  (global-company-mode))


(use-package go-mode)
(use-package swift-mode)



(use-package elfeed
  :bind (("C-x w" . cle/hydra-elfeed/body)
         :map elfeed-search-mode-map
         ("R" . elfeed-update)
         :map elfeed-show-mode-map
         ("J" . elfeed-show-next)
         ("K" . elfeed-show-prev))
        
  :config
  (setq browse-url-browser-function 'w3m-browse-url)
  (setq elfeed-feeds
        '( 
          ("https://www.xboxpower.com.br/feed/" xbox)
          ("https://sachachua.com/blog/feed/" sasha_Chua emacs)
          ("https://www.reddit.com/r/macmini/.rss" reddit mac)
          ("https://macmagazine.com.br/feed/" mac)
          ("https://emacsredux.com/atom.xml" mac)
          ("http://ergoemacs.org/emacs/blog.xml" mac)
          ("https://irreal.org/blog/?feed=atom" mac))))

(defhydra cle/hydra-elfeed ()
  "Elfeed"
  ("e" (cle/open-elfeed-filtered "@6-month-ago +emacs +unread") "emacs")
  ("m"(cle/open-elfeed-filtered "@6-month-ago +mac +unread") "mac")
  ("x"(cle/open-elfeed-filtered "@6-month-ago +xbox +unread") "xbox")
  ("a"(cle/open-elfeed-filtered "@6-month-ago +unread") "todos não lidos")
)


(use-package w3m)


(use-package org-bullets :hook (org-mode . org-bullets-mode))
(use-package ace-jump-mode :bind("C-c c" . ace-jump-word-mode))

;;snippets
(use-package yasnippet)
(use-package yasnippet-snippets)

;; git
(use-package magit
  :init (message "Carregando o magit")
  :config
  (message "Magit carregado"))

;; movimento entre janelas
(use-package ace-window :bind ("M-o" . 'ace-window))


;;hydra
(use-package hydra)
;;apenas para testar package sem necessáriamente instalar
(use-package try)
