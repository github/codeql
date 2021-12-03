import javascript

query ClientWebSocket::ClientSocket clientSocket() { any() }

query ClientWebSocket::SendNode clientSend() { any() }

query ClientWebSocket::ReceiveNode clientReceive() { any() }

query ServerWebSocket::ServerSocket serverSocket() { any() }

query ServerWebSocket::SendNode serverSend() { any() }

query ServerWebSocket::ReceiveNode serverReceive() { any() }

query predicate flowSteps(DataFlow::Node pred, DataFlow::Node succ) {
  DataFlow::SharedFlowStep::step(pred, succ)
}

query RemoteFlowSource remoteFlow() { any() }
