// Generated automatically from org.apache.commons.io.file.PathFilter for testing purposes

package org.apache.commons.io.file;

import java.nio.file.FileVisitResult;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;

public interface PathFilter
{
    FileVisitResult accept(Path p0, BasicFileAttributes p1);
}
