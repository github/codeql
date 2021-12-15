import { createRequire } from 'module';

const require = createRequire(import.meta.url);
const { ApolloServer } = require('apollo-server');
