// Generated automatically from android.app.FragmentTransaction for testing purposes

package android.app;

import android.app.Fragment;
import android.view.View;

abstract public class FragmentTransaction
{
    public FragmentTransaction(){}
    public abstract FragmentTransaction add(Fragment p0, String p1);
    public abstract FragmentTransaction add(int p0, Fragment p1);
    public abstract FragmentTransaction add(int p0, Fragment p1, String p2);
    public abstract FragmentTransaction addSharedElement(View p0, String p1);
    public abstract FragmentTransaction addToBackStack(String p0);
    public abstract FragmentTransaction attach(Fragment p0);
    public abstract FragmentTransaction detach(Fragment p0);
    public abstract FragmentTransaction disallowAddToBackStack();
    public abstract FragmentTransaction hide(Fragment p0);
    public abstract FragmentTransaction remove(Fragment p0);
    public abstract FragmentTransaction replace(int p0, Fragment p1);
    public abstract FragmentTransaction replace(int p0, Fragment p1, String p2);
    public abstract FragmentTransaction runOnCommit(Runnable p0);
    public abstract FragmentTransaction setBreadCrumbShortTitle(CharSequence p0);
    public abstract FragmentTransaction setBreadCrumbShortTitle(int p0);
    public abstract FragmentTransaction setBreadCrumbTitle(CharSequence p0);
    public abstract FragmentTransaction setBreadCrumbTitle(int p0);
    public abstract FragmentTransaction setCustomAnimations(int p0, int p1);
    public abstract FragmentTransaction setCustomAnimations(int p0, int p1, int p2, int p3);
    public abstract FragmentTransaction setPrimaryNavigationFragment(Fragment p0);
    public abstract FragmentTransaction setReorderingAllowed(boolean p0);
    public abstract FragmentTransaction setTransition(int p0);
    public abstract FragmentTransaction setTransitionStyle(int p0);
    public abstract FragmentTransaction show(Fragment p0);
    public abstract boolean isAddToBackStackAllowed();
    public abstract boolean isEmpty();
    public abstract int commit();
    public abstract int commitAllowingStateLoss();
    public abstract void commitNow();
    public abstract void commitNowAllowingStateLoss();
    public static int TRANSIT_ENTER_MASK = 0;
    public static int TRANSIT_EXIT_MASK = 0;
    public static int TRANSIT_FRAGMENT_CLOSE = 0;
    public static int TRANSIT_FRAGMENT_FADE = 0;
    public static int TRANSIT_FRAGMENT_OPEN = 0;
    public static int TRANSIT_NONE = 0;
    public static int TRANSIT_UNSET = 0;
}
