# feeler

## installation

- Install MindsetProcessing (http://jorgecardoso.eu/processing/MindSetProcessing/) inside Processing3/libraries

Without PHP backend
- Change the first in feelerApp.pde line to ```boolean debug = true;```
- The application now runs in 'debug' mode, so you can login by clicking 'L' on the keyboard

With PHP backend
- Install MAMP [https://www.mamp.info/en/] and run it
- Install this [https://github.com/Repox/SimpleUsers] and create a user
  - Edit the configuration file, located at simpleusers/config.inc.php, then run the install script which is located at simpleusers/install.php As an alternative to the install script, edit the configuration file. The tables can be created manually, by opening tables.sql and pasting the tables into phpMyAdmin.
- Change feelerApp/data/config.json to reflect your environment
- Run feelerApp.pde and try to log in

## running
- set simulateMindSet to true to test without MindWave
- uncomment `size(displayWidth, displayHeight);` to allow screen size detection

## todo/issues
- [x] Fix scroll
- [ ] Add timer for session
- [ ] On mouse over 'overall' balls show session time and specify relaxation/attention
- [ ] Add breadcrumb menu for visualizations (with navigation)
- [ ] Add day of the week for sessions? (instead of "Session")
- [ ] Click thumbnail to see larger screenshot
- [ ] Include assessment and screenshot in exports?
- [ ] Turn localhost on/off (when off, connect to the Internet)
- [ ] Add timer, stop/pause/play button to Session
- [ ] Add connection feedback information
- [x] Save separate file for assessment
- [x] Identifying users
  - Added basic user management, but registration needs to be done on a web page (see below)
- [x] Registration through the app (not browser)
  - Added basic registration: to register just click signup instead of login after filling username and password fields
- [x] Change folder paths when saving files
- [x] Visualization of last activity data (and the different levels)
- [x] Visualization of the overall activity (this could be left for a second stage if it’s too much work)
- [x] Screen capture
- [x] Download raw data
- [x] Capture data screens (these need to be synchronized with the boxes and give some feedback (recording time, connection) indicating everything works ok.
- [x] In the app, the user should be able to delete a session.
- [ ] Implement visuals
