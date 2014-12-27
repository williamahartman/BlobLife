
  ///////////////////////////////////////////////////
 //                   GUI CODE                    //
///////////////////////////////////////////////////

public class Slider
{
    float x, y, width, height;
    float valueX = 0;
    float value; // change this one to type double if you need the extra precision
    
    Slider ( float xx, float yy, float ww, float hh) 
    {
        x = xx; 
        y = yy; 
        width = ww; 
        height = hh;
    
        // register it
        Interactive.add( this );
    }
    
    void setValue(float value) {
        this.value = value;
        valueX = map(value, 0, 1, x, x+width-height);
    }
    
    // called from manager
    void mouseDragged ( float mx, float my, float dx, float dy )
    {
        valueX = mx - height/2;
        
        if ( valueX < x ) valueX = x;
        if ( valueX > x+width-height ) valueX = x+width-height;
        
        value = map( valueX, x, x+width-height, 0, 1 );
    }

    void draw () 
    {
        noStroke();
        
        fill(0, 0, 30 );
        rect(x, y, width, height);
        
        fill(0, 0, 50 );
        rect( valueX, y, height, height );
    }
}


public class MultiSlider
{
    float x,y,width,height;
    boolean on = false;
    
    SliderHandle left, right, activeHandle;
    
    float values[];
    
    MultiSlider ( float xx, float yy, float ww, float hh )
    {
        this.x = xx; this.y = yy; this.width = ww; this.height = hh;
        
        left  = new SliderHandle( x, y, height, height );
        right = new SliderHandle( x+width-height, y, height, height );
        
        values = new float[]{0,1};
        
        Interactive.add(this);
    }
    
    void setValues(float val1, float val2) {
      if(val1 < val2) {
        values[0] = val1;
        values[1] = val2;
      } else {
        values[0] = val2;
        values[1] = val1;
      }
      
      left.x = map(val1, 0, 1, x, x+width-left.width);
      right.x = map(val2, 0, 1, x, x+width-right.width);
    }
    
    void mouseEntered ()
    {
        on = true;
    }
    
    void mouseExited ()
    {
        on = false;
    }
    
    void mousePressed ( float mx, float my )
    {
        if ( left.isInside( mx, my ) ) activeHandle = left;
        else if ( right.isInside( mx, my ) ) activeHandle = right;
    }
    
    void mouseDragged ( float mx, float my, float dx, float dy )
    {
        if ( activeHandle == null ) return;
        
        float vx = mx - activeHandle.width/2;
        
        vx = constrain( vx, x, x+width-activeHandle.width );
        
        if ( activeHandle == left )
        {
            if ( vx > right.x - activeHandle.width ) vx = right.x - activeHandle.width;
            values[0] = map( vx, x, x+width-activeHandle.width, 0, 1 );
        }
        else
        {
            if ( vx < left.x + activeHandle.width ) vx = left.x + activeHandle.width;
            values[1] = map( vx, x, x+width-activeHandle.width, 0, 1 );
        }
        
        activeHandle.x = vx;
    }
    
    void draw ()
    {
        noStroke();
        fill(0, 0, 30 );
        rect( x, y, width, height );
        fill( 0, 0, on ? 50 : 40);
        rect( left.x, left.y, right.x-left.x+right.width, right.height );
    }
    
    public boolean isInside ( float mx, float my )
    {
        return left.isInside(mx,my) || right.isInside(mx,my);
    }
}

class SliderHandle
{
    float x,y,width,height;
    
    SliderHandle ( float xx, float yy, float ww, float hh )
    {
        this.x = xx; this.y = yy; this.width = ww; this.height = hh;
    }
    
    void draw ()
    {
        rect( x, y, width, height );
    }
    
    public boolean isInside ( float mx, float my )
    {
        return Interactive.insideRect( x, y, width, height, mx, my );
    }
}

public class ResetButton
{
    float x, y, width, height;
    String text;
    boolean on;
    
    ResetButton ( float xx, float yy, float w, float h, String text)
    {
        x = xx; y = yy; width = w; height = h;
        this.text = text;
        on = false;
        Interactive.add( this ); // register it with the manager
    }
    
    // called by manager
    
    void mouseEntered ()
    {
        on = true;
    }
    
    void mouseExited ()
    {
        on = false;
    }
    
    void mousePressed ( float mx, float my ) 
    {
        g.reset();
    }

    void draw () 
    {        
        fill(0, 0, on ? 50 : 30);
        text(text, x, y + 12);
    }
}

public class ResetSlidersButton
{
    float x, y, width, height;
    String text;
    boolean on;
    
    ResetSlidersButton ( float xx, float yy, float w, float h, String text)
    {
        x = xx; y = yy; width = w; height = h;
        this.text = text;
        on = false;
        Interactive.add( this ); // register it with the manager
    }
    
    // called by manager
    
    void mouseEntered ()
    {
        on = true;
    }
    
    void mouseExited ()
    {
        on = false;
    }
    
    void mousePressed ( float mx, float my ) 
    {
       blurPassesSlider.setValue(0.8);
       sizeSlider.setValue(0.3);
       hueSlider.setValues(0.15, 0.95);
       saturationSlider.setValues(0.3, 0.9);
    }

    void draw () 
    {        
        fill(0, 0, on ? 50 : 30);
        text(text, x, y + 12);
    }
}


