// Generated automatically from androidx.fragment.app.FragmentManager for testing purposes

package androidx.fragment.app;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import androidx.fragment.app.BackStackRecord;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentFactory;
import androidx.fragment.app.FragmentTransaction;
import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

abstract public class FragmentManager {
    abstract static public class FragmentLifecycleCallbacks {
        public FragmentLifecycleCallbacks() {}

        public void onFragmentActivityCreated(FragmentManager p0, Fragment p1, Bundle p2) {}

        public void onFragmentAttached(FragmentManager p0, Fragment p1, Context p2) {}

        public void onFragmentCreated(FragmentManager p0, Fragment p1, Bundle p2) {}

        public void onFragmentDestroyed(FragmentManager p0, Fragment p1) {}

        public void onFragmentDetached(FragmentManager p0, Fragment p1) {}

        public void onFragmentPaused(FragmentManager p0, Fragment p1) {}

        public void onFragmentPreAttached(FragmentManager p0, Fragment p1, Context p2) {}

        public void onFragmentPreCreated(FragmentManager p0, Fragment p1, Bundle p2) {}

        public void onFragmentResumed(FragmentManager p0, Fragment p1) {}

        public void onFragmentSaveInstanceState(FragmentManager p0, Fragment p1, Bundle p2) {}

        public void onFragmentStarted(FragmentManager p0, Fragment p1) {}

        public void onFragmentStopped(FragmentManager p0, Fragment p1) {}

        public void onFragmentViewCreated(FragmentManager p0, Fragment p1, View p2, Bundle p3) {}

        public void onFragmentViewDestroyed(FragmentManager p0, Fragment p1) {}
    }

    public Fragment findFragmentById(int p0) {
        return null;
    }

    public Fragment findFragmentByTag(String p0) {
        return null;
    }

    public Fragment getFragment(Bundle p0, String p1) {
        return null;
    }

    public Fragment getPrimaryNavigationFragment() {
        return null;
    }

    public Fragment.SavedState saveFragmentInstanceState(Fragment p0) {
        return null;
    }

    public FragmentFactory getFragmentFactory() {
        return null;
    }

    public FragmentManager() {}

    public FragmentManager.BackStackEntry getBackStackEntryAt(int p0) {
        return null;
    }

    public FragmentTransaction beginTransaction() {
        return null;
    }

    public FragmentTransaction openTransaction() {
        return null;
    }

    public List<Fragment> getFragments() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean executePendingTransactions() {
        return false;
    }

    public boolean isDestroyed() {
        return false;
    }

    public boolean isStateSaved() {
        return false;
    }

    public boolean popBackStackImmediate() {
        return false;
    }

    public boolean popBackStackImmediate(String p0, int p1) {
        return false;
    }

    public boolean popBackStackImmediate(int p0, int p1) {
        return false;
    }

    public int getBackStackEntryCount() {
        return 0;
    }

    public static <F extends Fragment> F findFragment(View p0) {
        return null;
    }

    public static int POP_BACK_STACK_INCLUSIVE = 0;

    public static void enableDebugLogging(boolean p0) {}

    public void addOnBackStackChangedListener(FragmentManager.OnBackStackChangedListener p0) {}

    public void dump(String p0, FileDescriptor p1, PrintWriter p2, String[] p3) {}

    public void popBackStack() {}

    public void popBackStack(String p0, int p1) {}

    public void popBackStack(int p0, int p1) {}

    public void putFragment(Bundle p0, String p1, Fragment p2) {}

    public void registerFragmentLifecycleCallbacks(FragmentManager.FragmentLifecycleCallbacks p0,
            boolean p1) {}

    public void removeOnBackStackChangedListener(FragmentManager.OnBackStackChangedListener p0) {}

    public void setFragmentFactory(FragmentFactory p0) {}

    public void unregisterFragmentLifecycleCallbacks(
            FragmentManager.FragmentLifecycleCallbacks p0) {}

    static public interface BackStackEntry {
        CharSequence getBreadCrumbShortTitle();

        CharSequence getBreadCrumbTitle();

        String getName();

        int getBreadCrumbShortTitleRes();

        int getBreadCrumbTitleRes();

        int getId();
    }
    static public interface OnBackStackChangedListener {
        void onBackStackChanged();
    }

    static public interface OpGenerator {
        boolean generateOps(ArrayList<BackStackRecord> records, ArrayList<Boolean> isRecordPop);
    }
}
