class FLava extends FGameObject {
  int n;

  FLava(int x, int y) {
    super();
    setPosition(x, y);
    setName("bridge");
    setStatic(true);
    setStatic(true);
    setFriction(10);
    setName("lava");
    setSensor(true);
  }

  void act () {
    animate();
  }

  void animate() {
      n = (int) random(0, 5);
       if (frameCount % 10 == 0) {
      attachImage(lava[n]);
      n++;
      if (n == 5) n = 0;
    }
  }
}
