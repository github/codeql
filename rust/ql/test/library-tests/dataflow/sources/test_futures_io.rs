fn sink<T>(_: T) { }

// --- tests ---

use std::pin::Pin;
use std::task::{Context, Poll};
use std::io;
use futures::io::AsyncRead;
use futures::io::AsyncReadExt;
use futures::io::AsyncBufRead;
use futures::io::AsyncBufReadExt;
use futures::StreamExt;
use futures_rustls::{TlsConnector};
use async_std::sync::Arc;
use async_std::net::TcpStream;

async fn test_futures_rustls_futures_io() -> io::Result<()> {
    let url = "www.example.com:443";
    let tcp = TcpStream::connect(url).await?; // $ MISSING: Alert[rust/summary/taint-sources]
    sink(&tcp); // $ MISSING: hasTaintFlow
    let config = rustls::ClientConfig::builder()
        .with_root_certificates(rustls::RootCertStore::empty())
        .with_no_client_auth();
    let connector = TlsConnector::from(Arc::new(config));
    let server_name = rustls::pki_types::ServerName::try_from("www.example.com").unwrap();
    let mut reader = connector.connect(server_name, tcp).await?;
    sink(&reader); // $ MISSING: hasTaintFlow

    {
        // using the `AsyncRead` trait (low-level)
        let mut buffer = [0u8; 64];
        let mut pinned = Pin::new(&mut reader);
        sink(&pinned); // $ MISSING: hasTaintFlow
        let mut cx = Context::from_waker(futures::task::noop_waker_ref());
        let bytes_read = pinned.poll_read(&mut cx, &mut buffer);
        if let Poll::Ready(Ok(n)) = bytes_read {
            sink(&buffer); // $ MISSING: hasTaintFlow=url
            sink(&buffer[..n]); // $ MISSING: hasTaintFlow=url
        }
    }

    {
        // using the `AsyncReadExt::read` extension method (higher-level)
        let mut buffer1 = [0u8; 64];
        let bytes_read1 = futures::io::AsyncReadExt::read(&mut reader, &mut buffer1).await?;
        sink(&buffer1[..bytes_read1]); // $ MISSING: hasTaintFlow

        let mut buffer2 = [0u8; 64];
        let bytes_read2 = reader.read(&mut buffer2).await?;
        sink(&buffer2[..bytes_read2]); // $ MISSING: hasTaintFlow
    }

    let mut reader2 = futures::io::BufReader::new(reader);
    sink(&reader2); // $ MISSING: hasTaintFlow

    {
        // using the `AsyncBufRead` trait (low-level)
        let mut pinned = Pin::new(&mut reader2);
        sink(&pinned); // $ MISSING: hasTaintFlow
        let mut cx = Context::from_waker(futures::task::noop_waker_ref());
        let buffer = pinned.poll_fill_buf(&mut cx);
        if let Poll::Ready(Ok(buf)) = buffer {
            sink(&buffer); // $ MISSING: hasTaintFlow=url
            sink(buf); // $ MISSING: hasTaintFlow=url
        }

        // using the `AsyncBufRead` trait (alternative syntax)
        let buffer2 = Pin::new(&mut reader2).poll_fill_buf(&mut cx);
        match (buffer2) {
            Poll::Ready(Ok(buf)) => {
                sink(&buffer2); // $ MISSING: hasTaintFlow=url
                sink(buf); // $ MISSING: hasTaintFlow=url
            }
            _ => {
                // ...
            }
        }
    }

    {
        // using the `AsyncBufReadExt::fill_buf` extension method (higher-level)
        let buffer = reader2.fill_buf().await?;
        sink(buffer); // $ MISSING: hasTaintFlow
    }

    {
        // using the `AsyncRead` trait (low-level)
        let mut buffer = [0u8; 64];
        let mut pinned = Pin::new(&mut reader2);
        sink(&pinned); // $ MISSING: hasTaintFlow
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
        sink(&buffer1[..bytes_read1]); // $ MISSING: hasTaintFlow

        let mut buffer2 = [0u8; 64];
        let bytes_read2 = reader2.read(&mut buffer2).await?;
        sink(&buffer2[..bytes_read2]); // $ MISSING: hasTaintFlow
    }

    {
        // using the `AsyncBufRead` trait (low-level)
        let mut pinned = Pin::new(&mut reader2);
        sink(&pinned); // $ MISSING: hasTaintFlow
        let mut cx = Context::from_waker(futures::task::noop_waker_ref());
        let buffer = pinned.poll_fill_buf(&mut cx);
        sink(&buffer); // $ MISSING: hasTaintFlow=url
        if let Poll::Ready(Ok(buf)) = buffer {
            sink(buf); // $ MISSING: hasTaintFlow=url
        }
    }

    {
        // using the `AsyncBufReadExt::fill_buf` extension method (higher-level)
        let buffer = reader2.fill_buf().await?;
        sink(buffer); // $ MISSING: hasTaintFlow
    }

    {
        // using the `AsyncBufReadExt::read_until` extension method
        let mut line = Vec::new();
        let _bytes_read = reader2.read_until(b'\n', &mut line).await?;
        sink(&line); // $ MISSING: hasTaintFlow
    }

    {
        // using the `AsyncBufReadExt::read_line` extension method
        let mut line = String::new();
        let _bytes_read = reader2.read_line(&mut line).await?;
        sink(&line); // $ MISSING: hasTaintFlow
    }

    {
        // using the `AsyncBufReadExt::read_to_end` extension method
        let mut buffer = Vec::with_capacity(1024);
        let _bytes_read = reader2.read_to_end(&mut buffer).await?;
        sink(&buffer); // $ MISSING: hasTaintFlow
    }

    {
        // using the `AsyncBufReadExt::lines` extension method
        let mut lines_stream = reader2.lines();
        sink(lines_stream.next().await.unwrap()); // $ MISSING: hasTaintFlow
        while let Some(line) = lines_stream.next().await {
            sink(line.unwrap()); // $ MISSING: hasTaintFlow
        }
    }

    Ok(())
}
