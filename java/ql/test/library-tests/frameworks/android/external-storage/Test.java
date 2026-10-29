import java.io.File;
import java.io.InputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.FileReader;
import java.io.RandomAccessFile;
import android.content.Context;
import android.os.Environment;

class Test {
    void sink(Object o) {}

    void test1(Context ctx) throws IOException {
        File f = new File(ctx.getExternalFilesDir(null), "file.txt");
        InputStream is = new FileInputStream(f);
        byte[] data = new byte[is.available()];
        is.read(data);
        sink(data); // $ hasTaintFlow
        is.close();
    }

    void test2(Context ctx) throws IOException {
        File f = new File(new File(new File(ctx.getExternalFilesDirs(null)[0], "things"), "stuff"), "file.txt");
        sink(new FileInputStream(f)); // $ hasTaintFlow
    }

    void test3(Context ctx) throws IOException {
        File f = new File(ctx.getExternalCacheDir(), "file.txt");
        sink(new FileInputStream(f)); // $ hasTaintFlow
    }

    void test4(Context ctx) throws IOException {
        File f = new File(ctx.getExternalCacheDirs()[0], "file.txt");
        sink(new FileInputStream(f)); // $ hasTaintFlow
    }

    void test5(Context ctx) throws IOException {
        File f = new File(Environment.getExternalStorageDirectory(), "file.txt");
        sink(new FileInputStream(f)); // $ hasTaintFlow
    }

    void test6(Context ctx) throws IOException {
        File f = new File(Environment.getExternalStoragePublicDirectory(null), "file.txt");
        sink(new FileInputStream(f)); // $ hasTaintFlow
    }

    static final File dir = Environment.getExternalStorageDirectory();
 
    void test7(Context ctx) throws IOException {
        File f = new File(dir, "file.txt");
        sink(new FileInputStream(f)); // $ hasTaintFlow 
    }

    void test8() throws IOException {
        File f = new File(dir, "file.txt");
        sink(new FileReader(f)); // $ hasTaintFlow 
        sink(new RandomAccessFile(f, "r")); // $ hasTaintFlow 
    }
 }