// Generated automatically from androidx.lifecycle.ViewModelProvider for testing purposes

package androidx.lifecycle;

import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelStore;
import androidx.lifecycle.ViewModelStoreOwner;

public class ViewModelProvider
{
    protected ViewModelProvider() {}
    public <T extends ViewModel> T get(Class<T> p0){ return null; }
    public <T extends ViewModel> T get(String p0, Class<T> p1){ return null; }
    public ViewModelProvider(ViewModelStore p0, ViewModelProvider.Factory p1){}
    public ViewModelProvider(ViewModelStoreOwner p0){}
    public ViewModelProvider(ViewModelStoreOwner p0, ViewModelProvider.Factory p1){}
    static public interface Factory
    {
        <T extends ViewModel> T create(Class<T> p0);
    }
}
