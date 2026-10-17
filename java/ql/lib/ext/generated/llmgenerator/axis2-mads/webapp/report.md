# MaD Generation Report

## Included (1)

| Package | Class | Method | Type | Kind | Certainty | Reason |
|---------|-------|--------|------|------|-----------|--------|
| org.apache.axis2.webapp | AxisAdminServlet | service | source | remote | 5 | The `request` parameter (arg 0) is an HttpServletRequest provided by the servlet container, carrying user-supplied HTTP data (query parameters, headers, path info, etc.). The `service` method is a well-known servlet entry point where remote data enters the application. Callees confirm usage of getParameter, getPathInfo, getMethod on the request. |

## Ignored (low certainty) (0)

None.

