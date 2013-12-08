import 'dart:html';
import 'dart:async';
import 'dart:svg';

class BasicUnit {
  
  SvgSvgElement canvas;
  GElement group;
  RectElement body;
  bool dragging;
  num dragOffsetX, dragOffsetY, width, height;
  
  BasicUnit(SvgSvgElement canvas, num x, num y, num width, num height) {
    this.canvas = canvas;
    this.width = width;
    this.height = height;
    
    this.body = new RectElement();
    this.body.setAttribute('x', '$x');
    this.body.setAttribute('y', '$y');
    this.body.setAttribute('width', '$width');
    this.body.setAttribute('height', '$height');
    this.body.classes.add('processing_body');
    
    this.body.onMouseDown.listen((MouseEvent e) => select(e));
    this.body.onMouseMove.listen((MouseEvent e) => moveStarted(e));
    this.body.onMouseUp.listen((MouseEvent e) => moveCompleted(e));
    this.body.onMouseLeave.listen((MouseEvent e) => moveCompleted(e));
    
    this.group = new GElement();
    this.group.append(this.body);
    
    this.dragging = false;
  }
  
  void select(MouseEvent e) {
    this.dragging = true;
    this.group.parentNode.append(this.group);
    
    var mouseCoordinates = this.getMouseCoordinates(e);
    this.dragOffsetX = mouseCoordinates['x'] - this.body.getCtm().e; //double.parse(this.body.attributes['x']);
    this.dragOffsetY = mouseCoordinates['y'] - this.body.getCtm().f; //double.parse(this.body.attributes['y']);
  }
  
  void moveStarted(MouseEvent e) {
    if (this.dragging) {
      var mouseCoordinates = this.getMouseCoordinates(e);
      num newX = mouseCoordinates['x'] - this.dragOffsetX;
      num newY = mouseCoordinates['y'] - this.dragOffsetY;
      //this.body.setAttribute('x', '$newX');
      //this.body.setAttribute('y', '$newY');
      this.body.setAttribute('transform', 'translate($newX, $newY)');
    }
  }
  
  void moveCompleted(MouseEvent e) {
    this.dragging = false;
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