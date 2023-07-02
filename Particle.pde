class Particle {
  PVector pos, velocity;
  float speed;
  float signal;
  float sensor_angle;
  float sensor_dist;
  int size;
  int too_much, crazy_period;
  
  Particle(float vel, float sig, float sa, float sd, int s, int th) {
    set_params(vel, sig, sa, sd, s, th, 1);
  }
  
  void set_params(float vel, float sig, float sa, float sd, int s, int th, int n) {
    velocity = PVector.random2D().setMag(vel);
    speed = vel;
    signal = sig;
    sensor_angle = sa;
    sensor_dist = sd;
    size = s;
    too_much = th;
    crazy_period = 0;
    if (n > 0) {
      pos = new PVector(int(random(width)), int(random(height)));
    }
  }
  
  int clamp(int value, int minimum, int maximum) {
    if (value < minimum){
      value = minimum;
    }
    else if (value >= maximum){
      value = maximum-1;
    }
    return value;
  }
  
  void update(int[] pix) {
    ellipse(pos.x, pos.y, size, size);
    velocity.setMag(sensor_dist);
    PVector s2v = PVector.add(pos, velocity);
    PVector s1v = PVector.add(pos, velocity.rotate(sensor_angle));  
    PVector s3v = PVector.add(pos, velocity.rotate(-sensor_angle*2));
    velocity.setMag(speed).rotate(sensor_angle);
    
    float s1 = pix[clamp(int(s1v.y)*width+int(s1v.x), 0, width*height)];
    float s2 = pix[clamp(int(s2v.y)*width+int(s2v.x), 0, width*height)];
    float s3 = pix[clamp(int(s3v.y)*width+int(s3v.x), 0, width*height)];
    
    if ((s1 > too_much || s2 > too_much || s3 > too_much) && (crazy_period == 0)) {
      crazy_period = 120;
      velocity.rotate(radians(random(160, 200))*(random(2)-1)); // Reverse the direction by rotating 180 degrees
    } else if (crazy_period > 0) {
      velocity.rotate(radians(random(sensor_angle, -sensor_angle)));
    } else if (s1 > s2 && s1 == s3) {
      velocity.rotate(sensor_angle*int(random(2)-1));
    } else if (s1 >= s2 && s1 > s3) {
      velocity.rotate(sensor_angle);
    } else if (s3 > s1 && s3 >= s2) {
      velocity.rotate(-sensor_angle);
    } 
    
    pos.add(velocity);
    if (pos.x < 0 || pos.x > width) {
      pos.sub(velocity);
      velocity.rotate(radians(180.0)); // Rotate 180 degrees to turn around
    }
  
    if (pos.y < 0 || pos.y > height) {
      pos.sub(velocity);
      velocity.rotate(radians(180.0)); // Rotate 180 degrees to turn around
    }
}
}
