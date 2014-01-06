package
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.IScrollBar;
	import feathers.controls.List;
	import feathers.controls.ScrollBar;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	
	import starling.core.Starling;
	import starling.display.Quad;
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
			{ label: "ドラえもん", data: null }
			,{ label: "パーマン",           data: null }
			,{ label: "オバケのQ太郎",     data: null }
			,{ label: "怪物君",         data: null }
			,{ label: "忍者ハットリ君",   data: null }
			,{ label: "キテレツ大百科",   data: null }
			,{ label: "プロゴルファー猿",   data: null }
			,{ label: "エスパー魔美",   data: null }
			,{ label: "チンプイ",   data: null }
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
			stage.addEventListener(Event.RESIZE,_handleStageResize);
			_starling.start();		
			
			
			var list:List = _createList();
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
			trace(item);
		}
		
		private function _createList():List
		{
		
			var list:List = new List();
			list.width  = 320;
			list.height = 480;
			list.x      = 10;
			list.y      = 10;
			
			list.backgroundSkin = new Quad(100,100,0xff0000);
		
			list.itemRendererFactory = function():IListItemRenderer {
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.defaultSkin         =  _getColorQuad(0x00ffff);
				renderer.downSkin            = _getColorQuad(0x9999aa);
				renderer.defaultSelectedSkin = _getColorQuad(0xccaa55);
				
				renderer.height = 75;
				
				//----- If use bitmap font
				// renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(
				//     "tk_cooper", 24, 0xeeeecc, "center"
				// );
				
				renderer.labelFactory = function():ITextRenderer {
					return new TextFieldTextRenderer();
				};
				renderer.defaultLabelProperties.textFormat = new TextFormat(
					"_sans", 24, 0x4a3816
				);
				
				renderer.labelField = "label";
				renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_CENTER;
				renderer.verticalAlign   = Button.VERTICAL_ALIGN_MIDDLE;
				renderer.padding = 14;
				
				// enable the quick hit area to optimize hit tests when an item
				// is only selectable and doesn't have interactive children.
				renderer.isQuickHitAreaEnabled = true;
				return renderer;
			};
			
			// scroll bar
			list.verticalScrollBarFactory = function():IScrollBar {
				var scrollBar:ScrollBar = new ScrollBar();
				scrollBar.thumbProperties.defaultSkin = _getColorQuad(0x00ff00);
				scrollBar.thumbProperties.width = 6;
				scrollBar.direction = ScrollBar.DIRECTION_VERTICAL;
				return scrollBar;
			};
		
			return list;
		}
		
		private function _getColorQuad(color:uint):Quad
		{
			return new Quad(100,100,color);
		}
	}
}