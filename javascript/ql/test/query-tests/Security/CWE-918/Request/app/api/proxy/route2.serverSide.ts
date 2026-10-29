import { NextRequest, NextResponse } from 'next/server';

export async function POST(req: NextRequest) {
  const { url } = await req.json(); // $ Source[js/request-forgery]
  const res = await fetch(url); // $ Alert[js/request-forgery]
  const data = await res.text();
  return new NextResponse(data, { headers: res.headers });
}
