// BAD: no URI validation
String returnURL = request.getParameter("returnURL");
RequestDispatcher rd = sc.getRequestDispatcher(returnURL);
rd.forward(request, response);

// GOOD: check for a trusted prefix, ensuring path traversal is not used to erase that prefix:
// (alternatively use `Path.normalize` instead of checking for `..`)
if (!returnURL.contains("..") && returnURL.hasPrefix("/pages")) { ... }
// Also GOOD: check for a forbidden prefix, ensuring URL-encoding is not used to evade the check:
// (alternatively use `URLDecoder.decode` before `hasPrefix`)
if (returnURL.hasPrefix("/internal") && !returnURL.contains("%")) { ... }