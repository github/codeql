import { Request, Response, R } from './expressSelectiveExport';

function t1(req: Request) { // $ hasUnderlyingType='express'.Request
}

function t2(res: Response) { // none, not exported
}

function t3(res: R) { // $ hasUnderlyingType='express'.Response
}
