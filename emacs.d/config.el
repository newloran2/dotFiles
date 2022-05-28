
(setq inhibit-startup-message t)

(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(set-frame-font "Source Code Pro 12")
(defalias 'yes-or-no-p 'y-or-n-p)
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)

(setq shr-inhibit-images t) ;; sem imagens no emacs grafico
(recentf-mode t)
(setq recentf-max-saved-items 100)
(setq recentf-exclude '("~/.emacs.d/elpa"))
(global-set-key (kbd "C-c r") 'ido-recentf-open)
(global-set-key (kbd "C-c s") (lambda() (interactive) (switch-to-buffer "*scratch*")))
(global-set-key (kbd "C-c a") 'org-agenda)
;;evil
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Put backup files neatly away                                                 
(let ((backup-dir "~/.emacs.d/backups")
      (auto-saves-dir "~/.emacs.d/auto-save"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks                           
      delete-old-versions t  ; Clean up the backups                             
      version-control t      ; Use version numbers on backups,                  
      kept-new-versions 5    ; keep some new versions                           
      kept-old-versions 2)   ; and some old ones, too                           

;; configuração de tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq c-default-style "linux") 
(setq c-basic-offset 4) 
(c-set-offset 'comment-intro 0)



;;agenda
(setq org-agenda-files (list "~/.emacs.d/agenda/todo.org"
                             "~/.emacs.d/agenda/work.org"
                             "~/.emacs.d/agenda/home.org"))



;;recentf usando o ido :)
(progn
  ;; make buffer switch command do suggestions, also for find-file command
  (require 'ido)
  (ido-mode 1)

  ;; show choices verticallyq
  (if (version< emacs-version "25")
      (setq ido-separator "\n")
    (setf (nth 2 ido-decorations) "\n"))

  ;; show any name that has the chars you typed
  (setq ido-enable-flex-matching t)

  ;; use current pane for newly opened file
  (setq ido-default-file-method 'selected-window)

  ;; use current pane for newly switched buffer
  (setq ido-default-buffer-method 'selected-window)

  ;; stop ido from suggesting when naming new file
  (define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c1284dd4c650d6d74cfaf0106b8ae42270cab6c58f78efc5b7c825b6a4580417" "b6269b0356ed8d9ed55b0dcea10b4e13227b89fd2af4452eee19ac88297b0f99" "c8b83e7692e77f3e2e46c08177b673da6e41b307805cd1982da9e2ea2e90e6d7" default))
 '(evil-undo-system 'undo-tree)
 '(package-selected-packages
   '(restclient helm-mode helm dumb-jump xwwp emms projectile eshell-toggle eshel-toggle undo-tree undo-fu evil lsp-sourcekit yaml-mode rust-mode ydra mu4e expand-region hydra ace-window elcast try spray popup-el popup google-translate magit plantuml-mode elfeed-goodies yasnippet-snippets yasnippet go-mode company which-key lsp-ui lsp-mode company-quickhelp monokai-pro-them shell-pop ace-jump-mode ace-jump swift-mode org-bullets w3m w3 elfeed use-package))
 '(safe-local-variable-values '((git-commit-major-mode . git-commit-elisp-text-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
