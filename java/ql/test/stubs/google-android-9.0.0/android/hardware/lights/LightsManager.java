// Generated automatically from android.hardware.lights.LightsManager for testing purposes

package android.hardware.lights;

import android.hardware.lights.Light;
import android.hardware.lights.LightState;
import android.hardware.lights.LightsRequest;
import java.util.List;

abstract public class LightsManager
{
    abstract static public class LightsSession implements AutoCloseable
    {
        public abstract void close();
        public abstract void requestLights(LightsRequest p0);
    }
    public abstract LightState getLightState(Light p0);
    public abstract LightsManager.LightsSession openSession();
    public abstract List<Light> getLights();
}
