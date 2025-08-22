// Generated automatically from org.eclipse.emf.common.notify.Notifier for testing purposes

package org.eclipse.emf.common.notify;

import org.eclipse.emf.common.notify.Adapter;
import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.util.EList;

public interface Notifier
{
    EList<Adapter> eAdapters();
    boolean eDeliver();
    void eNotify(Notification p0);
    void eSetDeliver(boolean p0);
}
