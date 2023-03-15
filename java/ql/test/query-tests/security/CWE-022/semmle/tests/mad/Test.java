import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetAddress;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import javax.xml.transform.stream.StreamResult;
import org.apache.commons.io.FileUtils;
import org.apache.tools.ant.AntClassLoader;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.taskdefs.Copy;
import org.apache.tools.ant.taskdefs.Expand;
import org.apache.tools.ant.types.FileSet;
import org.codehaus.cargo.container.installer.ZipURLInstaller;
import org.kohsuke.stapler.framework.io.LargeText;

public class Test {

    private InetAddress address;

    public Object source() {
        return address.getHostName();
    }

    void test() throws IOException {
        // "java.lang;Module;true;getResourceAsStream;(String);;Argument[0];read-file;ai-generated"
        getClass().getModule().getResourceAsStream((String) source());
        // "java.lang;Class;false;getResource;(String);;Argument[0];read-file;ai-generated"
        getClass().getResource((String) source());
        // "java.lang;ClassLoader;true;getSystemResourceAsStream;(String);;Argument[0];read-file;ai-generated"
        ClassLoader.getSystemResourceAsStream((String) source());
        // "java.io;File;true;createTempFile;(String,String,File);;Argument[2];create-file;ai-generated"
        File.createTempFile(";", ";", (File) source());
        // "java.io;File;true;renameTo;(File);;Argument[0];create-file;ai-generated"
        new File("").renameTo((File) source());
        // "java.io;FileInputStream;true;FileInputStream;(File);;Argument[0];read-file;ai-generated"
        new FileInputStream((File) source());
        // "java.io;FileReader;true;FileReader;(File);;Argument[0];read-file;ai-generated"
        new FileReader((File) source());
        // "java.io;FileReader;true;FileReader;(String);;Argument[0];read-file;ai-generated"
        new FileReader((String) source());
        // "java.nio.file;Files;false;copy;;;Argument[0];read-file;manual"
        Files.copy((Path) source(), (Path) null);
        Files.copy((Path) source(), (OutputStream) null);
        Files.copy((InputStream) source(), null);
        // "java.nio.file;Files;false;copy;;;Argument[1];create-file;manual"
        Files.copy((Path) null, (Path) source());
        Files.copy((Path) null, (OutputStream) source());
        Files.copy((InputStream) null, (Path) source());
        // "java.nio.file;Files;false;createDirectories;;;Argument[0];create-file;manual"
        Files.createDirectories((Path) source());
        // "java.nio.file;Files;false;createDirectory;;;Argument[0];create-file;manual"
        Files.createDirectory((Path) source());
        // "java.nio.file;Files;false;createFile;;;Argument[0];create-file;manual"
        Files.createFile((Path) source());
        // "java.nio.file;Files;false;createLink;;;Argument[0];create-file;manual"
        Files.createLink((Path) source(), null);
        // "java.nio.file;Files;false;createSymbolicLink;;;Argument[0];create-file;manual"
        Files.createSymbolicLink((Path) source(), null);
        // "java.nio.file;Files;false;createTempDirectory;(Path,String,FileAttribute[]);;Argument[0];create-file;manual"
        Files.createTempDirectory((Path) source(), null);
        // "java.nio.file;Files;false;createTempFile;(Path,String,String,FileAttribute[]);;Argument[0];create-file;manual"
        Files.createTempFile((Path) source(), null, null);
        // "java.nio.file;Files;false;delete;(Path);;Argument[0];delete-file;ai-generated"
        Files.delete((Path) source());
        // "java.nio.file;Files;false;deleteIfExists;(Path);;Argument[0];delete-file;ai-generated"
        Files.deleteIfExists((Path) source());
        // "java.nio.file;Files;false;lines;(Path,Charset);;Argument[0];read-file;ai-generated"
        Files.lines((Path) source(), null);
        // "java.nio.file;Files;false;move;;;Argument[1];create-file;manual"
        Files.move(null, (Path) source());
        // "java.nio.file;Files;false;newBufferedReader;(Path,Charset);;Argument[0];read-file;ai-generated"
        Files.newBufferedReader((Path) source(), null);
        // "java.nio.file;Files;false;newBufferedWriter;;;Argument[0];create-file;manual"
        Files.newBufferedWriter((Path) source());
        Files.newBufferedWriter((Path) source(), (Charset) null);
        // "java.nio.file;Files;false;newOutputStream;;;Argument[0];create-file;manual"
        Files.newOutputStream((Path) source());
        // "java.nio.file;Files;false;write;;;Argument[0];create-file;manual"
        Files.write((Path) source(), (byte[]) null);
        Files.write((Path) source(), (Iterable<CharSequence>) null);
        Files.write((Path) source(), (Iterable<CharSequence>) null, (Charset) null);
        // "java.nio.file;Files;false;writeString;;;Argument[0];create-file;manual"
        Files.writeString((Path) source(), (CharSequence) null);
        Files.writeString((Path) source(), (CharSequence) null, (Charset) null);
        // "javax.xml.transform.stream;StreamResult";true;"StreamResult;(File);;Argument[0];create-file;ai-generated"
        new StreamResult((File) source());
        // "org.apache.commons.io;FileUtils;true;openInputStream;(File);;Argument[0];read-file;ai-generated"
        FileUtils.openInputStream((File) source());
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[1];create-file;ai-generated"
        new ZipURLInstaller((URL) null, (String) source(), "");
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[2];create-file;ai-generated"
        new ZipURLInstaller((URL) null, "", (String) source());
    }

    void test(AntClassLoader acl) {
        // "org.apache.tools.ant;AntClassLoader;true;addPathComponent;(File);;Argument[0];read-file;ai-generated"
        acl.addPathComponent((File) source());
        // "org.apache.tools.ant;AntClassLoader;true;AntClassLoader;(ClassLoader,Project,Path,boolean);;Argument[2];read-file;ai-generated"
        new AntClassLoader(null, null, (org.apache.tools.ant.types.Path) source(), false);
        // "org.apache.tools.ant;AntClassLoader;true;AntClassLoader;(Project,Path,boolean);;Argument[1];read-file;ai-generated"
        new AntClassLoader(null, (org.apache.tools.ant.types.Path) source(), false);
        // "org.apache.tools.ant;AntClassLoader;true;AntClassLoader;(Project,Path);;Argument[1];read-file;ai-generated"
        new AntClassLoader(null, (org.apache.tools.ant.types.Path) source());
        // "org.kohsuke.stapler.framework.io;LargeText;true;LargeText;(File,Charset,boolean,boolean);;Argument[0];read-file;ai-generated"
        new LargeText((File) source(), null, false, false);
    }

    void test(DirectoryScanner ds) {
        // "org.apache.tools.ant;DirectoryScanner;true;setBasedir;(File);;Argument[0];read-file;ai-generated"
        ds.setBasedir((File) source());
    }

    void test(Copy cp) {
        // "org.apache.tools.ant.taskdefs;Copy;true;addFileset;(FileSet);;Argument[0];read-file;ai-generated"
        cp.addFileset((FileSet) source());
        // "org.apache.tools.ant.taskdefs;Copy;true;setFile;(File);;Argument[0];read-file;ai-generated"
        cp.setFile((File) source());
        // "org.apache.tools.ant.taskdefs;Copy;true;setTodir;(File);;Argument[0];create-file;ai-generated"
        cp.setTodir((File) source());
        // "org.apache.tools.ant.taskdefs;Copy;true;setTofile;(File);;Argument[0];create-file;ai-generated"
        cp.setTofile((File) source());
    }

    void test(Expand ex) {
        // "org.apache.tools.ant.taskdefs;Expand;true;setDest;(File);;Argument[0];create-file;ai-generated"
        ex.setDest((File) source());
        // "org.apache.tools.ant.taskdefs;Expand;true;setSrc;(File);;Argument[0];read-file;ai-generated"
        ex.setSrc((File) source());
    }
}
