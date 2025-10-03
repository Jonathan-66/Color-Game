import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import gifAnimation.*;

Minim minim;
AudioPlayer Start, Gaming, Over, Success;

PFont ui, ui2;
Gif g;
Gif a;
int mode = 1;

int randomWord = (int) random(0,6);
int randomColor = (int) random(0,6);
boolean isMatching;
int score = 0;
int bestScore = 0;

color red = #FC0000;
color green = #00FC4D;
color yellow = #EBFC00;
color blue = #00C8FC;
color orange = #FC7A00;
color purple = #EF00FC;
String[] words = {"Red","Green","Yellow","Blue","Orange","Purple"};
color[] colors = {red,green,yellow,blue,orange,purple};

float wordX;
float wordY;
float wordSpeed = 10;
float startX = -220;

void setup(){
  size(600,800);
  ui = createFont("Asimovian-Regular.ttf", 80, true);
  ui2 = createFont("Asimovian-Regular.ttf", 22, true);
  g = new Gif(this, "14e9c1fa08891b41f23b7cdd02904c0e.gif");
  g.loop();
  a = new Gif(this, "65313084ff0fb3453089947e_giphy.gif");
  a.loop();
  minim = new Minim(this);
  Start = minim.loadFile("start.mp3");
  Gaming = minim.loadFile("game.mp3");
  Over = minim.loadFile("over.wav");
  Success = minim.loadFile("SUCCESS.wav");
  setMode(1);
}

void draw() {
  if(mode == 1){
    StartPage();
  } 
  else if (mode == 2){
    Game();
  } 
  else {
    GameOver();
  }
}

void StartPage(){
  image(g, 0, 0, width, height); 
  fill(255);
  textFont(ui);
  textAlign(CENTER, CENTER);
  text("Color Game", 300, 100);
  textFont(ui2);
  text("Best: " + bestScore, 300, 160);
  if (mouseX > 400 && mouseX < 500 && mouseY > 625 && mouseY < 675) stroke(255); else stroke(0);
  fill(0);
  strokeWeight(5);
  rect(400, 625, 100, 50);
  fill(255);
  textFont(ui2);
  textAlign(CENTER, CENTER);
  text("Start", 450, 650);
}

void Game(){
  noStroke();
  fill(0);
  rect(0,0,600,400);
  fill(255);
  rect(0,400,600,400);
  fill(255);
  textFont(ui);
  textAlign(CENTER, CENTER);
  text("Right?", 300, 200);
  fill(0);
  textFont(ui);
  textAlign(CENTER, CENTER);
  text("Wrong!", 300, 600);
  textFont(ui);
  textAlign(LEFT, CENTER);
  fill(colors[randomColor]);
  text(words[randomWord], wordX, wordY);
  wordX += wordSpeed;
  if (wordX > width) {
    setMode(3);
  }
}

void GameOver(){
  image(a, 0, 0, width, height);
  fill(255);
  textAlign(CENTER, CENTER);
  textFont(ui);
  text("Game Over", width/2, height/2 - 40);
  textFont(ui2);
  text("Score: " + score, width/2, height/2 + 20);
  text("Best: " + bestScore, width/2, height/2 + 40);
}

void mousePressed(){
  if (mode == 1 && mouseX > 400 && mouseX < 500 && mouseY > 625 && mouseY < 675) {
    score = 0;
    setMode(2);
    Puzzle();
    wordX = startX;
    wordY = height/2;
  } else if (mode == 2) {
    boolean player = mouseY < 400;
    if (player == isMatching) {
      Success.play();
      Success.rewind();
      score++;
      Puzzle();
      wordX = startX;
      wordY = height/2;
    } else {
      setMode(3);
    }
  } else if (mode == 3) {
    setMode(1);
  }
}

void Puzzle(){
  isMatching = random(1) < 0.5;
  randomWord = (int) random(0, 6);
  if (isMatching) {
    randomColor = randomWord;
  } else {
    int idx = (int) random(0, 5);
    if (idx >= randomWord) idx++;
    randomColor = idx;
  }
}

void setMode(int m){
  mode = m;
  if (mode == 1){
    Start.rewind();
    Start.loop();
  } else if (mode == 2){
    Start.pause();
    Gaming.rewind();
    Gaming.loop();
  } else if (mode == 3){
    if (score > bestScore) bestScore = score;
    Gaming.pause();
    Over.rewind();
    Over.play();
  }
}
