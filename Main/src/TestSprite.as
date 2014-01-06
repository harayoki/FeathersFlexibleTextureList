package
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	
	import harayoki.starling.feathers.FlexibleTextureListFactory;
	
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
		
		private const CONTENT:Array = [
		   	 { label: "ドラえもん",		data: null }
			,{ label: "パーマン",     	data: null }
			,{ label: "オバケのQ太郎", 	data: null }
			,{ label: "怪物君",       	data: null }
			,{ label: "忍者ハットリ君", 	data: null }
			,{ label: "キテレツ大百科", 	data: null }
			,{ label: "プロゴルファー猿",	data: null }
			,{ label: "エスパー魔美",  	data: null }
			,{ label: "チンプイ",   		data: null }
		];
		
		public static function main(stage:Stage):void
		{
			_flashStage = stage;
			
			_flashStage.align = StageAlign.TOP_LEFT;
			_flashStage.scaleMode = StageScaleMode.NO_SCALE;
			Starling.handleLostContext = true;
			
			_starling = new Starling(TestSprite,_flashStage,new Rectangle(0,0,CONTENTS_WIDTH,CONTENTS_HEIGHT));
			_starling.showStats = true;
			_starling.showStatsAt("right","top",2);				
		}
		
		public function TestSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE,_handleAddedToStage);
		}
		
		private function _handleAddedToStage():void
		{
			stage.color = _flashStage.color;
			stage.alpha = 0.999999;
			stage.addEventListener(Event.RESIZE,_handleStageResize);
			_starling.start();		
			
			
			var list:List = new FlexibleTextureListFactory().createBasic();
			list.width  = 320;
			list.height = 480;
			list.x      = 10;
			list.y      = 10;
			list.dataProvider = new ListCollection(CONTENT);
			addChild(list);
			
			list.addEventListener(Event.CHANGE, _handleChangeListItem);
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
		
		private function _handleChangeListItem(event:Event):void {
			
			var list:List = List(event.currentTarget);
			var item:Object = list.selectedItem;
			trace(item.label,item.data);
		}
	}
}