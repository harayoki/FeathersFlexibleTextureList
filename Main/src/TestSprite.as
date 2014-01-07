package
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.textures.Scale3Textures;
	
	import harayoki.starling.feathers.FlexibleTextureListFactory;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class TestSprite extends Sprite
	{
		private static const CONTENTS_WIDTH:int = 480;
		private static const CONTENTS_HEIGHT:int = 640;
		private static var _starling:Starling;
		private static var _flashStage:Stage;
		
		private var _assetManager:AssetManager;
		
		private const CONTENT:Array = [
		   	 { label: "ドラえもん",		data: null ,texture:0}
			,{ label: "パーマン",     	data: null ,texture:1}
			,{ label: "オバケのQ太郎", 	data: null ,texture:0}
			,{ label: "(新)オバケのQ太郎", data: null ,texture:1}
			,{ label: "怪物君",       	data: null ,texture:0}
			,{ label: "忍者ハットリ君", 	data: null ,texture:1}
			,{ label: "キテレツ大百科", 	data: null ,texture:0}
			,{ label: "プロゴルファー猿",	data: null ,texture:1}
			,{ label: "エスパー魔美",  	data: null ,texture:0}
			,{ label: "チンプイ",   		data: null ,texture:1}
			,{ label: "21エモン",   		data: null ,texture:0}
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
			
			_loadAssets();
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
		
		private function _loadAssets():void
		{
			_assetManager = new AssetManager();
			_assetManager.verbose = true;
			_assetManager.enqueue("textures.png");
			_assetManager.enqueue("textures.xml");
			_assetManager.loadQueue(function(num:Number):void{
				if(num==1.0)
				{
					_start();
				}
			});
		}
		private function _start():void
		{
			const bgTextures:Array = [_assetManager.getTexture("bg_a_320x64"),_assetManager.getTexture("bg_b_320x64")];

			var factory:FlexibleTextureListFactory = new FlexibleTextureListFactory();
			factory.textFormat = new TextFormat("_sans",24,0x331111,true);
			factory.textureSelecter = function(data:Object):Texture{
				return bgTextures[data.texture];
			}
			factory.listItemHeight = 80;
			factory.applyVscrollbarByAssetManager(_assetManager);
			factory.applyHscrollbarByAssetManager(_assetManager);
			
			var list:List = factory.createSimpleList();
			list.width  = 460;
			list.height = 620;
			list.x      = 10;
			list.y      = 10;
			list.dataProvider = new ListCollection(CONTENT);
			addChild(list);
			
			list.addEventListener(Event.CHANGE, _handleChangeListItem);			
		}
		
		private function _handleChangeListItem(event:Event):void {
			
			var list:List = List(event.currentTarget);
			var item:Object = list.selectedItem;
			trace(item.label,item.data);
		}
	}
}