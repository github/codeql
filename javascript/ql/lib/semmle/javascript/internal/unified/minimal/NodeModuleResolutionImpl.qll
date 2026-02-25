/**
 * INTERNAL: Do not use directly.
 *
 * Provides predicates for modeling Node.js module resolution.
 */

import minimal

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
