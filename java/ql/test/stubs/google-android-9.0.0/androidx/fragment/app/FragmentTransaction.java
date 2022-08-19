// Generated automatically from androidx.fragment.app.FragmentTransaction for testing purposes

package androidx.fragment.app;

import android.os.Bundle;
import android.view.View;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Lifecycle;

abstract public class FragmentTransaction
{
    public FragmentTransaction add(Fragment p0, String p1){ return null; }
    public FragmentTransaction add(int p0, Fragment p1){ return null; }
    public FragmentTransaction add(int p0, Fragment p1, String p2){ return null; }
    public FragmentTransaction addSharedElement(View p0, String p1){ return null; }
    public FragmentTransaction addToBackStack(String p0){ return null; }
    public FragmentTransaction attach(Fragment p0){ return null; }
    public FragmentTransaction detach(Fragment p0){ return null; }
    public FragmentTransaction disallowAddToBackStack(){ return null; }
    public FragmentTransaction hide(Fragment p0){ return null; }
    public FragmentTransaction remove(Fragment p0){ return null; }
    public FragmentTransaction replace(int p0, Fragment p1){ return null; }
    public FragmentTransaction replace(int p0, Fragment p1, String p2){ return null; }
    public FragmentTransaction runOnCommit(Runnable p0){ return null; }
    public FragmentTransaction setAllowOptimization(boolean p0){ return null; }
    public FragmentTransaction setBreadCrumbShortTitle(CharSequence p0){ return null; }
    public FragmentTransaction setBreadCrumbShortTitle(int p0){ return null; }
    public FragmentTransaction setBreadCrumbTitle(CharSequence p0){ return null; }
    public FragmentTransaction setBreadCrumbTitle(int p0){ return null; }
    public FragmentTransaction setCustomAnimations(int p0, int p1){ return null; }
    public FragmentTransaction setCustomAnimations(int p0, int p1, int p2, int p3){ return null; }
    public FragmentTransaction setMaxLifecycle(Fragment p0, Lifecycle.State p1){ return null; }
    public FragmentTransaction setPrimaryNavigationFragment(Fragment p0){ return null; }
    public FragmentTransaction setReorderingAllowed(boolean p0){ return null; }
    public FragmentTransaction setTransition(int p0){ return null; }
    public FragmentTransaction setTransitionStyle(int p0){ return null; }
    public FragmentTransaction show(Fragment p0){ return null; }
    public FragmentTransaction(){}
    public abstract int commit();
    public abstract int commitAllowingStateLoss();
    public abstract void commitNow();
    public abstract void commitNowAllowingStateLoss();
    public boolean isAddToBackStackAllowed(){ return false; }
    public boolean isEmpty(){ return false; }
    public final FragmentTransaction add(Class<? extends Fragment> p0, Bundle p1, String p2){ return null; }
    public final FragmentTransaction add(int p0, Class<? extends Fragment> p1, Bundle p2){ return null; }
    public final FragmentTransaction add(int p0, Class<? extends Fragment> p1, Bundle p2, String p3){ return null; }
    public final FragmentTransaction replace(int p0, Class<? extends Fragment> p1, Bundle p2){ return null; }
    public final FragmentTransaction replace(int p0, Class<? extends Fragment> p1, Bundle p2, String p3){ return null; }
    public static int TRANSIT_ENTER_MASK = 0;
    public static int TRANSIT_EXIT_MASK = 0;
    public static int TRANSIT_FRAGMENT_CLOSE = 0;
    public static int TRANSIT_FRAGMENT_FADE = 0;
    public static int TRANSIT_FRAGMENT_OPEN = 0;
    public static int TRANSIT_NONE = 0;
    public static int TRANSIT_UNSET = 0;
}
