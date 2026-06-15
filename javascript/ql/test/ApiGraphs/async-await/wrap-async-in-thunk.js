import * as t from "testlib";

async function getData1() {
    const data = await fetch("https://example.com/content");
    return data.json(); /* def=moduleImport("testlib").getMember("exports").getMember("foo").getParameter(0).getReturn().getPromised() */
}

export function use1() {
    t.foo(() => getData1());
}

async function getData2() {
    const data = await fetch("https://example.com/content");
    return data.json(); /* def=moduleImport("testlib").getMember("exports").getMember("foo").getParameter(0).getReturn().getPromised() */
}

export function use2() {
    t.foo(getData2);
}

export function use3() {
    t.foo(async () => {
        const data = await fetch("https://example.com/content");
        return data.json(); /* def=moduleImport("testlib").getMember("exports").getMember("foo").getParameter(0).getReturn().getPromised() */
    });
}
