// Generated automatically from androidx.core.app.ActivityCompat for testing purposes

package androidx.core.app;

import android.app.Activity;
import android.content.Intent;
import android.content.IntentSender;
import android.net.Uri;
import android.os.Bundle;
import android.view.DragEvent;
import android.view.View;
import androidx.core.app.SharedElementCallback;
import androidx.core.content.ContextCompat;
import androidx.core.view.DragAndDropPermissionsCompat;

public class ActivityCompat extends ContextCompat
{
    protected ActivityCompat(){}
    public static <T extends View> T requireViewById(Activity p0, int p1){ return null; }
    public static ActivityCompat.PermissionCompatDelegate getPermissionCompatDelegate(){ return null; }
    public static DragAndDropPermissionsCompat requestDragAndDropPermissions(Activity p0, DragEvent p1){ return null; }
    public static Uri getReferrer(Activity p0){ return null; }
    public static boolean invalidateOptionsMenu(Activity p0){ return false; }
    public static boolean shouldShowRequestPermissionRationale(Activity p0, String p1){ return false; }
    public static void finishAffinity(Activity p0){}
    public static void finishAfterTransition(Activity p0){}
    public static void postponeEnterTransition(Activity p0){}
    public static void recreate(Activity p0){}
    public static void requestPermissions(Activity p0, String[] p1, int p2){}
    public static void setEnterSharedElementCallback(Activity p0, SharedElementCallback p1){}
    public static void setExitSharedElementCallback(Activity p0, SharedElementCallback p1){}
    public static void setPermissionCompatDelegate(ActivityCompat.PermissionCompatDelegate p0){}
    public static void startActivityForResult(Activity p0, Intent p1, int p2, Bundle p3){}
    public static void startIntentSenderForResult(Activity p0, IntentSender p1, int p2, Intent p3, int p4, int p5, int p6, Bundle p7){}
    public static void startPostponedEnterTransition(Activity p0){}
    static public interface OnRequestPermissionsResultCallback
    {
        void onRequestPermissionsResult(int p0, String[] p1, int[] p2);
    }
    static public interface PermissionCompatDelegate
    {
        boolean onActivityResult(Activity p0, int p1, int p2, Intent p3);
        boolean requestPermissions(Activity p0, String[] p1, int p2);
    }
    static public interface RequestPermissionsRequestCodeValidator
    {
        void validateRequestPermissionsRequestCode(int p0);
    }
}
