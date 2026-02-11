import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.compress.compressors.CompressorException;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.net.Socket;
import java.util.zip.DataFormatException;

public class Bombs {
    public void sendUserFileGood2(Socket sock) throws IOException {
        InputStream remoteFile = sock.getInputStream();
        // Zip
        ZipHandler.ZipInputStreamSafe2(remoteFile);
        ZipHandler.ZipInputStreamSafe(remoteFile);
        ZipHandler.ZipInputStreamUnsafe(remoteFile);
        ZipHandler.GZipInputStreamUnsafe(remoteFile);
        ZipHandler.InflaterInputStreamUnsafe(remoteFile);

        BufferedReader filenameReader =
                new BufferedReader(new InputStreamReader(sock.getInputStream(), "UTF-8"));
        String filename = filenameReader.readLine();
        try {
            ZipHandler.InflaterUnsafe(filename.getBytes());
        } catch (DataFormatException e) {
            throw new RuntimeException(e);
        }
        try {
            ZipHandler.ZipFile1(filename);
        } catch (DataFormatException e) {
            throw new RuntimeException(e);
        }

        // Zip4j
        Zip4jHandler.zip4jZipInputStream(remoteFile);
        Zip4jHandler.zip4jZipInputStreamSafe(remoteFile);
        // SnappyZip
        SnappyHandler.SnappyZipInputStream(remoteFile);
        // apache Commons
        CommonsCompressHandler.commonsCompressorInputStream(remoteFile);
        try {
            CommonsCompressHandler.commonsCompressArchiveInputStream(remoteFile);
            CommonsCompressHandler.commonsCompressArchiveStreamFactory(remoteFile);
        } catch (ArchiveException e) {
            throw new RuntimeException(e);
        }
        try {
            CommonsCompressHandler.commonsCompressCompressorStreamFactory(remoteFile);
        } catch (CompressorException e) {
            throw new RuntimeException(e);
        }

    }
}
