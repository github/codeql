lgtm,codescanning
* Added support for more templating languages.
  - EJS, Mustache, Handlebars, Nunjucks, Hogan, and Swig are now supported.
  - Template tags from the above dialects are now recognized as sinks
    when not escaped safely for the context, leading to additional results for `js/xss` and `js/code-injection`.
  - Files with the extension `.ejs`, `.hbs`, or `.njk` are now extracted and analyzed.
