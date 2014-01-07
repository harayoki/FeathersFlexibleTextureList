package
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import feathers.controls.List;
	import feathers.data.ListCollection;
	import feathers.text.BitmapFontTextFormat;
	
	import harayoki.starling.feathers.FlexibleTextureListFactory;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	/**
	 * リスト動作サンプル メイン
	 * _startメソッド内がサンプルとして主となる箇所
	 * @author haruyuki.imai
	 */
	public class TestSprite extends Sprite
	{
		private static const CONTENTS_WIDTH:int = 480;
		private static const CONTENTS_HEIGHT:int = 640;
		private static var _starling:Starling;
		private static var _flashStage:Stage;
		
		private var _assetManager:AssetManager;
		
		private const CONTENT:Array = [
		   	 { label: "ドラえもん"		}
			,{ label: "パーマン"     	}
			,{ label: "オバケのQ太郎" 	}
			,{ label: "(新)オバケのQ太郎" }
			,{ label: "怪物君", texture:"bg_b_320x64"}
			,{ label: "忍者ハットリ君", texture:"bg_b_320x64"}
			,{ label: "キテレツ大百科"}
			,{ label: "プロゴルファー猿", texture:"bg_b_320x64"}
			,{ label: "エスパー魔美"}
			,{ label: "チンプイ"}
			,{ label: "21エモン"}
		];
		
		/**
		 * ここから動作スタート
		 */
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
			var list:List;
			
			//factory経由でリストを手に入れます
			var factory:FlexibleTextureListFactory = new FlexibleTextureListFactory();
			
			//フォルトの背景テクスチャを設定 テクスチャ指定は全ての行をdataProvider経由で行っても良い
			factory.defaultBackgroundTexture = _assetManager.getTexture("bg_a_320x64");
			
			//(任意の処理) テキストフォーマットを指定
			factory.textFormat = new TextFormat("_sans",24,0x331111,true);
			
			//(任意の処理) BitmapFontの使用も可能
			//factory.bitmapFontTextFormat = new BitmapFontTextFormat(....
			
			//縦横のスクロールバーをいい感じに指定(テクスチャアトラス名とサイズは決めうちされてます)
			factory.useDefaultScrollbarAssets(_assetManager);
			
			//自前でスクロールバー指定する場合の例
			//factory.vScrollBarThumbSkinTexture = new Scale3Textures(....
			
			//背景をいい感じに管理してくれるようにする
			//この仕組みを使った場合、デフォルトのテクスチャ以外は、dataProvider経由(CONTENT)内で行なう
			factory.useDefaultBackgroundDisplayObjectSelecter(_assetManager);
			
			//(任意の処理) 選択アイテムのカラー 通常カラーやタッチ時のカラー指定も可能
			factory.selectColor = 0xffcccc;
			
			//ここで実際にリストを作成
			list = factory.createSimpleList();
			
			////////// ここから先は通常のリストの扱いと同じ //////////
			
			list.width  = 460;
			list.height = 620;
			list.x      = 10;
			list.y      = 10;
			
			//(任意の処理) labelFieldの指定例
			//list.itemRendererProperties.labelField = "label";
			
			//(任意の処理) labelFunctionの指定例
			//list.itemRendererProperties.labelFunction = function(data:Object):String
			//{
			//	return data.label + " 大好き!";
			//}
			
			//※itemRendererPropertiesの対応は現在この２つ(labelFieldとlabelFunction)のみになっています
			//factoryに設定している各プロパティも、itemRendererPropertiesで設定できるようにするかもしれませんし
			//いくつかは設定可能ですが、とりあえず使用しないでください
			
			/* 公式wiki引用 データの受け渡し方はCustom item renderers作者の自由 
			Custom item renderers may not have the same labelField, iconSourceField, or other similar properties that the default item renderer offers.
			If you are creating a custom item renderer, you can design it to interpret an item's data any way that you prefer.
			If you're using a custom item renderer created by someone else, check its documentation for complete details about how your data provider should be structured.
			*/
				
			list.dataProvider = new ListCollection(CONTENT);
			addChild(list);
			
			list.addEventListener(Event.CHANGE, handleChangeListItem);		
			
			//// test用
			//flash.utils.setTimeout(function():void{
			//	list.removeFromParent();
			//	list.dispose();			
			//},3000);
						
			function handleChangeListItem(event:Event):void {
				var list:List = List(event.currentTarget);
				var item:Object = list.selectedItem;
				trace("selected:",item.label);
			}
			
		}
	}
}