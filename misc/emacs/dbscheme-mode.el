;;; dbscheme-mode.el --- A major mode for editing Semmle database schema files

;;; Commentary:
;;
;; A basic major mode for editing Semmle database schema files.
;;
;; Provides syntax highlightning and comment support.

;;; Code:

(define-generic-mode
    'dbscheme-mode ; mode name

  ;; comments
  '(("//" . nil)
    ("/*" . "*/"))

  ;; keywords
  '("case" "ref" "unique" "of")

  ;; other things to highlight
  `((,ql--primitive-type-regex . 'font-lock-type-face)
    ("\\<varchar([0-9]+)" . 'font-lock-type-face)
    (,ql--at-type-regex 0 'font-lock-type-face)
    (,ql--predicate-regex 1 'font-lock-variable-name-face))

  ;; auto mode alist
  '("\\.dbscheme$")

  ;; other function to run
  '((lambda ()
      (modify-syntax-entry ?_ "w" (syntax-table))
      (modify-syntax-entry ?@ "_" (syntax-table))))
  "A mode for database schema files")

(provide 'dbscheme-mode)
;;; dbscheme-mode.el ends here
