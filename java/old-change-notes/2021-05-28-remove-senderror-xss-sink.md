lgtm,codescanning
* The query "Cross-site scripting" (`java/xss`) has been improved to report fewer false positives by removing the `javax.servlet.http.HttpServletResponse.sendError` sink since Servlet API implementations generally already escape the error message, preventing script injection.
