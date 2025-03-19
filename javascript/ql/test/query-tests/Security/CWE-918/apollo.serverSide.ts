import { ApolloServer } from '@apollo/server';
import { get } from 'https';

function createApolloServer(typeDefs) {
    const resolvers = {
        Mutation: {
          downloadFiles: async (_, { files }) => { // $ MISSING: Source[js/request-forgery]
            files.forEach((file) => { get(file.url, (res) => {}); }); // $ MISSING: Alert[js/request-forgery] Sink[js/request-forgery]
            return true;
          },
        },
      };
    const server = new ApolloServer({typeDefs, resolvers});
}
