/*
 * Keep malformed UTF-8 beyond the binary-file header check so this file is parsed.
 * The parser and Java extractor must agree on source positions after these bytes.
 */
// Truncated UTF-8 sequences: â‚ ðŸ’
function different(a: string, b: string) {
  return a !== b;
}
