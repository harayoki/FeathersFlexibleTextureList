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

	public class FlexibleTextureListFactory
	{
		//protected static const DEFAULT_TEXT_FORMAT:TextFormat = new TextFormat("_sans", 24, 0x333333);
		protected var scale:Number = 1.0;
		
		//Scale3Image or DisplayObject
		public var hScrollBarThumbSkinTexture:Object;
		public var hScrollBarThumbSkinColor:uint = 0xffffff;
		
		//Scale3Image or DisplayObject
		public var vScrollBarThumbSkinTexture:Object;
		public var vScrollBarThumbSkinColor:uint = 0xffffff;
		
		public var textFormat:TextFormat = null;
		public var bitmapFontTextFormat:BitmapFontTextFormat = null;
		
		public var listItemHeight:int = 80;
		
		public var defaultTexture:Texture;
		
		public var textureSelecter:Function;
		
		public function FlexibleTextureListFactory(scale:Number=1.0)
		{
			this.scale = scale;
		}
		
		public function createSimpleList():List
		{
			
			var list:List = new List();
			list.horizontalScrollBarFactory = horizontalScrollBarFactory;
			list.verticalScrollBarFactory = verticalScrollBarFactory;			
						
			list.itemRendererFactory = function():IListItemRenderer {
				var renderer:FlexibleTextureListItemRenderer = new FlexibleTextureListItemRenderer();
				renderer.paddingTop = 0 * scale
				renderer.paddingRight = 32 * scale
				renderer.paddingBottom = 0 * scale;
				renderer.paddingLeft = 44 * scale;
				renderer.textureSelecter = textureSelecter;
				renderer.height = listItemHeight;
				renderer.defaultTexture = defaultTexture;
				
				if(bitmapFontTextFormat)
				{
					renderer.useBitmapFont = true;
					renderer.bitmapTextFormat = bitmapFontTextFormat;
				}
				else
				{
					renderer.useBitmapFont = false;
					renderer.textFormat = textFormat;//nullでもOK
				}
				
				return renderer;
			};
			
			return list;
		}
		
		public function applyVscrollbarByAssetManager(assetmanager:AssetManager,textureName:String="vscrollbar",region1:int=8,region2:int=8):void
		{
			vScrollBarThumbSkinTexture = new Scale3Textures(assetmanager.getTexture(textureName),region1,region2,Scale3Textures.DIRECTION_VERTICAL);
		}
		
		public function applyHscrollbarByAssetManager(assetmanager:AssetManager,textureName:String="hscrollbar",region1:int=8,region2:int=8):void
		{
			hScrollBarThumbSkinTexture = new Scale3Textures(assetmanager.getTexture(textureName),region1,region2,Scale3Textures.DIRECTION_HORIZONTAL);
		}
		
		public function setTextureSelecterByAssetManager(_assetManager:AssetManager,dataName:String="texture"):void
		{
			textureSelecter = function(data:Object):Texture{
				var textureName:String = data[dataName];
				if(!textureName) return null;
				return _assetManager.getTexture(textureName);
			}
		}
		
		protected function horizontalScrollBarFactory():SimpleScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			var defaultSkin:DisplayObject;
			if(hScrollBarThumbSkinTexture is Scale3Textures)
			{
				defaultSkin = new Scale3Image(Scale3Textures(hScrollBarThumbSkinTexture), scale);
			}
			else if(hScrollBarThumbSkinTexture is Texture)
			{
				defaultSkin = new Image(Texture(hScrollBarThumbSkinTexture));
			}
			else
			{
				defaultSkin = getColorQuad();
				defaultSkin.height = 10 * scale;
			}
			if(defaultSkin.hasOwnProperty("color"))
			{
				defaultSkin["color"] = hScrollBarThumbSkinColor;
			}

			defaultSkin.width = 10 * scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingRight = scrollBar.paddingBottom = scrollBar.paddingLeft = 4 * scale;
			return scrollBar;
		}
		
		protected function verticalScrollBarFactory():SimpleScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_VERTICAL;
			var defaultSkin:DisplayObject;
			if(vScrollBarThumbSkinTexture is Scale3Textures)
			{
				defaultSkin = new Scale3Image(Scale3Textures(vScrollBarThumbSkinTexture), scale);
			}
			else if(vScrollBarThumbSkinTexture is Texture)
			{
				defaultSkin = new Image(Texture(vScrollBarThumbSkinTexture));
			}
			else
			{
				defaultSkin = getColorQuad();
				defaultSkin.width = 10 * scale;
			}
			if(defaultSkin.hasOwnProperty("color"))
			{
				defaultSkin["color"] = vScrollBarThumbSkinColor;
			}
			
			defaultSkin.height = 10 * scale;
			scrollBar.thumbProperties.defaultSkin = defaultSkin;
			scrollBar.paddingTop = scrollBar.paddingRight = scrollBar.paddingBottom = 4 * scale;
			return scrollBar;
		}
		
		protected function getColorQuad(color:uint=0xffffff):Quad
		{
			return new Quad(32,32,color);
		}
	}
}
