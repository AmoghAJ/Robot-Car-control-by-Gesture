/*
 *  Program:Car control by getsure
 *  Author:1.Amogh jagadale
 *         2.Suraj Phalake
 *         3.Sabaratnam Yadav
*/

// LED for indication
#define ledPin  13

// Left Motor Controls
# define Lp  7    // ip A
# define Ln  4    // ip B
# define El  5    
// Right Motor Controls
# define Rp  8   // ip A
# define Rn  12  // ip B
# define Er  6

float Val01,Val02;
byte serialByte;         // incoming serial byte

void setup() 
{
  Serial.begin(9600);
  pinMode (ledPin, OUTPUT);
  pinMode (Lp, OUTPUT);
  pinMode (Ln, OUTPUT);
  pinMode (El, OUTPUT);
  pinMode (Rp, OUTPUT);
  pinMode (Rn, OUTPUT);
  pinMode (Er, OUTPUT);
  
  digitalWrite (ledPin,LOW);
  digitalWrite (El,HIGH);
  digitalWrite (Er,HIGH);
}
void loop()
{
  if (Serial.available()>4)
  {
  char val= Serial.read();
  if(val=='S')
  {
  {
 Val01=Serial.read();
 Val02=Serial.read();
  }
}
if(Val01==1)
{
TurnRight();
}
else if(Val01==2)
{
TurnLeft();  
}
else if(Val02==1)
{
MoveUp();
}
else if(Val02==2)
{
MoveDown();
}
else if(Val02==0)
{
CarStop();
}
}
}
//Method declaration
//Right
void TurnRight()
{
digitalWrite (Lp,HIGH);
digitalWrite (Ln,LOW);
digitalWrite (Rp,LOW);
digitalWrite (Rn,HIGH);  
}
//left 
void TurnLeft()
{ 
digitalWrite (Lp,LOW);
digitalWrite (Ln,HIGH);
digitalWrite (Rp,HIGH);
digitalWrite (Rn,LOW);
}
//Forward
void MoveUp()
{
  digitalWrite (Lp,LOW);
  digitalWrite (Ln,HIGH);
  digitalWrite (Rp,LOW);
  digitalWrite (Rn,HIGH);
}
//Backward
void MoveDown()
{
digitalWrite (Lp,HIGH);
digitalWrite (Ln,LOW);
digitalWrite (Rp,HIGH);
digitalWrite (Rn,LOW);
}
//Stop
void CarStop()
{
digitalWrite (Lp,LOW);
digitalWrite (Ln,LOW);
digitalWrite (Rp,LOW);
digitalWrite (Rn,LOW);
}
  
