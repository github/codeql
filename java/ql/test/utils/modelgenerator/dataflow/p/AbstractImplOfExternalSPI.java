package p;

import java.io.File;
import java.io.FileFilter;

public abstract class AbstractImplOfExternalSPI implements FileFilter {

  // neutral=p;AbstractImplOfExternalSPI;accept;(File);summary;df-generated
  @Override
  public boolean accept(File pathname) {
    return false;
  }
}
