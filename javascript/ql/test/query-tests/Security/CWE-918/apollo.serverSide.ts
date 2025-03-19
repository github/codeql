import { ApolloServer } from '@apollo/server';
import { get } from 'https';

function createApolloServer(typeDefs) {
    const resolvers = {
        Mutation: {
          downloadFiles: async (_, { files }) => { // $ Source[js/request-forgery]
            files.forEach((file) => { get(file.url, (res) => {}); }); // $ Alert[js/request-forgery] Sink[js/request-forgery]
            return true;
          },
        },
      };
    const server = new ApolloServer({typeDefs, resolvers});
}
