//Point class, convenience class for points.
class Point {
  float x;
  float y;
  
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  //Return the distance between two points
  float dist(Point p2) {
     return sqrt(sq(x - p2.x) + sq(y - p2.y));
  }
}

//Cell class. Has a location and a draw function.
class Cell {
  Point p;
  color c;
  
  //Constructor, point and color get passed
  Cell(Point p, color c) {
    this.p = p;
    this.c =  c;
  }
  
  //Draws the cell as a circle at its location, at the passed draw size.
  void drawCell(float cellSize, float hueLow, float hueHigh, float saturationLow, float saturationHigh) {
    noStroke();
    fill(map(hue(c), 0, 100, hueLow, hueHigh), 
         map(saturation(c), 0, 100, saturationLow, saturationHigh),
         100);
    ellipse(p.x, p.y, cellSize, cellSize); 
  }
}

//Runs the game of life. Holds a list of all cells, and handles updating that list. Also draws the
//cells it contains.
class GameOfLife {
  int startNum;
  
  int xSize;
  int ySize;
  ArrayList<Cell> cellList;
  
  //Constructor, takes initial number of cells.
  GameOfLife(int startNum, int xSize, int ySize) {
    this.startNum = startNum;
    this.cellList = new ArrayList<Cell>(5000);
    this.xSize = xSize;
    this.ySize = ySize;
    
    for(int i = 0; i < startNum; i++) {
      cellList.add(new Cell(new Point(random(xSize), 
                                      random(ySize)), 
                            color(random(100), random(100), 100)));
    }
  }
  
  //Updates the game, cells as close as or closer than the passed value are considered neighbors.
  void updateGame(float neighborDist) {
    for(int i = 0; i < cellList.size(); i++) {
      Cell currentCell = cellList.get(i);
      
      //Count neighbors for the current cell
      int numNeighbors = 0;
      for(int j = 0; j < cellList.size(); j++) {
        if(i != j && currentCell.p.dist(cellList.get(j).p) < neighborDist) {
          numNeighbors++;
        }
      }
      
      //Kill cells (too many neighbors, too few neighbors, or off screen)
      if(numNeighbors < 2 || 
         numNeighbors > 3 || 
         currentCell.p.x < 0 || currentCell.p.x > xSize || currentCell.p.y < 0 || currentCell.p.y > ySize) {
        cellList.remove(i);
        i--;
      }
      
      //Make new cell (2 or 3 neighbors).
      if(numNeighbors >= 2 && numNeighbors <= 3) {
        cellList.add(new Cell(new Point(currentCell.p.x + random(-neighborDist - 4.85, neighborDist + 4.85), 
                                        currentCell.p.y + random(-neighborDist - 4.85, neighborDist + 4.85)),
                              color(hue(currentCell.c) + random(-1, 1), 
                                    saturation(currentCell.c) + random(-1, 1), 
                                    100)));
      }
    }
  }
  
  //Draw all the cells in the game
  void drawGame(float cellSize, float hueLow, float hueHigh, float saturationLow, float saturationHigh) {
    for(Cell c: cellList) {
      c.drawCell(cellSize, hueLow, hueHigh, saturationLow, saturationHigh); 
    }
  }
  
  //Remove all the cells and restart
  void reset() {
    this.cellList = new ArrayList<Cell>(5000);
    
    for(int i = 0; i < startNum; i++) {
      cellList.add(new Cell(new Point(random(xSize), 
                                      random(ySize)), 
                            color(random(100), random(100), 100)));
    }
  }
}

