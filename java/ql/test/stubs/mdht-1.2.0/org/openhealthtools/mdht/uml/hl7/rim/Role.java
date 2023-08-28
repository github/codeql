// Generated automatically from org.openhealthtools.mdht.uml.hl7.rim.Role for testing purposes

package org.openhealthtools.mdht.uml.hl7.rim;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.Enumerator;
import org.openhealthtools.mdht.uml.hl7.rim.InfrastructureRoot;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;
import org.openhealthtools.mdht.uml.hl7.rim.RoleLink;

public interface Role extends InfrastructureRoot
{
    EList<Participation> getParticipations();
    EList<RoleLink> getInboundLinks();
    EList<RoleLink> getOutboundLinks();
    Enumerator getClassCode();
    boolean isClassCodeDefined();
    org.openhealthtools.mdht.uml.hl7.rim.Entity getPlayer();
    org.openhealthtools.mdht.uml.hl7.rim.Entity getScoper();
}
