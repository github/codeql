lgtm,codescanning
* The security queries now distinguish more clearly between different parts of `window.location`.
  When the taint source of an alert is based on `window.location`, the source will usually
  occur closer to where user-controlled data is obtained, such as at `location.hash`.
* `js/request-forgery` no longer considers client-side path parameters to be a source due to
  the restricted character set usable in a path, resulting in fewer false-positive results.
