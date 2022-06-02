// Generated automatically from android.text.method.KeyListener for testing purposes

package android.text.method;

import android.text.Editable;
import android.view.KeyEvent;
import android.view.View;

public interface KeyListener
{
    boolean onKeyDown(View p0, Editable p1, int p2, KeyEvent p3);
    boolean onKeyOther(View p0, Editable p1, KeyEvent p2);
    boolean onKeyUp(View p0, Editable p1, int p2, KeyEvent p3);
    int getInputType();
    void clearMetaKeyState(View p0, Editable p1, int p2);
}
