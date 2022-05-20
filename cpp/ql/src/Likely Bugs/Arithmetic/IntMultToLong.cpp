int i = 2000000000;
long j = i * i; //Wrong: due to overflow on the multiplication between ints, 
                //will result to j being -1651507200, not 4000000000000000000

long k = (long) i * i; //Correct: the multiplication is done on longs instead of ints, 
                       //and will not overflow

long l = static_cast<long>(i) * i; //Correct: modern C++
