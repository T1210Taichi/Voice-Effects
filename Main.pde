/*http://www.pronowa.com/room/sound_content.html
上記サイトの「ディレイ」と「ビブラート」を実装
https://ism1000ch.hatenablog.com/entry/2014/06/10/145955
さらに上記サイトを参考にDistotionとOverDriveを実装
またそれらを入れ替えやすくUIの実装

ControlP5のreference
https://sojamo.de/libraries/controlP5/reference/index.html?controlP5/Button.html

Minimのreferece
https://code.compartmental.net/minim/index.html
*/

//import
import ddf.minim.*;
import ddf.minim.effects.*;
import controlP5.*;

//package
Minim minim;
AudioInput in;
ControlP5 cp5;

//UI
DropdownList dl;
Button bt;
Knob kn;

//parameter
//vibrato
float DEPTH = 0.002;    // sec
float FREQUENCY = 5.0;  // Hz
//echo
float DELAY_TIME = 1.0;
float DELAY_LEVEL = 0.5;
int FEEDBACK = 2;
//Distotion
float outVo = 0.7;
float amp = 1.0;
//周期
float FS = 44100.0;

//effect
MyAudioEffectClass effect;
EchoClass echo;
VibratoClass vibrato;
DistotionClass distotion;
OverDriveClass overdrive;


void setup()
{
  size(500, 500);
  textSize(20);
  minim = new Minim(this);
  in = minim.getLineIn(minim.MONO);
  
  echo = new EchoClass(FS, DELAY_TIME, DELAY_LEVEL, FEEDBACK);
  vibrato = new VibratoClass(FS, DEPTH, FREQUENCY);
  distotion = new DistotionClass(outVo, amp);
  overdrive = new OverDriveClass(outVo, amp);
  
  float fontSize = 20;
  ControlFont font = new ControlFont(createFont("MS Gothic",fontSize));  
  cp5 = new ControlP5(this);
  //どのエフェクタか選択
  dl = cp5.addDropdownList("ListEffect")
      .setPosition(width/2 - 210, 250)
      .setSize(130, 200)
      .setItemHeight(20)
      .setBarHeight(50)     
      .addItem("Echo", 0)
      .addItem("Vibrato", 1)
      .addItem("Distotion", 2)
      .addItem("OverDrive", 3)
      .setValue(0);
  //エフェクタのオンオフ
  bt = cp5.addButton("clearEffects")
      .setPosition(width/2 + 100, 250)
      .setSize(130, 50);  
  //エフェクトのかかり具合
  float knobRadius = 40;
  kn = cp5.addKnob("setVibrato")
     .setLabel("Effect Value")
     .setRange(1.0, 100.0)
     .setValue(1.0)
     .setPosition(width / 2 - knobRadius, 250 - knobRadius)
     .setRadius(knobRadius);  
     
     dl.getCaptionLabel().setFont(font);
     bt.getCaptionLabel().setFont(font);
     kn.getCaptionLabel().setFont(font);
}

//どのエフェクトか選択
void ListEffect(int n){
  //一度初期化
  in.clearEffects();
  
  switch(n){
    case(0): effect = echo;break;
    case(1): effect = vibrato;break;
    case(2): effect = distotion;break;
    case(3): effect = overdrive;break;
  }
  println("addEffect");
  in.addEffect(effect);
  kn.setValue(1.0);
}
// エフェクトのかかり具合を調整
void setVibrato(float value){
  println("set Effect Value");
  effect.setEffect(value);
}
//エフェクトのオンオフ
void clearEffects(){
  in.clearEffects();
  kn.setValue(1.0);
  println("clear Effect");
}

void draw()
{
  background(0);
  stroke(255);
  for(int i = 0; i < in.left.size()-1; i++)
  {
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }
  
  String monitoringState = in.isMonitoring() ? "enabled" : "disabled";
  text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
}

void stop()
{
  in.close();
  minim.stop();
  
  super.stop();
}

void keyPressed()
{
  if ( key == 'm' || key == 'M' )
  {
    if ( in.isMonitoring() )
    {
      in.disableMonitoring();
    }
    else
    {
      in.enableMonitoring();
    }
  }
}
