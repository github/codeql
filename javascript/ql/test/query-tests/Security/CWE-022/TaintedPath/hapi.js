const Hapi = require('@hapi/hapi');
const fs = require('fs').promises;

(async () => {
    const server = Hapi.server({
        port: 3005,
        host: 'localhost'
    });

    server.route({
        method: 'GET',
        path: '/hello',
        handler: async (request, h) => {
            const filepath = request.query.filepath; // $ MISSING: Source
            const data = await fs.readFile(filepath, 'utf8'); // $ MISSING: Alert
            const firstLine = data.split('\n')[0];
            return firstLine;
        }
    });

    await server.start();
})();
