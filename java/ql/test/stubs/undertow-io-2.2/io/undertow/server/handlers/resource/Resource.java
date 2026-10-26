package io.undertow.server.handlers.resource;

import java.io.File;
import java.net.URL;
import java.nio.file.Path;
import java.util.Date;
import java.util.List;

public interface Resource {
	String getPath();

	Date getLastModified();

	String getLastModifiedString();

	String getName();

	boolean isDirectory();

	List<Resource> list();

	Long getContentLength();

	File getFile();

	Path getFilePath();

	File getResourceManagerRoot();

	Path getResourceManagerRootPath();

	URL getUrl();
}
