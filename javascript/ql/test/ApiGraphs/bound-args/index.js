import bar from 'foo';

let boundbar = bar.bind(
    "receiver", // def (parameter -1 (member default (member exports (module foo))))
    "firstarg"  // def (parameter 0 (member default (member exports (module foo))))
);
boundbar(
    "secondarg" // def (parameter 1 (member default (member exports (module foo))))
)

let boundbar2 = boundbar.bind(
    "ignored", // !def (parameter -1 (member default (member exports (module foo))))
    "othersecondarg" // def (parameter 1 (member default (member exports (module foo))))
)
boundbar2(
    "thirdarg" // def (parameter 2 (member default (member exports (module foo))))
)

let bar2 = bar;
for (var i = 0; i < 2; ++i)
    bar2 = bar2.bind(
        null,
        i /* def (parameter 1 (member default (member exports (module foo)))) */ /* def (parameter 9 (member default (member exports (module foo)))) */
    );
