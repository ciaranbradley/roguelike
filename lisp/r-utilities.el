;;; r-utilities.el --- Useful (to me) utilities
;;
;; Author: Ciaran Bradley <ciaran.p.bradley@gmail.com>
;; Created: 2024-11-01
;; Version: 1.0
;; License: MIT
;;
;;; Commentary:
;; Utilitiy functions that serve no purpose elsewhere
;;
;;
;;; Code:
(provide 'r-utilites)
(require 'cl-lib)

;;; From portacle
(cl-defmacro os-case (&body cases)
  `(cond ,@(cl-loop for case in cases collect
                    (if (eql (car case) t)
                        `(t ,@(cdr case))
                      `((eql system-type ',(car case)) ,@(cdr case))))))

(macroexpand-all (os-case (gnu/linux "lin") (darwin "mac") (windows-nt "win")))

;; code starts here
(defun open-init-file ()
  "Open the Emacs init file."
  (interactive)
  (find-file user-init-file))

(defun open-main-org-file ()
  "Open my org file."
  (interactive)
  (find-file "q:/Dropbox/org/organiser.org"))

(global-set-key (kbd "C-c f i") 'open-init-file)
(global-set-key (kbd "C-c f o") 'open-main-org-file)

;;; r-utilities.el ends here
