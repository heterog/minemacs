;;; me-window.el --- Windows and frames -*- lexical-binding: t; -*-

;; Copyright (C) 2022-2023  Abdelhak Bougouffa

;; Author: Abdelhak Bougouffa (concat "abougouffa" "@" "fedora" "project" "." "org")

;;; Commentary:

;; Window configuration for special windows.
;; This section inspired by the article "Demystifying Emacs’s Window Manager" found here:
;; www.masteringemacs.org/article/demystifying-emacs-window-manager

;;; Code:

(use-package ace-window
  :straight t
  :bind (("M-o" . ace-window))
  :custom
  (aw-dispatch-always t)
  :init
  (+map! "wa" #'ace-window))

(add-to-list
 'display-buffer-alist
 `(,(rx bol "*" (or "Help" (seq "helpful" (zero-or-more not-newline))) "*" eol)
   (display-buffer-reuse-window display-buffer-pop-up-window)
   (inhibit-same-window . t)))

;; Show *Warnings* at bottom
(add-to-list
 'display-buffer-alist
 `("^\\*Warnings\\*$"
   (display-buffer-reuse-window display-buffer-in-direction)
   (direction . bottom) ;; bottom (above below...)
   (dedicated . t) ;; Close when finished
   (reusable-frames . visible) ;;
   (window-height . 10)))

;; Show dictionary definition and completion buffer on the right side
(add-to-list
 'display-buffer-alist
 `(,(rx bol "*" (or "Dictionary" "lexic" "Completions") "*" eol)
   (display-buffer-in-side-window)
   (side . right)
   (window-width . 82)))

(add-to-list
 'display-buffer-alist
 `(,(rx bol "*" (or "eshell" "terminal" "shell" "Shell Command Output" "Async Shell Command") "*" eol)
   ;; (display-buffer-reuse-window display-buffer-at-bottom)
   (display-buffer-reuse-window display-buffer-in-direction)
   (direction . bottom) ;; bottom (above below...)
   (dedicated . t) ;; Close when finished
   (reusable-frames . visible) ;;
   (window-height . 0.3)))

(setq
 frame-title-format
 '(""
   (:eval
    (let ((proj
           (ignore-errors
             (cond
              ((featurep 'projectile) (projectile-project-name))
              (t (or
                  (project-name (project-current))
                  (file-name-nondirectory (string-trim-right (expand-file-name (vc-root-dir)) "/"))))))))
     (concat
      (if (buffer-modified-p) " ○" " ●")
      (when (and proj (not (string= proj "-"))) (format " %s" proj)))))))

;; Adapted from: github.com/Phundrak/dotfiles/blob/master/org/config/emacs.org
(with-eval-after-load 'hydra
  (defhydra +window-adjust-size (:hint nil :foreign-keys warn)
    "
^Zoom^                                ^Other
^^^^^^^-----------------------------------------
[_t_/_s_] shrink/enlarge vertically   [_q_] quit
[_c_/_r_] shrink/enlarge horizontally
"
    ("q" nil :exit t)
    ("c" shrink-window-horizontally)
    ("t" enlarge-window)
    ("s" shrink-window)
    ("r" enlarge-window-horizontally))

  (+map! "wj" '(+window-adjust-size/body :wk "+window-adjust-size")))


(provide 'me-window)

;;; me-window.el ends here
