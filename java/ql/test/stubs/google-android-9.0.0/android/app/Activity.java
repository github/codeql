/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package android.app;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

/**
 * An activity is a single, focused thing that the user can do. Almost all
 * activities interact with the user, so the Activity class takes care of
 * creating a window for you in which you can place your UI with
 * {@link #setContentView}. While activities are often presented to the user as
 * full-screen windows, they can also be used in other ways: as floating windows
 * (via a theme with {@link android.R.attr#windowIsFloating} set) or embedded
 * inside of another activity (using {@link ActivityGroup}).
 *
 * There are two methods almost all subclasses of Activity will implement:
 *
 * <ul>
 * <li>{@link #onCreate} is where you initialize your activity. Most
 * importantly, here you will usually call {@link #setContentView(int)} with a
 * layout resource defining your UI, and using {@link #findViewById} to retrieve
 * the widgets in that UI that you need to interact with programmatically.
 *
 * <li>{@link #onPause} is where you deal with the user leaving your activity.
 * Most importantly, any changes made by the user should at this point be
 * committed (usually to the {@link android.content.ContentProvider} holding the
 * data).
 * </ul>
 *
 * <p>
 * To be of use with {@link android.content.Context#startActivity
 * Context.startActivity()}, all activity classes must have a corresponding
 * {@link android.R.styleable#AndroidManifestActivity &lt;activity&gt;}
 * declaration in their package's <code>AndroidManifest.xml</code>.
 * </p>
 *
 * <p>
 * Topics covered here:
 * <ol>
 * <li><a href="#Fragments">Fragments</a>
 * <li><a href="#ActivityLifecycle">Activity Lifecycle</a>
 * <li><a href="#ConfigurationChanges">Configuration Changes</a>
 * <li><a href="#StartingActivities">Starting Activities and Getting Results</a>
 * <li><a href="#SavingPersistentState">Saving Persistent State</a>
 * <li><a href="#Permissions">Permissions</a>
 * <li><a href="#ProcessLifecycle">Process Lifecycle</a>
 * </ol>
 *
 * <div class="special reference">
 * <h3>Developer Guides</h3>
 * <p>
 * The Activity class is an important part of an application's overall
 * lifecycle, and the way activities are launched and put together is a
 * fundamental part of the platform's application model. For a detailed
 * perspective on the structure of an Android application and how activities
 * behave, please read the
 * <a href="{@docRoot}guide/topics/fundamentals.html">Application
 * Fundamentals</a> and
 * <a href="{@docRoot}guide/components/tasks-and-back-stack.html">Tasks and Back
 * Stack</a> developer guides.
 * </p>
 *
 * <p>
 * You can also find a detailed discussion about how to create activities in the
 * <a href="{@docRoot}guide/components/activities.html">Activities</a> developer
 * guide.
 * </p>
 * </div>
 *
 * <a name="Fragments"></a>
 * <h3>Fragments</h3>
 *
 * <p>
 * The {@link android.support.v4.app.FragmentActivity} subclass can make use of
 * the {@link android.support.v4.app.Fragment} class to better modularize their
 * code, build more sophisticated user interfaces for larger screens, and help
 * scale their application between small and large screens.
 * </p>
 *
 * <p>
 * For more information about using fragments, read the
 * <a href="{@docRoot}guide/components/fragments.html">Fragments</a> developer
 * guide.
 * </p>
 *
 * <a name="ActivityLifecycle"></a>
 * <h3>Activity Lifecycle</h3>
 *
 * <p>
 * Activities in the system are managed as an <em>activity stack</em>. When a
 * new activity is started, it is placed on the top of the stack and becomes the
 * running activity -- the previous activity always remains below it in the
 * stack, and will not come to the foreground again until the new activity
 * exits.
 * </p>
 *
 * <p>
 * An activity has essentially four states:
 * </p>
 * <ul>
 * <li>If an activity is in the foreground of the screen (at the top of the
 * stack), it is <em>active</em> or <em>running</em>.</li>
 * <li>If an activity has lost focus but is still visible (that is, a new
 * non-full-sized or transparent activity has focus on top of your activity), it
 * is <em>paused</em>. A paused activity is completely alive (it maintains all
 * state and member information and remains attached to the window manager), but
 * can be killed by the system in extreme low memory situations.
 * <li>If an activity is completely obscured by another activity, it is
 * <em>stopped</em>. It still retains all state and member information, however,
 * it is no longer visible to the user so its window is hidden and it will often
 * be killed by the system when memory is needed elsewhere.</li>
 * <li>If an activity is paused or stopped, the system can drop the activity
 * from memory by either asking it to finish, or simply killing its process.
 * When it is displayed again to the user, it must be completely restarted and
 * restored to its previous state.</li>
 * </ul>
 *
 * <p>
 * The following diagram shows the important state paths of an Activity. The
 * square rectangles represent callback methods you can implement to perform
 * operations when the Activity moves between states. The colored ovals are
 * major states the Activity can be in.
 * </p>
 *
 * <p>
 * <img src="../../../images/activity_lifecycle.png" alt="State diagram for an
 * Android Activity Lifecycle." border="0" />
 * </p>
 *
 * <p>
 * There are three key loops you may be interested in monitoring within your
 * activity:
 *
 * <ul>
 * <li>The <b>entire lifetime</b> of an activity happens between the first call
 * to {@link android.app.Activity#onCreate} through to a single final call to
 * {@link android.app.Activity#onDestroy}. An activity will do all setup of
 * "global" state in onCreate(), and release all remaining resources in
 * onDestroy(). For example, if it has a thread running in the background to
 * download data from the network, it may create that thread in onCreate() and
 * then stop the thread in onDestroy().
 *
 * <li>The <b>visible lifetime</b> of an activity happens between a call to
 * {@link android.app.Activity#onStart} until a corresponding call to
 * {@link android.app.Activity#onStop}. During this time the user can see the
 * activity on-screen, though it may not be in the foreground and interacting
 * with the user. Between these two methods you can maintain resources that are
 * needed to show the activity to the user. For example, you can register a
 * {@link android.content.BroadcastReceiver} in onStart() to monitor for changes
 * that impact your UI, and unregister it in onStop() when the user no longer
 * sees what you are displaying. The onStart() and onStop() methods can be
 * called multiple times, as the activity becomes visible and hidden to the
 * user.
 *
 * <li>The <b>foreground lifetime</b> of an activity happens between a call to
 * {@link android.app.Activity#onResume} until a corresponding call to
 * {@link android.app.Activity#onPause}. During this time the activity is in
 * front of all other activities and interacting with the user. An activity can
 * frequently go between the resumed and paused states -- for example when the
 * device goes to sleep, when an activity result is delivered, when a new intent
 * is delivered -- so the code in these methods should be fairly lightweight.
 * </ul>
 *
 * <p>
 * The entire lifecycle of an activity is defined by the following Activity
 * methods. All of these are hooks that you can override to do appropriate work
 * when the activity changes state. All activities will implement
 * {@link android.app.Activity#onCreate} to do their initial setup; many will
 * also implement {@link android.app.Activity#onPause} to commit changes to data
 * and otherwise prepare to stop interacting with the user. You should always
 * call up to your superclass when implementing these methods.
 * </p>
 *
 * </p>
 * 
 * <pre class="prettyprint">
 * public class Activity extends ApplicationContext {
 *     protected void onCreate(Bundle savedInstanceState);
 *
 *     protected void onStart();
 *
 *     protected void onRestart();
 *
 *     protected void onResume();
 *
 *     protected void onPause();
 *
 *     protected void onStop();
 *
 *     protected void onDestroy();
 * }
 * </pre>
 *
 * <p>
 * In general the movement through an activity's lifecycle looks like this:
 * </p>
 *
 * <table border="2" width="85%" align="center" frame="hsides" rules="rows">
 * <colgroup align="left" span="3" /> <colgroup align="left" />
 * <colgroup align="center" /> <colgroup align="center" />
 *
 * <thead>
 * <tr>
 * <th colspan="3">Method</th>
 * <th>Description</th>
 * <th>Killable?</th>
 * <th>Next</th>
 * </tr>
 * </thead>
 *
 * <tbody>
 * <tr>
 * <td colspan="3" align="left" border="0">{@link android.app.Activity#onCreate
 * onCreate()}</td>
 * <td>Called when the activity is first created. This is where you should do
 * all of your normal static set up: create views, bind data to lists, etc. This
 * method also provides you with a Bundle containing the activity's previously
 * frozen state, if there was one.
 * <p>
 * Always followed by <code>onStart()</code>.</td>
 * <td align="center">No</td>
 * <td align="center"><code>onStart()</code></td>
 * </tr>
 *
 * <tr>
 * <td rowspan="5" style="border-left: none; border-right:
 * none;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
 * <td colspan="2" align="left" border="0">{@link android.app.Activity#onRestart
 * onRestart()}</td>
 * <td>Called after your activity has been stopped, prior to it being started
 * again.
 * <p>
 * Always followed by <code>onStart()</code></td>
 * <td align="center">No</td>
 * <td align="center"><code>onStart()</code></td>
 * </tr>
 *
 * <tr>
 * <td colspan="2" align="left" border="0">{@link android.app.Activity#onStart
 * onStart()}</td>
 * <td>Called when the activity is becoming visible to the user.
 * <p>
 * Followed by <code>onResume()</code> if the activity comes to the foreground,
 * or <code>onStop()</code> if it becomes hidden.</td>
 * <td align="center">No</td>
 * <td align="center"><code>onResume()</code> or <code>onStop()</code></td>
 * </tr>
 *
 * <tr>
 * <td rowspan="2" style="border-left: none;">&nbsp;&nbsp;&nbsp;&nbsp;</td>
 * <td align="left" border="0">{@link android.app.Activity#onResume
 * onResume()}</td>
 * <td>Called when the activity will start interacting with the user. At this
 * point your activity is at the top of the activity stack, with user input
 * going to it.
 * <p>
 * Always followed by <code>onPause()</code>.</td>
 * <td align="center">No</td>
 * <td align="center"><code>onPause()</code></td>
 * </tr>
 *
 * <tr>
 * <td align="left" border="0">{@link android.app.Activity#onPause
 * onPause()}</td>
 * <td>Called when the system is about to start resuming a previous activity.
 * This is typically used to commit unsaved changes to persistent data, stop
 * animations and other things that may be consuming CPU, etc. Implementations
 * of this method must be very quick because the next activity will not be
 * resumed until this method returns.
 * <p>
 * Followed by either <code>onResume()</code> if the activity returns back to
 * the front, or <code>onStop()</code> if it becomes invisible to the user.</td>
 * <td align="center"><font color=
 * "#800000"><strong>Pre-{@link android.os.Build.VERSION_CODES#HONEYCOMB}</strong></font></td>
 * <td align="center"><code>onResume()</code> or<br>
 * <code>onStop()</code></td>
 * </tr>
 *
 * <tr>
 * <td colspan="2" align="left" border="0">{@link android.app.Activity#onStop
 * onStop()}</td>
 * <td>Called when the activity is no longer visible to the user, because
 * another activity has been resumed and is covering this one. This may happen
 * either because a new activity is being started, an existing one is being
 * brought in front of this one, or this one is being destroyed.
 * <p>
 * Followed by either <code>onRestart()</code> if this activity is coming back
 * to interact with the user, or <code>onDestroy()</code> if this activity is
 * going away.</td>
 * <td align="center"><font color="#800000"><strong>Yes</strong></font></td>
 * <td align="center"><code>onRestart()</code> or<br>
 * <code>onDestroy()</code></td>
 * </tr>
 *
 * <tr>
 * <td colspan="3" align="left" border="0">{@link android.app.Activity#onDestroy
 * onDestroy()}</td>
 * <td>The final call you receive before your activity is destroyed. This can
 * happen either because the activity is finishing (someone called
 * {@link Activity#finish} on it, or because the system is temporarily
 * destroying this instance of the activity to save space. You can distinguish
 * between these two scenarios with the {@link Activity#isFinishing}
 * method.</td>
 * <td align="center"><font color="#800000"><strong>Yes</strong></font></td>
 * <td align="center"><em>nothing</em></td>
 * </tr>
 * </tbody>
 * </table>
 *
 * <p>
 * Note the "Killable" column in the above table -- for those methods that are
 * marked as being killable, after that method returns the process hosting the
 * activity may be killed by the system <em>at any time</em> without another
 * line of its code being executed. Because of this, you should use the
 * {@link #onPause} method to write any persistent data (such as user edits) to
 * storage. In addition, the method {@link #onSaveInstanceState(Bundle)} is
 * called before placing the activity in such a background state, allowing you
 * to save away any dynamic instance state in your activity into the given
 * Bundle, to be later received in {@link #onCreate} if the activity needs to be
 * re-created. See the <a href="#ProcessLifecycle">Process Lifecycle</a> section
 * for more information on how the lifecycle of a process is tied to the
 * activities it is hosting. Note that it is important to save persistent data
 * in {@link #onPause} instead of {@link #onSaveInstanceState} because the
 * latter is not part of the lifecycle callbacks, so will not be called in every
 * situation as described in its documentation.
 * </p>
 *
 * <p class="note">
 * Be aware that these semantics will change slightly between applications
 * targeting platforms starting with
 * {@link android.os.Build.VERSION_CODES#HONEYCOMB} vs. those targeting prior
 * platforms. Starting with Honeycomb, an application is not in the killable
 * state until its {@link #onStop} has returned. This impacts when
 * {@link #onSaveInstanceState(Bundle)} may be called (it may be safely called
 * after {@link #onPause()}) and allows an application to safely wait until
 * {@link #onStop()} to save persistent state.
 * </p>
 *
 * <p class="note">
 * For applications targeting platforms starting with
 * {@link android.os.Build.VERSION_CODES#P} {@link #onSaveInstanceState(Bundle)}
 * will always be called after {@link #onStop}, so an application may safely
 * perform fragment transactions in {@link #onStop} and will be able to save
 * persistent state later.
 * </p>
 *
 * <p>
 * For those methods that are not marked as being killable, the activity's
 * process will not be killed by the system starting from the time the method is
 * called and continuing after it returns. Thus an activity is in the killable
 * state, for example, between after <code>onPause()</code> to the start of
 * <code>onResume()</code>.
 * </p>
 *
 * <a name="ConfigurationChanges"></a>
 * <h3>Configuration Changes</h3>
 *
 * <p>
 * If the configuration of the device (as defined by the {@link Configuration
 * Resources.Configuration} class) changes, then anything displaying a user
 * interface will need to update to match that configuration. Because Activity
 * is the primary mechanism for interacting with the user, it includes special
 * support for handling configuration changes.
 * </p>
 *
 * <p>
 * Unless you specify otherwise, a configuration change (such as a change in
 * screen orientation, language, input devices, etc) will cause your current
 * activity to be <em>destroyed</em>, going through the normal activity
 * lifecycle process of {@link #onPause}, {@link #onStop}, and
 * {@link #onDestroy} as appropriate. If the activity had been in the foreground
 * or visible to the user, once {@link #onDestroy} is called in that instance
 * then a new instance of the activity will be created, with whatever
 * savedInstanceState the previous instance had generated from
 * {@link #onSaveInstanceState}.
 * </p>
 *
 * <p>
 * This is done because any application resource, including layout files, can
 * change based on any configuration value. Thus the only safe way to handle a
 * configuration change is to re-retrieve all resources, including layouts,
 * drawables, and strings. Because activities must already know how to save
 * their state and re-create themselves from that state, this is a convenient
 * way to have an activity restart itself with a new configuration.
 * </p>
 *
 * <p>
 * In some special cases, you may want to bypass restarting of your activity
 * based on one or more types of configuration changes. This is done with the
 * {@link android.R.attr#configChanges android:configChanges} attribute in its
 * manifest. For any types of configuration changes you say that you handle
 * there, you will receive a call to your current activity's
 * {@link #onConfigurationChanged} method instead of being restarted. If a
 * configuration change involves any that you do not handle, however, the
 * activity will still be restarted and {@link #onConfigurationChanged} will not
 * be called.
 * </p>
 *
 * <a name="StartingActivities"></a>
 * <h3>Starting Activities and Getting Results</h3>
 *
 * <p>
 * The {@link android.app.Activity#startActivity} method is used to start a new
 * activity, which will be placed at the top of the activity stack. It takes a
 * single argument, an {@link android.content.Intent Intent}, which describes
 * the activity to be executed.
 * </p>
 *
 * <p>
 * Sometimes you want to get a result back from an activity when it ends. For
 * example, you may start an activity that lets the user pick a person in a list
 * of contacts; when it ends, it returns the person that was selected. To do
 * this, you call the
 * {@link android.app.Activity#startActivityForResult(Intent, int)} version with
 * a second integer parameter identifying the call. The result will come back
 * through your {@link android.app.Activity#onActivityResult} method.
 * </p>
 *
 * <p>
 * When an activity exits, it can call
 * {@link android.app.Activity#setResult(int)} to return data back to its
 * parent. It must always supply a result code, which can be the standard
 * results RESULT_CANCELED, RESULT_OK, or any custom values starting at
 * RESULT_FIRST_USER. In addition, it can optionally return back an Intent
 * containing any additional data it wants. All of this information appears back
 * on the parent's <code>Activity.onActivityResult()</code>, along with the
 * integer identifier it originally supplied.
 * </p>
 *
 * <p>
 * If a child activity fails for any reason (such as crashing), the parent
 * activity will receive a result with the code RESULT_CANCELED.
 * </p>
 *
 * <pre class="prettyprint">
 * public class MyActivity extends Activity {
 *     ...
 *
 *     static final int PICK_CONTACT_REQUEST = 0;
 *
 *     public boolean onKeyDown(int keyCode, KeyEvent event) {
 *         if (keyCode == KeyEvent.KEYCODE_DPAD_CENTER) {
 *             // When the user center presses, let them pick a contact.
 *             startActivityForResult(
 *                 new Intent(Intent.ACTION_PICK,
 *                 new Uri("content://contacts")),
 *                 PICK_CONTACT_REQUEST);
 *            return true;
 *         }
 *         return false;
 *     }
 *
 *     protected void onActivityResult(int requestCode, int resultCode,
 *             Intent data) {
 *         if (requestCode == PICK_CONTACT_REQUEST) {
 *             if (resultCode == RESULT_OK) {
 *                 // A contact was picked.  Here we will just display it
 *                 // to the user.
 *                 startActivity(new Intent(Intent.ACTION_VIEW, data));
 *             }
 *         }
 *     }
 * }
 * </pre>
 *
 * <a name="SavingPersistentState"></a>
 * <h3>Saving Persistent State</h3>
 *
 * <p>
 * There are generally two kinds of persistent state than an activity will deal
 * with: shared document-like data (typically stored in a SQLite database using
 * a {@linkplain android.content.ContentProvider content provider}) and internal
 * state such as user preferences.
 * </p>
 *
 * <p>
 * For content provider data, we suggest that activities use a "edit in place"
 * user model. That is, any edits a user makes are effectively made immediately
 * without requiring an additional confirmation step. Supporting this model is
 * generally a simple matter of following two rules:
 * </p>
 *
 * <ul>
 * <li>
 * <p>
 * When creating a new document, the backing database entry or file for it is
 * created immediately. For example, if the user chooses to write a new email, a
 * new entry for that email is created as soon as they start entering data, so
 * that if they go to any other activity after that point this email will now
 * appear in the list of drafts.
 * </p>
 * <li>
 * <p>
 * When an activity's <code>onPause()</code> method is called, it should commit
 * to the backing content provider or file any changes the user has made. This
 * ensures that those changes will be seen by any other activity that is about
 * to run. You will probably want to commit your data even more aggressively at
 * key times during your activity's lifecycle: for example before starting a new
 * activity, before finishing your own activity, when the user switches between
 * input fields, etc.
 * </p>
 * </ul>
 *
 * <p>
 * This model is designed to prevent data loss when a user is navigating between
 * activities, and allows the system to safely kill an activity (because system
 * resources are needed somewhere else) at any time after it has been paused.
 * Note this implies that the user pressing BACK from your activity does
 * <em>not</em> mean "cancel" -- it means to leave the activity with its current
 * contents saved away. Canceling edits in an activity must be provided through
 * some other mechanism, such as an explicit "revert" or "undo" option.
 * </p>
 *
 * <p>
 * See the {@linkplain android.content.ContentProvider content package} for more
 * information about content providers. These are a key aspect of how different
 * activities invoke and propagate data between themselves.
 * </p>
 *
 * <p>
 * The Activity class also provides an API for managing internal persistent
 * state associated with an activity. This can be used, for example, to remember
 * the user's preferred initial display in a calendar (day view or week view) or
 * the user's default home page in a web browser.
 * </p>
 *
 * <p>
 * Activity persistent state is managed with the method {@link #getPreferences},
 * allowing you to retrieve and modify a set of name/value pairs associated with
 * the activity. To use preferences that are shared across multiple application
 * components (activities, receivers, services, providers), you can use the
 * underlying {@link Context#getSharedPreferences
 * Context.getSharedPreferences()} method to retrieve a preferences object
 * stored under a specific name. (Note that it is not possible to share settings
 * data across application packages -- for that you will need a content
 * provider.)
 * </p>
 *
 * <p>
 * Here is an excerpt from a calendar activity that stores the user's preferred
 * view mode in its persistent settings:
 * </p>
 *
 * <pre class="prettyprint">
 * public class CalendarActivity extends Activity {
 *     ...
 *
 *     static final int DAY_VIEW_MODE = 0;
 *     static final int WEEK_VIEW_MODE = 1;
 *
 *     private SharedPreferences mPrefs;
 *     private int mCurViewMode;
 *
 *     protected void onCreate(Bundle savedInstanceState) {
 *         super.onCreate(savedInstanceState);
 *
 *         SharedPreferences mPrefs = getSharedPreferences();
 *         mCurViewMode = mPrefs.getInt("view_mode", DAY_VIEW_MODE);
 *     }
 *
 *     protected void onPause() {
 *         super.onPause();
 *
 *         SharedPreferences.Editor ed = mPrefs.edit();
 *         ed.putInt("view_mode", mCurViewMode);
 *         ed.commit();
 *     }
 * }
 * </pre>
 *
 * <a name="Permissions"></a>
 * <h3>Permissions</h3>
 *
 * <p>
 * The ability to start a particular Activity can be enforced when it is
 * declared in its manifest's {@link android.R.styleable#AndroidManifestActivity
 * &lt;activity&gt;} tag. By doing so, other applications will need to declare a
 * corresponding {@link android.R.styleable#AndroidManifestUsesPermission
 * &lt;uses-permission&gt;} element in their own manifest to be able to start
 * that activity.
 *
 * <p>
 * When starting an Activity you can set
 * {@link Intent#FLAG_GRANT_READ_URI_PERMISSION
 * Intent.FLAG_GRANT_READ_URI_PERMISSION} and/or
 * {@link Intent#FLAG_GRANT_WRITE_URI_PERMISSION
 * Intent.FLAG_GRANT_WRITE_URI_PERMISSION} on the Intent. This will grant the
 * Activity access to the specific URIs in the Intent. Access will remain until
 * the Activity has finished (it will remain across the hosting process being
 * killed and other temporary destruction). As of
 * {@link android.os.Build.VERSION_CODES#GINGERBREAD}, if the Activity was
 * already created and a new Intent is being delivered to
 * {@link #onNewIntent(Intent)}, any newly granted URI permissions will be added
 * to the existing ones it holds.
 *
 * <p>
 * See the <a href="{@docRoot}guide/topics/security/security.html">Security and
 * Permissions</a> document for more information on permissions and security in
 * general.
 *
 * <a name="ProcessLifecycle"></a>
 * <h3>Process Lifecycle</h3>
 *
 * <p>
 * The Android system attempts to keep an application process around for as long
 * as possible, but eventually will need to remove old processes when memory
 * runs low. As described in <a href="#ActivityLifecycle">Activity
 * Lifecycle</a>, the decision about which process to remove is intimately tied
 * to the state of the user's interaction with it. In general, there are four
 * states a process can be in based on the activities running in it, listed here
 * in order of importance. The system will kill less important processes (the
 * last ones) before it resorts to killing more important processes (the first
 * ones).
 *
 * <ol>
 * <li>
 * <p>
 * The <b>foreground activity</b> (the activity at the top of the screen that
 * the user is currently interacting with) is considered the most important. Its
 * process will only be killed as a last resort, if it uses more memory than is
 * available on the device. Generally at this point the device has reached a
 * memory paging state, so this is required in order to keep the user interface
 * responsive.
 * <li>
 * <p>
 * A <b>visible activity</b> (an activity that is visible to the user but not in
 * the foreground, such as one sitting behind a foreground dialog) is considered
 * extremely important and will not be killed unless that is required to keep
 * the foreground activity running.
 * <li>
 * <p>
 * A <b>background activity</b> (an activity that is not visible to the user and
 * has been paused) is no longer critical, so the system may safely kill its
 * process to reclaim memory for other foreground or visible processes. If its
 * process needs to be killed, when the user navigates back to the activity
 * (making it visible on the screen again), its {@link #onCreate} method will be
 * called with the savedInstanceState it had previously supplied in
 * {@link #onSaveInstanceState} so that it can restart itself in the same state
 * as the user last left it.
 * <li>
 * <p>
 * An <b>empty process</b> is one hosting no activities or other application
 * components (such as {@link Service} or
 * {@link android.content.BroadcastReceiver} classes). These are killed very
 * quickly by the system as memory becomes low. For this reason, any background
 * operation you do outside of an activity must be executed in the context of an
 * activity BroadcastReceiver or Service to ensure that the system knows it
 * needs to keep your process around.
 * </ol>
 *
 * <p>
 * Sometimes an Activity may need to do a long-running operation that exists
 * independently of the activity lifecycle itself. An example may be a camera
 * application that allows you to upload a picture to a web site. The upload may
 * take a long time, and the application should allow the user to leave the
 * application while it is executing. To accomplish this, your Activity should
 * start a {@link Service} in which the upload takes place. This allows the
 * system to properly prioritize your process (considering it to be more
 * important than other non-visible applications) for the duration of the
 * upload, independent of whether the original activity is paused, stopped, or
 * finished.
 */
public class Activity {
    /** Return the intent that started this activity. */
    public Intent getIntent() {
        return null;
    }

    /**
     * Change the intent returned by {@link #getIntent}. This holds a reference to
     * the given intent; it does not copy it. Often used in conjunction with
     * {@link #onNewIntent}.
     *
     * @param newIntent The new Intent object to return from getIntent
     *
     * @see #getIntent
     * @see #onNewIntent
     */
    public void setIntent(Intent newIntent) {
    }

    /**
     * Called when the activity is starting. This is where most initialization
     * should go: calling {@link #setContentView(int)} to inflate the activity's UI,
     * using {@link #findViewById} to programmatically interact with widgets in the
     * UI, calling
     * {@link #managedQuery(android.net.Uri , String[], String, String[], String)}
     * to retrieve cursors for data being displayed, etc.
     *
     * <p>
     * You can call {@link #finish} from within this function, in which case
     * onDestroy() will be immediately called after {@link #onCreate} without any of
     * the rest of the activity lifecycle ({@link #onStart}, {@link #onResume},
     * {@link #onPause}, etc) executing.
     *
     * <p>
     * <em>Derived classes must call through to the super class's implementation of
     * this method. If they do not, an exception will be thrown.</em>
     * </p>
     *
     * @param savedInstanceState If the activity is being re-initialized after
     *                           previously being shut down then this Bundle
     *                           contains the data it most recently supplied in
     *                           {@link #onSaveInstanceState}. <b><i>Note: Otherwise
     *                           it is null.</i></b>
     *
     * @see #onStart
     * @see #onSaveInstanceState
     * @see #onRestoreInstanceState
     * @see #onPostCreate
     */
    protected void onCreate(Bundle savedInstanceState) {
    }

    /**
     * This method is called after {@link #onStart} when the activity is being
     * re-initialized from a previously saved state, given here in
     * <var>savedInstanceState</var>. Most implementations will simply use
     * {@link #onCreate} to restore their state, but it is sometimes convenient to
     * do it here after all of the initialization has been done or to allow
     * subclasses to decide whether to use your default implementation. The default
     * implementation of this method performs a restore of any view state that had
     * previously been frozen by {@link #onSaveInstanceState}.
     *
     * <p>
     * This method is called between {@link #onStart} and {@link #onPostCreate}.
     *
     * @param savedInstanceState the data most recently supplied in
     *                           {@link #onSaveInstanceState}.
     *
     * @see #onCreate
     * @see #onPostCreate
     * @see #onResume
     * @see #onSaveInstanceState
     */
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
    }

    /**
     * Called when activity start-up is complete (after {@link #onStart} and
     * {@link #onRestoreInstanceState} have been called). Applications will
     * generally not implement this method; it is intended for system classes to do
     * final initialization after application code has run.
     *
     * <p>
     * <em>Derived classes must call through to the super class's implementation of
     * this method. If they do not, an exception will be thrown.</em>
     * </p>
     *
     * @param savedInstanceState If the activity is being re-initialized after
     *                           previously being shut down then this Bundle
     *                           contains the data it most recently supplied in
     *                           {@link #onSaveInstanceState}. <b><i>Note: Otherwise
     *                           it is null.</i></b>
     * @see #onCreate
     */
    protected void onPostCreate(Bundle savedInstanceState) {
    }

    /**
     * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when the
     * activity had been stopped, but is now again being displayed to the user. It
     * will be followed by {@link #onResume}.
     *
     * <p>
     * <em>Derived classes must call through to the super class's implementation of
     * this method. If they do not, an exception will be thrown.</em>
     * </p>
     *
     * @see #onCreate
     * @see #onStop
     * @see #onResume
     */
    protected void onStart() {
    }

    /**
     * Called after {@link #onRestoreInstanceState}, {@link #onRestart}, or
     * {@link #onPause}, for your activity to start interacting with the user. This
     * is a good place to begin animations, open exclusive-access devices (such as
     * the camera), etc.
     *
     * <p>
     * Keep in mind that onResume is not the best indicator that your activity is
     * visible to the user; a system window such as the keyguard may be in front.
     * Use {@link #onWindowFocusChanged} to know for certain that your activity is
     * visible to the user (for example, to resume a game).
     *
     * <p>
     * <em>Derived classes must call through to the super class's implementation of
     * this method. If they do not, an exception will be thrown.</em>
     * </p>
     *
     * @see #onRestoreInstanceState
     * @see #onRestart
     * @see #onPostResume
     * @see #onPause
     */
    protected void onResume() {
    }

    /**
     * Called when activity resume is complete (after {@link #onResume} has been
     * called). Applications will generally not implement this method; it is
     * intended for system classes to do final setup after application resume code
     * has run.
     *
     * <p>
     * <em>Derived classes must call through to the super class's implementation of
     * this method. If they do not, an exception will be thrown.</em>
     * </p>
     *
     * @see #onResume
     */
    protected void onPostResume() {
    }

    /**
     * This is called for activities that set launchMode to "singleTop" in their
     * package, or if a client used the {@link Intent#FLAG_ACTIVITY_SINGLE_TOP} flag
     * when calling {@link #startActivity}. In either case, when the activity is
     * re-launched while at the top of the activity stack instead of a new instance
     * of the activity being started, onNewIntent() will be called on the existing
     * instance with the Intent that was used to re-launch it.
     *
     * <p>
     * An activity will always be paused before receiving a new intent, so you can
     * count on {@link #onResume} being called after this method.
     *
     * <p>
     * Note that {@link #getIntent} still returns the original Intent. You can use
     * {@link #setIntent} to update it to this new Intent.
     *
     * @param intent The new intent that was started for the activity.
     *
     * @see #getIntent
     * @see #setIntent
     * @see #onResume
     */
    protected void onNewIntent(Intent intent) {
    }

    /**
     * Called to retrieve per-instance state from an activity before being killed so
     * that the state can be restored in {@link #onCreate} or
     * {@link #onRestoreInstanceState} (the {@link Bundle} populated by this method
     * will be passed to both).
     *
     * <p>
     * This method is called before an activity may be killed so that when it comes
     * back some time in the future it can restore its state. For example, if
     * activity B is launched in front of activity A, and at some point activity A
     * is killed to reclaim resources, activity A will have a chance to save the
     * current state of its user interface via this method so that when the user
     * returns to activity A, the state of the user interface can be restored via
     * {@link #onCreate} or {@link #onRestoreInstanceState}.
     *
     * <p>
     * Do not confuse this method with activity lifecycle callbacks such as
     * {@link #onPause}, which is always called when an activity is being placed in
     * the background or on its way to destruction, or {@link #onStop} which is
     * called before destruction. One example of when {@link #onPause} and
     * {@link #onStop} is called and not this method is when a user navigates back
     * from activity B to activity A: there is no need to call
     * {@link #onSaveInstanceState} on B because that particular instance will never
     * be restored, so the system avoids calling it. An example when
     * {@link #onPause} is called and not {@link #onSaveInstanceState} is when
     * activity B is launched in front of activity A: the system may avoid calling
     * {@link #onSaveInstanceState} on activity A if it isn't killed during the
     * lifetime of B since the state of the user interface of A will stay intact.
     *
     * <p>
     * The default implementation takes care of most of the UI per-instance state
     * for you by calling {@link android.view.View#onSaveInstanceState()} on each
     * view in the hierarchy that has an id, and by saving the id of the currently
     * focused view (all of which is restored by the default implementation of
     * {@link #onRestoreInstanceState}). If you override this method to save
     * additional information not captured by each individual view, you will likely
     * want to call through to the default implementation, otherwise be prepared to
     * save all of the state of each view yourself.
     *
     * <p>
     * If called, this method will occur after {@link #onStop} for applications
     * targeting platforms starting with {@link android.os.Build.VERSION_CODES#P}.
     * For applications targeting earlier platform versions this method will occur
     * before {@link #onStop} and there are no guarantees about whether it will
     * occur before or after {@link #onPause}.
     *
     * @param outState Bundle in which to place your saved state.
     *
     * @see #onCreate
     * @see #onRestoreInstanceState
     * @see #onPause
     */
    protected void onSaveInstanceState(Bundle outState) {
    }

    /**
     * Called as part of the activity lifecycle when an activity is going into the
     * background, but has not (yet) been killed. The counterpart to
     * {@link #onResume}.
     *
     * <p>
     * When activity B is launched in front of activity A, this callback will be
     * invoked on A. B will not be created until A's {@link #onPause} returns, so be
     * sure to not do anything lengthy here.
     *
     * <p>
     * This callback is mostly used for saving any persistent state the activity is
     * editing, to present a "edit in place" model to the user and making sure
     * nothing is lost if there are not enough resources to start the new activity
     * without first killing this one. This is also a good place to do things like
     * stop animations and other things that consume a noticeable amount of CPU in
     * order to make the switch to the next activity as fast as possible, or to
     * close resources that are exclusive access such as the camera.
     *
     * <p>
     * In situations where the system needs more memory it may kill paused processes
     * to reclaim resources. Because of this, you should be sure that all of your
     * state is saved by the time you return from this function. In general
     * {@link #onSaveInstanceState} is used to save per-instance state in the
     * activity and this method is used to store global persistent data (in content
     * providers, files, etc.)
     *
     * <p>
     * After receiving this call you will usually receive a following call to
     * {@link #onStop} (after the next activity has been resumed and displayed),
     * however in some cases there will be a direct call back to {@link #onResume}
     * without going through the stopped state.
     *
     * <p>
     * <em>Derived classes must call through to the super class's implementation of
     * this method. If they do not, an exception will be thrown.</em>
     * </p>
     *
     * @see #onResume
     * @see #onSaveInstanceState
     * @see #onStop
     */
    protected void onPause() {
    }

    /**
     * Called when you are no longer visible to the user. You will next receive
     * either {@link #onRestart}, {@link #onDestroy}, or nothing, depending on later
     * user activity.
     *
     * <p>
     * <em>Derived classes must call through to the super class's implementation of
     * this method. If they do not, an exception will be thrown.</em>
     * </p>
     *
     * @see #onRestart
     * @see #onResume
     * @see #onSaveInstanceState
     * @see #onDestroy
     */
    protected void onStop() {
    }

    /**
     * Perform any final cleanup before an activity is destroyed. This can happen
     * either because the activity is finishing (someone called {@link #finish} on
     * it, or because the system is temporarily destroying this instance of the
     * activity to save space. You can distinguish between these two scenarios with
     * the {@link #isFinishing} method.
     *
     * <p>
     * <em>Note: do not count on this method being called as a place for saving
     * data! For example, if an activity is editing data in a content provider,
     * those edits should be committed in either {@link #onPause} or
     * {@link #onSaveInstanceState}, not here.</em> This method is usually
     * implemented to free resources like threads that are associated with an
     * activity, so that a destroyed activity does not leave such things around
     * while the rest of its application is still running. There are situations
     * where the system will simply kill the activity's hosting process without
     * calling this method (or any others) in it, so it should not be used to do
     * things that are intended to remain around after the process goes away.
     *
     * <p>
     * <em>Derived classes must call through to the super class's implementation of
     * this method. If they do not, an exception will be thrown.</em>
     * </p>
     *
     * @see #onPause
     * @see #onStop
     * @see #finish
     * @see #isFinishing
     */
    protected void onDestroy() {
    }

    /**
     * Finds a view that was identified by the {@code android:id} XML attribute that
     * was processed in {@link #onCreate}.
     * <p>
     * <strong>Note:</strong> In most cases -- depending on compiler support -- the
     * resulting view is automatically cast to the target class type. If the target
     * class type is unconstrained, an explicit cast may be necessary.
     *
     * @param id the ID to search for
     * @return a view with given ID if found, or {@code null} otherwise
     * @see View#findViewById(int)
     * @see Activity#requireViewById(int)
     */
    public <T> T findViewById(int id) {
    }

    /**
     * Set the activity content from a layout resource. The resource will be
     * inflated, adding all top-level views to the activity.
     *
     * @param layoutResID Resource ID to be inflated.
     *
     * @see #setContentView(android.view.View)
     * @see #setContentView(android.view.View, android.view.ViewGroup.LayoutParams)
     */
    public void setContentView(int layoutResID) {
    }

    /**
     * Set the activity content to an explicit view. This view is placed directly
     * into the activity's view hierarchy. It can itself be a complex view
     * hierarchy. When calling this method, the layout parameters of the specified
     * view are ignored. Both the width and the height of the view are set by
     * default to {@link ViewGroup.LayoutParams#MATCH_PARENT}. To use your own
     * layout parameters, invoke
     * {@link #setContentView(android.view.View, android.view.ViewGroup.LayoutParams)}
     * instead.
     *
     * @param view The desired content to display.
     *
     * @see #setContentView(int)
     * @see #setContentView(android.view.View, android.view.ViewGroup.LayoutParams)
     */
    public void setContentView(View view) {
    }

    /**
     * Same as calling {@link #startActivityForResult(Intent, int, Bundle)} with no
     * options.
     *
     * @param intent      The intent to start.
     * @param requestCode If >= 0, this code will be returned in onActivityResult()
     *                    when the activity exits.
     *
     * @throws android.content.ActivityNotFoundException
     *
     * @see #startActivity
     */
    public void startActivityForResult(Intent intent, int requestCode) {
    }

    /**
     * Same as {@link #startActivity(Intent, Bundle)} with no options specified.
     *
     * @param intent The intent to start.
     *
     * @throws android.content.ActivityNotFoundException
     *
     * @see #startActivity(Intent, Bundle)
     * @see #startActivityForResult
     */
    public void startActivity(Intent intent) {
    }

    /**
     * Launch a new activity. You will not receive any information about when the
     * activity exits. This implementation overrides the base version, providing
     * information about the activity performing the launch. Because of this
     * additional information, the {@link Intent#FLAG_ACTIVITY_NEW_TASK} launch flag
     * is not required; if not specified, the new activity will be added to the task
     * of the caller.
     *
     * <p>
     * This method throws {@link android.content.ActivityNotFoundException} if there
     * was no Activity found to run the given Intent.
     *
     * @param intent  The intent to start.
     * @param options Additional options for how the Activity should be started. See
     *                {@link android.content.Context#startActivity(Intent, Bundle)}
     *                Context.startActivity(Intent, Bundle)} for more details.
     *
     * @throws android.content.ActivityNotFoundException
     *
     * @see #startActivity(Intent)
     * @see #startActivityForResult
     */
    public void startActivity(Intent intent, Bundle options) {
    }

    /**
     * Same as {@link #startActivities(Intent[], Bundle)} with no options specified.
     *
     * @param intents The intents to start.
     *
     * @throws android.content.ActivityNotFoundException
     *
     * @see #startActivities(Intent[], Bundle)
     * @see #startActivityForResult
     */
    public void startActivities(Intent[] intents) {
    }

    /**
     * Launch a new activity. You will not receive any information about when the
     * activity exits. This implementation overrides the base version, providing
     * information about the activity performing the launch. Because of this
     * additional information, the {@link Intent#FLAG_ACTIVITY_NEW_TASK} launch flag
     * is not required; if not specified, the new activity will be added to the task
     * of the caller.
     *
     * <p>
     * This method throws {@link android.content.ActivityNotFoundException} if there
     * was no Activity found to run the given Intent.
     *
     * @param intents The intents to start.
     * @param options Additional options for how the Activity should be started. See
     *                {@link android.content.Context#startActivity(Intent, Bundle)}
     *                Context.startActivity(Intent, Bundle)} for more details.
     *
     * @throws android.content.ActivityNotFoundException
     *
     * @see #startActivities(Intent[])
     * @see #startActivityForResult
     */
    public void startActivities(Intent[] intents, Bundle options) {
    }
}