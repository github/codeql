lgtm,codescanning
* Assertion methods are now taking into account methods with parameters that are annotated
with `System.Diagnostics.CodeAnalysis.DoesNotReturnIfAttribute`. This change is expected to
lead to higher precision in any query that relies on control flow graphs.
