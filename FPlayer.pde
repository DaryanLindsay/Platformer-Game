class FPlayer extends FBox {

  int frame;
  int direction;
  int lives;
  final int L = -1;
  final int R = 1;


  FPlayer() {
    super(gridSize, gridSize);
    frame = 0;
    direction = R;
    lives = 3;
    setPosition(0, 0);
    setName("player");
    setFillColor(red);
    setRotatable(false);
  }

  void act() {
    handleInput();
    checkForCollisions();
    animate();
  }

  void animate() {
    if (frame >= action.length) frame = 0;
    if (frameCount % 5 == 0) {
      if (direction == R) attachImage(action[frame]);
      if (direction == L) attachImage(reverseImage(action[frame]));
      frame++;
    }
  }

  void handleInput() {
    float vy = getVelocityY();
    float vx = getVelocityX();
    if (abs(vy) < 0.1) {
      action = idle;
    }
    if (akey) {
      setVelocity(-200, vy);
      action = run;
      direction = L;
    }
    if (dkey) {
      setVelocity(200, vy);
      action = run;
      direction = R;
    }

    if (wkey) {
      setVelocity(vx, -300);
    }

    if (abs(vy) > 0.1) {
      action = jump;
    }
  }

  void checkForCollisions() {
    ArrayList<FContact> contacts = getContacts();
    for (int i = 0; i < contacts.size(); i++) {
      FContact fc = contacts.get(i);
      if (fc.contains("spikeblock")) {
        setPosition(0, 0);
        playerlives--;
      }
      if (fc.contains("lava")) {
        setPosition(0, 0);
        playerlives--;
      }
      if (fc.contains("hammer")) {
        setPosition(0, 0);
        playerlives--;
      }
      if (fc.contains("victory")) {
        mode = VICTORY;
      }
    }
  }
}
