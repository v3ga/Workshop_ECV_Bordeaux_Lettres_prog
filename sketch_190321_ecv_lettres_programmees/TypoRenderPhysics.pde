class TypoRenderPhysics extends TypoRender
{
  ArrayList<Box2DParticle> box2dParticles; 
  ArrayList<Box2DSurface> box2dSurfaces;

  float size1      = 5;
  float size2      = 15;
  float scale      = 1.4;

  TypoRenderPhysics()
  {
    super();
    this.name = "typoRenderPhysics";

    // Creation de l'univers Box2D
    box2d = new Box2DProcessing(applet);
    box2d.createWorld();
    box2d.setGravity(0, -10);

    reset();
  }

  void reset()
  {
    box2dParticles = new ArrayList<Box2DParticle>();
    box2dSurfaces = new ArrayList<Box2DSurface>();
  }

  void compute()
  {
    super.compute();
    if (tm!=null)
    {
      int i, j;  
      for (i=0; i<tm.shapesNb(); i++)
      {
        noFill();
        Box2DSurface s = new Box2DSurface(); 
        PVector[] pointsShape = tm.shape(i);
        for (j=0; j<pointsShape.length; j++)
        {
          PVector p = pointsShape[j];
          s.addPoint(p.x, p.y);
        }
        s.build();
        box2dSurfaces.add(s);
      }
    }
  }

  void draw()
  {
    if (mousePressed)
    {
      Box2DParticle particule = new Box2DParticle(mouseX-width/2, mouseY-height/2, random(size1, size2));
      box2dParticles.add(particule);
    }

    for (int i = box2dParticles.size()-1; i >= 0; i--) {
      Box2DParticle p = box2dParticles.get(i); 
      if (p.done())
        box2dParticles.remove(i);
    }

    // Mise à jour de Box2D
    box2d.step();

    super.draw();
  }

  void drawShapes(int nCalque)
  {
    pushStyle();
    // Dessin
    noFill();
    stroke(0);
    for (Box2DParticle p : box2dParticles) {
      p.display(this.scale);
    }
    
    if (!bExportSVG){
      for (Box2DSurface s : box2dSurfaces) {
        s.display();
      }
    }
    popStyle();
  }
}
