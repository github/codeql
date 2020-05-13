class buf
{
public:
    char *buffer;
};

class packet
{
public:
    buf data;
};

typedef long ssize_t;

ssize_t argument_source(void *buf);

void sink(char *b);

void handlePacket(packet *p)
{
    sink(p->data.buffer); // flow [NOT DETECTED by IR]
}

void f(buf* b)
{
    char *raw;
    packet p;
    argument_source(raw);
    argument_source(b->buffer);
    argument_source(p.data.buffer);
    sink(raw); // flow [NOT DETECTED by IR]
    sink(b->buffer); // flow [NOT DETECTED by IR]
    handlePacket(&p);
}