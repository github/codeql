(x?: number) => x;
async (x?: number) => x;
(...{length}: Object): number => length;
async (...{length}: Object): Promise<number> => length;
condition ? (x) : y;