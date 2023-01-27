void gameover() {
  song.rewind();

  background(black);
  textSize(100);
  fill(red);
  text("GAME OVER", width/2, height/3);

  button2.show();
  button3.show();

  if (button2.clicked) {
    playerlives = 3;
    mode = GAME;
    song.rewind();
    song.play();
    loadWorld(map);
    loadPlayer();
  }

  if (button3.clicked) {
    playerlives = 3;
    mode = INTRO;
    loadWorld(map);
    loadPlayer();
  }
}
