class Body {

  Dir dir = Dir.U;
  ArrayList<Vector> arr = new ArrayList<Vector>();
  Dir[] dirarr = new Dir[2];//{ Dir.U, Dir.U};
  int index = -1;
  boolean growing = false;
  Vector head ; 

  Body() {
    for (float y =size*0.5 + 4; y> size*0.5; y--) {
      arr.add(new Vector(int(size/2), int(y)));
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
    arr.add(new Vector(newX, newY));


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
    for (int i = 0; i< arr.size() - 1; i++)
      smear(arr.get(i), arr.get(i+1));
    }

    void smear(Vector a, Vector b) {
      final int offset = 10;
      push();
      colorMode(RGB);
      fill(255);
      stroke(255);
      strokeWeight(10);
      rect(a.x* grid + grid/2 - offset, a.y* grid + grid/2 - offset, 
        (b.x - a.x)* grid + offset, (b.y - a.y)* grid + offset );   
      //line(a.x * grid,a.y * grid,b.x* grid, b.y* grid);
      
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

  Vector(int x, int y) {
    this.x = x; 
    this.y = y;
  }
  boolean equals(Vector v) {
    return this.x == v.x && this.y == v.y;
  }

  Vector add( Vector v) {
    int x = this.x + v.x;
    int y = this.y + v.y;
    return new Vector(x, y);
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
