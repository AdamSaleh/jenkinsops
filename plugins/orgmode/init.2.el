;; Init file to use with the orgmode plugin.

;; Load org-mode
;; Requires org-mode v8.x

(require 'package)
(setq package-load-list '((htmlize t)))
(package-initialize)

(require 'org)
(require 'ox-html)
(require 'htmlize)

;;; Custom configuration for the export.
(setq debug-on-error t)

;;; Add any custom configuration that you would like to 'conf.el'.
(setq nikola-use-pygments nil
      org-export-with-toc nil
      org-src-fontify-natively t
      org-enable-reveal-js-support t
      org-export-with-section-numbers nil
      org-startup-folded 'showeverything)

(require 'cl)                           ;for `lexical-let'

(add-hook
 ;; This is for org 8.x (use `org-export-first-hook' for earlier versions).
 (make-local-variable 'org-export-before-processing-hook)
 (lambda (backend)
   (add-to-list (make-local-variable 'load-path) (expand-file-name "./etc"))
   (require 'color-theme)
   (color-theme-initialize)

   (when (display-graphic-p)            ;Are we running in interactive mode?
     ;; If so, create a temporary frame to install the color theme used by
     ;; htmlize:
     (lexical-let ((buff (switch-to-buffer-other-frame (current-buffer)))
                   (frame (selected-frame)))
       (setq color-theme-is-global nil)
       (make-frame-invisible frame)
       ;; Schedule deletion of temporary frame:
       (add-to-list
        ;; The following is for org 8.x (earlier versions use other hooks like
        ;; `org-latex-final-hook').
        (make-local-variable 'org-export-filter-final-output-functions)
        (lambda (string backend info) (delete-frame frame)))))

   ;; Install color theme.
   (color-theme-blippblopp)))

;; Export function used by Nikola.
(defun nikola-html-export (infile outfile)
  "Export the body only of the input file and write it to
specified location."
  (with-current-buffer (find-file infile)
    (load "/home/asaleh/.emacs.d/elpa/htmlize-20161211.1019/htmlize.el")
    (org-html-export-as-html)
    (write-file outfile nil)))
