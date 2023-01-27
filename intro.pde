void intro() {
  background(pink);
  fill(blue);
  textSize(50);
  text("SUPER MARIO!", width/2, height/3);
  
  button.show();
  
  if(button.clicked) {
    song.rewind();
    playerlives = 3;
    song.play();
    mode = GAME;
  }
  
}
