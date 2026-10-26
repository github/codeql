"use server";

export async function getData(
    x, // $ threatModelSource=remote
    y) { // $ threatModelSource=remote
}

async function getData2(
    x, // should not be remote flow sources (because the function is not exported)
    y) {
}
