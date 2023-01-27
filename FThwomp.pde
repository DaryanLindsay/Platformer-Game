class FThwomp extends FGameObject {
  float setX;
  float setY;
  float randomX;
  float randomY;
  boolean triggered;
  int r = 0;
  int k = 0;
  int p = 0;



  FThwomp( float x, float y) {
    super(2, 2);
    setPosition(x, y);
    setName("thwomp");
    setRotatable(false);
    setStatic(true);
    setX = x;
    setY = y;
  }

  void act() {
    animate();
    collide();
  }

  void animate() {
    randomX = setX + random(-2, 2);
    randomY = setY + random(-2, 2);
    attachImage(thwomp[0]);
    if (getX() - player.getX() < gridSize && getX() - player.getX() > -gridSize && player.getY() > getY()) {
      triggered = true;
    }
    if (getY() == setY + 5*gridSize) {
      r++;
    }
    if (!triggered) {
      setStatic(true);
      k = 0;
      if (getY() >= setY) {
        int b = 0;
        b++;
        setPosition(setX, getY() - b);
      }
    }
    if (triggered) {
      p = 0;
      attachImage(thwomp[1]);
      k++;
      if (k < 25) {
        setPosition(randomX, randomY);
      }
      if (k == 25) {
        setPosition(setX, setY);
      }
      if (k >25) {
        setStatic(false);
        setVelocity(0, 500);
      }
    }

    if (getY() > 1519) {
      triggered = false;
    }
  }

  void collide() {
    if (isTouching("player")) {
      playerlives--;
      player.setPosition(0, 0);
    }
  }
}
