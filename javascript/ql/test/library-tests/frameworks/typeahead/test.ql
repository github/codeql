import javascript

query DataFlow::Node url() { result = any(ClientRequest r).getUrl() }

query DataFlow::Node response(string responseType, boolean promise) {
  result = any(ClientRequest r).getAResponseDataNode(responseType, promise)
}

query DataFlow::Node suggestionFunction() { result = any(Typeahead::TypeaheadSuggestionFunction t) }
