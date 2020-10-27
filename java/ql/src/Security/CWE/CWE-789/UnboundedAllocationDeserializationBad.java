class A implements Serializable{
    transient Object[] data;

    private void writeObject(java.io.ObjectOutputStream out) throws IOException {
        out.writeInt(data.length);

        for (int i = 0; i < data.length; i++) {
            out.writeObject(data[i]);
        }
    }

    private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
        int length = in.readInt();

        // BAD: An array is allocated whose size could be controlled by an attacker.
        data = new Object[length];

        for (int i = 0; i < length; i++) {
            data[i] = in.readObject()
        }
    }
}