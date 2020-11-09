class Body {

  Dir dir = Dir.U;
  ArrayList<Vector> arr = new ArrayList<Vector>();
  Dir[] dirarr = new Dir[2];//{ Dir.U, Dir.U};
  int index = -1;
  boolean growing = false;
  Vector head ; 

  Body() {
    for (float y =size*0.5 + 4; y> size*0.5; y--) {
      arr.add(new Vector(int(size/2), int(y), Dir.U));
    }
    head =arr.get(arr.size() -1 );
  }


  void move() {
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
    arr.add(new Vector(newX, newY, this.dir));


    // removing the tail if not growing
    if (growing) {
      growing = false;
    } else {
      arr.remove(0);
    }
  }


  void updateDir( Dir d) {

    // small array of size 2 for holding last two direction change
    dirarr[0] = dirarr[1];
    dirarr[1] = d;
  }



  void grow() {
    growing = true;
  }

  boolean opposites(Dir a, Dir b) {
    return (a.ordinal() + b.ordinal())% 4 == 1;

    // In Dir enum the contants U, D, L, R, has ordinals 0,1,2,3 
    // and the sum of U,D and L,R, which are opposites,
    // produces 1, 5 respectively
  }



  void show() {
    push();
    fill(255);
    noStroke();
    strokeWeight(1.0/size* 30);

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
    pop();
  }

  void show2() {


    Vector first = arr.get(0);
    Vector second = arr.get(1);
    Vector last = arr.get(arr.size()- 1);
    Vector scndLast = arr.get(arr.size() -2);
    
    block(first, first.compare(second));
    block(last, last.compare(scndLast));
    

    for (int i = 1; i< arr.size() - 1; i++) {
      Vector current = arr.get(i);
      block(current, current.compare(arr.get(i-1)));
      block(current, current.compare(arr.get(i+1)));
    }
  }

  void block(Vector v, Dir dir) {
    int thickness = 8, w = 0, h = 0, blockX = 0, blockY= 0;
    int x = v.x * grid;
    int y = v.y * grid;
    switch(dir) {
    case U:
      blockX = x + grid/2 - thickness;
      blockY = y;
      w = thickness*2;
      h = grid/2 + thickness;
      break;
    case D:
      blockX = x + grid/2 - thickness;
      blockY = y + grid/2 - thickness;
      w = thickness*2;
      h = grid/2 + thickness;
      break;
    case L:
      blockX = x;
      blockY = y + grid/2 - thickness;
      w = grid/2 + thickness;
      h = thickness*2;
      break;
    case R:
      blockX = x + grid/2 - thickness;
      blockY = y + grid/2 - thickness;
      w = grid/2 + thickness;
      h = thickness*2;
    }
    push();
    //rectMode(CENTER);
    colorMode(RGB);
    fill(255);
    //stroke(255, 0, 0);
    rect(blockX, blockY, w, h);
    pop();
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
  final Dir dir;

  Vector(int x, int y, Dir d) {
    this.x = x; 
    this.y = y;
    this.dir = d;
  }
  boolean equals(Vector v) {
    return this.x == v.x && this.y == v.y;
  }

  Dir compare( Vector v) {
    Dir ret = this.dir;
    if ( this.x == v.x)
      ret =  (v.y < this.y) ? Dir.U : Dir.D;
    if ( this.y == v.y)
      ret =  (v.x < this.x) ? Dir.L : Dir.R;
    return ret;
  }

  void show() {
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

  void show() {
    fill(150, 0, 150); 
    noStroke(); 
    rect(x* grid, y* grid, grid, grid);
  }
}
