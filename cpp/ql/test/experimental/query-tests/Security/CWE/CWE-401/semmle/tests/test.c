#define size_t int
#define NULL ((void*)0)


unsigned char * badResize0(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// BAD: on unsuccessful call to realloc, we will lose a pointer to a valid memory block
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	return buffer;
}

unsigned char * goodResize0(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: this way we will exclude possible memory leak 
	unsigned char * tmp;
	if (currentSize < newSize)
	{
		tmp = (unsigned char *)realloc(buffer, newSize);
	}
	if (tmp == NULL)
	{
		free(buffer);
		return NULL;
	} 
	else
		buffer = tmp;
	return buffer;
}
unsigned char * badResize1(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	if(!buffer)
		exit(0);
	// BAD: on unsuccessful call to realloc, we will lose a pointer to a valid memory block
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	return buffer;
}

unsigned char * noBadResize1(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	if(!buffer)
		exit(0);
	return buffer;
}
unsigned char * noBadResize1e(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	if(buffer)
		return buffer;
	else
		exit(0);
}
unsigned char * noBadResize1o(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		if(buffer = (unsigned char *)realloc(buffer, newSize))
			exit(0);
	}
	return buffer;
}
unsigned char * badResize2(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	assert(buffer!=0);
	// BAD: on unsuccessful call to realloc, we will lose a pointer to a valid memory block
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	return buffer;
}

unsigned char * noBadResize2(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
		assert(buffer!=0);
	}
	return buffer;
}

unsigned char * noBadResize2e(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	assert(buffer!=0);
	return buffer;
}