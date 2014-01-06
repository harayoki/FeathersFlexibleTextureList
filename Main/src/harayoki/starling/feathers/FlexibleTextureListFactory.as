package harayoki.starling.feathers
{
	import feathers.controls.List;
	import feathers.controls.SimpleScrollBar;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.textures.Texture;

	public class FlexibleTextureListFactory
	{
		//protected static const DEFAULT_TEXT_FORMAT:TextFormat = new TextFormat("_sans", 24, 0x333333);
		protected var scale:Number = 1.0;
		
		public var normalIconTexture:Texture;
		public var selectedIconTexture:Texture;
		
		//Scale3Image or DisplayObject or color(uint);
		public var horizontalScrollBarThumbSkinTexture:Object;
		
		//Scale3Image or DisplayObject or color(uint);
		public var verticalScrollBarThumbSkinTexture:Object;
		
		public function FlexibleTextureListFactory(scale:Number=1.0)
		{
			this.scale = scale;
			//defaultTextFormat = DEFAULT_TEXT_FORMAT;
		}
		
		public function createSimpleList():List
		{
					
			var list:List = new List();
			list.nameList.add(FlexibleTextureListItemRenderer.CHILD_NAME_FLEXIBLE_TEXTURE_LIST);
			list.horizontalScrollBarFactory = horizontalScrollBarFactory;
			list.verticalScrollBarFactory = verticalScrollBarFactory;			
						
			list.itemRendererFactory = function():IListItemRenderer {
				var renderer:FlexibleTextureListItemRenderer = new FlexibleTextureListItemRenderer();
				renderer.paddingTop = 0 * scale
				renderer.paddingRight = 32 * scale
				renderer.paddingBottom = 0 * scale;
				renderer.paddingLeft = 44 * scale;
				renderer.normalIconTexture = normalIconTexture;
				renderer.selectedIconTexture = selectedIconTexture;
				renderer.height = 75;
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
				defaultSkin = getColorQuad(horizontalScrollBarThumbSkinTexture is uint ? verticalScrollBarThumbSkinTexture as uint : 0xffffff);
				defaultSkin.height = 10 * scale;
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
				defaultSkin = getColorQuad(verticalScrollBarThumbSkinTexture is uint ? verticalScrollBarThumbSkinTexture as uint : 0xffffff);
				defaultSkin.width = 10 * scale;
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
