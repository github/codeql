/**
 * @kind test-postprocess
 */

private import rust
private import codeql.util.test.ExternalLocationPostProcessing
import Make<getSourceLocationPrefix/0>

private string getSourceLocationPrefix() { sourceLocationPrefix(result) }
