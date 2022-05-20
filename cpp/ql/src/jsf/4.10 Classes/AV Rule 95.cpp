enum Shape_color { red, green, blue };
class Shape 
{
  public:
    virtual void draw (Shape_color color = green) const;
    ...
}
class Circle : public Shape 
{
  public:
    virtual void draw (Shape_color  color = red) const;
    ...
}
void fun()
{
  Shape* sp;

  sp = new Circle;
  sp->draw ();      // Invokes Circle::draw(green) even though the default
}				   	// parameter for Circle is red.
