void victory() {
 fill(gold);
 textSize(50);
 text("VICTORY!", width/2, height/4);
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
    song.rewind();
    playerlives = 3;
    mode = INTRO;
    loadWorld(map);
    loadPlayer();
  }
  
}
