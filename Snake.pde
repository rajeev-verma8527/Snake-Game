
Body sn;
Food f;
int size = 20; // number of rows/columns
int grid; // size of each block in  pixels
int speed = 4;  //block per second
int framerate = 24; // internal framerate is not consistent resulting in varying speed
boolean paused = false;
int snakeWidth = 9;
void setup() {
  size(805, 805);
  grid = width/size;

  sn = new Body();
  spawnFood();
  frameRate(framerate);
}



void draw() {
  if ( paused) return;
  background(0);

  //If food eaten
  if (f.eaten) spawnFood();

  // Adjusting for different framerate
  if (frameCount %(framerate/speed) == 0) {
    if (sn.hit() || sn.win()) {
      paused = true;
      sn = new Body();
    }
    sn.move();
  }

  if (sn.head.x == f.x && sn.head.y == f.y) {
    f.eaten = true;
    sn.grow();
  }



  f.show();
  //sn.show();

  sn.show2();
}

void keyPressed() {
  if (!paused) {
    if (keyCode == LEFT) sn.updateDir(Dir.L);
    else if (keyCode == RIGHT) sn.updateDir(Dir.R);
    else if (keyCode == UP) sn.updateDir(Dir.U);
    else if (keyCode == DOWN) sn.updateDir(Dir.D);
  }
  if (keyCode == ' ' && !sn.gameOver)
    if (paused) paused = false;
    else paused = true;

  if (keyCode == ' ' && sn.gameOver) {
    sn = new Body();
  }
}


void spawnFood() {
  int r, c;
out:
  for (;; ) {
    r= int(random(size));
    c=  int(random(size));
    for (Vector v : sn.arr) {
      if (r == v.y && c == v.x) {
        continue out;
      }
    }
    break out;
  }
  f = new Food(r, c);
}
