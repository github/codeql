static int zero = __COUNTER__;

// these map to 1.h through 4.h via little.hmap
#include "a.h"
#include "b.h"
#include "C.H"
#include "D.H"

// these map to 5.h through 8.h via big.hmap
#include "e.h"
#include "f.h"
#include "G.H"
#include "H.H"

// semmle-extractor-options: -I${testdir}/little_qltest.hmap -I${testdir}/big_qltest.hmap
