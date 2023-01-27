class FBridge extends FGameObject {

  FBridge(int x, int y) {
    super();
    setPosition(x, y);
    setName("bridge");
    attachImage(bridge);
    setStatic(true);
  }

  void act () {
    if (isTouching("player")) {
      setStatic(false);
      //setSensor(true);
    }
  }
}
