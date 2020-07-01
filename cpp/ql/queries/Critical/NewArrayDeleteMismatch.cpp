Record* record = new Record[SIZE];

...

delete record; //record was created using 'new[]', but was freed using 'delete'
