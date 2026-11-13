---
category: minorAnalysis
---
* Checks of the form `isNaN(parseInt(x))` and `isNaN(parseFloat(x))` are no longer treated as checking that `x` is a number, since `parseInt` and `parseFloat` only validate a numeric prefix of `x`. This can reveal previously missed alerts, for example from `js/shell-command-constructed-from-input` and `js/unsafe-jquery-plugin`.
