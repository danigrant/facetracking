// live video library
import processing.video.*;

// open CV library
import gab.opencv.*;
import java.awt.Rectangle;

// main open CV object (contains a ton of computer vision methods)
OpenCV opencv;

// array to hold all of the positions of the found faces
Rectangle[] faces = {
};

// camera capture object
Capture video;

// video scaling factor
int scalingFactor = 2;

// hats and moustache images!

PImage horns;
PImage eyes;
PImage lips;

int opacity = 0;
boolean changeColor = false;

void setup() 
{
  size(320*scalingFactor, 240*scalingFactor);

  // grab an array of our cameras
  String[] cameras = Capture.list();

  // no camera objects - no need to continue!  
  if (cameras.length == 0) 
  {
    println("There are no cameras available for capture.");
    exit();
  } 
  else 
  {
    // create a video object
    // note - bring this in at a low resolution so that you
    // don't make things chug too much!
    video = new Capture(this, 320, 240);

    // Start capturing the images from the camera
    video.start();

    // create our open CV object and tell it to monitor the video stream
    opencv = new OpenCV(this, video);

    // tell open CV to begin looking for faces
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  


    horns = loadImage("horns.png");
    eyes = loadImage("eyes.png");
    lips = loadImage("lips.png");
  }
}

void draw() 
{
  if (video.available() == true) 
  {
    // read a new frame of video
    video.read();

    // tell OpenCV about this frame
    opencv.loadImage(video);

    // attempt to detect any new faces
    faces = opencv.detect();
  }

  // image the camera to the screen - we can scale it up here if we want
  imageMode(CORNER);
  image(video, 0, 0, width, height);
  
  //fill(255, opacity);
  //rect(0,0, width, height);
  //opacity = (int)map(mouseY, 0, height, 0, 255);

  // now iterate over our faces array - it will contain the position
  // of any faces detected by open CV as well as their width and height
  for (int i = 0; i < faces.length; i++) 
  {
    // compute a scaling factor for this face
    float hornsFactor = float(faces[i].width)/float(horns.width);
    float eyesFactor = float(faces[i].width)/float(eyes.width);
    float lipsFactor = float(faces[i].width)/float(lips.width);

    // don't be scared by all this math - it was all trial and error to find the right values
    // for the images I chose!
    imageMode(CENTER);
    image(horns, faces[i].x*scalingFactor + 0.52 *faces[i].width*scalingFactor, 
    faces[i].y*scalingFactor - 0.05*faces[i].height*scalingFactor, 
    faces[i].width*scalingFactor*2.5, 
    horns.height*hornsFactor*scalingFactor*2);

    image(eyes, faces[i].x*scalingFactor + 0.48*faces[i].width*scalingFactor, 
    faces[i].y*scalingFactor + 0.3*faces[i].height*scalingFactor, 
    faces[i].width*scalingFactor*1.5, 
    1.5*eyes.height*eyesFactor*scalingFactor);

    image(lips, faces[i].x*scalingFactor + 0.48*faces[i].width*scalingFactor, 
    faces[i].y*scalingFactor + 0.8*faces[i].height*scalingFactor, 
    faces[i].width*scalingFactor*1.5, 
    1.5*lips.height*lipsFactor*scalingFactor);
  }
}
