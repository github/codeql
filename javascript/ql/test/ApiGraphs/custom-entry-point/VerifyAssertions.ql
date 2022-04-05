class CustomEntryPoint extends API::EntryPoint {
  CustomEntryPoint() { this = "CustomEntryPoint" }

  override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef("CustomEntryPoint") }
}

import ApiGraphs.VerifyAssertions
