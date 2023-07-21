// Generated automatically from javafx.concurrent.Worker for testing purposes

package javafx.concurrent;

import javafx.beans.property.ReadOnlyBooleanProperty;
import javafx.beans.property.ReadOnlyDoubleProperty;
import javafx.beans.property.ReadOnlyObjectProperty;
import javafx.beans.property.ReadOnlyStringProperty;

public interface Worker<V>
{
    ReadOnlyBooleanProperty runningProperty();
    ReadOnlyDoubleProperty progressProperty();
    ReadOnlyDoubleProperty totalWorkProperty();
    ReadOnlyDoubleProperty workDoneProperty();
    ReadOnlyObjectProperty<Throwable> exceptionProperty();
    ReadOnlyObjectProperty<V> valueProperty();
    ReadOnlyObjectProperty<Worker.State> stateProperty();
    ReadOnlyStringProperty messageProperty();
    ReadOnlyStringProperty titleProperty();
    String getMessage();
    String getTitle();
    Throwable getException();
    V getValue();
    Worker.State getState();
    boolean cancel();
    boolean isRunning();
    double getProgress();
    double getTotalWork();
    double getWorkDone();
    static public enum State
    {
        CANCELLED, FAILED, READY, RUNNING, SCHEDULED, SUCCEEDED;
        private State() {}
    }
}
