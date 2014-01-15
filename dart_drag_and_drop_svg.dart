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
    this.body = new RectElement();
    this.body.setAttribute('x', '$x');
    this.body.setAttribute('y', '$y');
    this.body.setAttribute('width', '$width');
    this.body.setAttribute('height', '$height');
    this.body.classes.add('processing_body');

    this.body.onMouseDown.listen(select);

    this.group = new GElement();
    this.group.append(this.body);

    this.dragging = false;
  }

  void select(MouseEvent e) {
    e.preventDefault();
    this.dragging = true;

    var mouseCoordinates = getMouseCoordinates(e);
    this.dragOffsetX = mouseCoordinates['x'] - body.getCtm().e; //double.parse(body.attributes['x']);
    this.dragOffsetY = mouseCoordinates['y'] - body.getCtm().f;

    this.canvas.onMouseMove.listen(moveStarted).resume();
    this.canvas.onMouseUp.listen(moveCompleted).resume();
  }

  void moveStarted(MouseEvent e) {
    e.preventDefault();

    if (dragging) {
      var mouseCoordinates = getMouseCoordinates(e);
      num newX = mouseCoordinates['x'] - dragOffsetX;
      num newY = mouseCoordinates['y'] - dragOffsetY;
      this.body.setAttribute('transform', 'translate($newX, $newY)');
    }
  }

  void moveCompleted(MouseEvent e) {
    e.preventDefault();
    this.dragging = false;

    this.canvas.onMouseMove.listen(moveStarted).cancel();
    this.canvas.onMouseUp.listen(moveCompleted).cancel();
  }

  dynamic getMouseCoordinates(e) {
    return {'x': (e.client.x - this.canvas.currentTranslate.x)/this.canvas.currentScale,
            'y': (e.client.y - this.canvas.currentTranslate.y)/this.canvas.currentScale};
  }
}

class Application {
  int WIDTH = 80, HEIGHT = 60;

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