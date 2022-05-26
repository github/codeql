lgtm,codescanning
* Improved ability to recognise a sanitizing function (for example, `func f(s string) bool { return isClean(s) }`). This may reduce false-positives for any query employing a sanitizing test.
