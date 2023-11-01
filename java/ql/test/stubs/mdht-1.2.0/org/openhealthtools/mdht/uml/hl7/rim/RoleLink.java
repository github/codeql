// Generated automatically from org.openhealthtools.mdht.uml.hl7.rim.RoleLink for testing purposes

package org.openhealthtools.mdht.uml.hl7.rim;

import org.eclipse.emf.common.util.Enumerator;
import org.openhealthtools.mdht.uml.hl7.rim.InfrastructureRoot;
import org.openhealthtools.mdht.uml.hl7.rim.Role;

public interface RoleLink extends InfrastructureRoot
{
    Enumerator getTypeCode();
    Role getSource();
    Role getTarget();
    boolean isTypeCodeDefined();
}
