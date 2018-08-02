import javascript
import semmle.javascript.frameworks.ExpressModules

from ExpressLibraries::ExpressSession::MiddlewareInstance session, string name
select session, name, session.getOption(name)