// Generated automatically from org.openhealthtools.mdht.uml.cda.EncompassingEncounter for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.EncounterParticipant;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Location;
import org.openhealthtools.mdht.uml.cda.ResponsibleParty;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.vocab.ActClass;
import org.openhealthtools.mdht.uml.hl7.vocab.ActMood;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface EncompassingEncounter extends org.openhealthtools.mdht.uml.hl7.rim.Act
{
    ActClass getClassCode();
    ActMood getMoodCode();
    CE getCode();
    CE getDischargeDispositionCode();
    EList<CS> getRealmCodes();
    EList<EncounterParticipant> getEncounterParticipants();
    EList<II> getIds();
    EList<II> getTemplateIds();
    IVL_TS getEffectiveTime();
    InfrastructureRootTypeId getTypeId();
    Location getLocation();
    NullFlavor getNullFlavor();
    ResponsibleParty getResponsibleParty();
    boolean isSetClassCode();
    boolean isSetMoodCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateMoodCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(ActClass p0);
    void setCode(CE p0);
    void setDischargeDispositionCode(CE p0);
    void setEffectiveTime(IVL_TS p0);
    void setLocation(Location p0);
    void setMoodCode(ActMood p0);
    void setNullFlavor(NullFlavor p0);
    void setResponsibleParty(ResponsibleParty p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetMoodCode();
    void unsetNullFlavor();
}
