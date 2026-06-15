// Generated automatically from org.openhealthtools.mdht.uml.cda.CustodianOrganization for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.AD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.EN;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.ON;
import org.openhealthtools.mdht.uml.hl7.datatypes.TEL;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityClassOrganization;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityDeterminer;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface CustodianOrganization extends org.openhealthtools.mdht.uml.hl7.rim.Entity
{
    AD getAddr();
    EList<AD> getAddrs();
    EList<CS> getRealmCodes();
    EList<EN> getNames();
    EList<II> getIds();
    EList<II> getTemplateIds();
    EList<TEL> getTelecoms();
    EntityClassOrganization getClassCode();
    EntityDeterminer getDeterminerCode();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    ON getName();
    TEL getTelecom();
    boolean isSetClassCode();
    boolean isSetDeterminerCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateDeterminerCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAddr(AD p0);
    void setClassCode(EntityClassOrganization p0);
    void setDeterminerCode(EntityDeterminer p0);
    void setName(ON p0);
    void setNullFlavor(NullFlavor p0);
    void setTelecom(TEL p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetDeterminerCode();
    void unsetNullFlavor();
}
