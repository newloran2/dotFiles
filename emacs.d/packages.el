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
         ("B" . ar/elfeed-search-browse-background-url))
  :config
  (setq browse-url-browser-function 'eww-browse-url)
  ;;(setq browse-url-browser-function 'w3m-browse-url)
  (setq elfeed-feeds
        '( 
          ("https://www.xboxpower.com.br/feed/" xbox)
          ("https://www.trueachievements.com/newsrss.aspx" xbox)
          ("https://www.promocaogames.com.br/feeds/posts/default" xbox)
          ("https://sachachua.com/blog/feed/" sasha_Chua emacs)
          ("https://www.reddit.com/r/macmini/.rss" reddit mac)
          ("https://macmagazine.com.br/feed/" mac)
          ("https://emacsredux.com/atom.xml" emacs)
          ("http://ergoemacs.org/emacs/blog.xml" mac)
          ("https://irreal.org/blog/?feed=atom" mac)
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCA7bPwBQFCzVlTavNy5U3_g" youtube))
  ))

(defhydra cle/hydra-elfeed ()
  "Elfeed"
  ("e" (cle/open-elfeed-filtered "@6-month-ago +emacs +unread") "emacs")
  ("m"(cle/open-elfeed-filtered "@6-month-ago +mac +unread") "mac")
  ("x"(cle/open-elfeed-filtered "@6-month-ago +xbox +unread") "xbox")
  ("a"(cle/open-elfeed-filtered "@6-month-ago +unread") "todos não lidos")
)


(use-package w3m
  :config
  (setq w3m-toggle-inline-images-permanently nil)) ;; desliga a exibição de imagens no w3m


(use-package org-bullets :hook (org-mode . org-bullets-mode))
(use-package ace-jump-mode :bind("C-c c" . ace-jump-word-mode))

;;snippets
(use-package yasnippet
  :hook
  ('emacs-lisp-mode-hook '(yas-minor-mode))
  ('go-mode-hook '(yas-minor-mode)))
(use-package yasnippet-snippets)

;; git
(use-package magit
  :init (message "Carregando o magit")
  :config
  (message "Magit carregado"))



(use-package avy
  :bind
  ("M-g" . 'avy-goto-char-timer)
  ("M-o" . 'ace-window))

;;Hydra
(use-package hydra)
;;Apenas Para Testar Package Sem Necessáriamente instalar
(use-package try)

