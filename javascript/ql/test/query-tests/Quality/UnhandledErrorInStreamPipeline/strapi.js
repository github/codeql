import { async } from '@strapi/utils';

const f = async () => {
    const permissionsInDB = await async.pipe(strapi.db.query('x').findMany,map('y'))();
}
