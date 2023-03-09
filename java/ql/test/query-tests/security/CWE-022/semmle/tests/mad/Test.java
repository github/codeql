import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.net.InetAddress;
import java.net.URL;
import org.codehaus.cargo.container.installer.ZipURLInstaller;

public class Test {

    void test(InetAddress address) throws IOException {
        String t = address.getHostName();
        // "java.lang;Module;true;getResourceAsStream;(String);;Argument[0];read-file;ai-generated"
        getClass().getModule().getResourceAsStream(t);
        // "java.lang;Class;false;getResource;(String);;Argument[0];read-file;ai-generated"
        getClass().getResource(t);
        // "java.lang;ClassLoader;true;getSystemResourceAsStream;(String);;Argument[0];read-file;ai-generated"
        ClassLoader.getSystemResource(t);
        // "java.io;File;true;createTempFile;(String,String,File);;Argument[2];create-file;ai-generated"
        File.createTempFile(";", t);
        // "java.io;File;true;renameTo;(File);;Argument[0];create-file;ai-generated"
        new File("").renameTo((File) t);
        // "java.io;FileInputStream;true;FileInputStream;(File);;Argument[0];read-file;ai-generated"
        new FileInputStream((File) t);
        // "java.io;FileReader;true;FileReader;(File);;Argument[0];read-file;ai-generated"
        new FileReader((File) t);
        // "java.io;FileReader;true;FileReader;(String);;Argument[0];read-file;ai-generated"
        new FileReader(t);
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[1];create-file;ai-generated"
        new ZipURLInstaller((URL) null, t, "");
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[2];create-file;ai-generated"
        new ZipURLInstaller((URL) null, "", t);
    }
}
