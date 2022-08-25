// Generated automatically from androidx.fragment.app.Fragment for testing purposes

package androidx.fragment.app;

import android.animation.Animator;
import android.app.Activity;
import android.content.ComponentCallbacks;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.AttributeSet;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import androidx.core.app.SharedElementCallback;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.lifecycle.HasDefaultViewModelProviderFactory;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.ViewModelProvider;
import androidx.lifecycle.ViewModelStore;
import androidx.lifecycle.ViewModelStoreOwner;
import androidx.loader.app.LoaderManager;
import androidx.savedstate.SavedStateRegistry;
import androidx.savedstate.SavedStateRegistryOwner;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.concurrent.TimeUnit;

public class Fragment implements ComponentCallbacks, HasDefaultViewModelProviderFactory, LifecycleOwner, SavedStateRegistryOwner, View.OnCreateContextMenuListener, ViewModelStoreOwner
{
    public Animation onCreateAnimation(int p0, boolean p1, int p2){ return null; }
    public Animator onCreateAnimator(int p0, boolean p1, int p2){ return null; }
    public Context getContext(){ return null; }
    public Fragment(){}
    public Fragment(int p0){}
    public LayoutInflater getLayoutInflater(Bundle p0){ return null; }
    public LayoutInflater onGetLayoutInflater(Bundle p0){ return null; }
    public Lifecycle getLifecycle(){ return null; }
    public LifecycleOwner getViewLifecycleOwner(){ return null; }
    public LoaderManager getLoaderManager(){ return null; }
    public Object getEnterTransition(){ return null; }
    public Object getExitTransition(){ return null; }
    public Object getReenterTransition(){ return null; }
    public Object getReturnTransition(){ return null; }
    public Object getSharedElementEnterTransition(){ return null; }
    public Object getSharedElementReturnTransition(){ return null; }
    public String toString(){ return null; }
    public View getView(){ return null; }
    public View onCreateView(LayoutInflater p0, ViewGroup p1, Bundle p2){ return null; }
    public ViewModelProvider.Factory getDefaultViewModelProviderFactory(){ return null; }
    public ViewModelStore getViewModelStore(){ return null; }
    public boolean getAllowEnterTransitionOverlap(){ return false; }
    public boolean getAllowReturnTransitionOverlap(){ return false; }
    public boolean getUserVisibleHint(){ return false; }
    public boolean onContextItemSelected(MenuItem p0){ return false; }
    public boolean onOptionsItemSelected(MenuItem p0){ return false; }
    public boolean shouldShowRequestPermissionRationale(String p0){ return false; }
    public final Bundle getArguments(){ return null; }
    public final Bundle requireArguments(){ return null; }
    public final CharSequence getText(int p0){ return null; }
    public final Context requireContext(){ return null; }
    public final Fragment getParentFragment(){ return null; }
    public final Fragment getTargetFragment(){ return null; }
    public final Fragment requireParentFragment(){ return null; }
    public final FragmentActivity getActivity(){ return null; }
    public final FragmentActivity requireActivity(){ return null; }
    public final FragmentManager getChildFragmentManager(){ return null; }
    public final FragmentManager getFragmentManager(){ return null; }
    public final FragmentManager getParentFragmentManager(){ return null; }
    public final FragmentManager requireFragmentManager(){ return null; }
    public final LayoutInflater getLayoutInflater(){ return null; }
    public final Object getHost(){ return null; }
    public final Object requireHost(){ return null; }
    public final Resources getResources(){ return null; }
    public final SavedStateRegistry getSavedStateRegistry(){ return null; }
    public final String getString(int p0){ return null; }
    public final String getString(int p0, Object... p1){ return null; }
    public final String getTag(){ return null; }
    public final View requireView(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean getRetainInstance(){ return false; }
    public final boolean hasOptionsMenu(){ return false; }
    public final boolean isAdded(){ return false; }
    public final boolean isDetached(){ return false; }
    public final boolean isHidden(){ return false; }
    public final boolean isInLayout(){ return false; }
    public final boolean isMenuVisible(){ return false; }
    public final boolean isRemoving(){ return false; }
    public final boolean isResumed(){ return false; }
    public final boolean isStateSaved(){ return false; }
    public final boolean isVisible(){ return false; }
    public final int getId(){ return 0; }
    public final int getTargetRequestCode(){ return 0; }
    public final int hashCode(){ return 0; }
    public final void postponeEnterTransition(long p0, TimeUnit p1){}
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
    public void onInflate(Context p0, AttributeSet p1, Bundle p2){}
    public void onLowMemory(){}
    public void onMultiWindowModeChanged(boolean p0){}
    public void onOptionsMenuClosed(Menu p0){}
    public void onPause(){}
    public void onPictureInPictureModeChanged(boolean p0){}
    public void onPrepareOptionsMenu(Menu p0){}
    public void onPrimaryNavigationFragmentChanged(boolean p0){}
    public void onRequestPermissionsResult(int p0, String[] p1, int[] p2){}
    public void onResume(){}
    public void onSaveInstanceState(Bundle p0){}
    public void onStart(){}
    public void onStop(){}
    public void onViewCreated(View p0, Bundle p1){}
    public void onViewStateRestored(Bundle p0){}
    public void postponeEnterTransition(){}
    public void registerForContextMenu(View p0){}
    public void setAllowEnterTransitionOverlap(boolean p0){}
    public void setAllowReturnTransitionOverlap(boolean p0){}
    public void setArguments(Bundle p0){}
    public void setEnterSharedElementCallback(SharedElementCallback p0){}
    public void setEnterTransition(Object p0){}
    public void setExitSharedElementCallback(SharedElementCallback p0){}
    public void setExitTransition(Object p0){}
    public void setHasOptionsMenu(boolean p0){}
    public void setInitialSavedState(Fragment.SavedState p0){}
    public void setMenuVisibility(boolean p0){}
    public void setReenterTransition(Object p0){}
    public void setRetainInstance(boolean p0){}
    public void setReturnTransition(Object p0){}
    public void setSharedElementEnterTransition(Object p0){}
    public void setSharedElementReturnTransition(Object p0){}
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
        protected SavedState() {}
        public int describeContents(){ return 0; }
        public static Parcelable.Creator<Fragment.SavedState> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
}
