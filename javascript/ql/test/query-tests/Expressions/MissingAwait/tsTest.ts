declare let cache: { [x: string]: Promise<any> };

function deleteCache(x: string) {
    delete cache[x]; // OK
}
