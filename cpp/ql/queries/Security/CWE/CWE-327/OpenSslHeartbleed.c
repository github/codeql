int
tls1_process_heartbeat(SSL *s)
    {
    unsigned char *p = &s->s3->rrec.data[0], *pl;
    unsigned short hbtype;
    unsigned int payload;
 
    /* ... */
 
    hbtype = *p++;
    n2s(p, payload);
    pl = p;
 
    /* ... */
 
    if (hbtype == TLS1_HB_REQUEST)
            {
            /* ... */
            memcpy(bp, pl, payload);  // BAD: overflow here
            /* ... */
            }
 
 
    /* ... */
 
    }
