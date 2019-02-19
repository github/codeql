# QL syntax highlighting and file-type detection for Emacs

To install, add this directory to the `load-path` and add load the mode in the Emacs init file.

Example:

```elisp
;  ~/.emacs, ~/.emacs.el, or ~/.emacs.d/init.el

; ...

(add-to-list 'load-path "~/ql/misc/emacs")
(require 'ql-mode-base)
(require 'dbscheme-mode)

; ...
```
