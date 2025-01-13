import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.FileSystems;

public class TaintedPath {
    public void sendUserFile(Socket sock, String user) throws IOException {
        BufferedReader filenameReader =
                new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        String filename = filenameReader.readLine();
        // BAD: read from a file without checking its path
        BufferedReader fileReader = new BufferedReader(new FileReader(filename)); // $ hasTaintFlow
        String fileLine = fileReader.readLine();
        while (fileLine != null) {
            sock.getOutputStream().write(fileLine.getBytes());
            fileLine = fileReader.readLine();
        }
    }

    public void sendUserFileGood(Socket sock, String user) throws IOException {
        BufferedReader filenameReader =
                new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        String filename = filenameReader.readLine();
        // GOOD: ensure that the file is in a designated folder in the user's home directory
        if (!filename.contains("..") && filename.startsWith("/home/" + user + "/public/")) {
            BufferedReader fileReader = new BufferedReader(new FileReader(filename));
            String fileLine = fileReader.readLine();
            while (fileLine != null) {
                sock.getOutputStream().write(fileLine.getBytes());
                fileLine = fileReader.readLine();
            }
        }
    }

    public void sendUserFileGood2(Socket sock, String user) throws Exception {
        BufferedReader filenameReader =
                new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        String filename = filenameReader.readLine();

        Path publicFolder = Paths.get("/home/" + user + "/public").normalize().toAbsolutePath();
        Path filePath = publicFolder.resolve(filename).normalize().toAbsolutePath();

        // GOOD: ensure that the path stays within the public folder
        if (!filePath.startsWith(publicFolder + File.separator)) {
            throw new IllegalArgumentException("Invalid filename");
        }
        BufferedReader fileReader = new BufferedReader(new FileReader(filePath.toString()));
        String fileLine = fileReader.readLine();
        while (fileLine != null) {
            sock.getOutputStream().write(fileLine.getBytes());
            fileLine = fileReader.readLine();
        }
    }

    public void sendUserFileGood3(Socket sock, String user) throws Exception {
        BufferedReader filenameReader =
                new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        String filename = filenameReader.readLine();
        // GOOD: ensure that the filename has no path separators or parent directory references
        if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
            throw new IllegalArgumentException("Invalid filename");
        }
        BufferedReader fileReader = new BufferedReader(new FileReader(filename));
        String fileLine = fileReader.readLine();
        while (fileLine != null) {
            sock.getOutputStream().write(fileLine.getBytes());
            fileLine = fileReader.readLine();
        }
    }

    public void sendUserFileGood4(Socket sock, String user) throws IOException {
        BufferedReader filenameReader =
                new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        String filename = filenameReader.readLine();
        File file = new File(filename);
        String baseName = file.getName();
        // GOOD: only use the final component of the user provided path
        BufferedReader fileReader = new BufferedReader(new FileReader(baseName));
        String fileLine = fileReader.readLine();
        while (fileLine != null) {
            sock.getOutputStream().write(fileLine.getBytes());
            fileLine = fileReader.readLine();
        }
    }

    // TODO : New tests

    public void sendUserFileGood5(Socket sock, String user) throws IOException {
        BufferedReader filenameReader = new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        // GOOD: remove all ".." sequences and path separators from the filename
        String filename = filenameReader.readLine().replaceAll("\\.", "").replaceAll("/", "");
        BufferedReader fileReader = new BufferedReader(new FileReader(filename)); // GOOD
        String fileLine = fileReader.readLine();
        while(fileLine != null) {
            sock.getOutputStream().write(fileLine.getBytes());
            fileLine = fileReader.readLine();
        }
    }

    public void sendUserFileGood6(Socket sock, String user) throws IOException {
        BufferedReader filenameReader = new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        String filename = filenameReader.readLine();
        // GOOD: remove all ".." sequences and path separators from the filename
        filename = filename.replaceAll("\\.\\.|[/\\\\]", "");
        BufferedReader fileReader = new BufferedReader(new FileReader(filename)); // GOOD
        String fileLine = fileReader.readLine();
        while(fileLine != null) {
            sock.getOutputStream().write(fileLine.getBytes());
            fileLine = fileReader.readLine();
        }
    }

    public void sendUserFileGood7(Socket sock, String user) throws Exception {
        BufferedReader filenameReader =
                new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        String filename = filenameReader.readLine();

        // GOOD: ensure that that /, \ and .. cannot possibly be in the payload
        if (filename.matches("[0-9a-fA-F]{20,}")) {
            final Path pathObject = FileSystems.getDefault().getPath(filename); // summary now, see https://github.com/github/codeql/commit/19cb7adb6db17a3131b7db93482abc6a0d93ceff#diff-4b91db1bd2a19ab607f83fbe858f0ceffd942d1fb246739c731112367c865f88L8

            BufferedReader fileReader = new BufferedReader(new FileReader(pathObject.toString())); // GOOD
            String fileLine = fileReader.readLine();
            while (fileLine != null) {
                sock.getOutputStream().write(fileLine.getBytes());
                fileLine = fileReader.readLine();
            }
        }

    }

}
