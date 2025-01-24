---
category: fix
---
* Fixed a bug that would occur when TypeScript code was found in an HTML-like file, such as a `.vue` file,
  but where it could not be associated with any `tsconfig.json` file. Previously the embedded code was not
  extracted in this case, but should now be extracted properly.
