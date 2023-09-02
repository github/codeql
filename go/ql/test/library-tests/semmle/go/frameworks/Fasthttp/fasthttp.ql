import go
import semmle.go.frameworks.Fasthttp

from
  Fasthttp::Request::UntrustedFlowSource u1, Fasthttp::RequestCtx::UntrustedFlowSource u2,
  Fasthttp::URI::UntrustedFlowSource u3, Fasthttp::RequestHeader::UntrustedFlowSource u4
select u1, u2, u3, u4
