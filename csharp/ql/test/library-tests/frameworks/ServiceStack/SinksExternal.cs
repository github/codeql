using System.Collections.Generic;
using System.Linq;
using ServiceStack;
using System.Threading.Tasks;
using System;
using Microsoft.Extensions.ObjectPool;
using System.IO;

namespace ServiceStackTest
{
    public class ResponseDto { }
    public class ReqDto1 : IReturn<ResponseDto> { }

    public class ReqDto2 : IReturnVoid { }

    public class C
    {
        public async Task M()
        {
            var client = new JsonServiceClient("");

            client.DeserializeFromStream<object>(new MemoryStream());   // not a sink

            client.Get(new ReqDto1());
            client.Get(new ReqDto2());
            client.Get<ResponseDto>("relativeOrAbsoluteUrl");           // not a sink
            client.Get<ResponseDto>(new object());
            client.Get("relativeOrAbsoluteUrl");                        // not a sink
            client.Get(new object());

            await client.GetAsync<ResponseDto>("relativeOrAbsoluteUrl");    // not a sink
            await client.GetAsync<ResponseDto>(new object());
            await client.GetAsync(new ReqDto1());
            await client.GetAsync(new ReqDto2());


            client.CustomMethod("GET", new ReqDto2());
            client.CustomMethod<ResponseDto>("GET", "relativeOrAbsoluteUrl", new ReqDto1());
            client.CustomMethod<ResponseDto>("GET", new ReqDto1());
            client.CustomMethod<ResponseDto>("GET", new object());
            client.CustomMethod("GET", "relativeOrAbsoluteUrl", new object());
            client.CustomMethod("GET", (IReturnVoid)null);
            await client.CustomMethodAsync("GET", new ReqDto2());
            await client.CustomMethodAsync<ResponseDto>("GET", "relativeOrAbsoluteUrl", new ReqDto1());
            await client.CustomMethodAsync<ResponseDto>("GET", new ReqDto1());
            await client.CustomMethodAsync<ResponseDto>("GET", new object());

            client.DownloadBytes("GET", "requestUri", new object());
            await client.DownloadBytesAsync("GET", "relativeOrAbsoluteUrl", new object());

            client.Head(new object());
            client.Patch(new object());
            client.Post(new object());
            client.Put(new object());

            client.Send<ResponseDto>(new object());
            client.Publish(new ReqDto1());
            client.SendOneWay(new object());
        }
    }
}
