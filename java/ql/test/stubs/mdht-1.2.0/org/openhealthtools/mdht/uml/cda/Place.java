// Generated automatically from org.openhealthtools.mdht.uml.cda.Place for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.AD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.EN;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityClassPlace;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityDeterminer;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Place extends org.openhealthtools.mdht.uml.hl7.rim.Entity
{
    AD getAddr();
    EList<AD> getAddrs();
    EList<CS> getRealmCodes();
    EList<EN> getNames();
    EList<II> getTemplateIds();
    EN getName();
    EntityClassPlace getClassCode();
    EntityDeterminer getDeterminerCode();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    boolean isSetClassCode();
    boolean isSetDeterminerCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateDeterminerCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAddr(AD p0);
    void setClassCode(EntityClassPlace p0);
    void setDeterminerCode(EntityDeterminer p0);
    void setName(EN p0);
    void setNullFlavor(NullFlavor p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetDeterminerCode();
    void unsetNullFlavor();
}
