#if defined(FOO)
	#error "This shouldn't happen"
#elif !defined(BAR)
	
	#if 1
		// ...
	#else
		// ...
	#endif

#else
	#warning "This shouldn't happen either"
#endif

#if 0
	// ...
#else
	// ...
#endif