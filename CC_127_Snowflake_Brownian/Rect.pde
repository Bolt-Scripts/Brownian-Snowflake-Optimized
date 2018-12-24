public class Rectangle {
  public PVector pos;
  public float width;
  public float height;
  public color clr = 120;

  public Rectangle(float x, float y, float _width, float _height) {
    pos = new PVector(x, y);
    width = _width;
    height = _height;
  }

  boolean Contains(Particle point) {
    return(
      point.pos.x >= pos.x - width &&
      point.pos.x <= pos.x + width &&
      point.pos.y >= pos.y - height &&
      point.pos.y <= pos.y + height
      );
  }

  boolean Intersects(Rectangle ceckRect) {
    return !(
      ceckRect.pos.x - ceckRect.width > pos.x + width ||
      ceckRect.pos.x + ceckRect.width < pos.x - width ||
      ceckRect.pos.y - ceckRect.height > pos.y + height ||
      ceckRect.pos.y + ceckRect.height < pos.y - height
      );
  }

  void Draw() {
    noFill();
    stroke(clr);
    strokeWeight(1);
    rectMode(CENTER);
    rect(pos.x, pos.y, width * 2, height * 2);
  }
}
