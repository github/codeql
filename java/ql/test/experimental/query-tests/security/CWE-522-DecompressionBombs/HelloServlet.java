import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.compress.compressors.CompressorException;
import org.apache.commons.io.IOUtils;

import java.io.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.zip.DataFormatException;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;

public class Bombs extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException, ServletException, IOException {
        response.setContentType("text/html");
        Part remoteFile = request.getPart("zipFile");
        // Zip
        ZipHandler.ZipInputStreamSafe2(remoteFile.getInputStream());
        ZipHandler.ZipInputStreamSafe(request.getPart("zipFile").getInputStream());
        ZipHandler.ZipInputStreamUnsafe(remoteFile.getInputStream());
        ZipHandler.GZipInputStreamUnsafe(request.getPart("zipFile").getInputStream());
        ZipHandler.InflaterInputStreamUnsafe(request.getPart("zipFile").getInputStream());
        try {
            ZipHandler.InflaterUnsafe(request.getParameter("data").getBytes(StandardCharsets.UTF_8));
        } catch (DataFormatException e) {
            throw new RuntimeException(e);
        }
        try {
           ZipHandler. ZipFile1(request.getParameter("zipFileName"));
        } catch (DataFormatException e) {
            throw new RuntimeException(e);
        }

        // Zip4j
        Zip4jHandler.zip4jZipInputStream(remoteFile.getInputStream());
        Zip4jHandler.zip4jZipInputStreamSafe(remoteFile.getInputStream());
        // SnappyZip
        SnappyHandler.SnappyZipInputStream(remoteFile.getInputStream());
        // apache Commons
        commonsCompressArchiveInputStream2(remoteFile.getInputStream());
        CommonsCompressHandler.commonsCompressorInputStream(remoteFile.getInputStream());
        try {
            CommonsCompressHandler.commonsCompressArchiveInputStream(remoteFile.getInputStream());
            CommonsCompressHandler.commonsCompressArchiveStreamFactory(remoteFile.getInputStream());
        } catch (ArchiveException e) {
            throw new RuntimeException(e);
        }
        try {
            CommonsCompressHandler.commonsCompressCompressorStreamFactory(remoteFile.getInputStream());
        } catch (CompressorException e) {
            throw new RuntimeException(e);
        }

        PrintWriter out = response.getWriter();
        out.println("<html><body>end</body></html>");
    }
}
