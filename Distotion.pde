/*
https://ism1000ch.hatenablog.com/entry/2014/06/10/145955
上記サイトを参考にディストーションを実装
*/

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class DistotionClass extends MyAudioEffectClass{
  
  int l_index, r_index;
  float[] l_buffer;
  float[] r_buffer;
  
  float outVo;
  float amp;
  
  DistotionClass(float o, float a){
    outVo = o;
    amp = a;
    
  }
  
  int distotion_process(float[] samp, float[] buffer, int ix)
  {
    int index = ix;
    float[] out = new float[samp.length];
    
    for(int i = 0; i < samp.length; i++){
      samp[i] *= amp;
      samp[i] = min(1.0, samp[i]);
      samp[i] = max(-1.0, samp[i]);
      out[i] = samp[i] * outVo;
    }
    
    arraycopy(out, samp);
    return index;
  }  
  
  void process(float[] samp)
  {
    l_index = distotion_process(samp, l_buffer, l_index);
  }
  
  void process(float[] left, float[] right)
  {
    l_index = distotion_process(left, l_buffer, l_index);
    r_index = distotion_process(right, r_buffer, r_index);
  }
  
  void setEffect(float value){
    amp = value;
    println(amp);
  }
}
