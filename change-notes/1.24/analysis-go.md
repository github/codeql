# Improvements to Go analysis

## New queries

| **Query**                                                                 | **Tags**                                                                   | **Purpose**                                                                                                                                            |
|---------------------------------------------------------------------------|----------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| Constant length comparison (`go/constant-length-comparison`)     | correctness | Highlights code that checks the length of an array or slice against a constant before indexing it using a variable, suggesting a logic error. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                                           | **Expected impact**          | **Change**                                                |
|-----------------------------------------------------|------------------------------|-----------------------------------------------------------|
| Reflected cross-site scripting (`go/reflected-xss`) | Fewer results | Untrusted input flowing into an HTTP header definition is no longer flagged, since this is often harmless. |
| Useless assignment to field (`go/useless-assignment-to-field`) | Fewer false positives | The query now conservatively handles fields promoted through embedded pointer types. |
