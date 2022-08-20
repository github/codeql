import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;

public class ImplicitPendingIntents extends Activity {

	public void onCreate(Bundle savedInstance) {
		{
			// BAD: an implicit Intent is used to create a PendingIntent.
			// The PendingIntent is then added to another implicit Intent
			// and started.
			Intent baseIntent = new Intent();
			PendingIntent pi =
					PendingIntent.getActivity(this, 0, baseIntent, PendingIntent.FLAG_ONE_SHOT);
			Intent fwdIntent = new Intent("SOME_ACTION");
			fwdIntent.putExtra("fwdIntent", pi);
			sendBroadcast(fwdIntent);
		}

		{
			// GOOD: both the PendingIntent and the wrapping Intent are explicit.
			Intent safeIntent = new Intent(this, AnotherActivity.class);
			PendingIntent pi =
					PendingIntent.getActivity(this, 0, safeIntent, PendingIntent.FLAG_ONE_SHOT);
			Intent fwdIntent = new Intent();
			fwdIntent.setClassName("destination.package", "DestinationClass");
			fwdIntent.putExtra("fwdIntent", pi);
			startActivity(fwdIntent);
		}

		{
			// GOOD: The PendingIntent is created with FLAG_IMMUTABLE.
			Intent baseIntent = new Intent("SOME_ACTION");
			PendingIntent pi =
					PendingIntent.getActivity(this, 0, baseIntent, PendingIntent.FLAG_IMMUTABLE);
			Intent fwdIntent = new Intent();
			fwdIntent.setClassName("destination.package", "DestinationClass");
			fwdIntent.putExtra("fwdIntent", pi);
			startActivity(fwdIntent);
		}
	}
}
