// Generated automatically from org.openhealthtools.mdht.uml.hl7.rim.Act for testing purposes

package org.openhealthtools.mdht.uml.hl7.rim;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.Enumerator;
import org.openhealthtools.mdht.uml.hl7.rim.ActRelationship;
import org.openhealthtools.mdht.uml.hl7.rim.InfrastructureRoot;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;

public interface Act extends InfrastructureRoot
{
    Boolean getNegationInd();
    EList<ActRelationship> getInboundRelationships();
    EList<ActRelationship> getOutboundRelationships();
    EList<Participation> getParticipations();
    Enumerator getClassCode();
    Enumerator getMoodCode();
    boolean isClassCodeDefined();
    boolean isMoodCodeDefined();
}
