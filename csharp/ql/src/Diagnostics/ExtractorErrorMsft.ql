/**
 * @name Extraction error msft
 * @description An error message reported by the extractor, limited to those files where there are no
 *              compilation errors. This indicates a bug or limitation in the extractor, and could lead
 *              to inaccurate results.
 * @id cs/extractor-error-msft
 * @kind problem
 * @tags security
 *       extraction
 */

 import csharp
 import semmle.code.csharp.commons.Diagnostics
 
 from ExtractorError error
 select error.getLocation().getFile(), error.getText()
 