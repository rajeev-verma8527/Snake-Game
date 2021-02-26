import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Snake extends PApplet {


Body sn;
Food f;
int size = 30; // number of rows/columns
int grid; // size of each block in  pixels
int speed = 8;  //block per second
int framerate = 24; // internal framerate is not consistent resulting in varying speed

public void setup() {
  
  grid = width/size;

  sn = new Body();
  spawnFood();
  frameRate(framerate);
}



public void draw() {
  background(0);
  //If food eaten
  if (f.eaten) spawnFood();

  // Adjusting for different framerate
  if (frameCount %(framerate/speed) == 0) {
    sn.move();
  }

  if (sn.head.x == f.x && sn.head.y == f.y) {
    f.eaten = true;
    sn.grow();
  }

 
 

  f.show();
  sn.show();
}

public void keyPressed() {

  if (keyCode == LEFT) sn.updateDir(Dir.L);
  else if (keyCode == RIGHT) sn.updateDir(Dir.R);
  else if (keyCode == UP) sn.updateDir(Dir.U);
  else if (keyCode == DOWN) sn.updateDir(Dir.D);
}


public void spawnFood() {
  int r, c;
out:
  for (;; ) {
    r= PApplet.parseInt(random(size));
    c=  PApplet.parseInt(random(size));
    for (Vector v : sn.arr) {
      if (r == v.y && c == v.x) {
        continue out;
      }
    }
    break out;
  }
  f = new Food(r, c);
}
class Body {

  Dir dir = Dir.U;
  ArrayList<Vector> arr = new ArrayList<Vector>();
  Dir[] dirarr = new Dir[2];//{ Dir.U, Dir.U};
  int index = -1;
  boolean growing = false;
  Vector head ; 

  Body() {
    for (float y =size*0.5f + 4; y> size*0.5f; y--) {
      arr.add(new Vector(PApplet.parseInt(size/2), PApplet.parseInt(y)));
    }
    head =arr.get(arr.size() -1 );
  }


  public void move() {
    int xOffset = 0, yOffset = 0;
    
    // checking direction list
    for (int i = 0; i< 2; i++) {
      if (dirarr[i] != null) {
        if (!opposites(dirarr[i], dir))
          dir =dirarr[i] ;
        dirarr[i] = null;
        break;
      }
    }
    
    
    //changing direction
    switch(dir) {
    case U:
      xOffset = 0; 
      yOffset = -1;
      break;
    case D:
      xOffset = 0; 
      yOffset = 1;
      break;
    case L:
      xOffset = -1; 
      yOffset = 0;
      break;
    case R:
      xOffset = 1; 
      yOffset = 0;
      break;
    }

    // moving according to the new direction
    head = arr.get(arr.size() -1 );
    int newX = head.x + xOffset;
    int newY   = head.y + yOffset;
    newX %= size + 1;
    newY %= size + 1;
    if (newX <= -1) newX = size ;
    if (newY <= -1) newY = size ;
    arr.add(new Vector(newX, newY));

    
    // removing the tail if not growing
    if (growing) {
      growing = false;
    } else {
      arr.remove(0);
    }
  }


  public void updateDir( Dir d) {

    // small array of size 2 for holding last two direction change
    dirarr[0] = dirarr[1];
    dirarr[1] = d;
  }



  public void grow() {
    growing = true;
  }

  public boolean opposites(Dir a, Dir b) {
    return (a.ordinal() + b.ordinal())% 4 == 1;

    // In Dir enum the contants U, D, L, R, has ordinals 0,1,2,3 
    // and the sum of U,D and L,R, which are opposites,
    // produces 1, 5 respectively
  }



  public void show() {
    fill(255);
    noStroke();
    strokeWeight(1.0f/size* 30);

    // all blocks white
    //for (Vector v : arr) {
    //  rect(v.x * grid, v.y * grid, grid, grid);
    //}
    //Vector front = arr.get(arr.size() -1 );
    //fill(0, 250, 150);
    //circle(front.x * grid + grid/2, front.y * grid +  grid/2, grid);

    //rainbow gradient

    float cval = 0;
    colorMode(HSB, 100);

    for (int i = 0; i < arr.size(); i++) {
      cval  =map(i, 0, arr.size(), 10, 100);
      fill(cval, 100, 100);
      rect(arr.get(i).x * grid, arr.get(i).y * grid, grid, grid);
    }
  }
}
enum Dir { 
  // enum for Directions of the snake
  U, D, L, R
}

class Vector {

  // A Vector class for holding rows and columns

  final int x;
  final int y;

  Vector(int x, int y) {
    this.x = x; 
    this.y = y;
  }
  public boolean equals(Vector v) {
    return this.x == v.x && this.y == v.y;
  }

  public Vector add( Vector v) {
    int x = this.x + v.x;
    int y = this.y + v.y;
    return new Vector(x, y);
  }

  public void show() {
    println(this.x, this.y);
  }
}

class Food {
  int x, y;
  boolean eaten = false;
  Food(int r, int c) {
    x=c;
    y=r;
  }

  public void show() {
    fill(150, 0, 150);
    noStroke();
    rect(x* grid, y* grid, grid, grid);
  }
}
  public void settings() {  size(805, 805); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Snake" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
