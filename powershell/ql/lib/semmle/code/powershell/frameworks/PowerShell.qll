import powershell
import semmle.code.powershell.frameworks.data.internal.ApiGraphModels
private import semmle.code.powershell.dataflow.internal.DataFlowPublic as DataFlow

module PowerShell {
  private class PowerShellGlobalEntry extends ModelInput::TypeModel {
    override DataFlow::Node getASource(string type) {
      type = "System.Management.Automation.PowerShell!" and
      result.asExpr().getExpr().(TypeNameExpr).getName().toLowerCase() = "powershell"
    }
  }
}
