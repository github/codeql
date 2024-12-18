package p;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

public class ImplOfExternalSPI extends AbstractImplOfExternalSPI {

  // sink=p;ImplOfExternalSPI;true;accept;(File);;Argument[0];path-injection;df-generated
  // neutral=p;ImplOfExternalSPI;accept;(File);summary;df-generated
  @Override
  public boolean accept(File pathname) {
    try {
      Files.createFile(pathname.toPath());
    } catch (IOException e) {
      e.printStackTrace();
    }
    return false;
  }
}
