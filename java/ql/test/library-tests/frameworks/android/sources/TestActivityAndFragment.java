import android.app.Activity;
import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import androidx.fragment.app.FragmentTransaction;

public class TestActivityAndFragment extends Activity {

    private TestFragment frag;

    void sink(Object o) {}

    public void onCreate(Bundle saved) {
        FragmentTransaction ft = null;
        ft.add(0, frag);

    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        sink(requestCode); // safe
        sink(resultCode); // safe
        sink(data); // $ hasValueFlow
    }

    private class TestFragment extends Fragment {
        public void onCreate(Bundle savedInstance) {
            Intent implicitIntent = new Intent("SOME_ACTION");
            startActivityForResult(implicitIntent, 0);
        }

    }
}
