package com.example.test;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

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
}
