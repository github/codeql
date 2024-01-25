// Generated automatically from org.openhealthtools.mdht.uml.cda.Performer2 for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.AssignedEntity;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.ParticipationPhysicalPerformer;

public interface Performer2 extends Participation
{
    AssignedEntity getAssignedEntity();
    CE getModeCode();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    IVL_TS getTime();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    ParticipationPhysicalPerformer getTypeCode();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateTypeCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAssignedEntity(AssignedEntity p0);
    void setModeCode(CE p0);
    void setNullFlavor(NullFlavor p0);
    void setTime(IVL_TS p0);
    void setTypeCode(ParticipationPhysicalPerformer p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetNullFlavor();
    void unsetTypeCode();
}
