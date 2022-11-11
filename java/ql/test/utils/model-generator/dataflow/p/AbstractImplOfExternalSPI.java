package p;

import java.io.File;
import java.io.FileFilter;

public abstract class AbstractImplOfExternalSPI implements FileFilter {

    @Override
    public boolean accept(File pathname) {
        return false;
    }

}