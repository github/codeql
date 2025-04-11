import { NextRequest, NextResponse } from 'next/server';

export async function middleware(req: NextRequest) {
    const target = req.nextUrl // $ Source[js/request-forgery]
    if (target) {
      const res = await fetch(target) // $ Alert[js/request-forgery] Sink[js/request-forgery]
      const data = await res.text()
      return new NextResponse(data)
    }
    return NextResponse.next()
}
  