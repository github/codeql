// Generated automatically from org.openhealthtools.mdht.uml.cda.Participant2 for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.ParticipantRole;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;
import org.openhealthtools.mdht.uml.hl7.vocab.ContextControl;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.ParticipationType;

public interface Participant2 extends Participation
{
    CE getAwarenessCode();
    ContextControl getContextControlCode();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    IVL_TS getTime();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    ParticipantRole getParticipantRole();
    ParticipationType getTypeCode();
    boolean isSetContextControlCode();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateContextControlCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAwarenessCode(CE p0);
    void setContextControlCode(ContextControl p0);
    void setNullFlavor(NullFlavor p0);
    void setParticipantRole(ParticipantRole p0);
    void setTime(IVL_TS p0);
    void setTypeCode(ParticipationType p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetContextControlCode();
    void unsetNullFlavor();
    void unsetTypeCode();
}
