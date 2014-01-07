package harayoki.starling.feathers
{
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
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
		protected var _scale:Number = 1.0;
		
		public var hScrollBarThumbSkinTexture:Scale3Textures;
		public var hScrollBarThumbSkinColor:uint = 0xffffff;
		
		public var vScrollBarThumbSkinTexture:Scale3Textures;
		public var vScrollBarThumbSkinColor:uint = 0xffffff;
		
		public var textFormat:TextFormat = null;
		public var bitmapFontTextFormat:BitmapFontTextFormat = null;
		
		public var listItemHeight:int = 80;
		
		public var defaultBackgroundTexture:Texture;
		
		public var backgroundSelecter:Function;
		
		public function FlexibleTextureListFactory(scale:Number=1.0)
		{
			_scale = scale;
		}
		
		public function dispose():void
		{
			backgroundSelecter = null;
			defaultBackgroundTexture = null;
			textFormat = null;
			bitmapFontTextFormat = null;
			hScrollBarThumbSkinTexture = null;
			vScrollBarThumbSkinTexture = null;
		}
		
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
				var renderer:FlexibleTextureListItemRenderer;
				renderer = new FlexibleTextureListItemRenderer();
				renderer.paddingTop = 0 * _scale
				renderer.paddingRight = 32 * _scale
				renderer.paddingBottom = 0 * _scale;
				renderer.paddingLeft = 44 * _scale;
				renderer.backgroundSelecter = backgroundSelecter;
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
			backgroundSelecter = function(list:List,data:Object):DisplayObject{
				var flexList:FlexibleTextureList = FlexibleTextureList(list);
				var img:Image = flexList._autoCreatedImages[data];
				var texture:Texture;
				if(img) return img;
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
				//trace(data["label"],img);
				return img;
			}
		}
		
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
		
		protected function getColorQuad(color:uint=0xffffff):Quad
		{
			return new Quad(32,32,color);
		}
	}
}
import flash.utils.Dictionary;

import feathers.controls.List;

import starling.display.Image;

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
