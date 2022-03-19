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

import android.app.Fragment;
import android.os.Bundle;
import android.view.View;

public abstract class FragmentTransaction {
  public FragmentTransaction() {}

  public final FragmentTransaction add(Class<? extends Fragment> fragmentClass, Bundle args,
      String tag) {
    return null;
  }

  public FragmentTransaction add(Fragment fragment, String tag) {
    return null;
  }

  public final FragmentTransaction add(int containerViewId, Class<? extends Fragment> fragmentClass,
      Bundle args) {
    return null;
  }

  public FragmentTransaction add(int containerViewId, Fragment fragment) {
    return null;
  }

  public final FragmentTransaction add(int containerViewId, Class<? extends Fragment> fragmentClass,
      Bundle args, String tag) {
    return null;
  }

  public FragmentTransaction add(int containerViewId, Fragment fragment, String tag) {
    return null;
  }

  public final FragmentTransaction replace(int containerViewId,
      Class<? extends Fragment> fragmentClass, Bundle args) {
    return null;
  }

  public FragmentTransaction replace(int containerViewId, Fragment fragment) {
    return null;
  }

  public final FragmentTransaction replace(int containerViewId,
      Class<? extends Fragment> fragmentClass, Bundle args, String tag) {
    return null;
  }

  public FragmentTransaction replace(int containerViewId, Fragment fragment, String tag) {
    return null;
  }

  public FragmentTransaction remove(Fragment fragment) {
    return null;
  }

  public FragmentTransaction hide(Fragment fragment) {
    return null;
  }

  public FragmentTransaction show(Fragment fragment) {
    return null;
  }

  public FragmentTransaction detach(Fragment fragment) {
    return null;
  }

  public FragmentTransaction attach(Fragment fragment) {
    return null;
  }

  public FragmentTransaction setPrimaryNavigationFragment(Fragment fragment) {
    return null;
  }

  public boolean isEmpty() {
    return false;
  }

  public FragmentTransaction setCustomAnimations(int enter, int exit) {
    return null;
  }

  public FragmentTransaction setCustomAnimations(int enter, int exit, int popEnter, int popExit) {
    return null;
  }

  public FragmentTransaction addSharedElement(View sharedElement, String name) {
    return null;
  }

  public FragmentTransaction setTransition(int transition) {
    return null;
  }

  public FragmentTransaction setTransitionStyle(int styleRes) {
    return null;
  }

  public FragmentTransaction addToBackStack(String name) {
    return null;
  }

  public boolean isAddToBackStackAllowed() {
    return false;
  }

  public FragmentTransaction disallowAddToBackStack() {
    return null;
  }

  public FragmentTransaction setBreadCrumbTitle(int res) {
    return null;
  }

  public FragmentTransaction setBreadCrumbTitle(CharSequence text) {
    return null;
  }

  public FragmentTransaction setBreadCrumbShortTitle(int res) {
    return null;
  }

  public FragmentTransaction setBreadCrumbShortTitle(CharSequence text) {
    return null;
  }

  public FragmentTransaction setReorderingAllowed(boolean reorderingAllowed) {
    return null;
  }

  public FragmentTransaction setAllowOptimization(boolean allowOptimization) {
    return null;
  }

  public FragmentTransaction runOnCommit(Runnable runnable) {
    return null;
  }

  public abstract int commit();

  public abstract int commitAllowingStateLoss();

  public abstract void commitNow();

  public abstract void commitNowAllowingStateLoss();

}
