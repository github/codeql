// main.c - Cleanup-DuplicateIncludeGuard test

#include "header1.h"
#include "header2.h"
#include "header3.h"
#include "header3.h"

#include "header4.h"
#include "subfolder/header4.h"
#include "subfolder/header5.h"

#include "header6.h"
#include "header7.h"
