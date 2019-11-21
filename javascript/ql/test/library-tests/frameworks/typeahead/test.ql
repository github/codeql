import javascript

query DataFlow::Node url() {
   result = any(Typeahead::RemoteBloodhoundClientRequest r).getUrl()	
}

query DataFlow::Node response(string responseType, boolean promise) {
   result = any(Typeahead::RemoteBloodhoundClientRequest r).getAResponseDataNode(responseType, promise)	
}

query DataFlow::Node suggestionFunction() {
  result = any(Typeahead::TypeaheadSuggestionFunction t)	
}