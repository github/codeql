import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.net.Socket;

public class Main {
  public void sendUserFileGood(Socket sock) throws IOException {
    BufferedReader filenameReader =
        new BufferedReader(new InputStreamReader(sock.getInputStream(), StandardCharsets.UTF_8));
    String path = filenameReader.readLine();
    Path src = Path.of(path);
    File srcF = new File(path);

    new JavaNio().PathInjection(src, srcF);

    new SpringIo().PathInjection(path);

    AmazonS3 s3PathInjection = new AmazonS3();
    s3PathInjection.downloadFileResumable(src.toUri());
    s3PathInjection.downloadFile(path);
    s3PathInjection.downloadObjectsToDirectory(src.toUri());
    s3PathInjection.uploadFileResumable(src.toUri());
    s3PathInjection.uploadDirectory(src.toUri());
    s3PathInjection.uploadFile(src.toUri());

    Zip4j zip4jfile = new Zip4j();
    zip4jfile.PathInjection(path);

    ZipFile zipfile = new ZipFile();
    zipfile.PathInjection(path);
  }
}
