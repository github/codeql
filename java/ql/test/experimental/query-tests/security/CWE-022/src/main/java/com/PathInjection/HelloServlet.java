package com.PathInjection;

import java.io.*;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Path;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.lingala.zip4j.ZipFile;

@WebServlet(
    name = "helloServlet",
    urlPatterns = {"/hello"})
@MultipartConfig()
public class HelloServlet extends HttpServlet {

  public void init() {}

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String path = request.getParameter("path");
    Path src = Path.of(path);
    File srcF = new File(path);
    new CommonsIOPathInjection().PathInjection(src, srcF);
    new SpringIoPathInjection().PathInjection(path);
    S3PathInjection s3PathInjection = new S3PathInjection();
    s3PathInjection.downloadFileResumable(src.toUri());
    s3PathInjection.downloadFile(path);
    s3PathInjection.downloadObjectsToDirectory(src.toUri());
    s3PathInjection.uploadFileResumable(src.toUri());
    s3PathInjection.uploadDirectory(src.toUri());
    s3PathInjection.uploadFile(src.toUri());

    ZipFile zipfile = new ZipFile(path);
    zipfile.extractAll(path);
    new java.util.zip.ZipFile(path);

    PrintWriter out = response.getWriter();
    response.setContentType("text/html");
    out.println("<html><body>end</body></html>");
  }
}
