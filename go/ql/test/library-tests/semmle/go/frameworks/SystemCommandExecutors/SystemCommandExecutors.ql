import go
import semmle.go.security.CommandInjection

from SystemCommandExecution exec
select exec, exec.getCommandName()
