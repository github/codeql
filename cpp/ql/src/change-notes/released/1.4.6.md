## 1.4.6

### Minor Analysis Improvements

* The `cpp/short-global-name` query will no longer give alerts for instantiations of template variables, only for the template itself.
* Fixed a false positive in `cpp/overflow-buffer` when the type of the destination buffer is a reference to a class/struct type.
