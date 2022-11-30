// Generated automatically from androidx.savedstate.SavedStateRegistry for testing purposes

package androidx.savedstate;

import android.os.Bundle;
import androidx.savedstate.SavedStateRegistryOwner;

public class SavedStateRegistry
{
    public Bundle consumeRestoredStateForKey(String p0){ return null; }
    public boolean isRestored(){ return false; }
    public void registerSavedStateProvider(String p0, SavedStateRegistry.SavedStateProvider p1){}
    public void runOnNextRecreation(Class<? extends SavedStateRegistry.AutoRecreated> p0){}
    public void unregisterSavedStateProvider(String p0){}
    static public interface AutoRecreated
    {
        void onRecreated(SavedStateRegistryOwner p0);
    }
    static public interface SavedStateProvider
    {
        Bundle saveState();
    }
}
