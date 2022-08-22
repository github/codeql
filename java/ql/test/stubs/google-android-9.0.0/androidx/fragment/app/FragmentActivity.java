// Generated automatically from androidx.fragment.app.FragmentActivity for testing purposes

package androidx.fragment.app;

import java.io.FileDescriptor;
import java.io.PrintWriter;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import androidx.activity.ComponentActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.app.SharedElementCallback;
import androidx.loader.app.LoaderManager;

public class FragmentActivity extends ComponentActivity implements ActivityCompat.OnRequestPermissionsResultCallback, ActivityCompat.RequestPermissionsRequestCodeValidator
{
    protected boolean onPrepareOptionsPanel(View p0, Menu p1){ return false; }
    protected void onActivityResult(int p0, int p1, Intent p2){}
    protected void onDestroy(){}
    protected void onNewIntent(Intent p0){}
    protected void onPause(){}
    protected void onPostResume(){}
    protected void onResume(){}
    protected void onResumeFragments(){}
    protected void onSaveInstanceState(Bundle p0){}
    protected void onStart(){}
    protected void onStop(){}
    public FragmentActivity(){}
    public FragmentActivity(int p0){}
    public FragmentManager getSupportFragmentManager(){ return null; }
    public LoaderManager getSupportLoaderManager(){ return null; }
    public View onCreateView(String p0, Context p1, AttributeSet p2){ return null; }
    public View onCreateView(View p0, String p1, Context p2, AttributeSet p3){ return null; }
    public boolean onCreatePanelMenu(int p0, Menu p1){ return false; }
    public boolean onMenuItemSelected(int p0, MenuItem p1){ return false; }
    public boolean onPreparePanel(int p0, View p1, Menu p2){ return false; }
    public final void validateRequestPermissionsRequestCode(int p0){}
    public void dump(String p0, FileDescriptor p1, PrintWriter p2, String[] p3){}
    public void onAttachFragment(Fragment p0){}
    public void onConfigurationChanged(Configuration p0){}
    public void onLowMemory(){}
    public void onMultiWindowModeChanged(boolean p0){}
    public void onPanelClosed(int p0, Menu p1){}
    public void onPictureInPictureModeChanged(boolean p0){}
    public void onRequestPermissionsResult(int p0, String[] p1, int[] p2){}
    public void onStateNotSaved(){}
    public void setEnterSharedElementCallback(SharedElementCallback p0){}
    public void setExitSharedElementCallback(SharedElementCallback p0){}
    public void startActivityForResult(Intent p0, int p1){}
    public void startActivityForResult(Intent p0, int p1, Bundle p2){}
    public void startActivityFromFragment(Fragment p0, Intent p1, int p2){}
    public void startActivityFromFragment(Fragment p0, Intent p1, int p2, Bundle p3){}
    public void startIntentSenderForResult(IntentSender p0, int p1, Intent p2, int p3, int p4, int p5){}
    public void startIntentSenderForResult(IntentSender p0, int p1, Intent p2, int p3, int p4, int p5, Bundle p6){}
    public void startIntentSenderFromFragment(Fragment p0, IntentSender p1, int p2, Intent p3, int p4, int p5, int p6, Bundle p7){}
    public void supportFinishAfterTransition(){}
    public void supportInvalidateOptionsMenu(){}
    public void supportPostponeEnterTransition(){}
    public void supportStartPostponedEnterTransition(){}
}
