
package org.apache.commons.io;

import java.io.File;

public class FileCleaner {

    private static final FileCleaningTracker INSTANCE = new FileCleaningTracker();

    // Parameterless static methods should not be modeled.
    public static synchronized void exitWhenFinished() {
        INSTANCE.exitWhenFinished();
    }

    public static FileCleaningTracker getInstance() {
        return INSTANCE;
    }

    public static int getTrackCount() {
        return INSTANCE.getTrackCount();
    }
}
