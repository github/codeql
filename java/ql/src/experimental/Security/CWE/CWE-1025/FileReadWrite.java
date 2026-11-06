public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    // BAD:openFileOutput() uses Context.MODE_WORLD_READABLE mode
    void test_file_read() {
        try {
            FileOutputStream outputStream = this.openFileOutput("test_read.txt", Context.MODE_WORLD_READABLE);
            outputStream.write("123".getBytes(StandardCharsets.UTF_8));
            outputStream.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // BAD:openFileOutput() uses Context.MODE_WORLD_READABLE mode
    void test_file_read2() {
        try {
            openFileOutput("", 0);
            FileOutputStream outputStream = this.openFileOutput("test_all222.txt", 1);
            outputStream.write("123".getBytes(StandardCharsets.UTF_8));
            outputStream.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    // BAD:openFileOutput() uses Context.MODE_WORLD_WRITEABLE mode
    void test_file_write() {
        try {
            FileOutputStream outputStream = this.openFileOutput("test_write.txt", Context.MODE_WORLD_WRITEABLE);
            outputStream.write("123".getBytes(StandardCharsets.UTF_8));
            outputStream.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // BAD:openFileOutput() uses the Context.MODE_WORLD_READABLE mode and Context.MODE_WORLD_WRITEABLE mode
    void test_file_read_write() {
        try {
            FileOutputStream outputStream = this.openFileOutput("test_read_write.txt", Context.MODE_WORLD_READABLE | Context.MODE_WORLD_WRITEABLE);
            outputStream.write("123".getBytes(StandardCharsets.UTF_8));
            outputStream.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // BAD:openFileOutput() uses the Context.MODE_WORLD_READABLE mode and Context.MODE_WORLD_WRITEABLE mode
    void test_file_all() {
        try {
            FileOutputStream outputStream = this.openFileOutput("test_all.txt", Context.MODE_PRIVATE | Context.MODE_WORLD_READABLE | Context.MODE_WORLD_WRITEABLE);
            outputStream.write("123".getBytes(StandardCharsets.UTF_8));
            outputStream.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    //GOOD:openFileOutput() uses the Context.MODE_PRIVATE mode
    void test_file_private() {
        try {
            FileOutputStream outputStream = this.openFileOutput("test_private.txt", Context.MODE_PRIVATE);
            outputStream.write("123".getBytes(StandardCharsets.UTF_8));
            outputStream.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}
