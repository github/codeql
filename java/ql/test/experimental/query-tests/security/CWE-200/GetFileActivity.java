import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class GetFileActivity extends Activity {
    public static final int REQUEST_CODE__SELECT_CONTENT_FROM_APPS = 99;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(-1);

        Intent action = new Intent(Intent.ACTION_GET_CONTENT);
        action = action.setType("*/*").addCategory(Intent.CATEGORY_OPENABLE);
        action.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);

        startActivityForResult(
                Intent.createChooser(action, "Open File From Selected Application"), REQUEST_CODE__SELECT_CONTENT_FROM_APPS
        );
    }
}
