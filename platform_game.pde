import fisica.*;
FWorld world;

final int INTRO = 0;
final int GAME = 1;
final int GAMEOVER = 2;
final int VICTORY = 3;
int mode;
int playerlives;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//sound variables
Minim minim;
AudioPlayer song;

color white = #FFFFFF;
color black = #000000;
color green = #00FF00;
color red = #FF0000;
color cyan = #0aebf7; //for ice block
color treetrunk = #6b290d;
color treetop = #11f01c;
color gray = #c4c2c4;
color yellow =  #fff703;
color orange = #ffa600;
color pink = #FF03D1;
color hammergray = #B3B1B7;
color blue = #14FCF7;
color yellow2 = #fad419;
color gold = #ffc400;

PImage map, ice, brick, treeTrunk, treeIntersect, treeTopLeft, treeTopCenter, treeTopRight, spike, bridge;
int gridSize = 32;
boolean wkey, akey, skey, dkey, upkey, downkey, rightkey, leftkey, spacekey;
float zoom = 1;

//objects and lists of objects
ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;
FPlayer player;

//Images for main character animations
PImage[] idle;
PImage[] jump;
PImage[] run;
PImage[] action;

//images for other animations
PImage[] goomba;
PImage[] thwomp;
PImage[] hammerbro;
PImage[] lava;
PImage hammer;

boolean mouseReleased;
boolean wasPressed;

Button button, button2, button3;

void setup() {
  playerlives = 3;
  mode = INTRO;
  size(600, 600);
  Fisica.init(this);
  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();
  loadImages();
  loadWorld(map);
  loadPlayer();
  ice.resize(32, 32);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);

  //set up minim variables
  minim = new Minim(this);
  song = minim.loadFile("MUSIC.mp3");


  //load buttons
  button = new Button("PLAY", width/2, 3*height/4, 200, 100, green, white, 40);
  button2 = new Button("TRY AGAIN", width/2 + 150, 3*height/4, 200, 100, green, yellow, 35);
  button3 = new Button("MENU", width/2 - 150, 3*height/4, 200, 100, red, blue, 40);
}

void loadImages() {
  map = loadImage("map4.png");
  ice = loadImage("blueBlock.png");
  brick = loadImage("brick.png");
  treeTrunk = loadImage("tree_trunk.png");
  treeIntersect = loadImage("tree_intersect.png");
  treeTopLeft = loadImage("treetop_w.png");
  treeTopCenter = loadImage("treetop_center.png");
  treeTopRight = loadImage("treetop_e.png");
  spike = loadImage("spike.png");
  bridge = loadImage("bridge_center.png");

  //enemies
  goomba = new PImage[2];
  goomba[0] = loadImage("goomba0.png");
  goomba[0].resize(gridSize, gridSize);
  goomba[1] = loadImage("goomba1.png");
  goomba[1].resize(gridSize, gridSize);

  thwomp = new PImage[2];
  thwomp[0] = loadImage("thwomp0.png");
  thwomp[0].resize(gridSize*2, gridSize*2);
  thwomp[1] = loadImage("thwomp1.png");
  thwomp[1].resize(gridSize*2, gridSize*2);

  hammerbro = new PImage[2];
  hammerbro[0] = loadImage("hammerbro0.png");
  hammerbro[0].resize(gridSize, gridSize);
  hammerbro[1] = loadImage("hammerbro1.png");
  hammerbro[1].resize(gridSize, gridSize);
  //hammer = new PImage;
  hammer = loadImage("hammer.png");

  //load actions
  idle = new PImage[2];
  idle[0] = loadImage("idle0.png");
  idle[1] = loadImage("idle1.png");

  jump = new PImage[1];
  jump[0] = loadImage("jump0.png");

  run = new PImage[3];
  run[0] = loadImage("runright0.png");
  run[1] = loadImage("runright1.png");
  run[2] = loadImage("runright2.png");

  action = idle;

  //lava animation
  lava = new PImage[6];
  lava[0] = loadImage("lava0.png");
  lava[1] = loadImage("lava1.png");
  lava[2] = loadImage("lava2.png");
  lava[3] = loadImage("lava3.png");
  lava[4] = loadImage("lava4.png");
  lava[5] = loadImage("lava5.png");
}
void loadWorld(PImage img) {
  world =  new FWorld(-2000, -2000, 2000, 2000);
  world.setGravity( 0, 900);

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y); //color above current pixel
      color s  = img.get(x, y+1); //color below current pixel
      color w = img.get(x-1, y); //color west of current pixel
      color e = img.get(x+1, y); //color east of current pixel

      if (c == black) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(10);
        b.setName("brick");
        b.attachImage(brick);
        world.add(b);
      } else if ( c == pink) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(10);
        b.setName("wall");
        b.attachImage(brick);
        world.add(b);
      } else if (c == cyan) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(0);
        b.setName("ice");
        b.attachImage(ice);
        world.add(b);
      } else if (c == treetrunk) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(10);
        b.setName("treetrunk");
        b.attachImage(treeTrunk);
        b.setSensor(true);
        world.add(b);
      } else if (c == treetop && s == treetrunk) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(10);
        b.setName("treeintersect");
        b.attachImage(treeIntersect);
        world.add(b);
      } else if (c == treetop && w == white) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(10);
        b.setName("treetopleft");
        b.attachImage(treeTopLeft);
        world.add(b);
      } else if (c == treetop && w == treetop && e == treetop) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(10);
        b.setName("treetopcenter");
        b.attachImage(treeTopCenter);
        world.add(b);
      } else if (c == treetop && e != treetop) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(10);
        b.setName("treetopright");
        b.attachImage(treeTopRight);
        world.add(b);
      } else if (c == gray) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(10);
        b.setName("spikeblock");
        b.attachImage(spike);
        world.add(b);
      } else if (c == yellow) {
        FBridge br = new FBridge(x*gridSize, y*gridSize);
        terrain.add(br);
        world.add(br);
      } else if (c == orange) {
        FLava b = new FLava(x*gridSize, y*gridSize);
        terrain.add(b);
        world.add(b);
        //FBox b = new FBox(gridSize, gridSize);
        //b.setPosition(x*gridSize, y*gridSize);
        //b.setStatic(true);
        //b.setFriction(10);
        //b.setName("lava");
        //b.attachImage(lava[(int)random(0,5)]);
        //b.setSensor(true);
        //world.add(b);
      } else if (c == red) {
        FGoomba gmb = new FGoomba(x*gridSize, y*gridSize);
        enemies.add(gmb);
        world.add(gmb);
      } else if (c == hammergray) {
        FHammerbro b = new FHammerbro(x*gridSize, y*gridSize);
        enemies.add(b);
        world.add(b);
      } else if (c==yellow2) {
        FThwomp t = new FThwomp(x*gridSize, y*gridSize);
        enemies.add(t);
        world.add(t);
      } else if (c == gold) {
        FBox b = new FBox(gridSize, gridSize);
        b.setPosition(x*gridSize, y*gridSize);
        b.setStatic(true);
        b.setFriction(10);
        b.attachImage(brick);
        b.setName("victory");
        world.add(b);
      }
    }
  }
}

//else if (c== white) {
//       FBox b = new FBox(gridSize, gridSize);
//       b.setSensor(true);
//       fill(blue);
//       world.add(b);
//     }

void loadPlayer() {
  player = new FPlayer();
  world.add(player);
}

void draw() {
  click();
  if (mode == GAME) {
    game();
  } else if (mode == INTRO) {
    intro();
  } else if (mode == GAMEOVER) {
    gameover();
  }else if (mode == VICTORY) {
   victory(); 
    
  }
}

void game() {
  background(blue);
  fill(yellow);
  textSize(40);
  text("LIVES: " + playerlives, 80, 80);
  drawWorld();
  actWorld();
  
  
  ////quordinates
  //fill(red);
  //textSize(20);
  //if (mouseX < width - 150) {
  //  text(mouseX + ", " + mouseY, mouseX, mouseY - 20);
  //}

  if (playerlives <= 0) {
    mode = GAMEOVER;
  }
}

void drawWorld() {
  pushMatrix();
  translate(zoom*-player.getX()+width/2, zoom*-player.getY()+height/2);
  scale(zoom);
  world.step();
  world.draw();
  popMatrix();
}

void actWorld() {
  player.act();
  for (int i = 0; i < terrain.size(); i++) {
    FGameObject t = terrain.get(i);
    t.act();
  }

  for (int i = 0; i < enemies.size(); i++) {
    FGameObject e = enemies.get(i);
    e.act();
  }
}
