// Generated automatically from android.text.method.MovementMethod for testing purposes

package android.text.method;

import android.text.Spannable;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.widget.TextView;

public interface MovementMethod
{
    boolean canSelectArbitrarily();
    boolean onGenericMotionEvent(TextView p0, Spannable p1, MotionEvent p2);
    boolean onKeyDown(TextView p0, Spannable p1, int p2, KeyEvent p3);
    boolean onKeyOther(TextView p0, Spannable p1, KeyEvent p2);
    boolean onKeyUp(TextView p0, Spannable p1, int p2, KeyEvent p3);
    boolean onTouchEvent(TextView p0, Spannable p1, MotionEvent p2);
    boolean onTrackballEvent(TextView p0, Spannable p1, MotionEvent p2);
    void initialize(TextView p0, Spannable p1);
    void onTakeFocus(TextView p0, Spannable p1, int p2);
}
