// Generated automatically from android.app.FragmentManager for testing purposes

package android.app;

import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.List;

abstract public class FragmentManager
{
    abstract static public class FragmentLifecycleCallbacks
    {
        public FragmentLifecycleCallbacks(){}
        public void onFragmentActivityCreated(FragmentManager p0, Fragment p1, Bundle p2){}
        public void onFragmentAttached(FragmentManager p0, Fragment p1, Context p2){}
        public void onFragmentCreated(FragmentManager p0, Fragment p1, Bundle p2){}
        public void onFragmentDestroyed(FragmentManager p0, Fragment p1){}
        public void onFragmentDetached(FragmentManager p0, Fragment p1){}
        public void onFragmentPaused(FragmentManager p0, Fragment p1){}
        public void onFragmentPreAttached(FragmentManager p0, Fragment p1, Context p2){}
        public void onFragmentPreCreated(FragmentManager p0, Fragment p1, Bundle p2){}
        public void onFragmentResumed(FragmentManager p0, Fragment p1){}
        public void onFragmentSaveInstanceState(FragmentManager p0, Fragment p1, Bundle p2){}
        public void onFragmentStarted(FragmentManager p0, Fragment p1){}
        public void onFragmentStopped(FragmentManager p0, Fragment p1){}
        public void onFragmentViewCreated(FragmentManager p0, Fragment p1, View p2, Bundle p3){}
        public void onFragmentViewDestroyed(FragmentManager p0, Fragment p1){}
    }
    public FragmentManager(){}
    public abstract Fragment findFragmentById(int p0);
    public abstract Fragment findFragmentByTag(String p0);
    public abstract Fragment getFragment(Bundle p0, String p1);
    public abstract Fragment getPrimaryNavigationFragment();
    public abstract Fragment.SavedState saveFragmentInstanceState(Fragment p0);
    public abstract FragmentManager.BackStackEntry getBackStackEntryAt(int p0);
    public abstract FragmentTransaction beginTransaction();
    public abstract List<Fragment> getFragments();
    public abstract boolean executePendingTransactions();
    public abstract boolean isDestroyed();
    public abstract boolean isStateSaved();
    public abstract boolean popBackStackImmediate();
    public abstract boolean popBackStackImmediate(String p0, int p1);
    public abstract boolean popBackStackImmediate(int p0, int p1);
    public abstract int getBackStackEntryCount();
    public abstract void addOnBackStackChangedListener(FragmentManager.OnBackStackChangedListener p0);
    public abstract void dump(String p0, FileDescriptor p1, PrintWriter p2, String[] p3);
    public abstract void popBackStack();
    public abstract void popBackStack(String p0, int p1);
    public abstract void popBackStack(int p0, int p1);
    public abstract void putFragment(Bundle p0, String p1, Fragment p2);
    public abstract void registerFragmentLifecycleCallbacks(FragmentManager.FragmentLifecycleCallbacks p0, boolean p1);
    public abstract void removeOnBackStackChangedListener(FragmentManager.OnBackStackChangedListener p0);
    public abstract void unregisterFragmentLifecycleCallbacks(FragmentManager.FragmentLifecycleCallbacks p0);
    public static int POP_BACK_STACK_INCLUSIVE = 0;
    public static void enableDebugLogging(boolean p0){}
    public void invalidateOptionsMenu(){}
    static public interface BackStackEntry
    {
        CharSequence getBreadCrumbShortTitle();
        CharSequence getBreadCrumbTitle();
        String getName();
        int getBreadCrumbShortTitleRes();
        int getBreadCrumbTitleRes();
        int getId();
    }
    static public interface OnBackStackChangedListener
    {
        void onBackStackChanged();
    }
}
