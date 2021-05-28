lgtm,codescanning
* The query "Cross-site scripting" (`java/xss`) has been improved to report fewer false positives by removing the `javax.servlet.http.HttpServletResponse.sendError` sink since the Servlet API implementations already encode the error message for the HTML context.
