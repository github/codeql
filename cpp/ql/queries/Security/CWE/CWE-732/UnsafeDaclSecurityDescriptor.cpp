SECURITY_DESCRIPTOR  pSD;
SECURITY_ATTRIBUTES  SA;

if (!InitializeSecurityDescriptor(&pSD, SECURITY_DESCRIPTOR_REVISION))
{
    // error handling
}
if (!SetSecurityDescriptorDacl(&pSD,
    TRUE,   // bDaclPresent - this value indicates the presence of a DACL in the security descriptor
    NULL,   // pDacl - the pDacl parameter does not point to a DACL. All access will be allowed
    FALSE))
{
    // error handling
}
