import go
import semmle.go.security.RequestForgery

select any(RequestForgery::Sink s)
