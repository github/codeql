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
    sink(p->data.buffer); // $ ast,ir
}

void f(buf* b)
{
    char *raw;
    packet p;
    argument_source(raw);
    argument_source(b->buffer);
    argument_source(p.data.buffer);
    sink(raw); // $ ast,ir
    sink(b->buffer); // $ ast,ir
    handlePacket(&p);
}