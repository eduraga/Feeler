import processing.net.*;
import controlP5.*;
import java.util.*;

ControlP5 cp5;

JSONObject json;

String encodedAuth = "";
Client client;
String loginData;

boolean isLoggedIn = false;
boolean isWrongPassword = false;
String currentUser = "";
String currentPassword = "";
Textfield username;
Textfield password;

final static int TIMER = 100;
static boolean isEnabled = true;

// files handling
FloatTable data;
String filenameString;
String[] fileArray;
File directory2;

float dataMin, dataMax;
int deltaMax, deltaMin, thetaMax, thetaMin, lowAlphaMax, lowAlphaMin, highAlphaMax, highAlphaMin, lowBetaMax, lowBetaMin, highBetaMax, highBetaMin, lowGammaMax, lowGammaMin, midGammaMax, midGammaMin, blinkStMax, blinkStMin, attentionMin, attentionMax, meditationMin, meditationMax; 
float plotX1, plotY1;
float plotX2, plotY2;
 
int rowCount, rowCount1, rowCount2,  rowCount3;
long state1start, state2start,state3start;
int columnCount;
int currentColumn = 0; 
char[] filenameCharArray = new char[20];
/////////////////////////

String host;
int port;
String address;

void setup() {
  size(700,400);
  noStroke();
  textSize(12);
  
  json = loadJSONObject("config.json");
  host = json.getString("host");
  port = json.getInt("port");
  address = json.getString("address");
  
  cp5 = new ControlP5(this);
  
  PImage[] imgs = {loadImage("feeler-logo.png"),loadImage("feeler-logo.png"),loadImage("feeler-logo.png")};
  cp5.addButton("homeBt")
     .setBroadcast(false)
     .setPosition(20, 20)
     .setSize(241,63)
     .setLabel("Feeler")
     .setImages(imgs)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("homeBt").moveTo("global");
     
  cp5.getTab("default")
     .activateEvent(true)
     .setLabel("home")
     .setId(1)
     ;
  
  cp5.addTab("login");
  cp5.getTab("login")
     .activateEvent(true)
     .setId(2)
     ;

  cp5.addTab("userHome");
  cp5.getTab("userHome")
     .activateEvent(true)
     .setId(3)
     ;

  cp5.addTab("newSession");
  cp5.getTab("newSession")
     .activateEvent(true)
     .setId(4)
     ;
  
  username = cp5.addTextfield("username")
     .setPosition(width/2 - 100, height/2 - 40)
     .setSize(200, 20)
     .setLabel("username")
     .setFocus(true)
     ;
  username.setAutoClear(true);
  cp5.getController("username").moveTo("login");
  
  password = cp5.addTextfield("password")
     .setPosition(width/2 - 100, height/2)
     .setSize(200, 20)
     .setPasswordMode(true)
     .setLabel("password")
     ;
  password.setAutoClear(true);
  cp5.getController("password").moveTo("login");
  
  cp5.addButton("submit")
     .setBroadcast(false)
     .setLabel("login")
     .setPosition(width/2 - 100, height/2 + 40)
     .setSize(200,40)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("submit").moveTo("login");
  
  cp5.addButton("loginBt")
     .setBroadcast(false)
     .setLabel("login")
     .setPosition(width - 100, 20)
     .setSize(80,40)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("loginBt").moveTo("default");
  
  cp5.addButton("logoutBt")
     .setBroadcast(false)
     .setLabel("Logout")
     .setPosition(width - 80, 10)
     .setSize(70,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("logoutBt").moveTo("global");
  cp5.getController("logoutBt").hide();
  
  
  cp5.addButton("newSession")
     .setBroadcast(false)
     .setLabel("start a session")
     .setPosition(width - 160, 10)
     .setSize(70,20)
     .setValue(1)
     .setBroadcast(true)
     .getCaptionLabel().align(CENTER,CENTER)
     ;
  cp5.getController("newSession").moveTo("userHome");
  
  // file handling
  File directory1 = new java.io.File(sketchPath(""));
  String temp = directory1.getAbsolutePath();
  temp += "/log";
  directory2 = new File(temp);
  fileArray = directory2.list();
  
  cp5.addScrollableList("loadFiles")
     .setPosition(20, 120)
     .setLabel("Load session")
     .setSize(200, 100)
     .setBarHeight(20)
     .setItemHeight(20)
     .addItems(fileArray)
     // .setType(ScrollableList.LIST)
     ;
  cp5.getController("loadFiles").moveTo("userHome");
  /////////////////////////////

}

void draw() {
  background(255);
  fill(0);
  
  if(isLoggedIn){
    textAlign(RIGHT);
    text("Hello, " + currentUser, width - 10, 50);
  }
  
  if(isWrongPassword){
    textAlign(CENTER);
    text("Wrong username or password", width/2, height/2 - 60);
  }
  
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    println("got an event from tab : "+theControlEvent.getTab().getName()+" with id "+theControlEvent.getTab().getId());
  }
  
  if(theControlEvent.getLabel() == "Logout"){
    cp5.getController("logoutBt").hide();
    isLoggedIn = false;
    cp5.getTab("default").bringToFront();
  }
  
  if (theControlEvent.isAssignableFrom(Textfield.class)) {
    Textfield t = (Textfield)theControlEvent.getController();
    
    if(t.getName() == "username"){
      currentUser = t.getStringValue();
    }
    if(t.getName() == "password"){
      currentPassword = t.getStringValue();
    }
    
    client = new Client(this, host, port);
    client.write("POST "+address+" HTTP/1.0\r\n");
    client.write("Accept: application/xml\r\n");
    client.write("Accept-Charset: utf-8;q=0.7,*;q=0.7\r\n");
    client.write("Content-Type: application/x-www-form-urlencoded\r\n");
    String contentLength = nf(23+currentUser.length()+currentPassword.length()); 
    client.write("Content-Length: "+contentLength+"\r\n\r\n");
    
    client.write("username="+currentUser+"&password="+currentPassword+"&\r\n");
    client.write("\r\n");

    println("controlEvent: accessing a string from controller '"
      +t.getName()+"': "+t.getStringValue()
    );
    
    print("controlEvent: trying to setText, ");

    t.setText("controlEvent: changing text.");
    if (t.isAutoClear()==false) {
      println(" success!");
    } 
    else {
      println(" but Textfield.isAutoClear() is false, could not setText here.");
    }
  }
}

public void loginBt(int theValue) {
  cp5.getTab("login").bringToFront();
}

public void newSession(int theValue) {
  cp5.getTab("newSession").bringToFront();
}


void submit(int theValue) {
  // use callback instead
  isEnabled = true;
  username.submit();
  password.submit();
  thread("timer"); // from forum.processing.org/two/discussion/110/trigger-an-event
}

void loginCheck(){
  if (client.available() > 0) {
    loginData = client.readString();
    String[] m = match(loginData, "<logintest>(.*?)</logintest>");
    if(m[1].equals("success")){
      println("success");
      cp5.getTab("userHome").bringToFront();
      isLoggedIn = true;
      isWrongPassword = false;
      cp5.getController("logoutBt").show();
  
Date d = new Date();
println(d.getTime());
      String lastLogin = String.valueOf(year()) + "-" + String.valueOf(month()) + "-" + String.valueOf(day()) + "-" + String.valueOf(hour()) + "-" + String.valueOf(minute()) + "-" + String.valueOf(second()) + ".txt";
      String[] userLoglist = split(lastLogin, ' ');
      saveStrings(currentUser + "/last-login.txt", userLoglist);
    } else {
      println("wrong password");
      isLoggedIn = false;
      isWrongPassword = true;
    }
  }
}

void timer() {
  while (isEnabled) {
    delay(TIMER);
    isEnabled = false;
    loginCheck();
  }
}




void loadFiles(int n) {
  /* request the selected item based on index n */
  println(n, cp5.get(ScrollableList.class, "loadFiles").getItem(n));
  
  /* here an item is stored as a Map  with the following key-value pairs:
   * name, the given name of the item
   * text, the given text of the item by default the same as name
   * value, the given value of the item, can be changed by using .getItem(n).put("value", "abc"); a value here is of type Object therefore can be anything
   * color, the given color of the item, how to change, see below
   * view, a customizable view, is of type CDrawable 
   */
  
  CColor c = new CColor();
  c.setBackground(color(0));
  cp5.get(ScrollableList.class, "loadFiles").getItem(n).put("color", c);  
  
  int i = fileArray.length;
  filenameString = fileArray[n];
  data = new FloatTable(directory2 + "/" + filenameString);

  //filenameString = "2015.07.14 11.34.55.tsv";      //comment out for loading the visualisation - copy filename here
  filenameCharArray = filenameString.toCharArray();

  rowCount = data.getRowCount(9);
  rowCount1 = data.getRowCount(1);
  rowCount2 = data.getRowCount(2);
  rowCount3 = data.getRowCount(3);
  columnCount = data.getColumnCount();
 
  state1start = data.getStateStart(1); // state1end = data.getStateEnd(1);
  state2start = data.getStateStart(2); // state2end = data.getStateEnd(2);
  state3start = data.getStateStart(3); // state3end = data.getStateEnd(3);

  deltaMax = (int)data.getColumnMax(0);      deltaMin = (int)data.getColumnMin(0); 
  thetaMax = (int)data.getColumnMax(1);      thetaMin = (int)data.getColumnMin(1);
  lowAlphaMax = (int)data.getColumnMax(2);   lowAlphaMin = (int)data.getColumnMin(2); 
  highAlphaMax = (int)data.getColumnMax(3);  highAlphaMin = (int)data.getColumnMin(3);
  lowBetaMax = (int)data.getColumnMax(4);    lowBetaMin = (int)data.getColumnMin(4); 
  highBetaMax = (int)data.getColumnMax(5);   highBetaMin = (int)data.getColumnMin(5);
  lowGammaMax = (int)data.getColumnMax(6);   lowGammaMin = (int)data.getColumnMin(6); 
  midGammaMax = (int)data.getColumnMax(7);   midGammaMin = (int)data.getColumnMin(7);
  blinkStMax = (int)data.getColumnMax(8);    blinkStMin = (int)data.getColumnMin(8);
  attentionMax = (int)data.getColumnMax(9);  attentionMin = (int)data.getColumnMin(9);
  meditationMax = (int)data.getColumnMax(10);  meditationMin = (int)data.getColumnMin(10);
  
  println("rowCount: " + rowCount);
  
}