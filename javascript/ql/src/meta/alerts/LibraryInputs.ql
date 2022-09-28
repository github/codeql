/**
 * @name Library inputs
 * @description An input coming from the client of a library
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/library-inputs
 * @tags meta
 * @precision very-low
 */

import javascript
import semmle.javascript.PackageExports

select getALibraryInputParameter(), "Library input"
