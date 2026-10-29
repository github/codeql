// Generated automatically from androidx.fragment.app.BackStackRecord for testing purposes

package androidx.fragment.app;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.lifecycle.Lifecycle;
import java.io.PrintWriter;
import java.util.ArrayList;

class BackStackRecord extends FragmentTransaction implements FragmentManager.BackStackEntry, FragmentManager.OpGenerator
{
    protected BackStackRecord() {}
    public CharSequence getBreadCrumbShortTitle(){ return null; }
    public CharSequence getBreadCrumbTitle(){ return null; }
    public FragmentTransaction detach(Fragment p0){ return null; }
    public FragmentTransaction hide(Fragment p0){ return null; }
    public FragmentTransaction remove(Fragment p0){ return null; }
    public FragmentTransaction setMaxLifecycle(Fragment p0, Lifecycle.State p1){ return null; }
    public FragmentTransaction setPrimaryNavigationFragment(Fragment p0){ return null; }
    public FragmentTransaction show(Fragment p0){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public boolean generateOps(ArrayList<BackStackRecord> p0, ArrayList<Boolean> p1){ return false; }
    public boolean isEmpty(){ return false; }
    public int commit(){ return 0; }
    public int commitAllowingStateLoss(){ return 0; }
    public int getBreadCrumbShortTitleRes(){ return 0; }
    public int getBreadCrumbTitleRes(){ return 0; }
    public int getId(){ return 0; }
    public void commitNow(){}
    public void commitNowAllowingStateLoss(){}
    public void dump(String p0, PrintWriter p1){}
    public void dump(String p0, PrintWriter p1, boolean p2){}
    public void runOnCommitRunnables(){}
}
