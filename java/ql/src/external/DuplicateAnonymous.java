// BAD: Duplicate anonymous classes:
button1.addActionListener(new ActionListener() {
    public void actionPerfored(ActionEvent e)
    {
        for (ActionListener listener: listeners)
            listeners.actionPerformed(e);
    }
});

button2.addActionListener(new ActionListener() {
    public void actionPerfored(ActionEvent e)
    {
        for (ActionListener listener: listeners)
            listeners.actionPerformed(e);
    }
});

// ... and so on.

// GOOD: Better solution:
class MultiplexingListener implements ActionListener {
    public void actionPerformed(ActionEvent e) {
        for (ActionListener listener : listeners)
            listener.actionPerformed(e);
    }
}

button1.addActionListener(new MultiplexingListener());
button2.addActionListener(new MultiplexingListener());
// ... and so on.
