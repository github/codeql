import { Request } from "express";

export function f1(req: Request) {
    req.body;
}

type Alias = Request & { foo: string };

export function f2(req: Alias) {
    req.body;
}
