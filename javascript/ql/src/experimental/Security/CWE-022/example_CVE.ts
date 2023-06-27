import { Controller, Get, Param, Response, } from '@nestjs/common';
import { AppService } from './app.service';
import path from "path";
import fs from 'node:fs';
//or import fs from 'fs';
import { readFile } from 'node:fs/promises';

@Controller()
export class AppController {
    constructor(private readonly appService: AppService) {
    }

    @Get()
    getHello(): string {
        return this.appService.getHello();
    }

    // @Get(/^\/download\/(.+)$/)
    // , getCacheMiddleware(), catchError(fileRead));
    @Get('/download/:filename(*)')
    // This route will match any URL that starts with
    async fileRead(@Param('filename') filename: string, @Response() res) {
        try {
            const { img, type } = await this.fileReadHelper(
                path.join('nc', 'uploads', filename)
            );

            res.writeHead(200, { 'Content-Type': type });
            res.end(img, 'binary');
        } catch (e) {
            console.log(e);
            res.status(404).send('Not found');
        }
    }

    public async fileReadHelper(filePath: string): Promise<any> {
        try {
            await readFile(
                path.join("a/", ...filePath.split('/')),
            );
            return await fs.promises.readFile(
                path.join("a/", ...filePath.split('/')),
            );
        } catch (e) {
            throw e;
        }
    }
}
