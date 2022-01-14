package com.example.test;

import java.io.FileNotFoundException;
import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetFileDescriptor;
import android.net.Uri;
import android.os.Bundle;
import android.os.CancellationSignal;
import android.os.RemoteException;
import androidx.core.graphics.drawable.IconCompat;
import androidx.slice.Slice;
import androidx.slice.SliceProvider;
import androidx.slice.builders.ListBuilder;
import androidx.slice.builders.SliceAction;
import androidx.slice.core.SliceHints.ImageMode;

public class ImplicitPendingIntentsTest {

    public static void testPendingIntentAsAnExtra(Context ctx)
            throws PendingIntent.CanceledException {
        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, baseIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // $hasImplicitPendingIntent
            ctx.startActivities(new Intent[] {fwdIntent}); // $hasImplicitPendingIntent
            ctx.startService(fwdIntent); // Safe
            ctx.sendBroadcast(fwdIntent); // $hasImplicitPendingIntent

            fwdIntent.setComponent(null); // Not a sanitizer
            ctx.startActivity(fwdIntent); // $hasImplicitPendingIntent

            fwdIntent.setPackage("a.safe.package"); // Sanitizer
            ctx.startActivity(fwdIntent); // Safe
        }

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivityAsUser(ctx, 0, baseIntent, 0, null, null);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // $hasImplicitPendingIntent
        }

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivities(ctx, 0, new Intent[] {baseIntent}, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // $hasImplicitPendingIntent
        }

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivitiesAsUser(ctx, 0, new Intent[] {baseIntent},
                    0, null, null);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // $hasImplicitPendingIntent
        }

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getBroadcast(ctx, 0, baseIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.sendBroadcast(fwdIntent); // $hasImplicitPendingIntent
        }

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getBroadcastAsUser(ctx, 0, baseIntent, 0, null);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.sendBroadcast(fwdIntent); // $hasImplicitPendingIntent
        }

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getService(ctx, 0, baseIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // $hasImplicitPendingIntent
        }

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getForegroundService(ctx, 0, baseIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // $hasImplicitPendingIntent
        }

        {
            Intent intent = new Intent();
            // Testing the need of going through a PendingIntent creation (flow state)
            ctx.startActivity(intent); // Safe
        }

        {
            Intent safeIntent = new Intent(ctx, Activity.class); // Sanitizer
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, safeIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // Safe
        }

        {
            Intent safeIntent = new Intent();
            safeIntent.setClass(ctx, Object.class); // Sanitizer
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, safeIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // Safe
        }

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, baseIntent, 0);
            Intent fwdIntent = new Intent(ctx, Activity.class); // Sanitizer
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // Safe
        }

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, baseIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.setPackage("a.safe.package"); // Sanitizer
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // Safe
        }

        {
            Intent baseIntent = new Intent();
            int flag = PendingIntent.FLAG_IMMUTABLE;
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, baseIntent, flag); // Sanitizer
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // Safe
        }

        {
            Intent baseIntent = new Intent();
            int flag = PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_ONE_SHOT;
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, baseIntent, flag); // Sanitizer
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // $ SPURIOUS: $ hasImplicitPendingIntent
        }
    }

    public static void testPendingIntentWrappedInAnotherPendingIntent(Context ctx,
            PendingIntent other) throws PendingIntent.CanceledException {
        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, baseIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            other.send(ctx, 0, fwdIntent); // $hasImplicitPendingIntent
            other.send(ctx, 0, fwdIntent, null, null); // $hasImplicitPendingIntent
            other.send(ctx, 0, fwdIntent, null, null, null); // $hasImplicitPendingIntent
            other.send(ctx, 0, fwdIntent, null, null, null, null); // $hasImplicitPendingIntent
        }
    }

    public static void testPendingIntentInANotification(Context ctx)
            throws PendingIntent.CanceledException {

        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, baseIntent, 0);
            Notification.Action.Builder aBuilder = new Notification.Action.Builder(0, "", pi);
            Notification.Builder nBuilder =
                    new Notification.Builder(ctx).addAction(aBuilder.build());
            Notification notification = nBuilder.build();
            NotificationManager nManager = new NotificationManager();
            nManager.notifyAsPackage("targetPackage", "tag", 0, notification); // $hasImplicitPendingIntent
            nManager.notify(0, notification); // $hasImplicitPendingIntent
            nManager.notifyAsUser("", 0, notification, null); // $hasImplicitPendingIntent
        }
        {
            Intent baseIntent = new Intent();
            PendingIntent pi =
                    PendingIntent.getActivity(ctx, 0, baseIntent, PendingIntent.FLAG_IMMUTABLE); // Sanitizer
            Notification.Action.Builder aBuilder = new Notification.Action.Builder(0, "", pi);
            Notification.Builder nBuilder =
                    new Notification.Builder(ctx).addAction(aBuilder.build());
            Notification notification = nBuilder.build();
            NotificationManager nManager = new NotificationManager();
            nManager.notify(0, notification); // Safe
        }
        {
            // Even though pi1 is vulnerable, it's wrapped in fwdIntent,
            // from which pi2 (safe) is created. Since only system apps can extract an Intent
            // from a PendingIntent (via android.permission.GET_INTENT_SENDER_INTENT),
            // the attacker has no way of accessing fwdIntent, and thus pi1.
            Intent baseIntent = new Intent();
            PendingIntent pi1 = PendingIntent.getActivity(ctx, 0, baseIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi1);
            PendingIntent pi2 =
                    PendingIntent.getActivity(ctx, 0, fwdIntent, PendingIntent.FLAG_IMMUTABLE);
            Notification.Action action = new Notification.Action(0, "", pi2);
            Notification.Builder nBuilder = new Notification.Builder(ctx).addAction(action);
            Notification notification = nBuilder.build();
            NotificationManager noMan = new NotificationManager();
            noMan.notify(0, notification); // Safe
        }

    }

    static class TestActivity extends Activity {
        @Override
        public void onCreate(Bundle bundle) {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivity(null, 0, baseIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            setResult(0, fwdIntent); // $hasImplicitPendingIntent
        }
    }

    static class TestSliceProvider extends SliceProvider {

        private PendingIntent mPendingIntent;

        @Override
        public Slice onBindSlice(Uri sliceUri) {
            if (sliceUri.getAuthority().equals("1")) {
                Intent baseIntent = new Intent();
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent, 0);
                SliceAction activityAction = SliceAction.createDeeplink(pi, null, 0, "Test");
                ListBuilder listBuilder = new ListBuilder(getContext(), sliceUri, null);
                listBuilder.addRow(new ListBuilder.RowBuilder().setTitle("Title")
                        .setPrimaryAction(activityAction));
                return listBuilder.build(); // $hasImplicitPendingIntent

            } else if (sliceUri.getAuthority().equals("2")) {
                Intent baseIntent = new Intent(getContext(), Activity.class); // Sanitizer
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent, 0);
                SliceAction activityAction = SliceAction.createDeeplink(pi, null, 0, "Test");
                ListBuilder listBuilder = new ListBuilder(getContext(), sliceUri, null);
                listBuilder.addRow(new ListBuilder.RowBuilder().setTitle("Title")
                        .setPrimaryAction(activityAction));
                return listBuilder.build(); // Safe

            } else if (sliceUri.getAuthority().equals("3")) {
                Intent baseIntent = new Intent();
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent,
                        PendingIntent.FLAG_IMMUTABLE); // Sanitizer
                SliceAction activityAction = SliceAction.createDeeplink(pi, null, 0, "Test");
                ListBuilder listBuilder = new ListBuilder(getContext(), sliceUri, null);
                listBuilder.addRow(new ListBuilder.RowBuilder().setTitle("Title")
                        .setPrimaryAction(activityAction));
                return listBuilder.build(); // Safe

            } else {
                // Testing implicit field read flows:
                // mPendingIntent is set in onCreateSliceProvider
                SliceAction action = SliceAction.createDeeplink(mPendingIntent, null, 0, "");
                ListBuilder listBuilder = new ListBuilder(getContext(), sliceUri, 0);
                listBuilder.addRow(new ListBuilder.RowBuilder(sliceUri).setPrimaryAction(action));
                return listBuilder.build(); // $hasImplicitPendingIntent
            }
        }

        @Override
        public PendingIntent onCreatePermissionRequest(Uri sliceUri, String callingPackage) {
            if (sliceUri.getAuthority().equals("1")) {
                Intent baseIntent = new Intent();
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent, 0);
                return pi; // $hasImplicitPendingIntent
            } else {
                Intent baseIntent = new Intent();
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent,
                        PendingIntent.FLAG_IMMUTABLE); // Sanitizer
                return pi; // Safe
            }
        }

        @Override
        public boolean onCreateSliceProvider() {
            // Testing implicit field read flows:
            // mPendingIntent is used in onBindSlice
            Intent baseIntent = new Intent();
            mPendingIntent = PendingIntent.getActivity(getContext(), 0, baseIntent, 0);
            return true;
        }
    }
}
