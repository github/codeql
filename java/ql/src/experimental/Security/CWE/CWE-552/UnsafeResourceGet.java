// BAD: no URI validation
URL url = request.getServletContext().getResource(requestUrl);
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
if (path.startsWith("/trusted")) {
	URL url = request.getServletContext().getResource(path.toString());
}
