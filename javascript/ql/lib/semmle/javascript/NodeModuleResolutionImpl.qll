/**
 * INTERNAL: Do not use directly.
 *
 * Provides predicates for modeling Node.js module resolution.
 */

import javascript

/**
 * Gets the priority with which a given file extension should be found by module resolution.
 * Extensions with a lower numeric priority value are preferred.
 *
 * File types that compile to `js` are preferred over the `js` file type itself.
 * This is to ensure we find the original source file in case the compiled output is also present.
 */
int getFileExtensionPriority(string ext) {
  ext = "tsx" and result = 0
  or
  ext = "ts" and result = 1
  or
  ext = "jsx" and result = 2
  or
  ext = "es6" and result = 3
  or
  ext = "es" and result = 4
  or
  ext = "mjs" and result = 5
  or
  ext = "cjs" and result = 6
  or
  ext = "js" and result = 7
  or
  ext = "json" and result = 8
  or
  ext = "node" and result = 9
  or
  ext = "d.ts" and result = 10
}

int prioritiesPerCandidate() { result = 3 * (numberOfExtensions() + 1) }

int numberOfExtensions() { result = count(getFileExtensionPriority(_)) }

/**
 * Gets a file in folder `dir` whose name is of the form `basename.extension`,
 * where `extension` has the given `priority`.
 *
 * This may resolve to an `mjs` file even though `require` will never find those files at runtime.
 * We do this to handle the case where an `mjs` file is transpiled to `js`, and we want to find the
 * original source file.
 */
bindingset[basename]
File tryExtensions(Folder dir, string basename, int priority) {
  exists(string ext | result = dir.getFile(basename, ext) |
    priority = getFileExtensionPriority(ext)
  )
}
