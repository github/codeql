import javascript

class CustomDocument extends DOM::DocumentSource::Range, DataFlow::CallNode {
  CustomDocument() { getCalleeName() = "customGetDocument" }
}

query DataFlow::Node test_documentRef() { result = DOM::documentRef() }

query DataFlow::Node test_locationRef() { result = DOM::locationRef() }

query DataFlow::Node test_domValueRef() { result = DOM::domValueRef() }
