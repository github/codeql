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
package android.content;

import android.os.Bundle;
/**
 * Base class for code that will receive intents sent by sendBroadcast().
 *
 * <p>If you don't need to send broadcasts across applications, consider using
 * this class with {@link android.support.v4.content.LocalBroadcastManager} instead
 * of the more general facilities described below.  This will give you a much
 * more efficient implementation (no cross-process communication needed) and allow
 * you to avoid thinking about any security issues related to other applications
 * being able to receive or send your broadcasts.
 *
 * <p>You can either dynamically register an instance of this class with
 * {@link Context#registerReceiver Context.registerReceiver()}
 * or statically publish an implementation through the
 * {@link android.R.styleable#AndroidManifestReceiver &lt;receiver&gt;}
 * tag in your <code>AndroidManifest.xml</code>.
 * 
 * <p><em><strong>Note:</strong></em>
 * &nbsp;&nbsp;&nbsp;If registering a receiver in your
 * {@link android.app.Activity#onResume() Activity.onResume()}
 * implementation, you should unregister it in 
 * {@link android.app.Activity#onPause() Activity.onPause()}.
 * (You won't receive intents when paused, 
 * and this will cut down on unnecessary system overhead). Do not unregister in 
 * {@link android.app.Activity#onSaveInstanceState(android.os.Bundle) Activity.onSaveInstanceState()},
 * because this won't be called if the user moves back in the history
 * stack.
 * 
 * <p>There are two major classes of broadcasts that can be received:</p>
 * <ul>
 * <li> <b>Normal broadcasts</b> (sent with {@link Context#sendBroadcast(Intent)
 * Context.sendBroadcast}) are completely asynchronous.  All receivers of the
 * broadcast are run in an undefined order, often at the same time.  This is
 * more efficient, but means that receivers cannot use the result or abort
 * APIs included here.
 * <li> <b>Ordered broadcasts</b> (sent with {@link Context#sendOrderedBroadcast(Intent, String)
 * Context.sendOrderedBroadcast}) are delivered to one receiver at a time.
 * As each receiver executes in turn, it can propagate a result to the next
 * receiver, or it can completely abort the broadcast so that it won't be passed
 * to other receivers.  The order receivers run in can be controlled with the
 * {@link android.R.styleable#AndroidManifestIntentFilter_priority
 * android:priority} attribute of the matching intent-filter; receivers with
 * the same priority will be run in an arbitrary order.
 * </ul>
 * 
 * <p>Even in the case of normal broadcasts, the system may in some
 * situations revert to delivering the broadcast one receiver at a time.  In
 * particular, for receivers that may require the creation of a process, only
 * one will be run at a time to avoid overloading the system with new processes.
 * In this situation, however, the non-ordered semantics hold: these receivers still
 * cannot return results or abort their broadcast.</p>
 * 
 * <p>Note that, although the Intent class is used for sending and receiving
 * these broadcasts, the Intent broadcast mechanism here is completely separate
 * from Intents that are used to start Activities with
 * {@link Context#startActivity Context.startActivity()}.
 * There is no way for a BroadcastReceiver
 * to see or capture Intents used with startActivity(); likewise, when
 * you broadcast an Intent, you will never find or start an Activity.
 * These two operations are semantically very different: starting an
 * Activity with an Intent is a foreground operation that modifies what the
 * user is currently interacting with; broadcasting an Intent is a background
 * operation that the user is not normally aware of.
 * 
 * <p>The BroadcastReceiver class (when launched as a component through
 * a manifest's {@link android.R.styleable#AndroidManifestReceiver &lt;receiver&gt;}
 * tag) is an important part of an
 * <a href="{@docRoot}guide/topics/fundamentals.html#lcycles">application's overall lifecycle</a>.</p>
 * 
 * <p>Topics covered here:
 * <ol>
 * <li><a href="#Security">Security</a>
 * <li><a href="#ReceiverLifecycle">Receiver Lifecycle</a>
 * <li><a href="#ProcessLifecycle">Process Lifecycle</a>
 * </ol>
 *
 * <div class="special reference">
 * <h3>Developer Guides</h3>
 * <p>For information about how to use this class to receive and resolve intents, read the
 * <a href="{@docRoot}guide/topics/intents/intents-filters.html">Intents and Intent Filters</a>
 * developer guide.</p>
 * </div>
 *
 * <a name="Security"></a>
 * <h3>Security</h3>
 *
 * <p>Receivers used with the {@link Context} APIs are by their nature a
 * cross-application facility, so you must consider how other applications
 * may be able to abuse your use of them.  Some things to consider are:
 *
 * <ul>
 * <li><p>The Intent namespace is global.  Make sure that Intent action names and
 * other strings are written in a namespace you own, or else you may inadvertantly
 * conflict with other applications.
 * <li><p>When you use {@link Context#registerReceiver(BroadcastReceiver, IntentFilter)},
 * <em>any</em> application may send broadcasts to that registered receiver.  You can
 * control who can send broadcasts to it through permissions described below.
 * <li><p>When you publish a receiver in your application's manifest and specify
 * intent-filters for it, any other application can send broadcasts to it regardless
 * of the filters you specify.  To prevent others from sending to it, make it
 * unavailable to them with <code>android:exported="false"</code>.
 * <li><p>When you use {@link Context#sendBroadcast(Intent)} or related methods,
 * normally any other application can receive these broadcasts.  You can control who
 * can receive such broadcasts through permissions described below.  Alternatively,
 * starting with {@link android.os.Build.VERSION_CODES#ICE_CREAM_SANDWICH}, you
 * can also safely restrict the broadcast to a single application with
 * {@link Intent#setPackage(String) Intent.setPackage}
 * </ul>
 *
 * <p>None of these issues exist when using
 * {@link android.support.v4.content.LocalBroadcastManager}, since intents
 * broadcast it never go outside of the current process.
 *
 * <p>Access permissions can be enforced by either the sender or receiver
 * of a broadcast.
 *
 * <p>To enforce a permission when sending, you supply a non-null
 * <var>permission</var> argument to
 * {@link Context#sendBroadcast(Intent, String)} or
 * {@link Context#sendOrderedBroadcast(Intent, String, BroadcastReceiver, android.os.Handler, int, String, Bundle)}.
 * Only receivers who have been granted this permission
 * (by requesting it with the
 * {@link android.R.styleable#AndroidManifestUsesPermission &lt;uses-permission&gt;}
 * tag in their <code>AndroidManifest.xml</code>) will be able to receive
 * the broadcast.
 *
 * <p>To enforce a permission when receiving, you supply a non-null
 * <var>permission</var> when registering your receiver -- either when calling
 * {@link Context#registerReceiver(BroadcastReceiver, IntentFilter, String, android.os.Handler)}
 * or in the static
 * {@link android.R.styleable#AndroidManifestReceiver &lt;receiver&gt;}
 * tag in your <code>AndroidManifest.xml</code>.  Only broadcasters who have
 * been granted this permission (by requesting it with the
 * {@link android.R.styleable#AndroidManifestUsesPermission &lt;uses-permission&gt;}
 * tag in their <code>AndroidManifest.xml</code>) will be able to send an
 * Intent to the receiver.
 *
 * <p>See the <a href="{@docRoot}guide/topics/security/security.html">Security and Permissions</a>
 * document for more information on permissions and security in general.
 *
 * <a name="ReceiverLifecycle"></a>
 * <h3>Receiver Lifecycle</h3>
 * 
 * <p>A BroadcastReceiver object is only valid for the duration of the call
 * to {@link #onReceive}.  Once your code returns from this function,
 * the system considers the object to be finished and no longer active.
 * 
 * <p>This has important repercussions to what you can do in an
 * {@link #onReceive} implementation: anything that requires asynchronous
 * operation is not available, because you will need to return from the
 * function to handle the asynchronous operation, but at that point the
 * BroadcastReceiver is no longer active and thus the system is free to kill
 * its process before the asynchronous operation completes.
 * 
 * <p>In particular, you may <i>not</i> show a dialog or bind to a service from
 * within a BroadcastReceiver.  For the former, you should instead use the
 * {@link android.app.NotificationManager} API.  For the latter, you can
 * use {@link android.content.Context#startService Context.startService()} to
 * send a command to the service.
 *
 * <a name="ProcessLifecycle"></a>
 * <h3>Process Lifecycle</h3>
 * 
 * <p>A process that is currently executing a BroadcastReceiver (that is,
 * currently running the code in its {@link #onReceive} method) is
 * considered to be a foreground process and will be kept running by the
 * system except under cases of extreme memory pressure.
 * 
 * <p>Once you return from onReceive(), the BroadcastReceiver is no longer
 * active, and its hosting process is only as important as any other application
 * components that are running in it.  This is especially important because if
 * that process was only hosting the BroadcastReceiver (a common case for
 * applications that the user has never or not recently interacted with), then
 * upon returning from onReceive() the system will consider its process
 * to be empty and aggressively kill it so that resources are available for other
 * more important processes.
 * 
 * <p>This means that for longer-running operations you will often use
 * a {@link android.app.Service} in conjunction with a BroadcastReceiver to keep
 * the containing process active for the entire time of your operation.
 */
public abstract class BroadcastReceiver {
    
    /**
     * State for a result that is pending for a broadcast receiver.  Returned
     * by {@link BroadcastReceiver#goAsync() goAsync()}
     * while in {@link BroadcastReceiver#onReceive BroadcastReceiver.onReceive()}.
     * This allows you to return from onReceive() without having the broadcast
     * terminate; you must call {@link #finish()} once you are done with the
     * broadcast.  This allows you to process the broadcast off of the main
     * thread of your app.
     * 
     * <p>Note on threading: the state inside of this class is not itself
     * thread-safe, however you can use it from any thread if you properly
     * sure that you do not have races.  Typically this means you will hand
     * the entire object to another thread, which will be solely responsible
     * for setting any results and finally calling {@link #finish()}.
     */
    
    public BroadcastReceiver() {
    }
    /**
     * This method is called when the BroadcastReceiver is receiving an Intent
     * broadcast.  During this time you can use the other methods on
     * BroadcastReceiver to view/modify the current result values.  This method
     * is always called within the main thread of its process, unless you
     * explicitly asked for it to be scheduled on a different thread using
     * {@link android.content.Context#registerReceiver(BroadcastReceiver,
     * IntentFilter, String, android.os.Handler)}. When it runs on the main
     * thread you should
     * never perform long-running operations in it (there is a timeout of
     * 10 seconds that the system allows before considering the receiver to
     * be blocked and a candidate to be killed). You cannot launch a popup dialog
     * in your implementation of onReceive().
     *
     * <p><b>If this BroadcastReceiver was launched through a &lt;receiver&gt; tag,
     * then the object is no longer alive after returning from this
     * function.</b>  This means you should not perform any operations that
     * return a result to you asynchronously -- in particular, for interacting
     * with services, you should use
     * {@link Context#startService(Intent)} instead of
     * {@link Context#bindService(Intent, ServiceConnection, int)}.  If you wish
     * to interact with a service that is already running, you can use
     * {@link #peekService}.
     * 
     * <p>The Intent filters used in {@link android.content.Context#registerReceiver}
     * and in application manifests are <em>not</em> guaranteed to be exclusive. They
     * are hints to the operating system about how to find suitable recipients. It is
     * possible for senders to force delivery to specific recipients, bypassing filter
     * resolution.  For this reason, {@link #onReceive(Context, Intent) onReceive()}
     * implementations should respond only to known actions, ignoring any unexpected
     * Intents that they may receive.
     * 
     * @param context The Context in which the receiver is running.
     * @param intent The Intent being received.
     */
    public abstract void onReceive(Context context, Intent intent);
}