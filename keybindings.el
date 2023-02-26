;;; keybindings.el --- rogue Layer keybindings File for Spacemacs

;; Hide Show
(global-set-key (kbd "C-c <down>") 'hs-toggle-hiding)

;; To-fish jump
(global-set-key (kbd "C-c j") 'to-fish-jump)

;; Avy
(global-set-key (kbd "C-'") 'avy-goto-char)
(define-key org-mode-map (kbd "C-'") 'avy-goto-char)

;; Don't kill my words
(global-set-key (kbd "C-<backspace>") 'backward-delete-word)

;; Line stuff
(global-set-key (kbd "C-d") 'duplicate-line)
(global-set-key (kbd "M-<up>") 'move-text-line-up)
(global-set-key (kbd "M-<down>") 'move-text-line-down)
(global-set-key (kbd "C-S-<backspace>") 'delete-line)

;; Projectile
(global-set-key (kbd "C-c g") 'helm-projectile-ag)

;; Zooming
(global-set-key (kbd "C-c z") 'spacemacs/zoom-frm-transient-state/body)

;; Cycle theme
(global-set-key (kbd "M-m T n") 'r/cycle-theme)

;; Few resets
(global-set-key (kbd "C-x C-l") nil)
(global-set-key (kbd "<insert>") nil)
(define-key org-mode-map (kbd "C-c C-x C-s") nil)
(define-key elfeed-search-mode-map (kbd "s") nil)

;; Helm
(define-key helm-map (kbd "<left>") 'helm-previous-source)
(define-key helm-map (kbd "<right>") 'helm-next-source)
(customize-set-variable 'helm-ff-lynx-style-map t)

;; Smartparens
(global-set-key (kbd "M-<right>") 'sp-forward-slurp-sexp)
(global-set-key (kbd "M-<left>") 'sp-forward-barf-sexp)
(global-set-key (kbd "M-S-<right>") 'sp-backward-barf-sexp)
(global-set-key (kbd "M-S-<left>") 'sp-backward-slurp-sexp)
(global-set-key (kbd "M-u") 'sp-backward-unwrap-sexp)
(global-set-key (kbd "M-n") 'sp-end-of-sexp)
(global-set-key (kbd "M-p") 'sp-beginning-of-sexp)
(global-set-key (kbd "M-k") 'sp-kill-sexp)

;; Persp grouping
(global-set-key (kbd "C-x C-b") #'(lambda (arg) (interactive "P") (with-persp-buffer-list () (ibuffer arg))))

;; elfeed
(define-key elfeed-search-mode-map (kbd "U") 'elfeed-update)
(define-key elfeed-search-mode-map (kbd "C-c o") 'r-feeds/play-elfeed)

(define-key org-mode-map (kbd "C-c .") 'org-time-stamp-inactive)
(global-set-key (kbd "C-c b") 'helm-bibtex)

(define-key org-mode-map (kbd "C-c y") 'org-cliplink)
