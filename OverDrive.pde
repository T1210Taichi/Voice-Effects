/*
https://ism1000ch.hatenablog.com/entry/2014/06/10/145955
上記サイトを参考にオーバードライブを実装
*/

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class OverDriveClass extends MyAudioEffectClass{
  
  int l_index, r_index;
  float[] l_buffer;
  float[] r_buffer;
  
  float outVo;
  float amp;
  
  OverDriveClass(float o, float a){
    outVo = o;
    amp = a;
    
  }
  
  int overdrive_process(float[] samp, float[] buffer, int ix)
  {
    int index = ix;
    float[] out = new float[samp.length];
    
    for(int i = 0; i < samp.length; i++){
      float d = samp[i];
      float res;
      d = atan(d) / (PI / 2.0);
      if(d > 0){
        res = d * amp;
      }else{
        res = d * amp * 0.3;
      }
      res = min(res, 1.0);
      res = max(res, -1.0);
      out[i] = res * outVo;
    }
    
    arraycopy(out, samp);
    return index;
  }  
  
  void process(float[] samp)
  {
    l_index = overdrive_process(samp, l_buffer, l_index);
  }
  
  void process(float[] left, float[] right)
  {
    l_index = overdrive_process(left, l_buffer, l_index);
    r_index = overdrive_process(right, r_buffer, r_index);
  }
  
  void setEffect(float value){
    amp = value;
    println(amp);
  }
}
