// Generated automatically from org.openhealthtools.mdht.uml.hl7.rim.ActRelationship for testing purposes

package org.openhealthtools.mdht.uml.hl7.rim;

import org.eclipse.emf.common.util.Enumerator;
import org.openhealthtools.mdht.uml.hl7.rim.InfrastructureRoot;

public interface ActRelationship extends InfrastructureRoot
{
    Enumerator getTypeCode();
    boolean isTypeCodeDefined();
    org.openhealthtools.mdht.uml.hl7.rim.Act getSource();
    org.openhealthtools.mdht.uml.hl7.rim.Act getTarget();
}
