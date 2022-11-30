import codeql.ruby.frameworks.ActionCable
import codeql.ruby.frameworks.stdlib.Logger
import codeql.ruby.dataflow.RemoteFlowSources

query predicate loggerInstantiations(Logger::LoggerInstantiation l) { any() }

query predicate remoteFlowSources(RemoteFlowSource s) { any() }
