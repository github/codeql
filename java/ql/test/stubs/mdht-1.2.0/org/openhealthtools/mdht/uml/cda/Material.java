// Generated automatically from org.openhealthtools.mdht.uml.cda.Material for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.EN;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.ST;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityClassManufacturedMaterial;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityDeterminerDetermined;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Material extends org.openhealthtools.mdht.uml.hl7.rim.Entity
{
    CE getCode();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    EN getName();
    EntityClassManufacturedMaterial getClassCode();
    EntityDeterminerDetermined getDeterminerCode();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    ST getLotNumberText();
    boolean isSetClassCode();
    boolean isSetDeterminerCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateDeterminerCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(EntityClassManufacturedMaterial p0);
    void setCode(CE p0);
    void setDeterminerCode(EntityDeterminerDetermined p0);
    void setLotNumberText(ST p0);
    void setName(EN p0);
    void setNullFlavor(NullFlavor p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetDeterminerCode();
    void unsetNullFlavor();
}
