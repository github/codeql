import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.net.Socket;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;

public class TaintedPath {
    public void sendUserFile(Socket sock, String user) throws IOException {
	    BufferedReader filenameReader = new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
	    String filename = filenameReader.readLine();
	    // BAD: read from a file without checking its path
    	BufferedReader fileReader = new BufferedReader(new FileReader(filename));
        String fileLine = fileReader.readLine();
        while(fileLine != null) {
        	sock.getOutputStream().write(fileLine.getBytes());
        	fileLine = fileReader.readLine();
        }
    }

    public void sendUserFileGood(Socket sock, String user) throws IOException {
        BufferedReader filenameReader = new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        String filename = filenameReader.readLine();
        // GOOD: ensure that the file is in a designated folder in the user's home directory
        if (!filename.contains("..") && filename.startsWith("/home/" + user + "/public/")) {
            BufferedReader fileReader = new BufferedReader(new FileReader(filename));
            String fileLine = fileReader.readLine();
            while(fileLine != null) {
                sock.getOutputStream().write(fileLine.getBytes());
                fileLine = fileReader.readLine();
            }
        }
    }
}
