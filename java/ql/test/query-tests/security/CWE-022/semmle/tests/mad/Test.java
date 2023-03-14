import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.net.InetAddress;
import java.net.URL;
import org.codehaus.cargo.container.installer.ZipURLInstaller;

public class Test {

    public Object source(InetAddress address) {
        return address.getHostName();
    }

    void test() throws IOException {
        // "java.lang;Module;true;getResourceAsStream;(String);;Argument[0];read-file;ai-generated"
        getClass().getModule().getResourceAsStream((String) source(null));
        // "java.lang;Class;false;getResource;(String);;Argument[0];read-file;ai-generated"
        getClass().getResource((String) source(null));
        // "java.lang;ClassLoader;true;getSystemResourceAsStream;(String);;Argument[0];read-file;ai-generated"
        ClassLoader.getSystemResourceAsStream((String) source(null));
        // "java.io;File;true;createTempFile;(String,String,File);;Argument[2];create-file;ai-generated"
        File.createTempFile(";", ";", (File) source(null));
        // "java.io;File;true;renameTo;(File);;Argument[0];create-file;ai-generated"
        new File("").renameTo((File) source(null));
        // "java.io;FileInputStream;true;FileInputStream;(File);;Argument[0];read-file;ai-generated"
        new FileInputStream((File) source(null));
        // "java.io;FileReader;true;FileReader;(File);;Argument[0];read-file;ai-generated"
        new FileReader((File) source(null));
        // "java.io;FileReader;true;FileReader;(String);;Argument[0];read-file;ai-generated"
        new FileReader((String) source(null));
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[1];create-file;ai-generated"
        new ZipURLInstaller((URL) null, (String) source(null), "");
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[2];create-file;ai-generated"
        new ZipURLInstaller((URL) null, "", (String) source(null));
    }
}
