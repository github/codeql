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

    public void testNewFileWithURI() throws java.net.URISyntaxException {
        File f = new File(new URI("dir"));
    }

    public void testPathOfWithString() {
        Path p = Path.of("dir");
        Path p2 = Path.of("dir", "sub");
    }

    public void testPathOfWithURI() throws java.net.URISyntaxException {
        Path p = Path.of(new URI("dir"));
    }

    public void testPathsGetWithString() {
        Path p = Paths.get("dir");
        Path p2 = Paths.get("dir", "sub");
    }

    public void testPathsGetWithURI() throws java.net.URISyntaxException {
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

    public void testNewFileWriterWithString() throws java.io.IOException {
        FileWriter fw = new FileWriter("dir");
    }

    public void testNewFileReaderWithString() throws java.io.FileNotFoundException {
        FileReader fr = new FileReader("dir");
    }

    public void testNewFileOutputStreamWithString() throws java.io.FileNotFoundException {
        FileOutputStream fos = new FileOutputStream("dir");
    }

    public void testNewFileInputStreamWithString() throws java.io.FileNotFoundException {
        FileInputStream fis = new FileInputStream("dir");
    }
}
