module.exports = grammar({
    name: "blame",

    extras: $ => [/\s/],

    rules: {
        blame_info: $ => seq($._today, repeat(field('file_entry', $.file_entry))),

        _today: $ => seq("today:", field('today', $.date)),

        file_entry: $ => seq(
            "file: ",
            field('file_name', $.filename),
            "\n",
            repeat(field('blame_entry', $.blame_entry))
        ),

        blame_entry: $ => seq(
            "last_modified:",
            field('date', $.date),
            repeat(field('line', $.number)),
        ),

        date: $ => /\d{4}-\d{2}-\d{2}/,

        filename: $ => /[a-zA-Z0-9_\-\.\/ ]+/,

        number: $ => /\d+/,
    }
});
