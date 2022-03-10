// BAD: no file download validation
HttpServletRequest request = getRequest();
String path = request.getParameter("path");
String filePath = "/pages/" + path;
HttpServletResponse resp = getResponse();
File file = new File(filePath);
resp.getOutputStream().write(file.readContent());

// BAD: no file upload validation
String savePath = getPara("dir");
File file = getFile("fileParam").getFile();
FileInputStream fis = new FileInputStream(file);
String filePath = "/files/" + savePath;
FileOutputStream fos = new FileOutputStream(filePath);

// GOOD: check for a trusted prefix, ensuring path traversal is not used to erase that prefix:
// (alternatively use `Path.normalize` instead of checking for `..`)
if (!filePath.contains("..") && filePath.hasPrefix("/pages")) { ... }
// Also GOOD: check for a forbidden prefix, ensuring URL-encoding is not used to evade the check:
// (alternatively use `URLDecoder.decode` before `hasPrefix`)
if (filePath.hasPrefix("/files") && !filePath.contains("%")) { ... }