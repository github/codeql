import go

class UserInputSource extends DataFlow::Node {
  UserInputSource() {
    this = any(DataFlow::CallNode cn |
      // HTTP request parameters
      cn.getTarget().hasQualifiedName("net/http.Request", "FormValue") or
      cn.getTarget().hasQualifiedName("net/http.Request", "PostFormValue") or
      
      // Query parameters
      cn.getTarget().hasQualifiedName("net/url.URL", "Query") or

      // HTTP headers
      cn.getTarget().hasQualifiedName("net/http.Request", "Header.Get") or

      // Environment variables
      cn.getTarget().hasQualifiedName("os", "Getenv") or

      // Cookie values
      cn.getTarget().hasQualifiedName("net/http.Request", "Cookie") or

      cn.getTarget().hasQualifiedName("net/url.Values", "Get")
      // ... add other sources of user input as needed
    )
  }
}

from ImportSpec i, DataFlow::CallNode m, UserInputSource userInput
where
  i.getPath() = "html/template" and
  m.getTarget().hasQualifiedName("html/template.Template", "Parse") and
  userInput = m.getTarget().getACall().getArgument(0).getAPredecessor*().(DataFlow::CallNode)
select i.getPath(),
m.getTarget().getACall().getArgument(0).getAPredecessor*().(DataFlow::CallNode).getTarget().getQualifiedName(), "Potential SSTI: User input flows to template parsing."
