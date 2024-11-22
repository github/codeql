CREATE TABLE IF NOT EXISTS people
(
    id INTEGER PRIMARY KEY NOT NULL,
    firstname TEXT NOT NULL,
    lastname TEXT NOT NULL
);

INSERT INTO people
VALUES (1, "Alice", "Adams");

INSERT INTO people
VALUES (2, "Bob", "Becket");
