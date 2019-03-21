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
String letter = "A";
// Couleur du tracé
color colorLines = color(0,0,0);
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
PFont font15,font30;

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
  applyFormatSize("21x30");
}

// ----------------------------------------------------------
void setup()
{
  RG.init(this);
  typoRenderBasic = new TypoRenderBasic();
  typoRenderBasic.set(fontFilename, letter, 20);
  typoRenderers.add( typoRenderBasic );

//  typoRenderPhysics = new TypoRenderPhysics();
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
    stroke(0,50);
    shape(backgroundSVG, 0, 0, width, height);
    popStyle();
  }
  shape(motifSVG,0,0);

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
  
}
