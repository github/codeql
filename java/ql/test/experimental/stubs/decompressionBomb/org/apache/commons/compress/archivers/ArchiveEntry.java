// Generated automatically from org.apache.commons.compress.archivers.ArchiveEntry for testing purposes

package org.apache.commons.compress.archivers;

import java.util.Date;

public interface ArchiveEntry
{
    Date getLastModifiedDate();
    String getName();
    boolean isDirectory();
    long getSize();
    static long SIZE_UNKNOWN = 0;
}
