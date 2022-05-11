import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.RandomAccessFile;
import java.io.Writer;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.List;
import java.util.Locale;
import android.app.Activity;
import android.content.Context;
import androidx.security.crypto.EncryptedFile;
import androidx.security.crypto.EncryptedFile.FileEncryptionScheme;

public class CleartextStorageAndroidFilesystemTest extends Activity {

  public void testWriteLocalFile(Context context, String name, String password) throws Exception {

    // FileOutputStream
    {
      // java.io;FileOutputStream;false;FileOutputStream;;;Argument[0];create-file
      FileOutputStream os = new FileOutputStream("some_file.txt");
      // Nested writers
      Writer writer = new BufferedWriter(new OutputStreamWriter(os, "utf-8"));
      // java.io;FileOutputStream;false;write;;;Argument[0];write-file
      writer.write(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      writer.close();
    }

    // RandomAccessFile
    {
      // java.io;RandomAccessFile;false;RandomAccessFile;;;Argument[0];create-file
      RandomAccessFile f = new RandomAccessFile("some_file.txt", "r");
      String contents = name + ":" + password;
      // java.io;RandomAccessFile;false;write;;;Argument[0];write-file
      f.write(contents.getBytes()); // $ hasCleartextStorageAndroidFilesystem
      f.close();
    }
    {
      // try-with-resources
      try (RandomAccessFile f = new RandomAccessFile(new File("some_file.txt"), "r")) {
        // java.io;RandomAccessFile;false;writeBytes;;;Argument[0];write-file
        f.writeBytes(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      }
    }
    {
      RandomAccessFile f = new RandomAccessFile("some_file.txt", "r");
      // java.io;RandomAccessFile;false;writeChars;;;Argument[0];write-file
      f.writeChars(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      f.close();
    }
    {
      RandomAccessFile f = new RandomAccessFile("some_file.txt", "r");
      // java.io;RandomAccessFile;false;writeUTF;;;Argument[0];write-file
      f.writeUTF(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      f.close();
    }

    // FileWriter
    {
      // java.io;FileWriter;false;FileWriter;;;Argument[0];create-file
      FileWriter fw = new FileWriter("some_file.txt");
      // java.io;Writer;true;append;;;Argument[0];write-file
      fw.append(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      fw.close();
    }
    {
      // try-with-resources
      try (FileWriter fw = new FileWriter("some_file.txt")) {
        // java.io;Writer;true;write;;;Argument[0];write-file
        fw.write(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      }
    }

    // PrintStream
    {
      // java.io;PrintStream;false;PrintStream;(File);;Argument[0];create-file"
      PrintStream ps = new PrintStream(new File("some_file.txt"));
      // java.io;PrintStream;true;append;;;Argument[0];write-file
      ps.append(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      ps.close();
    }
    {
      // java.io;PrintStream;false;PrintStream;(File,String);;Argument[0];create-file
      PrintStream ps = new PrintStream(new File("some_file.txt"), "utf-8");
      // java.io;PrintStream;true;format;(String,Object[]);;Argument[0..1];write-file
      ps.format("%s:" + password, name); // $ hasCleartextStorageAndroidFilesystem
      ps.format("%s:%s", name, password); // $ hasCleartextStorageAndroidFilesystem
      ps.close();
    }
    {
      // java.io;PrintStream;false;PrintStream;(File,Charset);;Argument[0];create-file
      PrintStream ps = new PrintStream(new File("some_file.txt"), Charset.defaultCharset());
      // java.io;PrintStream;true;format;(Locale,String,Object[]);;Argument[1..2];write-file
      ps.format(Locale.US, "%s:" + password, name); // $ hasCleartextStorageAndroidFilesystem
      ps.format(Locale.US, "%s:%s", name, password); // $ hasCleartextStorageAndroidFilesystem
      ps.close();
    }
    {
      // java.io;PrintStream;false;PrintStream;(String);;Argument[0];create-file
      PrintStream ps = new PrintStream("some_file.txt");
      // java.io;PrintStream;true;print;;;Argument[0];write-file
      ps.print(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      ps.close();
    }
    {
      // java.io;PrintStream;false;PrintStream;(String,String);;Argument[0];create-file
      PrintStream ps = new PrintStream("some_file.txt", "utf-8");
      // java.io;PrintStream;true;printf;(String,Object[]);;Argument[0..1];write-file
      ps.printf("%s:" + password, name); // $ hasCleartextStorageAndroidFilesystem
      ps.printf("%s:%s", name, password); // $ hasCleartextStorageAndroidFilesystem
      ps.close();
    }
    {
      // java.io;PrintStream;false;PrintStream;(String,Charset);;Argument[0];create-file
      PrintStream ps = new PrintStream("some_file.txt", Charset.defaultCharset());
      // java.io;PrintStream;true;printf;(Locale,String,Object[]);;Argument[1..2];write-file
      ps.printf(Locale.US, "%s:" + password, name); // $ hasCleartextStorageAndroidFilesystem
      ps.printf(Locale.US, "%s:%s", name, password); // $ hasCleartextStorageAndroidFilesystem
      ps.close();
    }
    {
      PrintStream ps = new PrintStream("some_file.txt");
      // java.io;PrintStream;true;println;;;Argument[0];write-file
      ps.println(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      ps.close();
    }
    {
      PrintStream ps = new PrintStream("some_file.txt");
      String contents = name + ":" + password;
      // java.io;PrintStream;true;write;;;Argument[0];write-file
      ps.write(contents.getBytes()); // $ hasCleartextStorageAndroidFilesystem
      ps.close();
    }
    {
      PrintStream ps = new PrintStream("some_file.txt");
      String contents = name + ":" + password;
      // java.io;PrintStream;true;writeBytes;;;Argument[0];write-file
      ps.writeBytes(contents.getBytes()); // $ hasCleartextStorageAndroidFilesystem
      ps.close();
    }

    // PrintWriter
    {
      // java.io;PrintWriter;false;PrintWriter;(File);;Argument[0];create-file
      PrintWriter pw = new PrintWriter(new File("some_file.txt"));
      // java.io;Writer;true;append;;;Argument[0];write-file
      pw.append(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      pw.close();
    }
    {
      // try-with-resources
      try (PrintWriter pw = new PrintWriter(new File("some_file.txt"))) {
        // java.io;PrintWriter;false;format;(String,Object[]);;Argument[0..1];write-file
        pw.format("%s:" + password, name); // $ hasCleartextStorageAndroidFilesystem
        pw.format("%s:%s", name, password); // $ hasCleartextStorageAndroidFilesystem
      }
    }
    {
      // java.io;PrintWriter;false;PrintWriter;(File,String);;Argument[0];create-file
      PrintWriter pw = new PrintWriter(new File("some_file.txt"), "utf-8");
      // java.io;PrintWriter;false;format;(Locale,String,Object[]);;Argument[1..2];write-file
      pw.format(Locale.US, "%s:" + password, name); // $ hasCleartextStorageAndroidFilesystem
      pw.format(Locale.US, "%s:%s", name, password); // $ hasCleartextStorageAndroidFilesystem
      pw.close();
    }
    {
      // java.io;PrintWriter;false;PrintWriter;(File,Charset);;Argument[0];create-file
      PrintWriter pw = new PrintWriter(new File("some_file.txt"), Charset.defaultCharset());
      // java.io;PrintWriter;false;print;;;Argument[0];write-file
      pw.print(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      pw.close();
    }

    {
      // java.io;PrintWriter;false;PrintWriter;(String);;Argument[0];create-file
      PrintWriter pw = new PrintWriter("some_file.txt");
      // java.io;PrintWriter;false;printf;(String,Object[]);;Argument[0..1];write-file
      pw.printf("%s:" + password, name); // $ hasCleartextStorageAndroidFilesystem
      pw.printf("%s:%s", name, password); // $ hasCleartextStorageAndroidFilesystem
      pw.close();
    }
    {
      // java.io;PrintWriter;false;PrintWriter;(String,String);;Argument[0];create-file
      PrintWriter pw = new PrintWriter("some_file.txt", "utf-8");
      // java.io;PrintWriter;false;printf;(Locale,String,Object[]);;Argument[1..2];write-file
      pw.printf(Locale.US, "%s:" + password, name); // $ hasCleartextStorageAndroidFilesystem
      pw.printf(Locale.US, "%s:%s", name, password); // $ hasCleartextStorageAndroidFilesystem
      pw.close();
    }
    {
      // java.io;PrintWriter;false;PrintWriter;(String,Charset);;Argument[0];create-file
      PrintWriter pw = new PrintWriter("some_file.txt", Charset.defaultCharset());
      // java.io;PrintWriter;false;println;;;Argument[0];write-file
      pw.println(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      pw.close();
    }
    {
      PrintWriter pw = new PrintWriter("some_file.txt");
      // java.io;Writer;true;write;;;Argument[0];write-file
      pw.write(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      pw.close();
    }

    // java.nio.files.Files
    {
      // java.nio.file;Files;false;newBufferedWriter;;;Argument[0];create-file
      BufferedWriter bw = Files.newBufferedWriter(Path.of("some_file.txt"));
      bw.write(name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
      bw.close();
    }
    {
      // java.nio.file;Files;false;newOutputStream;;;Argument[0];create-file
      // try-with-resources
      try (OutputStream os = Files.newOutputStream(Path.of("some_file.txt"))) {
        String contents = name + ":" + password;
        os.write(contents.getBytes());
      }
    }
    {
      Path path = Path.of("some_file.txt");
      String contents = name + ":" + password;
      // java.nio.file;Files;false;write;;;Argument[0];create-file
      // java.nio.file;Files;false;write;;;Argument[1];write-file",
      Files.write(path, contents.getBytes()); // $ hasCleartextStorageAndroidFilesystem
    }
    {
      Path path = Path.of("some_file.txt");
      String contents = name + ":" + password;
      Files.write(path, List.of(contents)); // $ hasCleartextStorageAndroidFilesystem
    }
    {
      Path path = Path.of("some_file.txt");
      // java.nio.file;Files;false;writeString;;;Argument[0];create-file
      // java.nio.file;Files;false;writeString;;;Argument[1];write-file"
      Files.writeString(path, name + ":" + password); // $ hasCleartextStorageAndroidFilesystem
    }

    // Safe writes
    {
      FileWriter fw = new FileWriter("some_file.txt");
      fw.write(name + ":" + hash(password)); // Safe - using a hash
      fw.close();
    }
    {
      Writer writer = new OutputStreamWriter(new ByteArrayOutputStream(), "utf-8");
      writer.write(name + ":" + password); // Safe - not writing to a file
      writer.close();
    }
    {
      File file = new File("some_file.txt");
      String contents = name + ":" + password;
      EncryptedFile encryptedFile = new EncryptedFile.Builder(file, context, "some_key",
          FileEncryptionScheme.AES256_GCM_HKDF_4KB).build();
      FileOutputStream encryptedOutputStream = encryptedFile.openFileOutput();
      encryptedOutputStream.write(contents.getBytes()); // Safe - using EncryptedFile
    }
  }

  private static String hash(String cleartext) throws Exception {
    MessageDigest digest = MessageDigest.getInstance("SHA-256");
    byte[] hash = digest.digest(cleartext.getBytes(StandardCharsets.UTF_8));
    String encoded = Base64.getEncoder().encodeToString(hash);
    return encoded;
  }

}
