import processing.video.*;
boolean printIJ = true;
color black = color(0);
color white = color(255);
int rez = 3;
Capture video;
int threshhold = 6;
int field[][];
int arrszI,arrszJ;
int space = 2;
boolean showPoints = true;
int bg = 150;
boolean showCamfeed = false;

void setup() {
  size(2*640, 2*480);
  //size(640,480);
  if(Capture.list().length > 1)video = new Capture(this, 640, 480,Capture.list()[1]);
  else video = new Capture(this, 640, 480);
  video.start();
  background(0);
  arrszI = width/(2*rez);
  arrszJ = height/(2*rez);
  field = new int[1+video.height/rez][1+video.width/rez];
  rectMode(CENTER);
}

void keyPressed(){
  if(key == 'p'){
    showPoints = !showPoints;
    if(bg==0)bg=100;
    else bg=0;
  }
  if(key == 'c'){
    showCamfeed = !showCamfeed;
  }
}

void draw() {
  if(!showCamfeed)background(bg);
  if (video.available()) {
      video.read();
      video.loadPixels();
      int fi = 0;
      for(int i=0; i<(video.width); i+=rez){
        int fj = 0;
        for(int j=0; j<(video.height); j+=rez){
          int loc1 = i+j*video.width;
          int loc2 = (i+1)+j*video.width;
          int brightness = int(brightness(video.pixels[loc1])) - int(brightness(video.pixels[loc2]));
          if(abs(brightness) > threshhold)field[fj][fi] = 1;
          else field[fj][fi] = 0;
          if(showCamfeed){
            noStroke();
            float r=red(color(video.pixels[loc1]));
            float g=green(video.pixels[loc1]);          
            float b=blue(video.pixels[loc1]);
            fill(r,g,b);
            rect(i*space,j*space,rez*space,rez*space);
          }
          fj+=1;
        }
        fi+=1;
      }
    }
  
  for(int y=0; y<video.height/rez ; ++y){
    for(int x=0; x<video.width/rez ; ++x){
      noStroke();
      int posx = x*rez*space;
      int posy = y*rez*space;
      if(showPoints){
        if(field[y][x] == 1)fill(255);
        else fill(0);
        rect(posx+rez/2,posy+rez/2,rez,rez);
      }
      
      PVector a = new PVector(posx+(1.5*rez), posy+(rez/2));
      PVector b = new PVector(posx+(2*rez)+(rez/2), posy+(rez/2)+rez);
      PVector c = new PVector(posx+(1.5*rez), (posy+(rez/2)+rez) + rez);
      PVector d = new PVector(posx+(rez/2), posy+(1.5*rez));
      
      
      int state = getState(field[y][x],field[y][x+1],field[y+1][x+1],field[y+1][x]);
      
      if(showCamfeed)stroke(255,0,0);
      else stroke(255);
      strokeWeight(1.5);
      switch(state){
        case 1:
          line(c,d);
          break;
        case 2:
          line(b,c);
          break;
        case 3:
          line(b,d);
          break;
        case 4:
          line(a,b);
          break;
        case 5:
          line(a,d);
          line(b,c);
          break;
        case 6:
          line(a,c);
          break;
        case 7:
          line(a,d);
          break;
        case 8:
          line(a,d);
          break;
        case 9:
          line(a,c);
          break;
        case 10:
          line(a,b);
          line(c,d);
          break;
        case 11:
          line(a,b);
          break;
        case 12:
          line(b,d);
          break;
        case 13:
          line(b,c);
          break;
        case 14:
          line(c,d);
          break;
      }
    }
  }
}


void line(PVector v1, PVector v2){
  line(v1.x,v1.y,v2.x,v2.y);
}

int getState(int a, int b, int c, int d){
  return a*8 + b*4 + c*2 + d*1;
}
