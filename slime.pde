int np = 15000;
int scr_size = 800;
float velocity, sig, sa, sd, decay;
int psize, th;

void setup() {
  size(800, 800);
  set_random_params();
  set_particle_params(1, 1);
  frameRate(60);
  background(0);
}

void set_random_params() {
  velocity = random(2, 10);
  sig = int(random(12, 50));
  sa = int(random(10, 100));
  sd = int(random(velocity, 30));
  decay = int(random(5, sig-5));
  psize = int(random(5, 13));
  th = int(random(50, 220));
  println("New Random Params: \tvel="+str(velocity)+" \tsig_str="+str(sig)+" \tdecay="+str(decay)+" \tsa="+str(sa)+" \tsd="+str(sd)+" \tp_size="+str(psize)+" \tth="+str(th));
}


Particle[] particles = new Particle[np];

void set_particle_params(int n, int n2) {
  if (n2 > 0) {
    for (int i = 0; i < np; i++) {
      particles[i] = new Particle(velocity, sig, sa, sd, psize, th);
    }
  } else {
    for (int i = 0; i < np; i++) {
      particles[i].set_params(velocity, sig, sa, sd, psize, th, n);
    }
  }
}

void keyPressed() {
  if (key == 'r') {
    set_random_params();
    set_particle_params(0, 0);
  } else if (key == 'n') {
    set_random_params();
    set_particle_params(1, 0);
  }
}






void draw() {
  fill(0, decay);
  rect(0, 0, width, height);
  loadPixels();
  updatePixels();
  noStroke();
  fill(255, 255, 255, particles[0].signal);
  for (int i = 0; i < np; i++) {
    particles[i].update(pixels);
  }
}
