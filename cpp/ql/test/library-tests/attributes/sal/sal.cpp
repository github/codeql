void Bar( // Attribute style:
[SA_Pre(Null=SA_No,ValidBytes="cb")]
[SA_Pre(Deref=1,Valid=SA_Yes)]
[SA_Pre(Deref=1,Access=SA_Read)] char* pBuf, size_t cb);

void Foo( // Declspec style:
__declspec("SAL_pre")
__declspec("SAL_valid")
__declspec("SAL_pre")
__declspec("SAL_deref")
__declspec("SAL_readonly")
__declspec("SAL_pre")
__declspec("SAL_readableTo(byteCount(cb))") char* pBuf, size_t cb);

int Exotic(__declspec("{#foo}") int thisIsWhyAttributeNamesAreHashedInFullIds);
