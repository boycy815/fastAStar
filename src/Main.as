package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	/**
	 * A*搜索 128x128 4方向
	 * @author clifford.cheny http://www.cnblogs.com/flash3d/
	 */
	
	[SWF(width=640,height=675)]
	public class Main extends Sprite 
	{
		private var _astar:FastAstar;
		private var _canvas:BitmapData;
		private var _scene:Sprite;
		private var _text:TextField;
		private var _button:String;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_astar = new FastAstar();
			//_astar.isPrune = false;
			_canvas = new BitmapData(640, 640);
			var bmp:Bitmap = new Bitmap(_canvas);
			_scene = new Sprite();
			addChild(bmp);
			addChild(_scene);
			
			_text = new TextField();
			_text.width = stage.stageWidth;
			_text.height = 35;
			_text.y = 640;
			_button = "<a href='event:refresh'>刷新</a>"
			_text.htmlText = _button;
			addChild(_text);
			
			_text.addEventListener(TextEvent.LINK, onLink);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			
			onLink();
		}
		
		private var _startX:int;
		private var _startY:int;
		private var _endX:int;
		private var _endY:int;
		private var _step:int;
		
		private function onLink(e:TextEvent = null):void
		{
			var l:int;
			var i:int;
			var t:Node;
			_step = 0;
			var ttt:int = getTimer();
			_astar.createMap();
			_text.htmlText = "耗时：" + (getTimer() - ttt) + "ms    " + _button;
			_scene.graphics.clear();
			_canvas.fillRect(new Rectangle(0, 0, 640, 640), 0xFF00FF00)
			l = _astar.map.length;
			for (i = 0; i < l; i++)
			{
				t = _astar.map[i];
				if (t.block == _astar.mapVersion)
					_canvas.fillRect(new Rectangle(t.x * 5, t.y * 5, 5, 5), 0xFF000000);
			}
		}
		
		private function onPress(e:MouseEvent):void
		{
			if (e.stageX < 0 || e.stageX >= 640) return;
			if (e.stageY < 0 || e.stageY >= 640) return;
			
			var graphics:Graphics = _scene.graphics;
			
			if (_step == 0)
			{
				graphics.clear();
				_startX = int(e.stageX / 5);
				_startY = int(e.stageY / 5);
				if (_astar.map[_startY << FastAstar.D1 | _startX].block == _astar.mapVersion) return;
				graphics.beginFill(0xFFFF0000);
				graphics.drawCircle(_startX * 5 + 2.5, _startY * 5 + 2.5, 2.5);
				graphics.endFill();
				_step++;
			}
			else if (_step == 1)
			{
				_endX = int(e.stageX / 5);
				_endY = int(e.stageY / 5);
				if (_astar.map[_endY << FastAstar.D1 | _endX].block == _astar.mapVersion) return;
				graphics.beginFill(0xFFFF0000);
				graphics.drawCircle(_endX * 5 + 2.5, _endY * 5 + 2.5, 2.5);
				graphics.endFill();
				
				var ttt:int = getTimer();
				_astar.search(_startX, _startY, _endX, _endY);
				var l:int = _astar.path.length;
				_text.htmlText = "耗时：" + (getTimer() - ttt) + "ms    " + "长度：" + l + "步    " + _button;
				
				var t:Node = _astar.path[0];
				var i:int;
				graphics.lineStyle(1, 0x0000FF);
				for (i = 1; i < l; i++)
				{
					graphics.moveTo(t.x * 5 + 2.5, t.y * 5 + 2.5);
					t = _astar.path[i];
					graphics.lineTo(t.x * 5 + 2.5, t.y * 5 + 2.5);
				}
				_step = 0;
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			}
		}
		
		private function onMove(e:MouseEvent):void
		{
			if (e.stageX < 0 || e.stageX >= 640) return;
			if (e.stageY < 0 || e.stageY >= 640) return;
			
			var graphics:Graphics = _scene.graphics;
			_endX = int(e.stageX / 5);
			_endY = int(e.stageY / 5);
			if (_astar.map[_endY << FastAstar.D1 | _endX].block == _astar.mapVersion) return;
			graphics.clear();
			graphics.beginFill(0xFFFF0000);
			graphics.drawCircle(_startX * 5 + 2.5, _startY * 5 + 2.5, 2.5);
			graphics.drawCircle(_endX * 5 + 2.5, _endY * 5 + 2.5, 2.5);
			graphics.endFill();
			var ttt:int = getTimer();
			_astar.search(_startX, _startY, _endX, _endY);
			var l:int = _astar.path.length;
			_text.htmlText = "耗时：" + (getTimer() - ttt) + "ms    " + "长度：" + l + "步    " + _button;
			var t:Node = _astar.path[0];
			var i:int;
			graphics.lineStyle(1, 0x0000FF);
			for (i = 1; i < l; i++)
			{
				graphics.moveTo(t.x * 5 + 2.5, t.y * 5 + 2.5);
				t = _astar.path[i];
				graphics.lineTo(t.x * 5 + 2.5, t.y * 5 + 2.5);
			}
			/*graphics.beginFill(0xFFFFFF, 0.5);
			graphics.lineStyle();
			l = _astar.tests.length;
			for (i = 0; i < l; i++)
			{
				t = _astar.tests[i];
				graphics.drawRect(t.x * 5, t.y * 5, 5, 5);
			}
			graphics.endFill();*/
		}
		
		private function onUp(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}
	}
	
}