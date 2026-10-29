// Generated automatically from androidx.lifecycle.Lifecycle for testing purposes

package androidx.lifecycle;

import androidx.lifecycle.LifecycleObserver;

abstract public class Lifecycle
{
    public Lifecycle(){}
    public abstract Lifecycle.State getCurrentState();
    public abstract void addObserver(LifecycleObserver p0);
    public abstract void removeObserver(LifecycleObserver p0);
    static public enum Event
    {
        ON_ANY, ON_CREATE, ON_DESTROY, ON_PAUSE, ON_RESUME, ON_START, ON_STOP;
        private Event() {}
        public Lifecycle.State getTargetState(){ return null; }
        public static Lifecycle.Event downFrom(Lifecycle.State p0){ return null; }
        public static Lifecycle.Event downTo(Lifecycle.State p0){ return null; }
        public static Lifecycle.Event upFrom(Lifecycle.State p0){ return null; }
        public static Lifecycle.Event upTo(Lifecycle.State p0){ return null; }
    }
    static public enum State
    {
        CREATED, DESTROYED, INITIALIZED, RESUMED, STARTED;
        private State() {}
        public boolean isAtLeast(Lifecycle.State p0){ return false; }
    }
}
