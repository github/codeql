lgtm,codescanning
* Recognised function `fmt.Errorf` to always return non-nil strings. This may reduce false-positives that depend on a function possibly returning nil.
