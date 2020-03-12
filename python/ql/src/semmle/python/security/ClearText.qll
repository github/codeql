import python
import semmle.python.security.TaintTracking
import semmle.python.security.SensitiveData
import semmle.python.dataflow.Files
import semmle.python.web.Http

module ClearTextStorage {

    abstract class Sink extends TaintSink {
        override predicate sinks(TaintKind kind) {
            kind instanceof SensitiveData
        }
    }

    class CookieStorageSink extends Sink {
        CookieStorageSink() {
            any(CookieSet cookie).getValue() = this
        }
    }

    class FileStorageSink extends Sink {
        FileStorageSink() {
            exists(CallNode call, AttrNode meth, string name |
                any(OpenFile fd).taints(meth.getObject(name)) and
                call.getFunction() = meth and
                call.getAnArg() = this |
                name = "write"
            )
        }
    }

}

module ClearTextLogging {

    abstract class Sink extends TaintSink {
        override predicate sinks(TaintKind kind) {
            kind instanceof SensitiveData
        }
    }

    class PrintSink extends Sink {
        PrintSink() {
            exists(CallNode call |
                call.getAnArg() = this and
                call = Value::named("print").getACall()
            )
        }
    }

    class LoggingSink extends Sink {
        LoggingSink() {
            exists(CallNode call, AttrNode meth, string name |
                call.getFunction() = meth and
                meth.getObject(name).(NameNode).getId().matches("logg%") and
                call.getAnArg() = this |
                name = "error" or
                name = "warn" or
                name = "warning" or
                name = "debug" or
                name = "info"
            )
        }
    }

}
