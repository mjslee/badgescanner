import TUIO.*;
TuioProcessing tuioClient;

String filename = "logs/"+leadZero(day())+"-"+leadZero(hour())+"-"+leadZero(minute())+".csv";

PrintWriter logfile;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 200; //orig:60
float table_size = 760;
float scale_factor = 1;
PFont font;

PImage a;

void setup()
{
  logfile = createWriter(filename);
  logfile.flush();
  logfile.close();
  
  //PrintWriter output = createWriter("outputlog.csv");
  //size(screen.width,screen.height);
  size(640,480);
  noStroke();
  fill(0);
  
  loop();
  frameRate(30);
  //noLoop();
  
  hint(ENABLE_NATIVE_FONTS);
  font = createFont("Arial", 18);
  scale_factor = height/table_size;
  
  // we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods (see below)
  tuioClient  = new TuioProcessing(this);
  populateNames();
}

// within the draw method we retrieve a Vector (List) of TuioObject and TuioCursor (polling)
// from the TuioProcessing client and then loop over both lists to draw the graphical feedback.
void draw()
{
  background(255);
  textFont(font,32*scale_factor);
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 
   
  Vector tuioObjectList = tuioClient.getTuioObjects();
  for (int i=0;i<tuioObjectList.size();i++) {
     
     TuioObject tobj = (TuioObject)tuioObjectList.elementAt(i);
     //stroke(200,200,200);
     //fill(100,100,100);
     pushMatrix();
     translate(tobj.getScreenX(width),tobj.getScreenY(height));
     //rotate(tobj.getAngle());
     //rect(-obj_size/2,-obj_size/2,obj_size,obj_size);
     
     try{
       a = loadImage("photos/"+getImage(tobj.getSymbolID()));
       image(a, -obj_size/2,-obj_size/2,obj_size,obj_size);
     }
     catch(Exception e ){
       a = loadImage("photos/invalid.jpg");
       image(a, -obj_size/2,-obj_size/2,obj_size,obj_size);
     }

     popMatrix();
     
      if (checkedIn[tobj.getSymbolID()]){
         fill(0,255,0);
      }
      else {
        fill(255,0,0);
      }
     
     text(""+tobj.getSymbolID()+": " + getName(tobj.getSymbolID()) + ", " + getType(tobj.getSymbolID()) + checkMark(tobj.getSymbolID()), tobj.getScreenX(width)+70, tobj.getScreenY(height));
   }

}

// these callback methods are called whenever a TUIO event occurs

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  //println("remove object "+getName(tobj.getSymbolID())+" ("+tobj.getSessionID()+")");
  if (!checkedIn[tobj.getSymbolID()]){
    println("Checked in: "+getName(tobj.getSymbolID()));
    checkedIn[tobj.getSymbolID()] = true;
    logger(getFid(tobj.getSymbolID())+","+getName(tobj.getSymbolID())+","+getEmail(tobj.getSymbolID())+","+stringTime()+","+numTime());
  }
  else{
     println("\""+getName(tobj.getSymbolID())+"\" has already been checked in.");
  }
  
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  //println("add cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
/*  println("update cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
          */
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  //println("remove cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
}

// called after each message bundle
// representing the end of an image frame
void refresh(TuioTime bundleTime) { 
  redraw();
}

String getName(int id) {
  String s = "(invalid)";
  try
  {
    s = participants[id].name;
  }
  catch( ArrayIndexOutOfBoundsException e ){}
  catch(NullPointerException e ) {}
    return s;
}

String getType(int id) {
  String s = "(invalid)";
  try
  {
    s = participants[id].type;
  }
  catch( ArrayIndexOutOfBoundsException e ){}
  catch(NullPointerException e ) {}
    return s;
}

String getFid(int id) {
  String s = "(invalid)";
  try
  {
    s = "" + participants[id].fidID;
  }
  catch( ArrayIndexOutOfBoundsException e ){}
  catch(NullPointerException e ) {}
    return s;
}
String getEmail(int id) {
  String s = "(invalid)";
  try
  {
    s = participants[id].email;
  }
  catch( ArrayIndexOutOfBoundsException e ){}
  catch(NullPointerException e ) {}
    return s;
}


String getImage(int id) {
  String s = "invalid.jpg";
  try
  {
    s = participants[id].photo;
  }
  catch( ArrayIndexOutOfBoundsException e ){}
  catch(NullPointerException e ) {}
    return s;
}


String checkMark(int id){
      if (!checkedIn[id]){
         return "";
      }
      else {
         return " [✔]";
      } 
}


void populateNames() {

    String lines[] = loadStrings("people.csv");
    ArrayList ppl_tmp = new ArrayList();
    
    for(int i = 0; i < lines.length; i++){
        String values[] = (lines[i].split( ","));
        //println("index="+i+" :"+values[0] +", "+values[1] +", "+values[2] +", "+values[3]);
        // 0:fid, 1:name, 2:email, 3:type
        participants[i] = new Participant(Integer.parseInt(values[0]), values[1], values[2], values[3]);
        println("[" + i +"]: " +participants[i].printVals());
        //ppl_tmp.add( new Parti(values[0], values[1], values[2], values[3]) );
    }
}


long numTime(){
    Date de = new Date();
    long current = de.getTime()/1000;
    return current;
}

Date stringTime(){
    Date de = new Date();
    long current = de.getTime()/1000;
    java.util.Date d = new java.util.Date(current*1000);
    return d;
}

class Participant
{
  int fidID;
  String name;
  String email;
  String photo;
  String date;
  String time;
  String type;
  //String fname;
  //String lname;
  
  void newOut() {
    println( "Imported new participant: ("+fidID+") "+name+", "+ type +" ,"+photo);
    return;
  }
  
  void stamp(String d, String t){
     date = d;
     time = t;
     return; 
  }
  
  String printVals() {
   return ("" +fidID + ", "+ name + ", "  + email + ", " + type + ", " + photo); 
  }
  
  String makePhotoName(String email) {
    return "" + email.toLowerCase() +".jpg";
  }
  
  String makeCapital(String inputWord) {
    String firstLetter = inputWord.substring(0,1);  // Get first letter
    String remainder   = inputWord.substring(1);    // Get remainder of word.
    return firstLetter.toUpperCase() + remainder.toLowerCase();
  }
  
  Participant(int fid, String n, String e, String t) 
  {
    //docID = did;
    fidID = fid;
    name = n;
    email = e;
    type = t;
    //lname = ln.replaceAll("\\s+$","");
    //fname = fn.replaceAll("\\s+$","");
    photo = makePhotoName(email);
  }
}

String leadZero(int num){
  if (num <= 9) {return "0"+num;}
  else {return ""+num;}
}


void logger(String s)
{
  output = append(output, s);
  saveStrings(filename, output);
}

// # CALLED WHEN (ANY) KEYBOARD KEY IS RELEASED #
void keyReleased()
{
  if (key == '\\')
  {
   println("Last entry marked!");
   logger("^invalid");
  }
}


boolean[] checkedIn = new boolean[220];
Participant[] participants = new Participant[220];
String[] output = new String[0];
