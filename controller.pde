import SimpleOpenNI.*;
import processing.opengl.*;
import processing.serial.*;
SimpleOpenNI kinect;
Serial myPort;
// NITE
XnVSessionManager sessionManager;
XnVPointControl pointControl;
// Font for text on screen
PFont font;
String Ctext;
String dir;
// Variables for Hand Detection
boolean handsTrackFlag = false;
PVector screenHandVec = new PVector();
PVector handVec = new PVector();
int t = 0;
PVector centerVec = new PVector();
PVector screenCenterVec = new PVector();
PVector v = new PVector();
boolean automated=true;
boolean serial = true;
int Val01, Val02,value;
float temp01, temp02, temp03, temp04;

void setup() {
	// Simple-openni object
	kinect = new SimpleOpenNI(this);
	kinect.setMirror(true);
	// enable depthMap generation, hands + gestures
	kinect.enableDepth();
	kinect.enableGesture();
	kinect.enableHands();
	// setup NITE
	sessionManager = kinect.createSessionManager("Wave", "RaiseHand");
	// Setup NITE.s Hand Point Control
	pointControl = new XnVPointControl();
	pointControl.RegisterPointCreate(this);
	pointControl.RegisterPointDestroy(this);
	pointControl.RegisterPointUpdate(this);
	// Add it to the session
	sessionManager.AddListener(pointControl);
	// Set the sketch size to match the depth map
	size(kinect.depthWidth(), kinect.depthHeight());
	smooth();
	// Initialize Font

	Ctext="Kinect is live";
	dir = "";
	//Initialize Serial Communication
	if (serial) {
		String portName = Serial.list()[0]; // This gets the first port
		myPort = new Serial(this, portName, 9600);
	}	
}

void draw() {
	background(0);
	PVector centerL = new PVector(width/2, height/2);
	// Update Kinect data
	kinect.update();
	// update NITE
	kinect.update(sessionManager);
	// draw depthImageMap
	image(kinect.depthImage(), 0, 0);
	//displacement between the centre and the hand in 2D
	v.x = screenHandVec.x-centerL.x;
	v.y = screenHandVec.y-centerL.y;
	if (handsTrackFlag) {
	drawHand();
	drawArrow(v, centerL);
	controlCar();
	}
	textDisplay();
	if (serial) {
	sendSerialData();
	}
}

void controlCar() {
	temp01 = screenHandVec.x-width/2;
	temp02 = height/2- screenHandVec.y;
	temp03 = int(map(temp01, -width/2, width/2, 0, 255));

	if (temp03 < 100) {
	Val01 = 1;
	}
	if (temp03 >150) {
	Val01 = 2;
	}
	if ((temp03 > 100) && (temp03 < 150)) {
	Val01 = 0;
	}
	temp04= int(map(temp02, -height/2, height/2, -255, 250));
	if ((temp04 > 0) && (temp04 > 50)) {
	Val02 = 1;
	}
	else if ((temp04 < 0) && (temp04 < -50)) {
	Val02 = 2;
	}
	else {
	Val02 = 0;
	}
}

// Draw the hand on screen
void drawHand() {
	stroke(255, 0, 0);
	pushStyle();
	strokeWeight(6);
	kinect.convertRealWorldToProjective(handVec, screenHandVec);
	point(screenHandVec.x, screenHandVec.y);
	popStyle();
}

void drawArrow(PVector v, PVector loc) {
	pushMatrix();
	float arrowsize = 4;
	translate(loc.x, loc.y);
	stroke(255, 0, 0);
	strokeWeight(2);
	rotate(v.heading2D());
	float len = v.mag();
	line(0, 0, len, 0);
	line(len, 0, len-arrowsize, +arrowsize/2);
	line(len, 0, len-arrowsize, -arrowsize/2);
	popMatrix();
}

void textDisplay() {
	fill(255,0,0);
	text(Ctext, 10, kinect.depthHeight()-10);
	text("Direction: "+dir, 10, kinect.depthHeight()-50);
	if ((Val02 == 1) && (Val01 == 0))
	{
	dir ="Forward";
	}
	else if ((Val02 == 2) && (Val01 == 0))
	{
	dir="Reverse";
	}
	else if ((Val02 == 0) && (Val01 == 1))
	{
	dir="Left";
	}
	else if ((Val02 == 0) && (Val01 == 2)) 
	{
	dir="Right";
	}
	else if((Val01 == 0) && (Val02 == 0))
	{
	dir="Stop";
	}
}

void sendSerialData() {
	// Serial Communcation
	myPort.write('S');
	myPort.write(Val01);
	myPort.write(Val02);
}

// XnVPointControl callbacks
void onPointCreate(XnVHandPointContext pContext) {
	println("onPointCreate:");
	handsTrackFlag = true;
	handVec.set(pContext.getPtPosition().getX(),
	pContext.getPtPosition().getY(),
	pContext.getPtPosition().getZ());
}

void onPointDestroy(int nID) {
	println("PointDestroy: " + nID);
	handsTrackFlag = false;
}

void onPointUpdate(XnVHandPointContext pContext) {
	handVec.set(pContext.getPtPosition().getX(),
	pContext.getPtPosition().getY(),
	pContext.getPtPosition().getZ());
}