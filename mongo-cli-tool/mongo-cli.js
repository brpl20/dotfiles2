#!/usr/bin/env node

const { MongoClient } = require('mongodb');

const uris = {
  local: "mongodb://localhost:27017",
  production: "mongodb://prod.server:27017",
  staging: "mongodb://staging.server:27017"
};

async function main() {
  const command = process.argv[2];
  const uriKey = process.argv[3];
  const databaseName = process.argv[4];
  const collectionName = process.argv[5];

  if (command === 'list-uris') {
    console.log("URIs disponíveis:");
    for (const key in uris) {
      console.log(`${key}: ${uris[key]}`);
    }
    return;
  }

  const uri = uris[uriKey];

  if (!uri) {
    console.log('URI não reconhecido. Use o comando "list-uris" para ver os URIs disponíveis.');
    return;
  }

  const client = new MongoClient(uri);

  try {
    await client.connect();

    if (command === 'drop') {
      if (!databaseName) {
        console.log('Por favor, forneça o nome do banco de dados.');
        return;
      }

      if (collectionName) {
        // Drop a specific collection
        await client.db(databaseName).collection(collectionName).drop();
        console.log(`Coleção ${collectionName} no banco de dados ${databaseName} removida com sucesso.`);
      } else {
        // Drop the entire database
        await client.db(databaseName).dropDatabase();
        console.log(`Banco de dados ${databaseName} removido com sucesso.`);
      }
    } else if (command === 'map') {
      const databases = await client.db().admin().listDatabases();
      for (const dbInfo of databases.databases) {
        console.log(dbInfo.name);
        const collections = await client.db(dbInfo.name).listCollections().toArray();
        for (const collection of collections) {
          console.log(`  └─ ${collection.name}`);
        }
      }
    } else {
      console.log('Comando não reconhecido. Use "drop", "map" ou "list-uris".');
    }
  } catch (err) {
    console.error(err);
  } finally {
    await client.close();
  }
}

main().catch(console.error);