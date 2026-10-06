/**
 * @kind test-postprocess
 */

private import unified
private import codeql.util.test.ExternalLocationPostProcessing
import Make<getSourceLocationPrefix/0>

private string getSourceLocationPrefix() { sourceLocationPrefix(result) }
