# NoSQL database query built from user-controlled sources (experimental)
If a database query is built from user-provided data without sufficient sanitization, a user may be able to run malicious database queries.

Note: This CodeQL query is an experimental query. Experimental queries generate alerts using machine learning. They might include more false positives but they will improve over time.


## Recommendation
Ensure that untrusted data is interpreted as a literal value and not as a query object, eg., by using an operator like MongoDB's `$eq`.

## Example
In the following example, an `express.js` application is defining two endpoints that permit a user to query a MongoDB database.

In each case, the handler constructs two copies of the same query involving user input taken from the request object. In both handlers, the input is parsed using the `body-parser` library, which will transform the request data that arrives as a string to JSON objects.

In the first case, `/search1`, the input is used as a query object. This means that a malicious user is able to inject queries that select more data than the developer intended.

In the second case, `/search2`, parts of the input are converted to a string representation and then used with the `$eq` operator to construct a query object.


```javascript
const app = require("express")(),
      mongodb = require("mongodb"),
      bodyParser = require('body-parser');

const client = new MongoClient('mongodb://localhost:27017/test');

app.use(bodyParser.urlencoded({ extended: true }));

app.get("/search1", async function handler(req, res) {
    await client.connect();
    const db = client.db('test');
    const doc = db.collection('doc');

    const result = doc.find({
      // BAD:
      // This is vulnerable.
      // Eg., req.body.title might be the object { $ne: "foobarbaz" }, and the
      // endpoint would return all data.
      title: req.body.title
    });

    res.send(await result);
});

app.get("/search2", async function handler(req, res) {
    await client.connect();
    const db = client.db('test');
    const doc = db.collection('doc');

    // GOOD:
    // The input is converted to a string, and matched using the $eq operator.
    // At most one datum is returned.
    const result = await doc.find({ title: { $eq: `${req.body.title}` } });

    res.send(await result);
});
```

## References
* Acunetix Blog: [NoSQL Injections and How to Avoid Them](https://www.acunetix.com/blog/web-security-zone/nosql-injections/).
* MongoDB: [$eq operator](https://docs.mongodb.com/manual/reference/operator/query/eq).
* MongoDB: [$ne operator](https://docs.mongodb.com/manual/reference/operator/query/ne).
