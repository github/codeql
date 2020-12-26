// BAD: on unsuccessful call to realloc, we will lose a pointer to a valid memory block
if (currentSize < newSize)
{
	buffer = (unsigned char *)realloc(buffer, newSize);
}



// GOOD: this way we will exclude possible memory leak 
unsigned char * tmp;
if (currentSize < newSize)
{
	tmp = (unsigned char *)realloc(buffer, newSize);
}
if (tmp == NULL)
{
	free(buffer);
} 
else
	buffer = tmp;
