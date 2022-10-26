import java.util.Iterator;

int objectsNum = 60;
int ringDistance = 20;
int ringSpeed = 1;
int centerMovementSpeed = 1;
int maxDistanceToCenter = 30;
int distanceToCenter = 0;
boolean tentaclesMoving = true;
boolean showRings = true;

//------------------------------

boolean movingToCenter = false; 
int colorFactor = 0;
int globalCounter = 0;
ArrayList<TrailingObject> objects;
Iterator<TrailingObject> objIterator;  

class TrailingObject { 
  float difX;
  float difY;
  float circX;
  float circY;
  float circRadio;
  float halfRadio;
  float speed;
  int quadrant; //1-4
  
  TrailingObject(){
    speed = 5;
    quadrant = 1;
    circRadio = 100;
    halfRadio = circRadio / 2;
    circX = mouseX - halfRadio;
    circY = mouseY - halfRadio;  
  }
  
  TrailingObject(float speed, int quadrant){
    super();
    this.speed = speed;
    this.quadrant = quadrant;
  }  
  
  private void adjustQuadrant(){
    switch(this.quadrant){
      case 1:
        difX -= halfRadio + distanceToCenter;
        difY -= halfRadio + distanceToCenter;
      break;
      case 2:
        difX += halfRadio + distanceToCenter;
        difY -= halfRadio + distanceToCenter;
      break;
      case 3:
        difX -= halfRadio + distanceToCenter;
        difY += halfRadio + distanceToCenter;
      break;
      case 4:
        difX += halfRadio + distanceToCenter;
        difY += halfRadio + distanceToCenter;
      break;
    }
  }
  
  void update() {           
    circRadio = speed * 2;
    halfRadio = circRadio / 2;
    
    difX = mouseX - circX;
    difY = mouseY - circY;
    
    adjustQuadrant();
    
    circX += difX / speed;
    circY += difY / speed;    
  } 
} 

void updateColorFactor(){ 
  if (globalCounter % ringSpeed == 0){
    if (colorFactor >= ringDistance) 
      colorFactor = 1;
    else
      colorFactor += 1;   
  }
}

void updateDistanceToCenter(){  
  if (globalCounter % centerMovementSpeed == 0){
      if (distanceToCenter > maxDistanceToCenter)
        movingToCenter = true;
        
      if (distanceToCenter <= 0)
        movingToCenter = false;    
      
      if (movingToCenter) 
        distanceToCenter -= 1;
      else
        distanceToCenter += 1;   
  }
}

void setup() { 
  size(800,600);
  
  objects = new ArrayList<TrailingObject>();   
  
  for (int i = objectsNum; i > 0 ; i--){
     objects.add(new TrailingObject(i, 1)); 
     objects.add(new TrailingObject(i, 2)); 
     objects.add(new TrailingObject(i, 3)); 
     objects.add(new TrailingObject(i, 4)); 
  }      

}

boolean isLight(int index){
  boolean result = false;
  
  int iterations = objectsNum / ringDistance * 4;
  
  for (int i = 0; i <= iterations; i++){
    result = result || (index >= colorFactor + (ringDistance * i) && index < colorFactor + (ringDistance * i) + 4);
  }
    
  return result;
}

void draw() { 
  background(0);   
    
  objIterator = objects.iterator();
  
  int i = 0;

  while(objIterator.hasNext()){
     i++;
    
     TrailingObject obj = objIterator.next();
     
     obj.update();

     noStroke();     
     
     float colorValue = (i * 255 / (objectsNum * 4));
     
     if (showRings && isLight(i)) 
       fill(0, colorValue + 20, 0);
     else
      fill(0, colorValue , 0);
     
     circle(obj.circX, obj.circY, obj.circRadio);         
  }
 
  updateColorFactor();
  if (tentaclesMoving) updateDistanceToCenter();
  globalCounter++;

}
    
    
