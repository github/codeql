import { Request, Response, R } from './expressSelectiveExport';

function t1(req: Request) { // $ MISSING: hasUnderlyingType='express'.Request SPURIOUS: hasUnderlyingType='expressSelectiveExport.ts'.Request
}

function t2(res: Response) { // $ SPURIOUS: hasUnderlyingType='expressSelectiveExport.ts'.Response - none, not exported
}

function t3(res: R) { // $ MISSING: hasUnderlyingType='express'.Response SPURIOUS: hasUnderlyingType='expressSelectiveExport.ts'.R
}
