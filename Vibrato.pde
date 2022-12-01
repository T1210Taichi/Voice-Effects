//http://www.pronowa.com/room/sound007.html

class VibratoClass extends MyAudioEffectClass
{
  float[] l_buffer;
  float[] r_buffer;
  int buffer_size;  
  int l_total_index, r_total_index;
  float dt;      // dt >= depth
  float depth;
  float freq;
  float fs;
  
  VibratoClass(float f, float dp, float fq)
  {
    fs = f;
    depth = fs * dp;
    dt = depth;
    freq = fq;
    
    buffer_size = (int)(2.0 * dt) + 256;
        
    l_buffer = new float[buffer_size];
    r_buffer = new float[buffer_size];
    
    l_total_index = 0;
    r_total_index = 0;
    
    for (int i = 0; i < buffer_size; i++)
    {
      l_buffer[i] = 0.0;
      r_buffer[i] = 0.0;
    }
  }
  
  int vibrato_process(float[] samp, float[] buffer, int ix)
  {
    float[] out = new float[samp.length];
    int n = ix;
    for ( int i = 0; i < samp.length; i++ )
    {
      int index = n % buffer_size;
      buffer[index] = samp[i];
      float fmod = dt + depth * sin( 2.0 * PI * freq * n / fs );
      float t = (float)index - fmod;
      int m0 = (int)t;
      int m1 = m0 + 1;
      float delta = t - (float)m0;
      if (m0 < 0)
      {
        m0 += buffer_size;
      }
      if (m1 < 0)
      {
        m1 += buffer_size;
      }
      out[i] = delta * buffer[m1] + (1.0 - delta) * buffer[m0];
      n++;
    }    
    arraycopy(out, samp);
    
    return n;
  }
  
  void process(float[] samp)
  {
    l_total_index = vibrato_process(samp, l_buffer, l_total_index);
  }
  
  void process(float[] left, float[] right)
  {
    l_total_index = vibrato_process(left, l_buffer, l_total_index);
    r_total_index = vibrato_process(right, r_buffer, r_total_index);
  }
  
  void setEffect(float value){
    freq = value;
  }
}
