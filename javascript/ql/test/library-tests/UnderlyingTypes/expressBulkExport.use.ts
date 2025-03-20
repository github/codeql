import { Request, Response } from './expressBulkExport';

function t1(req: Request) { // $ MISSING: hasUnderlyingType='express'.Request SPURIOUS: hasUnderlyingType='expressBulkExport.ts'.Request
}

function t2(res: Response) { // $ MISSING: hasUnderlyingType='express'.Response SPURIOUS: hasUnderlyingType='expressBulkExport.ts'.Response
}
