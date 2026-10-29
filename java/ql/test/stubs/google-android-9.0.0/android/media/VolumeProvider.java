// Generated automatically from android.media.VolumeProvider for testing purposes

package android.media;


abstract public class VolumeProvider
{
    protected VolumeProvider() {}
    public VolumeProvider(int p0, int p1, int p2){}
    public VolumeProvider(int p0, int p1, int p2, String p3){}
    public final String getVolumeControlId(){ return null; }
    public final int getCurrentVolume(){ return 0; }
    public final int getMaxVolume(){ return 0; }
    public final int getVolumeControl(){ return 0; }
    public final void setCurrentVolume(int p0){}
    public static int VOLUME_CONTROL_ABSOLUTE = 0;
    public static int VOLUME_CONTROL_FIXED = 0;
    public static int VOLUME_CONTROL_RELATIVE = 0;
    public void onAdjustVolume(int p0){}
    public void onSetVolumeTo(int p0){}
}
