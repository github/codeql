import java.io.File;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.FileSystems;
import java.net.URI;

class PathCreation {
    public void testNewFileWithString() {
        File f = new File("dir");
        File f2 = new File("dir", "sub");
    }

    public void testNewFileWithFileString() {
        File f = new File(new File("dir"), "sub");
    }

    public void testNewFileWithURI() {
        File f = new File(new URI("dir"));
    }

    public void testPathOfWithString() {
        Path p = Path.of("dir");
        Path p2 = Path.of("dir", "sub");
    }

    public void testPathOfWithURI() {
        Path p = Path.of(new URI("dir"));
    }

    public void testPathsGetWithString() {
        Path p = Paths.get("dir");
        Path p2 = Paths.get("dir", "sub");
    }

    public void testPathsGetWithURI() {
        Path p = Paths.get(new URI("dir"));
    }

    public void testFileSystemGetPathWithString() {
        Path p = FileSystems.getDefault().getPath("dir");
        Path p2 = FileSystems.getDefault().getPath("dir", "sub");
    }

    public void testPathResolveSiblingWithString() {
        Path p = Path.of("dir").resolveSibling("sub");
    }

    public void testPathResolveWithString() {
        Path p = Path.of("dir").resolve("sub");
    }

    public void testNewFileWriterWithString() {
        FileWriter fw = new FileWriter("dir");
    }

    public void testNewFileReaderWithString() {
        FileReader fr = new FileReader("dir");
    }

    public void testNewFileOutputStreamWithString() {
        FileOutputStream fos = new FileOutputStream("dir");
    }

    public void testNewFileInputStreamWithString() {
        FileInputStream fis = new FileInputStream("dir");
    }
}
