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

	public class FlexibleTextureListFactory
	{
		//protected static const DEFAULT_TEXT_FORMAT:TextFormat = new TextFormat("_sans", 24, 0x333333);
		protected var scale:Number = 1.0;
		
		//Scale3Image or DisplayObject
		public var horizontalScrollBarThumbSkinTexture:Object;
		public var horizontalScrollBarThumbSkinColor:uint = 0xffffff;
		
		//Scale3Image or DisplayObject
		public var verticalScrollBarThumbSkinTexture:Object;
		public var verticalScrollBarThumbSkinColor:uint = 0xffffff;
		
		public var textFormat:TextFormat = null;
		public var bitmapFontTextFormat:BitmapFontTextFormat = null;
		
		public var listItemHeight:int = 75;
		
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
		
		protected function horizontalScrollBarFactory():SimpleScrollBar
		{
			const scrollBar:SimpleScrollBar = new SimpleScrollBar();
			scrollBar.direction = SimpleScrollBar.DIRECTION_HORIZONTAL;
			var defaultSkin:DisplayObject;
			if(horizontalScrollBarThumbSkinTexture is Scale3Textures)
			{
				defaultSkin = new Scale3Image(Scale3Textures(horizontalScrollBarThumbSkinTexture), scale);
			}
			else if(horizontalScrollBarThumbSkinTexture is Texture)
			{
				defaultSkin = new Image(Texture(horizontalScrollBarThumbSkinTexture));
			}
			else
			{
				defaultSkin = getColorQuad();
				defaultSkin.height = 10 * scale;
			}
			if(defaultSkin.hasOwnProperty("color"))
			{
				defaultSkin["color"] = horizontalScrollBarThumbSkinColor;
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
			if(verticalScrollBarThumbSkinTexture is Scale3Textures)
			{
				defaultSkin = new Scale3Image(Scale3Textures(verticalScrollBarThumbSkinTexture), scale);
			}
			else if(verticalScrollBarThumbSkinTexture is Texture)
			{
				defaultSkin = new Image(Texture(verticalScrollBarThumbSkinTexture));
			}
			else
			{
				defaultSkin = getColorQuad();
				defaultSkin.width = 10 * scale;
			}
			if(defaultSkin.hasOwnProperty("color"))
			{
				defaultSkin["color"] = verticalScrollBarThumbSkinColor;
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
