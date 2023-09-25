import go
import semmle.go.security.OpenUrlRedirectCustomizations

select any(OpenUrlRedirect::Sink s)
