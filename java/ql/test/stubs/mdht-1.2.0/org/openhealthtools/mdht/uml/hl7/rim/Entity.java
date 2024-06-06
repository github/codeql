// Generated automatically from org.openhealthtools.mdht.uml.hl7.rim.Entity for testing purposes

package org.openhealthtools.mdht.uml.hl7.rim;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.Enumerator;
import org.openhealthtools.mdht.uml.hl7.rim.InfrastructureRoot;
import org.openhealthtools.mdht.uml.hl7.rim.Role;

public interface Entity extends InfrastructureRoot
{
    EList<Role> getPlayedRoles();
    EList<Role> getScopedRoles();
    Enumerator getClassCode();
    Enumerator getDeterminerCode();
    boolean isClassCodeDefined();
    boolean isDeterminerCodeDefined();
}
