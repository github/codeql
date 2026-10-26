"use server";

export async function echoService(x) { // $ Source[js/code-injection]
    return x + " from server";
}
