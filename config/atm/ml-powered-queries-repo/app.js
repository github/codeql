const bodyParser = require('body-parser');
const express = require('express');
const mongoose = require('mongoose');

const notesApi = require('./notes-api');
const usersApi = require('./users-api');

const addSampleData = module.exports.addSampleData = async () => {
  const [userA, userB] = await User.create([
    {
      name: "A",
      token: "tokenA"
    },
    {
      name: "B",
      token: "tokenB"
    }
  ]);

  await Note.create([
    {
      title: "Public note belonging to A",
      body: "This is a public note belonging to A",
      isPublic: true,
      ownerToken: userA.token
    },
    {
      title: "Public note belonging to B",
      body: "This is a public note belonging to B",
      isPublic: true,
      ownerToken: userB.token
    },
    {
      title: "Private note belonging to A",
      body: "This is a private note belonging to A",
      ownerToken: userA.token
    },
    {
      title: "Private note belonging to B",
      body: "This is a private note belonging to B",
      ownerToken: userB.token
    }
  ]);
}

module.exports.startApp = async () => {
  // Open the default mongoose connection
  await mongoose.connect('mongodb://mongo:27017/notes', { useFindAndModify: false });
  // Drop contents of DB
  mongoose.connection.dropDatabase();
  // Add some sample data
  await addSampleData();

  const app = express();

  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded());

  app.get('/', async (_req, res) => {
    res.send('Hello World');
  });

  app.use('/api/notes', notesApi.router);
  app.use('/api/users', usersApi.router);

  app.listen(3000);
  Logger.log('Express started on port 3000');
};
