class FHammerbro extends FGameObject {
  int direction = L;
  int speed = 50;
  int frame = 0;

  FHammerbro(float x, float y) {
    super();
    setPosition(x, y);
    setName("hammerbro");
    setRotatable(false);
  }


  void act() {
    animate();
    collide();
    move();
  }


  void animate() {
    if (frame >= hammerbro.length) frame = 0;
    if (frameCount % 5 == 0) {
      if (direction == R) attachImage(hammerbro[frame]);
      if (direction == L) attachImage(reverseImage(hammerbro[frame]));
      frame++;
    }
  }

  void collide() {
    if (isTouching("wall")) {
      direction *= - 1;
      setPosition(getX()+direction, getY()-gridSize/2);
      throwHammer();
    }
    if (isTouching("player")) {
      if ( player.getY() < getY()) {
        world.remove(this);
        enemies.remove(this);
        player.setVelocity(player.getVelocityX(), -300);
      } else {
        playerlives--;
        player.setPosition(0, 0);
      }
    }
  }

  void move() {
    float vy = getVelocityY();
    setVelocity(speed*direction, vy);
  }

  void throwHammer() {
    FBox h = new FBox(gridSize, gridSize);
    h.setPosition(getX(), getY());
    h.attachImage(hammer);
    h.setName("hammer");
    h.setSensor(true);
    h.setVelocity(random(-300, 300), -400);
    h.setAngularVelocity(50);
    world.add(h);
  }
}
