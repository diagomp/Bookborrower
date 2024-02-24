import processing.pdf.*;

import java.awt.AWTException;
import java.awt.Window;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.Dimension;
import java.awt.image.BufferedImage;
//import com.sun.awt.AWTUtilities;
import java.io.File;
import java.io.IOException;
import java.awt.event.InputEvent;
import java.awt.event.KeyEvent;
 
import javax.imageio.ImageIO;
import java.util.concurrent.TimeUnit;
import javax.swing.*;
import java.awt.Insets;

String bookName = "Máquinas y motores térmicos";
//String bookName = "prueba";
int numPages = 462;
int waitingTime = 6;

int[] pages = {117, 133, 153, 154, 182, 183, 266, 278, 296, 318, 357, 410, 459};

PImage screenshot;
int screenHeight;
int screenWidth;
float scale = 0.5;

float _xPosArea, _yPosArea;
float xPosArea, yPosArea;
float wArea, hArea;

int xPosButton, yPosButton;

PGraphicsPDF pdf;

Robot robot;
static final String RENDERER = FX2D;
final int[] xy = new int[2];

String msg = "";

boolean dragging = false;
boolean help = false;
boolean firstPage = true;

void settings() {
  Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
  screenWidth = screenSize.width;
  screenHeight = screenSize.height;
  size(int(screenWidth*scale),int(screenHeight*scale));
}

void setup () {
  
  //println(strToNumber("12526"));
  
  if (args != null) {
    //println("Programa con argumentos");
    numPages = 0;
    bookName = "";
    for (String s: args) {
      
      int num = strToNumber(s);
      if (num > 0) {
        numPages = num;
        break;
      }
      bookName += s + " ";
      
    }
  }
  
  
  surface.setResizable(false);
  surface.setAlwaysOnTop(true);
  //AWTUtilities.setWindowOpacity(frame, 0.5);
  wArea = width;
  hArea = height;
  try {
    robot = new Robot();
  }
  catch (Exception e) {
    System.err.println(e);
  }
  
  //beginRecord(PDF, bookName + ".pdf");
  screenshot = new PImage();
  cursor(CROSS);
}

void draw () {
  background(255);
  screenshot();
  //screenshot();
  pushMatrix();
  /*float scaleX = width/wArea;
  float scaleY = height/hArea;
  translate(-xPosArea*scaleX, -yPosArea*scaleY);
  image(screenshot,0 , 0, width*scaleX, height*scaleY);*/
  translate(-xPosArea, -yPosArea);
  image(screenshot,0 , 0, screenWidth*scale, screenHeight*scale);
  //println("Image\tWindow");
  //println(screenshot.width + "\t" + width);
  popMatrix();
  
  if (help) {
    //int screenshotPixels[][] = new int[screenshot.width][screenshot.height];
    screenshot.loadPixels();
    for (int i = 0; i < screenshot.width; i++) {
      for (int j = 0; j < screenshot.height; j++) {
        //screenshotPixels[i][j] = screenshot.pixels[j*screenshot.width + i];
        if(pow((xPosArea + mouseX)/scale - i, 2)+pow((yPosArea + mouseY)/scale - j,2) > pow(200,2)) {
          screenshot.pixels[j*screenshot.width + i] = color(0, 0, 0, 255);
        }
      }
    }
    screenshot.updatePixels();
    pushMatrix();
    translate(-2*(xPosArea+mouseX), -2*(yPosArea+mouseY));
    image(screenshot, mouseX , mouseY, 2*screenWidth*scale, 2*screenHeight*scale);
    popMatrix();
  }
  
  if (dragging) {
    stroke(255, 0, 0);
    strokeWeight(2);
    fill(255, 0, 0, 100);
    rect(_xPosArea, _yPosArea, mouseX-_xPosArea, mouseY-_yPosArea);
  }
  
  
  /*if (args != null) {
    background(255);
    fill(0);
    text(bookName, width/2, height/2);
  }*/
  
  
  
  
}

void mouseDragged() {
  if (!dragging && mouseButton == CENTER) {
    dragging = true;
    _xPosArea = mouseX;
    _yPosArea = mouseY;
  }
}

void mouseReleased() {
  if (mouseButton == CENTER) {
    dragging = false;
    xPosArea = _xPosArea;
    yPosArea = _yPosArea;
    wArea = mouseX - xPosArea;
    hArea = mouseY - yPosArea;
    surface.setSize(int(wArea),int(hArea));
    /*if (frame != null) {
      getWindowLocation(this, xy);
      surface.setLocation(int(xy[0]+xPosArea), int(xy[1]+yPosArea));
    }*/
    help = false;
  }
}

void keyPressed() {
  switch (key) {
    case 'u':
    case 'U':
      screenshot();
      println("UPDATED");
      break;
    case 'r':
    case 'R':
      xPosArea = 0;
      yPosArea = 0;
      wArea = screenWidth*scale;
      hArea = screenHeight*scale;
      surface.setSize(int(wArea),int(hArea));
      println("RESET");
      break;
    case 'h':
    case 'H':
      help = !help;
      break;
    case 'c':
    case 'C':
      xPosButton = int((mouseX+xPosArea)/scale);
      yPosButton = int((mouseY+yPosArea)/scale);
      break;
    case 'f':
    case 'F':
      copyPagePDF();
      //pdf.image(screenshot, -xPosArea/scale, -yPosArea/scale, screenWidth*2480/wArea, screenHeight*23508/hArea);
      moveToFollowingPage();
      
      break;
    case 's':
    case 'S':
      createPDF();
      break;
    case 'e':
    case 'E':
      endPDF();
      break;
    case CODED:
      if (keyCode == UP) {
        println("UP key pressed");
        thread("copyBook");
      }
      else if (keyCode == DOWN) {
        println("DOWN key pressed");
        thread("printPages");
      }
      
  }
  
  if (key >= '0' && key <= '9') {
    waitingTime = key - '0';
    println("\n\nWT: " + waitingTime);
  }
 
    
}
void screenshot() {
  try {
    screenshot = new PImage(new Robot().createScreenCapture(new Rectangle(0, 0, displayWidth, displayHeight)));
  } catch (AWTException e) { }
}

void createPDF () {
  pdf = (PGraphicsPDF) createGraphics(2480, 3508, PDF, bookName + ".pdf");
  pdf.beginDraw();
  pdf.background(255);
}

void endPDF () {
  pdf.dispose();
  pdf.endDraw();
}

void copyPagePDF () {
  if (!firstPage) {
    pdf.nextPage();
  }
  firstPage = false;
  pdf.image(screenshot, -xPosArea*2480/wArea, -yPosArea*3508/hArea, 2480*scale*screenWidth/wArea, 3508*scale*screenHeight/hArea);
}

void moveToFollowingPage() {
  robot.mouseMove(xPosButton, yPosButton);
  robot.mousePress(InputEvent.BUTTON1_MASK);
  robot.mouseRelease(InputEvent.BUTTON1_MASK);
      
  getWindowLocation(this, xy);
  robot.mouseMove(xy[0], xy[1]);
  robot.mousePress(InputEvent.BUTTON1_MASK);
  robot.mouseRelease(InputEvent.BUTTON1_MASK);
}

void copyBook() {
  println("COPY PROCESS STARTED...");
  
  //frame = (JFrame) ((processing.awt.PSurfaceAWT.SmoothCanvas)app.getSurface().getNative()).getFrame();
  JFrame info = new JFrame();
  info.setSize(350, 80);
  info.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  info.setTitle("Status bar");
  info.setAlwaysOnTop(true);
  //info.setUndecorated(true);
  //info.setResizable(false);
  
  JPanel p = new JPanel();
  //info.insets =new Insets(5, 5, 5, 5;
  p.setLayout(new BoxLayout(p, BoxLayout.Y_AXIS));
  JLabel label = new JLabel("Loading...");
 
  JProgressBar pb = new JProgressBar();
  pb.setStringPainted(true);
  pb.setValue(0);
  
  p.add(label);
  p.add(pb);
  info.add(p);
  info.setVisible(true);
  
  
  createPDF();
  for (int i = 0; i < numPages; i++) {
    try {
      TimeUnit.SECONDS.sleep(waitingTime);
    }
    catch (Exception e) {
      System.err.println(e);
    }
    copyPagePDF();
    moveToFollowingPage();
    pb.setValue(100*i/numPages);
    
    println("Page " + (i+1) + " out of " + numPages + " copied.");
  }
  endPDF();
  p.setVisible(false);
  println("BOOK COPIED SUCCESFULLY.");
}

void printPages (/*int ... pages*/) {
  //createPDF();
  
   for (int i = 0; i < pages.length; i++) {
     try {
       TimeUnit.SECONDS.sleep(waitingTime);
     }
     catch (Exception e) {
       System.err.println(e);
     }
     
     // Creamos un PDF por cada hoja especificada
     bookName = "page " + pages[i];
     firstPage = true;
     createPDF();
     copyPagePDF();
     endPDF();
     
     
     // Avanzamos el número de páginas suponiendo que están puestas en orden
     if (i == pages.length - 1) break;
     for (int j = 0; j < pages[i + 1] - pages[i]; j++) {
       moveToFollowingPage();
       try {
         TimeUnit.MILLISECONDS.sleep(500);
       }
       catch (Exception e) {
         System.err.println(e);
       }
     }
   }
  
}

static final int[] getWindowLocation(final PApplet pa, int... xy) {
  if (xy == null || xy.length < 2)  xy = new int[2];
 
  final Object surf = pa.getSurface().getNative();
  final PGraphics canvas = pa.getGraphics();
 
  if (canvas.isGL()) {
    xy[0] = ((com.jogamp.nativewindow.NativeWindow) surf).getX();
    xy[1] = ((com.jogamp.nativewindow.NativeWindow) surf).getY();
  } else if (canvas instanceof processing.awt.PGraphicsJava2D) {
    final java.awt.Component f =
      ((processing.awt.PSurfaceAWT.SmoothCanvas) surf).getFrame();
 
    xy[0] = f.getX();
    xy[1] = f.getY();
  } else try {
    final java.lang.reflect.Method getStage =
      surf.getClass().getDeclaredMethod("getStage");
 
    getStage.setAccessible(true);
 
    final Object stage = getStage.invoke(surf);
    final Class<?> st = stage.getClass();
 
    final java.lang.reflect.Method getX = st.getMethod("getX");
    final java.lang.reflect.Method getY = st.getMethod("getY");
 
    xy[0] = ((Number) getX.invoke(stage)).intValue();
    xy[1] = ((Number) getY.invoke(stage)).intValue();
  }
  catch (final ReflectiveOperationException e) {
    System.err.println(e);
  }
 
  return xy;
}

int strToNumber (String s) {
  int num = 0;
  for (int i = 0; i < s.length(); i++) {
    char c = s.charAt(i);
    if (c <= '9' && c >= '0') {
      //Caracter numérico
      num *= 10;
      num += c - '0';
    }
    else {
      return -1; 
    }
  }
  
  return num;
}
