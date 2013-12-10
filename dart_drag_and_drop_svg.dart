import 'dart:html';
import 'dart:async';
import 'dart:svg';

class BasicUnit {
  
  SvgSvgElement canvas;
  GElement group;
  RectElement body;
  bool dragging;
  num dragOffsetX, dragOffsetY, width, height;
  
  BasicUnit(SvgSvgElement this.canvas, num x, num y, num this.width, num this.height) {
    
    body = new RectElement();
    body.setAttribute('x', '$x');
    body.setAttribute('y', '$y');
    body.setAttribute('width', '$width');
    body.setAttribute('height', '$height');
    body.classes.add('processing_body');
    
    body.onMouseDown.listen(select);
    canvas.onMouseMove.listen(moveStarted);
    body.onMouseUp.listen(moveCompleted);
    canvas.onMouseLeave.listen(moveCompleted);
    
    group = new GElement();
    group.append(body);
    
    dragging = false;
  }
  
  void select(MouseEvent e) {
    e.preventDefault();
    dragging = true;
    
    var mouseCoordinates = getMouseCoordinates(e);
    dragOffsetX = mouseCoordinates['x'] - body.getCtm().e; //double.parse(body.attributes['x']);
    dragOffsetY = mouseCoordinates['y'] - body.getCtm().f;
  }
  
  void moveStarted(MouseEvent e) {
    e.preventDefault();
    
    if (dragging) {
      var mouseCoordinates = getMouseCoordinates(e);
      num newX = mouseCoordinates['x'] - dragOffsetX;
      num newY = mouseCoordinates['y'] - dragOffsetY;
      body.setAttribute('transform', 'translate($newX, $newY)');
    }
  }
  
  void moveCompleted(MouseEvent e) {
    e.preventDefault();
    dragging = false;
  }
  
  dynamic getMouseCoordinates(e) {
    return {'x': (e.offset.x - this.canvas.currentTranslate.x)/this.canvas.currentScale, 
            'y': (e.offset.y - this.canvas.currentTranslate.y)/this.canvas.currentScale};
  }
}

class Application {
  /*
   * Constants
   */
  int WIDTH = 80, HEIGHT = 60;
  
  /*
   * Class variables
   */
  SvgSvgElement canvas;
  
  Application(canvas_id) {
    this.canvas = document.querySelector(canvas_id);
    this.canvas.onDoubleClick.listen((MouseEvent e) => addNewUnit(e));
  }
  
  void addNewUnit(MouseEvent e) {
    num x = e.offset.x - WIDTH/2;
    num y = e.offset.y - HEIGHT/2;
    BasicUnit newUnit = new BasicUnit(this.canvas, x, y, WIDTH, HEIGHT);
    this.canvas.append(newUnit.group);
  }
}

void main() {
  Application app = new Application("#app_container");
}