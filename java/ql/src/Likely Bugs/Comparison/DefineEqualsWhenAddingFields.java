public class DefineEqualsWhenAddingFields {
    static class Square {
        protected int width = 0;
        public Square(int width) {
            this.width = width;
        }
        @Override
        public boolean equals(Object thatO) {  // This method works only for squares.
            if(thatO != null && getClass() == thatO.getClass() ) {
                Square that = (Square)thatO;
                return width == that.width;
            }
            return false;
        }
    }

    static class Rectangle extends Square {
        private int height = 0;
        public Rectangle(int width, int height) {
            super(width);
            this.height = height;
        }
    }

    public static void main(String[] args) {
        Rectangle r1 = new Rectangle(4, 3);
        Rectangle r2 = new Rectangle(4, 5);
        System.out.println(r1.equals(r2));  // Outputs 'true'
    }
}
