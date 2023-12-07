// Generated automatically from org.openhealthtools.mdht.uml.cda.EncounterParticipant for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.AssignedEntity;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.x_EncounterParticipant;

public interface EncounterParticipant extends Participation
{
    AssignedEntity getAssignedEntity();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    IVL_TS getTime();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    void setAssignedEntity(AssignedEntity p0);
    void setNullFlavor(NullFlavor p0);
    void setTime(IVL_TS p0);
    void setTypeCode(x_EncounterParticipant p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetNullFlavor();
    void unsetTypeCode();
    x_EncounterParticipant getTypeCode();
}
