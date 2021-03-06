int[] boxStates = {0, 1, 2, 3};
boolean timerOn = false;

String filename;
PrintWriter output;
int datetimestr0;
int datetimestr =  0;

int attention = 0;
int meditation = 0;

long delta1 = 0;
long theta1 = 0;
long low_alpha1 = 0;
long high_alpha1 = 0;
long low_beta1 = 0;
long high_beta1 = 0;
long low_gamma1 = 0;
long mid_gamma1 = 0;

int blinkSt = 0;
int timeline = 0;

int triggerCounter = 0;
int triggerLow = 20;
int triggerMedium = 50;
int triggerHigh = 80;

PImage learningGoal;
PImage learningGoal2;

void newSession() {
  //tryGetFeelerSConnection();
  if (boxState == 200) {
    screenshotThresholds();
  }

  if (debug || simulateMindSet || simulateBoxes) {
    if (boxState >= 100) {
      stroke(200);
      line(0, height/4, width, height/4);
      stroke(230);
      line(0, height/4 + height/8, width, height/4 + height/8);
      stroke(200);
      line(0, height/2, width, height/2);
      stroke(230);
      line(0, height/2 + height/4 - height/8, width, height/2 + height/4 - height/8);
      stroke(200);
      line(0, height/2 + height/4, width, height/2 + height/4);

      pushStyle();
      if (attention > triggerLow) {
        if (attention < 75) {
          fill(100, 200, 200);
        } else {
          fill(200, 100, 100);
        }
      } else {
        fill(100, 100, 200);
      }

      ellipse(width/2, map(attention, 0, 100, height/2 + height/4, height/4), 20, 20);

      if (meditation > triggerLow) {
        if (meditation < 75) {
          fill(100, 200, 200);
        } else {
          fill(200, 100, 100);
        }
      } else {
        fill(100, 100, 200);
      }
      ellipse(width/2 + 40, map(meditation, 0, 100, height/2 + height/4, height/4), 20, 20);
      popStyle();
    }
  }

  //display status of boxes
  if (feelerS.checkConnection() || simulateBoxes) {
    text("Boxes", width/2 + padding*14, padding*2);
    PImage learningGoal = loadImage("checked_small.png");
    image(learningGoal, width/2 + padding*12, padding, 30, 30);// Boxes connected
  } else {
    text("Boxes", width/2 + padding*14, padding*2);
    PImage learningGoal2 = loadImage("tocheck_big.png");
    image(learningGoal2, width/2 + padding*12, padding, 30, 30);// Boxes disconnected
  }

  //display status of MindWave
  if (mindSetOK || simulateMindSet) {//mindSetOK
    text("EEG headset", width/2 + padding*7.5, padding*2);
    PImage learningGoal = loadImage("checked_small.png");
    image(learningGoal, width/2 + padding*5.5, padding, 30, 30);// EEG headset connected
  } else {
    text("EEG headset", width/2 + padding*7.5, padding*2);
    PImage learningGoal2 = loadImage("tocheck_big.png");
    image(learningGoal2, width/2 + padding*5.5, padding, 30, 30);//EEG headset disconnected
  }

  if (frameCount % 200 == 0) {
    println("attention: " + attention);
    if (attention == 0 && meditation == 0) {
      //mindSet.quit();
      mindSetOK = false;
      cp5.getController("startSession").hide();
    }
  }

  switch(boxState) {
  case 0:
    pageH1("New session");
    textSize(20); //added by Eva
    //fill(100);//added by Eva
    if (!mindSetPortOk && !simulateMindSet) {
      PImage one = loadImage("one.png");// Added by Eva
      image(one, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
      text("Connect the EEG headset", padding + 80 + 80, headerHeight + padding + 75 + 30);

      if (!mindSetPortOk) {
        try {
          //mindSetPort = new Serial(this, Serial.list()[2]);
          mindSet = new MindSet(this, "/dev/cu.MindWaveMobile-DevA");
          println("port ok");
          mindSetPortOk = true;
          //mindSetOK = true;
        }
        catch (Exception e) {
          println("port not ok");
          mindSetPortOk = false;
        }
      }
      cp5.getController("startSession").hide();
    } else if ( !(mindSetOK && attention > 0 && meditation > 0) && !simulateMindSet) {
      PImage one = loadImage("one.png");// Added by Eva
      image(one, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
      text("Connect the EEG headset", padding + 80 + 80, headerHeight + padding + 75 + 30);
      pushStyle();
      fill(textLightColor);
      text("Connection established and waiting for data", padding + 80 + 80, headerHeight + padding + 75 + 30 + 80);
      textSize(16);
      //text("(I am connected, but make sure the headset is well placed!)", padding + 80 + 80 + 80 + 20, headerHeight + padding + 75 +30 + 80 + 20);
      popStyle();
      cp5.getController("startSession").hide();
    } else if (!feelerS.checkConnection() && !simulateBoxes) {
      PImage one = loadImage("one.png");// Added by Eva
      image(one, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
      text("Connect the EEG headset", padding + 80 + 80, headerHeight + padding + 75 + 30);
      //PImage learningGoal = loadImage("checked_big.png");
      //image(learningGoal, padding + 340 +80, headerHeight + padding + 50 + 30, 35, 35);
      PImage two = loadImage("two.png");// Added by Eva
      image(two, padding + 80, headerHeight + padding*2 + 100 + 30, 60, 60);// Added by Eva
      text("Connect the boxes", padding + 80 + 80, headerHeight + padding + 155 + 30);
      //image(learningGoal, padding + 280 + 80, headerHeight + padding*2 + 110 + 30, 35, 35);
      //PImage three = loadImage("three.png");// Added by Eva
      //image(three, padding + 80, headerHeight + padding*2 + 180 + 30, 60, 60);// Added by Eva
    } else {
      PImage one = loadImage("one.png");// Added by Eva
      //image(one, padding + 80, headerHeight + padding + 70, 60, 60);// Added by Eva
      image(one, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
      text("Connect the EEG headset", padding + 80 + 80, headerHeight + padding + 75 + 30);
      //PImage learningGoal = loadImage("checked_big.png");
      //image(learningGoal, padding + 340 + 80, headerHeight + padding + 50 + 30, 35, 35);
      PImage two = loadImage("two.png");// Added by Eva
      image(two, padding + 80, headerHeight + padding*2 + 100 + 30, 60, 60);// Added by Eva
      text("Connect the boxes", padding + 80 + 80, headerHeight + padding + 155 + 30);
      //image(learningGoal, padding + 280 + 80, headerHeight + padding*2 + 110 + 30, 35, 35);
      PImage three = loadImage("three.png");// Added by Eva
      image(three, padding + 80, headerHeight + padding*2 + 180 + 30, 60, 60);// Added by Eva

      cp5.getController("startSession").show();
    }
    break;
  case 100:
    feelerS.setBoxState(1);//added by Eva 2016.09.14
    feelerS.setBox2LedState(0);//added by Eva 2016.09.14
    feelerS.sendValues();//added by Eva 2016.09.14
    cp5.getController("startSession").hide();
    pageH1("New session");
    PImage one = loadImage("one.png");// Added by Eva
    image(one, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
    textSize(24); //added by Eva
    text("Meditate", padding + 80 + 80, headerHeight + padding + 60 + 30);
    recording = true;
    timerOn = true;
    timeline = 1;
    fill(textDarkColor);
    textSize(16); //added by Eva
    text("Sync your breathing with the box lighting", padding + 80 + 80, headerHeight + padding + 90 + 30);
    PImage meditatebox = loadImage("meditate_box.png");// Added by Eva
    image(meditatebox, padding + 80 + 80, headerHeight + padding + 120 + 30, 270, 386);// Added by Eva
    counterDisplay();

    feelerS.setBoxState(1);
    feelerS.setBox2LedState(0);

    if (sw.minute() == 0 && sw.second() == 0) {
      println("End meditation");
      feelerS.setBoxState(3);
      sw.stop();
      boxState = 200;
      timerOn = false;
    }
    break;
  case 200:
    pageH1("New session");
    PImage two = loadImage("two.png");// Added by Eva
    image(two, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
    textSize(24); //added by Eva
    text("Study", padding + 80 + 80, headerHeight + padding + 60 + 30);
    fill(textDarkColor);
    textSize(16); //added by Eva
    text("Focus on your work. Let the time fly", padding + 80 + 80, headerHeight + padding + 90 + 30);
    PImage studybox = loadImage("study_box.png");// Added by Eva
    image(studybox, padding + 80 + 80, headerHeight + padding + 120 + 30, 270, 386);// Added by Eva
    timeline = 2;
    counterDisplay();

    feelerS.setBoxState(3);

    if (feelerS.getBoxesConnected() == 1 || simulateBoxes) {
      int ledState = int(map(sw.getElapsedTime(), sw.countDownStart, 0, 1, 20));
      //println("getElapsedTime: " + sw.getElapsedTime() + ", sw.countDownStart: " + sw.countDownStart);
      println("ledState: " + ledState);
      // increase this from 0 to 20
      feelerS.setBox2LedState(ledState);

      if (!timerOn) {
        sw.start(countDownStartStudy);
        timerOn = true;
        //} else if(sw.minute() == 0 && sw.second() == 0){
      } else if (sw.getElapsedTime() <= 50) {
        println("End study");
        cancelScreenshots();
        sw.stop();
        timerOn = false;
        boxState = 300;
      }
    }

    break;
  case 300:
    if (!recording) recording = true;
    pageH1("New session");
    PImage three = loadImage("three.png");// Added by Eva
    image(three, padding + 80, headerHeight + padding + 40 + 30, 60, 60);// Added by Eva
    textSize(24); //added by Eva
    text("Play", padding + 80 + 80, headerHeight + padding + 60 + 30);
    fill(textDarkColor);
    textSize(16); //added by Eva
    text("Repeat the light sequence as long as you can", padding + 80 + 80, headerHeight + padding + 90 + 30);
    PImage playbox = loadImage("play_box.png");// Added by Eva
    image(playbox, padding + 80 + 80, headerHeight + padding + 120 + 30, 270, 386);// Added by Eva
    timeline = 3;
    counterDisplay();

    feelerS.setBoxState(4);
    feelerS.setBox2LedState(0);

    if (!timerOn) {
      cu.start();
      timerOn = true;
      cp5.getController("endGame").show();
      //} else if(cu.getElapsedTime() >= 50){
      //  println(cu.getElapsedTime());
      //  boxState = 350;
      //  cu.stop();
      //  timerOn = false;
    }
    break;
  case 400:
    logger.pause("end of log");
    recording = false;
    timeline = 4;
    pageH1("Personal experience");
    if (assessQuestion == 1) {
      textSize(20);// added by Eva
      assess(assessQuestion, "/3 Select how you felt during:");
      feelingRadioMeditation.draw();
      feelingRadioStudy.draw();
      feelingRadioPlay.draw();
    } else if (assessQuestion == 2) {
      feelingRadioMeditation.clear();
      feelingRadioStudy.clear();
      feelingRadioPlay.clear();
      textSize(20);// added by Eva
      assess(assessQuestion, "/3 Select how your level of relaxation during:");
      text("Meditation", padding + 80, 250 + 10); //added by Evad
      text("Study", padding + 80, 250 + 50 + padding*3 + 10); //added by Eva
      text("Play", padding + 80, 250 + 50*2 + padding*6.2 + 10); //added by Eva
    } else if (assessQuestion == 3) {
      textSize(20);// added by Eva
      assess(assessQuestion, "/3 Select how your level of attention during:");
      text("Meditation", padding + 80, 250 + 10); //added by Evad
      text("Study", padding + 80, 250 + 50 + padding*3 + 10); //added by Eva
      text("Play", padding + 80, 250 + 50*2 + padding*6.2 + 10); //added by Eva
      hasFinished = false;
    } else if (assessQuestion == 4) {
      textSize(20);// added by Eva
      textAlign(LEFT);
      assess(assessQuestion, "Answers saved!\nYour data is being loaded");
       pageH6("You can remove the EEG helmet");
      if (!timerOn) {
        timerOn = true;
        //cp5.getController("stopBt").hide();
        //cp5.getController("playPauseBt").hide();
      } else if (cu.getElapsedTime() >= 3000) {
        println("geral!!! " + cu.getElapsedTime());
        cu.stop();
        timerOn = false;
        currentPage = "overall";
        cp5.getController("overall").hide();
        cp5.getController("newSession").show();
        cp5.getController("overallTopRight").hide();
        println("loadFiles");
        loadFiles();
      }
      //println(sw.getElapsedTime());
    }
    break;
  default:
    pageH1("Start a session");
    break;
  }

  if (recording) {
    int datetimestr1 = millis() / 1000;
    datetimestr = datetimestr1 - datetimestr0;

    output.print(datetimestr);
    output.print(TAB);
    output.print(delta1);
    output.print(TAB);
    output.print(theta1);
    output.print(TAB);
    output.print(low_alpha1);
    output.print(TAB);
    output.print(high_alpha1);
    output.print(TAB);
    output.print(low_beta1);
    output.print(TAB);
    output.print(high_beta1);
    output.print(TAB);
    output.print(low_gamma1);
    output.print(TAB);
    output.print(mid_gamma1);
    output.print(TAB);
    output.print(blinkSt);
    output.print(TAB);
    output.print(attention);
    output.print(TAB);
    output.print(meditation);
    output.print(TAB);
    output.println(timeline);
  }
}

void assess(int questionNo, String question) {
  text(question, padding + 15 + 80, headerHeight + padding + 60 + 30);//added by Eva
  //text(question, padding*2, headerHeight + padding*2);

  if (questionNo != 4) {
    text(questionNo, padding + 80, headerHeight + padding + 60 + 30);//added by Eva
    //text(questionNo, padding, headerHeight + padding*2);
  } else {
    hasFinished = true;
    //currentPage = "eegActivity";
    //if(hasFinished == false){
    //  hasFinished = true;
    //  t.schedule(new TimerTask() {
    //    public void run() {
    //      println("trigger");
    //      hasFinished = true;
    //      print(" " + nf(3, 0, 2));
    //      currentPage = "eegActivity";
    //    }
    //  }, (long) (3*1e3));
    //}
  }
}


void counterDisplay() {
  pushStyle();
  textSize(100);
  textAlign(CENTER);
  //textAlign(10,10);


  String second;
  String minute;

  if ( boxState != 300) {
    second = new DecimalFormat("00").format(sw.second());
    minute = new DecimalFormat("00").format(sw.minute());
  } else {
    second = new DecimalFormat("00").format(cu.second());
    minute = new DecimalFormat("00").format(cu.minute());
  }

  if (boxState > 0) {
    text(minute + ":" + second, width/2, containerPosY + padding);
  }
  popStyle();
}

void screenshotThresholds() {
  if (recording) {
    if (attention < triggerLow || meditation < triggerLow) {
      if (hasFinished) {
        triggerScreenshots(60); //comment this line if you want to try without the screenshots
      }
      //if ((frameCount & 0xF) == 0)   print('.');
    } else if (attention > triggerHigh || meditation > triggerHigh) {
      triggerScreenshots(60); //comment this line if you want to try without the screenshots
    } else {
      cancelScreenshots(); //comment this line (plus the ones noted above) if you want to try without the screenshots
    }
  }
}


/**
 * TimerTask (v1.3)
 * by GoToLoop (2013/Dec)
 *
 * forum.processing.org/two/discussion/1725/millis-and-timer
 */
final Timer t = new Timer();
boolean hasFinished = true;

void triggerScreenshots(final float sec) {
  hasFinished = false;

  t.schedule(new TimerTask() {
    public void run() {
      //print(" " + nf(sec, 0, 2));
      hasFinished = true;

      //feelerS.sendValues();
      //feelerS.get();
      println(", getBoxesConnected: " + feelerS.getBoxesConnected());
      //println(feelerS.checkConnection());
    }
  }
  , (long) (sec*1e3));


  //feelerS.sendValues();
  //feelerS.get();
  //println(", getBoxesConnected: " + feelerS.getBoxesConnected());

  println("\n\nScreenshot scheduled for " + nf(10, 0, 2) + " secs.\n");

  //feelerS.sendValues();
  //feelerS.get();
  //println(feelerS.checkConnection());

  screenshot();
  PImage newImage = createImage(100, 100, RGB);
  newImage = screenshot.get();
  //instead of datetimestr we may want to use logger's int(time.get()/1000)
  newImage.save(
    sessionPath + "/screenshots/" +
    datetimestr+"-"+String.valueOf(year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + "-" + String.valueOf(hour()) + "-" + String.valueOf(minute()) + "-" + String.valueOf(second()) +
    "-screenshot.png"
    );
}
///////////////////////////////
void cancelScreenshots() {
  hasFinished = true;
}

//MindSet functions

float attoff = 0.01;
float medoff = 0.0;

void simulate() {
  if (recording) {
    poorSignalEvent(int(random(200)));

    //simulate with noise
    attoff = attoff + .02;
    medoff = medoff + .01;
    //comment the following two lines to simulate with mouse
    attentionEvent(int(noise(attoff) * 100));
    meditationEvent(int(noise(medoff) * 100));

    //simulate with mouse
    //uncomment the following two lines to simulate with mouse
    //attentionEvent(int(map(mouseX, 0, width, 0, 100)));
    //meditationEvent(int(map(mouseY, 0, height, 0, 100)));

    eegEvent(int(random(20000)), int(random(20000)), int(random(20000)), 
      int(random(20000)), int(random(20000)), int(random(20000)), 
      int(random(20000)), int(random(20000)) );
  }
}

public void poorSignalEvent(int sig) {
  //logger._poorSignalEvent(sig, longTimer.get());
  //signalWidget.add(200-sig);
  //println("poorSignal: " + sig);

  if (sig == 200) {
    mindSetOK = false;
  } else {
    mindSetOK = true;
  }
}

//void serialEvent(Serial p) {
//inString = p.readString();
//thisSerialValue = p.read();

//thisFrame = frameCount;

//println(p.read());
//println(p.available());
//println(p.last());
//if(p.read() == -1){
//  println("morreu");
//}

//mindSetOK = true;
//}

public void attentionEvent(int attentionLevel) {
  logger._attentionEvent(attentionLevel, longTimer.get());
  //attentionWidget.add(attentionLevel);
  //println("attentionLevel: " + attentionLevel);
  attention = attentionLevel;
}

public void meditationEvent(int meditationLevel) {
  logger._meditationEvent(meditationLevel, longTimer.get());
  //meditationWidget.add(meditationLevel);
  //println("meditationLevel: " + meditationLevel);
  meditation = meditationLevel;
}

public void blinkEvent(int strength) {
  logger._meditationEvent(strength, longTimer.get());
  println("blinkEvent: " + strength);
}

public void rawEvent(int[] values) {
  logger._rawEvent(values, longTimer.get());
  //println("rawEvent: " + values);
}

public void eegEvent(int delta, int theta, int low_alpha, 
  int high_alpha, int low_beta, int high_beta, int low_gamma, int mid_gamma) {
  logger._eegEvent(delta, theta, low_alpha, high_alpha, low_beta, high_beta, low_gamma, mid_gamma, longTimer.get());
  delta1 = delta;
  theta1 = theta;
  low_alpha1 = low_alpha;
  high_alpha1 = high_alpha;
  low_beta1 = low_beta;
  high_beta1 = high_beta;
  low_gamma1 = low_gamma;
  mid_gamma1 = mid_gamma;
  //println("delta1: " + delta1);
}