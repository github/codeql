



class UseBraces
{
	void f() { }
	void g() { }
	void h() { }
	void test(boolean bb)
	{
		int x = 0, y;
		int[] branches = new int[10];
		
		// If-then statement
		
		if(1==1)
		{
			f();
		}
			g();	// No alert
			
		if(1==1)	
			f();
		g();		// No alert
		
		if(1==1)
			f(); // $ Alert
			g();	// Alert
			
		if(1==1)
			f();	g();	// $ Alert // Alert

		// If-then-else statement

		if (1 + 2 == 3)
		{
			f();
		}
		else
		{
			g();
		}
		
			g();	// No alert
			
		if(1==2)
			f();
		else
			g();
		f();		// No alert
			
		if(true)
		{
			f();
		}
		else
			f(); // $ Alert
			g();	// Alert
			
		if(true)
		{
			f();
		}
		else
			f();  g();	// $ Alert // Alert

		// While statement

		while(bb)
		{
			f();
		}
			g();		// No alert


		while(bb)
			f();
		g();

		while(bb   )
			f(); // $ Alert
			g();		// Alert
			g();		// No alert

		while(bb   )
			f();	g();		// $ Alert // Alert


		while(bb)
			if (x != 0) x = 1;

		// Do-while statement
		
		do
			f();
		while(false);
			g();	// No alert
		
		// For statement
		for(int i=0; i<10; ++i)
		{
			f();
		}
			g();
			
		for(int i=0; i<10; ++i)
			f();
		g();
		
		for(int i=0; i<10; ++i)
			f(); // $ Alert
			g();				// Alert

		for(int i=0; i<10; ++i)
			f(); g();			// $ Alert // Alert

		
		// Foreach statement
		
		for( int b : branches)
			x += b;
		f();

		for( int b : branches)
		{
			x += b;
		}
			f();

		for( int b : branches)
			f(); // $ Alert
			g();			// Alert

		for( int b : branches)
			f(); g();		// $ Alert // Alert

		// Nested ifs
		if( true )
		if(false)
			f();
		g();	// No alert
		
		if( true )
			if(false) // $ Alert
				f();
			g();	// Alert
		
		if( true )
			;
		else 
		if (false)
			f();
		g();	// No alert

		if( true )
			;
		else 
			if (false)
				f();
			g();	// false negative

		if( true )
			;
		else if (false)
			f();  // $ Alert
			g();	// Alert
		
		// Nested combinations
		if (true)
		while (x<10)
			f();
		g();	// No alert

		if (true)
			while (x<10) // $ Alert
				f();
			g();	// Alert

		while (x<10)
		if (true)
			f();
		g();	// No alert

		while (x<10)
			if (true) // $ Alert
				f();
			g();	// Alert

		if (true)
			f();
		class C {} // No alert

		if (true)
			f();
				g(); // No alert
	}
}
