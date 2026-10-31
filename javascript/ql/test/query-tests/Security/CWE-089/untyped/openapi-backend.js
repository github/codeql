const { OpenAPIBackend } = require('openapi-backend');
const OpenAPIBackendDefault = require('openapi-backend').default;
const { Pool } = require('pg');

const db = new Pool();

const api = new OpenAPIBackend({
  definition: './openapi.yml',
  handlers: {
    getPet: (c) => db.query(`SELECT * FROM pets WHERE id = ${c.request.params.id}`), // $ Alert
    getPetSafe: (c) => db.query('SELECT * FROM pets WHERE id = $1', [c.request.params.id]),
  },
  securityHandlers: {
    apiKey: (c) => db.query(`SELECT * FROM keys WHERE key = '${c.request.headers['x-api-key']}'`), // $ Alert
  },
});

api.register('findPets', async (c) => {
  const { name } = c.request.query; // $ Source
  return db.query(`SELECT * FROM pets WHERE name = '${name}'`); // $ Alert
});

api.register({
  createPet: (c) => db.query(`INSERT INTO pets (name) VALUES ('${c.request.requestBody.name}')`), // $ Alert
});

api.registerSecurityHandler('session', (c) =>
  db.query(`SELECT * FROM sessions WHERE id = '${c.request.cookies.sid}'`), // $ Alert
);

async function main() {
  const initialized = await new OpenAPIBackendDefault({ definition: './openapi.yml' }).init();
  initialized.register('deletePet', (c) => db.query(`DELETE FROM pets WHERE id = ${c.request.params.id}`)); // $ Alert
}

api.registerHandler('updatePet', (c) => db.query(`UPDATE pets SET name = 'x' WHERE id = ${c.request.params.id}`)); // $ Alert

const audited = new OpenAPIBackend({
  definition: './openapi.yml',
  validate: (c) => {
    db.query(`INSERT INTO audit (path) VALUES ('${c.request.path}')`); // $ Alert
    return true;
  },
});
