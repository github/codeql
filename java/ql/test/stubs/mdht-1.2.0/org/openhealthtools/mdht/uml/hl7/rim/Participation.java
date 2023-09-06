// Generated automatically from org.openhealthtools.mdht.uml.hl7.rim.Participation for testing purposes

package org.openhealthtools.mdht.uml.hl7.rim;

import org.eclipse.emf.common.util.Enumerator;
import org.openhealthtools.mdht.uml.hl7.rim.InfrastructureRoot;
import org.openhealthtools.mdht.uml.hl7.rim.Role;

public interface Participation extends InfrastructureRoot
{
    Enumerator getTypeCode();
    Role getRole();
    boolean isContextControlCodeDefined();
    boolean isTypeCodeDefined();
    org.openhealthtools.mdht.uml.hl7.rim.Act getAct();
}
