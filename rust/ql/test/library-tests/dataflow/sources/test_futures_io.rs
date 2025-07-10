fn sink<T>(_: T) {}

// --- tests ---

use async_std::net::TcpStream;
use async_std::sync::Arc;
use futures::io::AsyncBufRead;
use futures::io::AsyncBufReadExt;
use futures::io::AsyncRead;
use futures::io::AsyncReadExt;
use futures::StreamExt;
use futures_rustls::TlsConnector;
use std::io;
use std::pin::Pin;
use std::task::{Context, Poll};

async fn test_futures_rustls_futures_io() -> io::Result<()> {
    let url = "www.example.com:443";
    let tcp = TcpStream::connect(url).await?; // $ Alert[rust/summary/taint-sources]
    sink(&tcp); // $ hasTaintFlow=url
    let config = rustls::ClientConfig::builder()
        .with_root_certificates(rustls::RootCertStore::empty())
        .with_no_client_auth();
    let connector = TlsConnector::from(Arc::new(config));
    let server_name = rustls::pki_types::ServerName::try_from("www.example.com").unwrap();
    let mut reader = connector.connect(server_name, tcp).await?;
    sink(&reader); // $ hasTaintFlow=url

    {
        // using the `AsyncRead` trait (low-level)
        let mut buffer = [0u8; 64];
        let mut pinned = Pin::new(&mut reader);
        sink(&pinned); // $ hasTaintFlow=url
        let mut cx = Context::from_waker(futures::task::noop_waker_ref());
        let bytes_read = pinned.poll_read(&mut cx, &mut buffer); // we cannot correctly resolve this call, since it relies on `Deref`
        if let Poll::Ready(Ok(n)) = bytes_read {
            sink(&buffer); // $ MISSING: hasTaintFlow=url
            sink(&buffer[..n]); // $ MISSING: hasTaintFlow=url
        }
    }

    {
        // using the `AsyncReadExt::read` extension method (higher-level)
        let mut buffer1 = [0u8; 64];
        let bytes_read1 = futures::io::AsyncReadExt::read(&mut reader, &mut buffer1).await?;
        sink(&buffer1[..bytes_read1]); // $ hasTaintFlow=url

        let mut buffer2 = [0u8; 64];
        let bytes_read2 = reader.read(&mut buffer2).await?; // we cannot resolve the `read` call, which comes from `impl<R: AsyncRead + ?Sized> AsyncReadExt for R {}` in `async_read_ext.rs`

        sink(&buffer2[..bytes_read2]); // $ MISSING: hasTaintFlow=url
    }

    let mut reader2 = futures::io::BufReader::new(reader);
    sink(&reader2); // $ hasTaintFlow=url

    {
        // using the `AsyncBufRead` trait (low-level)
        let mut pinned = Pin::new(&mut reader2);
        sink(&pinned); // $ hasTaintFlow=url
        let mut cx = Context::from_waker(futures::task::noop_waker_ref());
        let buffer = pinned.poll_fill_buf(&mut cx);
        if let Poll::Ready(Ok(buf)) = buffer {
            sink(&buffer); // $ hasTaintFlow=url
            sink(buf); // $ MISSING: hasTaintFlow=url
        }

        // using the `AsyncBufRead` trait (alternative syntax)
        let buffer2 = Pin::new(&mut reader2).poll_fill_buf(&mut cx);
        match (buffer2) {
            Poll::Ready(Ok(buf)) => {
                sink(&buffer2); // $ hasTaintFlow=url
                sink(buf); // $ hasTaintFlow=url
            }
            _ => {
                // ...
            }
        }
    }

    {
        // using the `AsyncBufReadExt::fill_buf` extension method (higher-level)
        let buffer = reader2.fill_buf().await?; // we cannot resolve the `fill_buf` call, which comes from `impl<R: AsyncBufRead + ?Sized> AsyncBufReadExt for R {}` in `async_buf_read_ext.rs`
        sink(buffer); // $ MISSING: hasTaintFlow=url
    }

    {
        // using the `AsyncRead` trait (low-level)
        let mut buffer = [0u8; 64];
        let mut pinned = Pin::new(&mut reader2);
        sink(&pinned); // $ hasTaintFlow=url
        let mut cx = Context::from_waker(futures::task::noop_waker_ref());
        let bytes_read = pinned.poll_read(&mut cx, &mut buffer);
        sink(&buffer); // $ MISSING: hasTaintFlow=url
        if let Poll::Ready(Ok(n)) = bytes_read {
            sink(&buffer[..n]); // $ MISSING: hasTaintFlow=url
        }
    }

    {
        // using the `AsyncReadExt::read` extension method (higher-level)
        let mut buffer1 = [0u8; 64];
        let bytes_read1 = futures::io::AsyncReadExt::read(&mut reader2, &mut buffer1).await?;
        sink(&buffer1[..bytes_read1]); // $ hasTaintFlow=url

        let mut buffer2 = [0u8; 64];
        let bytes_read2 = reader2.read(&mut buffer2).await?; // we cannot resolve the `read` call, which comes from `impl<R: AsyncRead + ?Sized> AsyncReadExt for R {}` in `async_read_ext.rs`
        sink(&buffer2[..bytes_read2]); // $ MISSING: hasTaintFlow=url
    }

    {
        // using the `AsyncBufRead` trait (low-level)
        let mut pinned = Pin::new(&mut reader2);
        sink(&pinned); // $ hasTaintFlow=url
        let mut cx = Context::from_waker(futures::task::noop_waker_ref());
        let buffer = pinned.poll_fill_buf(&mut cx);
        sink(&buffer); // $ hasTaintFlow=url
        if let Poll::Ready(Ok(buf)) = buffer {
            sink(buf); // $ MISSING: hasTaintFlow=url
        }
    }

    {
        // using the `AsyncBufReadExt::fill_buf` extension method (higher-level)
        let buffer = reader2.fill_buf().await?; // we cannot resolve the `fill_buf` call, which comes from `impl<R: AsyncBufRead + ?Sized> AsyncBufReadExt for R {}` in `async_buf_read_ext.rs`
        sink(buffer); // $ MISSING: hasTaintFlow=url
    }

    {
        // using the `AsyncBufReadExt::read_until` extension method
        let mut line = Vec::new();
        let _bytes_read = reader2.read_until(b'\n', &mut line).await?; // we cannot resolve the `read_until` call, which comes from `impl<R: AsyncBufRead + ?Sized> AsyncBufReadExt for R {}` in `async_buf_read_ext.rs`
        sink(&line); // $ MISSING: hasTaintFlow=url
    }

    {
        // using the `AsyncBufReadExt::read_line` extension method
        let mut line = String::new();
        let _bytes_read = reader2.read_line(&mut line).await?; // we cannot resolve the `read_line` call, which comes from `impl<R: AsyncBufRead + ?Sized> AsyncBufReadExt for R {}` in `async_buf_read_ext.rs`
        sink(&line); // $ MISSING: hasTaintFlow=url
    }

    {
        // using the `AsyncBufReadExt::read_to_end` extension method
        let mut buffer = Vec::with_capacity(1024);
        let _bytes_read = reader2.read_to_end(&mut buffer).await?; // we cannot resolve the `read` call, which comes from `impl<R: AsyncRead + ?Sized> AsyncReadExt for R {}` in `async_read_ext.rs`
        sink(&buffer); // $ MISSING: hasTaintFlow=url
    }

    {
        // using the `AsyncBufReadExt::lines` extension method
        let mut lines_stream = reader2.lines(); // we cannot resolve the `lines` call, which comes from `impl<R: AsyncBufRead + ?Sized> AsyncBufReadExt for R {}` in `async_buf_read_ext.rs`
        sink(lines_stream.next().await.unwrap()); // $ MISSING: hasTaintFlow=url
        while let Some(line) = lines_stream.next().await {
            sink(line.unwrap()); // $ MISSING: hasTaintFlow
        }
    }

    Ok(())
}
