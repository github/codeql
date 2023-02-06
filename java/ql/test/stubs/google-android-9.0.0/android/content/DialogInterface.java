// Generated automatically from android.content.DialogInterface for testing purposes

package android.content;

import android.view.KeyEvent;

public interface DialogInterface
{
    static int BUTTON1 = 0;
    static int BUTTON2 = 0;
    static int BUTTON3 = 0;
    static int BUTTON_NEGATIVE = 0;
    static int BUTTON_NEUTRAL = 0;
    static int BUTTON_POSITIVE = 0;
    static public interface OnCancelListener
    {
        void onCancel(DialogInterface p0);
    }
    static public interface OnClickListener
    {
        void onClick(DialogInterface p0, int p1);
    }
    static public interface OnDismissListener
    {
        void onDismiss(DialogInterface p0);
    }
    static public interface OnKeyListener
    {
        boolean onKey(DialogInterface p0, int p1, KeyEvent p2);
    }
    static public interface OnMultiChoiceClickListener
    {
        void onClick(DialogInterface p0, int p1, boolean p2);
    }
    static public interface OnShowListener
    {
        void onShow(DialogInterface p0);
    }
    void cancel();
    void dismiss();
}
