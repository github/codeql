import bar from 'foo';

let boundbar = bar.bind(
    "receiver", // def=moduleImport("foo").getMember("exports").getMember("default").getReceiver()
    "firstarg"  // def=moduleImport("foo").getMember("exports").getMember("default").getParameter(0)
);
boundbar(
    "secondarg" // def=moduleImport("foo").getMember("exports").getMember("default").getParameter(1)
)

let boundbar2 = boundbar.bind(
    "ignored", // MISSING: def=moduleImport("foo").getMember("exports)".getMember("default").getReceiver()
    "othersecondarg" // def=moduleImport("foo").getMember("exports").getMember("default").getParameter(1)
)
boundbar2(
    "thirdarg" // def=moduleImport("foo").getMember("exports").getMember("default").getParameter(2)
)

let bar2 = bar;
for (var i = 0; i < 2; ++i)
    bar2 = bar2.bind(
        null,
        i /* def=moduleImport("foo").getMember("exports").getMember("default").getParameter(1) */ /* def=moduleImport("foo").getMember("exports").getMember("default").getParameter(9) */
    );
