// Generated automatically from android.app.AlertDialog for testing purposes

package android.app;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.database.Cursor;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Adapter;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListAdapter;
import android.widget.ListView;

public class AlertDialog extends Dialog implements DialogInterface
{
    protected AlertDialog() {}
    protected AlertDialog(Context p0){}
    protected AlertDialog(Context p0, boolean p1, DialogInterface.OnCancelListener p2){}
    protected AlertDialog(Context p0, int p1){}
    protected void onCreate(Bundle p0){}
    public Button getButton(int p0){ return null; }
    public ListView getListView(){ return null; }
    public boolean onKeyDown(int p0, KeyEvent p1){ return false; }
    public boolean onKeyUp(int p0, KeyEvent p1){ return false; }
    public static int THEME_DEVICE_DEFAULT_DARK = 0;
    public static int THEME_DEVICE_DEFAULT_LIGHT = 0;
    public static int THEME_HOLO_DARK = 0;
    public static int THEME_HOLO_LIGHT = 0;
    public static int THEME_TRADITIONAL = 0;
    public void setButton(CharSequence p0, DialogInterface.OnClickListener p1){}
    public void setButton(CharSequence p0, Message p1){}
    public void setButton(int p0, CharSequence p1, DialogInterface.OnClickListener p2){}
    public void setButton(int p0, CharSequence p1, Message p2){}
    public void setButton2(CharSequence p0, DialogInterface.OnClickListener p1){}
    public void setButton2(CharSequence p0, Message p1){}
    public void setButton3(CharSequence p0, DialogInterface.OnClickListener p1){}
    public void setButton3(CharSequence p0, Message p1){}
    public void setCustomTitle(View p0){}
    public void setIcon(Drawable p0){}
    public void setIcon(int p0){}
    public void setIconAttribute(int p0){}
    public void setInverseBackgroundForced(boolean p0){}
    public void setMessage(CharSequence p0){}
    public void setTitle(CharSequence p0){}
    public void setView(View p0){}
    public void setView(View p0, int p1, int p2, int p3, int p4){}
    static public class Builder
    {
        protected Builder() {}
        public AlertDialog create(){ return null; }
        public AlertDialog show(){ return null; }
        public AlertDialog.Builder setAdapter(ListAdapter p0, DialogInterface.OnClickListener p1){ return null; }
        public AlertDialog.Builder setCancelable(boolean p0){ return null; }
        public AlertDialog.Builder setCursor(Cursor p0, DialogInterface.OnClickListener p1, String p2){ return null; }
        public AlertDialog.Builder setCustomTitle(View p0){ return null; }
        public AlertDialog.Builder setIcon(Drawable p0){ return null; }
        public AlertDialog.Builder setIcon(int p0){ return null; }
        public AlertDialog.Builder setIconAttribute(int p0){ return null; }
        public AlertDialog.Builder setInverseBackgroundForced(boolean p0){ return null; }
        public AlertDialog.Builder setItems(CharSequence[] p0, DialogInterface.OnClickListener p1){ return null; }
        public AlertDialog.Builder setItems(int p0, DialogInterface.OnClickListener p1){ return null; }
        public AlertDialog.Builder setMessage(CharSequence p0){ return null; }
        public AlertDialog.Builder setMessage(int p0){ return null; }
        public AlertDialog.Builder setMultiChoiceItems(CharSequence[] p0, boolean[] p1, DialogInterface.OnMultiChoiceClickListener p2){ return null; }
        public AlertDialog.Builder setMultiChoiceItems(Cursor p0, String p1, String p2, DialogInterface.OnMultiChoiceClickListener p3){ return null; }
        public AlertDialog.Builder setMultiChoiceItems(int p0, boolean[] p1, DialogInterface.OnMultiChoiceClickListener p2){ return null; }
        public AlertDialog.Builder setNegativeButton(CharSequence p0, DialogInterface.OnClickListener p1){ return null; }
        public AlertDialog.Builder setNegativeButton(int p0, DialogInterface.OnClickListener p1){ return null; }
        public AlertDialog.Builder setNeutralButton(CharSequence p0, DialogInterface.OnClickListener p1){ return null; }
        public AlertDialog.Builder setNeutralButton(int p0, DialogInterface.OnClickListener p1){ return null; }
        public AlertDialog.Builder setOnCancelListener(DialogInterface.OnCancelListener p0){ return null; }
        public AlertDialog.Builder setOnDismissListener(DialogInterface.OnDismissListener p0){ return null; }
        public AlertDialog.Builder setOnItemSelectedListener(AdapterView.OnItemSelectedListener p0){ return null; }
        public AlertDialog.Builder setOnKeyListener(DialogInterface.OnKeyListener p0){ return null; }
        public AlertDialog.Builder setPositiveButton(CharSequence p0, DialogInterface.OnClickListener p1){ return null; }
        public AlertDialog.Builder setPositiveButton(int p0, DialogInterface.OnClickListener p1){ return null; }
        public AlertDialog.Builder setSingleChoiceItems(CharSequence[] p0, int p1, DialogInterface.OnClickListener p2){ return null; }
        public AlertDialog.Builder setSingleChoiceItems(Cursor p0, int p1, String p2, DialogInterface.OnClickListener p3){ return null; }
        public AlertDialog.Builder setSingleChoiceItems(ListAdapter p0, int p1, DialogInterface.OnClickListener p2){ return null; }
        public AlertDialog.Builder setSingleChoiceItems(int p0, int p1, DialogInterface.OnClickListener p2){ return null; }
        public AlertDialog.Builder setTitle(CharSequence p0){ return null; }
        public AlertDialog.Builder setTitle(int p0){ return null; }
        public AlertDialog.Builder setView(View p0){ return null; }
        public AlertDialog.Builder setView(int p0){ return null; }
        public Builder(Context p0){}
        public Builder(Context p0, int p1){}
        public Context getContext(){ return null; }
    }
}
