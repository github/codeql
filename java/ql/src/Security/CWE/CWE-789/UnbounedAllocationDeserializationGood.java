class A implements Serializable{
    transient Object[] data;

    private void writeObject(java.io.ObjectOutputStream out) throws IOException {
        out.writeInt(data.length);

        for (int i = 0; i < data.length; i++) {
            out.writeLong(data[i]);
        }
    }

    private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
        int length = in.readInt();

        // GOOD: An ArrayList is used, which dynamically allocates memory as needed.
        ArrayList<Object> dataList = new ArrayList<Object>();

        for (int i = 0; i < length; i++) {
            dataList.add(in.readObject());
        }

        data = dataList.toArray();
    }
}