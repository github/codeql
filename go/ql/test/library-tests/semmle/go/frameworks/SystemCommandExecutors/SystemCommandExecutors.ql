import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.security.CommandInjection

from SystemCommandExecution exec
select exec, exec.getCommandName()
