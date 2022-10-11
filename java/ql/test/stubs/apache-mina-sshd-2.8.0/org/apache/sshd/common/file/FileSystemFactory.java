// Generated automatically from org.apache.sshd.common.file.FileSystemFactory for testing purposes

package org.apache.sshd.common.file;

import java.nio.file.FileSystem;
import java.nio.file.Path;
import org.apache.sshd.common.session.SessionContext;

public interface FileSystemFactory
{
    FileSystem createFileSystem(SessionContext p0);
    Path getUserHomeDir(SessionContext p0);
}
