lgtm,codescanning
* Fixed a bug that meant data-flow through a checked typecast (e.g. `cast, ok = x.(*Type)`) could be missed.
