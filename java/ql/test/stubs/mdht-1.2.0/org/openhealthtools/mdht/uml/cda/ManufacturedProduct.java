// Generated automatically from org.openhealthtools.mdht.uml.cda.ManufacturedProduct for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.LabeledDrug;
import org.openhealthtools.mdht.uml.cda.Material;
import org.openhealthtools.mdht.uml.cda.Organization;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.Role;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.RoleClassManufacturedProduct;

public interface ManufacturedProduct extends Role
{
    EList<CS> getRealmCodes();
    EList<II> getIds();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    LabeledDrug getManufacturedLabeledDrug();
    Material getManufacturedMaterial();
    NullFlavor getNullFlavor();
    Organization getManufacturerOrganization();
    RoleClassManufacturedProduct getClassCode();
    boolean isSetClassCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateManufacturedDrugOrOtherMaterial(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(RoleClassManufacturedProduct p0);
    void setManufacturedLabeledDrug(LabeledDrug p0);
    void setManufacturedMaterial(Material p0);
    void setManufacturerOrganization(Organization p0);
    void setNullFlavor(NullFlavor p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetNullFlavor();
}
