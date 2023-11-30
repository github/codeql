// Generated automatically from org.eclipse.emf.common.notify.Adapter for testing purposes

package org.eclipse.emf.common.notify;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.Notifier;

public interface Adapter
{
    Notifier getTarget();
    boolean isAdapterForType(Object p0);
    void notifyChanged(Notification p0);
    void setTarget(Notifier p0);
}
