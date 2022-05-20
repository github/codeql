
struct Struct
{
	int get_x() {return x;}
	int get_y() {return y;}
	void set_x(int _x) {x = _x;}
	void set_y(int _y) {y = _y;}
	void something_else() {};

	int x, y;
};

class StructLikeClass
{
public:
	StructLikeClass() : x(0), y(0) {}

	int get_x() {return x;}
	int get_y() {return y;}
	void set_x(int _x) {x = _x;}
	void set_y(int _y) {y = _y;}

private:
	int x, y;
};

class NotStructLikeClass
{
public:
	NotStructLikeClass() : x(0), y(0) {}

	int get_x() {return x;}
	int get_y() {return y;}
	void set_x(int _x) {x = _x;}
	void set_y(int _y) {y = _y;}
	void something_else() {};

private:
	int x, y;
};
