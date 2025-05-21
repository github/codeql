import powershell
import semmle.code.powershell.frameworks.data.internal.ApiGraphModels
private import semmle.code.powershell.dataflow.internal.DataFlowPublic as DataFlow

module RunspaceFactory {
  private class RunspaceFactoryGlobalEntry extends ModelInput::TypeModel {
    override DataFlow::Node getASource(string type) {
      type = "System.Management.Automation.Runspaces.RunspaceFactory!" and
      result.asExpr().getExpr().(TypeNameExpr).getName().toLowerCase() = "runspacefactory"
    }
  }
}
