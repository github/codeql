import javascript

query DataFlow::Node dbUse() { result = API::moduleImport("@example/db").getInstance().getAUse() }
