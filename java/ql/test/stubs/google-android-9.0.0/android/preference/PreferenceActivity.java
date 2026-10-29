/*
 * Copyright (C) 2007 The Android Open Source Project
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

package android.preference;

import java.util.List;
import android.app.Fragment;
import android.app.ListActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.view.View;
import android.view.View.OnClickListener;

public abstract class PreferenceActivity extends ListActivity {

  public static final class Header implements Parcelable {
    public Header() {}

    public CharSequence getTitle(Resources res) {
      return null;
    }

    public CharSequence getSummary(Resources res) {
      return null;
    }

    public CharSequence getBreadCrumbTitle(Resources res) {
      return null;
    }

    public CharSequence getBreadCrumbShortTitle(Resources res) {
      return null;
    }

    public int describeContents() {
      return 0;
    }

    public void writeToParcel(Parcel dest, int flags) {}

    public void readFromParcel(Parcel in) {}

    public static final Creator<Header> CREATOR = null;

  }

  public void onBackPressed() {}

  public boolean hasHeaders() {
    return false;
  }

  public List<Header> getHeaders() {
    return null;
  }

  public boolean isMultiPane() {
    return false;
  }

  public boolean onIsMultiPane() {
    return false;
  }

  public boolean onIsHidingHeaders() {
    return false;
  }

  public Header onGetInitialHeader() {
    return null;
  }

  public Header onGetNewHeader() {
    return null;
  }

  public void onBuildHeaders(List<Header> target) {}

  public void invalidateHeaders() {}

  public void loadHeadersFromResource(int resid, List<Header> target) {}

  public void setListFooter(View view) {}

  public void onContentChanged() {}

  public void onHeaderClick(Header header, int position) {}

  public Intent onBuildStartFragmentIntent(String fragmentName, Bundle args, int titleRes,
      int shortTitleRes) {
    return null;
  }

  public void startWithFragment(String fragmentName, Bundle args, Fragment resultTo,
      int resultRequestCode) {}

  public void startWithFragment(String fragmentName, Bundle args, Fragment resultTo,
      int resultRequestCode, int titleRes, int shortTitleRes) {}

  public void showBreadCrumbs(CharSequence title, CharSequence shortTitle) {}

  public void setParentTitle(CharSequence title, CharSequence shortTitle,
      OnClickListener listener) {}

  public void switchToHeader(String fragmentName, Bundle args) {}

  public void switchToHeader(Header header) {}

  public void startPreferenceFragment(Fragment fragment, boolean push) {}

  public void startPreferencePanel(String fragmentClass, Bundle args, int titleRes,
      CharSequence titleText, Fragment resultTo, int resultRequestCode) {}

  public void finishPreferencePanel(Fragment caller, int resultCode, Intent resultData) {}


  public void addPreferencesFromIntent(Intent intent) {}

  public void addPreferencesFromResource(int preferencesResId) {}

  protected boolean isValidFragment(String fragmentName) {
    return false;
  }

}
