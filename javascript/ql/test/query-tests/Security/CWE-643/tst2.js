let query = document.location.hash.substring(1);
document.createExpression(query); // NOT OK
document.evaluate(query);         // NOT OK
