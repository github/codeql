import codeql.ruby.frameworks.ActiveSupport
import codeql.ruby.DataFlow

query DataFlow::Node constantizeCalls(ActiveSupport::CoreExtensions::String::Constantize c) {
  result = c.getCode()
}
