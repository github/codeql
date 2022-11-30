// Generated automatically from android.app.Dialog for testing purposes

package android.app;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Message;
import android.view.ActionMode;
import android.view.ContextMenu;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.SearchEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityEvent;

public class Dialog implements DialogInterface, KeyEvent.Callback, View.OnCreateContextMenuListener, Window.Callback
{
    protected Dialog() {}
    protected Dialog(Context p0, boolean p1, DialogInterface.OnCancelListener p2){}
    protected void onCreate(Bundle p0){}
    protected void onStart(){}
    protected void onStop(){}
    public <T extends View> T findViewById(int p0){ return null; }
    public ActionBar getActionBar(){ return null; }
    public ActionMode onWindowStartingActionMode(ActionMode.Callback p0){ return null; }
    public ActionMode onWindowStartingActionMode(ActionMode.Callback p0, int p1){ return null; }
    public Bundle onSaveInstanceState(){ return null; }
    public Dialog(Context p0){}
    public Dialog(Context p0, int p1){}
    public LayoutInflater getLayoutInflater(){ return null; }
    public View getCurrentFocus(){ return null; }
    public View onCreatePanelView(int p0){ return null; }
    public Window getWindow(){ return null; }
    public boolean dispatchGenericMotionEvent(MotionEvent p0){ return false; }
    public boolean dispatchKeyEvent(KeyEvent p0){ return false; }
    public boolean dispatchKeyShortcutEvent(KeyEvent p0){ return false; }
    public boolean dispatchPopulateAccessibilityEvent(AccessibilityEvent p0){ return false; }
    public boolean dispatchTouchEvent(MotionEvent p0){ return false; }
    public boolean dispatchTrackballEvent(MotionEvent p0){ return false; }
    public boolean isShowing(){ return false; }
    public boolean onContextItemSelected(MenuItem p0){ return false; }
    public boolean onCreateOptionsMenu(Menu p0){ return false; }
    public boolean onCreatePanelMenu(int p0, Menu p1){ return false; }
    public boolean onGenericMotionEvent(MotionEvent p0){ return false; }
    public boolean onKeyDown(int p0, KeyEvent p1){ return false; }
    public boolean onKeyLongPress(int p0, KeyEvent p1){ return false; }
    public boolean onKeyMultiple(int p0, int p1, KeyEvent p2){ return false; }
    public boolean onKeyShortcut(int p0, KeyEvent p1){ return false; }
    public boolean onKeyUp(int p0, KeyEvent p1){ return false; }
    public boolean onMenuItemSelected(int p0, MenuItem p1){ return false; }
    public boolean onMenuOpened(int p0, Menu p1){ return false; }
    public boolean onOptionsItemSelected(MenuItem p0){ return false; }
    public boolean onPrepareOptionsMenu(Menu p0){ return false; }
    public boolean onPreparePanel(int p0, View p1, Menu p2){ return false; }
    public boolean onSearchRequested(){ return false; }
    public boolean onSearchRequested(SearchEvent p0){ return false; }
    public boolean onTouchEvent(MotionEvent p0){ return false; }
    public boolean onTrackballEvent(MotionEvent p0){ return false; }
    public final <T extends View> T requireViewById(int p0){ return null; }
    public final Activity getOwnerActivity(){ return null; }
    public final Context getContext(){ return null; }
    public final SearchEvent getSearchEvent(){ return null; }
    public final boolean requestWindowFeature(int p0){ return false; }
    public final int getVolumeControlStream(){ return 0; }
    public final void setFeatureDrawable(int p0, Drawable p1){}
    public final void setFeatureDrawableAlpha(int p0, int p1){}
    public final void setFeatureDrawableResource(int p0, int p1){}
    public final void setFeatureDrawableUri(int p0, Uri p1){}
    public final void setOwnerActivity(Activity p0){}
    public final void setVolumeControlStream(int p0){}
    public void addContentView(View p0, ViewGroup.LayoutParams p1){}
    public void cancel(){}
    public void closeOptionsMenu(){}
    public void create(){}
    public void dismiss(){}
    public void hide(){}
    public void invalidateOptionsMenu(){}
    public void onActionModeFinished(ActionMode p0){}
    public void onActionModeStarted(ActionMode p0){}
    public void onAttachedToWindow(){}
    public void onBackPressed(){}
    public void onContentChanged(){}
    public void onContextMenuClosed(Menu p0){}
    public void onCreateContextMenu(ContextMenu p0, View p1, ContextMenu.ContextMenuInfo p2){}
    public void onDetachedFromWindow(){}
    public void onOptionsMenuClosed(Menu p0){}
    public void onPanelClosed(int p0, Menu p1){}
    public void onRestoreInstanceState(Bundle p0){}
    public void onWindowAttributesChanged(WindowManager.LayoutParams p0){}
    public void onWindowFocusChanged(boolean p0){}
    public void openContextMenu(View p0){}
    public void openOptionsMenu(){}
    public void registerForContextMenu(View p0){}
    public void setCancelMessage(Message p0){}
    public void setCancelable(boolean p0){}
    public void setCanceledOnTouchOutside(boolean p0){}
    public void setContentView(View p0){}
    public void setContentView(View p0, ViewGroup.LayoutParams p1){}
    public void setContentView(int p0){}
    public void setDismissMessage(Message p0){}
    public void setOnCancelListener(DialogInterface.OnCancelListener p0){}
    public void setOnDismissListener(DialogInterface.OnDismissListener p0){}
    public void setOnKeyListener(DialogInterface.OnKeyListener p0){}
    public void setOnShowListener(DialogInterface.OnShowListener p0){}
    public void setTitle(CharSequence p0){}
    public void setTitle(int p0){}
    public void show(){}
    public void takeKeyEvents(boolean p0){}
    public void unregisterForContextMenu(View p0){}
}
