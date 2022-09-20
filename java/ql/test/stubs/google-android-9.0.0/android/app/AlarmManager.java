// Generated automatically from android.app.AlarmManager for testing purposes

package android.app;

import android.app.PendingIntent;
import android.os.Handler;
import android.os.Parcel;
import android.os.Parcelable;

public class AlarmManager
{
    public AlarmManager.AlarmClockInfo getNextAlarmClock(){ return null; }
    public boolean canScheduleExactAlarms(){ return false; }
    public static String ACTION_NEXT_ALARM_CLOCK_CHANGED = null;
    public static String ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED = null;
    public static int ELAPSED_REALTIME = 0;
    public static int ELAPSED_REALTIME_WAKEUP = 0;
    public static int RTC = 0;
    public static int RTC_WAKEUP = 0;
    public static long INTERVAL_DAY = 0;
    public static long INTERVAL_FIFTEEN_MINUTES = 0;
    public static long INTERVAL_HALF_DAY = 0;
    public static long INTERVAL_HALF_HOUR = 0;
    public static long INTERVAL_HOUR = 0;
    public void cancel(AlarmManager.OnAlarmListener p0){}
    public void cancel(PendingIntent p0){}
    public void set(int p0, long p1, PendingIntent p2){}
    public void set(int p0, long p1, String p2, AlarmManager.OnAlarmListener p3, Handler p4){}
    public void setAlarmClock(AlarmManager.AlarmClockInfo p0, PendingIntent p1){}
    public void setAndAllowWhileIdle(int p0, long p1, PendingIntent p2){}
    public void setExact(int p0, long p1, PendingIntent p2){}
    public void setExact(int p0, long p1, String p2, AlarmManager.OnAlarmListener p3, Handler p4){}
    public void setExactAndAllowWhileIdle(int p0, long p1, PendingIntent p2){}
    public void setInexactRepeating(int p0, long p1, long p2, PendingIntent p3){}
    public void setRepeating(int p0, long p1, long p2, PendingIntent p3){}
    public void setTime(long p0){}
    public void setTimeZone(String p0){}
    public void setWindow(int p0, long p1, long p2, PendingIntent p3){}
    public void setWindow(int p0, long p1, long p2, String p3, AlarmManager.OnAlarmListener p4, Handler p5){}
    static public class AlarmClockInfo implements Parcelable
    {
        protected AlarmClockInfo() {}
        public AlarmClockInfo(long p0, PendingIntent p1){}
        public PendingIntent getShowIntent(){ return null; }
        public int describeContents(){ return 0; }
        public long getTriggerTime(){ return 0; }
        public static Parcelable.Creator<AlarmManager.AlarmClockInfo> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public interface OnAlarmListener
    {
        void onAlarm();
    }
}
