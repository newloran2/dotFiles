;;(setq lsp-use-plists "true")
(setq comp-deferred-compilation t)
;; definição do arquivo de inicialização separado para evitar que o emacs escreva nele
(setq functions-file (expand-file-name "functions.el" user-emacs-directory))
(setq keybinds-file (expand-file-name "keybinds.el" user-emacs-directory))
(setq custom-file (expand-file-name "config.el" user-emacs-directory))
(setq packages-file (expand-file-name "packages.el" user-emacs-directory))
(when (file-exists-p keybinds-file) (load keybinds-file))
(when (file-exists-p custom-file) (load custom-file))
(when (file-exists-p functions-file) (load functions-file))
(when (file-exists-p packages-file) (load packages-file))


