#define size_t int
#define NULL ((void*)0)

#define assert(x) if (!(x)) __assert_fail(#x,__FILE__,__LINE__)
void __assert_fail(const char *assertion, const char *file, int line);

void aFakeFailed_1(int file, int line)
{
}
void aFailed_1(int file, int line)
{
    exit(0);
}
void aFailed_2(int file, int line, int ex)
{
    if(ex == 1)
	    exit(0);
    else
	    return;
}
#define F_NUM 1
#define myASSERT_1(expr) \
    if (!(expr)) \
        aFailed_1(F_NUM, __LINE__)
#define myASSERT_2(expr) \
    if (!(expr)) \
        aFailed_2(F_NUM, __LINE__, 1)

unsigned char * badResize_0(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// BAD: on unsuccessful call to realloc, we will lose a pointer to a valid memory block
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	return buffer;
}

unsigned char * goodResize_0(unsigned char * buffer,size_t currentSize,size_t newSize)
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
unsigned char * badResize_1_0(unsigned char * buffer,size_t currentSize,size_t newSize)
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

unsigned char * noBadResize_1_0(unsigned char * buffer,size_t currentSize,size_t newSize)
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
unsigned char * noBadResize_1_1(unsigned char * buffer,size_t currentSize,size_t newSize)
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
unsigned char * noBadResize_1_2(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		if(buffer = (unsigned char *)realloc(buffer, newSize))
		exit(0);
	}
	return buffer;
}
unsigned char * noBadResize_1_3(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	if(!buffer)
		aFailed_1(1, 1);
	return buffer;
}
unsigned char * noBadResize_1_4(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	if(buffer)
		return buffer;
	else
		aFailed_1(1, 1);
}
unsigned char * noBadResize_1_5(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		if(buffer = (unsigned char *)realloc(buffer, newSize))
		aFailed_1(1, 1);
	}
	return buffer;
}
unsigned char * badResize_1_1(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// BAD: on unsuccessful call to realloc, we will lose a pointer to a valid memory block
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	if(!buffer)
		aFakeFailed_1(1, 1);
	return buffer;
}

unsigned char * noBadResize_1_6(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	if(!buffer)
		aFailed_2(1, 1, 1);
	return buffer;
}
unsigned char * noBadResize_1_7(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	if(buffer)
		return buffer;
	else
		aFailed_2(1, 1, 1);
}
unsigned char * noBadResize_1_8(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		if(buffer = (unsigned char *)realloc(buffer, newSize))
		aFailed_2(1, 1, 1);
	}
	return buffer;
}

unsigned char * badResize_2_0(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// BAD: on unsuccessful call to realloc, we will lose a pointer to a valid memory block
	assert(buffer!=0);
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	return buffer;
}

unsigned char * noBadResize_2_0(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
		assert(buffer!=0);
	}
	return buffer;
}

unsigned char * noBadResize2e_2_1(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	assert(buffer!=0);
	return buffer;
}
unsigned char * noBadResize_2_2(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
		assert(buffer);
	}
	return buffer;
}

unsigned char * noBadResize_2_3(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	assert(buffer);
	return buffer;
}
unsigned char * noBadResize_2_4(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
		myASSERT_1(buffer);
	}
	return buffer;
}

unsigned char * noBadResize_2_5(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	myASSERT_1(buffer);
	return buffer;
}
unsigned char * noBadResize_2_6(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
		myASSERT_2(buffer);
	}
	return buffer;
}

unsigned char * noBadResize_2_7(unsigned char * buffer,size_t currentSize,size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	myASSERT_2(buffer);
	return buffer;
}

unsigned char *goodResize_3_1(unsigned char *buffer, size_t currentSize, size_t newSize)
{
	// GOOD: this way we will exclude possible memory leak [FALSE POSITIVE]
	unsigned char *tmp = buffer;
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
		if (buffer == NULL)
		{
			free(tmp);
			return NULL;
		} 
	}

	return buffer;
}

unsigned char *goodResize_3_2(unsigned char *buffer, size_t currentSize, size_t newSize)
{
	// GOOD: this way we will exclude possible memory leak [FALSE POSITIVE]
	unsigned char *tmp = buffer;
	if (currentSize < newSize)
	{
		tmp = (unsigned char *)realloc(tmp, newSize);
		if (tmp != 0)
		{
			buffer = tmp;
		} 
	}

	return buffer;
}

void abort(void);

unsigned char *noBadResize_4_1(unsigned char *buffer, size_t currentSize, size_t newSize)
{
	// GOOD: program to end
	if (currentSize < newSize)
	{
		if (buffer = (unsigned char *)realloc(buffer, newSize))
			abort();
	}

	return buffer;
}

unsigned char * badResize_5_2(unsigned char *buffer, size_t currentSize, size_t newSize, int cond)
{
	// BAD: on unsuccessful call to realloc, we will lose a pointer to a valid memory block
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
	}
	if (cond)
	{
		abort(); // irrelevant
	}
	return buffer;
}

unsigned char * badResize_5_1(unsigned char *buffer, size_t currentSize, size_t newSize, int cond)
{
	// BAD: on unsuccessful call to realloc, we will lose a pointer to a valid memory block
	if (currentSize < newSize)
	{
		buffer = (unsigned char *)realloc(buffer, newSize);
		assert(cond); // irrelevant
	}
	return buffer;
}
