package p;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

public class ImplOfExternalSPI extends AbstractImplOfExternalSPI {

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