package harayoki.starling.feathers
{
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.BitmapFontTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class FlexibleTextureListItemRenderer extends FeathersControl implements IListItemRenderer
	{
		protected static var DEFAULT_TEXTURE:Texture;//ここでnewするとStage3Dが準備できていないのでエラーになります
		protected static const DEFAULT_TEXT_FORMAT:TextFormat = new TextFormat("_sans",24,0x111111);
		private static const HELPER_POINT:Point = new Point();
		private static const HELPER_TOUCHES_VECTOR:Vector.<Touch> = new <Touch>[];
		
		protected var _touchPointID:int = -1;
		protected var _info:FlexibleTextureListItemInfo;
		
		public var backgroundSelecter:Function;
		
		public var useBitmapFont:Boolean = false;
		public var textFormat:TextFormat;
		public var bitmapTextFormat:BitmapFontTextFormat;
		public var cneterizeLabel:Boolean = false;
		
		public function FlexibleTextureListItemRenderer()
		{
			//このインスタンスはリストのアイテム数分だけ作成されます
			if(!DEFAULT_TEXTURE)
			{
				DEFAULT_TEXTURE = Texture.fromColor(32,32,0xff555555);
			}
			_info = new FlexibleTextureListItemInfo();
			addEventListener(TouchEvent.TOUCH, touchHandler);			
		}
		
		public override function dispose():void
		{
			//list.dispose()時に呼ばれます
			removeEventListener(TouchEvent.TOUCH, touchHandler);			
			_data = null;
			backgroundSelecter = null;
			textFormat = null;
			bitmapTextFormat = null;
			if(_owner)
			{
				_owner.removeEventListener(Event.SCROLL, owner_scrollHandler);
			}
			_owner = null;
			_info = null;
			super.dispose();
		}
		
		protected var _data:Object;	
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if(_data == value)
			{
				return;
			}
			_data = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		//////////
		
		protected var _index:int = -1;
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		//////////
		
		protected var _owner:List;
		
		public function get owner():List
		{
			return _owner;
		}
		
		public function set owner(value:List):void
		{
			if(_owner == value)
			{
				return;
			}
			if(_owner)
			{
				_owner.removeEventListener(Event.SCROLL, owner_scrollHandler);
			}
			_owner = value;
			if(_owner)
			{
				_owner.addEventListener(Event.SCROLL, owner_scrollHandler);
			}			
			_owner = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected function touchHandler(event:TouchEvent):void
		{
			var isInBounds:Boolean;
			
			if(!this._isEnabled)
			{
				return;
			}
			
			const touches:Vector.<Touch> = event.getTouches(this, null, HELPER_TOUCHES_VECTOR);
			if(touches.length == 0)
			{
				return;
			}
			if(this._touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this._touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				
				if(!touch)
				{
					HELPER_TOUCHES_VECTOR.length = 0;
					return;
				}
				
				if(touch.phase == TouchPhase.ENDED)
				{
					this._touchPointID = -1;
					this.isTouching = false;
					touch.getLocation(this, HELPER_POINT);
					isInBounds = this.hitTest(HELPER_POINT, true) != null;
					if(isInBounds)
					{
						if(!this._isSelected)
						{
							this.isSelected = true;
						}
					}
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						this._touchPointID = touch.id;
						touch.getLocation(this, HELPER_POINT);
						isInBounds = this.hitTest(HELPER_POINT, true) != null;
						if(isInBounds)
						{
							this.isTouching = true;
						}
						break;
					}
				}
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}		
		
		protected function owner_scrollHandler(event:Event):void
		{
			this._touchPointID = -1;
			this.isTouching = false;
		}
		
		//////////

		protected var _isSelected:Boolean = false;
		
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if(_isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}
		
		//////////
		
		protected var _isTouching:Boolean = false;
		
		public function get isTouching():Boolean
		{
			return _isTouching;
		}
		
		public function set isTouching(value:Boolean):void
		{
			if(_isTouching == value)
			{
				return;
			}
			this._isTouching = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}
		
		//////////

		protected var _paddingTop:Number = 0;
		
		public function get paddingTop():Number
		{
			return this._paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
			{
				return;
			}
			this._paddingTop = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		//////////

		protected var _paddingRight:Number = 0;
		
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		//////////

		protected var _paddingBottom:Number = 0;
		
		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
			{
				return;
			}
			this._paddingBottom = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		//////////

		protected var _paddingLeft:Number = 0;
		
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		//////////

		protected var _gap:Number = 0;
		
		public function get gap():Number
		{
			return this._gap;
		}
		
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		//////////
		
		protected var background:DisplayObject;
		protected var label:Label;
		
		override protected function initialize():void
		{
			var textFormat:TextFormat = this.textFormat ? this.textFormat : DEFAULT_TEXT_FORMAT;
						
			label = new Label();
			label.textRendererFactory = function():ITextRenderer
			{
				if(useBitmapFont)
				{
					return new BitmapFontTextRenderer();
				}
				else
				{
					return new TextFieldTextRenderer();
				}
			}
			label.textRendererProperties.textFormat = useBitmapFont ? bitmapTextFormat : textFormat;
			addChild(label);
			
		}
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
						
			if(dataInvalid || selectionInvalid || stylesInvalid)
			{
				commitData();
			}
			
			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(dataInvalid || sizeInvalid || selectionInvalid)
			{
				layout();
			}
		}
		
		protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = this._paddingLeft + this._paddingRight;
			}
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = this._paddingTop + this._paddingBottom;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		protected function commitData():void
		{
			if(_owner)
			{
				label.text = data.label;
				
				var index:int = _owner.dataProvider.getItemIndex(data);
				var newBackground:DisplayObject;
				if(backgroundSelecter != null)
				{
					_info.touching = _isTouching;
					_info.selected = _isSelected;
					newBackground = backgroundSelecter.apply(null,[_owner,data,_info]);
				}
				if(background == null && newBackground == null)
				{
					newBackground = new Image(DEFAULT_TEXTURE);
				}
				if(newBackground && newBackground != background)
				{
					if(background)
					{
						addChildAt(newBackground,getChildIndex(background));
						background.removeFromParent();
						background = newBackground
					}
					else
					{
						addChildAt(newBackground,0);
						background = newBackground;
					}
				}
				
			}
			else
			{
				label.text = null;
			}
		}
		
		protected function layout():void
		{
			this.background.width = this.actualWidth;
			this.background.height = this.actualHeight;
			
			const leftMarginWidth:Number = this._paddingLeft + this._gap;
			const availableLabelWidth:Number = this.actualWidth - this._paddingRight - leftMarginWidth;
			const availableLabelHeight:Number = this.actualHeight - this._paddingTop - this._paddingBottom;
			
			label.validate();
			
			if(cneterizeLabel)
			{
				label.x = leftMarginWidth + (availableLabelWidth - label.width) / 2;
			}
			else
			{
				label.x = leftMarginWidth;
			}
			label.y = (availableLabelHeight - this.label.height) / 2;
		}
		
	}
}