import com.mongodb.MongoClient;
import com.mongodb.DBObject;
import com.mongodb.util.*;
import com.mongodb.ServerAddress;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.*;

public class Mongo {
    public static void main(String[] args) { // $ Source[java/sql-injection]
        MongoClient mongoClient = new MongoClient(new ServerAddress("localhost", 27017));
        DB db = mongoClient.getDB("mydb");
        DBCollection collection = db.getCollection("test");

        String name = args[1];
        String stringQuery = "{ 'name' : '" + name + "'}";
        DBObject databaseQuery = (DBObject) JSON.parse(stringQuery); // $ Alert[java/sql-injection]
        DBCursor result = collection.find(databaseQuery);

        String json = args[1];
        BasicDBObject bdb = BasicDBObject.parse(json); // $ Alert[java/sql-injection]
        DBCursor result2 = collection.find(bdb);

    }
}
