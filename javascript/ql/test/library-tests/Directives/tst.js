'use strict'; // this is a directive
'use asm'; // and so is this
'bundle';// and this
'use server';
'use client';
'use cache';
'use cache: remote';
'use cache: private';
{
  'use strict'; // but this isn't a directive
}

'use asm'; // and neither is this

function f() {
  'use\x20strict'; // this is a directive, though not a strict mode directive
  'use asm'; // and so is this
  'bundle';
  'use server';
  'use client';
  'use cache';
  'use cache: remote';
  'use cache: private';
  ;
  'use strict'; // but this isn't a directive
}

function g() {
    "";
    'use strict'; // this is a directive
}
