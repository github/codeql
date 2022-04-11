// BAD: no URI validation
URL url = servletContext.getResource(requestUrl);
url = getClass().getResource(requestUrl);
InputStream in = url.openStream();

InputStream in = request.getServletContext().getResourceAsStream(requestPath);
in = getClass().getClassLoader().getResourceAsStream(requestPath);

// GOOD: check for a trusted prefix, ensuring path traversal is not used to erase that prefix:
// (alternatively use `Path.normalize` instead of checking for `..`)
if (!requestPath.contains("..") && requestPath.startsWith("/trusted")) {
	InputStream in = request.getServletContext().getResourceAsStream(requestPath);
}

Path path = Paths.get(requestUrl).normalize().toRealPath();
URL url = sc.getResource(path.toString());
