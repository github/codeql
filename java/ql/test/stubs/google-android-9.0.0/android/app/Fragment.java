// Generated automatically from android.app.Fragment for testing purposes

package android.app;

import android.animation.Animator;
import android.app.Activity;
import android.app.FragmentManager;
import android.app.LoaderManager;
import android.app.SharedElementCallback;
import android.content.ComponentCallbacks2;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.transition.Transition;
import android.util.AttributeSet;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import java.io.FileDescriptor;
import java.io.PrintWriter;

public class Fragment implements ComponentCallbacks2, View.OnCreateContextMenuListener
{
    public Animator onCreateAnimator(int p0, boolean p1, int p2){ return null; }
    public Context getContext(){ return null; }
    public Fragment(){}
    public LayoutInflater onGetLayoutInflater(Bundle p0){ return null; }
    public LoaderManager getLoaderManager(){ return null; }
    public String toString(){ return null; }
    public Transition getEnterTransition(){ return null; }
    public Transition getExitTransition(){ return null; }
    public Transition getReenterTransition(){ return null; }
    public Transition getReturnTransition(){ return null; }
    public Transition getSharedElementEnterTransition(){ return null; }
    public Transition getSharedElementReturnTransition(){ return null; }
    public View getView(){ return null; }
    public View onCreateView(LayoutInflater p0, ViewGroup p1, Bundle p2){ return null; }
    public boolean getAllowEnterTransitionOverlap(){ return false; }
    public boolean getAllowReturnTransitionOverlap(){ return false; }
    public boolean getUserVisibleHint(){ return false; }
    public boolean onContextItemSelected(MenuItem p0){ return false; }
    public boolean onOptionsItemSelected(MenuItem p0){ return false; }
    public boolean shouldShowRequestPermissionRationale(String p0){ return false; }
    public final Activity getActivity(){ return null; }
    public final Bundle getArguments(){ return null; }
    public final CharSequence getText(int p0){ return null; }
    public final Fragment getParentFragment(){ return null; }
    public final Fragment getTargetFragment(){ return null; }
    public final FragmentManager getChildFragmentManager(){ return null; }
    public final FragmentManager getFragmentManager(){ return null; }
    public final LayoutInflater getLayoutInflater(){ return null; }
    public final Object getHost(){ return null; }
    public final Resources getResources(){ return null; }
    public final String getString(int p0){ return null; }
    public final String getString(int p0, Object... p1){ return null; }
    public final String getTag(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean getRetainInstance(){ return false; }
    public final boolean isAdded(){ return false; }
    public final boolean isDetached(){ return false; }
    public final boolean isHidden(){ return false; }
    public final boolean isInLayout(){ return false; }
    public final boolean isRemoving(){ return false; }
    public final boolean isResumed(){ return false; }
    public final boolean isStateSaved(){ return false; }
    public final boolean isVisible(){ return false; }
    public final int getId(){ return 0; }
    public final int getTargetRequestCode(){ return 0; }
    public final int hashCode(){ return 0; }
    public final void requestPermissions(String[] p0, int p1){}
    public static Fragment instantiate(Context p0, String p1){ return null; }
    public static Fragment instantiate(Context p0, String p1, Bundle p2){ return null; }
    public void dump(String p0, FileDescriptor p1, PrintWriter p2, String[] p3){}
    public void onActivityCreated(Bundle p0){}
    public void onActivityResult(int p0, int p1, Intent p2){}
    public void onAttach(Activity p0){}
    public void onAttach(Context p0){}
    public void onAttachFragment(Fragment p0){}
    public void onConfigurationChanged(Configuration p0){}
    public void onCreate(Bundle p0){}
    public void onCreateContextMenu(ContextMenu p0, View p1, ContextMenu.ContextMenuInfo p2){}
    public void onCreateOptionsMenu(Menu p0, MenuInflater p1){}
    public void onDestroy(){}
    public void onDestroyOptionsMenu(){}
    public void onDestroyView(){}
    public void onDetach(){}
    public void onHiddenChanged(boolean p0){}
    public void onInflate(Activity p0, AttributeSet p1, Bundle p2){}
    public void onInflate(AttributeSet p0, Bundle p1){}
    public void onInflate(Context p0, AttributeSet p1, Bundle p2){}
    public void onLowMemory(){}
    public void onMultiWindowModeChanged(boolean p0){}
    public void onMultiWindowModeChanged(boolean p0, Configuration p1){}
    public void onOptionsMenuClosed(Menu p0){}
    public void onPause(){}
    public void onPictureInPictureModeChanged(boolean p0){}
    public void onPictureInPictureModeChanged(boolean p0, Configuration p1){}
    public void onPrepareOptionsMenu(Menu p0){}
    public void onRequestPermissionsResult(int p0, String[] p1, int[] p2){}
    public void onResume(){}
    public void onSaveInstanceState(Bundle p0){}
    public void onStart(){}
    public void onStop(){}
    public void onTrimMemory(int p0){}
    public void onViewCreated(View p0, Bundle p1){}
    public void onViewStateRestored(Bundle p0){}
    public void postponeEnterTransition(){}
    public void registerForContextMenu(View p0){}
    public void setAllowEnterTransitionOverlap(boolean p0){}
    public void setAllowReturnTransitionOverlap(boolean p0){}
    public void setArguments(Bundle p0){}
    public void setEnterSharedElementCallback(SharedElementCallback p0){}
    public void setEnterTransition(Transition p0){}
    public void setExitSharedElementCallback(SharedElementCallback p0){}
    public void setExitTransition(Transition p0){}
    public void setHasOptionsMenu(boolean p0){}
    public void setInitialSavedState(Fragment.SavedState p0){}
    public void setMenuVisibility(boolean p0){}
    public void setReenterTransition(Transition p0){}
    public void setRetainInstance(boolean p0){}
    public void setReturnTransition(Transition p0){}
    public void setSharedElementEnterTransition(Transition p0){}
    public void setSharedElementReturnTransition(Transition p0){}
    public void setTargetFragment(Fragment p0, int p1){}
    public void setUserVisibleHint(boolean p0){}
    public void startActivity(Intent p0){}
    public void startActivity(Intent p0, Bundle p1){}
    public void startActivityForResult(Intent p0, int p1){}
    public void startActivityForResult(Intent p0, int p1, Bundle p2){}
    public void startIntentSenderForResult(IntentSender p0, int p1, Intent p2, int p3, int p4, int p5, Bundle p6){}
    public void startPostponedEnterTransition(){}
    public void unregisterForContextMenu(View p0){}
    static public class SavedState implements Parcelable
    {
        public int describeContents(){ return 0; }
        public static Parcelable.ClassLoaderCreator<Fragment.SavedState> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
