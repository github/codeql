// Generated automatically from android.webkit.PermissionRequest for testing purposes

package android.webkit;

import android.net.Uri;

abstract public class PermissionRequest
{
    public PermissionRequest(){}
    public abstract String[] getResources();
    public abstract Uri getOrigin();
    public abstract void deny();
    public abstract void grant(String[] p0);
    public static String RESOURCE_AUDIO_CAPTURE = null;
    public static String RESOURCE_MIDI_SYSEX = null;
    public static String RESOURCE_PROTECTED_MEDIA_ID = null;
    public static String RESOURCE_VIDEO_CAPTURE = null;
}
