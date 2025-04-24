import { NextRequest, NextResponse } from 'next/server';

export async function middleware(req: NextRequest) {
    const target = req.nextUrl // $ Source[js/request-forgery]
    const target2 = target.searchParams.get('target'); // $ Source[js/request-forgery]
    if (target) {
      const res = await fetch(target) // $ Alert[js/request-forgery]
      const data = await res.text()
      return new NextResponse(data)
    }
    if (target2) {
        const res = await fetch(target2); // $ Alert[js/request-forgery]
        const data = await res.text();
        return new NextResponse(data);
    }
    return NextResponse.next()
}
