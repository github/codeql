import OpenAPIBackend, { Context } from 'openapi-backend';
import { Pool } from 'pg';

const db = new Pool();

const getOwner = async (c: Context) => db.query(`SELECT * FROM owners WHERE id = ${c.request.params.id}`); // $ Alert

export const api = new OpenAPIBackend({ definition: './openapi.yml', handlers: { getOwner } });
