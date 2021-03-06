class FeelingRadio {
  int _x, _y, imgY;
  int imgSz = 120;
  //int imgSz = 48;
  String _label;
  String[] feelings = {"good", "neutral", "bad"};
  String checked = "";

  PImage good = loadImage("assess-good.png");
  PImage goodChecked = loadImage("assess-good-checked.png");

  PImage neutral = loadImage("assess-neutral.png");
  PImage neutralChecked = loadImage("assess-neutral-checked.png");

  PImage bad = loadImage("assess-bad.png");
  PImage badChecked = loadImage("assess-bad-checked.png");

  PImage goodImg;
  PImage neutralImg;
  PImage badImg;

  Boolean active=false;

  FeelingRadio (int x, int y, String label) {  
    _x = x;
    _y = y; 
    imgY = y + padding/2;
    _label = label;
  }

  void draw() {
    active=true;
    pushStyle();
    textAlign(LEFT);
    text(_label, _x, _y);
    popStyle();

    if (this.over(_x, imgY, imgSz, imgSz) || this.checked == "good") {
      goodImg = goodChecked;
    } else {
      goodImg = good;
    }
    image(goodImg, _x, imgY);


    if (this.over(_x + imgSz, imgY, imgSz, imgSz) || this.checked == "neutral") {
      neutralImg = neutralChecked;
    } else {
      neutralImg = neutral;
    }
    image(neutralImg, _x + imgSz, imgY);

    if (this.over(_x + imgSz*2, imgY, imgSz, imgSz) || this.checked == "bad") {
      badImg = badChecked;
    } else {
      badImg = bad;
    }
    image(badImg, _x + imgSz*2, imgY);
  }
  void clear() {
    if (active) {
      active=false;
      this.checked="";
    }
  }

  void click() {
    if (active) {
      println("."+feelingAssessMeditation+"."+feelingAssessStudy+"."+feelingAssessPlay);
      if (this.over(_x, imgY, imgSz, imgSz)) {
        this.checked = feelings[0];
      } else if (this.over(_x + imgSz, imgY, imgSz, imgSz)) {
        this.checked = feelings[1];
      } else if (this.over(_x + imgSz*2, imgY, imgSz, imgSz)) {
        this.checked = feelings[2];
      }

      if (_label.equals("Meditation")) {
        //case 'M':
        feelingAssessMeditation = this.checked;
        //break;
      } else if (_label.equals("Study")) {
        //case 'S':
        feelingAssessStudy = this.checked;
        //break;
      } else if (_label.equals("Play")) {
        //case 'P':
        feelingAssessPlay = this.checked;
        //break;
        //default:
        //break;
      }
    }
  }

  boolean over(int x, int y, int width, int height) {
    if (active) {
      if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
} 