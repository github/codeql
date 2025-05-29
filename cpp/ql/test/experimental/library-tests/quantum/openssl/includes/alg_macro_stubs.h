# define EVP_PKEY_NONE   NID_undef
# define EVP_PKEY_RSA    NID_rsaEncryption
# define EVP_PKEY_RSA2   NID_rsa
# define EVP_PKEY_RSA_PSS NID_rsassaPss
# define EVP_PKEY_DSA    NID_dsa
# define EVP_PKEY_DSA1   NID_dsa_2
# define EVP_PKEY_DSA2   NID_dsaWithSHA
# define EVP_PKEY_DSA3   NID_dsaWithSHA1
# define EVP_PKEY_DSA4   NID_dsaWithSHA1_2
# define EVP_PKEY_DH     NID_dhKeyAgreement
# define EVP_PKEY_DHX    NID_dhpublicnumber
# define EVP_PKEY_EC     NID_X9_62_id_ecPublicKey
# define EVP_PKEY_SM2    NID_sm2
# define EVP_PKEY_HMAC   NID_hmac
# define EVP_PKEY_CMAC   NID_cmac
# define EVP_PKEY_SCRYPT NID_id_scrypt
# define EVP_PKEY_TLS1_PRF NID_tls1_prf
# define EVP_PKEY_HKDF   NID_hkdf
# define EVP_PKEY_POLY1305 NID_poly1305
# define EVP_PKEY_SIPHASH NID_siphash
# define EVP_PKEY_X25519 NID_X25519
# define EVP_PKEY_ED25519 NID_ED25519
# define EVP_PKEY_X448 NID_X448
# define EVP_PKEY_ED448 NID_ED448

#define NID_crl_reason 141
#define NID_invalidity_date 142
#define NID_hold_instruction_code 430
#define NID_undef 0
#define NID_pkcs9_emailAddress 48
#define NID_crl_number 88
#define SN_aes_256_cbc "AES-256-CBC"
#define NID_id_it_caCerts 1223
#define NID_id_it_rootCaCert 1254
#define NID_id_it_crlStatusList 1256
#define NID_id_it_certReqTemplate 1225
#define NID_id_regCtrl_algId 1259
#define NID_id_regCtrl_rsaKeyLen 1260
#define NID_pkcs7_signed 22
#define NID_pkcs7_data 21
#define NID_ED25519 1087
#define NID_ED448 1088
#define SN_sha256 "SHA256"
#define NID_hmac 855
#define SN_X9_62_prime192v1 "prime192v1"
#define SN_X9_62_prime256v1 "prime256v1"
#define NID_grasshopper_mac NID_kuznyechik_mac
#define SN_grasshopper_mac SN_kuznyechik_mac
#define NID_grasshopper_cfb NID_kuznyechik_cfb
#define SN_grasshopper_cfb SN_kuznyechik_cfb
#define NID_grasshopper_cbc NID_kuznyechik_cbc
#define SN_grasshopper_cbc SN_kuznyechik_cbc
#define NID_grasshopper_ofb NID_kuznyechik_ofb
#define SN_grasshopper_ofb SN_kuznyechik_ofb
#define NID_grasshopper_ctr NID_kuznyechik_ctr
#define SN_grasshopper_ctr SN_kuznyechik_ctr
#define NID_grasshopper_ecb NID_kuznyechik_ecb
#define SN_grasshopper_ecb SN_kuznyechik_ecb
#define NID_id_tc26_wrap_gostr3412_2015_kuznyechik_kexp15 NID_kuznyechik_kexp15
#define SN_id_tc26_wrap_gostr3412_2015_kuznyechik_kexp15 SN_kuznyechik_kexp15
#define NID_id_tc26_wrap_gostr3412_2015_magma_kexp15 NID_magma_kexp15
#define SN_id_tc26_wrap_gostr3412_2015_magma_kexp15 SN_magma_kexp15
#define NID_id_tc26_cipher_gostr3412_2015_kuznyechik_ctracpkm_omac NID_kuznyechik_ctr_acpkm_omac
#define SN_id_tc26_cipher_gostr3412_2015_kuznyechik_ctracpkm_omac SN_kuznyechik_ctr_acpkm_omac
#define NID_id_tc26_cipher_gostr3412_2015_kuznyechik_ctracpkm NID_kuznyechik_ctr_acpkm
#define SN_id_tc26_cipher_gostr3412_2015_kuznyechik_ctracpkm SN_kuznyechik_ctr_acpkm
#define NID_id_tc26_cipher_gostr3412_2015_magma_ctracpkm_omac NID_magma_ctr_acpkm_omac
#define SN_id_tc26_cipher_gostr3412_2015_magma_ctracpkm_omac SN_magma_ctr_acpkm_omac
#define NID_id_tc26_cipher_gostr3412_2015_magma_ctracpkm NID_magma_ctr_acpkm
#define SN_id_tc26_cipher_gostr3412_2015_magma_ctracpkm SN_magma_ctr_acpkm
#define NID_ML_KEM_1024 1456
#define LN_ML_KEM_1024 "ML-KEM-1024"
#define SN_ML_KEM_1024 "id-alg-ml-kem-1024"
#define NID_ML_KEM_768 1455
#define LN_ML_KEM_768 "ML-KEM-768"
#define SN_ML_KEM_768 "id-alg-ml-kem-768"
#define NID_ML_KEM_512 1454
#define LN_ML_KEM_512 "ML-KEM-512"
#define SN_ML_KEM_512 "id-alg-ml-kem-512"
#define NID_tcg_tr_cat_PublicKey 1453
#define LN_tcg_tr_cat_PublicKey "Public Key Trait Category"
#define SN_tcg_tr_cat_PublicKey "tcg-tr-cat-PublicKey"
#define NID_tcg_tr_cat_RTM 1452
#define LN_tcg_tr_cat_RTM "Root of Trust of Measurement Trait Category"
#define SN_tcg_tr_cat_RTM "tcg-tr-cat-RTM"
#define NID_tcg_tr_cat_platformFirmwareUpdateCompliance 1451
#define LN_tcg_tr_cat_platformFirmwareUpdateCompliance "Platform Firmware Update Compliance Trait Category"
#define SN_tcg_tr_cat_platformFirmwareUpdateCompliance "tcg-tr-cat-platformFirmwareUpdateCompliance"
#define NID_tcg_tr_cat_platformFirmwareSignatureVerification 1450
#define LN_tcg_tr_cat_platformFirmwareSignatureVerification "Platform Firmware Signature Verification Trait Category"
#define SN_tcg_tr_cat_platformFirmwareSignatureVerification "tcg-tr-cat-platformFirmwareSignatureVerification"
#define NID_tcg_tr_cat_platformHardwareCapabilities 1449
#define LN_tcg_tr_cat_platformHardwareCapabilities "Platform Hardware Capabilities Trait Category"
#define SN_tcg_tr_cat_platformHardwareCapabilities "tcg-tr-cat-platformHardwareCapabilities"
#define NID_tcg_tr_cat_platformFirmwareCapabilities 1448
#define LN_tcg_tr_cat_platformFirmwareCapabilities "Platform Firmware Capabilities Trait Category"
#define SN_tcg_tr_cat_platformFirmwareCapabilities "tcg-tr-cat-platformFirmwareCapabilities"
#define NID_tcg_tr_cat_PEN 1447
#define LN_tcg_tr_cat_PEN "Private Enterprise Number Trait Category"
#define SN_tcg_tr_cat_PEN "tcg-tr-cat-PEN"
#define NID_tcg_tr_cat_attestationProtocol 1446
#define LN_tcg_tr_cat_attestationProtocol "Attestation Protocol Trait Category"
#define SN_tcg_tr_cat_attestationProtocol "tcg-tr-cat-attestationProtocol"
#define NID_tcg_tr_cat_networkMAC 1445
#define LN_tcg_tr_cat_networkMAC "Network MAC Trait Category"
#define SN_tcg_tr_cat_networkMAC "tcg-tr-cat-networkMAC"
#define NID_tcg_tr_cat_ISO9000 1444
#define LN_tcg_tr_cat_ISO9000 "ISO 9000 Trait Category"
#define SN_tcg_tr_cat_ISO9000 "tcg-tr-cat-ISO9000"
#define NID_tcg_tr_cat_FIPSLevel 1443
#define LN_tcg_tr_cat_FIPSLevel "FIPS Level Trait Category"
#define SN_tcg_tr_cat_FIPSLevel "tcg-tr-cat-FIPSLevel"
#define NID_tcg_tr_cat_componentIdentifierV11 1442
#define LN_tcg_tr_cat_componentIdentifierV11 "Component Identifier V1.1 Trait Category"
#define SN_tcg_tr_cat_componentIdentifierV11 "tcg-tr-cat-componentIdentifierV11"
#define NID_tcg_tr_cat_CommonCriteria 1441
#define LN_tcg_tr_cat_CommonCriteria "Common Criteria Trait Category"
#define SN_tcg_tr_cat_CommonCriteria "tcg-tr-cat-CommonCriteria"
#define NID_tcg_tr_cat_genericCertificate 1440
#define LN_tcg_tr_cat_genericCertificate "Generic Certificate Trait Category"
#define SN_tcg_tr_cat_genericCertificate "tcg-tr-cat-genericCertificate"
#define NID_tcg_tr_cat_RebasePlatformCertificate 1439
#define LN_tcg_tr_cat_RebasePlatformCertificate "Rebase Platform Certificate Trait Category"
#define SN_tcg_tr_cat_RebasePlatformCertificate "tcg-tr-cat-RebasePlatformCertificate"
#define NID_tcg_tr_cat_DeltaPlatformCertificate 1438
#define LN_tcg_tr_cat_DeltaPlatformCertificate "Delta Platform Certificate Trait Category"
#define SN_tcg_tr_cat_DeltaPlatformCertificate "tcg-tr-cat-DeltaPlatformCertificate"
#define NID_tcg_tr_cat_PlatformCertificate 1437
#define LN_tcg_tr_cat_PlatformCertificate "Platform Certificate Trait Category"
#define SN_tcg_tr_cat_PlatformCertificate "tcg-tr-cat-PlatformCertificate"
#define NID_tcg_tr_cat_PEMCertificate 1436
#define LN_tcg_tr_cat_PEMCertificate "PEM Certificate Trait Category"
#define SN_tcg_tr_cat_PEMCertificate "tcg-tr-cat-PEMCertificate"
#define NID_tcg_tr_cat_SPDMCertificate 1435
#define LN_tcg_tr_cat_SPDMCertificate "SPDM Certificate Trait Category"
#define SN_tcg_tr_cat_SPDMCertificate "tcg-tr-cat-SPDMCertificate"
#define NID_tcg_tr_cat_DICECertificate 1434
#define LN_tcg_tr_cat_DICECertificate "DICE Certificate Trait Category"
#define SN_tcg_tr_cat_DICECertificate "tcg-tr-cat-DICECertificate"
#define NID_tcg_tr_cat_IDevIDCertificate 1433
#define LN_tcg_tr_cat_IDevIDCertificate "IDevID Certificate Trait Category"
#define SN_tcg_tr_cat_IDevIDCertificate "tcg-tr-cat-IDevIDCertificate"
#define NID_tcg_tr_cat_IAKCertificate 1432
#define LN_tcg_tr_cat_IAKCertificate "IAK Certificate Trait Category"
#define SN_tcg_tr_cat_IAKCertificate "tcg-tr-cat-IAKCertificate"
#define NID_tcg_tr_cat_EKCertificate 1431
#define LN_tcg_tr_cat_EKCertificate "EK Certificate Trait Category"
#define SN_tcg_tr_cat_EKCertificate "tcg-tr-cat-EKCertificate"
#define NID_tcg_tr_cat_componentFieldReplaceable 1430
#define LN_tcg_tr_cat_componentFieldReplaceable "Component Field Replaceable Trait Category"
#define SN_tcg_tr_cat_componentFieldReplaceable "tcg-tr-cat-componentFieldReplaceable"
#define NID_tcg_tr_cat_componentRevision 1429
#define LN_tcg_tr_cat_componentRevision "Component Revision Trait Category"
#define SN_tcg_tr_cat_componentRevision "tcg-tr-cat-componentRevision"
#define NID_tcg_tr_cat_componentLocation 1428
#define LN_tcg_tr_cat_componentLocation "Component Location Trait Category"
#define SN_tcg_tr_cat_componentLocation "tcg-tr-cat-componentLocation"
#define NID_tcg_tr_cat_componentStatus 1427
#define LN_tcg_tr_cat_componentStatus "Component Status Trait Category"
#define SN_tcg_tr_cat_componentStatus "tcg-tr-cat-componentStatus"
#define NID_tcg_tr_cat_componentSerial 1426
#define LN_tcg_tr_cat_componentSerial "Component Serial Trait Category"
#define SN_tcg_tr_cat_componentSerial "tcg-tr-cat-componentSerial"
#define NID_tcg_tr_cat_componentModel 1425
#define LN_tcg_tr_cat_componentModel "Component Model Trait Category"
#define SN_tcg_tr_cat_componentModel "tcg-tr-cat-componentModel"
#define NID_tcg_tr_cat_componentManufacturer 1424
#define LN_tcg_tr_cat_componentManufacturer "Component Manufacturer Trait Category"
#define SN_tcg_tr_cat_componentManufacturer "tcg-tr-cat-componentManufacturer"
#define NID_tcg_tr_cat_componentClass 1423
#define LN_tcg_tr_cat_componentClass "Component Class Trait Category"
#define SN_tcg_tr_cat_componentClass "tcg-tr-cat-componentClass"
#define NID_tcg_tr_cat_platformOwnership 1422
#define LN_tcg_tr_cat_platformOwnership "Platform Ownership Trait Category"
#define SN_tcg_tr_cat_platformOwnership "tcg-tr-cat-platformOwnership"
#define NID_tcg_tr_cat_platformManufacturerIdentifier 1421
#define LN_tcg_tr_cat_platformManufacturerIdentifier "Platform Manufacturer Identifier Trait Category"
#define SN_tcg_tr_cat_platformManufacturerIdentifier "tcg-tr-cat-platformManufacturerIdentifier"
#define NID_tcg_tr_cat_platformSerial 1420
#define LN_tcg_tr_cat_platformSerial "Platform Serial Trait Category"
#define SN_tcg_tr_cat_platformSerial "tcg-tr-cat-platformSerial"
#define NID_tcg_tr_cat_platformVersion 1419
#define LN_tcg_tr_cat_platformVersion "Platform Version Trait Category"
#define SN_tcg_tr_cat_platformVersion "tcg-tr-cat-platformVersion"
#define NID_tcg_tr_cat_platformModel 1418
#define LN_tcg_tr_cat_platformModel "Platform Model Trait Category"
#define SN_tcg_tr_cat_platformModel "tcg-tr-cat-platformModel"
#define NID_tcg_tr_cat_platformManufacturer 1417
#define LN_tcg_tr_cat_platformManufacturer "Platform Manufacturer Trait Category"
#define SN_tcg_tr_cat_platformManufacturer "tcg-tr-cat-platformManufacturer"
#define NID_tcg_tr_ID_PublicKey 1416
#define LN_tcg_tr_ID_PublicKey "Public Key Trait"
#define SN_tcg_tr_ID_PublicKey "tcg-tr-ID-PublicKey"
#define NID_tcg_tr_ID_PEMCertString 1415
#define LN_tcg_tr_ID_PEMCertString "PEM-Encoded Certificate String Trait"
#define SN_tcg_tr_ID_PEMCertString "tcg-tr-ID-PEMCertString"
#define NID_tcg_tr_ID_IA5String 1414
#define LN_tcg_tr_ID_IA5String "IA5String Trait"
#define SN_tcg_tr_ID_IA5String "tcg-tr-ID-IA5String"
#define NID_tcg_tr_ID_UTF8String 1413
#define LN_tcg_tr_ID_UTF8String "UTF8String Trait"
#define SN_tcg_tr_ID_UTF8String "tcg-tr-ID-UTF8String"
#define NID_tcg_tr_ID_URI 1412
#define LN_tcg_tr_ID_URI "Uniform Resource Identifier Trait"
#define SN_tcg_tr_ID_URI "tcg-tr-ID-URI"
#define NID_tcg_tr_ID_status 1411
#define LN_tcg_tr_ID_status "Attribute Status Trait"
#define SN_tcg_tr_ID_status "tcg-tr-ID-status"
#define NID_tcg_tr_ID_RTM 1410
#define LN_tcg_tr_ID_RTM "Root of Trust for Measurement Trait"
#define SN_tcg_tr_ID_RTM "tcg-tr-ID-RTM"
#define NID_tcg_tr_ID_platformHardwareCapabilities 1409
#define LN_tcg_tr_ID_platformHardwareCapabilities "Platform Hardware Capabilities Trait"
#define SN_tcg_tr_ID_platformHardwareCapabilities "tcg-tr-ID-platformHardwareCapabilities"
#define NID_tcg_tr_ID_platformFirmwareUpdateCompliance 1408
#define LN_tcg_tr_ID_platformFirmwareUpdateCompliance "Platform Firmware Update Compliance Trait"
#define SN_tcg_tr_ID_platformFirmwareUpdateCompliance "tcg-tr-ID-platformFirmwareUpdateCompliance"
#define NID_tcg_tr_ID_platformFirmwareSignatureVerification 1407
#define LN_tcg_tr_ID_platformFirmwareSignatureVerification "Platform Firmware Signature Verification Trait"
#define SN_tcg_tr_ID_platformFirmwareSignatureVerification "tcg-tr-ID-platformFirmwareSignatureVerification"
#define NID_tcg_tr_ID_platformFirmwareCapabilities 1406
#define LN_tcg_tr_ID_platformFirmwareCapabilities "Platform Firmware Capabilities Trait"
#define SN_tcg_tr_ID_platformFirmwareCapabilities "tcg-tr-ID-platformFirmwareCapabilities"
#define NID_tcg_tr_ID_PEN 1405
#define LN_tcg_tr_ID_PEN "Private Enterprise Number Trait"
#define SN_tcg_tr_ID_PEN "tcg-tr-ID-PEN"
#define NID_tcg_tr_ID_OID 1404
#define LN_tcg_tr_ID_OID "Object Identifier Trait"
#define SN_tcg_tr_ID_OID "tcg-tr-ID-OID"
#define NID_tcg_tr_ID_networkMAC 1403
#define LN_tcg_tr_ID_networkMAC "Network MAC Trait"
#define SN_tcg_tr_ID_networkMAC "tcg-tr-ID-networkMAC"
#define NID_tcg_tr_ID_ISO9000Level 1402
#define LN_tcg_tr_ID_ISO9000Level "ISO 9000 Level Trait"
#define SN_tcg_tr_ID_ISO9000Level "tcg-tr-ID-ISO9000Level"
#define NID_tcg_tr_ID_FIPSLevel 1401
#define LN_tcg_tr_ID_FIPSLevel "FIPS Level Trait"
#define SN_tcg_tr_ID_FIPSLevel "tcg-tr-ID-FIPSLevel"
#define NID_tcg_tr_ID_componentIdentifierV11 1400
#define LN_tcg_tr_ID_componentIdentifierV11 "Component Identifier V1.1 Trait"
#define SN_tcg_tr_ID_componentIdentifierV11 "tcg-tr-ID-componentIdentifierV11"
#define NID_tcg_tr_ID_componentClass 1399
#define LN_tcg_tr_ID_componentClass "Component Class Trait"
#define SN_tcg_tr_ID_componentClass "tcg-tr-ID-componentClass"
#define NID_tcg_tr_ID_CommonCriteria 1398
#define LN_tcg_tr_ID_CommonCriteria "Common Criteria Trait"
#define SN_tcg_tr_ID_CommonCriteria "tcg-tr-ID-CommonCriteria"
#define NID_tcg_tr_ID_CertificateIdentifier 1397
#define LN_tcg_tr_ID_CertificateIdentifier "Certificate Identifier Trait"
#define SN_tcg_tr_ID_CertificateIdentifier "tcg-tr-ID-CertificateIdentifier"
#define NID_tcg_tr_ID_Boolean 1396
#define LN_tcg_tr_ID_Boolean "Boolean Trait"
#define SN_tcg_tr_ID_Boolean "tcg-tr-ID-Boolean"
#define NID_tcg_tr_registry 1395
#define LN_tcg_tr_registry "TCG Trait Registries"
#define SN_tcg_tr_registry "tcg-tr-registry"
#define NID_tcg_tr_category 1394
#define LN_tcg_tr_category "TCG Trait Categories"
#define SN_tcg_tr_category "tcg-tr-category"
#define NID_tcg_tr_ID 1393
#define LN_tcg_tr_ID "TCG Trait Identifiers"
#define SN_tcg_tr_ID "tcg-tr-ID"
#define NID_tcg_cap_verifiedPlatformCertificate 1392
#define LN_tcg_cap_verifiedPlatformCertificate "TCG Verified Platform Certificate CA Policy"
#define SN_tcg_cap_verifiedPlatformCertificate "tcg-cap-verifiedPlatformCertificate"
#define NID_tcg_registry_componentClass_disk 1391
#define LN_tcg_registry_componentClass_disk "Disk Component Class"
#define SN_tcg_registry_componentClass_disk "tcg-registry-componentClass-disk"
#define NID_tcg_registry_componentClass_pcie 1390
#define LN_tcg_registry_componentClass_pcie "PCIE Component Class"
#define SN_tcg_registry_componentClass_pcie "tcg-registry-componentClass-pcie"
#define NID_tcg_registry_componentClass_dmtf 1389
#define LN_tcg_registry_componentClass_dmtf "Distributed Management Task Force Registry"
#define SN_tcg_registry_componentClass_dmtf "tcg-registry-componentClass-dmtf"
#define NID_tcg_registry_componentClass_ietf 1388
#define LN_tcg_registry_componentClass_ietf "Internet Engineering Task Force Registry"
#define SN_tcg_registry_componentClass_ietf "tcg-registry-componentClass-ietf"
#define NID_tcg_registry_componentClass_tcg 1387
#define LN_tcg_registry_componentClass_tcg "Trusted Computed Group Registry"
#define SN_tcg_registry_componentClass_tcg "tcg-registry-componentClass-tcg"
#define NID_tcg_registry_componentClass 1386
#define LN_tcg_registry_componentClass "TCG Component Class"
#define SN_tcg_registry_componentClass "tcg-registry-componentClass"
#define NID_tcg_address_bluetoothmac 1385
#define LN_tcg_address_bluetoothmac "Bluetooth MAC Address"
#define SN_tcg_address_bluetoothmac "tcg-address-bluetoothmac"
#define NID_tcg_address_wlanmac 1384
#define LN_tcg_address_wlanmac "WLAN MAC Address"
#define SN_tcg_address_wlanmac "tcg-address-wlanmac"
#define NID_tcg_address_ethernetmac 1383
#define LN_tcg_address_ethernetmac "Ethernet MAC Address"
#define SN_tcg_address_ethernetmac "tcg-address-ethernetmac"
#define NID_tcg_prt_tpmIdProtocol 1382
#define LN_tcg_prt_tpmIdProtocol "TCG TPM Protocol"
#define SN_tcg_prt_tpmIdProtocol "tcg-prt-tpmIdProtocol"
#define NID_tcg_ce_virtualPlatformBackupService 1381
#define LN_tcg_ce_virtualPlatformBackupService "Virtual Platform Backup Service"
#define SN_tcg_ce_virtualPlatformBackupService "tcg-ce-virtualPlatformBackupService"
#define NID_tcg_ce_migrationControllerRegistrationService 1380
#define LN_tcg_ce_migrationControllerRegistrationService "Migration Controller Registration Service"
#define SN_tcg_ce_migrationControllerRegistrationService "tcg-ce-migrationControllerRegistrationService"
#define NID_tcg_ce_migrationControllerAttestationService 1379
#define LN_tcg_ce_migrationControllerAttestationService "Migration Controller Attestation Service"
#define SN_tcg_ce_migrationControllerAttestationService "tcg-ce-migrationControllerAttestationService"
#define NID_tcg_ce_virtualPlatformAttestationService 1378
#define LN_tcg_ce_virtualPlatformAttestationService "Virtual Platform Attestation Service"
#define SN_tcg_ce_virtualPlatformAttestationService "tcg-ce-virtualPlatformAttestationService"
#define NID_tcg_ce_relevantManifests 1377
#define LN_tcg_ce_relevantManifests "Relevant Manifests"
#define SN_tcg_ce_relevantManifests "tcg-ce-relevantManifests"
#define NID_tcg_ce_relevantCredentials 1376
#define LN_tcg_ce_relevantCredentials "Relevant Credentials"
#define SN_tcg_ce_relevantCredentials "tcg-ce-relevantCredentials"
#define NID_tcg_kp_AdditionalPlatformKeyCertificate 1375
#define LN_tcg_kp_AdditionalPlatformKeyCertificate "Additional Platform Key Certificate"
#define SN_tcg_kp_AdditionalPlatformKeyCertificate "tcg-kp-AdditionalPlatformKeyCertificate"
#define NID_tcg_kp_AdditionalPlatformAttributeCertificate 1374
#define LN_tcg_kp_AdditionalPlatformAttributeCertificate "Additional Platform Attribute Certificate"
#define SN_tcg_kp_AdditionalPlatformAttributeCertificate "tcg-kp-AdditionalPlatformAttributeCertificate"
#define NID_tcg_kp_DeltaPlatformKeyCertificate 1373
#define LN_tcg_kp_DeltaPlatformKeyCertificate "Delta Platform Key Certificate"
#define SN_tcg_kp_DeltaPlatformKeyCertificate "tcg-kp-DeltaPlatformKeyCertificate"
#define NID_tcg_kp_DeltaPlatformAttributeCertificate 1372
#define LN_tcg_kp_DeltaPlatformAttributeCertificate "Delta Platform Attribute Certificate"
#define SN_tcg_kp_DeltaPlatformAttributeCertificate "tcg-kp-DeltaPlatformAttributeCertificate"
#define NID_tcg_kp_PlatformKeyCertificate 1371
#define LN_tcg_kp_PlatformKeyCertificate "Platform Key Certificate"
#define SN_tcg_kp_PlatformKeyCertificate "tcg-kp-PlatformKeyCertificate"
#define NID_tcg_kp_AIKCertificate 1370
#define LN_tcg_kp_AIKCertificate "Attestation Identity Key Certificate"
#define SN_tcg_kp_AIKCertificate "tcg-kp-AIKCertificate"
#define NID_tcg_kp_PlatformAttributeCertificate 1369
#define LN_tcg_kp_PlatformAttributeCertificate "Platform Attribute Certificate"
#define SN_tcg_kp_PlatformAttributeCertificate "tcg-kp-PlatformAttributeCertificate"
#define NID_tcg_kp_EKCertificate 1368
#define LN_tcg_kp_EKCertificate "Endorsement Key Certificate"
#define SN_tcg_kp_EKCertificate "tcg-kp-EKCertificate"
#define NID_tcg_algorithm_null 1367
#define LN_tcg_algorithm_null "TCG NULL Algorithm"
#define SN_tcg_algorithm_null "tcg-algorithm-null"
#define NID_tcg_at_platformConfigUri_v3 1366
#define LN_tcg_at_platformConfigUri_v3 "Platform Configuration URI Version 3"
#define SN_tcg_at_platformConfigUri_v3 "tcg-at-platformConfigUri-v3"
#define NID_tcg_at_platformConfiguration_v3 1365
#define LN_tcg_at_platformConfiguration_v3 "Platform Configuration Version 3"
#define SN_tcg_at_platformConfiguration_v3 "tcg-at-platformConfiguration-v3"
#define NID_tcg_at_platformConfiguration_v2 1364
#define LN_tcg_at_platformConfiguration_v2 "Platform Configuration Version 2"
#define SN_tcg_at_platformConfiguration_v2 "tcg-at-platformConfiguration-v2"
#define NID_tcg_at_platformConfiguration_v1 1363
#define LN_tcg_at_platformConfiguration_v1 "Platform Configuration Version 1"
#define SN_tcg_at_platformConfiguration_v1 "tcg-at-platformConfiguration-v1"
#define NID_tcg_at_cryptographicAnchors 1362
#define LN_tcg_at_cryptographicAnchors "TCG Cryptographic Anchors"
#define SN_tcg_at_cryptographicAnchors "tcg-at-cryptographicAnchors"
#define NID_tcg_at_tbbSecurityAssertions_v3 1361
#define LN_tcg_at_tbbSecurityAssertions_v3 "TCG TBB Security Assertions V3"
#define SN_tcg_at_tbbSecurityAssertions_v3 "tcg-at-tbbSecurityAssertions-v3"
#define NID_tcg_at_previousPlatformCertificates 1360
#define LN_tcg_at_previousPlatformCertificates "TCG Previous Platform Certificates"
#define SN_tcg_at_previousPlatformCertificates "tcg-at-previousPlatformCertificates"
#define NID_tcg_at_tcgCredentialType 1359
#define LN_tcg_at_tcgCredentialType "TCG Credential Type"
#define SN_tcg_at_tcgCredentialType "tcg-at-tcgCredentialType"
#define NID_tcg_at_tcgCredentialSpecification 1358
#define LN_tcg_at_tcgCredentialSpecification "TCG Credential Specification"
#define SN_tcg_at_tcgCredentialSpecification "tcg-at-tcgCredentialSpecification"
#define NID_tcg_at_tbbSecurityAssertions 1357
#define LN_tcg_at_tbbSecurityAssertions "TBB Security Assertions"
#define SN_tcg_at_tbbSecurityAssertions "tcg-at-tbbSecurityAssertions"
#define NID_tcg_at_tpmSecurityAssertions 1356
#define LN_tcg_at_tpmSecurityAssertions "TPM Security Assertions"
#define SN_tcg_at_tpmSecurityAssertions "tcg-at-tpmSecurityAssertions"
#define NID_tcg_at_tcgPlatformSpecification 1355
#define LN_tcg_at_tcgPlatformSpecification "TPM Platform Specification"
#define SN_tcg_at_tcgPlatformSpecification "tcg-at-tcgPlatformSpecification"
#define NID_tcg_at_tpmSpecification 1354
#define LN_tcg_at_tpmSpecification "TPM Specification"
#define SN_tcg_at_tpmSpecification "tcg-at-tpmSpecification"
#define NID_tcg_at_tpmIdLabel 1353
#define LN_tcg_at_tpmIdLabel "TPM ID Label"
#define SN_tcg_at_tpmIdLabel "tcg-at-tpmIdLabel"
#define NID_tcg_at_tbbSecurityTarget 1352
#define LN_tcg_at_tbbSecurityTarget "TBB Security Target"
#define SN_tcg_at_tbbSecurityTarget "tcg-at-tbbSecurityTarget"
#define NID_tcg_at_tbbProtectionProfile 1351
#define LN_tcg_at_tbbProtectionProfile "TBB Protection Profile"
#define SN_tcg_at_tbbProtectionProfile "tcg-at-tbbProtectionProfile"
#define NID_tcg_at_tpmSecurityTarget 1350
#define LN_tcg_at_tpmSecurityTarget "TPM Security Target"
#define SN_tcg_at_tpmSecurityTarget "tcg-at-tpmSecurityTarget"
#define NID_tcg_at_tpmProtectionProfile 1349
#define LN_tcg_at_tpmProtectionProfile "TPM Protection Profile"
#define SN_tcg_at_tpmProtectionProfile "tcg-at-tpmProtectionProfile"
#define NID_tcg_at_securityQualities 1348
#define LN_tcg_at_securityQualities "Security Qualities"
#define SN_tcg_at_securityQualities "tcg-at-securityQualities"
#define NID_tcg_at_tpmVersion 1347
#define LN_tcg_at_tpmVersion "TPM Version"
#define SN_tcg_at_tpmVersion "tcg-at-tpmVersion"
#define NID_tcg_at_tpmModel 1346
#define LN_tcg_at_tpmModel "TPM Model"
#define SN_tcg_at_tpmModel "tcg-at-tpmModel"
#define NID_tcg_at_tpmManufacturer 1345
#define LN_tcg_at_tpmManufacturer "TPM Manufacturer"
#define SN_tcg_at_tpmManufacturer "tcg-at-tpmManufacturer"
#define NID_tcg_at_platformIdentifier 1344
#define LN_tcg_at_platformIdentifier "TCG Platform Identifier"
#define SN_tcg_at_platformIdentifier "tcg-at-platformIdentifier"
#define NID_tcg_at_platformConfiguration 1343
#define LN_tcg_at_platformConfiguration "TCG Platform Configuration"
#define SN_tcg_at_platformConfiguration "tcg-at-platformConfiguration"
#define NID_tcg_at_platformSerial 1342
#define LN_tcg_at_platformSerial "TCG Platform Serial Number"
#define SN_tcg_at_platformSerial "tcg-at-platformSerial"
#define NID_tcg_at_platformVersion 1341
#define LN_tcg_at_platformVersion "TCG Platform Version"
#define SN_tcg_at_platformVersion "tcg-at-platformVersion"
#define NID_tcg_at_platformModel 1340
#define LN_tcg_at_platformModel "TCG Platform Model"
#define SN_tcg_at_platformModel "tcg-at-platformModel"
#define NID_tcg_at_platformConfigUri 1339
#define LN_tcg_at_platformConfigUri "TCG Platform Configuration URI"
#define SN_tcg_at_platformConfigUri "tcg-at-platformConfigUri"
#define NID_tcg_at_platformManufacturerId 1338
#define LN_tcg_at_platformManufacturerId "TCG Platform Manufacturer ID"
#define SN_tcg_at_platformManufacturerId "tcg-at-platformManufacturerId"
#define NID_tcg_at_platformManufacturerStr 1337
#define LN_tcg_at_platformManufacturerStr "TCG Platform Manufacturer String"
#define SN_tcg_at_platformManufacturerStr "tcg-at-platformManufacturerStr"
#define NID_tcg_common 1336
#define LN_tcg_common "Trusted Computing Group Common"
#define SN_tcg_common "tcg-common"
#define NID_tcg_traits 1335
#define LN_tcg_traits "Trusted Computing Group Traits"
#define SN_tcg_traits "tcg-traits"
#define NID_tcg_registry 1334
#define LN_tcg_registry "Trusted Computing Group Registry"
#define SN_tcg_registry "tcg-registry"
#define NID_tcg_address 1333
#define LN_tcg_address "Trusted Computing Group Address Formats"
#define SN_tcg_address "tcg-address"
#define NID_tcg_ca 1332
#define LN_tcg_ca "Trusted Computing Group Certificate Policies"
#define SN_tcg_ca "tcg-ca"
#define NID_tcg_kp 1331
#define LN_tcg_kp "Trusted Computing Group Key Purposes"
#define SN_tcg_kp "tcg-kp"
#define NID_tcg_ce 1330
#define LN_tcg_ce "Trusted Computing Group Certificate Extensions"
#define SN_tcg_ce "tcg-ce"
#define NID_tcg_platformClass 1329
#define LN_tcg_platformClass "Trusted Computing Group Platform Classes"
#define SN_tcg_platformClass "tcg-platformClass"
#define NID_tcg_algorithm 1328
#define LN_tcg_algorithm "Trusted Computing Group Algorithms"
#define SN_tcg_algorithm "tcg-algorithm"
#define NID_tcg_protocol 1327
#define LN_tcg_protocol "Trusted Computing Group Protocols"
#define SN_tcg_protocol "tcg-protocol"
#define NID_tcg_attribute 1326
#define LN_tcg_attribute "Trusted Computing Group Attributes"
#define SN_tcg_attribute "tcg-attribute"
#define NID_tcg_tcpaSpecVersion 1325
#define SN_tcg_tcpaSpecVersion "tcg-tcpaSpecVersion"
#define NID_tcg 1324
#define LN_tcg "Trusted Computing Group"
#define SN_tcg "tcg"
#define NID_zstd 1289
#define LN_zstd "Zstandard compression"
#define SN_zstd "zstd"
#define NID_brotli 1288
#define LN_brotli "Brotli compression"
#define SN_brotli "brotli"
#define NID_oracle_jdk_trustedkeyusage 1283
#define LN_oracle_jdk_trustedkeyusage "Trusted key usage (Oracle)"
#define SN_oracle_jdk_trustedkeyusage "oracle-jdk-trustedkeyusage"
#define NID_oracle 1282
#define LN_oracle "Oracle organization"
#define SN_oracle "oracle-organization"
#define NID_aes_256_siv 1200
#define LN_aes_256_siv "aes-256-siv"
#define SN_aes_256_siv "AES-256-SIV"
#define NID_aes_192_siv 1199
#define LN_aes_192_siv "aes-192-siv"
#define SN_aes_192_siv "AES-192-SIV"
#define NID_aes_128_siv 1198
#define LN_aes_128_siv "aes-128-siv"
#define SN_aes_128_siv "AES-128-SIV"
#define NID_uacurve9 1169
#define LN_uacurve9 "DSTU curve 9"
#define SN_uacurve9 "uacurve9"
#define NID_uacurve8 1168
#define LN_uacurve8 "DSTU curve 8"
#define SN_uacurve8 "uacurve8"
#define NID_uacurve7 1167
#define LN_uacurve7 "DSTU curve 7"
#define SN_uacurve7 "uacurve7"
#define NID_uacurve6 1166
#define LN_uacurve6 "DSTU curve 6"
#define SN_uacurve6 "uacurve6"
#define NID_uacurve5 1165
#define LN_uacurve5 "DSTU curve 5"
#define SN_uacurve5 "uacurve5"
#define NID_uacurve4 1164
#define LN_uacurve4 "DSTU curve 4"
#define SN_uacurve4 "uacurve4"
#define NID_uacurve3 1163
#define LN_uacurve3 "DSTU curve 3"
#define SN_uacurve3 "uacurve3"
#define NID_uacurve2 1162
#define LN_uacurve2 "DSTU curve 2"
#define SN_uacurve2 "uacurve2"
#define NID_uacurve1 1161
#define LN_uacurve1 "DSTU curve 1"
#define SN_uacurve1 "uacurve1"
#define NID_uacurve0 1160
#define LN_uacurve0 "DSTU curve 0"
#define SN_uacurve0 "uacurve0"
#define NID_dstu4145be 1159
#define LN_dstu4145be "DSTU 4145-2002 big endian"
#define SN_dstu4145be "dstu4145be"
#define NID_dstu4145le 1158
#define LN_dstu4145le "DSTU 4145-2002 little endian"
#define SN_dstu4145le "dstu4145le"
#define NID_dstu34311 1157
#define LN_dstu34311 "DSTU Gost 34311-95"
#define SN_dstu34311 "dstu34311"
#define NID_hmacWithDstu34311 1156
#define LN_hmacWithDstu34311 "HMAC DSTU Gost 34311-95"
#define SN_hmacWithDstu34311 "hmacWithDstu34311"
#define NID_dstu28147_wrap 1155
#define LN_dstu28147_wrap "DSTU Gost 28147-2009 key wrap"
#define SN_dstu28147_wrap "dstu28147-wrap"
#define NID_dstu28147_cfb 1154
#define LN_dstu28147_cfb "DSTU Gost 28147-2009 CFB mode"
#define SN_dstu28147_cfb "dstu28147-cfb"
#define NID_dstu28147_ofb 1153
#define LN_dstu28147_ofb "DSTU Gost 28147-2009 OFB mode"
#define SN_dstu28147_ofb "dstu28147-ofb"
#define NID_dstu28147 1152
#define LN_dstu28147 "DSTU Gost 28147-2009"
#define SN_dstu28147 "dstu28147"
#define NID_ua_pki 1151
#define SN_ua_pki "ua-pki"
#define NID_ISO_UA 1150
#define SN_ISO_UA "ISO-UA"
#define NID_modp_8192 1217
#define SN_modp_8192 "modp_8192"
#define NID_modp_6144 1216
#define SN_modp_6144 "modp_6144"
#define NID_modp_4096 1215
#define SN_modp_4096 "modp_4096"
#define NID_modp_3072 1214
#define SN_modp_3072 "modp_3072"
#define NID_modp_2048 1213
#define SN_modp_2048 "modp_2048"
#define NID_modp_1536 1212
#define SN_modp_1536 "modp_1536"
#define NID_ffdhe8192 1130
#define SN_ffdhe8192 "ffdhe8192"
#define NID_ffdhe6144 1129
#define SN_ffdhe6144 "ffdhe6144"
#define NID_ffdhe4096 1128
#define SN_ffdhe4096 "ffdhe4096"
#define NID_ffdhe3072 1127
#define SN_ffdhe3072 "ffdhe3072"
#define NID_ffdhe2048 1126
#define SN_ffdhe2048 "ffdhe2048"
#define NID_siphash 1062
#define LN_siphash "siphash"
#define SN_siphash "SipHash"
#define NID_poly1305 1061
#define LN_poly1305 "poly1305"
#define SN_poly1305 "Poly1305"
#define NID_auth_any 1064
#define LN_auth_any "auth-any"
#define SN_auth_any "AuthANY"
#define NID_auth_null 1053
#define LN_auth_null "auth-null"
#define SN_auth_null "AuthNULL"
#define NID_auth_srp 1052
#define LN_auth_srp "auth-srp"
#define SN_auth_srp "AuthSRP"
#define NID_auth_gost12 1051
#define LN_auth_gost12 "auth-gost12"
#define SN_auth_gost12 "AuthGOST12"
#define NID_auth_gost01 1050
#define LN_auth_gost01 "auth-gost01"
#define SN_auth_gost01 "AuthGOST01"
#define NID_auth_dss 1049
#define LN_auth_dss "auth-dss"
#define SN_auth_dss "AuthDSS"
#define NID_auth_psk 1048
#define LN_auth_psk "auth-psk"
#define SN_auth_psk "AuthPSK"
#define NID_auth_ecdsa 1047
#define LN_auth_ecdsa "auth-ecdsa"
#define SN_auth_ecdsa "AuthECDSA"
#define NID_auth_rsa 1046
#define LN_auth_rsa "auth-rsa"
#define SN_auth_rsa "AuthRSA"
#define NID_kx_any 1063
#define LN_kx_any "kx-any"
#define SN_kx_any "KxANY"
#define NID_kx_gost18 1218
#define LN_kx_gost18 "kx-gost18"
#define SN_kx_gost18 "KxGOST18"
#define NID_kx_gost 1045
#define LN_kx_gost "kx-gost"
#define SN_kx_gost "KxGOST"
#define NID_kx_srp 1044
#define LN_kx_srp "kx-srp"
#define SN_kx_srp "KxSRP"
#define NID_kx_psk 1043
#define LN_kx_psk "kx-psk"
#define SN_kx_psk "KxPSK"
#define NID_kx_rsa_psk 1042
#define LN_kx_rsa_psk "kx-rsa-psk"
#define SN_kx_rsa_psk "KxRSA_PSK"
#define NID_kx_dhe_psk 1041
#define LN_kx_dhe_psk "kx-dhe-psk"
#define SN_kx_dhe_psk "KxDHE-PSK"
#define NID_kx_ecdhe_psk 1040
#define LN_kx_ecdhe_psk "kx-ecdhe-psk"
#define SN_kx_ecdhe_psk "KxECDHE-PSK"
#define NID_kx_dhe 1039
#define LN_kx_dhe "kx-dhe"
#define SN_kx_dhe "KxDHE"
#define NID_kx_ecdhe 1038
#define LN_kx_ecdhe "kx-ecdhe"
#define SN_kx_ecdhe "KxECDHE"
#define NID_kx_rsa 1037
#define LN_kx_rsa "kx-rsa"
#define SN_kx_rsa "KxRSA"
#define SN_ED448 "ED448"
#define SN_ED25519 "ED25519"
#define NID_X448 1035
#define SN_X448 "X448"
#define NID_X25519 1034
#define SN_X25519 "X25519"
#define NID_pkInitKDC 1033
#define LN_pkInitKDC "Signing KDC Response"
#define SN_pkInitKDC "pkInitKDC"
#define NID_pkInitClientAuth 1032
#define LN_pkInitClientAuth "PKINIT Client Auth"
#define SN_pkInitClientAuth "pkInitClientAuth"
#define NID_id_pkinit 1031
#define SN_id_pkinit "id-pkinit"
#define NID_x963kdf 1206
#define LN_x963kdf "x963kdf"
#define SN_x963kdf "X963KDF"
#define NID_x942kdf 1207
#define LN_x942kdf "x942kdf"
#define SN_x942kdf "X942KDF"
#define NID_sskdf 1205
#define LN_sskdf "sskdf"
#define SN_sskdf "SSKDF"
#define NID_sshkdf 1203
#define LN_sshkdf "sshkdf"
#define SN_sshkdf "SSHKDF"
#define NID_hkdf 1036
#define LN_hkdf "hkdf"
#define SN_hkdf "HKDF"
#define NID_tls1_prf 1021
#define LN_tls1_prf "tls1-prf"
#define SN_tls1_prf "TLS1-PRF"
#define NID_id_scrypt 973
#define LN_id_scrypt "scrypt"
#define SN_id_scrypt "id-scrypt"
#define NID_jurisdictionCountryName 957
#define LN_jurisdictionCountryName "jurisdictionCountryName"
#define SN_jurisdictionCountryName "jurisdictionC"
#define NID_jurisdictionStateOrProvinceName 956
#define LN_jurisdictionStateOrProvinceName "jurisdictionStateOrProvinceName"
#define SN_jurisdictionStateOrProvinceName "jurisdictionST"
#define NID_jurisdictionLocalityName 955
#define LN_jurisdictionLocalityName "jurisdictionLocalityName"
#define SN_jurisdictionLocalityName "jurisdictionL"
#define NID_ct_cert_scts 954
#define LN_ct_cert_scts "CT Certificate SCTs"
#define SN_ct_cert_scts "ct_cert_scts"
#define NID_ct_precert_signer 953
#define LN_ct_precert_signer "CT Precertificate Signer"
#define SN_ct_precert_signer "ct_precert_signer"
#define NID_ct_precert_poison 952
#define LN_ct_precert_poison "CT Precertificate Poison"
#define SN_ct_precert_poison "ct_precert_poison"
#define NID_ct_precert_scts 951
#define LN_ct_precert_scts "CT Precertificate SCTs"
#define SN_ct_precert_scts "ct_precert_scts"
#define NID_dh_cofactor_kdf 947
#define SN_dh_cofactor_kdf "dh-cofactor-kdf"
#define NID_dh_std_kdf 946
#define SN_dh_std_kdf "dh-std-kdf"
#define NID_dhSinglePass_cofactorDH_sha512kdf_scheme 945
#define SN_dhSinglePass_cofactorDH_sha512kdf_scheme "dhSinglePass-cofactorDH-sha512kdf-scheme"
#define NID_dhSinglePass_cofactorDH_sha384kdf_scheme 944
#define SN_dhSinglePass_cofactorDH_sha384kdf_scheme "dhSinglePass-cofactorDH-sha384kdf-scheme"
#define NID_dhSinglePass_cofactorDH_sha256kdf_scheme 943
#define SN_dhSinglePass_cofactorDH_sha256kdf_scheme "dhSinglePass-cofactorDH-sha256kdf-scheme"
#define NID_dhSinglePass_cofactorDH_sha224kdf_scheme 942
#define SN_dhSinglePass_cofactorDH_sha224kdf_scheme "dhSinglePass-cofactorDH-sha224kdf-scheme"
#define NID_dhSinglePass_cofactorDH_sha1kdf_scheme 941
#define SN_dhSinglePass_cofactorDH_sha1kdf_scheme "dhSinglePass-cofactorDH-sha1kdf-scheme"
#define NID_dhSinglePass_stdDH_sha512kdf_scheme 940
#define SN_dhSinglePass_stdDH_sha512kdf_scheme "dhSinglePass-stdDH-sha512kdf-scheme"
#define NID_dhSinglePass_stdDH_sha384kdf_scheme 939
#define SN_dhSinglePass_stdDH_sha384kdf_scheme "dhSinglePass-stdDH-sha384kdf-scheme"
#define NID_dhSinglePass_stdDH_sha256kdf_scheme 938
#define SN_dhSinglePass_stdDH_sha256kdf_scheme "dhSinglePass-stdDH-sha256kdf-scheme"
#define NID_dhSinglePass_stdDH_sha224kdf_scheme 937
#define SN_dhSinglePass_stdDH_sha224kdf_scheme "dhSinglePass-stdDH-sha224kdf-scheme"
#define NID_dhSinglePass_stdDH_sha1kdf_scheme 936
#define SN_dhSinglePass_stdDH_sha1kdf_scheme "dhSinglePass-stdDH-sha1kdf-scheme"
#define NID_brainpoolP512t1 934
#define SN_brainpoolP512t1 "brainpoolP512t1"
#define NID_brainpoolP512r1tls13 1287
#define SN_brainpoolP512r1tls13 "brainpoolP512r1tls13"
#define NID_brainpoolP512r1 933
#define SN_brainpoolP512r1 "brainpoolP512r1"
#define NID_brainpoolP384t1 932
#define SN_brainpoolP384t1 "brainpoolP384t1"
#define NID_brainpoolP384r1tls13 1286
#define SN_brainpoolP384r1tls13 "brainpoolP384r1tls13"
#define NID_brainpoolP384r1 931
#define SN_brainpoolP384r1 "brainpoolP384r1"
#define NID_brainpoolP320t1 930
#define SN_brainpoolP320t1 "brainpoolP320t1"
#define NID_brainpoolP320r1 929
#define SN_brainpoolP320r1 "brainpoolP320r1"
#define NID_brainpoolP256t1 928
#define SN_brainpoolP256t1 "brainpoolP256t1"
#define NID_brainpoolP256r1tls13 1285
#define SN_brainpoolP256r1tls13 "brainpoolP256r1tls13"
#define NID_brainpoolP256r1 927
#define SN_brainpoolP256r1 "brainpoolP256r1"
#define NID_brainpoolP224t1 926
#define SN_brainpoolP224t1 "brainpoolP224t1"
#define NID_brainpoolP224r1 925
#define SN_brainpoolP224r1 "brainpoolP224r1"
#define NID_brainpoolP192t1 924
#define SN_brainpoolP192t1 "brainpoolP192t1"
#define NID_brainpoolP192r1 923
#define SN_brainpoolP192r1 "brainpoolP192r1"
#define NID_brainpoolP160t1 922
#define SN_brainpoolP160t1 "brainpoolP160t1"
#define NID_brainpoolP160r1 921
#define SN_brainpoolP160r1 "brainpoolP160r1"
#define NID_dhpublicnumber 920
#define LN_dhpublicnumber "X9.42 DH"
#define SN_dhpublicnumber "dhpublicnumber"
#define NID_chacha20 1019
#define LN_chacha20 "chacha20"
#define SN_chacha20 "ChaCha20"
#define NID_chacha20_poly1305 1018
#define LN_chacha20_poly1305 "chacha20-poly1305"
#define SN_chacha20_poly1305 "ChaCha20-Poly1305"
#define NID_aes_256_cbc_hmac_sha256 950
#define LN_aes_256_cbc_hmac_sha256 "aes-256-cbc-hmac-sha256"
#define SN_aes_256_cbc_hmac_sha256 "AES-256-CBC-HMAC-SHA256"
#define NID_aes_192_cbc_hmac_sha256 949
#define LN_aes_192_cbc_hmac_sha256 "aes-192-cbc-hmac-sha256"
#define SN_aes_192_cbc_hmac_sha256 "AES-192-CBC-HMAC-SHA256"
#define NID_aes_128_cbc_hmac_sha256 948
#define LN_aes_128_cbc_hmac_sha256 "aes-128-cbc-hmac-sha256"
#define SN_aes_128_cbc_hmac_sha256 "AES-128-CBC-HMAC-SHA256"
#define NID_aes_256_cbc_hmac_sha1 918
#define LN_aes_256_cbc_hmac_sha1 "aes-256-cbc-hmac-sha1"
#define SN_aes_256_cbc_hmac_sha1 "AES-256-CBC-HMAC-SHA1"
#define NID_aes_192_cbc_hmac_sha1 917
#define LN_aes_192_cbc_hmac_sha1 "aes-192-cbc-hmac-sha1"
#define SN_aes_192_cbc_hmac_sha1 "AES-192-CBC-HMAC-SHA1"
#define NID_aes_128_cbc_hmac_sha1 916
#define LN_aes_128_cbc_hmac_sha1 "aes-128-cbc-hmac-sha1"
#define SN_aes_128_cbc_hmac_sha1 "AES-128-CBC-HMAC-SHA1"
#define NID_rc4_hmac_md5 915
#define LN_rc4_hmac_md5 "rc4-hmac-md5"
#define SN_rc4_hmac_md5 "RC4-HMAC-MD5"
#define NID_cmac 894
#define LN_cmac "cmac"
#define SN_cmac "CMAC"
#define LN_hmac "hmac"
#define SN_hmac "HMAC"
#define NID_sm4_xts 1290
#define LN_sm4_xts "sm4-xts"
#define SN_sm4_xts "SM4-XTS"
#define NID_sm4_ccm 1249
#define LN_sm4_ccm "sm4-ccm"
#define SN_sm4_ccm "SM4-CCM"
#define NID_sm4_gcm 1248
#define LN_sm4_gcm "sm4-gcm"
#define SN_sm4_gcm "SM4-GCM"
#define NID_sm4_ctr 1139
#define LN_sm4_ctr "sm4-ctr"
#define SN_sm4_ctr "SM4-CTR"
#define NID_sm4_cfb8 1138
#define LN_sm4_cfb8 "sm4-cfb8"
#define SN_sm4_cfb8 "SM4-CFB8"
#define NID_sm4_cfb1 1136
#define LN_sm4_cfb1 "sm4-cfb1"
#define SN_sm4_cfb1 "SM4-CFB1"
#define NID_sm4_cfb128 1137
#define LN_sm4_cfb128 "sm4-cfb"
#define SN_sm4_cfb128 "SM4-CFB"
#define NID_sm4_ofb128 1135
#define LN_sm4_ofb128 "sm4-ofb"
#define SN_sm4_ofb128 "SM4-OFB"
#define NID_sm4_cbc 1134
#define LN_sm4_cbc "sm4-cbc"
#define SN_sm4_cbc "SM4-CBC"
#define NID_sm4_ecb 1133
#define LN_sm4_ecb "sm4-ecb"
#define SN_sm4_ecb "SM4-ECB"
#define NID_seed_ofb128 778
#define LN_seed_ofb128 "seed-ofb"
#define SN_seed_ofb128 "SEED-OFB"
#define NID_seed_cfb128 779
#define LN_seed_cfb128 "seed-cfb"
#define SN_seed_cfb128 "SEED-CFB"
#define NID_seed_cbc 777
#define LN_seed_cbc "seed-cbc"
#define SN_seed_cbc "SEED-CBC"
#define NID_seed_ecb 776
#define LN_seed_ecb "seed-ecb"
#define SN_seed_ecb "SEED-ECB"
#define NID_kisa 773
#define LN_kisa "kisa"
#define SN_kisa "KISA"
#define NID_aria_256_gcm 1125
#define LN_aria_256_gcm "aria-256-gcm"
#define SN_aria_256_gcm "ARIA-256-GCM"
#define NID_aria_192_gcm 1124
#define LN_aria_192_gcm "aria-192-gcm"
#define SN_aria_192_gcm "ARIA-192-GCM"
#define NID_aria_128_gcm 1123
#define LN_aria_128_gcm "aria-128-gcm"
#define SN_aria_128_gcm "ARIA-128-GCM"
#define NID_aria_256_ccm 1122
#define LN_aria_256_ccm "aria-256-ccm"
#define SN_aria_256_ccm "ARIA-256-CCM"
#define NID_aria_192_ccm 1121
#define LN_aria_192_ccm "aria-192-ccm"
#define SN_aria_192_ccm "ARIA-192-CCM"
#define NID_aria_128_ccm 1120
#define LN_aria_128_ccm "aria-128-ccm"
#define SN_aria_128_ccm "ARIA-128-CCM"
#define NID_aria_256_cfb8 1085
#define LN_aria_256_cfb8 "aria-256-cfb8"
#define SN_aria_256_cfb8 "ARIA-256-CFB8"
#define NID_aria_192_cfb8 1084
#define LN_aria_192_cfb8 "aria-192-cfb8"
#define SN_aria_192_cfb8 "ARIA-192-CFB8"
#define NID_aria_128_cfb8 1083
#define LN_aria_128_cfb8 "aria-128-cfb8"
#define SN_aria_128_cfb8 "ARIA-128-CFB8"
#define NID_aria_256_cfb1 1082
#define LN_aria_256_cfb1 "aria-256-cfb1"
#define SN_aria_256_cfb1 "ARIA-256-CFB1"
#define NID_aria_192_cfb1 1081
#define LN_aria_192_cfb1 "aria-192-cfb1"
#define SN_aria_192_cfb1 "ARIA-192-CFB1"
#define NID_aria_128_cfb1 1080
#define LN_aria_128_cfb1 "aria-128-cfb1"
#define SN_aria_128_cfb1 "ARIA-128-CFB1"
#define NID_aria_256_ctr 1079
#define LN_aria_256_ctr "aria-256-ctr"
#define SN_aria_256_ctr "ARIA-256-CTR"
#define NID_aria_256_ofb128 1078
#define LN_aria_256_ofb128 "aria-256-ofb"
#define SN_aria_256_ofb128 "ARIA-256-OFB"
#define NID_aria_256_cfb128 1077
#define LN_aria_256_cfb128 "aria-256-cfb"
#define SN_aria_256_cfb128 "ARIA-256-CFB"
#define NID_aria_256_cbc 1076
#define LN_aria_256_cbc "aria-256-cbc"
#define SN_aria_256_cbc "ARIA-256-CBC"
#define NID_aria_256_ecb 1075
#define LN_aria_256_ecb "aria-256-ecb"
#define SN_aria_256_ecb "ARIA-256-ECB"
#define NID_aria_192_ctr 1074
#define LN_aria_192_ctr "aria-192-ctr"
#define SN_aria_192_ctr "ARIA-192-CTR"
#define NID_aria_192_ofb128 1073
#define LN_aria_192_ofb128 "aria-192-ofb"
#define SN_aria_192_ofb128 "ARIA-192-OFB"
#define NID_aria_192_cfb128 1072
#define LN_aria_192_cfb128 "aria-192-cfb"
#define SN_aria_192_cfb128 "ARIA-192-CFB"
#define NID_aria_192_cbc 1071
#define LN_aria_192_cbc "aria-192-cbc"
#define SN_aria_192_cbc "ARIA-192-CBC"
#define NID_aria_192_ecb 1070
#define LN_aria_192_ecb "aria-192-ecb"
#define SN_aria_192_ecb "ARIA-192-ECB"
#define NID_aria_128_ctr 1069
#define LN_aria_128_ctr "aria-128-ctr"
#define SN_aria_128_ctr "ARIA-128-CTR"
#define NID_aria_128_ofb128 1068
#define LN_aria_128_ofb128 "aria-128-ofb"
#define SN_aria_128_ofb128 "ARIA-128-OFB"
#define NID_aria_128_cfb128 1067
#define LN_aria_128_cfb128 "aria-128-cfb"
#define SN_aria_128_cfb128 "ARIA-128-CFB"
#define NID_aria_128_cbc 1066
#define LN_aria_128_cbc "aria-128-cbc"
#define SN_aria_128_cbc "ARIA-128-CBC"
#define NID_aria_128_ecb 1065
#define LN_aria_128_ecb "aria-128-ecb"
#define SN_aria_128_ecb "ARIA-128-ECB"
#define NID_camellia_256_cfb8 765
#define LN_camellia_256_cfb8 "camellia-256-cfb8"
#define SN_camellia_256_cfb8 "CAMELLIA-256-CFB8"
#define NID_camellia_192_cfb8 764
#define LN_camellia_192_cfb8 "camellia-192-cfb8"
#define SN_camellia_192_cfb8 "CAMELLIA-192-CFB8"
#define NID_camellia_128_cfb8 763
#define LN_camellia_128_cfb8 "camellia-128-cfb8"
#define SN_camellia_128_cfb8 "CAMELLIA-128-CFB8"
#define NID_camellia_256_cfb1 762
#define LN_camellia_256_cfb1 "camellia-256-cfb1"
#define SN_camellia_256_cfb1 "CAMELLIA-256-CFB1"
#define NID_camellia_192_cfb1 761
#define LN_camellia_192_cfb1 "camellia-192-cfb1"
#define SN_camellia_192_cfb1 "CAMELLIA-192-CFB1"
#define NID_camellia_128_cfb1 760
#define LN_camellia_128_cfb1 "camellia-128-cfb1"
#define SN_camellia_128_cfb1 "CAMELLIA-128-CFB1"
#define NID_camellia_256_cmac 972
#define LN_camellia_256_cmac "camellia-256-cmac"
#define SN_camellia_256_cmac "CAMELLIA-256-CMAC"
#define NID_camellia_256_ctr 971
#define LN_camellia_256_ctr "camellia-256-ctr"
#define SN_camellia_256_ctr "CAMELLIA-256-CTR"
#define NID_camellia_256_ccm 970
#define LN_camellia_256_ccm "camellia-256-ccm"
#define SN_camellia_256_ccm "CAMELLIA-256-CCM"
#define NID_camellia_256_gcm 969
#define LN_camellia_256_gcm "camellia-256-gcm"
#define SN_camellia_256_gcm "CAMELLIA-256-GCM"
#define NID_camellia_256_cfb128 759
#define LN_camellia_256_cfb128 "camellia-256-cfb"
#define SN_camellia_256_cfb128 "CAMELLIA-256-CFB"
#define NID_camellia_256_ofb128 768
#define LN_camellia_256_ofb128 "camellia-256-ofb"
#define SN_camellia_256_ofb128 "CAMELLIA-256-OFB"
#define NID_camellia_256_ecb 756
#define LN_camellia_256_ecb "camellia-256-ecb"
#define SN_camellia_256_ecb "CAMELLIA-256-ECB"
#define NID_camellia_192_cmac 968
#define LN_camellia_192_cmac "camellia-192-cmac"
#define SN_camellia_192_cmac "CAMELLIA-192-CMAC"
#define NID_camellia_192_ctr 967
#define LN_camellia_192_ctr "camellia-192-ctr"
#define SN_camellia_192_ctr "CAMELLIA-192-CTR"
#define NID_camellia_192_ccm 966
#define LN_camellia_192_ccm "camellia-192-ccm"
#define SN_camellia_192_ccm "CAMELLIA-192-CCM"
#define NID_camellia_192_gcm 965
#define LN_camellia_192_gcm "camellia-192-gcm"
#define SN_camellia_192_gcm "CAMELLIA-192-GCM"
#define NID_camellia_192_cfb128 758
#define LN_camellia_192_cfb128 "camellia-192-cfb"
#define SN_camellia_192_cfb128 "CAMELLIA-192-CFB"
#define NID_camellia_192_ofb128 767
#define LN_camellia_192_ofb128 "camellia-192-ofb"
#define SN_camellia_192_ofb128 "CAMELLIA-192-OFB"
#define NID_camellia_192_ecb 755
#define LN_camellia_192_ecb "camellia-192-ecb"
#define SN_camellia_192_ecb "CAMELLIA-192-ECB"
#define NID_camellia_128_cmac 964
#define LN_camellia_128_cmac "camellia-128-cmac"
#define SN_camellia_128_cmac "CAMELLIA-128-CMAC"
#define NID_camellia_128_ctr 963
#define LN_camellia_128_ctr "camellia-128-ctr"
#define SN_camellia_128_ctr "CAMELLIA-128-CTR"
#define NID_camellia_128_ccm 962
#define LN_camellia_128_ccm "camellia-128-ccm"
#define SN_camellia_128_ccm "CAMELLIA-128-CCM"
#define NID_camellia_128_gcm 961
#define LN_camellia_128_gcm "camellia-128-gcm"
#define SN_camellia_128_gcm "CAMELLIA-128-GCM"
#define NID_camellia_128_cfb128 757
#define LN_camellia_128_cfb128 "camellia-128-cfb"
#define SN_camellia_128_cfb128 "CAMELLIA-128-CFB"
#define NID_camellia_128_ofb128 766
#define LN_camellia_128_ofb128 "camellia-128-ofb"
#define SN_camellia_128_ofb128 "CAMELLIA-128-OFB"
#define NID_camellia_128_ecb 754
#define LN_camellia_128_ecb "camellia-128-ecb"
#define SN_camellia_128_ecb "CAMELLIA-128-ECB"
#define NID_id_camellia256_wrap 909
#define SN_id_camellia256_wrap "id-camellia256-wrap"
#define NID_id_camellia192_wrap 908
#define SN_id_camellia192_wrap "id-camellia192-wrap"
#define NID_id_camellia128_wrap 907
#define SN_id_camellia128_wrap "id-camellia128-wrap"
#define NID_camellia_256_cbc 753
#define LN_camellia_256_cbc "camellia-256-cbc"
#define SN_camellia_256_cbc "CAMELLIA-256-CBC"
#define NID_camellia_192_cbc 752
#define LN_camellia_192_cbc "camellia-192-cbc"
#define SN_camellia_192_cbc "CAMELLIA-192-CBC"
#define NID_camellia_128_cbc 751
#define LN_camellia_128_cbc "camellia-128-cbc"
#define SN_camellia_128_cbc "CAMELLIA-128-CBC"
#define NID_magma_mac 1192
#define SN_magma_mac "magma-mac"
#define NID_magma_cfb 1191
#define SN_magma_cfb "magma-cfb"
#define NID_magma_cbc 1190
#define SN_magma_cbc "magma-cbc"
#define NID_magma_ofb 1189
#define SN_magma_ofb "magma-ofb"
#define NID_magma_ctr 1188
#define SN_magma_ctr "magma-ctr"
#define NID_magma_ecb 1187
#define SN_magma_ecb "magma-ecb"
#define NID_kuznyechik_mac 1017
#define SN_kuznyechik_mac "kuznyechik-mac"
#define NID_kuznyechik_cfb 1016
#define SN_kuznyechik_cfb "kuznyechik-cfb"
#define NID_kuznyechik_cbc 1015
#define SN_kuznyechik_cbc "kuznyechik-cbc"
#define NID_kuznyechik_ofb 1014
#define SN_kuznyechik_ofb "kuznyechik-ofb"
#define NID_kuznyechik_ctr 1013
#define SN_kuznyechik_ctr "kuznyechik-ctr"
#define NID_kuznyechik_ecb 1012
#define SN_kuznyechik_ecb "kuznyechik-ecb"
#define NID_classSignToolKA1 1233
#define LN_classSignToolKA1 "Class of Signing Tool KA1"
#define SN_classSignToolKA1 "classSignToolKA1"
#define NID_classSignToolKB2 1232
#define LN_classSignToolKB2 "Class of Signing Tool KB2"
#define SN_classSignToolKB2 "classSignToolKB2"
#define NID_classSignToolKB1 1231
#define LN_classSignToolKB1 "Class of Signing Tool KB1"
#define SN_classSignToolKB1 "classSignToolKB1"
#define NID_classSignToolKC3 1230
#define LN_classSignToolKC3 "Class of Signing Tool KC3"
#define SN_classSignToolKC3 "classSignToolKC3"
#define NID_classSignToolKC2 1229
#define LN_classSignToolKC2 "Class of Signing Tool KC2"
#define SN_classSignToolKC2 "classSignToolKC2"
#define NID_classSignToolKC1 1228
#define LN_classSignToolKC1 "Class of Signing Tool KC1"
#define SN_classSignToolKC1 "classSignToolKC1"
#define NID_classSignTool 1227
#define LN_classSignTool "Class of Signing Tool"
#define SN_classSignTool "classSignTool"
#define NID_issuerSignTool 1008
#define LN_issuerSignTool "Signing Tool of Issuer"
#define SN_issuerSignTool "issuerSignTool"
#define NID_subjectSignTool 1007
#define LN_subjectSignTool "Signing Tool of Subject"
#define SN_subjectSignTool "subjectSignTool"
#define NID_OGRNIP 1226
#define LN_OGRNIP "OGRNIP"
#define SN_OGRNIP "OGRNIP"
#define NID_SNILS 1006
#define LN_SNILS "SNILS"
#define SN_SNILS "SNILS"
#define NID_OGRN 1005
#define LN_OGRN "OGRN"
#define SN_OGRN "OGRN"
#define NID_INN 1004
#define LN_INN "INN"
#define SN_INN "INN"
#define NID_id_tc26_gost_28147_param_Z 1003
#define LN_id_tc26_gost_28147_param_Z "GOST 28147-89 TC26 parameter set"
#define SN_id_tc26_gost_28147_param_Z "id-tc26-gost-28147-param-Z"
#define NID_id_tc26_gost_28147_constants 1002
#define SN_id_tc26_gost_28147_constants "id-tc26-gost-28147-constants"
#define NID_id_tc26_cipher_constants 1001
#define SN_id_tc26_cipher_constants "id-tc26-cipher-constants"
#define NID_id_tc26_digest_constants 1000
#define SN_id_tc26_digest_constants "id-tc26-digest-constants"
#define NID_id_tc26_gost_3410_2012_512_paramSetC 1149
#define LN_id_tc26_gost_3410_2012_512_paramSetC "GOST R 34.10-2012 (512 bit) ParamSet C"
#define SN_id_tc26_gost_3410_2012_512_paramSetC "id-tc26-gost-3410-2012-512-paramSetC"
#define NID_id_tc26_gost_3410_2012_512_paramSetB 999
#define LN_id_tc26_gost_3410_2012_512_paramSetB "GOST R 34.10-2012 (512 bit) ParamSet B"
#define SN_id_tc26_gost_3410_2012_512_paramSetB "id-tc26-gost-3410-2012-512-paramSetB"
#define NID_id_tc26_gost_3410_2012_512_paramSetA 998
#define LN_id_tc26_gost_3410_2012_512_paramSetA "GOST R 34.10-2012 (512 bit) ParamSet A"
#define SN_id_tc26_gost_3410_2012_512_paramSetA "id-tc26-gost-3410-2012-512-paramSetA"
#define NID_id_tc26_gost_3410_2012_512_paramSetTest 997
#define LN_id_tc26_gost_3410_2012_512_paramSetTest "GOST R 34.10-2012 (512 bit) testing parameter set"
#define SN_id_tc26_gost_3410_2012_512_paramSetTest "id-tc26-gost-3410-2012-512-paramSetTest"
#define NID_id_tc26_gost_3410_2012_512_constants 996
#define SN_id_tc26_gost_3410_2012_512_constants "id-tc26-gost-3410-2012-512-constants"
#define NID_id_tc26_gost_3410_2012_256_paramSetD 1186
#define LN_id_tc26_gost_3410_2012_256_paramSetD "GOST R 34.10-2012 (256 bit) ParamSet D"
#define SN_id_tc26_gost_3410_2012_256_paramSetD "id-tc26-gost-3410-2012-256-paramSetD"
#define NID_id_tc26_gost_3410_2012_256_paramSetC 1185
#define LN_id_tc26_gost_3410_2012_256_paramSetC "GOST R 34.10-2012 (256 bit) ParamSet C"
#define SN_id_tc26_gost_3410_2012_256_paramSetC "id-tc26-gost-3410-2012-256-paramSetC"
#define NID_id_tc26_gost_3410_2012_256_paramSetB 1184
#define LN_id_tc26_gost_3410_2012_256_paramSetB "GOST R 34.10-2012 (256 bit) ParamSet B"
#define SN_id_tc26_gost_3410_2012_256_paramSetB "id-tc26-gost-3410-2012-256-paramSetB"
#define NID_id_tc26_gost_3410_2012_256_paramSetA 1148
#define LN_id_tc26_gost_3410_2012_256_paramSetA "GOST R 34.10-2012 (256 bit) ParamSet A"
#define SN_id_tc26_gost_3410_2012_256_paramSetA "id-tc26-gost-3410-2012-256-paramSetA"
#define NID_id_tc26_gost_3410_2012_256_constants 1147
#define SN_id_tc26_gost_3410_2012_256_constants "id-tc26-gost-3410-2012-256-constants"
#define NID_id_tc26_sign_constants 995
#define SN_id_tc26_sign_constants "id-tc26-sign-constants"
#define NID_id_tc26_constants 994
#define SN_id_tc26_constants "id-tc26-constants"
#define NID_kuznyechik_kexp15 1183
#define SN_kuznyechik_kexp15 "kuznyechik-kexp15"
#define NID_id_tc26_wrap_gostr3412_2015_kuznyechik 1182
#define SN_id_tc26_wrap_gostr3412_2015_kuznyechik "id-tc26-wrap-gostr3412-2015-kuznyechik"
#define NID_magma_kexp15 1181
#define SN_magma_kexp15 "magma-kexp15"
#define NID_id_tc26_wrap_gostr3412_2015_magma 1180
#define SN_id_tc26_wrap_gostr3412_2015_magma "id-tc26-wrap-gostr3412-2015-magma"
#define NID_id_tc26_wrap 1179
#define SN_id_tc26_wrap "id-tc26-wrap"
#define NID_id_tc26_agreement_gost_3410_2012_512 993
#define SN_id_tc26_agreement_gost_3410_2012_512 "id-tc26-agreement-gost-3410-2012-512"
#define NID_id_tc26_agreement_gost_3410_2012_256 992
#define SN_id_tc26_agreement_gost_3410_2012_256 "id-tc26-agreement-gost-3410-2012-256"
#define NID_id_tc26_agreement 991
#define SN_id_tc26_agreement "id-tc26-agreement"
#define NID_kuznyechik_ctr_acpkm_omac 1178
#define SN_kuznyechik_ctr_acpkm_omac "kuznyechik-ctr-acpkm-omac"
#define NID_kuznyechik_ctr_acpkm 1177
#define SN_kuznyechik_ctr_acpkm "kuznyechik-ctr-acpkm"
#define NID_id_tc26_cipher_gostr3412_2015_kuznyechik 1176
#define SN_id_tc26_cipher_gostr3412_2015_kuznyechik "id-tc26-cipher-gostr3412-2015-kuznyechik"
#define NID_magma_ctr_acpkm_omac 1175
#define SN_magma_ctr_acpkm_omac "magma-ctr-acpkm-omac"
#define NID_magma_ctr_acpkm 1174
#define SN_magma_ctr_acpkm "magma-ctr-acpkm"
#define NID_id_tc26_cipher_gostr3412_2015_magma 1173
#define SN_id_tc26_cipher_gostr3412_2015_magma "id-tc26-cipher-gostr3412-2015-magma"
#define NID_id_tc26_cipher 990
#define SN_id_tc26_cipher "id-tc26-cipher"
#define NID_id_tc26_hmac_gost_3411_2012_512 989
#define LN_id_tc26_hmac_gost_3411_2012_512 "HMAC GOST 34.11-2012 512 bit"
#define SN_id_tc26_hmac_gost_3411_2012_512 "id-tc26-hmac-gost-3411-2012-512"
#define NID_id_tc26_hmac_gost_3411_2012_256 988
#define LN_id_tc26_hmac_gost_3411_2012_256 "HMAC GOST 34.11-2012 256 bit"
#define SN_id_tc26_hmac_gost_3411_2012_256 "id-tc26-hmac-gost-3411-2012-256"
#define NID_id_tc26_mac 987
#define SN_id_tc26_mac "id-tc26-mac"
#define NID_id_tc26_signwithdigest_gost3410_2012_512 986
#define LN_id_tc26_signwithdigest_gost3410_2012_512 "GOST R 34.10-2012 with GOST R 34.11-2012 (512 bit)"
#define SN_id_tc26_signwithdigest_gost3410_2012_512 "id-tc26-signwithdigest-gost3410-2012-512"
#define NID_id_tc26_signwithdigest_gost3410_2012_256 985
#define LN_id_tc26_signwithdigest_gost3410_2012_256 "GOST R 34.10-2012 with GOST R 34.11-2012 (256 bit)"
#define SN_id_tc26_signwithdigest_gost3410_2012_256 "id-tc26-signwithdigest-gost3410-2012-256"
#define NID_id_tc26_signwithdigest 984
#define SN_id_tc26_signwithdigest "id-tc26-signwithdigest"
#define NID_id_GostR3411_2012_512 983
#define LN_id_GostR3411_2012_512 "GOST R 34.11-2012 with 512 bit hash"
#define SN_id_GostR3411_2012_512 "md_gost12_512"
#define NID_id_GostR3411_2012_256 982
#define LN_id_GostR3411_2012_256 "GOST R 34.11-2012 with 256 bit hash"
#define SN_id_GostR3411_2012_256 "md_gost12_256"
#define NID_id_tc26_digest 981
#define SN_id_tc26_digest "id-tc26-digest"
#define NID_id_GostR3410_2012_512 980
#define LN_id_GostR3410_2012_512 "GOST R 34.10-2012 with 512 bit modulus"
#define SN_id_GostR3410_2012_512 "gost2012_512"
#define NID_id_GostR3410_2012_256 979
#define LN_id_GostR3410_2012_256 "GOST R 34.10-2012 with 256 bit modulus"
#define SN_id_GostR3410_2012_256 "gost2012_256"
#define NID_id_tc26_sign 978
#define SN_id_tc26_sign "id-tc26-sign"
#define NID_id_tc26_algorithms 977
#define SN_id_tc26_algorithms "id-tc26-algorithms"
#define NID_id_GostR3410_2001_ParamSet_cc 854
#define LN_id_GostR3410_2001_ParamSet_cc "GOST R 3410-2001 Parameter Set Cryptocom"
#define SN_id_GostR3410_2001_ParamSet_cc "id-GostR3410-2001-ParamSet-cc"
#define NID_id_GostR3411_94_with_GostR3410_2001_cc 853
#define LN_id_GostR3411_94_with_GostR3410_2001_cc "GOST R 34.11-94 with GOST R 34.10-2001 Cryptocom"
#define SN_id_GostR3411_94_with_GostR3410_2001_cc "id-GostR3411-94-with-GostR3410-2001-cc"
#define NID_id_GostR3411_94_with_GostR3410_94_cc 852
#define LN_id_GostR3411_94_with_GostR3410_94_cc "GOST R 34.11-94 with GOST R 34.10-94 Cryptocom"
#define SN_id_GostR3411_94_with_GostR3410_94_cc "id-GostR3411-94-with-GostR3410-94-cc"
#define NID_id_GostR3410_2001_cc 851
#define LN_id_GostR3410_2001_cc "GOST 34.10-2001 Cryptocom"
#define SN_id_GostR3410_2001_cc "gost2001cc"
#define NID_id_GostR3410_94_cc 850
#define LN_id_GostR3410_94_cc "GOST 34.10-94 Cryptocom"
#define SN_id_GostR3410_94_cc "gost94cc"
#define NID_id_Gost28147_89_cc 849
#define LN_id_Gost28147_89_cc "GOST 28147-89 Cryptocom ParamSet"
#define SN_id_Gost28147_89_cc "id-Gost28147-89-cc"
#define NID_id_GostR3410_94_bBis 848
#define SN_id_GostR3410_94_bBis "id-GostR3410-94-bBis"
#define NID_id_GostR3410_94_b 847
#define SN_id_GostR3410_94_b "id-GostR3410-94-b"
#define NID_id_GostR3410_94_aBis 846
#define SN_id_GostR3410_94_aBis "id-GostR3410-94-aBis"
#define NID_id_GostR3410_94_a 845
#define SN_id_GostR3410_94_a "id-GostR3410-94-a"
#define NID_id_GostR3410_2001_CryptoPro_XchB_ParamSet 844
#define SN_id_GostR3410_2001_CryptoPro_XchB_ParamSet "id-GostR3410-2001-CryptoPro-XchB-ParamSet"
#define NID_id_GostR3410_2001_CryptoPro_XchA_ParamSet 843
#define SN_id_GostR3410_2001_CryptoPro_XchA_ParamSet "id-GostR3410-2001-CryptoPro-XchA-ParamSet"
#define NID_id_GostR3410_2001_CryptoPro_C_ParamSet 842
#define SN_id_GostR3410_2001_CryptoPro_C_ParamSet "id-GostR3410-2001-CryptoPro-C-ParamSet"
#define NID_id_GostR3410_2001_CryptoPro_B_ParamSet 841
#define SN_id_GostR3410_2001_CryptoPro_B_ParamSet "id-GostR3410-2001-CryptoPro-B-ParamSet"
#define NID_id_GostR3410_2001_CryptoPro_A_ParamSet 840
#define SN_id_GostR3410_2001_CryptoPro_A_ParamSet "id-GostR3410-2001-CryptoPro-A-ParamSet"
#define NID_id_GostR3410_2001_TestParamSet 839
#define SN_id_GostR3410_2001_TestParamSet "id-GostR3410-2001-TestParamSet"
#define NID_id_GostR3410_94_CryptoPro_XchC_ParamSet 838
#define SN_id_GostR3410_94_CryptoPro_XchC_ParamSet "id-GostR3410-94-CryptoPro-XchC-ParamSet"
#define NID_id_GostR3410_94_CryptoPro_XchB_ParamSet 837
#define SN_id_GostR3410_94_CryptoPro_XchB_ParamSet "id-GostR3410-94-CryptoPro-XchB-ParamSet"
#define NID_id_GostR3410_94_CryptoPro_XchA_ParamSet 836
#define SN_id_GostR3410_94_CryptoPro_XchA_ParamSet "id-GostR3410-94-CryptoPro-XchA-ParamSet"
#define NID_id_GostR3410_94_CryptoPro_D_ParamSet 835
#define SN_id_GostR3410_94_CryptoPro_D_ParamSet "id-GostR3410-94-CryptoPro-D-ParamSet"
#define NID_id_GostR3410_94_CryptoPro_C_ParamSet 834
#define SN_id_GostR3410_94_CryptoPro_C_ParamSet "id-GostR3410-94-CryptoPro-C-ParamSet"
#define NID_id_GostR3410_94_CryptoPro_B_ParamSet 833
#define SN_id_GostR3410_94_CryptoPro_B_ParamSet "id-GostR3410-94-CryptoPro-B-ParamSet"
#define NID_id_GostR3410_94_CryptoPro_A_ParamSet 832
#define SN_id_GostR3410_94_CryptoPro_A_ParamSet "id-GostR3410-94-CryptoPro-A-ParamSet"
#define NID_id_GostR3410_94_TestParamSet 831
#define SN_id_GostR3410_94_TestParamSet "id-GostR3410-94-TestParamSet"
#define NID_id_Gost28147_89_CryptoPro_RIC_1_ParamSet 830
#define SN_id_Gost28147_89_CryptoPro_RIC_1_ParamSet "id-Gost28147-89-CryptoPro-RIC-1-ParamSet"
#define NID_id_Gost28147_89_CryptoPro_Oscar_1_0_ParamSet 829
#define SN_id_Gost28147_89_CryptoPro_Oscar_1_0_ParamSet "id-Gost28147-89-CryptoPro-Oscar-1-0-ParamSet"
#define NID_id_Gost28147_89_CryptoPro_Oscar_1_1_ParamSet 828
#define SN_id_Gost28147_89_CryptoPro_Oscar_1_1_ParamSet "id-Gost28147-89-CryptoPro-Oscar-1-1-ParamSet"
#define NID_id_Gost28147_89_CryptoPro_D_ParamSet 827
#define SN_id_Gost28147_89_CryptoPro_D_ParamSet "id-Gost28147-89-CryptoPro-D-ParamSet"
#define NID_id_Gost28147_89_CryptoPro_C_ParamSet 826
#define SN_id_Gost28147_89_CryptoPro_C_ParamSet "id-Gost28147-89-CryptoPro-C-ParamSet"
#define NID_id_Gost28147_89_CryptoPro_B_ParamSet 825
#define SN_id_Gost28147_89_CryptoPro_B_ParamSet "id-Gost28147-89-CryptoPro-B-ParamSet"
#define NID_id_Gost28147_89_CryptoPro_A_ParamSet 824
#define SN_id_Gost28147_89_CryptoPro_A_ParamSet "id-Gost28147-89-CryptoPro-A-ParamSet"
#define NID_id_Gost28147_89_TestParamSet 823
#define SN_id_Gost28147_89_TestParamSet "id-Gost28147-89-TestParamSet"
#define NID_id_GostR3411_94_CryptoProParamSet 822
#define SN_id_GostR3411_94_CryptoProParamSet "id-GostR3411-94-CryptoProParamSet"
#define NID_id_GostR3411_94_TestParamSet 821
#define SN_id_GostR3411_94_TestParamSet "id-GostR3411-94-TestParamSet"
#define NID_id_Gost28147_89_None_KeyMeshing 820
#define SN_id_Gost28147_89_None_KeyMeshing "id-Gost28147-89-None-KeyMeshing"
#define NID_id_Gost28147_89_CryptoPro_KeyMeshing 819
#define SN_id_Gost28147_89_CryptoPro_KeyMeshing "id-Gost28147-89-CryptoPro-KeyMeshing"
#define NID_id_GostR3410_94DH 818
#define LN_id_GostR3410_94DH "GOST R 34.10-94 DH"
#define SN_id_GostR3410_94DH "id-GostR3410-94DH"
#define NID_id_GostR3410_2001DH 817
#define LN_id_GostR3410_2001DH "GOST R 34.10-2001 DH"
#define SN_id_GostR3410_2001DH "id-GostR3410-2001DH"
#define NID_id_GostR3411_94_prf 816
#define LN_id_GostR3411_94_prf "GOST R 34.11-94 PRF"
#define SN_id_GostR3411_94_prf "prf-gostr3411-94"
#define NID_gost_mac_12 976
#define SN_gost_mac_12 "gost-mac-12"
#define NID_id_Gost28147_89_MAC 815
#define LN_id_Gost28147_89_MAC "GOST 28147-89 MAC"
#define SN_id_Gost28147_89_MAC "gost-mac"
#define NID_gost89_ctr 1011
#define SN_gost89_ctr "gost89-ctr"
#define NID_gost89_ecb 1010
#define SN_gost89_ecb "gost89-ecb"
#define NID_gost89_cbc 1009
#define SN_gost89_cbc "gost89-cbc"
#define NID_gost89_cnt_12 975
#define SN_gost89_cnt_12 "gost89-cnt-12"
#define NID_gost89_cnt 814
#define SN_gost89_cnt "gost89-cnt"
#define NID_id_Gost28147_89 813
#define LN_id_Gost28147_89 "GOST 28147-89"
#define SN_id_Gost28147_89 "gost89"
#define NID_id_GostR3410_94 812
#define LN_id_GostR3410_94 "GOST R 34.10-94"
#define SN_id_GostR3410_94 "gost94"
#define NID_id_GostR3410_2001 811
#define LN_id_GostR3410_2001 "GOST R 34.10-2001"
#define SN_id_GostR3410_2001 "gost2001"
#define NID_id_HMACGostR3411_94 810
#define LN_id_HMACGostR3411_94 "HMAC GOST 34.11-94"
#define SN_id_HMACGostR3411_94 "id-HMACGostR3411-94"
#define NID_id_GostR3411_94 809
#define LN_id_GostR3411_94 "GOST R 34.11-94"
#define SN_id_GostR3411_94 "md_gost94"
#define NID_id_GostR3411_94_with_GostR3410_94 808
#define LN_id_GostR3411_94_with_GostR3410_94 "GOST R 34.11-94 with GOST R 34.10-94"
#define SN_id_GostR3411_94_with_GostR3410_94 "id-GostR3411-94-with-GostR3410-94"
#define NID_id_GostR3411_94_with_GostR3410_2001 807
#define LN_id_GostR3411_94_with_GostR3410_2001 "GOST R 34.11-94 with GOST R 34.10-2001"
#define SN_id_GostR3411_94_with_GostR3410_2001 "id-GostR3411-94-with-GostR3410-2001"
#define NID_id_tc26 974
#define SN_id_tc26 "id-tc26"
#define NID_cryptocom 806
#define SN_cryptocom "cryptocom"
#define NID_cryptopro 805
#define SN_cryptopro "cryptopro"
#define NID_whirlpool 804
#define SN_whirlpool "whirlpool"
#define NID_ipsec4 750
#define LN_ipsec4 "ipsec4"
#define SN_ipsec4 "Oakley-EC2N-4"
#define NID_ipsec3 749
#define LN_ipsec3 "ipsec3"
#define SN_ipsec3 "Oakley-EC2N-3"
#define NID_rsaOAEPEncryptionSET 644
#define SN_rsaOAEPEncryptionSET "rsaOAEPEncryptionSET"
#define NID_des_cdmf 643
#define LN_des_cdmf "des-cdmf"
#define SN_des_cdmf "DES-CDMF"
#define NID_set_brand_Novus 642
#define SN_set_brand_Novus "set-brand-Novus"
#define NID_set_brand_MasterCard 641
#define SN_set_brand_MasterCard "set-brand-MasterCard"
#define NID_set_brand_Visa 640
#define SN_set_brand_Visa "set-brand-Visa"
#define NID_set_brand_JCB 639
#define SN_set_brand_JCB "set-brand-JCB"
#define NID_set_brand_AmericanExpress 638
#define SN_set_brand_AmericanExpress "set-brand-AmericanExpress"
#define NID_set_brand_Diners 637
#define SN_set_brand_Diners "set-brand-Diners"
#define NID_set_brand_IATA_ATA 636
#define SN_set_brand_IATA_ATA "set-brand-IATA-ATA"
#define NID_setAttr_SecDevSig 635
#define LN_setAttr_SecDevSig "secure device signature"
#define SN_setAttr_SecDevSig "setAttr-SecDevSig"
#define NID_setAttr_TokICCsig 634
#define LN_setAttr_TokICCsig "ICC or token signature"
#define SN_setAttr_TokICCsig "setAttr-TokICCsig"
#define NID_setAttr_T2cleartxt 633
#define LN_setAttr_T2cleartxt "cleartext track 2"
#define SN_setAttr_T2cleartxt "setAttr-T2cleartxt"
#define NID_setAttr_T2Enc 632
#define LN_setAttr_T2Enc "encrypted track 2"
#define SN_setAttr_T2Enc "setAttr-T2Enc"
#define NID_setAttr_GenCryptgrm 631
#define LN_setAttr_GenCryptgrm "generate cryptogram"
#define SN_setAttr_GenCryptgrm "setAttr-GenCryptgrm"
#define NID_setAttr_IssCap_Sig 630
#define SN_setAttr_IssCap_Sig "setAttr-IssCap-Sig"
#define NID_setAttr_IssCap_T2 629
#define SN_setAttr_IssCap_T2 "setAttr-IssCap-T2"
#define NID_setAttr_IssCap_CVM 628
#define SN_setAttr_IssCap_CVM "setAttr-IssCap-CVM"
#define NID_setAttr_Token_B0Prime 627
#define SN_setAttr_Token_B0Prime "setAttr-Token-B0Prime"
#define NID_setAttr_Token_EMV 626
#define SN_setAttr_Token_EMV "setAttr-Token-EMV"
#define NID_set_addPolicy 625
#define SN_set_addPolicy "set-addPolicy"
#define NID_set_rootKeyThumb 624
#define SN_set_rootKeyThumb "set-rootKeyThumb"
#define NID_setAttr_IssCap 623
#define LN_setAttr_IssCap "issuer capabilities"
#define SN_setAttr_IssCap "setAttr-IssCap"
#define NID_setAttr_TokenType 622
#define SN_setAttr_TokenType "setAttr-TokenType"
#define NID_setAttr_PGWYcap 621
#define LN_setAttr_PGWYcap "payment gateway capabilities"
#define SN_setAttr_PGWYcap "setAttr-PGWYcap"
#define NID_setAttr_Cert 620
#define SN_setAttr_Cert "setAttr-Cert"
#define NID_setCext_IssuerCapabilities 619
#define SN_setCext_IssuerCapabilities "setCext-IssuerCapabilities"
#define NID_setCext_TokenType 618
#define SN_setCext_TokenType "setCext-TokenType"
#define NID_setCext_Track2Data 617
#define SN_setCext_Track2Data "setCext-Track2Data"
#define NID_setCext_TokenIdentifier 616
#define SN_setCext_TokenIdentifier "setCext-TokenIdentifier"
#define NID_setCext_PGWYcapabilities 615
#define SN_setCext_PGWYcapabilities "setCext-PGWYcapabilities"
#define NID_setCext_setQualf 614
#define SN_setCext_setQualf "setCext-setQualf"
#define NID_setCext_setExt 613
#define SN_setCext_setExt "setCext-setExt"
#define NID_setCext_tunneling 612
#define SN_setCext_tunneling "setCext-tunneling"
#define NID_setCext_cCertRequired 611
#define SN_setCext_cCertRequired "setCext-cCertRequired"
#define NID_setCext_merchData 610
#define SN_setCext_merchData "setCext-merchData"
#define NID_setCext_certType 609
#define SN_setCext_certType "setCext-certType"
#define NID_setCext_hashedRoot 608
#define SN_setCext_hashedRoot "setCext-hashedRoot"
#define NID_set_policy_root 607
#define SN_set_policy_root "set-policy-root"
#define NID_setext_cv 606
#define LN_setext_cv "additional verification"
#define SN_setext_cv "setext-cv"
#define NID_setext_track2 605
#define SN_setext_track2 "setext-track2"
#define NID_setext_pinAny 604
#define SN_setext_pinAny "setext-pinAny"
#define NID_setext_pinSecure 603
#define SN_setext_pinSecure "setext-pinSecure"
#define NID_setext_miAuth 602
#define LN_setext_miAuth "merchant initiated auth"
#define SN_setext_miAuth "setext-miAuth"
#define NID_setext_genCrypt 601
#define LN_setext_genCrypt "generic cryptogram"
#define SN_setext_genCrypt "setext-genCrypt"
#define NID_setct_BCIDistributionTBS 600
#define SN_setct_BCIDistributionTBS "setct-BCIDistributionTBS"
#define NID_setct_CRLNotificationResTBS 599
#define SN_setct_CRLNotificationResTBS "setct-CRLNotificationResTBS"
#define NID_setct_CRLNotificationTBS 598
#define SN_setct_CRLNotificationTBS "setct-CRLNotificationTBS"
#define NID_setct_CertResTBE 597
#define SN_setct_CertResTBE "setct-CertResTBE"
#define NID_setct_CertReqTBEX 596
#define SN_setct_CertReqTBEX "setct-CertReqTBEX"
#define NID_setct_CertReqTBE 595
#define SN_setct_CertReqTBE "setct-CertReqTBE"
#define NID_setct_RegFormReqTBE 594
#define SN_setct_RegFormReqTBE "setct-RegFormReqTBE"
#define NID_setct_BatchAdminResTBE 593
#define SN_setct_BatchAdminResTBE "setct-BatchAdminResTBE"
#define NID_setct_BatchAdminReqTBE 592
#define SN_setct_BatchAdminReqTBE "setct-BatchAdminReqTBE"
#define NID_setct_CredRevResTBE 591
#define SN_setct_CredRevResTBE "setct-CredRevResTBE"
#define NID_setct_CredRevReqTBEX 590
#define SN_setct_CredRevReqTBEX "setct-CredRevReqTBEX"
#define NID_setct_CredRevReqTBE 589
#define SN_setct_CredRevReqTBE "setct-CredRevReqTBE"
#define NID_setct_CredResTBE 588
#define SN_setct_CredResTBE "setct-CredResTBE"
#define NID_setct_CredReqTBEX 587
#define SN_setct_CredReqTBEX "setct-CredReqTBEX"
#define NID_setct_CredReqTBE 586
#define SN_setct_CredReqTBE "setct-CredReqTBE"
#define NID_setct_CapRevResTBE 585
#define SN_setct_CapRevResTBE "setct-CapRevResTBE"
#define NID_setct_CapRevReqTBEX 584
#define SN_setct_CapRevReqTBEX "setct-CapRevReqTBEX"
#define NID_setct_CapRevReqTBE 583
#define SN_setct_CapRevReqTBE "setct-CapRevReqTBE"
#define NID_setct_CapResTBE 582
#define SN_setct_CapResTBE "setct-CapResTBE"
#define NID_setct_CapReqTBEX 581
#define SN_setct_CapReqTBEX "setct-CapReqTBEX"
#define NID_setct_CapReqTBE 580
#define SN_setct_CapReqTBE "setct-CapReqTBE"
#define NID_setct_AuthRevResTBEB 579
#define SN_setct_AuthRevResTBEB "setct-AuthRevResTBEB"
#define NID_setct_AuthRevResTBE 578
#define SN_setct_AuthRevResTBE "setct-AuthRevResTBE"
#define NID_setct_AuthRevReqTBE 577
#define SN_setct_AuthRevReqTBE "setct-AuthRevReqTBE"
#define NID_setct_AcqCardCodeMsgTBE 576
#define SN_setct_AcqCardCodeMsgTBE "setct-AcqCardCodeMsgTBE"
#define NID_setct_CapTokenTBEX 575
#define SN_setct_CapTokenTBEX "setct-CapTokenTBEX"
#define NID_setct_CapTokenTBE 574
#define SN_setct_CapTokenTBE "setct-CapTokenTBE"
#define NID_setct_AuthTokenTBE 573
#define SN_setct_AuthTokenTBE "setct-AuthTokenTBE"
#define NID_setct_AuthResTBEX 572
#define SN_setct_AuthResTBEX "setct-AuthResTBEX"
#define NID_setct_AuthResTBE 571
#define SN_setct_AuthResTBE "setct-AuthResTBE"
#define NID_setct_AuthReqTBE 570
#define SN_setct_AuthReqTBE "setct-AuthReqTBE"
#define NID_setct_PIUnsignedTBE 569
#define SN_setct_PIUnsignedTBE "setct-PIUnsignedTBE"
#define NID_setct_PIDualSignedTBE 568
#define SN_setct_PIDualSignedTBE "setct-PIDualSignedTBE"
#define NID_setct_ErrorTBS 567
#define SN_setct_ErrorTBS "setct-ErrorTBS"
#define NID_setct_CertInqReqTBS 566
#define SN_setct_CertInqReqTBS "setct-CertInqReqTBS"
#define NID_setct_CertResData 565
#define SN_setct_CertResData "setct-CertResData"
#define NID_setct_CertReqTBS 564
#define SN_setct_CertReqTBS "setct-CertReqTBS"
#define NID_setct_CertReqData 563
#define SN_setct_CertReqData "setct-CertReqData"
#define NID_setct_RegFormResTBS 562
#define SN_setct_RegFormResTBS "setct-RegFormResTBS"
#define NID_setct_MeAqCInitResTBS 561
#define SN_setct_MeAqCInitResTBS "setct-MeAqCInitResTBS"
#define NID_setct_CardCInitResTBS 560
#define SN_setct_CardCInitResTBS "setct-CardCInitResTBS"
#define NID_setct_BatchAdminResData 559
#define SN_setct_BatchAdminResData "setct-BatchAdminResData"
#define NID_setct_BatchAdminReqData 558
#define SN_setct_BatchAdminReqData "setct-BatchAdminReqData"
#define NID_setct_PCertResTBS 557
#define SN_setct_PCertResTBS "setct-PCertResTBS"
#define NID_setct_PCertReqData 556
#define SN_setct_PCertReqData "setct-PCertReqData"
#define NID_setct_CredRevResData 555
#define SN_setct_CredRevResData "setct-CredRevResData"
#define NID_setct_CredRevReqTBSX 554
#define SN_setct_CredRevReqTBSX "setct-CredRevReqTBSX"
#define NID_setct_CredRevReqTBS 553
#define SN_setct_CredRevReqTBS "setct-CredRevReqTBS"
#define NID_setct_CredResData 552
#define SN_setct_CredResData "setct-CredResData"
#define NID_setct_CredReqTBSX 551
#define SN_setct_CredReqTBSX "setct-CredReqTBSX"
#define NID_setct_CredReqTBS 550
#define SN_setct_CredReqTBS "setct-CredReqTBS"
#define NID_setct_CapRevResData 549
#define SN_setct_CapRevResData "setct-CapRevResData"
#define NID_setct_CapRevReqTBSX 548
#define SN_setct_CapRevReqTBSX "setct-CapRevReqTBSX"
#define NID_setct_CapRevReqTBS 547
#define SN_setct_CapRevReqTBS "setct-CapRevReqTBS"
#define NID_setct_CapResData 546
#define SN_setct_CapResData "setct-CapResData"
#define NID_setct_CapReqTBSX 545
#define SN_setct_CapReqTBSX "setct-CapReqTBSX"
#define NID_setct_CapReqTBS 544
#define SN_setct_CapReqTBS "setct-CapReqTBS"
#define NID_setct_AuthRevResTBS 543
#define SN_setct_AuthRevResTBS "setct-AuthRevResTBS"
#define NID_setct_AuthRevResData 542
#define SN_setct_AuthRevResData "setct-AuthRevResData"
#define NID_setct_AuthRevReqTBS 541
#define SN_setct_AuthRevReqTBS "setct-AuthRevReqTBS"
#define NID_setct_AcqCardCodeMsg 540
#define SN_setct_AcqCardCodeMsg "setct-AcqCardCodeMsg"
#define NID_setct_CapTokenTBS 539
#define SN_setct_CapTokenTBS "setct-CapTokenTBS"
#define NID_setct_CapTokenData 538
#define SN_setct_CapTokenData "setct-CapTokenData"
#define NID_setct_AuthTokenTBS 537
#define SN_setct_AuthTokenTBS "setct-AuthTokenTBS"
#define NID_setct_AuthResTBSX 536
#define SN_setct_AuthResTBSX "setct-AuthResTBSX"
#define NID_setct_AuthResTBS 535
#define SN_setct_AuthResTBS "setct-AuthResTBS"
#define NID_setct_AuthReqTBS 534
#define SN_setct_AuthReqTBS "setct-AuthReqTBS"
#define NID_setct_PResData 533
#define SN_setct_PResData "setct-PResData"
#define NID_setct_PI_TBS 532
#define SN_setct_PI_TBS "setct-PI-TBS"
#define NID_setct_PInitResData 531
#define SN_setct_PInitResData "setct-PInitResData"
#define NID_setct_CapTokenSeq 530
#define SN_setct_CapTokenSeq "setct-CapTokenSeq"
#define NID_setct_AuthRevResBaggage 529
#define SN_setct_AuthRevResBaggage "setct-AuthRevResBaggage"
#define NID_setct_AuthRevReqBaggage 528
#define SN_setct_AuthRevReqBaggage "setct-AuthRevReqBaggage"
#define NID_setct_AuthResBaggage 527
#define SN_setct_AuthResBaggage "setct-AuthResBaggage"
#define NID_setct_HODInput 526
#define SN_setct_HODInput "setct-HODInput"
#define NID_setct_PIDataUnsigned 525
#define SN_setct_PIDataUnsigned "setct-PIDataUnsigned"
#define NID_setct_PIData 524
#define SN_setct_PIData "setct-PIData"
#define NID_setct_PI 523
#define SN_setct_PI "setct-PI"
#define NID_setct_OIData 522
#define SN_setct_OIData "setct-OIData"
#define NID_setct_PANOnly 521
#define SN_setct_PANOnly "setct-PANOnly"
#define NID_setct_PANToken 520
#define SN_setct_PANToken "setct-PANToken"
#define NID_setct_PANData 519
#define SN_setct_PANData "setct-PANData"
#define NID_set_brand 518
#define SN_set_brand "set-brand"
#define NID_set_certExt 517
#define LN_set_certExt "certificate extensions"
#define SN_set_certExt "set-certExt"
#define NID_set_policy 516
#define SN_set_policy "set-policy"
#define NID_set_attr 515
#define SN_set_attr "set-attr"
#define NID_set_msgExt 514
#define LN_set_msgExt "message extensions"
#define SN_set_msgExt "set-msgExt"
#define NID_set_ctype 513
#define LN_set_ctype "content types"
#define SN_set_ctype "set-ctype"
#define NID_id_set 512
#define LN_id_set "Secure Electronic Transactions"
#define SN_id_set "id-set"
#define NID_documentPublisher 502
#define LN_documentPublisher "documentPublisher"
#define NID_audio 501
#define SN_audio "audio"
#define NID_dITRedirect 500
#define LN_dITRedirect "dITRedirect"
#define NID_personalSignature 499
#define LN_personalSignature "personalSignature"
#define NID_subtreeMaximumQuality 498
#define LN_subtreeMaximumQuality "subtreeMaximumQuality"
#define NID_subtreeMinimumQuality 497
#define LN_subtreeMinimumQuality "subtreeMinimumQuality"
#define NID_singleLevelQuality 496
#define LN_singleLevelQuality "singleLevelQuality"
#define NID_dSAQuality 495
#define LN_dSAQuality "dSAQuality"
#define NID_buildingName 494
#define LN_buildingName "buildingName"
#define NID_mailPreferenceOption 493
#define LN_mailPreferenceOption "mailPreferenceOption"
#define NID_janetMailbox 492
#define LN_janetMailbox "janetMailbox"
#define NID_organizationalStatus 491
#define LN_organizationalStatus "organizationalStatus"
#define NID_uniqueIdentifier 102
#define LN_uniqueIdentifier "uniqueIdentifier"
#define SN_uniqueIdentifier "uid"
#define NID_friendlyCountryName 490
#define LN_friendlyCountryName "friendlyCountryName"
#define NID_pagerTelephoneNumber 489
#define LN_pagerTelephoneNumber "pagerTelephoneNumber"
#define NID_mobileTelephoneNumber 488
#define LN_mobileTelephoneNumber "mobileTelephoneNumber"
#define NID_personalTitle 487
#define LN_personalTitle "personalTitle"
#define NID_homePostalAddress 486
#define LN_homePostalAddress "homePostalAddress"
#define NID_associatedName 485
#define LN_associatedName "associatedName"
#define NID_associatedDomain 484
#define LN_associatedDomain "associatedDomain"
#define NID_cNAMERecord 483
#define LN_cNAMERecord "cNAMERecord"
#define NID_sOARecord 482
#define LN_sOARecord "sOARecord"
#define NID_nSRecord 481
#define LN_nSRecord "nSRecord"
#define NID_mXRecord 480
#define LN_mXRecord "mXRecord"
#define NID_pilotAttributeType27 479
#define LN_pilotAttributeType27 "pilotAttributeType27"
#define NID_aRecord 478
#define LN_aRecord "aRecord"
#define NID_domainComponent 391
#define LN_domainComponent "domainComponent"
#define SN_domainComponent "DC"
#define NID_lastModifiedBy 477
#define LN_lastModifiedBy "lastModifiedBy"
#define NID_lastModifiedTime 476
#define LN_lastModifiedTime "lastModifiedTime"
#define NID_otherMailbox 475
#define LN_otherMailbox "otherMailbox"
#define NID_secretary 474
#define SN_secretary "secretary"
#define NID_homeTelephoneNumber 473
#define LN_homeTelephoneNumber "homeTelephoneNumber"
#define NID_documentLocation 472
#define LN_documentLocation "documentLocation"
#define NID_documentAuthor 471
#define LN_documentAuthor "documentAuthor"
#define NID_documentVersion 470
#define LN_documentVersion "documentVersion"
#define NID_documentTitle 469
#define LN_documentTitle "documentTitle"
#define NID_documentIdentifier 468
#define LN_documentIdentifier "documentIdentifier"
#define NID_manager 467
#define SN_manager "manager"
#define NID_host 466
#define SN_host "host"
#define NID_userClass 465
#define LN_userClass "userClass"
#define NID_photo 464
#define SN_photo "photo"
#define NID_roomNumber 463
#define LN_roomNumber "roomNumber"
#define NID_favouriteDrink 462
#define LN_favouriteDrink "favouriteDrink"
#define NID_info 461
#define SN_info "info"
#define NID_rfc822Mailbox 460
#define LN_rfc822Mailbox "rfc822Mailbox"
#define SN_rfc822Mailbox "mail"
#define NID_textEncodedORAddress 459
#define LN_textEncodedORAddress "textEncodedORAddress"
#define NID_userId 458
#define LN_userId "userId"
#define SN_userId "UID"
#define NID_qualityLabelledData 457
#define LN_qualityLabelledData "qualityLabelledData"
#define NID_pilotDSA 456
#define LN_pilotDSA "pilotDSA"
#define NID_pilotOrganization 455
#define LN_pilotOrganization "pilotOrganization"
#define NID_simpleSecurityObject 454
#define LN_simpleSecurityObject "simpleSecurityObject"
#define NID_friendlyCountry 453
#define LN_friendlyCountry "friendlyCountry"
#define NID_domainRelatedObject 452
#define LN_domainRelatedObject "domainRelatedObject"
#define NID_dNSDomain 451
#define LN_dNSDomain "dNSDomain"
#define NID_rFC822localPart 450
#define LN_rFC822localPart "rFC822localPart"
#define NID_Domain 392
#define LN_Domain "Domain"
#define SN_Domain "domain"
#define NID_documentSeries 449
#define LN_documentSeries "documentSeries"
#define NID_room 448
#define SN_room "room"
#define NID_document 447
#define SN_document "document"
#define NID_account 446
#define SN_account "account"
#define NID_pilotPerson 445
#define LN_pilotPerson "pilotPerson"
#define NID_pilotObject 444
#define LN_pilotObject "pilotObject"
#define NID_caseIgnoreIA5StringSyntax 443
#define LN_caseIgnoreIA5StringSyntax "caseIgnoreIA5StringSyntax"
#define NID_iA5StringSyntax 442
#define LN_iA5StringSyntax "iA5StringSyntax"
#define NID_pilotGroups 441
#define LN_pilotGroups "pilotGroups"
#define NID_pilotObjectClass 440
#define LN_pilotObjectClass "pilotObjectClass"
#define NID_pilotAttributeSyntax 439
#define LN_pilotAttributeSyntax "pilotAttributeSyntax"
#define NID_pilotAttributeType 438
#define LN_pilotAttributeType "pilotAttributeType"
#define NID_pilot 437
#define SN_pilot "pilot"
#define NID_ucl 436
#define SN_ucl "ucl"
#define NID_pss 435
#define SN_pss "pss"
#define NID_data 434
#define SN_data "data"
#define NID_signedAssertion 1279
#define SN_signedAssertion "signedAssertion"
#define NID_id_aa_ATSHashIndex_v3 1278
#define SN_id_aa_ATSHashIndex_v3 "id-aa-ATSHashIndex-v3"
#define NID_id_aa_ATSHashIndex_v2 1277
#define SN_id_aa_ATSHashIndex_v2 "id-aa-ATSHashIndex-v2"
#define NID_id_aa_ets_sigPolicyStore 1276
#define SN_id_aa_ets_sigPolicyStore "id-aa-ets-sigPolicyStore"
#define NID_id_aa_ets_signerAttrV2 1275
#define SN_id_aa_ets_signerAttrV2 "id-aa-ets-signerAttrV2"
#define NID_cades_attributes 1274
#define SN_cades_attributes "cades-attributes"
#define NID_cades 1273
#define SN_cades "cades"
#define NID_id_aa_ATSHashIndex 1272
#define SN_id_aa_ATSHashIndex "id-aa-ATSHashIndex"
#define NID_id_aa_ets_archiveTimestampV3 1271
#define SN_id_aa_ets_archiveTimestampV3 "id-aa-ets-archiveTimestampV3"
#define NID_id_aa_ets_SignaturePolicyDocument 1270
#define SN_id_aa_ets_SignaturePolicyDocument "id-aa-ets-SignaturePolicyDocument"
#define NID_id_aa_ets_longTermValidation 1269
#define SN_id_aa_ets_longTermValidation "id-aa-ets-longTermValidation"
#define NID_id_aa_ets_mimeType 1268
#define SN_id_aa_ets_mimeType "id-aa-ets-mimeType"
#define NID_ess_attributes 1267
#define SN_ess_attributes "ess-attributes"
#define NID_electronic_signature_standard 1266
#define SN_electronic_signature_standard "electronic-signature-standard"
#define NID_etsi 1265
#define SN_etsi "etsi"
#define NID_itu_t_identified_organization 1264
#define SN_itu_t_identified_organization "itu-t-identified-organization"
#define NID_hold_instruction_reject 433
#define LN_hold_instruction_reject "Hold Instruction Reject"
#define SN_hold_instruction_reject "holdInstructionReject"
#define NID_hold_instruction_call_issuer 432
#define LN_hold_instruction_call_issuer "Hold Instruction Call Issuer"
#define SN_hold_instruction_call_issuer "holdInstructionCallIssuer"
#define NID_hold_instruction_none 431
#define LN_hold_instruction_none "Hold Instruction None"
#define SN_hold_instruction_none "holdInstructionNone"
#define LN_hold_instruction_code "Hold Instruction Code"
#define SN_hold_instruction_code "holdInstructionCode"
#define NID_SLH_DSA_SHAKE_256f_WITH_SHAKE256 1486
#define LN_SLH_DSA_SHAKE_256f_WITH_SHAKE256 "SLH-DSA-SHAKE-256f-WITH-SHAKE256"
#define SN_SLH_DSA_SHAKE_256f_WITH_SHAKE256 "id-hash-slh-dsa-shake-256f-with-shake256"
#define NID_SLH_DSA_SHAKE_256s_WITH_SHAKE256 1485
#define LN_SLH_DSA_SHAKE_256s_WITH_SHAKE256 "SLH-DSA-SHAKE-256s-WITH-SHAKE256"
#define SN_SLH_DSA_SHAKE_256s_WITH_SHAKE256 "id-hash-slh-dsa-shake-256s-with-shake256"
#define NID_SLH_DSA_SHAKE_192f_WITH_SHAKE256 1484
#define LN_SLH_DSA_SHAKE_192f_WITH_SHAKE256 "SLH-DSA-SHAKE-192f-WITH-SHAKE256"
#define SN_SLH_DSA_SHAKE_192f_WITH_SHAKE256 "id-hash-slh-dsa-shake-192f-with-shake256"
#define NID_SLH_DSA_SHAKE_192s_WITH_SHAKE256 1483
#define LN_SLH_DSA_SHAKE_192s_WITH_SHAKE256 "SLH-DSA-SHAKE-192s-WITH-SHAKE256"
#define SN_SLH_DSA_SHAKE_192s_WITH_SHAKE256 "id-hash-slh-dsa-shake-192s-with-shake256"
#define NID_SLH_DSA_SHAKE_128f_WITH_SHAKE128 1482
#define LN_SLH_DSA_SHAKE_128f_WITH_SHAKE128 "SLH-DSA-SHAKE-128f-WITH-SHAKE128"
#define SN_SLH_DSA_SHAKE_128f_WITH_SHAKE128 "id-hash-slh-dsa-shake-128f-with-shake128"
#define NID_SLH_DSA_SHAKE_128s_WITH_SHAKE128 1481
#define LN_SLH_DSA_SHAKE_128s_WITH_SHAKE128 "SLH-DSA-SHAKE-128s-WITH-SHAKE128"
#define SN_SLH_DSA_SHAKE_128s_WITH_SHAKE128 "id-hash-slh-dsa-shake-128s-with-shake128"
#define NID_SLH_DSA_SHA2_256f_WITH_SHA512 1480
#define LN_SLH_DSA_SHA2_256f_WITH_SHA512 "SLH-DSA-SHA2-256f-WITH-SHA512"
#define SN_SLH_DSA_SHA2_256f_WITH_SHA512 "id-hash-slh-dsa-sha2-256f-with-sha512"
#define NID_SLH_DSA_SHA2_256s_WITH_SHA512 1479
#define LN_SLH_DSA_SHA2_256s_WITH_SHA512 "SLH-DSA-SHA2-256s-WITH-SHA512"
#define SN_SLH_DSA_SHA2_256s_WITH_SHA512 "id-hash-slh-dsa-sha2-256s-with-sha512"
#define NID_SLH_DSA_SHA2_192f_WITH_SHA512 1478
#define LN_SLH_DSA_SHA2_192f_WITH_SHA512 "SLH-DSA-SHA2-192f-WITH-SHA512"
#define SN_SLH_DSA_SHA2_192f_WITH_SHA512 "id-hash-slh-dsa-sha2-192f-with-sha512"
#define NID_SLH_DSA_SHA2_192s_WITH_SHA512 1477
#define LN_SLH_DSA_SHA2_192s_WITH_SHA512 "SLH-DSA-SHA2-192s-WITH-SHA512"
#define SN_SLH_DSA_SHA2_192s_WITH_SHA512 "id-hash-slh-dsa-sha2-192s-with-sha512"
#define NID_SLH_DSA_SHA2_128f_WITH_SHA256 1476
#define LN_SLH_DSA_SHA2_128f_WITH_SHA256 "SLH-DSA-SHA2-128f-WITH-SHA256"
#define SN_SLH_DSA_SHA2_128f_WITH_SHA256 "id-hash-slh-dsa-sha2-128f-with-sha256"
#define NID_SLH_DSA_SHA2_128s_WITH_SHA256 1475
#define LN_SLH_DSA_SHA2_128s_WITH_SHA256 "SLH-DSA-SHA2-128s-WITH-SHA256"
#define SN_SLH_DSA_SHA2_128s_WITH_SHA256 "id-hash-slh-dsa-sha2-128s-with-sha256"
#define NID_HASH_ML_DSA_87_WITH_SHA512 1474
#define LN_HASH_ML_DSA_87_WITH_SHA512 "HASH-ML-DSA-87-WITH-SHA512"
#define SN_HASH_ML_DSA_87_WITH_SHA512 "id-hash-ml-dsa-87-with-sha512"
#define NID_HASH_ML_DSA_65_WITH_SHA512 1473
#define LN_HASH_ML_DSA_65_WITH_SHA512 "HASH-ML-DSA-65-WITH-SHA512"
#define SN_HASH_ML_DSA_65_WITH_SHA512 "id-hash-ml-dsa-65-with-sha512"
#define NID_HASH_ML_DSA_44_WITH_SHA512 1472
#define LN_HASH_ML_DSA_44_WITH_SHA512 "HASH-ML-DSA-44-WITH-SHA512"
#define SN_HASH_ML_DSA_44_WITH_SHA512 "id-hash-ml-dsa-44-with-sha512"
#define NID_SLH_DSA_SHAKE_256f 1471
#define LN_SLH_DSA_SHAKE_256f "SLH-DSA-SHAKE-256f"
#define SN_SLH_DSA_SHAKE_256f "id-slh-dsa-shake-256f"
#define NID_SLH_DSA_SHAKE_256s 1470
#define LN_SLH_DSA_SHAKE_256s "SLH-DSA-SHAKE-256s"
#define SN_SLH_DSA_SHAKE_256s "id-slh-dsa-shake-256s"
#define NID_SLH_DSA_SHAKE_192f 1469
#define LN_SLH_DSA_SHAKE_192f "SLH-DSA-SHAKE-192f"
#define SN_SLH_DSA_SHAKE_192f "id-slh-dsa-shake-192f"
#define NID_SLH_DSA_SHAKE_192s 1468
#define LN_SLH_DSA_SHAKE_192s "SLH-DSA-SHAKE-192s"
#define SN_SLH_DSA_SHAKE_192s "id-slh-dsa-shake-192s"
#define NID_SLH_DSA_SHAKE_128f 1467
#define LN_SLH_DSA_SHAKE_128f "SLH-DSA-SHAKE-128f"
#define SN_SLH_DSA_SHAKE_128f "id-slh-dsa-shake-128f"
#define NID_SLH_DSA_SHAKE_128s 1466
#define LN_SLH_DSA_SHAKE_128s "SLH-DSA-SHAKE-128s"
#define SN_SLH_DSA_SHAKE_128s "id-slh-dsa-shake-128s"
#define NID_SLH_DSA_SHA2_256f 1465
#define LN_SLH_DSA_SHA2_256f "SLH-DSA-SHA2-256f"
#define SN_SLH_DSA_SHA2_256f "id-slh-dsa-sha2-256f"
#define NID_SLH_DSA_SHA2_256s 1464
#define LN_SLH_DSA_SHA2_256s "SLH-DSA-SHA2-256s"
#define SN_SLH_DSA_SHA2_256s "id-slh-dsa-sha2-256s"
#define NID_SLH_DSA_SHA2_192f 1463
#define LN_SLH_DSA_SHA2_192f "SLH-DSA-SHA2-192f"
#define SN_SLH_DSA_SHA2_192f "id-slh-dsa-sha2-192f"
#define NID_SLH_DSA_SHA2_192s 1462
#define LN_SLH_DSA_SHA2_192s "SLH-DSA-SHA2-192s"
#define SN_SLH_DSA_SHA2_192s "id-slh-dsa-sha2-192s"
#define NID_SLH_DSA_SHA2_128f 1461
#define LN_SLH_DSA_SHA2_128f "SLH-DSA-SHA2-128f"
#define SN_SLH_DSA_SHA2_128f "id-slh-dsa-sha2-128f"
#define NID_SLH_DSA_SHA2_128s 1460
#define LN_SLH_DSA_SHA2_128s "SLH-DSA-SHA2-128s"
#define SN_SLH_DSA_SHA2_128s "id-slh-dsa-sha2-128s"
#define NID_ML_DSA_87 1459
#define LN_ML_DSA_87 "ML-DSA-87"
#define SN_ML_DSA_87 "id-ml-dsa-87"
#define NID_ML_DSA_65 1458
#define LN_ML_DSA_65 "ML-DSA-65"
#define SN_ML_DSA_65 "id-ml-dsa-65"
#define NID_ML_DSA_44 1457
#define LN_ML_DSA_44 "ML-DSA-44"
#define SN_ML_DSA_44 "id-ml-dsa-44"
#define NID_RSA_SHA3_512 1119
#define LN_RSA_SHA3_512 "RSA-SHA3-512"
#define SN_RSA_SHA3_512 "id-rsassa-pkcs1-v1_5-with-sha3-512"
#define NID_RSA_SHA3_384 1118
#define LN_RSA_SHA3_384 "RSA-SHA3-384"
#define SN_RSA_SHA3_384 "id-rsassa-pkcs1-v1_5-with-sha3-384"
#define NID_RSA_SHA3_256 1117
#define LN_RSA_SHA3_256 "RSA-SHA3-256"
#define SN_RSA_SHA3_256 "id-rsassa-pkcs1-v1_5-with-sha3-256"
#define NID_RSA_SHA3_224 1116
#define LN_RSA_SHA3_224 "RSA-SHA3-224"
#define SN_RSA_SHA3_224 "id-rsassa-pkcs1-v1_5-with-sha3-224"
#define NID_ecdsa_with_SHA3_512 1115
#define LN_ecdsa_with_SHA3_512 "ecdsa_with_SHA3-512"
#define SN_ecdsa_with_SHA3_512 "id-ecdsa-with-sha3-512"
#define NID_ecdsa_with_SHA3_384 1114
#define LN_ecdsa_with_SHA3_384 "ecdsa_with_SHA3-384"
#define SN_ecdsa_with_SHA3_384 "id-ecdsa-with-sha3-384"
#define NID_ecdsa_with_SHA3_256 1113
#define LN_ecdsa_with_SHA3_256 "ecdsa_with_SHA3-256"
#define SN_ecdsa_with_SHA3_256 "id-ecdsa-with-sha3-256"
#define NID_ecdsa_with_SHA3_224 1112
#define LN_ecdsa_with_SHA3_224 "ecdsa_with_SHA3-224"
#define SN_ecdsa_with_SHA3_224 "id-ecdsa-with-sha3-224"
#define NID_dsa_with_SHA3_512 1111
#define LN_dsa_with_SHA3_512 "dsa_with_SHA3-512"
#define SN_dsa_with_SHA3_512 "id-dsa-with-sha3-512"
#define NID_dsa_with_SHA3_384 1110
#define LN_dsa_with_SHA3_384 "dsa_with_SHA3-384"
#define SN_dsa_with_SHA3_384 "id-dsa-with-sha3-384"
#define NID_dsa_with_SHA3_256 1109
#define LN_dsa_with_SHA3_256 "dsa_with_SHA3-256"
#define SN_dsa_with_SHA3_256 "id-dsa-with-sha3-256"
#define NID_dsa_with_SHA3_224 1108
#define LN_dsa_with_SHA3_224 "dsa_with_SHA3-224"
#define SN_dsa_with_SHA3_224 "id-dsa-with-sha3-224"
#define NID_dsa_with_SHA512 1107
#define LN_dsa_with_SHA512 "dsa_with_SHA512"
#define SN_dsa_with_SHA512 "id-dsa-with-sha512"
#define NID_dsa_with_SHA384 1106
#define LN_dsa_with_SHA384 "dsa_with_SHA384"
#define SN_dsa_with_SHA384 "id-dsa-with-sha384"
#define NID_dsa_with_SHA256 803
#define SN_dsa_with_SHA256 "dsa_with_SHA256"
#define NID_dsa_with_SHA224 802
#define SN_dsa_with_SHA224 "dsa_with_SHA224"
#define NID_kmac256 1197
#define LN_kmac256 "kmac256"
#define SN_kmac256 "KMAC256"
#define NID_kmac128 1196
#define LN_kmac128 "kmac128"
#define SN_kmac128 "KMAC128"
#define NID_hmac_sha3_512 1105
#define LN_hmac_sha3_512 "hmac-sha3-512"
#define SN_hmac_sha3_512 "id-hmacWithSHA3-512"
#define NID_hmac_sha3_384 1104
#define LN_hmac_sha3_384 "hmac-sha3-384"
#define SN_hmac_sha3_384 "id-hmacWithSHA3-384"
#define NID_hmac_sha3_256 1103
#define LN_hmac_sha3_256 "hmac-sha3-256"
#define SN_hmac_sha3_256 "id-hmacWithSHA3-256"
#define NID_hmac_sha3_224 1102
#define LN_hmac_sha3_224 "hmac-sha3-224"
#define SN_hmac_sha3_224 "id-hmacWithSHA3-224"
#define NID_shake256 1101
#define LN_shake256 "shake256"
#define SN_shake256 "SHAKE256"
#define NID_shake128 1100
#define LN_shake128 "shake128"
#define SN_shake128 "SHAKE128"
#define NID_sha3_512 1099
#define LN_sha3_512 "sha3-512"
#define SN_sha3_512 "SHA3-512"
#define NID_sha3_384 1098
#define LN_sha3_384 "sha3-384"
#define SN_sha3_384 "SHA3-384"
#define NID_sha3_256 1097
#define LN_sha3_256 "sha3-256"
#define SN_sha3_256 "SHA3-256"
#define NID_sha3_224 1096
#define LN_sha3_224 "sha3-224"
#define SN_sha3_224 "SHA3-224"
#define NID_sha512_256 1095
#define LN_sha512_256 "sha512-256"
#define SN_sha512_256 "SHA512-256"
#define NID_sha512_224 1094
#define LN_sha512_224 "sha512-224"
#define SN_sha512_224 "SHA512-224"
#define NID_sha224 675
#define LN_sha224 "sha224"
#define SN_sha224 "SHA224"
#define NID_sha512 674
#define LN_sha512 "sha512"
#define SN_sha512 "SHA512"
#define NID_sha384 673
#define LN_sha384 "sha384"
#define SN_sha384 "SHA384"
#define NID_sha256 672
#define LN_sha256 "sha256"
#define NID_des_ede3_cfb8 659
#define LN_des_ede3_cfb8 "des-ede3-cfb8"
#define SN_des_ede3_cfb8 "DES-EDE3-CFB8"
#define NID_des_ede3_cfb1 658
#define LN_des_ede3_cfb1 "des-ede3-cfb1"
#define SN_des_ede3_cfb1 "DES-EDE3-CFB1"
#define NID_des_cfb8 657
#define LN_des_cfb8 "des-cfb8"
#define SN_des_cfb8 "DES-CFB8"
#define NID_des_cfb1 656
#define LN_des_cfb1 "des-cfb1"
#define SN_des_cfb1 "DES-CFB1"
#define NID_aes_256_ocb 960
#define LN_aes_256_ocb "aes-256-ocb"
#define SN_aes_256_ocb "AES-256-OCB"
#define NID_aes_192_ocb 959
#define LN_aes_192_ocb "aes-192-ocb"
#define SN_aes_192_ocb "AES-192-OCB"
#define NID_aes_128_ocb 958
#define LN_aes_128_ocb "aes-128-ocb"
#define SN_aes_128_ocb "AES-128-OCB"
#define NID_aes_256_ctr 906
#define LN_aes_256_ctr "aes-256-ctr"
#define SN_aes_256_ctr "AES-256-CTR"
#define NID_aes_192_ctr 905
#define LN_aes_192_ctr "aes-192-ctr"
#define SN_aes_192_ctr "AES-192-CTR"
#define NID_aes_128_ctr 904
#define LN_aes_128_ctr "aes-128-ctr"
#define SN_aes_128_ctr "AES-128-CTR"
#define NID_aes_256_cfb8 655
#define LN_aes_256_cfb8 "aes-256-cfb8"
#define SN_aes_256_cfb8 "AES-256-CFB8"
#define NID_aes_192_cfb8 654
#define LN_aes_192_cfb8 "aes-192-cfb8"
#define SN_aes_192_cfb8 "AES-192-CFB8"
#define NID_aes_128_cfb8 653
#define LN_aes_128_cfb8 "aes-128-cfb8"
#define SN_aes_128_cfb8 "AES-128-CFB8"
#define NID_aes_256_cfb1 652
#define LN_aes_256_cfb1 "aes-256-cfb1"
#define SN_aes_256_cfb1 "AES-256-CFB1"
#define NID_aes_192_cfb1 651
#define LN_aes_192_cfb1 "aes-192-cfb1"
#define SN_aes_192_cfb1 "AES-192-CFB1"
#define NID_aes_128_cfb1 650
#define LN_aes_128_cfb1 "aes-128-cfb1"
#define SN_aes_128_cfb1 "AES-128-CFB1"
#define NID_aes_256_xts 914
#define LN_aes_256_xts "aes-256-xts"
#define SN_aes_256_xts "AES-256-XTS"
#define NID_aes_128_xts 913
#define LN_aes_128_xts "aes-128-xts"
#define SN_aes_128_xts "AES-128-XTS"
#define NID_id_aes256_wrap_pad 903
#define SN_id_aes256_wrap_pad "id-aes256-wrap-pad"
#define NID_aes_256_ccm 902
#define LN_aes_256_ccm "aes-256-ccm"
#define SN_aes_256_ccm "id-aes256-CCM"
#define NID_aes_256_gcm 901
#define LN_aes_256_gcm "aes-256-gcm"
#define SN_aes_256_gcm "id-aes256-GCM"
#define NID_id_aes256_wrap 790
#define SN_id_aes256_wrap "id-aes256-wrap"
#define NID_aes_256_cfb128 429
#define LN_aes_256_cfb128 "aes-256-cfb"
#define SN_aes_256_cfb128 "AES-256-CFB"
#define NID_aes_256_ofb128 428
#define LN_aes_256_ofb128 "aes-256-ofb"
#define SN_aes_256_ofb128 "AES-256-OFB"
#define NID_aes_256_cbc 427
#define LN_aes_256_cbc "aes-256-cbc"
#define NID_aes_256_ecb 426
#define LN_aes_256_ecb "aes-256-ecb"
#define SN_aes_256_ecb "AES-256-ECB"
#define NID_id_aes192_wrap_pad 900
#define SN_id_aes192_wrap_pad "id-aes192-wrap-pad"
#define NID_aes_192_ccm 899
#define LN_aes_192_ccm "aes-192-ccm"
#define SN_aes_192_ccm "id-aes192-CCM"
#define NID_aes_192_gcm 898
#define LN_aes_192_gcm "aes-192-gcm"
#define SN_aes_192_gcm "id-aes192-GCM"
#define NID_id_aes192_wrap 789
#define SN_id_aes192_wrap "id-aes192-wrap"
#define NID_aes_192_cfb128 425
#define LN_aes_192_cfb128 "aes-192-cfb"
#define SN_aes_192_cfb128 "AES-192-CFB"
#define NID_aes_192_ofb128 424
#define LN_aes_192_ofb128 "aes-192-ofb"
#define SN_aes_192_ofb128 "AES-192-OFB"
#define NID_aes_192_cbc 423
#define LN_aes_192_cbc "aes-192-cbc"
#define SN_aes_192_cbc "AES-192-CBC"
#define NID_aes_192_ecb 422
#define LN_aes_192_ecb "aes-192-ecb"
#define SN_aes_192_ecb "AES-192-ECB"
#define NID_id_aes128_wrap_pad 897
#define SN_id_aes128_wrap_pad "id-aes128-wrap-pad"
#define NID_aes_128_ccm 896
#define LN_aes_128_ccm "aes-128-ccm"
#define SN_aes_128_ccm "id-aes128-CCM"
#define NID_aes_128_gcm 895
#define LN_aes_128_gcm "aes-128-gcm"
#define SN_aes_128_gcm "id-aes128-GCM"
#define NID_id_aes128_wrap 788
#define SN_id_aes128_wrap "id-aes128-wrap"
#define NID_aes_128_cfb128 421
#define LN_aes_128_cfb128 "aes-128-cfb"
#define SN_aes_128_cfb128 "AES-128-CFB"
#define NID_aes_128_ofb128 420
#define LN_aes_128_ofb128 "aes-128-ofb"
#define SN_aes_128_ofb128 "AES-128-OFB"
#define NID_aes_128_cbc 419
#define LN_aes_128_cbc "aes-128-cbc"
#define SN_aes_128_cbc "AES-128-CBC"
#define NID_aes_128_ecb 418
#define LN_aes_128_ecb "aes-128-ecb"
#define SN_aes_128_ecb "AES-128-ECB"
#define NID_zlib_compression 125
#define LN_zlib_compression "zlib compression"
#define SN_zlib_compression "ZLIB"
#define NID_id_hex_multipart_message 508
#define LN_id_hex_multipart_message "id-hex-multipart-message"
#define SN_id_hex_multipart_message "id-hex-multipart-message"
#define NID_id_hex_partial_message 507
#define LN_id_hex_partial_message "id-hex-partial-message"
#define SN_id_hex_partial_message "id-hex-partial-message"
#define NID_mime_mhs_bodies 506
#define LN_mime_mhs_bodies "mime-mhs-bodies"
#define SN_mime_mhs_bodies "mime-mhs-bodies"
#define NID_mime_mhs_headings 505
#define LN_mime_mhs_headings "mime-mhs-headings"
#define SN_mime_mhs_headings "mime-mhs-headings"
#define NID_mime_mhs 504
#define LN_mime_mhs "MIME MHS"
#define SN_mime_mhs "mime-mhs"
#define NID_id_kp_wisun_fan_device 1322
#define LN_id_kp_wisun_fan_device "Wi-SUN Alliance Field Area Network (FAN)"
#define SN_id_kp_wisun_fan_device "id-kp-wisun-fan-device"
#define NID_dcObject 390
#define LN_dcObject "dcObject"
#define SN_dcObject "dcobject"
#define NID_Enterprises 389
#define LN_Enterprises "Enterprises"
#define SN_Enterprises "enterprises"
#define NID_Mail 388
#define LN_Mail "Mail"
#define NID_SNMPv2 387
#define LN_SNMPv2 "SNMPv2"
#define SN_SNMPv2 "snmpv2"
#define NID_Security 386
#define LN_Security "Security"
#define SN_Security "security"
#define NID_Private 385
#define LN_Private "Private"
#define SN_Private "private"
#define NID_Experimental 384
#define LN_Experimental "Experimental"
#define SN_Experimental "experimental"
#define NID_Management 383
#define LN_Management "Management"
#define SN_Management "mgmt"
#define NID_Directory 382
#define LN_Directory "Directory"
#define SN_Directory "directory"
#define NID_iana 381
#define LN_iana "iana"
#define SN_iana "IANA"
#define NID_dod 380
#define LN_dod "dod"
#define SN_dod "DOD"
#define NID_org 379
#define LN_org "org"
#define SN_org "ORG"
#define NID_ns_sgc 139
#define LN_ns_sgc "Netscape Server Gated Crypto"
#define SN_ns_sgc "nsSGC"
#define NID_netscape_cert_sequence 79
#define LN_netscape_cert_sequence "Netscape Certificate Sequence"
#define SN_netscape_cert_sequence "nsCertSequence"
#define NID_netscape_comment 78
#define LN_netscape_comment "Netscape Comment"
#define SN_netscape_comment "nsComment"
#define NID_netscape_ssl_server_name 77
#define LN_netscape_ssl_server_name "Netscape SSL Server Name"
#define SN_netscape_ssl_server_name "nsSslServerName"
#define NID_netscape_ca_policy_url 76
#define LN_netscape_ca_policy_url "Netscape CA Policy Url"
#define SN_netscape_ca_policy_url "nsCaPolicyUrl"
#define NID_netscape_renewal_url 75
#define LN_netscape_renewal_url "Netscape Renewal Url"
#define SN_netscape_renewal_url "nsRenewalUrl"
#define NID_netscape_ca_revocation_url 74
#define LN_netscape_ca_revocation_url "Netscape CA Revocation Url"
#define SN_netscape_ca_revocation_url "nsCaRevocationUrl"
#define NID_netscape_revocation_url 73
#define LN_netscape_revocation_url "Netscape Revocation Url"
#define SN_netscape_revocation_url "nsRevocationUrl"
#define NID_netscape_base_url 72
#define LN_netscape_base_url "Netscape Base Url"
#define SN_netscape_base_url "nsBaseUrl"
#define NID_netscape_cert_type 71
#define LN_netscape_cert_type "Netscape Cert Type"
#define SN_netscape_cert_type "nsCertType"
#define NID_netscape_data_type 59
#define LN_netscape_data_type "Netscape Data Type"
#define SN_netscape_data_type "nsDataType"
#define NID_netscape_cert_extension 58
#define LN_netscape_cert_extension "Netscape Certificate Extension"
#define SN_netscape_cert_extension "nsCertExt"
#define NID_netscape 57
#define LN_netscape "Netscape Communications Corp."
#define SN_netscape "Netscape"
#define NID_anyExtendedKeyUsage 910
#define LN_anyExtendedKeyUsage "Any Extended Key Usage"
#define SN_anyExtendedKeyUsage "anyExtendedKeyUsage"
#define NID_associated_information 1319
#define LN_associated_information "X509v3 Associated Information"
#define SN_associated_information "associatedInformation"
#define NID_alt_signature_value 1318
#define LN_alt_signature_value "X509v3 Alternative Signature Value"
#define SN_alt_signature_value "altSignatureValue"
#define NID_alt_signature_algorithm 1317
#define LN_alt_signature_algorithm "X509v3 Alternative Signature Algorithm"
#define SN_alt_signature_algorithm "altSignatureAlgorithm"
#define NID_subject_alt_public_key_info 1316
#define LN_subject_alt_public_key_info "X509v3 Subject Alternative Public Key Info"
#define SN_subject_alt_public_key_info "subjectAltPublicKeyInfo"
#define NID_prot_restrict 1315
#define LN_prot_restrict "X509v3 Protocol Restriction"
#define SN_prot_restrict "protRestrict"
#define NID_authorization_validation 1314
#define LN_authorization_validation "X509v3 Authorization Validation"
#define SN_authorization_validation "authorizationValidation"
#define NID_holder_name_constraints 1313
#define LN_holder_name_constraints "X509v3 Holder Name Constraints"
#define SN_holder_name_constraints "holderNameConstraints"
#define NID_attribute_mappings 1312
#define LN_attribute_mappings "X509v3 Attribute Mappings"
#define SN_attribute_mappings "attributeMappings"
#define NID_allowed_attribute_assignments 1311
#define LN_allowed_attribute_assignments "X509v3 Allowed Attribute Assignments"
#define SN_allowed_attribute_assignments "allowedAttributeAssignments"
#define NID_group_ac 1310
#define LN_group_ac "X509v3 Group Attribute Certificate"
#define SN_group_ac "groupAC"
#define NID_single_use 1309
#define LN_single_use "X509v3 Single Use"
#define SN_single_use "singleUse"
#define NID_issued_on_behalf_of 1308
#define LN_issued_on_behalf_of "X509v3 Issued On Behalf Of"
#define SN_issued_on_behalf_of "issuedOnBehalfOf"
#define NID_id_aa_issuing_distribution_point 1307
#define LN_id_aa_issuing_distribution_point "X509v3 Attribute Authority Issuing Distribution Point"
#define SN_id_aa_issuing_distribution_point "aAissuingDistributionPoint"
#define NID_no_assertion 1306
#define LN_no_assertion "X509v3 No Assertion"
#define SN_no_assertion "noAssertion"
#define NID_indirect_issuer 1305
#define LN_indirect_issuer "X509v3 Indirect Issuer"
#define SN_indirect_issuer "indirectIssuer"
#define NID_acceptable_privilege_policies 1304
#define LN_acceptable_privilege_policies "X509v3 Acceptable Privilege Policies"
#define SN_acceptable_privilege_policies "acceptablePrivPolicies"
#define NID_no_rev_avail 403
#define LN_no_rev_avail "X509v3 No Revocation Available"
#define SN_no_rev_avail "noRevAvail"
#define NID_target_information 402
#define LN_target_information "X509v3 AC Targeting"
#define SN_target_information "targetInformation"
#define NID_inhibit_any_policy 748
#define LN_inhibit_any_policy "X509v3 Inhibit Any Policy"
#define SN_inhibit_any_policy "inhibitAnyPolicy"
#define NID_acceptable_cert_policies 1303
#define LN_acceptable_cert_policies "X509v3 Acceptable Certification Policies"
#define SN_acceptable_cert_policies "acceptableCertPolicies"
#define NID_soa_identifier 1302
#define LN_soa_identifier "X509v3 Source of Authority Identifier"
#define SN_soa_identifier "sOAIdentifier"
#define NID_user_notice 1301
#define LN_user_notice "X509v3 User Notice"
#define SN_user_notice "userNotice"
#define NID_attribute_descriptor 1300
#define LN_attribute_descriptor "X509v3 Attribute Descriptor"
#define SN_attribute_descriptor "attributeDescriptor"
#define NID_freshest_crl 857
#define LN_freshest_crl "X509v3 Freshest CRL"
#define SN_freshest_crl "freshestCRL"
#define NID_time_specification 1299
#define LN_time_specification "X509v3 Time Specification"
#define SN_time_specification "timeSpecification"
#define NID_delegated_name_constraints 1298
#define LN_delegated_name_constraints "X509v3 Delegated Name Constraints"
#define SN_delegated_name_constraints "delegatedNameConstraints"
#define NID_basic_att_constraints 1297
#define LN_basic_att_constraints "X509v3 Basic Attribute Certificate Constraints"
#define SN_basic_att_constraints "basicAttConstraints"
#define NID_role_spec_cert_identifier 1296
#define LN_role_spec_cert_identifier "X509v3 Role Specification Certificate Identifier"
#define SN_role_spec_cert_identifier "roleSpecCertIdentifier"
#define NID_authority_attribute_identifier 1295
#define LN_authority_attribute_identifier "X509v3 Authority Attribute Identifier"
#define SN_authority_attribute_identifier "authorityAttributeIdentifier"
#define NID_ext_key_usage 126
#define LN_ext_key_usage "X509v3 Extended Key Usage"
#define SN_ext_key_usage "extendedKeyUsage"
#define NID_policy_constraints 401
#define LN_policy_constraints "X509v3 Policy Constraints"
#define SN_policy_constraints "policyConstraints"
#define NID_authority_key_identifier 90
#define LN_authority_key_identifier "X509v3 Authority Key Identifier"
#define SN_authority_key_identifier "authorityKeyIdentifier"
#define NID_policy_mappings 747
#define LN_policy_mappings "X509v3 Policy Mappings"
#define SN_policy_mappings "policyMappings"
#define NID_any_policy 746
#define LN_any_policy "X509v3 Any Policy"
#define SN_any_policy "anyPolicy"
#define NID_certificate_policies 89
#define LN_certificate_policies "X509v3 Certificate Policies"
#define SN_certificate_policies "certificatePolicies"
#define NID_crl_distribution_points 103
#define LN_crl_distribution_points "X509v3 CRL Distribution Points"
#define SN_crl_distribution_points "crlDistributionPoints"
#define NID_name_constraints 666
#define LN_name_constraints "X509v3 Name Constraints"
#define SN_name_constraints "nameConstraints"
#define NID_certificate_issuer 771
#define LN_certificate_issuer "X509v3 Certificate Issuer"
#define SN_certificate_issuer "certificateIssuer"
#define NID_issuing_distribution_point 770
#define LN_issuing_distribution_point "X509v3 Issuing Distribution Point"
#define SN_issuing_distribution_point "issuingDistributionPoint"
#define NID_delta_crl 140
#define LN_delta_crl "X509v3 Delta CRL Indicator"
#define SN_delta_crl "deltaCRL"
#define LN_invalidity_date "Invalidity Date"
#define SN_invalidity_date "invalidityDate"
#define LN_crl_reason "X509v3 CRL Reason Code"
#define SN_crl_reason "CRLReason"
#define LN_crl_number "X509v3 CRL Number"
#define SN_crl_number "crlNumber"
#define NID_basic_constraints 87
#define LN_basic_constraints "X509v3 Basic Constraints"
#define SN_basic_constraints "basicConstraints"
#define NID_issuer_alt_name 86
#define LN_issuer_alt_name "X509v3 Issuer Alternative Name"
#define SN_issuer_alt_name "issuerAltName"
#define NID_subject_alt_name 85
#define LN_subject_alt_name "X509v3 Subject Alternative Name"
#define SN_subject_alt_name "subjectAltName"
#define NID_private_key_usage_period 84
#define LN_private_key_usage_period "X509v3 Private Key Usage Period"
#define SN_private_key_usage_period "privateKeyUsagePeriod"
#define NID_key_usage 83
#define LN_key_usage "X509v3 Key Usage"
#define SN_key_usage "keyUsage"
#define NID_subject_key_identifier 82
#define LN_subject_key_identifier "X509v3 Subject Key Identifier"
#define SN_subject_key_identifier "subjectKeyIdentifier"
#define NID_subject_directory_attributes 769
#define LN_subject_directory_attributes "X509v3 Subject Directory Attributes"
#define SN_subject_directory_attributes "subjectDirectoryAttributes"
#define NID_id_ce 81
#define SN_id_ce "id-ce"
#define NID_mdc2 95
#define LN_mdc2 "mdc2"
#define SN_mdc2 "MDC2"
#define NID_mdc2WithRSA 96
#define LN_mdc2WithRSA "mdc2WithRSA"
#define SN_mdc2WithRSA "RSA-MDC2"
#define NID_rsa 19
#define LN_rsa "rsa"
#define SN_rsa "RSA"
#define NID_X500algorithms 378
#define LN_X500algorithms "directory services - algorithms"
#define SN_X500algorithms "X500algorithms"
#define NID_dnsName 1092
#define LN_dnsName "dnsName"
#define NID_countryCode3n 1091
#define LN_countryCode3n "countryCode3n"
#define SN_countryCode3n "n3"
#define NID_countryCode3c 1090
#define LN_countryCode3c "countryCode3c"
#define SN_countryCode3c "c3"
#define NID_organizationIdentifier 1089
#define LN_organizationIdentifier "organizationIdentifier"
#define NID_role 400
#define LN_role "role"
#define SN_role "role"
#define NID_pseudonym 510
#define LN_pseudonym "pseudonym"
#define NID_dmdName 892
#define SN_dmdName "dmdName"
#define NID_deltaRevocationList 891
#define LN_deltaRevocationList "deltaRevocationList"
#define NID_supportedAlgorithms 890
#define LN_supportedAlgorithms "supportedAlgorithms"
#define NID_houseIdentifier 889
#define LN_houseIdentifier "houseIdentifier"
#define NID_uniqueMember 888
#define LN_uniqueMember "uniqueMember"
#define NID_distinguishedName 887
#define LN_distinguishedName "distinguishedName"
#define NID_protocolInformation 886
#define LN_protocolInformation "protocolInformation"
#define NID_enhancedSearchGuide 885
#define LN_enhancedSearchGuide "enhancedSearchGuide"
#define NID_dnQualifier 174
#define LN_dnQualifier "dnQualifier"
#define SN_dnQualifier "dnQualifier"
#define NID_x500UniqueIdentifier 503
#define LN_x500UniqueIdentifier "x500UniqueIdentifier"
#define NID_generationQualifier 509
#define LN_generationQualifier "generationQualifier"
#define NID_initials 101
#define LN_initials "initials"
#define SN_initials "initials"
#define NID_givenName 99
#define LN_givenName "givenName"
#define SN_givenName "GN"
#define NID_name 173
#define LN_name "name"
#define SN_name "name"
#define NID_crossCertificatePair 884
#define LN_crossCertificatePair "crossCertificatePair"
#define NID_certificateRevocationList 883
#define LN_certificateRevocationList "certificateRevocationList"
#define NID_authorityRevocationList 882
#define LN_authorityRevocationList "authorityRevocationList"
#define NID_cACertificate 881
#define LN_cACertificate "cACertificate"
#define NID_userCertificate 880
#define LN_userCertificate "userCertificate"
#define NID_userPassword 879
#define LN_userPassword "userPassword"
#define NID_seeAlso 878
#define SN_seeAlso "seeAlso"
#define NID_roleOccupant 877
#define LN_roleOccupant "roleOccupant"
#define NID_owner 876
#define SN_owner "owner"
#define NID_member 875
#define SN_member "member"
#define NID_supportedApplicationContext 874
#define LN_supportedApplicationContext "supportedApplicationContext"
#define NID_presentationAddress 873
#define LN_presentationAddress "presentationAddress"
#define NID_preferredDeliveryMethod 872
#define LN_preferredDeliveryMethod "preferredDeliveryMethod"
#define NID_destinationIndicator 871
#define LN_destinationIndicator "destinationIndicator"
#define NID_registeredAddress 870
#define LN_registeredAddress "registeredAddress"
#define NID_internationaliSDNNumber 869
#define LN_internationaliSDNNumber "internationaliSDNNumber"
#define NID_x121Address 868
#define LN_x121Address "x121Address"
#define NID_facsimileTelephoneNumber 867
#define LN_facsimileTelephoneNumber "facsimileTelephoneNumber"
#define NID_teletexTerminalIdentifier 866
#define LN_teletexTerminalIdentifier "teletexTerminalIdentifier"
#define NID_telexNumber 865
#define LN_telexNumber "telexNumber"
#define NID_telephoneNumber 864
#define LN_telephoneNumber "telephoneNumber"
#define NID_physicalDeliveryOfficeName 863
#define LN_physicalDeliveryOfficeName "physicalDeliveryOfficeName"
#define NID_postOfficeBox 862
#define LN_postOfficeBox "postOfficeBox"
#define NID_postalCode 661
#define LN_postalCode "postalCode"
#define NID_postalAddress 861
#define LN_postalAddress "postalAddress"
#define NID_businessCategory 860
#define LN_businessCategory "businessCategory"
#define NID_searchGuide 859
#define LN_searchGuide "searchGuide"
#define NID_description 107
#define LN_description "description"
#define NID_title 106
#define LN_title "title"
#define SN_title "title"
#define NID_organizationalUnitName 18
#define LN_organizationalUnitName "organizationalUnitName"
#define SN_organizationalUnitName "OU"
#define NID_organizationName 17
#define LN_organizationName "organizationName"
#define SN_organizationName "O"
#define NID_streetAddress 660
#define LN_streetAddress "streetAddress"
#define SN_streetAddress "street"
#define NID_stateOrProvinceName 16
#define LN_stateOrProvinceName "stateOrProvinceName"
#define SN_stateOrProvinceName "ST"
#define NID_localityName 15
#define LN_localityName "localityName"
#define SN_localityName "L"
#define NID_countryName 14
#define LN_countryName "countryName"
#define SN_countryName "C"
#define NID_serialNumber 105
#define LN_serialNumber "serialNumber"
#define NID_surname 100
#define LN_surname "surname"
#define SN_surname "SN"
#define NID_commonName 13
#define LN_commonName "commonName"
#define SN_commonName "CN"
#define NID_X509 12
#define SN_X509 "X509"
#define NID_X500 11
#define LN_X500 "directory services (X.500)"
#define SN_X500 "X500"
#define NID_sxnet 143
#define LN_sxnet "Strong Extranet ID"
#define SN_sxnet "SXNetID"
#define NID_blake2s256 1057
#define LN_blake2s256 "blake2s256"
#define SN_blake2s256 "BLAKE2s256"
#define NID_blake2b512 1056
#define LN_blake2b512 "blake2b512"
#define SN_blake2b512 "BLAKE2b512"
#define NID_blake2smac 1202
#define LN_blake2smac "blake2smac"
#define SN_blake2smac "BLAKE2SMAC"
#define NID_blake2bmac 1201
#define LN_blake2bmac "blake2bmac"
#define SN_blake2bmac "BLAKE2BMAC"
#define NID_ripemd160WithRSA 119
#define LN_ripemd160WithRSA "ripemd160WithRSA"
#define SN_ripemd160WithRSA "RSA-RIPEMD160"
#define NID_ripemd160 117
#define LN_ripemd160 "ripemd160"
#define SN_ripemd160 "RIPEMD160"
#define NID_sha1WithRSA 115
#define LN_sha1WithRSA "sha1WithRSA"
#define SN_sha1WithRSA "RSA-SHA1-2"
#define NID_dsaWithSHA1_2 70
#define LN_dsaWithSHA1_2 "dsaWithSHA1-old"
#define SN_dsaWithSHA1_2 "DSA-SHA1-old"
#define NID_sha1 64
#define LN_sha1 "sha1"
#define SN_sha1 "SHA1"
#define NID_sha 41
#define LN_sha "sha"
#define SN_sha "SHA"
#define NID_desx_cbc 80
#define LN_desx_cbc "desx-cbc"
#define SN_desx_cbc "DESX-CBC"
#define NID_des_ede3_ofb64 63
#define LN_des_ede3_ofb64 "des-ede3-ofb"
#define SN_des_ede3_ofb64 "DES-EDE3-OFB"
#define NID_des_ede_ofb64 62
#define LN_des_ede_ofb64 "des-ede-ofb"
#define SN_des_ede_ofb64 "DES-EDE-OFB"
#define NID_des_ede3_cfb64 61
#define LN_des_ede3_cfb64 "des-ede3-cfb"
#define SN_des_ede3_cfb64 "DES-EDE3-CFB"
#define NID_des_ede_cfb64 60
#define LN_des_ede_cfb64 "des-ede-cfb"
#define SN_des_ede_cfb64 "DES-EDE-CFB"
#define NID_des_ede_cbc 43
#define LN_des_ede_cbc "des-ede-cbc"
#define SN_des_ede_cbc "DES-EDE-CBC"
#define NID_des_ede3_ecb 33
#define LN_des_ede3_ecb "des-ede3"
#define SN_des_ede3_ecb "DES-EDE3"
#define NID_des_ede_ecb 32
#define LN_des_ede_ecb "des-ede"
#define SN_des_ede_ecb "DES-EDE"
#define NID_shaWithRSAEncryption 42
#define LN_shaWithRSAEncryption "shaWithRSAEncryption"
#define SN_shaWithRSAEncryption "RSA-SHA"
#define NID_dsaWithSHA 66
#define LN_dsaWithSHA "dsaWithSHA"
#define SN_dsaWithSHA "DSA-SHA"
#define NID_dsa_2 67
#define LN_dsa_2 "dsaEncryption-old"
#define SN_dsa_2 "DSA-old"
#define NID_rsaSignature 377
#define SN_rsaSignature "rsaSignature"
#define NID_des_cfb64 30
#define LN_des_cfb64 "des-cfb"
#define SN_des_cfb64 "DES-CFB"
#define NID_des_ofb64 45
#define LN_des_ofb64 "des-ofb"
#define SN_des_ofb64 "DES-OFB"
#define NID_des_cbc 31
#define LN_des_cbc "des-cbc"
#define SN_des_cbc "DES-CBC"
#define NID_des_ecb 29
#define LN_des_ecb "des-ecb"
#define SN_des_ecb "DES-ECB"
#define NID_md5WithRSA 104
#define LN_md5WithRSA "md5WithRSA"
#define SN_md5WithRSA "RSA-NP-MD5"
#define NID_algorithm 376
#define LN_algorithm "algorithm"
#define SN_algorithm "algorithm"
#define NID_id_pkix_OCSP_trustRoot 375
#define LN_id_pkix_OCSP_trustRoot "Trust Root"
#define SN_id_pkix_OCSP_trustRoot "trustRoot"
#define NID_id_pkix_OCSP_path 374
#define SN_id_pkix_OCSP_path "path"
#define NID_id_pkix_OCSP_valid 373
#define SN_id_pkix_OCSP_valid "valid"
#define NID_id_pkix_OCSP_extendedStatus 372
#define LN_id_pkix_OCSP_extendedStatus "Extended OCSP Status"
#define SN_id_pkix_OCSP_extendedStatus "extendedStatus"
#define NID_id_pkix_OCSP_serviceLocator 371
#define LN_id_pkix_OCSP_serviceLocator "OCSP Service Locator"
#define SN_id_pkix_OCSP_serviceLocator "serviceLocator"
#define NID_id_pkix_OCSP_archiveCutoff 370
#define LN_id_pkix_OCSP_archiveCutoff "OCSP Archive Cutoff"
#define SN_id_pkix_OCSP_archiveCutoff "archiveCutoff"
#define NID_id_pkix_OCSP_noCheck 369
#define LN_id_pkix_OCSP_noCheck "OCSP No Check"
#define SN_id_pkix_OCSP_noCheck "noCheck"
#define NID_id_pkix_OCSP_acceptableResponses 368
#define LN_id_pkix_OCSP_acceptableResponses "Acceptable OCSP Responses"
#define SN_id_pkix_OCSP_acceptableResponses "acceptableResponses"
#define NID_id_pkix_OCSP_CrlID 367
#define LN_id_pkix_OCSP_CrlID "OCSP CRL ID"
#define SN_id_pkix_OCSP_CrlID "CrlID"
#define NID_id_pkix_OCSP_Nonce 366
#define LN_id_pkix_OCSP_Nonce "OCSP Nonce"
#define SN_id_pkix_OCSP_Nonce "Nonce"
#define NID_id_pkix_OCSP_basic 365
#define LN_id_pkix_OCSP_basic "Basic OCSP Response"
#define SN_id_pkix_OCSP_basic "basicOCSPResponse"
#define NID_rpkiNotify 1245
#define LN_rpkiNotify "RPKI Notify"
#define SN_rpkiNotify "rpkiNotify"
#define NID_signedObject 1244
#define LN_signedObject "Signed Object"
#define SN_signedObject "signedObject"
#define NID_rpkiManifest 1243
#define LN_rpkiManifest "RPKI Manifest"
#define SN_rpkiManifest "rpkiManifest"
#define NID_caRepository 785
#define LN_caRepository "CA Repository"
#define SN_caRepository "caRepository"
#define NID_ad_dvcs 364
#define LN_ad_dvcs "ad dvcs"
#define SN_ad_dvcs "AD_DVCS"
#define NID_ad_timeStamping 363
#define LN_ad_timeStamping "AD Time Stamping"
#define SN_ad_timeStamping "ad_timestamping"
#define NID_ad_ca_issuers 179
#define LN_ad_ca_issuers "CA Issuers"
#define SN_ad_ca_issuers "caIssuers"
#define NID_ad_OCSP 178
#define LN_ad_OCSP "OCSP"
#define SN_ad_OCSP "OCSP"
#define NID_Independent 667
#define LN_Independent "Independent"
#define SN_Independent "id-ppl-independent"
#define NID_id_ppl_inheritAll 665
#define LN_id_ppl_inheritAll "Inherit all"
#define SN_id_ppl_inheritAll "id-ppl-inheritAll"
#define NID_id_ppl_anyLanguage 664
#define LN_id_ppl_anyLanguage "Any language"
#define SN_id_ppl_anyLanguage "id-ppl-anyLanguage"
#define NID_id_cct_PKIResponse 362
#define SN_id_cct_PKIResponse "id-cct-PKIResponse"
#define NID_id_cct_PKIData 361
#define SN_id_cct_PKIData "id-cct-PKIData"
#define NID_id_cct_crs 360
#define SN_id_cct_crs "id-cct-crs"
#define NID_ipAddr_asNumberv2 1242
#define SN_ipAddr_asNumberv2 "ipAddr-asNumberv2"
#define NID_ipAddr_asNumber 1241
#define SN_ipAddr_asNumber "ipAddr-asNumber"
#define NID_id_qcs_pkixQCSyntax_v1 359
#define SN_id_qcs_pkixQCSyntax_v1 "id-qcs-pkixQCSyntax-v1"
#define NID_id_aca_encAttrs 399
#define SN_id_aca_encAttrs "id-aca-encAttrs"
#define NID_id_aca_role 358
#define SN_id_aca_role "id-aca-role"
#define NID_id_aca_group 357
#define SN_id_aca_group "id-aca-group"
#define NID_id_aca_chargingIdentity 356
#define SN_id_aca_chargingIdentity "id-aca-chargingIdentity"
#define NID_id_aca_accessIdentity 355
#define SN_id_aca_accessIdentity "id-aca-accessIdentity"
#define NID_id_aca_authenticationInfo 354
#define SN_id_aca_authenticationInfo "id-aca-authenticationInfo"
#define NID_id_pda_countryOfResidence 353
#define SN_id_pda_countryOfResidence "id-pda-countryOfResidence"
#define NID_id_pda_countryOfCitizenship 352
#define SN_id_pda_countryOfCitizenship "id-pda-countryOfCitizenship"
#define NID_id_pda_gender 351
#define SN_id_pda_gender "id-pda-gender"
#define NID_id_pda_placeOfBirth 349
#define SN_id_pda_placeOfBirth "id-pda-placeOfBirth"
#define NID_id_pda_dateOfBirth 348
#define SN_id_pda_dateOfBirth "id-pda-dateOfBirth"
#define NID_id_on_SmtpUTF8Mailbox 1208
#define LN_id_on_SmtpUTF8Mailbox "Smtp UTF8 Mailbox"
#define SN_id_on_SmtpUTF8Mailbox "id-on-SmtpUTF8Mailbox"
#define NID_NAIRealm 1211
#define LN_NAIRealm "NAIRealm"
#define SN_NAIRealm "id-on-NAIRealm"
#define NID_SRVName 1210
#define LN_SRVName "SRVName"
#define SN_SRVName "id-on-dnsSRV"
#define NID_XmppAddr 1209
#define LN_XmppAddr "XmppAddr"
#define SN_XmppAddr "id-on-xmppAddr"
#define NID_id_on_hardwareModuleName 1321
#define LN_id_on_hardwareModuleName "Hardware Module Name"
#define SN_id_on_hardwareModuleName "id-on-hardwareModuleName"
#define NID_id_on_permanentIdentifier 858
#define LN_id_on_permanentIdentifier "Permanent Identifier"
#define SN_id_on_permanentIdentifier "id-on-permanentIdentifier"
#define NID_id_on_personalData 347
#define SN_id_on_personalData "id-on-personalData"
#define NID_id_cmc_confirmCertAcceptance 346
#define SN_id_cmc_confirmCertAcceptance "id-cmc-confirmCertAcceptance"
#define NID_id_cmc_popLinkWitness 345
#define SN_id_cmc_popLinkWitness "id-cmc-popLinkWitness"
#define NID_id_cmc_popLinkRandom 344
#define SN_id_cmc_popLinkRandom "id-cmc-popLinkRandom"
#define NID_id_cmc_queryPending 343
#define SN_id_cmc_queryPending "id-cmc-queryPending"
#define NID_id_cmc_responseInfo 342
#define SN_id_cmc_responseInfo "id-cmc-responseInfo"
#define NID_id_cmc_regInfo 341
#define SN_id_cmc_regInfo "id-cmc-regInfo"
#define NID_id_cmc_revokeRequest 340
#define SN_id_cmc_revokeRequest "id-cmc-revokeRequest"
#define NID_id_cmc_getCRL 339
#define SN_id_cmc_getCRL "id-cmc-getCRL"
#define NID_id_cmc_getCert 338
#define SN_id_cmc_getCert "id-cmc-getCert"
#define NID_id_cmc_lraPOPWitness 337
#define SN_id_cmc_lraPOPWitness "id-cmc-lraPOPWitness"
#define NID_id_cmc_decryptedPOP 336
#define SN_id_cmc_decryptedPOP "id-cmc-decryptedPOP"
#define NID_id_cmc_encryptedPOP 335
#define SN_id_cmc_encryptedPOP "id-cmc-encryptedPOP"
#define NID_id_cmc_addExtensions 334
#define SN_id_cmc_addExtensions "id-cmc-addExtensions"
#define NID_id_cmc_recipientNonce 333
#define SN_id_cmc_recipientNonce "id-cmc-recipientNonce"
#define NID_id_cmc_senderNonce 332
#define SN_id_cmc_senderNonce "id-cmc-senderNonce"
#define NID_id_cmc_transactionId 331
#define SN_id_cmc_transactionId "id-cmc-transactionId"
#define NID_id_cmc_dataReturn 330
#define SN_id_cmc_dataReturn "id-cmc-dataReturn"
#define NID_id_cmc_identityProof 329
#define SN_id_cmc_identityProof "id-cmc-identityProof"
#define NID_id_cmc_identification 328
#define SN_id_cmc_identification "id-cmc-identification"
#define NID_id_cmc_statusInfo 327
#define SN_id_cmc_statusInfo "id-cmc-statusInfo"
#define NID_id_alg_dh_pop 326
#define SN_id_alg_dh_pop "id-alg-dh-pop"
#define NID_id_alg_dh_sig_hmac_sha1 325
#define SN_id_alg_dh_sig_hmac_sha1 "id-alg-dh-sig-hmac-sha1"
#define NID_id_alg_noSignature 324
#define SN_id_alg_noSignature "id-alg-noSignature"
#define NID_id_alg_des40 323
#define SN_id_alg_des40 "id-alg-des40"
#define NID_id_regInfo_certReq 322
#define SN_id_regInfo_certReq "id-regInfo-certReq"
#define NID_id_regInfo_utf8Pairs 321
#define SN_id_regInfo_utf8Pairs "id-regInfo-utf8Pairs"
#define SN_id_regCtrl_rsaKeyLen "id-regCtrl-rsaKeyLen"
#define SN_id_regCtrl_algId "id-regCtrl-algId"
#define NID_id_regCtrl_altCertTemplate 1258
#define SN_id_regCtrl_altCertTemplate "id-regCtrl-altCertTemplate"
#define NID_id_regCtrl_protocolEncrKey 320
#define SN_id_regCtrl_protocolEncrKey "id-regCtrl-protocolEncrKey"
#define NID_id_regCtrl_oldCertID 319
#define SN_id_regCtrl_oldCertID "id-regCtrl-oldCertID"
#define NID_id_regCtrl_pkiArchiveOptions 318
#define SN_id_regCtrl_pkiArchiveOptions "id-regCtrl-pkiArchiveOptions"
#define NID_id_regCtrl_pkiPublicationInfo 317
#define SN_id_regCtrl_pkiPublicationInfo "id-regCtrl-pkiPublicationInfo"
#define NID_id_regCtrl_authenticator 316
#define SN_id_regCtrl_authenticator "id-regCtrl-authenticator"
#define NID_id_regCtrl_regToken 315
#define SN_id_regCtrl_regToken "id-regCtrl-regToken"
#define NID_id_regInfo 314
#define SN_id_regInfo "id-regInfo"
#define NID_id_regCtrl 313
#define SN_id_regCtrl "id-regCtrl"
#define NID_id_it_crls 1257
#define SN_id_it_crls "id-it-crls"
#define SN_id_it_crlStatusList "id-it-crlStatusList"
#define NID_id_it_certProfile 1255
#define SN_id_it_certProfile "id-it-certProfile"
#define SN_id_it_rootCaCert "id-it-rootCaCert"
#define SN_id_it_certReqTemplate "id-it-certReqTemplate"
#define NID_id_it_rootCaKeyUpdate 1224
#define SN_id_it_rootCaKeyUpdate "id-it-rootCaKeyUpdate"
#define SN_id_it_caCerts "id-it-caCerts"
#define NID_id_it_suppLangTags 784
#define SN_id_it_suppLangTags "id-it-suppLangTags"
#define NID_id_it_origPKIMessage 312
#define SN_id_it_origPKIMessage "id-it-origPKIMessage"
#define NID_id_it_confirmWaitTime 311
#define SN_id_it_confirmWaitTime "id-it-confirmWaitTime"
#define NID_id_it_implicitConfirm 310
#define SN_id_it_implicitConfirm "id-it-implicitConfirm"
#define NID_id_it_revPassphrase 309
#define SN_id_it_revPassphrase "id-it-revPassphrase"
#define NID_id_it_keyPairParamRep 308
#define SN_id_it_keyPairParamRep "id-it-keyPairParamRep"
#define NID_id_it_keyPairParamReq 307
#define SN_id_it_keyPairParamReq "id-it-keyPairParamReq"
#define NID_id_it_subscriptionResponse 306
#define SN_id_it_subscriptionResponse "id-it-subscriptionResponse"
#define NID_id_it_subscriptionRequest 305
#define SN_id_it_subscriptionRequest "id-it-subscriptionRequest"
#define NID_id_it_unsupportedOIDs 304
#define SN_id_it_unsupportedOIDs "id-it-unsupportedOIDs"
#define NID_id_it_currentCRL 303
#define SN_id_it_currentCRL "id-it-currentCRL"
#define NID_id_it_caKeyUpdateInfo 302
#define SN_id_it_caKeyUpdateInfo "id-it-caKeyUpdateInfo"
#define NID_id_it_preferredSymmAlg 301
#define SN_id_it_preferredSymmAlg "id-it-preferredSymmAlg"
#define NID_id_it_encKeyPairTypes 300
#define SN_id_it_encKeyPairTypes "id-it-encKeyPairTypes"
#define NID_id_it_signKeyPairTypes 299
#define SN_id_it_signKeyPairTypes "id-it-signKeyPairTypes"
#define NID_id_it_caProtEncCert 298
#define SN_id_it_caProtEncCert "id-it-caProtEncCert"
#define NID_cmKGA 1222
#define LN_cmKGA "Certificate Management Key Generation Authority"
#define SN_cmKGA "cmKGA"
#define NID_id_kp_BrandIndicatorforMessageIdentification 1221
#define LN_id_kp_BrandIndicatorforMessageIdentification "Brand Indicator for Message Identification"
#define SN_id_kp_BrandIndicatorforMessageIdentification "id-kp-BrandIndicatorforMessageIdentification"
#define NID_id_kp_bgpsec_router 1220
#define LN_id_kp_bgpsec_router "BGPsec Router"
#define SN_id_kp_bgpsec_router "id-kp-bgpsec-router"
#define NID_cmcArchive 1219
#define LN_cmcArchive "CMC Archive Server"
#define SN_cmcArchive "cmcArchive"
#define NID_cmcRA 1132
#define LN_cmcRA "CMC Registration Authority"
#define SN_cmcRA "cmcRA"
#define NID_cmcCA 1131
#define LN_cmcCA "CMC Certificate Authority"
#define SN_cmcCA "cmcCA"
#define NID_sendProxiedOwner 1030
#define LN_sendProxiedOwner "Send Proxied Owner"
#define SN_sendProxiedOwner "sendProxiedOwner"
#define NID_sendOwner 1029
#define LN_sendOwner "Send Owner"
#define SN_sendOwner "sendOwner"
#define NID_sendProxiedRouter 1028
#define LN_sendProxiedRouter "Send Proxied Router"
#define SN_sendProxiedRouter "sendProxiedRouter"
#define NID_sendRouter 1027
#define LN_sendRouter "Send Router"
#define SN_sendRouter "sendRouter"
#define NID_sshServer 1026
#define LN_sshServer "SSH Server"
#define SN_sshServer "secureShellServer"
#define NID_sshClient 1025
#define LN_sshClient "SSH Client"
#define SN_sshClient "secureShellClient"
#define NID_capwapWTP 1024
#define LN_capwapWTP "Ctrl/Provision WAP Termination"
#define SN_capwapWTP "capwapWTP"
#define NID_capwapAC 1023
#define LN_capwapAC "Ctrl/provision WAP Access"
#define SN_capwapAC "capwapAC"
#define NID_ipsec_IKE 1022
#define LN_ipsec_IKE "ipsec Internet Key Exchange"
#define SN_ipsec_IKE "ipsecIKE"
#define NID_dvcs 297
#define LN_dvcs "dvcs"
#define SN_dvcs "DVCS"
#define NID_OCSP_sign 180
#define LN_OCSP_sign "OCSP Signing"
#define SN_OCSP_sign "OCSPSigning"
#define NID_time_stamp 133
#define LN_time_stamp "Time Stamping"
#define SN_time_stamp "timeStamping"
#define NID_ipsecUser 296
#define LN_ipsecUser "IPSec User"
#define SN_ipsecUser "ipsecUser"
#define NID_ipsecTunnel 295
#define LN_ipsecTunnel "IPSec Tunnel"
#define SN_ipsecTunnel "ipsecTunnel"
#define NID_ipsecEndSystem 294
#define LN_ipsecEndSystem "IPSec End System"
#define SN_ipsecEndSystem "ipsecEndSystem"
#define NID_email_protect 132
#define LN_email_protect "E-mail Protection"
#define SN_email_protect "emailProtection"
#define NID_code_sign 131
#define LN_code_sign "Code Signing"
#define SN_code_sign "codeSigning"
#define NID_client_auth 130
#define LN_client_auth "TLS Web Client Authentication"
#define SN_client_auth "clientAuth"
#define NID_server_auth 129
#define LN_server_auth "TLS Web Server Authentication"
#define SN_server_auth "serverAuth"
#define NID_textNotice 293
#define SN_textNotice "textNotice"
#define NID_id_qt_unotice 165
#define LN_id_qt_unotice "Policy Qualifier User Notice"
#define SN_id_qt_unotice "id-qt-unotice"
#define NID_id_qt_cps 164
#define LN_id_qt_cps "Policy Qualifier CPS"
#define SN_id_qt_cps "id-qt-cps"
#define NID_sbgp_autonomousSysNumv2 1240
#define SN_sbgp_autonomousSysNumv2 "sbgp-autonomousSysNumv2"
#define NID_sbgp_ipAddrBlockv2 1239
#define SN_sbgp_ipAddrBlockv2 "sbgp-ipAddrBlockv2"
#define NID_tlsfeature 1020
#define LN_tlsfeature "TLS Feature"
#define SN_tlsfeature "tlsfeature"
#define NID_proxyCertInfo 663
#define LN_proxyCertInfo "Proxy Certificate Information"
#define SN_proxyCertInfo "proxyCertInfo"
#define NID_sinfo_access 398
#define LN_sinfo_access "Subject Information Access"
#define SN_sinfo_access "subjectInfoAccess"
#define NID_ac_proxying 397
#define SN_ac_proxying "ac-proxying"
#define NID_sbgp_routerIdentifier 292
#define SN_sbgp_routerIdentifier "sbgp-routerIdentifier"
#define NID_sbgp_autonomousSysNum 291
#define SN_sbgp_autonomousSysNum "sbgp-autonomousSysNum"
#define NID_sbgp_ipAddrBlock 290
#define SN_sbgp_ipAddrBlock "sbgp-ipAddrBlock"
#define NID_aaControls 289
#define SN_aaControls "aaControls"
#define NID_ac_targeting 288
#define SN_ac_targeting "ac-targeting"
#define NID_ac_auditEntity 1323
#define NID_ac_auditIdentity 287
#define LN_ac_auditIdentity "X509v3 Audit Identity"
#define SN_ac_auditIdentity "ac-auditIdentity"
#define NID_qcStatements 286
#define SN_qcStatements "qcStatements"
#define NID_biometricInfo 285
#define LN_biometricInfo "Biometric Info"
#define SN_biometricInfo "biometricInfo"
#define NID_info_access 177
#define LN_info_access "Authority Information Access"
#define SN_info_access "authorityInfoAccess"
#define NID_id_mod_cmp2021_02 1253
#define SN_id_mod_cmp2021_02 "id-mod-cmp2021-02"
#define NID_id_mod_cmp2021_88 1252
#define SN_id_mod_cmp2021_88 "id-mod-cmp2021-88"
#define NID_id_mod_cmp2000_02 1251
#define SN_id_mod_cmp2000_02 "id-mod-cmp2000-02"
#define NID_id_mod_cmp2000 284
#define SN_id_mod_cmp2000 "id-mod-cmp2000"
#define NID_id_mod_dvcs 283
#define SN_id_mod_dvcs "id-mod-dvcs"
#define NID_id_mod_ocsp 282
#define SN_id_mod_ocsp "id-mod-ocsp"
#define NID_id_mod_timestamp_protocol 281
#define SN_id_mod_timestamp_protocol "id-mod-timestamp-protocol"
#define NID_id_mod_attribute_cert 280
#define SN_id_mod_attribute_cert "id-mod-attribute-cert"
#define NID_id_mod_qualified_cert_93 279
#define SN_id_mod_qualified_cert_93 "id-mod-qualified-cert-93"
#define NID_id_mod_qualified_cert_88 278
#define SN_id_mod_qualified_cert_88 "id-mod-qualified-cert-88"
#define NID_id_mod_cmp 277
#define SN_id_mod_cmp "id-mod-cmp"
#define NID_id_mod_kea_profile_93 276
#define SN_id_mod_kea_profile_93 "id-mod-kea-profile-93"
#define NID_id_mod_kea_profile_88 275
#define SN_id_mod_kea_profile_88 "id-mod-kea-profile-88"
#define NID_id_mod_cmc 274
#define SN_id_mod_cmc "id-mod-cmc"
#define NID_id_mod_crmf 273
#define SN_id_mod_crmf "id-mod-crmf"
#define NID_id_pkix1_implicit_93 272
#define SN_id_pkix1_implicit_93 "id-pkix1-implicit-93"
#define NID_id_pkix1_explicit_93 271
#define SN_id_pkix1_explicit_93 "id-pkix1-explicit-93"
#define NID_id_pkix1_implicit_88 270
#define SN_id_pkix1_implicit_88 "id-pkix1-implicit-88"
#define NID_id_pkix1_explicit_88 269
#define SN_id_pkix1_explicit_88 "id-pkix1-explicit-88"
#define NID_id_ad 176
#define SN_id_ad "id-ad"
#define NID_id_ppl 662
#define SN_id_ppl "id-ppl"
#define NID_id_cct 268
#define SN_id_cct "id-cct"
#define NID_id_cp 1238
#define SN_id_cp "id-cp"
#define NID_id_qcs 267
#define SN_id_qcs "id-qcs"
#define NID_id_aca 266
#define SN_id_aca "id-aca"
#define NID_id_pda 265
#define SN_id_pda "id-pda"
#define NID_id_on 264
#define SN_id_on "id-on"
#define NID_id_cmc 263
#define SN_id_cmc "id-cmc"
#define NID_id_alg 262
#define SN_id_alg "id-alg"
#define NID_id_pkip 261
#define SN_id_pkip "id-pkip"
#define NID_id_it 260
#define SN_id_it "id-it"
#define NID_id_kp 128
#define SN_id_kp "id-kp"
#define NID_id_qt 259
#define SN_id_qt "id-qt"
#define NID_id_pe 175
#define SN_id_pe "id-pe"
#define NID_id_pkix_mod 258
#define SN_id_pkix_mod "id-pkix-mod"
#define NID_id_pkix 127
#define SN_id_pkix "PKIX"
#define NID_bf_ofb64 94
#define LN_bf_ofb64 "bf-ofb"
#define SN_bf_ofb64 "BF-OFB"
#define NID_bf_cfb64 93
#define LN_bf_cfb64 "bf-cfb"
#define SN_bf_cfb64 "BF-CFB"
#define NID_bf_ecb 92
#define LN_bf_ecb "bf-ecb"
#define SN_bf_ecb "BF-ECB"
#define NID_bf_cbc 91
#define LN_bf_cbc "bf-cbc"
#define SN_bf_cbc "BF-CBC"
#define NID_idea_ofb64 46
#define LN_idea_ofb64 "idea-ofb"
#define SN_idea_ofb64 "IDEA-OFB"
#define NID_idea_cfb64 35
#define LN_idea_cfb64 "idea-cfb"
#define SN_idea_cfb64 "IDEA-CFB"
#define NID_idea_ecb 36
#define LN_idea_ecb "idea-ecb"
#define SN_idea_ecb "IDEA-ECB"
#define NID_idea_cbc 34
#define LN_idea_cbc "idea-cbc"
#define SN_idea_cbc "IDEA-CBC"
#define NID_ms_app_policies 1294
#define LN_ms_app_policies "Microsoft Application Policies Extension"
#define SN_ms_app_policies "ms-app-policies"
#define NID_ms_cert_templ 1293
#define LN_ms_cert_templ "Microsoft certificate template"
#define SN_ms_cert_templ "ms-cert-templ"
#define NID_ms_ntds_obj_sid 1291
#define LN_ms_ntds_obj_sid "Microsoft NTDS AD objectSid"
#define SN_ms_ntds_obj_sid "ms-ntds-obj-sid"
#define NID_ms_ntds_sec_ext 1292
#define LN_ms_ntds_sec_ext "Microsoft NTDS CA Extension"
#define SN_ms_ntds_sec_ext "ms-ntds-sec-ext"
#define NID_ms_upn 649
#define LN_ms_upn "Microsoft User Principal Name"
#define SN_ms_upn "msUPN"
#define NID_ms_smartcard_login 648
#define LN_ms_smartcard_login "Microsoft Smartcard Login"
#define SN_ms_smartcard_login "msSmartcardLogin"
#define NID_ms_efs 138
#define LN_ms_efs "Microsoft Encrypted File System"
#define SN_ms_efs "msEFS"
#define NID_ms_sgc 137
#define LN_ms_sgc "Microsoft Server Gated Crypto"
#define SN_ms_sgc "msSGC"
#define NID_ms_ctl_sign 136
#define LN_ms_ctl_sign "Microsoft Trust List Signing"
#define SN_ms_ctl_sign "msCTLSign"
#define NID_ms_code_com 135
#define LN_ms_code_com "Microsoft Commercial Code Signing"
#define SN_ms_code_com "msCodeCom"
#define NID_ms_code_ind 134
#define LN_ms_code_ind "Microsoft Individual Code Signing"
#define SN_ms_code_ind "msCodeInd"
#define NID_ms_ext_req 171
#define LN_ms_ext_req "Microsoft Extension Request"
#define SN_ms_ext_req "msExtReq"
#define NID_rc5_ofb64 123
#define LN_rc5_ofb64 "rc5-ofb"
#define SN_rc5_ofb64 "RC5-OFB"
#define NID_rc5_cfb64 122
#define LN_rc5_cfb64 "rc5-cfb"
#define SN_rc5_cfb64 "RC5-CFB"
#define NID_rc5_ecb 121
#define LN_rc5_ecb "rc5-ecb"
#define SN_rc5_ecb "RC5-ECB"
#define NID_rc5_cbc 120
#define LN_rc5_cbc "rc5-cbc"
#define SN_rc5_cbc "RC5-CBC"
#define NID_des_ede3_cbc 44
#define LN_des_ede3_cbc "des-ede3-cbc"
#define SN_des_ede3_cbc "DES-EDE3-CBC"
#define NID_rc4_40 97
#define LN_rc4_40 "rc4-40"
#define SN_rc4_40 "RC4-40"
#define NID_rc4 5
#define LN_rc4 "rc4"
#define SN_rc4 "RC4"
#define NID_rc2_64_cbc 166
#define LN_rc2_64_cbc "rc2-64-cbc"
#define SN_rc2_64_cbc "RC2-64-CBC"
#define NID_rc2_40_cbc 98
#define LN_rc2_40_cbc "rc2-40-cbc"
#define SN_rc2_40_cbc "RC2-40-CBC"
#define NID_rc2_ofb64 40
#define LN_rc2_ofb64 "rc2-ofb"
#define SN_rc2_ofb64 "RC2-OFB"
#define NID_rc2_cfb64 39
#define LN_rc2_cfb64 "rc2-cfb"
#define SN_rc2_cfb64 "RC2-CFB"
#define NID_rc2_ecb 38
#define LN_rc2_ecb "rc2-ecb"
#define SN_rc2_ecb "RC2-ECB"
#define NID_rc2_cbc 37
#define LN_rc2_cbc "rc2-cbc"
#define SN_rc2_cbc "RC2-CBC"
#define NID_hmacWithSHA512_256 1194
#define LN_hmacWithSHA512_256 "hmacWithSHA512-256"
#define NID_hmacWithSHA512_224 1193
#define LN_hmacWithSHA512_224 "hmacWithSHA512-224"
#define NID_hmacWithSHA512 801
#define LN_hmacWithSHA512 "hmacWithSHA512"
#define NID_hmacWithSHA384 800
#define LN_hmacWithSHA384 "hmacWithSHA384"
#define NID_hmacWithSHA256 799
#define LN_hmacWithSHA256 "hmacWithSHA256"
#define NID_hmacWithSHA224 798
#define LN_hmacWithSHA224 "hmacWithSHA224"
#define NID_hmacWithSM3 1281
#define LN_hmacWithSM3 "hmacWithSM3"
#define NID_SM2_with_SM3 1204
#define LN_SM2_with_SM3 "SM2-with-SM3"
#define SN_SM2_with_SM3 "SM2-SM3"
#define NID_sm3WithRSAEncryption 1144
#define LN_sm3WithRSAEncryption "sm3WithRSAEncryption"
#define SN_sm3WithRSAEncryption "RSA-SM3"
#define NID_sm3 1143
#define LN_sm3 "sm3"
#define SN_sm3 "SM3"
#define NID_sm2 1172
#define LN_sm2 "sm2"
#define SN_sm2 "SM2"
#define NID_hmacWithSHA1 163
#define LN_hmacWithSHA1 "hmacWithSHA1"
#define NID_hmacWithMD5 797
#define LN_hmacWithMD5 "hmacWithMD5"
#define NID_md5_sha1 114
#define LN_md5_sha1 "md5-sha1"
#define SN_md5_sha1 "MD5-SHA1"
#define NID_md5 4
#define LN_md5 "md5"
#define SN_md5 "MD5"
#define NID_md4 257
#define LN_md4 "md4"
#define SN_md4 "MD4"
#define NID_md2 3
#define LN_md2 "md2"
#define SN_md2 "MD2"
#define NID_safeContentsBag 155
#define LN_safeContentsBag "safeContentsBag"
#define NID_secretBag 154
#define LN_secretBag "secretBag"
#define NID_crlBag 153
#define LN_crlBag "crlBag"
#define NID_certBag 152
#define LN_certBag "certBag"
#define NID_pkcs8ShroudedKeyBag 151
#define LN_pkcs8ShroudedKeyBag "pkcs8ShroudedKeyBag"
#define NID_keyBag 150
#define LN_keyBag "keyBag"
#define NID_pbe_WithSHA1And40BitRC2_CBC 149
#define LN_pbe_WithSHA1And40BitRC2_CBC "pbeWithSHA1And40BitRC2-CBC"
#define SN_pbe_WithSHA1And40BitRC2_CBC "PBE-SHA1-RC2-40"
#define NID_pbe_WithSHA1And128BitRC2_CBC 148
#define LN_pbe_WithSHA1And128BitRC2_CBC "pbeWithSHA1And128BitRC2-CBC"
#define SN_pbe_WithSHA1And128BitRC2_CBC "PBE-SHA1-RC2-128"
#define NID_pbe_WithSHA1And2_Key_TripleDES_CBC 147
#define LN_pbe_WithSHA1And2_Key_TripleDES_CBC "pbeWithSHA1And2-KeyTripleDES-CBC"
#define SN_pbe_WithSHA1And2_Key_TripleDES_CBC "PBE-SHA1-2DES"
#define NID_pbe_WithSHA1And3_Key_TripleDES_CBC 146
#define LN_pbe_WithSHA1And3_Key_TripleDES_CBC "pbeWithSHA1And3-KeyTripleDES-CBC"
#define SN_pbe_WithSHA1And3_Key_TripleDES_CBC "PBE-SHA1-3DES"
#define NID_pbe_WithSHA1And40BitRC4 145
#define LN_pbe_WithSHA1And40BitRC4 "pbeWithSHA1And40BitRC4"
#define SN_pbe_WithSHA1And40BitRC4 "PBE-SHA1-RC4-40"
#define NID_pbe_WithSHA1And128BitRC4 144
#define LN_pbe_WithSHA1And128BitRC4 "pbeWithSHA1And128BitRC4"
#define SN_pbe_WithSHA1And128BitRC4 "PBE-SHA1-RC4-128"
#define NID_id_aa_CMSAlgorithmProtection 1263
#define SN_id_aa_CMSAlgorithmProtection "id-aa-CMSAlgorithmProtection"
#define NID_x509Crl 160
#define LN_x509Crl "x509Crl"
#define NID_sdsiCertificate 159
#define LN_sdsiCertificate "sdsiCertificate"
#define NID_x509Certificate 158
#define LN_x509Certificate "x509Certificate"
#define NID_LocalKeySet 856
#define LN_LocalKeySet "Microsoft Local Key set"
#define SN_LocalKeySet "LocalKeySet"
#define NID_ms_csp_name 417
#define LN_ms_csp_name "Microsoft CSP Name"
#define SN_ms_csp_name "CSPName"
#define NID_localKeyID 157
#define LN_localKeyID "localKeyID"
#define NID_friendlyName 156
#define LN_friendlyName "friendlyName"
#define NID_id_smime_cti_ets_proofOfCreation 256
#define SN_id_smime_cti_ets_proofOfCreation "id-smime-cti-ets-proofOfCreation"
#define NID_id_smime_cti_ets_proofOfApproval 255
#define SN_id_smime_cti_ets_proofOfApproval "id-smime-cti-ets-proofOfApproval"
#define NID_id_smime_cti_ets_proofOfSender 254
#define SN_id_smime_cti_ets_proofOfSender "id-smime-cti-ets-proofOfSender"
#define NID_id_smime_cti_ets_proofOfDelivery 253
#define SN_id_smime_cti_ets_proofOfDelivery "id-smime-cti-ets-proofOfDelivery"
#define NID_id_smime_cti_ets_proofOfReceipt 252
#define SN_id_smime_cti_ets_proofOfReceipt "id-smime-cti-ets-proofOfReceipt"
#define NID_id_smime_cti_ets_proofOfOrigin 251
#define SN_id_smime_cti_ets_proofOfOrigin "id-smime-cti-ets-proofOfOrigin"
#define NID_id_smime_spq_ets_sqt_unotice 250
#define SN_id_smime_spq_ets_sqt_unotice "id-smime-spq-ets-sqt-unotice"
#define NID_id_smime_spq_ets_sqt_uri 249
#define SN_id_smime_spq_ets_sqt_uri "id-smime-spq-ets-sqt-uri"
#define NID_id_smime_cd_ldap 248
#define SN_id_smime_cd_ldap "id-smime-cd-ldap"
#define NID_id_alg_PWRI_KEK 893
#define SN_id_alg_PWRI_KEK "id-alg-PWRI-KEK"
#define NID_id_smime_alg_CMSRC2wrap 247
#define SN_id_smime_alg_CMSRC2wrap "id-smime-alg-CMSRC2wrap"
#define NID_id_smime_alg_CMS3DESwrap 246
#define SN_id_smime_alg_CMS3DESwrap "id-smime-alg-CMS3DESwrap"
#define NID_id_smime_alg_ESDH 245
#define SN_id_smime_alg_ESDH "id-smime-alg-ESDH"
#define NID_id_smime_alg_RC2wrap 244
#define SN_id_smime_alg_RC2wrap "id-smime-alg-RC2wrap"
#define NID_id_smime_alg_3DESwrap 243
#define SN_id_smime_alg_3DESwrap "id-smime-alg-3DESwrap"
#define NID_id_smime_alg_ESDHwithRC2 242
#define SN_id_smime_alg_ESDHwithRC2 "id-smime-alg-ESDHwithRC2"
#define NID_id_smime_alg_ESDHwith3DES 241
#define SN_id_smime_alg_ESDHwith3DES "id-smime-alg-ESDHwith3DES"
#define NID_id_aa_ets_archiveTimestampV2 1280
#define SN_id_aa_ets_archiveTimestampV2 "id-aa-ets-archiveTimestampV2"
#define NID_id_smime_aa_signingCertificateV2 1086
#define SN_id_smime_aa_signingCertificateV2 "id-smime-aa-signingCertificateV2"
#define NID_id_aa_ets_attrRevocationRefs 1262
#define SN_id_aa_ets_attrRevocationRefs "id-aa-ets-attrRevocationRefs"
#define NID_id_aa_ets_attrCertificateRefs 1261
#define SN_id_aa_ets_attrCertificateRefs "id-aa-ets-attrCertificateRefs"
#define NID_id_smime_aa_dvcs_dvc 240
#define SN_id_smime_aa_dvcs_dvc "id-smime-aa-dvcs-dvc"
#define NID_id_smime_aa_signatureType 239
#define SN_id_smime_aa_signatureType "id-smime-aa-signatureType"
#define NID_id_smime_aa_ets_archiveTimeStamp 238
#define SN_id_smime_aa_ets_archiveTimeStamp "id-smime-aa-ets-archiveTimeStamp"
#define NID_id_smime_aa_ets_certCRLTimestamp 237
#define SN_id_smime_aa_ets_certCRLTimestamp "id-smime-aa-ets-certCRLTimestamp"
#define NID_id_smime_aa_ets_escTimeStamp 236
#define SN_id_smime_aa_ets_escTimeStamp "id-smime-aa-ets-escTimeStamp"
#define NID_id_smime_aa_ets_revocationValues 235
#define SN_id_smime_aa_ets_revocationValues "id-smime-aa-ets-revocationValues"
#define NID_id_smime_aa_ets_certValues 234
#define SN_id_smime_aa_ets_certValues "id-smime-aa-ets-certValues"
#define NID_id_smime_aa_ets_RevocationRefs 233
#define SN_id_smime_aa_ets_RevocationRefs "id-smime-aa-ets-RevocationRefs"
#define NID_id_smime_aa_ets_CertificateRefs 232
#define SN_id_smime_aa_ets_CertificateRefs "id-smime-aa-ets-CertificateRefs"
#define NID_id_smime_aa_ets_contentTimestamp 231
#define SN_id_smime_aa_ets_contentTimestamp "id-smime-aa-ets-contentTimestamp"
#define NID_id_smime_aa_ets_otherSigCert 230
#define SN_id_smime_aa_ets_otherSigCert "id-smime-aa-ets-otherSigCert"
#define NID_id_smime_aa_ets_signerAttr 229
#define SN_id_smime_aa_ets_signerAttr "id-smime-aa-ets-signerAttr"
#define NID_id_smime_aa_ets_signerLocation 228
#define SN_id_smime_aa_ets_signerLocation "id-smime-aa-ets-signerLocation"
#define NID_id_smime_aa_ets_commitmentType 227
#define SN_id_smime_aa_ets_commitmentType "id-smime-aa-ets-commitmentType"
#define NID_id_smime_aa_ets_sigPolicyId 226
#define SN_id_smime_aa_ets_sigPolicyId "id-smime-aa-ets-sigPolicyId"
#define NID_id_smime_aa_timeStampToken 225
#define SN_id_smime_aa_timeStampToken "id-smime-aa-timeStampToken"
#define NID_id_smime_aa_smimeEncryptCerts 224
#define SN_id_smime_aa_smimeEncryptCerts "id-smime-aa-smimeEncryptCerts"
#define NID_id_smime_aa_signingCertificate 223
#define SN_id_smime_aa_signingCertificate "id-smime-aa-signingCertificate"
#define NID_id_smime_aa_encrypKeyPref 222
#define SN_id_smime_aa_encrypKeyPref "id-smime-aa-encrypKeyPref"
#define NID_id_smime_aa_contentReference 221
#define SN_id_smime_aa_contentReference "id-smime-aa-contentReference"
#define NID_id_smime_aa_equivalentLabels 220
#define SN_id_smime_aa_equivalentLabels "id-smime-aa-equivalentLabels"
#define NID_id_smime_aa_macValue 219
#define SN_id_smime_aa_macValue "id-smime-aa-macValue"
#define NID_id_smime_aa_contentIdentifier 218
#define SN_id_smime_aa_contentIdentifier "id-smime-aa-contentIdentifier"
#define NID_id_smime_aa_encapContentType 217
#define SN_id_smime_aa_encapContentType "id-smime-aa-encapContentType"
#define NID_id_smime_aa_msgSigDigest 216
#define SN_id_smime_aa_msgSigDigest "id-smime-aa-msgSigDigest"
#define NID_id_smime_aa_contentHint 215
#define SN_id_smime_aa_contentHint "id-smime-aa-contentHint"
#define NID_id_smime_aa_mlExpandHistory 214
#define SN_id_smime_aa_mlExpandHistory "id-smime-aa-mlExpandHistory"
#define NID_id_smime_aa_securityLabel 213
#define SN_id_smime_aa_securityLabel "id-smime-aa-securityLabel"
#define NID_id_smime_aa_receiptRequest 212
#define SN_id_smime_aa_receiptRequest "id-smime-aa-receiptRequest"
#define NID_id_ct_rpkiSignedPrefixList 1320
#define SN_id_ct_rpkiSignedPrefixList "id-ct-rpkiSignedPrefixList"
#define NID_id_ct_signedTAL 1284
#define SN_id_ct_signedTAL "id-ct-signedTAL"
#define NID_id_ct_ASPA 1250
#define SN_id_ct_ASPA "id-ct-ASPA"
#define NID_id_ct_signedChecklist 1247
#define SN_id_ct_signedChecklist "id-ct-signedChecklist"
#define NID_id_ct_geofeedCSVwithCRLF 1246
#define SN_id_ct_geofeedCSVwithCRLF "id-ct-geofeedCSVwithCRLF"
#define NID_id_ct_resourceTaggedAttest 1237
#define SN_id_ct_resourceTaggedAttest "id-ct-resourceTaggedAttest"
#define NID_id_ct_rpkiGhostbusters 1236
#define SN_id_ct_rpkiGhostbusters "id-ct-rpkiGhostbusters"
#define NID_id_ct_xml 1060
#define SN_id_ct_xml "id-ct-xml"
#define NID_id_ct_asciiTextWithCRLF 787
#define SN_id_ct_asciiTextWithCRLF "id-ct-asciiTextWithCRLF"
#define NID_id_ct_rpkiManifest 1235
#define SN_id_ct_rpkiManifest "id-ct-rpkiManifest"
#define NID_id_ct_routeOriginAuthz 1234
#define SN_id_ct_routeOriginAuthz "id-ct-routeOriginAuthz"
#define NID_id_smime_ct_authEnvelopedData 1059
#define SN_id_smime_ct_authEnvelopedData "id-smime-ct-authEnvelopedData"
#define NID_id_smime_ct_contentCollection 1058
#define SN_id_smime_ct_contentCollection "id-smime-ct-contentCollection"
#define NID_id_smime_ct_compressedData 786
#define SN_id_smime_ct_compressedData "id-smime-ct-compressedData"
#define NID_id_smime_ct_DVCSResponseData 211
#define SN_id_smime_ct_DVCSResponseData "id-smime-ct-DVCSResponseData"
#define NID_id_smime_ct_DVCSRequestData 210
#define SN_id_smime_ct_DVCSRequestData "id-smime-ct-DVCSRequestData"
#define NID_id_smime_ct_contentInfo 209
#define SN_id_smime_ct_contentInfo "id-smime-ct-contentInfo"
#define NID_id_smime_ct_TDTInfo 208
#define SN_id_smime_ct_TDTInfo "id-smime-ct-TDTInfo"
#define NID_id_smime_ct_TSTInfo 207
#define SN_id_smime_ct_TSTInfo "id-smime-ct-TSTInfo"
#define NID_id_smime_ct_publishCert 206
#define SN_id_smime_ct_publishCert "id-smime-ct-publishCert"
#define NID_id_smime_ct_authData 205
#define SN_id_smime_ct_authData "id-smime-ct-authData"
#define NID_id_smime_ct_receipt 204
#define SN_id_smime_ct_receipt "id-smime-ct-receipt"
#define NID_id_smime_mod_ets_eSigPolicy_97 203
#define SN_id_smime_mod_ets_eSigPolicy_97 "id-smime-mod-ets-eSigPolicy-97"
#define NID_id_smime_mod_ets_eSigPolicy_88 202
#define SN_id_smime_mod_ets_eSigPolicy_88 "id-smime-mod-ets-eSigPolicy-88"
#define NID_id_smime_mod_ets_eSignature_97 201
#define SN_id_smime_mod_ets_eSignature_97 "id-smime-mod-ets-eSignature-97"
#define NID_id_smime_mod_ets_eSignature_88 200
#define SN_id_smime_mod_ets_eSignature_88 "id-smime-mod-ets-eSignature-88"
#define NID_id_smime_mod_msg_v3 199
#define SN_id_smime_mod_msg_v3 "id-smime-mod-msg-v3"
#define NID_id_smime_mod_oid 198
#define SN_id_smime_mod_oid "id-smime-mod-oid"
#define NID_id_smime_mod_ess 197
#define SN_id_smime_mod_ess "id-smime-mod-ess"
#define NID_id_smime_mod_cms 196
#define SN_id_smime_mod_cms "id-smime-mod-cms"
#define NID_id_smime_cti 195
#define SN_id_smime_cti "id-smime-cti"
#define NID_id_smime_spq 194
#define SN_id_smime_spq "id-smime-spq"
#define NID_id_smime_cd 193
#define SN_id_smime_cd "id-smime-cd"
#define NID_id_smime_alg 192
#define SN_id_smime_alg "id-smime-alg"
#define NID_id_smime_aa 191
#define SN_id_smime_aa "id-smime-aa"
#define NID_id_smime_ct 190
#define SN_id_smime_ct "id-smime-ct"
#define NID_id_smime_mod 189
#define SN_id_smime_mod "id-smime-mod"
#define NID_SMIME 188
#define LN_SMIME "S/MIME"
#define SN_SMIME "SMIME"
#define NID_SMIMECapabilities 167
#define LN_SMIMECapabilities "S/MIME Capabilities"
#define SN_SMIMECapabilities "SMIME-CAPS"
#define NID_ext_req 172
#define LN_ext_req "Extension Request"
#define SN_ext_req "extReq"
#define NID_pkcs9_extCertAttributes 56
#define LN_pkcs9_extCertAttributes "extendedCertificateAttributes"
#define NID_pkcs9_unstructuredAddress 55
#define LN_pkcs9_unstructuredAddress "unstructuredAddress"
#define NID_pkcs9_challengePassword 54
#define LN_pkcs9_challengePassword "challengePassword"
#define NID_pkcs9_countersignature 53
#define LN_pkcs9_countersignature "countersignature"
#define NID_pkcs9_signingTime 52
#define LN_pkcs9_signingTime "signingTime"
#define NID_pkcs9_messageDigest 51
#define LN_pkcs9_messageDigest "messageDigest"
#define NID_pkcs9_contentType 50
#define LN_pkcs9_contentType "contentType"
#define NID_pkcs9_unstructuredName 49
#define LN_pkcs9_unstructuredName "unstructuredName"
#define LN_pkcs9_emailAddress "emailAddress"
#define NID_pkcs9 47
#define SN_pkcs9 "pkcs9"
#define NID_pkcs7_encrypted 26
#define LN_pkcs7_encrypted "pkcs7-encryptedData"
#define NID_pkcs7_digest 25
#define LN_pkcs7_digest "pkcs7-digestData"
#define NID_pkcs7_signedAndEnveloped 24
#define LN_pkcs7_signedAndEnveloped "pkcs7-signedAndEnvelopedData"
#define NID_pkcs7_enveloped 23
#define LN_pkcs7_enveloped "pkcs7-envelopedData"
#define LN_pkcs7_signed "pkcs7-signedData"
#define LN_pkcs7_data "pkcs7-data"
#define NID_pkcs7 20
#define SN_pkcs7 "pkcs7"
#define NID_pbmac1 162
#define LN_pbmac1 "PBMAC1"
#define NID_pbes2 161
#define LN_pbes2 "PBES2"
#define NID_id_pbkdf2 69
#define LN_id_pbkdf2 "PBKDF2"
#define NID_pbeWithSHA1AndRC2_CBC 68
#define LN_pbeWithSHA1AndRC2_CBC "pbeWithSHA1AndRC2-CBC"
#define SN_pbeWithSHA1AndRC2_CBC "PBE-SHA1-RC2-64"
#define NID_pbeWithSHA1AndDES_CBC 170
#define LN_pbeWithSHA1AndDES_CBC "pbeWithSHA1AndDES-CBC"
#define SN_pbeWithSHA1AndDES_CBC "PBE-SHA1-DES"
#define NID_pbeWithMD5AndRC2_CBC 169
#define LN_pbeWithMD5AndRC2_CBC "pbeWithMD5AndRC2-CBC"
#define SN_pbeWithMD5AndRC2_CBC "PBE-MD5-RC2-64"
#define NID_pbeWithMD2AndRC2_CBC 168
#define LN_pbeWithMD2AndRC2_CBC "pbeWithMD2AndRC2-CBC"
#define SN_pbeWithMD2AndRC2_CBC "PBE-MD2-RC2-64"
#define NID_pbeWithMD5AndDES_CBC 10
#define LN_pbeWithMD5AndDES_CBC "pbeWithMD5AndDES-CBC"
#define SN_pbeWithMD5AndDES_CBC "PBE-MD5-DES"
#define NID_pbeWithMD2AndDES_CBC 9
#define LN_pbeWithMD2AndDES_CBC "pbeWithMD2AndDES-CBC"
#define SN_pbeWithMD2AndDES_CBC "PBE-MD2-DES"
#define NID_pkcs5 187
#define SN_pkcs5 "pkcs5"
#define NID_dhKeyAgreement 28
#define LN_dhKeyAgreement "dhKeyAgreement"
#define NID_pkcs3 27
#define SN_pkcs3 "pkcs3"
#define NID_sha512_256WithRSAEncryption 1146
#define LN_sha512_256WithRSAEncryption "sha512-256WithRSAEncryption"
#define SN_sha512_256WithRSAEncryption "RSA-SHA512/256"
#define NID_sha512_224WithRSAEncryption 1145
#define LN_sha512_224WithRSAEncryption "sha512-224WithRSAEncryption"
#define SN_sha512_224WithRSAEncryption "RSA-SHA512/224"
#define NID_sha224WithRSAEncryption 671
#define LN_sha224WithRSAEncryption "sha224WithRSAEncryption"
#define SN_sha224WithRSAEncryption "RSA-SHA224"
#define NID_sha512WithRSAEncryption 670
#define LN_sha512WithRSAEncryption "sha512WithRSAEncryption"
#define SN_sha512WithRSAEncryption "RSA-SHA512"
#define NID_sha384WithRSAEncryption 669
#define LN_sha384WithRSAEncryption "sha384WithRSAEncryption"
#define SN_sha384WithRSAEncryption "RSA-SHA384"
#define NID_sha256WithRSAEncryption 668
#define LN_sha256WithRSAEncryption "sha256WithRSAEncryption"
#define SN_sha256WithRSAEncryption "RSA-SHA256"
#define NID_rsassaPss 912
#define LN_rsassaPss "rsassaPss"
#define SN_rsassaPss "RSASSA-PSS"
#define NID_pSpecified 935
#define LN_pSpecified "pSpecified"
#define SN_pSpecified "PSPECIFIED"
#define NID_mgf1 911
#define LN_mgf1 "mgf1"
#define SN_mgf1 "MGF1"
#define NID_rsaesOaep 919
#define LN_rsaesOaep "rsaesOaep"
#define SN_rsaesOaep "RSAES-OAEP"
#define NID_sha1WithRSAEncryption 65
#define LN_sha1WithRSAEncryption "sha1WithRSAEncryption"
#define SN_sha1WithRSAEncryption "RSA-SHA1"
#define NID_md5WithRSAEncryption 8
#define LN_md5WithRSAEncryption "md5WithRSAEncryption"
#define SN_md5WithRSAEncryption "RSA-MD5"
#define NID_md4WithRSAEncryption 396
#define LN_md4WithRSAEncryption "md4WithRSAEncryption"
#define SN_md4WithRSAEncryption "RSA-MD4"
#define NID_md2WithRSAEncryption 7
#define LN_md2WithRSAEncryption "md2WithRSAEncryption"
#define SN_md2WithRSAEncryption "RSA-MD2"
#define NID_rsaEncryption 6
#define LN_rsaEncryption "rsaEncryption"
#define NID_pkcs1 186
#define SN_pkcs1 "pkcs1"
#define NID_pkcs 2
#define LN_pkcs "RSA Data Security, Inc. PKCS"
#define SN_pkcs "pkcs"
#define NID_rsadsi 1
#define LN_rsadsi "RSA Data Security, Inc."
#define SN_rsadsi "rsadsi"
#define NID_id_DHBasedMac 783
#define LN_id_DHBasedMac "Diffie-Hellman based MAC"
#define SN_id_DHBasedMac "id-DHBasedMac"
#define NID_id_PasswordBasedMAC 782
#define LN_id_PasswordBasedMAC "password based MAC"
#define SN_id_PasswordBasedMAC "id-PasswordBasedMAC"
#define NID_pbeWithMD5AndCast5_CBC 112
#define LN_pbeWithMD5AndCast5_CBC "pbeWithMD5AndCast5CBC"
#define NID_cast5_ofb64 111
#define LN_cast5_ofb64 "cast5-ofb"
#define SN_cast5_ofb64 "CAST5-OFB"
#define NID_cast5_cfb64 110
#define LN_cast5_cfb64 "cast5-cfb"
#define SN_cast5_cfb64 "CAST5-CFB"
#define NID_cast5_ecb 109
#define LN_cast5_ecb "cast5-ecb"
#define SN_cast5_ecb "CAST5-ECB"
#define NID_cast5_cbc 108
#define LN_cast5_cbc "cast5-cbc"
#define SN_cast5_cbc "CAST5-CBC"
#define NID_wap_wsg_idm_ecid_wtls12 745
#define SN_wap_wsg_idm_ecid_wtls12 "wap-wsg-idm-ecid-wtls12"
#define NID_wap_wsg_idm_ecid_wtls11 744
#define SN_wap_wsg_idm_ecid_wtls11 "wap-wsg-idm-ecid-wtls11"
#define NID_wap_wsg_idm_ecid_wtls10 743
#define SN_wap_wsg_idm_ecid_wtls10 "wap-wsg-idm-ecid-wtls10"
#define NID_wap_wsg_idm_ecid_wtls9 742
#define SN_wap_wsg_idm_ecid_wtls9 "wap-wsg-idm-ecid-wtls9"
#define NID_wap_wsg_idm_ecid_wtls8 741
#define SN_wap_wsg_idm_ecid_wtls8 "wap-wsg-idm-ecid-wtls8"
#define NID_wap_wsg_idm_ecid_wtls7 740
#define SN_wap_wsg_idm_ecid_wtls7 "wap-wsg-idm-ecid-wtls7"
#define NID_wap_wsg_idm_ecid_wtls6 739
#define SN_wap_wsg_idm_ecid_wtls6 "wap-wsg-idm-ecid-wtls6"
#define NID_wap_wsg_idm_ecid_wtls5 738
#define SN_wap_wsg_idm_ecid_wtls5 "wap-wsg-idm-ecid-wtls5"
#define NID_wap_wsg_idm_ecid_wtls4 737
#define SN_wap_wsg_idm_ecid_wtls4 "wap-wsg-idm-ecid-wtls4"
#define NID_wap_wsg_idm_ecid_wtls3 736
#define SN_wap_wsg_idm_ecid_wtls3 "wap-wsg-idm-ecid-wtls3"
#define NID_wap_wsg_idm_ecid_wtls1 735
#define SN_wap_wsg_idm_ecid_wtls1 "wap-wsg-idm-ecid-wtls1"
#define NID_sect571r1 734
#define SN_sect571r1 "sect571r1"
#define NID_sect571k1 733
#define SN_sect571k1 "sect571k1"
#define NID_sect409r1 732
#define SN_sect409r1 "sect409r1"
#define NID_sect409k1 731
#define SN_sect409k1 "sect409k1"
#define NID_sect283r1 730
#define SN_sect283r1 "sect283r1"
#define NID_sect283k1 729
#define SN_sect283k1 "sect283k1"
#define NID_sect239k1 728
#define SN_sect239k1 "sect239k1"
#define NID_sect233r1 727
#define SN_sect233r1 "sect233r1"
#define NID_sect233k1 726
#define SN_sect233k1 "sect233k1"
#define NID_sect193r2 725
#define SN_sect193r2 "sect193r2"
#define NID_sect193r1 724
#define SN_sect193r1 "sect193r1"
#define NID_sect163r2 723
#define SN_sect163r2 "sect163r2"
#define NID_sect163r1 722
#define SN_sect163r1 "sect163r1"
#define NID_sect163k1 721
#define SN_sect163k1 "sect163k1"
#define NID_sect131r2 720
#define SN_sect131r2 "sect131r2"
#define NID_sect131r1 719
#define SN_sect131r1 "sect131r1"
#define NID_sect113r2 718
#define SN_sect113r2 "sect113r2"
#define NID_sect113r1 717
#define SN_sect113r1 "sect113r1"
#define NID_secp521r1 716
#define SN_secp521r1 "secp521r1"
#define NID_secp384r1 715
#define SN_secp384r1 "secp384r1"
#define NID_secp256k1 714
#define SN_secp256k1 "secp256k1"
#define NID_secp224r1 713
#define SN_secp224r1 "secp224r1"
#define NID_secp224k1 712
#define SN_secp224k1 "secp224k1"
#define NID_secp192k1 711
#define SN_secp192k1 "secp192k1"
#define NID_secp160r2 710
#define SN_secp160r2 "secp160r2"
#define NID_secp160r1 709
#define SN_secp160r1 "secp160r1"
#define NID_secp160k1 708
#define SN_secp160k1 "secp160k1"
#define NID_secp128r2 707
#define SN_secp128r2 "secp128r2"
#define NID_secp128r1 706
#define SN_secp128r1 "secp128r1"
#define NID_secp112r2 705
#define SN_secp112r2 "secp112r2"
#define NID_secp112r1 704
#define SN_secp112r1 "secp112r1"
#define NID_ecdsa_with_SHA512 796
#define SN_ecdsa_with_SHA512 "ecdsa-with-SHA512"
#define NID_ecdsa_with_SHA384 795
#define SN_ecdsa_with_SHA384 "ecdsa-with-SHA384"
#define NID_ecdsa_with_SHA256 794
#define SN_ecdsa_with_SHA256 "ecdsa-with-SHA256"
#define NID_ecdsa_with_SHA224 793
#define SN_ecdsa_with_SHA224 "ecdsa-with-SHA224"
#define NID_ecdsa_with_Specified 792
#define SN_ecdsa_with_Specified "ecdsa-with-Specified"
#define NID_ecdsa_with_Recommended 791
#define SN_ecdsa_with_Recommended "ecdsa-with-Recommended"
#define NID_ecdsa_with_SHA1 416
#define SN_ecdsa_with_SHA1 "ecdsa-with-SHA1"
#define NID_X9_62_prime256v1 415
#define NID_X9_62_prime239v3 414
#define SN_X9_62_prime239v3 "prime239v3"
#define NID_X9_62_prime239v2 413
#define SN_X9_62_prime239v2 "prime239v2"
#define NID_X9_62_prime239v1 412
#define SN_X9_62_prime239v1 "prime239v1"
#define NID_X9_62_prime192v3 411
#define SN_X9_62_prime192v3 "prime192v3"
#define NID_X9_62_prime192v2 410
#define SN_X9_62_prime192v2 "prime192v2"
#define NID_X9_62_prime192v1 409
#define NID_X9_62_c2tnb431r1 703
#define SN_X9_62_c2tnb431r1 "c2tnb431r1"
#define NID_X9_62_c2pnb368w1 702
#define SN_X9_62_c2pnb368w1 "c2pnb368w1"
#define NID_X9_62_c2tnb359v1 701
#define SN_X9_62_c2tnb359v1 "c2tnb359v1"
#define NID_X9_62_c2pnb304w1 700
#define SN_X9_62_c2pnb304w1 "c2pnb304w1"
#define NID_X9_62_c2pnb272w1 699
#define SN_X9_62_c2pnb272w1 "c2pnb272w1"
#define NID_X9_62_c2onb239v5 698
#define SN_X9_62_c2onb239v5 "c2onb239v5"
#define NID_X9_62_c2onb239v4 697
#define SN_X9_62_c2onb239v4 "c2onb239v4"
#define NID_X9_62_c2tnb239v3 696
#define SN_X9_62_c2tnb239v3 "c2tnb239v3"
#define NID_X9_62_c2tnb239v2 695
#define SN_X9_62_c2tnb239v2 "c2tnb239v2"
#define NID_X9_62_c2tnb239v1 694
#define SN_X9_62_c2tnb239v1 "c2tnb239v1"
#define NID_X9_62_c2pnb208w1 693
#define SN_X9_62_c2pnb208w1 "c2pnb208w1"
#define NID_X9_62_c2onb191v5 692
#define SN_X9_62_c2onb191v5 "c2onb191v5"
#define NID_X9_62_c2onb191v4 691
#define SN_X9_62_c2onb191v4 "c2onb191v4"
#define NID_X9_62_c2tnb191v3 690
#define SN_X9_62_c2tnb191v3 "c2tnb191v3"
#define NID_X9_62_c2tnb191v2 689
#define SN_X9_62_c2tnb191v2 "c2tnb191v2"
#define NID_X9_62_c2tnb191v1 688
#define SN_X9_62_c2tnb191v1 "c2tnb191v1"
#define NID_X9_62_c2pnb176v1 687
#define SN_X9_62_c2pnb176v1 "c2pnb176v1"
#define NID_X9_62_c2pnb163v3 686
#define SN_X9_62_c2pnb163v3 "c2pnb163v3"
#define NID_X9_62_c2pnb163v2 685
#define SN_X9_62_c2pnb163v2 "c2pnb163v2"
#define NID_X9_62_c2pnb163v1 684
#define SN_X9_62_c2pnb163v1 "c2pnb163v1"
#define NID_X9_62_id_ecPublicKey 408
#define SN_X9_62_id_ecPublicKey "id-ecPublicKey"
#define NID_X9_62_ppBasis 683
#define SN_X9_62_ppBasis "ppBasis"
#define NID_X9_62_tpBasis 682
#define SN_X9_62_tpBasis "tpBasis"
#define NID_X9_62_onBasis 681
#define SN_X9_62_onBasis "onBasis"
#define NID_X9_62_id_characteristic_two_basis 680
#define SN_X9_62_id_characteristic_two_basis "id-characteristic-two-basis"
#define NID_X9_62_characteristic_two_field 407
#define SN_X9_62_characteristic_two_field "characteristic-two-field"
#define NID_X9_62_prime_field 406
#define SN_X9_62_prime_field "prime-field"
#define NID_ansi_X9_62 405
#define LN_ansi_X9_62 "ANSI X9.62"
#define SN_ansi_X9_62 "ansi-X9-62"
#define NID_dsaWithSHA1 113
#define LN_dsaWithSHA1 "dsaWithSHA1"
#define SN_dsaWithSHA1 "DSA-SHA1"
#define NID_dsa 116
#define LN_dsa "dsaEncryption"
#define SN_dsa "DSA"
#define NID_sm_scheme 1142
#define SN_sm_scheme "sm-scheme"
#define NID_oscca 1141
#define SN_oscca "oscca"
#define NID_ISO_CN 1140
#define LN_ISO_CN "ISO CN Member Body"
#define SN_ISO_CN "ISO-CN"
#define NID_X9cm 185
#define LN_X9cm "X9.57 CM ?"
#define SN_X9cm "X9cm"
#define NID_X9_57 184
#define LN_X9_57 "X9.57"
#define SN_X9_57 "X9-57"
#define NID_ISO_US 183
#define LN_ISO_US "ISO US Member Body"
#define SN_ISO_US "ISO-US"
#define NID_clearance 395
#define SN_clearance "clearance"
#define NID_selected_attribute_types 394
#define LN_selected_attribute_types "Selected Attribute Types"
#define SN_selected_attribute_types "selected-attribute-types"
#define NID_wap_wsg 679
#define SN_wap_wsg "wap-wsg"
#define NID_wap 678
#define SN_wap "wap"
#define NID_international_organizations 647
#define LN_international_organizations "International Organizations"
#define SN_international_organizations "international-organizations"
#define NID_ieee_siswg 1171
#define LN_ieee_siswg "IEEE Security in Storage Working Group"
#define SN_ieee_siswg "ieee-siswg"
#define NID_ieee 1170
#define SN_ieee "ieee"
#define NID_certicom_arc 677
#define SN_certicom_arc "certicom-arc"
#define NID_x509ExtAdmission 1093
#define LN_x509ExtAdmission "Professional Information or basis for Admission"
#define SN_x509ExtAdmission "x509ExtAdmission"
#define NID_hmac_sha1 781
#define LN_hmac_sha1 "hmac-sha1"
#define SN_hmac_sha1 "HMAC-SHA1"
#define NID_hmac_md5 780
#define LN_hmac_md5 "hmac-md5"
#define SN_hmac_md5 "HMAC-MD5"
#define NID_gmac 1195
#define LN_gmac "gmac"
#define SN_gmac "GMAC"
#define NID_identified_organization 676
#define SN_identified_organization "identified-organization"
#define NID_member_body 182
#define LN_member_body "ISO Member Body"
#define SN_member_body "member-body"
#define NID_joint_iso_ccitt 393
#define NID_joint_iso_itu_t 646
#define LN_joint_iso_itu_t "joint-iso-itu-t"
#define SN_joint_iso_itu_t "JOINT-ISO-ITU-T"
#define NID_iso 181
#define LN_iso "iso"
#define SN_iso "ISO"
#define NID_ccitt 404
#define NID_itu_t 645
#define LN_itu_t "itu-t"
#define SN_itu_t "ITU-T"
#define LN_undef "undefined"
#define SN_undef "UNDEF"
