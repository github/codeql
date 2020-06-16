import python
import semmle.python.web.flask.General

from ControlFlowNode regex, Function func
where flask_routing(regex, func)
select regex.getNode().(StrConst).getText(), func.toString()
