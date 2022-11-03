class CustomEntryPoint extends API::EntryPoint {
  CustomEntryPoint() { this = "CustomEntryPoint" }

  override DataFlow::SourceNode getAUse() { result = DataFlow::globalVarRef("CustomEntryPoint") }

  override DataFlow::Node getARhs() { none() }
}

import ApiGraphs.VerifyAssertions
