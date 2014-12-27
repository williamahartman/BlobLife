import de.bezier.guido.*;

int defaultStartNum = 2000;
float defaultNeighborDist = 6;

GameOfLife g;
PShader blur;

Slider blurPassesSlider;
Slider sizeSlider;
MultiSlider hueSlider;
MultiSlider saturationSlider;

void setup() {
       //Window setup
       colorMode(HSB, 100);
       size(500, 500, P2D);
       background(0);
       frameRate(30);
       blur = loadShader("blur.glsl");
       
       //GUI setup
       Interactive.make(this);
       blurPassesSlider = new Slider(73, height - 48, width - 75, 10);
       blurPassesSlider.setValue(0.8);
       
       sizeSlider = new Slider(73, height - 36, width - 75, 10);
       sizeSlider.setValue(0.3);
       
       hueSlider = new MultiSlider(73, height - 24, width - 75, 10);
       hueSlider.setValues(0.15, 0.95);
       
       saturationSlider = new MultiSlider(73, height - 12, width - 75, 10);
       saturationSlider.setValues(0.3, 0.9);
       
       ResetButton resetButton = new ResetButton(width - 62, 0, 62, 15, "reset cells");
       ResetSlidersButton resetSlidersButton = new ResetSlidersButton(width - 73, height - 64, 73, 15, "reset sliders");
       
       
       //Game setup
       g = new GameOfLife(defaultStartNum, width, height - 48);
}

void draw() {  
       //update
       g.updateGame(defaultNeighborDist);
       
       //Draw (draw -> blur -> threshold)
       background(0);
       g.drawGame(2 + (sizeSlider.value * 10),
                  hueSlider.values[0] * 100,
                  hueSlider.values[1] * 100,
                  saturationSlider.values[0] * 100,
                  saturationSlider.values[1] * 100);
       
       for(int i = 0; i < blurPassesSlider.value * 30; i++ ) {
         filter(blur);
       }
       threshold(20);
       
       //Label background
       fill(0, 0, 10);
       rect(0, width - 50, width, 50);
       
       //Labels
       fill(0, 0, 50);
       text(g.cellList.size() + " cells", 2, 12);
       text("blur passes", 2, height - 39);
       text("cell size", 2, height - 27);
       text("hue range", 2, height - 15);
       text("saturation", 2, height - 2);
}

//A custom threshold implementation, preserves color. (not brightness though, just hue and saturation)
void threshold(float threshold) {
  loadPixels();
  for(int i = 0; i < pixels.length; i++) {
    if(brightness(pixels[i]) > threshold) {
      pixels[i] = color(hue(pixels[i]), saturation(pixels[i]), 100);
    } else {
      pixels[i] = color(0, 0, 0);
    }
  }
  
  updatePixels();
}

//Reset if space is pressed
void keyPressed() {
  if (key == ' ') {
     g.reset();
  }
}

//Painting cells on the screen
void mouseDragged() {
  for(int i = 0; i < 20; i++) {
    int hueBase = mouseX % 100;
    int saturationBase = mouseY % 100;
    
    g.cellList.add(new Cell(new Point(random(mouseX - 20, mouseX + 20), 
                                      random(mouseY - 20, mouseY + 20)), 
                            color(random(hueBase - 10, hueBase + 10),
                                  random(saturationBase - 10, saturationBase + 10),
                                  100)));
  } 
}
