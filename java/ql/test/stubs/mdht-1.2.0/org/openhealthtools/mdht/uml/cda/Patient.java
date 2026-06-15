// Generated automatically from org.openhealthtools.mdht.uml.cda.Patient for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.Birthplace;
import org.openhealthtools.mdht.uml.cda.Guardian;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.LanguageCommunication;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.PN;
import org.openhealthtools.mdht.uml.hl7.datatypes.TS;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityClass;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityDeterminer;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Patient extends org.openhealthtools.mdht.uml.hl7.rim.Entity
{
    Birthplace getBirthplace();
    CE getAdministrativeGenderCode();
    CE getEthnicGroupCode();
    CE getMaritalStatusCode();
    CE getRaceCode();
    CE getReligiousAffiliationCode();
    EList<CE> getSDTCRaceCodes();
    EList<CS> getRealmCodes();
    EList<Guardian> getGuardians();
    EList<II> getIds();
    EList<II> getTemplateIds();
    EList<LanguageCommunication> getLanguageCommunications();
    EList<PN> getNames();
    EntityClass getClassCode();
    EntityDeterminer getDeterminerCode();
    II getId();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    TS getBirthTime();
    boolean isSetClassCode();
    boolean isSetDeterminerCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateDeterminerCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAdministrativeGenderCode(CE p0);
    void setBirthTime(TS p0);
    void setBirthplace(Birthplace p0);
    void setClassCode(EntityClass p0);
    void setDeterminerCode(EntityDeterminer p0);
    void setEthnicGroupCode(CE p0);
    void setId(II p0);
    void setMaritalStatusCode(CE p0);
    void setNullFlavor(NullFlavor p0);
    void setRaceCode(CE p0);
    void setReligiousAffiliationCode(CE p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetDeterminerCode();
    void unsetNullFlavor();
}
