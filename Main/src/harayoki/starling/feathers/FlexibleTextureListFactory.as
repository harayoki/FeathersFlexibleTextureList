package harayoki.starling.feathers
{
	import flash.text.TextFormat;
	
	import feathers.controls.List;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.display.Scale3Image;
	import feathers.text.BitmapFontTextFormat;
	import feathers.textures.Scale3Textures;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	/**
	 * 各アイテム(行)のテクスチャを柔軟に指定してリストを作成するクラス
	 * @author haruyuki.imai
	 * ※ StarlingのAssetManagerと組み合わせると楽に使う事ができます
	 */
	public class FlexibleTextureListFactory
	{
		protected var _scale:Number = 1.0;
		
		/**
		 * 横スクロールバーのテクスチャー
		 */
		public var hScrollBarThumbSkinTexture:Scale3Textures;
		
		/**
		 * 横スクロールバーのカラー
		 */
		public var hScrollBarThumbSkinColor:uint = 0xffffff;
		
		/**
		 * 縦スクロールバーのテクスチャー
		 */
		public var vScrollBarThumbSkinTexture:Scale3Textures;
		
		/**
		 * 縦スクロールバーのカラー
		 */
		public var vScrollBarThumbSkinColor:uint = 0xffffff;
		
		/**
		 * ラベルテキストのフォーマット 
		 */
		public var textFormat:TextFormat = null;
		
		/**
		 * ラベルテキストをセンタライズするか
		 */
		public var cneterizeLabel:Boolean;
		
		/**
		 * ビットマップテキストのフォーマット
		 * (こちらが設定してある場合、通常のテキストよりも優先されます)
		 */
		public var bitmapFontTextFormat:BitmapFontTextFormat = null;
		
		/**
		 * リスト内の各アイテムの高さ 
		 */
		public var listItemHeight:int = 80;
		
		/**
		 * デフォルトの背景テクスチャ 
		 */
		public var defaultBackgroundTexture:Texture;
		
		/**
		 * リスト内アイテムの色指定(通常)
		 */
		public var normalColor:uint = 0xffffff;
		
		/**
		 * リスト内アイテムの色指定(タッチ中)
		 */
		public var touchColor:uint = 0xcccccc;

		/**
		 * リスト内アイテムの色指定(選択中)
		 */
		public var selectColor:uint = 0xaaaaaa;
		
		/**
		 * リスト内アイテムの背景を自分でカスタマイズしたい場合に使う
		 * 引数でList、dataProviderで渡された元データの１項目(Object型)、アイテムの状態(FlexibleTextureListItemInfo型)が渡されます。
		 * @see useDefaultBackgroundDisplayObjectSelecter のコード
		 */
		public var backgroundDisplayObjectSelecter:Function;
		
		/**
		 * @param scale 表示倍率
		 */
		public function FlexibleTextureListFactory(scale:Number=1.0)
		{
			_scale = scale;
		}
		
		/**
		 * 廃棄処理 
		 * 通常呼ばなくてよいと思います
		 */
		public function dispose():void
		{
			backgroundDisplayObjectSelecter = null;
			defaultBackgroundTexture = null;
			textFormat = null;
			bitmapFontTextFormat = null;
			hScrollBarThumbSkinTexture = null;
			vScrollBarThumbSkinTexture = null;
		}
		
		/**
		 * リストを作成する
		 */
		public function createSimpleList():List
		{
			
			var list:List;
			
			var onDispose:Function = function():void
			{
			}
			
			list = new FlexibleTextureList(onDispose);
			list.horizontalScrollBarFactory = horizontalScrollBarFactory;
			list.verticalScrollBarFactory = verticalScrollBarFactory;			
			list.itemRendererFactory = function():IListItemRenderer {
				
				var renderer:FlexibleTextureListItemRenderer = new FlexibleTextureListItemRenderer();
				
				//padding系は決め打ちしてます
				renderer.paddingTop = 0 * _scale
				renderer.paddingRight = 32 * _scale
				renderer.paddingBottom = 0 * _scale;
				renderer.paddingLeft = 44 * _scale;
				
				renderer.backgroundDisplayObjectSelecter = backgroundDisplayObjectSelecter;
				renderer.height = listItemHeight;
				renderer.cneterizeLabel = cneterizeLabel;
				
				if(bitmapFontTextFormat)
				{
					renderer.useBitmapFont = true;
					renderer.bitmapTextFormat = bitmapFontTextFormat;
				}
				else
				{
					renderer.useBitmapFont = false;
					renderer.textFormat = textFormat;//nullでもOK その場合適当なデフォルト値使われます
				}
				
				return renderer;
			};
			
			return list;
		}
		
		/**
		 * assetmanagerを使って縦スクロールバーの初期化を行う
		 * @param assetmanager
		 * @param vScrollbarTextureName 任意のテクスチャ名(デフォルト:"vscrollbar")
		 * @param region1 scrollbarテクスチャの頭の伸び縮みしないテキスト数
		 * @param region2 scrollbarテクスチャのお尻の伸び縮みしないテキスト数
		 */
		public function applyVscrollbarByAssetManager(assetmanager:AssetManager,vScrollbarTextureName:String="vscrollbar",region1:int=8,region2:int=8):void
		{
			var texture:Texture = assetmanager.getTexture(vScrollbarTextureName);
			if(texture)
			{
				vScrollBarThumbSkinTexture = new Scale3Textures(texture,region1,region2,Scale3Textures.DIRECTION_VERTICAL);				
			}
		}
		
		/**
		 * assetmanagerを使って横スクロールバーの初期化を行う
		 * @param assetmanager
		 * @param hScrollbarTextureName 任意のテクスチャ名(デフォルト:"hscrollbar")
		 * @param region1 scrollbarテクスチャの左側の伸び縮みしないテキスト数
		 * @param region2 scrollbarテクスチャの右側の伸び縮みしないテキスト数
		 */
		public function applyHscrollbarByAssetManager(assetmanager:AssetManager,hScrollbarTextureName:String="hscrollbar",region1:int=8,region2:int=8):void
		{
			var texture:Texture = assetmanager.getTexture(hScrollbarTextureName);
			{
				hScrollBarThumbSkinTexture = new Scale3Textures(texture,region1,region2,Scale3Textures.DIRECTION_HORIZONTAL);
			}
		}
		
		/**
		 * デフォルトのスクロールバーアセット(Texture)を適用する
		 * 内部でapplyVscrollbarByAssetManagerとapplyHscrollbarByAssetManagerを呼び出します
		 * @see applyVscrollbarByAssetManager
		 * @see applyHscrollbarByAssetManager
		 * @param assetmanager
		 */
		public function useDefaultScrollbarAssets(assetmanager:AssetManager):void
		{
			applyVscrollbarByAssetManager(assetmanager);
			applyHscrollbarByAssetManager(assetmanager);
		}
		
		/**
		 * デフォルトのリスト背景設定機能を使う
		 * dataProviderのデータとして各リストアイテムの背景画像のテクスチャを決定します
		 * @param _assetManager
		 * @param dataName dataProviderで与えた各項目のデータオブジェクトでテクスチャ名として扱うパラメータ名
		 */
		public function useDefaultBackgroundDisplayObjectSelecter(_assetManager:AssetManager,dataName:String="texture"):void
		{
			/**
			 *  ※背景の描画ロジックをここで指定している
			 *  @param list リスト参照 (ここでは必用だが、外からbackgroundDisplayObjectSelecterを指定する場合は使わなそう)
			 *  @param data 各行のアイテムに対応するデータ(dataProviderとして与えたデータの一部部分)
			 *  @param info 各行の状態
			 *  @return 表示するDisplayObject
			 */
			backgroundDisplayObjectSelecter = function(list:List,data:Object,info:FlexibleTextureListItemInfo):DisplayObject
			{
				var flexList:FlexibleTextureList = FlexibleTextureList(list);
				var img:Image = flexList._autoCreatedImages[data];
				var texture:Texture;
				if(!img)
				{
					var textureName:String = data[dataName];
					if(textureName) 
					{
						texture = _assetManager.getTexture(textureName);					
					}
					else
					{
						texture = defaultBackgroundTexture;
					}
					if(!texture) return null;
					img = flexList._autoCreatedImages[data] = new Image(texture);
				}
				if(img)
				{
					if(info.touching)
					{
						img.color = touchColor;
					}
					else if(info.selected)
					{
						img.color = selectColor;
					}
					else
					{
						img.color = normalColor;
					}
				}
				//trace(data["label"],img);
				return img;
			}
		}
		
		//横スクロールバー設定用
		protected function horizontalScrollBarFactory():SimpleScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			var defaultSkin:DisplayObject;
			if(hScrollBarThumbSkinTexture)
			{
				defaultSkin = new Scale3Image(Scale3Textures(hScrollBarThumbSkinTexture), _scale);
			}
			else
			{
				defaultSkin = getColorQuad();
				defaultSkin.height = 10 * _scale;
			}
			if(defaultSkin.hasOwnProperty("color"))
			{
				defaultSkin["color"] = hScrollBarThumbSkinColor;
			}

			defaultSkin.width = 10 * _scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingRight = scrollBar.paddingBottom = scrollBar.paddingLeft = 4 * _scale;
			return scrollBar;
		}
		
		//縦スクロールバー設定用
		protected function verticalScrollBarFactory():SimpleScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
			var defaultSkin:DisplayObject;
			if(vScrollBarThumbSkinTexture)
			{
				defaultSkin = new Scale3Image(Scale3Textures(vScrollBarThumbSkinTexture), _scale);
			}
			else
			{
				defaultSkin = getColorQuad();
				defaultSkin.width = 10 * _scale;
			}
			if(defaultSkin.hasOwnProperty("color"))
			{
				defaultSkin["color"] = vScrollBarThumbSkinColor;
			}
			
			defaultSkin.height = 10 * _scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom = 4 * _scale;
			return scrollBar;
		}
		
		//カラーquad作成用便利関数
		protected function getColorQuad(color:uint=0xffffff):Quad
		{
			return new Quad(32,32,color);
		}
	}
}

import flash.utils.Dictionary;

import feathers.controls.List;

import starling.display.Image;

/**
 * FlexibleTextureListFactoryが作成するリスト 表向きは通常のListとして扱える
 */
internal class FlexibleTextureList extends List
{
	protected var _onDispose:Function;
	internal var _autoCreatedImages:Dictionary = new Dictionary();
	public function FlexibleTextureList(onDispose:Function)
	{
		_onDispose = onDispose;
		super();
	}
	
	public override function dispose():void
	{
		if(_autoCreatedImages)
		{
			for each(var img:Image in _autoCreatedImages)
			{
				img.dispose();
			}
		}
		_autoCreatedImages = null;
		_onDispose.apply(null);
		super.dispose();
	}
}
