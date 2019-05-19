;;; funcs.el --- rogue Layer utility functions -*- lexical-binding: t -*-

(defvar ev-root "~/.config/env/env")

(defun to-fish-find-file (candidate)
  "Run find file for given bookmark"
  (helm-find-files-1 (file-name-as-directory (f-canonical (f-join "~/.tofish" candidate)))))

(defun dir-items (dir)
  (set-difference (directory-files dir) '("." "..") :test 'equal))

(defun to-fish-jump ()
  "Jump to to-fish bookmarks"
  (interactive)
  (helm :sources (helm-build-sync-source "bookmarks"
                   :candidates (dir-items "~/.tofish")
                   :action '(("Jump to bookmark" . to-fish-find-file)))
        :buffer "*helm tofish jump*"
        :prompt "Jump to: "))

(defun ev-set-group (group-name)
  (let ((dir (f-join ev-root group-name)))
    (dolist (file (dir-items dir))
      (setenv file (s-trim (f-read-text (f-join dir file)))))))

(defun ev-reset-group (group-name)
  (let ((dir (f-join ev-root group-name)))
    (dolist (file (dir-items dir))
      (setenv file nil))))

(defun ev-workon ()
  "Set ev environment variables"
  (interactive)
  (helm :sources (helm-build-sync-source "groups"
                   :candidates (dir-items ev-root)
                   :action '(("Set vars" . ev-set-group)))
        :buffer "*helm ev workon*"
        :prompt "ev workon: "))

(defun ev-reset ()
  "Clear whatever ev environment vars are set"
  (interactive)
  (dolist (group-name (dir-items ev-root))
    (ev-reset-group group-name)))

(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-word (- arg)))

(defun delete-line ()
  "Delete current line without killing"
  (interactive)
  (delete-region (line-beginning-position) (line-end-position)))

(defun duplicate-line ()
  "Duplicate a line."
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (newline)
  (yank)
  (setq kill-ring (cdr kill-ring)))

(defun r/cycle-theme ()
  "Cycle between dark and light scheme"
  (interactive)
  (if (eq r-current-theme r-dark-theme)
      (progn
        (r/light)
        (setq r-current-theme r-light-theme))
    (progn
      (r/dark)
      (setq r-current-theme r-dark-theme))))

(defun r/light ()
  "Switch to light theme"
  (interactive)
  (disable-theme r-dark-theme)
  (spacemacs/load-theme r-light-theme)
  (setq org-bullets-bullet-list '(" "))
  (r-org/reset-buffers)
  (beacon-mode -1))

(defun r/dark ()
  "Switch to dark theme"
  (interactive)
  (disable-theme r-light-theme)
  (spacemacs/load-theme r-dark-theme)
  (setq org-bullets-bullet-list '("› "))
  (r-org/reset-buffers)
  (beacon-mode +1))

(defun quack-quack (text)
  "Speak the given text"
  (start-process "quack" nil "quack" text))

(defun quack-unread-mail ()
  "Read unread emails"
  (interactive)
  (let ((subjects (mapcar
                   (lambda (mail) (plist-get mail :subject))
                   (r-mu4e/get-unread-mails))))
    (quack-quack (format "You have %s. %s"
                         (cond ((= (length subjects) 0) "no unread emails")
                               ((= (length subjects) 1) "1 unread email")
                               (t (format "%s unread emails" (length subjects))))
                         (s-join ". " subjects)))))

(defun magit-bookmarks ()
  (interactive)
  (let ((bms `(("website" . ,(concat user-project-dir "lepisma.github.io-deploy")))))
    (helm :sources (helm-build-sync-source "magit-bookmarks"
                     :candidates bms
                     :action `(("Open magit status" . magit-status)))
          :buffer "*helm magit bookmarks*"
          :prompt "Bookmark: ")))

(defun magit-commit-generic-update ()
  (interactive)
  (magit-commit-create '("-m" "Updates")))

(with-eval-after-load 'transient
  (with-eval-after-load 'magit
      (transient-append-suffix 'magit-commit "c"
        '("g" "Commit with generic message" magit-commit-generic-update))))

(defun poetry-activate ()
  (interactive)
  (let* ((venv-dir "~/.cache/pypoetry/virtualenvs/")
         (envs (directory-files venv-dir nil "^[a-z]")))
    (helm :sources (helm-build-sync-source "virtualenvs"
                     :candidates envs
                     :action `(("Activate venv" . (lambda (env) (pyvenv-activate (f-join (f-expand ,venv-dir) env))))))
          :buffer "*helm poetry*"
          :prompt "Activate : ")))

(defun clear-entity (text entity)
  "Remove the ranged ENTITY from TEXT."
  (let* ((match-range (alist-get 'range entity))
         (match (substring-no-properties text (car match-range) (cdr match-range))))
    (s-trim (s-collapse-whitespace (s-replace match "" text)))))

(defun parse-schedule-from-text (text)
  "Parse a scheduled entry from text."
  (let ((parsed-time (car (duck-time-parse text))))
    (if parsed-time
        `((body . ,(clear-entity text parsed-time))
          (ts . ,(duck-org-timestring parsed-time)))
      `((body . ,text)
        (ts)))))
