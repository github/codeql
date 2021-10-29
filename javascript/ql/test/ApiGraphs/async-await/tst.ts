import { readFile } from 'fs/promises';

async function readFileUtf8(path: string): Promise<string> {
    return readFile(path, { encoding: 'utf8' });
}

async function test(path: string) {
    await readFileUtf8(path); /* use (promised (return (member readFile (member exports (module fs/promises))))) */
}
