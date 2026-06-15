import go
import StringOps

module WebCacheDeception {
  abstract class Sink extends DataFlow::Node { }

  private class GoNetHttp extends Sink {
    GoNetHttp() {
      exists(
        DataFlow::CallNode m, DataFlow::ReadNode rn, Http::HeaderWrite::Range hw, DeclaredFunction f
      |
        m.getTarget().hasQualifiedName("net/http", "HandleFunc") and
        m.getArgument(0).getStringValue().matches("%/") and
        m.getArgument(1) = rn and
        rn.reads(f) and
        f.getParameter(0) = hw.getResponseWriter() and
        hw.getHeaderName() = "cache-control" and
        this = m.getArgument(0)
      )
    }
  }

  private class GoFiber extends Sink {
    GoFiber() {
      exists(ImportSpec i |
        i.getPath() = "github.com/gofiber/fiber" or
        i.getPath() = "github.com/gofiber/fiber/v2"
      |
        exists(DataFlow::CallNode m |
          m.getCall().getArgument(0).toString().matches("%/*%") and
          this = m.getArgument(0)
        )
      )
    }
  }

  private class GoChi extends Sink {
    GoChi() {
      exists(ImportSpec i |
        i.getPath() = "github.com/go-chi/chi/v5" or
        i.getPath() = "github.com/go-chi/chi/v5/middleware"
      |
        exists(DataFlow::CallNode m |
          m.getCall().getArgument(0).toString().matches("%/*%") and
          this = m.getArgument(0)
        )
      )
    }
  }

  private class GoHttpRouter extends Sink {
    GoHttpRouter() {
      exists(string pkg | pkg = "github.com/julienschmidt/httprouter" |
        exists(DataFlow::CallNode m |
          m.getCall().getArgument(0).toString().matches("%/*%") and
          this = m.getArgument(0)
        )
      )
    }
  }
}
