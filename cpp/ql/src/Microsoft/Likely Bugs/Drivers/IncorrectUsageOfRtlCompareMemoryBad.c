//bug, the code assumes RtlCompareMemory is comparing for identical values & return false if not identical
if (!RtlCompareMemory(pBuffer, ptr, 16)) 
{
	return FALSE;
}