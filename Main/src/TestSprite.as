package
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class TestSprite extends Sprite
	{
		private static const CONTENTS_WIDTH:int = 480;
		private static const CONTENTS_HEIGHT:int = 640;
		private static var _starling:Starling;
		private static var _flashStage:Stage;
		
		public static function main(stage:Stage):void
		{
			_flashStage = stage;
			
			_flashStage.align = StageAlign.TOP_LEFT;
			_flashStage.scaleMode = StageScaleMode.NO_SCALE;
			Starling.handleLostContext = true;
			
			_starling = new Starling(TestSprite,_flashStage,new Rectangle(0,0,CONTENTS_WIDTH,CONTENTS_HEIGHT));
			_starling.showStats = true;
			_starling.showStatsAt("left","top",2);				
		}
		
		public function TestSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE,_handleAddedToStage);
		}
		
		private function _handleAddedToStage():void
		{
			stage.addEventListener(Event.RESIZE,_handleStageResize);
			_starling.start();			
		}
		
		private function _handleStageResize(ev:Event):void
		{
			var w:int = _flashStage.stageWidth;
			var h:int = _flashStage.stageHeight
			_starling.viewPort = RectangleUtil.fit(
				new Rectangle(0, 0, CONTENTS_WIDTH, CONTENTS_HEIGHT),
				new Rectangle(0, 0, w,h),
				ScaleMode.SHOW_ALL);			
		}
		
	}
}