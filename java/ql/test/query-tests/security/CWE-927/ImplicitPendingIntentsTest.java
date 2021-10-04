package com.example.test;

import java.io.FileNotFoundException;
import android.app.Activity;
import android.app.PendingIntent;
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

    public static void test(Context ctx) throws PendingIntent.CanceledException {
        {
            Intent baseIntent = new Intent();
            PendingIntent pi = PendingIntent.getActivity(ctx, 0, baseIntent, 0);
            Intent fwdIntent = new Intent();
            fwdIntent.putExtra("fwdIntent", pi);
            ctx.startActivity(fwdIntent); // $hasTaintFlow
            ctx.startActivities(new Intent[] {fwdIntent}); // $hasTaintFlow
            ctx.startService(fwdIntent); // Safe
            ctx.sendBroadcast(fwdIntent); // $hasTaintFlow

            fwdIntent.setPackage("a.safe.package"); // Sanitizer
            ctx.startActivity(fwdIntent); // Safe
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
            ctx.startActivity(fwdIntent); // $ SPURIOUS: $ hasTaintFlow
        }

    }

    static class TestSliceProvider extends SliceProvider {

        @Override
        public Slice onBindSlice(Uri sliceUri) {
            if (sliceUri.getAuthority().equals("1")) {
                Intent baseIntent = new Intent();
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent, 0);
                SliceAction activityAction = SliceAction.createDeeplink(pi, null, 0, "Test");
                ListBuilder listBuilder = new ListBuilder(getContext(), sliceUri, null);
                listBuilder.addRow(new ListBuilder.RowBuilder().setTitle("Title")
                        .setPrimaryAction(activityAction));
                return listBuilder.build(); // $hasTaintFlow

            } else if (sliceUri.getAuthority().equals("2")) {
                Intent baseIntent = new Intent(getContext(), Activity.class); // Sanitizer
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent, 0);
                SliceAction activityAction = SliceAction.createDeeplink(pi, null, 0, "Test");
                ListBuilder listBuilder = new ListBuilder(getContext(), sliceUri, null);
                listBuilder.addRow(new ListBuilder.RowBuilder().setTitle("Title")
                        .setPrimaryAction(activityAction));
                return listBuilder.build(); // Safe

            } else {
                Intent baseIntent = new Intent();
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent,
                        PendingIntent.FLAG_IMMUTABLE); // Sanitizer
                SliceAction activityAction = SliceAction.createDeeplink(pi, null, 0, "Test");
                ListBuilder listBuilder = new ListBuilder(getContext(), sliceUri, null);
                listBuilder.addRow(new ListBuilder.RowBuilder().setTitle("Title")
                        .setPrimaryAction(activityAction));
                return listBuilder.build(); // Safe
            }
        }

        @Override
        public PendingIntent onCreatePermissionRequest(Uri sliceUri, String callingPackage) {
            if (sliceUri.getAuthority().equals("1")) {
                Intent baseIntent = new Intent();
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent, 0);
                return pi; // $hasTaintFlow
            } else {
                Intent baseIntent = new Intent();
                PendingIntent pi = PendingIntent.getActivity(getContext(), 0, baseIntent,
                        PendingIntent.FLAG_IMMUTABLE); // Sanitizer
                return pi; // Safe
            }
        }

        // Implementations needed for compilation
        @Override
        public boolean onCreateSliceProvider() {
            return true;
        }

        @Override
        public AssetFileDescriptor openTypedAssetFile(Uri uri, String mimeTypeFilter, Bundle opts,
                CancellationSignal signal) throws RemoteException, FileNotFoundException {
            return null;
        }

        @Override
        public Bundle call(String authority, String method, String arg, Bundle extras)
                throws RemoteException {
            return null;
        }
    }
}
