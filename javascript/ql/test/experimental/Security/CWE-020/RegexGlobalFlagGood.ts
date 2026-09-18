import { Request, Response, Application } from 'express';
import express from 'express';
import db from './postgres';

const FORBIDDEN_CHARS = /['\\]/;
const isForbidden = (str: string) => FORBIDDEN_CHARS.test(str);

const app: Application = express();

app.get('/api/users/:name', async (req: Request, res: Response) => {
    const { name } = req.params;
    if (isForbidden(name)) {
        return res.sendStatus(400);
    }
    const user = await db.query(`SELECT * FROM users WHERE name='${name}'`);
    res.json(user);
});

app.listen(1337);