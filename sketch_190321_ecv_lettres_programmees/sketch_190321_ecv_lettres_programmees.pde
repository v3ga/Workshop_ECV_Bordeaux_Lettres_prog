/*
  Lettres programmées
 
 —
 Developped and tested on : 
 - Processing 3.4 on MacOSX (10.13.6)
 
 —
 Julien @v3ga Gachadoat
 www.instagram.com/julienv3ga
 www.v3ga.net
 www.2roqs.com
 
 */

// ----------------------------------------------------------
import java.util.*;
import controlP5.*;
import geomerative.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import shiffman.box2d.*;
import processing.svg.*;

// ----------------------------------------------------------
// ----------------------------------------------------------
// ----------------------------------------------------------
// ----------------------------------------------------------
// Nom de la fonte à placer dans le dossier data/fontes
String fontFilename = "futura.ttf";
// Lettre par défaut à l'ouverture du programme
String letter = "B";
// Couleur du tracé
color colorLines = color(0, 0, 0);
// Fond (.svg )
// Laisser le champ vide pour ne rien afficher
//String backgroundFilename = "exports/190319_215808_export.svg"; 
String backgroundFilename = ""; 
// Mode de dessin par défaut
// 1 -> lignes
// 2 -> cercles
// 3 -> rectangle
// 4 -> motif (dessiné à partir de motif.svg)
String motifFilename = "images/motif.svg";
// 5 -> custom : va appeler la fonction drawCustom() définie ci dessous où on va pouvoir faire « ce que l'on veut »


// ----------------------------------------------------------
// ----------------------------------------------------------
// ----------------------------------------------------------
// ----------------------------------------------------------
PFont font15, font30;

// ----------------------------------------------------------
PApplet applet;
ControlFrame cf;
Timer timer;
boolean bExportSVG = false;

TypoRender typoRenderCurrent;
TypoRenderBasic typoRenderBasic;
TypoRenderPhysics typoRenderPhysics;
ArrayList<TypoRender> typoRenderers = new ArrayList<TypoRender>();
Box2DProcessing box2d;

PShape backgroundSVG, motifSVG;

// ----------------------------------------------------------
void settings()
{
  applet=(PApplet)this;
  defineFormats();
  applyFormatSize("40x40");
}

// ----------------------------------------------------------
void setup()
{
  RG.init(this);
  typoRenderBasic = new TypoRenderBasic();
  typoRenderBasic.set(fontFilename, letter, 20);
  typoRenderers.add( typoRenderBasic );

  typoRenderPhysics = new TypoRenderPhysics();
  //  typoRenderPhysics.set(fontFilename, letter, 20);
  //  typoRenderers.add( typoRenderPhysics );
  typoRenderCurrent =  typoRenderBasic;
  initMedias();
  createControls();
  surface.setLocation(500, 10);
  timer = new Timer();
}

// ----------------------------------------------------------
void draw()
{
  float dt = timer.dt();

  background(255);
  if (backgroundSVG!=null)
  {
    pushStyle();
    noFill();
    stroke(0, 50);
    shape(backgroundSVG, 0, 0, width, height);
    popStyle();
  }

  if (bExportSVG)
  {
    beginRecord(SVG, "data/exports/"+timestamp()+"_export.svg");
  }
  typoRenderCurrent.update(dt);
  typoRenderCurrent.draw();
  if (bExportSVG)
  {
    endRecord();
    bExportSVG = false;
  }
  typoRenderCurrent.drawMode();
}

// ----------------------------------------------------------
void keyPressed()
{
  if ( (key >= 'a' && key <= 'z') || (key >= 'A' && key <= 'Z'))
  {
    for (TypoRender tr : typoRenderers) 
      tr.setText(""+key);
  } 
  else if ((key >= '1' && key <= '9'))
  {
    int mode =  int( key-'1' );
    typoRenderBasic.setMode( mode );
    println("mode="+mode);
  }
  else if (key == ' ')
  {
    saveFrame("data/exports/"+timestamp()+"_export.jpg");
  }
}

// ----------------------------------------------------------
TypoRender getTypoRender(String name)
{
  TypoRender tr = null;
  for (TypoRender tr_ : typoRenderers) 
    if (tr_.name.equals(name))
      tr = tr_;
  return tr;
}

// ----------------------------------------------------------
void drawCustom(int nCalque, int indexPoint, int nbPoints)
{
  // float size1 = typoRenderBasic.getValue(indexPoint, nbPoints, typoRenderBasic.size1);
  // ellipse(random(-10,10), random(-20,20) ,10,10);
  // line(0,-random(0,100) ,0,random(0,100));
  float size1 = typoRenderBasic.size1;
  if (typoRenderBasic.bMotionSize1) // 
  {
    size1 = typoRenderBasic.getValue(indexPoint, nbPoints, size1); // valeur dynamique de size1
  }

  float size2 = typoRenderBasic.size2;
  if (typoRenderBasic.bMotionSize2) // 
  {
    size2 = typoRenderBasic.getValue(indexPoint, nbPoints, size1); // valeur dynamique de size1
  }
  arc(0, 0, size1, size1, 0, PI/1.5);


  /*  beginShape();
   vertex(-size1,-size1);
   vertex(size1,-size1);
   vertex(0,size1);
   vertex(-2*size1,size1);
   endShape(CLOSE);
   */

  //ellipse(0,0,size2,size2);
  //bezier(0,0, size1, size1, size2, size2, 40,40);
}
