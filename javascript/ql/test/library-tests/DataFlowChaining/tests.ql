import javascript
import DataFlow

query Node getAMethodCall(SourceNode node, string name) {
    result = node.getAMethodCall(name)
}

query Node getAMethodCallNoName(SourceNode node) {
    result = node.getAMethodCall()
}

query Node getAMemberInvocation(SourceNode node, string name) {
    result = node.getAMemberInvocation(name)
}

query Node getAMemberInvocationNoName(SourceNode node) {
    result = node.getAMemberInvocation()
}

query Node getAPropertyRead(SourceNode node, string name) {
    result = node.getAPropertyRead(name)
}

query Node getAPropertyReadNoName(SourceNode node) {
    result = node.getAPropertyRead()
}
