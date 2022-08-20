/*
 * Copyright 2018 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package androidx.fragment.app;

import java.util.List;
import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.View;

public abstract class FragmentManager {
  public static void enableDebugLogging(boolean enabled) {}

  public static boolean isLoggingEnabled(int level) {
    return false;
  }

  public interface BackStackEntry {
    int getId();

    String getName();

    int getBreadCrumbTitleRes();

    int getBreadCrumbShortTitleRes();

    CharSequence getBreadCrumbTitle();

    CharSequence getBreadCrumbShortTitle();

  }
  public interface OnBackStackChangedListener {
    void onBackStackChanged();

  }
  public abstract static class FragmentLifecycleCallbacks {
    public void onFragmentPreAttached(FragmentManager fm, Fragment f, Context context) {}

    public void onFragmentAttached(FragmentManager fm, Fragment f, Context context) {}

    public void onFragmentPreCreated(FragmentManager fm, Fragment f, Bundle savedInstanceState) {}

    public void onFragmentCreated(FragmentManager fm, Fragment f, Bundle savedInstanceState) {}

    public void onFragmentActivityCreated(FragmentManager fm, Fragment f,
        Bundle savedInstanceState) {}

    public void onFragmentViewCreated(FragmentManager fm, Fragment f, View v,
        Bundle savedInstanceState) {}

    public void onFragmentStarted(FragmentManager fm, Fragment f) {}

    public void onFragmentResumed(FragmentManager fm, Fragment f) {}

    public void onFragmentPaused(FragmentManager fm, Fragment f) {}

    public void onFragmentStopped(FragmentManager fm, Fragment f) {}

    public void onFragmentSaveInstanceState(FragmentManager fm, Fragment f, Bundle outState) {}

    public void onFragmentViewDestroyed(FragmentManager fm, Fragment f) {}

    public void onFragmentDestroyed(FragmentManager fm, Fragment f) {}

    public void onFragmentDetached(FragmentManager fm, Fragment f) {}

  }

  public FragmentTransaction openTransaction() {
    return null;
  }

  public FragmentTransaction beginTransaction() {
    return null;
  }

  public boolean executePendingTransactions() {
    return false;
  }

  public void restoreBackStack(String name) {}

  public void saveBackStack(String name) {}

  public void popBackStack() {}

  public boolean popBackStackImmediate() {
    return false;
  }

  public void popBackStack(final String name, final int flags) {}

  public boolean popBackStackImmediate(String name, int flags) {
    return false;
  }

  public void popBackStack(final int id, final int flags) {}

  public boolean popBackStackImmediate(int id, int flags) {
    return false;
  }

  public int getBackStackEntryCount() {
    return 0;
  }

  public BackStackEntry getBackStackEntryAt(int index) {
    return null;
  }

  public void addOnBackStackChangedListener(OnBackStackChangedListener listener) {}

  public void removeOnBackStackChangedListener(OnBackStackChangedListener listener) {}

  public final void setFragmentResult(String requestKey, Bundle result) {}

  public final void clearFragmentResult(String requestKey) {}

  public final void clearFragmentResultListener(String requestKey) {}

  public void putFragment(Bundle bundle, String key, Fragment fragment) {}

  public Fragment getFragment(Bundle bundle, String key) {
    return null;
  }

  public static <F extends Fragment> F findFragment(View view) {
    return null;
  }

  public List<Fragment> getFragments() {
    return null;
  }

  public Fragment.SavedState saveFragmentInstanceState(Fragment fragment) {
    return null;
  }

  public boolean isDestroyed() {
    return false;
  }

  @Override
  public String toString() {
    return null;
  }

}
