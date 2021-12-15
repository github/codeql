;;; ql-mode-base.el --- A major mode for editing QL files

;;; Commentary:
;;
;; A basic major mode for editing QL files.
;;
;; Provides syntax highlighting, comment support, and a mode-specific
;; keymap.

;;; Code:

(defconst ql--at-type-regex "\\_<@\\w+\\>")
(defconst ql--predicate-regex "\\(\\_<\\w+\\(\\+\\|\\*\\)?\\_>\\)\\s-*(")
(defconst ql--primitive-type-regex (regexp-opt '("int" "string" "float" "boolean" "date") 'symbols))
(defconst ql--annotation-regex (regexp-opt '("abstract" "cached" "external" "final" "transient" "library" "private" "deprecated" "override" "query" "pragma" "language" "bindingset") 'words))
(defconst ql--annotation-arg-regex (regexp-opt '("inline" "noinline" "nomagic" "noopt" "monotonicAggregates") 'words))
(defconst ql--keywords
  '("and" "any" "as" "asc" "avg" "boolean" "by" "class" "concat" "count" "date" "desc" "else" "exists" "extends" "false" "float" "forall" "forex" "from" "if" "implies" "import" "in" "instanceof" "int" "max" "min" "module" "not" "none" "or" "order" "predicate" "rank" "result" "select" "strictconcat" "strictcount" "strictsum" "string" "sum" "super" "then" "this" "true" "where"
    )
  )

(defconst ql--highlights
  `((,ql--predicate-regex 1 'font-lock-function-name-face)
    (,ql--primitive-type-regex . 'font-lock-type-face)
    (,ql--at-type-regex 0 'font-lock-type-face)
    (,ql--annotation-regex . 'font-lock-preprocessor-face)
    (,ql--annotation-arg-regex . 'font-lock-keyword-face))
  )

(defvar ql-mode-base-map
  (let ((map (make-sparse-keymap)))
    map)
  "Keymap for `ql-mode-base'.")

(defvar ql-mode-base-hook nil "Hook run after entering ql-mode-base.")

(define-generic-mode
    ql-mode-base

  ;; comments
  nil

  ;; keywords
  ql--keywords

  ;; other things to highlight
  ql--highlights

  ;; auto mode alist
  '("\\.qll?$")

  ;; other function to run
  (list (lambda ()
          (use-local-map ql-mode-base-map)

          (modify-syntax-entry ?_ "w" (syntax-table))
          ;; // Comments (style a)
          (modify-syntax-entry ?\/ ". 124" (syntax-table))
          (modify-syntax-entry ?\n "> " (syntax-table))
          ;; /* Comments (style b) */
          (modify-syntax-entry ?* ". 23b" (syntax-table))
          (modify-syntax-entry ?@ "_" (syntax-table))

          (set (make-local-variable 'comment-start) "//")
          (set (make-local-variable 'comment-start-skip) "// ")

          (run-hooks 'ql-mode-base-hook)

          ))
  "A basic major mode for QL files")

(provide 'ql-mode-base)
;;; ql-mode-base.el ends here
