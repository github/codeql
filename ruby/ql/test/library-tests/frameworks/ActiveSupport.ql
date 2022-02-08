import codeql.ruby.frameworks.ActiveSupport

query DataFlow::Node constantizeCalls(ActiveSupport::CoreExtensions::String::Constantize c) {
  result = c.getCode()
}
