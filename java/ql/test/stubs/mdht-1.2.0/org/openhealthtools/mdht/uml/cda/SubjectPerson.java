// Generated automatically from org.openhealthtools.mdht.uml.cda.SubjectPerson for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.BL;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.PN;
import org.openhealthtools.mdht.uml.hl7.datatypes.TS;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityClass;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityDeterminer;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface SubjectPerson extends org.openhealthtools.mdht.uml.hl7.rim.Entity
{
    BL getSDTCDeceasedInd();
    CE getAdministrativeGenderCode();
    EList<CS> getRealmCodes();
    EList<II> getSDTCIds();
    EList<II> getTemplateIds();
    EList<PN> getNames();
    EntityClass getClassCode();
    EntityDeterminer getDeterminerCode();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    TS getBirthTime();
    TS getSDTCDeceasedTime();
    boolean isSetClassCode();
    boolean isSetDeterminerCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateDeterminerCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAdministrativeGenderCode(CE p0);
    void setBirthTime(TS p0);
    void setClassCode(EntityClass p0);
    void setDeterminerCode(EntityDeterminer p0);
    void setNullFlavor(NullFlavor p0);
    void setSDTCDeceasedInd(BL p0);
    void setSDTCDeceasedTime(TS p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetDeterminerCode();
    void unsetNullFlavor();
}
