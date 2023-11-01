// Generated automatically from org.openhealthtools.mdht.uml.cda.Device for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.SC;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityClassDevice;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityDeterminer;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Device extends org.openhealthtools.mdht.uml.hl7.rim.Entity
{
    CE getCode();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    EntityClassDevice getClassCode();
    EntityDeterminer getDeterminerCode();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    SC getManufacturerModelName();
    SC getSoftwareName();
    boolean isSetClassCode();
    boolean isSetDeterminerCode();
    boolean isSetNullFlavor();
    boolean validateDeterminerCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(EntityClassDevice p0);
    void setCode(CE p0);
    void setDeterminerCode(EntityDeterminer p0);
    void setManufacturerModelName(SC p0);
    void setNullFlavor(NullFlavor p0);
    void setSoftwareName(SC p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetDeterminerCode();
    void unsetNullFlavor();
}
