import javascript

query ClientWebSocket::ClientSocket clientSocket() { any() }

query ClientWebSocket::SendNode clientSend() { any() }

query ClientWebSocket::ReceiveNode clientReceive() { any() }

query ServerWebSocket::ServerSocket serverSocket() { any() }

query ServerWebSocket::SendNode serverSend() { any() }

query ServerWebSocket::ReceiveNode serverReceive() { any() }

query predicate taintStep(DataFlow::Node pred, DataFlow::Node succ) {
  any(DataFlow::AdditionalFlowStep s).step(pred, succ)
}

query RemoteFlowSource remoteFlow() { any() }
