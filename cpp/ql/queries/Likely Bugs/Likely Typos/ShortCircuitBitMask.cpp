
unsigned int new_mask = old_mask || 0x0100; //wrong, || logical operator just returns 1 or 0

unsigned int new_mask = old_mask | 0x0100; //right, | is a bit-mask operator
