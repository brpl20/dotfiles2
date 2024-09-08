const { MongoClient, ServerApiVersion } = require('mongodb');

// Check if the correct number of arguments is provided
if (process.argv.length !== 4) {
  console.log('Usage: node drop-pizza-numbers.js <databaseName> <collectionName>');
  process.exit(1);
}

const databaseName = process.argv[2];
const collectionName = process.argv[3];

const uri = "mongodb+srv://pellibrsp:yITrncZWjfud9Lb5@serverlessinstance0.bwfqdh8.mongodb.net/?retryWrites=true&w=majority&appName=ServerlessInstance0";

const mclient = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

async function dropCollection(dbName, collName) {
  try {
    // Connect to the MongoDB server
    await mclient.connect();

    // Access the database and collection
    const database = mclient.db(dbName);
    const collection = database.collection(collName);

    // Drop the specified collection
    await collection.drop();
    console.log(`Collection '${collName}' in database '${dbName}' dropped successfully.`);
  } catch (error) {
    if (error.code === 26) {
      console.log(`Collection '${collName}' does not exist in database '${dbName}'.`);
    } else {
      console.error('Error dropping collection:', error);
    }
  } finally {
    // Close the MongoDB connection
    await mclient.close();
  }
}

async function run() {
  try {
    await mclient.connect();
    await mclient.db("admin").command({ ping: 1 });
    console.log("Pinged your deployment. You successfully connected to MongoDB!");
    await dropCollection(databaseName, collectionName);
  } catch (error) {
    console.error("An error occurred while connecting to MongoDB or executing the command:", error);
  } finally {
    console.log("Operation completed.");
  }
}

run().catch(console.dir);