// Generated automatically from android.content.pm.ServiceInfo for testing purposes

package android.content.pm;

import android.content.pm.ComponentInfo;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Printer;

public class ServiceInfo extends ComponentInfo implements Parcelable
{
    public ServiceInfo(){}
    public ServiceInfo(ServiceInfo p0){}
    public String permission = null;
    public String toString(){ return null; }
    public int describeContents(){ return 0; }
    public int flags = 0;
    public int getForegroundServiceType(){ return 0; }
    public static Parcelable.Creator<ServiceInfo> CREATOR = null;
    public static int FLAG_EXTERNAL_SERVICE = 0;
    public static int FLAG_ISOLATED_PROCESS = 0;
    public static int FLAG_SINGLE_USER = 0;
    public static int FLAG_STOP_WITH_TASK = 0;
    public static int FLAG_USE_APP_ZYGOTE = 0;
    public static int FOREGROUND_SERVICE_TYPE_CAMERA = 0;
    public static int FOREGROUND_SERVICE_TYPE_CONNECTED_DEVICE = 0;
    public static int FOREGROUND_SERVICE_TYPE_DATA_SYNC = 0;
    public static int FOREGROUND_SERVICE_TYPE_LOCATION = 0;
    public static int FOREGROUND_SERVICE_TYPE_MANIFEST = 0;
    public static int FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK = 0;
    public static int FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION = 0;
    public static int FOREGROUND_SERVICE_TYPE_MICROPHONE = 0;
    public static int FOREGROUND_SERVICE_TYPE_NONE = 0;
    public static int FOREGROUND_SERVICE_TYPE_PHONE_CALL = 0;
    public void dump(Printer p0, String p1){}
    public void writeToParcel(Parcel p0, int p1){}
}
