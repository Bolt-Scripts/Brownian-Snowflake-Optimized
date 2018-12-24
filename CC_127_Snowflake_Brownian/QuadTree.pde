static int treeCap = 3;

static color[] queryColors = {
  #A27AFE, 
  #7BCAE1, 
  #79FC4E, 
  #EAA400, 
  #FF2626
};

public class QuadTree {
  //im pretty sure i turned this into basically a bsp tree instead of a quadtree
  //when i was messing with it initially
  
  Rectangle bounds;
  ArrayList<Particle> points;
  boolean divided = false;

  ArrayList<Rectangle> debugQueryRects;

  QuadTree[] quadrants;

  QuadTree(Rectangle _bound, ArrayList<Particle> inPoints) {    
    bounds = _bound;
    points = new ArrayList<Particle>();
    debugQueryRects = new ArrayList<Rectangle>();
    quadrants = new QuadTree[2];

    //passdown code
    if (inPoints != null) {
      for (int i = 0; i < inPoints.size(); ) {
        Particle p = inPoints.get(i);
        if (bounds.Contains(p)) {
          //println(this.toString() + " : " + p.pos);
          points.add(p);
          inPoints.remove(p);
          continue;
        }
        i++;
      }
    }
  }

  boolean Insert(Particle point) {
    if (!bounds.Contains(point))
      return false;

    if (!divided && points.size() < treeCap) {
      points.add(point);
      return true;
    } else {
      if (!divided)
        Subdivide();

      for (QuadTree sect : quadrants)
        if (sect.Insert(point))
          return true;

      return false;
    }
  }

  void Subdivide() {
    divided = true;

    float x = bounds.pos.x;
    float y= bounds.pos.y;
    float hW = bounds.width / 2;
    float hH = bounds.height / 2;
    //quadrants[0] = new QuadTree(new Rectangle(x - hW, y - hH, hW, hH), points);
    //quadrants[1] = new QuadTree(new Rectangle(x + hW, y - hH, hW, hH), points);
    //quadrants[2] = new QuadTree(new Rectangle(x - hW, y + hH, hW, hH), points);
    //quadrants[3] = new QuadTree(new Rectangle(x + hW, y + hH, hW, hH), points);

    if (bounds.height > bounds.width) {
      quadrants[0] = new QuadTree(new Rectangle(x, y - hH, bounds.width, hH), points);
      quadrants[1] = new QuadTree(new Rectangle(x, y + hH, bounds.width, hH), points);
    } else {
      quadrants[0] = new QuadTree(new Rectangle(x - hW, y, hW, bounds.height), points);
      quadrants[1] = new QuadTree(new Rectangle(x + hW, y, hW, bounds.height), points);
    }
  }

  ArrayList<Particle> Query(Rectangle area, int depth) {
    ArrayList<Particle> foundPoints = new ArrayList<Particle>();
    if (bounds.Intersects(area)) {
      if (!divided || points.size() > 0) {
        debugQueryRects.add(bounds);
        bounds.clr = queryColors[depth % queryColors.length];
      }
      if (divided) {
        for (QuadTree sect : quadrants)
          foundPoints.addAll(sect.Query(area, depth + 1));
      } else {
        for (Particle p : points) {
          if (area.Contains(p))
            foundPoints.add(p);
        }
      }
      return foundPoints;
    } else
      return foundPoints;
  }

  void DrawQueryRects() {
    for (Rectangle rect : debugQueryRects) {
      rect.Draw();
    }
    for (QuadTree sect : quadrants) {
      if (sect != null)
        sect.DrawQueryRects();
    }
  }

  void Draw() {
    bounds.Draw();

    if (divided) {
      for (QuadTree sect : quadrants)
        sect.Draw();
    }
  }

  String toString() {
    return getStr(0);
  }

  String getStr(int depth) {
    String retStr = "";
    for (int i = 0; i < depth; i++) {
      retStr += "  ";
    }
    retStr += Integer.toString(points.size());

    if (divided) {
      retStr += "\n";
      for (QuadTree sect : quadrants)
        retStr += sect.getStr(depth + 1) + "\n";
    }

    return retStr;
  }
}
