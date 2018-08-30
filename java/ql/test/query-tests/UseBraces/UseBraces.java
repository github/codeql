



class UseBraces
{
	void f() { }
	void g() { }
	void h() { }
	void test()
	{
		int x, y;
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
			f();
			g();	// Alert
			
		if(1==1)
			f();	g();	// Alert

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
			f();
			g();	// Alert
			
		if(true)
		{
			f();
		}
		else
			f();  g();	// Alert

		// While statement

		while(false)
		{
			f();
		}
			g();		// No alert


		while(false)
			f();
		g();

		while(false)
			f();
			g();		// Alert
			g();		// No alert

		while(false)
			f();	g();		// Alert


		while(false)
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
			f();
			g();				// Alert

		for(int i=0; i<10; ++i)
			f(); g();			// Alert

		
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
			f();
			g();			// Alert

		for( int b : branches)
			f(); g();		// Alert

		// Nested ifs
		if( true )
		if(false)
			f();
		g();	// No alert
		
		if( true )
			if(false)
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
			f(); 
			g();	// Alert
		
		// Nested combinations
		if (true)
		while (x<10)
			f();
		g();	// No alert

		if (true)
			while (x<10)
				f();
			g();	// Alert

		while (x<10)
		if (true)
			f();
		g();	// No alert

		while (x<10)
			if (true)
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
