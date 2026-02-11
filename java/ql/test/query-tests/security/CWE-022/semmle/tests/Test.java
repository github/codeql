import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;

import javax.servlet.http.HttpServletRequest;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.io.FileUtils;
import org.apache.tools.ant.AntClassLoader;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.taskdefs.Copy;
import org.apache.tools.ant.taskdefs.Expand;
import org.apache.tools.ant.types.FileSet;
import org.codehaus.cargo.container.installer.ZipURLInstaller;
import org.kohsuke.stapler.framework.io.LargeText;
import org.openjdk.jmh.runner.options.ChainedOptionsBuilder;
import org.springframework.util.FileCopyUtils;

public class Test {

    private HttpServletRequest request;

    public Object source() {
        return request.getParameter("source"); // $ Source
    }

    void test() throws IOException {
        // "java.lang;Module;true;getResourceAsStream;(String);;Argument[0];read-file;ai-generated"
        getClass().getModule().getResourceAsStream((String) source()); // $ Alert
        // "java.lang;Class;false;getResource;(String);;Argument[0];read-file;ai-generated"
        getClass().getResource((String) source()); // $ Alert
        // "java.lang;ClassLoader;true;getSystemResourceAsStream;(String);;Argument[0];read-file;ai-generated"
        ClassLoader.getSystemResourceAsStream((String) source()); // $ Alert
        // "java.io;File;True;canExecute;();;Argument[this];path-injection;manual"
        ((File) source()).canExecute(); // $ Alert
        // "java.io;File;True;canRead;();;Argument[this];path-injection;manual"
        ((File) source()).canRead(); // $ Alert
        // "java.io;File;True;canWrite;();;Argument[this];path-injection;manual"
        ((File) source()).canWrite(); // $ Alert
        // "java.io;File;True;createNewFile;();;Argument[this];path-injection;ai-manual"
        ((File) source()).createNewFile(); // $ Alert
        // "java.io;File;true;createTempFile;(String,String,File);;Argument[2];create-file;ai-generated"
        File.createTempFile(";", ";", (File) source()); // $ Alert
        // "java.io;File;True;delete;();;Argument[this];path-injection;manual"
        ((File) source()).delete(); // $ Alert
        // "java.io;File;True;deleteOnExit;();;Argument[this];path-injection;manual"
        ((File) source()).deleteOnExit(); // $ Alert
        // "java.io;File;True;exists;();;Argument[this];path-injection;manual"
        ((File) source()).exists(); // $ Alert
        // "java.io:File;True;isDirectory;();;Argument[this];path-injection;manual"
        ((File) source()).isDirectory(); // $ Alert
        // "java.io:File;True;isFile;();;Argument[this];path-injection;manual"
        ((File) source()).isFile(); // $ Alert
        // "java.io:File;True;isHidden;();;Argument[this];path-injection;manual"
        ((File) source()).isHidden(); // $ Alert
        // "java.io;File;True;mkdir;();;Argument[this];path-injection;manual"
        ((File) source()).mkdir(); // $ Alert
        // "java.io;File;True;mkdirs;();;Argument[this];path-injection;manual"
        ((File) source()).mkdirs(); // $ Alert
        // "java.io;File;True;renameTo;(File);;Argument[0];path-injection;ai-manual"
        new File("").renameTo((File) source()); // $ Alert
        // "java.io;File;True;renameTo;(File);;Argument[this];path-injection;ai-manual"
        ((File) source()).renameTo(null); // $ Alert
        // "java.io;File;True;setExecutable;;;Argument[this];path-injection;manual"
        ((File) source()).setExecutable(true); // $ Alert
        // "java.io;File;True;setLastModified;;;Argument[this];path-injection;manual"
        ((File) source()).setLastModified(0); // $ Alert
        // "java.io;File;True;setReadable;;;Argument[this];path-injection;manual"
        ((File) source()).setReadable(true); // $ Alert
        // "java.io;File;True;setReadOnly;;;Argument[this];path-injection;manual"
        ((File) source()).setReadOnly(); // $ Alert
        // "java.io;File;True;setWritable;;;Argument[this];path-injection;manual"
        ((File) source()).setWritable(true); // $ Alert
        // "java.io;File;true;renameTo;(File);;Argument[0];create-file;ai-generated"
        new File("").renameTo((File) source()); // $ Alert
        // "java.io;FileInputStream;true;FileInputStream;(File);;Argument[0];read-file;ai-generated"
        new FileInputStream((File) source()); // $ Alert
        // "java.io;FileInputStream;true;FileInputStream;(FileDescriptor);;Argument[0];read-file;manual"
        new FileInputStream((FileDescriptor) source()); // $ Alert
        // "java.io;FileInputStream;true;FileInputStream;(String);;Argument[0];read-file;manual"
        new FileInputStream((String) source()); // $ Alert
        // "java.io;FileReader;true;FileReader;(File);;Argument[0];read-file;ai-generated"
        new FileReader((File) source()); // $ Alert
        // "java.io;FileReader;true;FileReader;(FileDescriptor);;Argument[0];read-file;manual"
        new FileReader((FileDescriptor) source()); // $ Alert
        // "java.io;FileReader;true;FileReader;(File,Charset);;Argument[0];read-file;manual"
        new FileReader((File) source(), null); // $ Alert
        // "java.io;FileReader;true;FileReader;(String);;Argument[0];read-file;ai-generated"
        new FileReader((String) source()); // $ Alert
        // "java.io;FileReader;true;FileReader;(String,Charset);;Argument[0];read-file;manual"
        new FileReader((String) source(), null); // $ Alert
        // "java.nio.file;Files;false;copy;;;Argument[0];read-file;manual"
        Files.copy((Path) source(), (Path) null); // $ Alert
        Files.copy((Path) source(), (OutputStream) null); // $ Alert
        // "java.nio.file;Files;false;copy;;;Argument[1];create-file;manual"
        Files.copy((Path) null, (Path) source()); // $ Alert
        Files.copy((InputStream) null, (Path) source()); // $ Alert
        // "java.nio.file;Files;false;createDirectories;;;Argument[0];create-file;manual"
        Files.createDirectories((Path) source()); // $ Alert
        // "java.nio.file;Files;false;createDirectory;;;Argument[0];create-file;manual"
        Files.createDirectory((Path) source()); // $ Alert
        // "java.nio.file;Files;false;createFile;;;Argument[0];create-file;manual"
        Files.createFile((Path) source()); // $ Alert
        // "java.nio.file;Files;false;createLink;;;Argument[0];create-file;manual"
        Files.createLink((Path) source(), null); // $ Alert
        // "java.nio.file;Files;false;createSymbolicLink;;;Argument[0];create-file;manual"
        Files.createSymbolicLink((Path) source(), null); // $ Alert
        // "java.nio.file;Files;false;createTempDirectory;(Path,String,FileAttribute[]);;Argument[0];create-file;manual"
        Files.createTempDirectory((Path) source(), null); // $ Alert
        // "java.nio.file;Files;false;createTempFile;(Path,String,String,FileAttribute[]);;Argument[0];create-file;manual"
        Files.createTempFile((Path) source(), null, null); // $ Alert
        // "java.nio.file;Files;false;delete;(Path);;Argument[0];delete-file;ai-generated"
        Files.delete((Path) source()); // $ Alert
        // "java.nio.file;Files;false;deleteIfExists;(Path);;Argument[0];delete-file;ai-generated"
        Files.deleteIfExists((Path) source()); // $ Alert
        // "java.nio.file;Files;false;lines;(Path,Charset);;Argument[0];read-file;ai-generated"
        Files.lines((Path) source(), null); // $ Alert
        // "java.nio.file;Files;false;move;;;Argument[1];create-file;manual"
        Files.move(null, (Path) source()); // $ Alert
        // "java.nio.file;Files;false;newBufferedReader;(Path,Charset);;Argument[0];read-file;ai-generated"
        Files.newBufferedReader((Path) source(), null); // $ Alert
        // "java.nio.file;Files;false;newBufferedWriter;;;Argument[0];create-file;manual"
        Files.newBufferedWriter((Path) source()); // $ Alert
        Files.newBufferedWriter((Path) source(), (Charset) null); // $ Alert
        // "java.nio.file;Files;false;newOutputStream;;;Argument[0];create-file;manual"
        Files.newOutputStream((Path) source()); // $ Alert
        // "java.nio.file;Files;false;write;;;Argument[0];create-file;manual"
        Files.write((Path) source(), (byte[]) null); // $ Alert
        Files.write((Path) source(), (Iterable<CharSequence>) null); // $ Alert
        Files.write((Path) source(), (Iterable<CharSequence>) null, (Charset) null); // $ Alert
        // "java.nio.file;Files;false;writeString;;;Argument[0];create-file;manual"
        Files.writeString((Path) source(), (CharSequence) null); // $ Alert
        Files.writeString((Path) source(), (CharSequence) null, (Charset) null); // $ Alert
        // "javax.xml.transform.stream;StreamResult";true;"StreamResult;(File);;Argument[0];create-file;ai-generated"
        new StreamResult((File) source()); // $ Alert
        // "org.apache.commons.io;FileUtils;true;openInputStream;(File);;Argument[0];read-file;ai-generated"
        FileUtils.openInputStream((File) source()); // $ Alert
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[1];create-file;ai-generated"
        new ZipURLInstaller((URL) null, (String) source(), ""); // $ Alert
        // "org.codehaus.cargo.container.installer;ZipURLInstaller;true;ZipURLInstaller;(URL,String,String);;Argument[2];create-file;ai-generated"
        new ZipURLInstaller((URL) null, "", (String) source()); // $ Alert
        // "org.springframework.util;FileCopyUtils;false;copy;(byte[],File);;Argument[1];create-file;manual"
        FileCopyUtils.copy((byte[]) null, (File) source()); // $ Alert
        // "org.springframework.util;FileCopyUtils;false;copy;(File,File);;Argument[0];create-file;manual"
        FileCopyUtils.copy((File) source(), null); // $ Alert
        // "org.springframework.util;FileCopyUtils;false;copy;(File,File);;Argument[1];create-file;manual"
        FileCopyUtils.copy((File) null, (File) source()); // $ Alert
    }

    void test(AntClassLoader acl) {
        // "org.apache.tools.ant;AntClassLoader;true;addPathComponent;(File);;Argument[0];read-file;ai-generated"
        acl.addPathComponent((File) source()); // $ Alert
        // "org.apache.tools.ant;AntClassLoader;true;AntClassLoader;(ClassLoader,Project,Path,boolean);;Argument[2];read-file;ai-generated"
        new AntClassLoader(null, null, (org.apache.tools.ant.types.Path) source(), false); // $ Alert
        // "org.apache.tools.ant;AntClassLoader;true;AntClassLoader;(Project,Path,boolean);;Argument[1];read-file;ai-generated"
        new AntClassLoader(null, (org.apache.tools.ant.types.Path) source(), false); // $ Alert
        // "org.apache.tools.ant;AntClassLoader;true;AntClassLoader;(Project,Path);;Argument[1];read-file;ai-generated"
        new AntClassLoader(null, (org.apache.tools.ant.types.Path) source()); // $ Alert
        // "org.kohsuke.stapler.framework.io;LargeText;true;LargeText;(File,Charset,boolean,boolean);;Argument[0];read-file;ai-generated"
        new LargeText((File) source(), null, false, false); // $ Alert
    }

    void doGet6(String root, HttpServletRequest request) throws IOException {
        String temp = request.getParameter("source");
        // GOOD: Use `contains` and `startsWith` to check if the path is safe
        if (!temp.contains("..") && temp.startsWith(root + "/")) {
            File file = new File(temp);
        }
    }

    void test(DirectoryScanner ds) {
        // "org.apache.tools.ant;DirectoryScanner;true;setBasedir;(File);;Argument[0];read-file;ai-generated"
        ds.setBasedir((File) source()); // $ Alert
    }

    void test(Copy cp) {
        // "org.apache.tools.ant.taskdefs;Copy;true;addFileset;(FileSet);;Argument[0];read-file;ai-generated"
        cp.addFileset((FileSet) source()); // $ Alert
        // "org.apache.tools.ant.taskdefs;Copy;true;setFile;(File);;Argument[0];read-file;ai-generated"
        cp.setFile((File) source()); // $ Alert
        // "org.apache.tools.ant.taskdefs;Copy;true;setTodir;(File);;Argument[0];create-file;ai-generated"
        cp.setTodir((File) source()); // $ Alert
        // "org.apache.tools.ant.taskdefs;Copy;true;setTofile;(File);;Argument[0];create-file;ai-generated"
        cp.setTofile((File) source()); // $ Alert
    }

    void test(Expand ex) {
        // "org.apache.tools.ant.taskdefs;Expand;true;setDest;(File);;Argument[0];create-file;ai-generated"
        ex.setDest((File) source()); // $ Alert
        // "org.apache.tools.ant.taskdefs;Expand;true;setSrc;(File);;Argument[0];read-file;ai-generated"
        ex.setSrc((File) source()); // $ Alert
    }

    void test(ChainedOptionsBuilder cob) {
        // "org.openjdk.jmh.runner.options;ChainedOptionsBuilder;true;result;(String);;Argument[0];create-file;ai-generated"
        cob.result((String) source()); // $ Alert
    }
}
