class LineChart {
  String type;
  int _listSize;
  int grainSize = 40;

  LineChart(String _type){
    type = _type;
    if(type == "averages"){
      _listSize = listSize;
    } else {
      _listSize = 2;
    }
    
  }
  
  void display(){
      
    float relaxEnd = 0;
    float studyEnd = 0;
    float assessEnd = 0;
    
    
    fill(graphBgColor);
    rect(visX - padding, visY - padding, visWidth - dotSize/2 + padding*2, visHeight + dotSize/2 + padding*2);
    
    if(fileNames != null){
      for(int i = 0; i < _listSize; i++){
        if(fileNames[0].charAt(0) != '.'){
          textAlign(LEFT, CENTER);
          
          String[] fileDate = split(fileNames[0], '.');
          
          float thisX = i * visWidth/_listSize + visX;
          float previousX = (i-1) * visWidth/_listSize + visX;
          
          float attAvg = map(attentionAverageList[i], 100, 0, visY, visHeight + visY);
          float rlxAvg = map(relaxationAverageList[i], 100, 0, visY, visHeight + visY);
          float prevAttAvg = 0;
          float prevRlxAvg = 0;
          
          if(i>0){
            prevAttAvg = map(attentionAverageList[i-1], 100, 0, visY, visHeight + visY);
            prevRlxAvg = map(relaxationAverageList[i-1], 100, 0, visY, visHeight + visY);
          }
          
          if(mouseX >= thisX - dotSize/2 && mouseX <= thisX + dotSize/2){
            
            if(type == "averages"){
              if(mouseY >= visY && mouseY <= visY + visHeight + dotSize/2){
                if(mousePressed){
                  currentPage = "singleSession";
                  cp5.getTab("singleSession").bringToFront();
                  currentSession = fileArray[i];
                  currentItem = i;
                  println(currentSession);
                }
                
                fill(250);
                rect(thisX - dotSize/2, visY, dotSize, visHeight + dotSize/2);
              }
            }
            
            if(mouseY >= rlxAvg - dotSize/2 && mouseY <= rlxAvg + dotSize/2){
              fill(textDarkColor);
              //rect(thisX - dotSize/2, rlxAvg - dotSize/2, dotSize, dotSize); // boundin box
              text(round(relaxationAverageList[i])+"%", thisX + 10, rlxAvg - dotSize);
            }
            if(mouseY >= attAvg - dotSize/2 && mouseY <= attAvg + dotSize/2){
              fill(textDarkColor);
              //rect(thisX - dotSize/2, attAvg - dotSize/2, dotSize, dotSize); // bouning box
              text(round(attentionAverageList[i])+"%", thisX + 10, attAvg - dotSize);
            }
            noStroke();
          }
          
          if(type == "averages"){
            fill(attentionColor);
            ellipse(thisX, attAvg, dotSize, dotSize);
            
            fill(relaxationColor);
            ellipse(thisX, rlxAvg, dotSize, dotSize);
            
            fill(textDarkColor);
            textAlign(CENTER, CENTER);
            text(fileDate[2] + "." + fileDate[1], thisX, visHeight + visY + 40);
          } else {
            noFill();
            if(i>0 && data.data != null){
              for (int j = 0; j < data.data.length; j+=grainSize) {
                if (data.data[j][11] > 0 && j>0) {
                  ////////////////////////////////////////////////////////////
                  int maxVal = 100; //TODO: what's the maximum value for the EEG?
                  ////////////////////////////////////////////////////////////
  
                  thisX = j * (visWidth - padding*2)/data.data.length + visX + padding;
                  previousX = (j-grainSize) * (visWidth - padding*2)/data.data.length + visX + padding;
                  
                  if(data.data[j][11] == 1){
                    fill(250);
                    relaxEnd = thisX;
                  }
                  if(data.data[j][11] == 2){
                   fill(230);
                   studyEnd = thisX;
                  }
                  if(data.data[j][11] == 3){
                    fill(210);
                    assessEnd = thisX;
                  }
                  noStroke();
                  rect(previousX, visY, grainSize, visHeight);
  
                  stroke(attentionColor);
                  line(
                        previousX,
                        map(data.data[j-grainSize][9], maxVal, 0, visY, visHeight + visY),
                        thisX,
                        map(data.data[j][9], maxVal, 0, visY, visHeight + visY)
                  );
                  stroke(relaxationColor);
                  line(
                        previousX,
                        map(data.data[j-grainSize][10], maxVal, 0, visY, visHeight + visY),
                        thisX,
                        map(data.data[j][10], maxVal, 0, visY, visHeight + visY)
                  );
                }
              }
            }
            
            noStroke();
          }
        }
      }
      
      fill(textDarkColor);
      if(type == "averages"){
        textAlign(LEFT);
        text("Averaged values of EEG data", visX, visHeight + visY + 60);
      } else if(type == "values"){
        //rect((visX + padding) + (studyEnd - (visX + padding)), visY, assessEnd - studyEnd, 20);
    
        textAlign(CENTER, CENTER);
        text("RELAX", visX + padding, visY, relaxEnd - (visX + padding), 20);
        text("STUDY", (visX + padding) + (relaxEnd - (visX + padding)), visY, relaxEnd - visX + padding/2, 20);
        text("ASSESS", (visX + padding) + (studyEnd - (visX + padding)), visY, assessEnd - studyEnd, 20);
      }
    } else {
        textAlign(CENTER);
        text("It seems you have no data yet.\nGo ahead and start a new session to generate some.", visX, visHeight/2 + visY, visWidth, visHeight);
    }
    
    //Labels
    textAlign(LEFT, CENTER);
    text("100%", visX - padding/2, visY);
    text("50%", visX - padding/2, visY + visHeight/2 + dotSize/2);
    text("0%", visX - padding/2, visY + visHeight + dotSize/2);
    
    
  }
}