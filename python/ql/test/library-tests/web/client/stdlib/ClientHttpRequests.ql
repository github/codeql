import python
import semmle.python.web.Http
import semmle.python.web.ClientHttpRequest

from Client::HttpRequest req, string method
where if exists(req.getMethodUpper()) then method = req.getMethodUpper() else method = "<NO METHOD>"
select req, req.getAUrlPart(), method
