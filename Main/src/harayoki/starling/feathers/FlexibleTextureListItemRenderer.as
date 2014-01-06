package harayoki.starling.feathers
{
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class FlexibleTextureListItemRenderer extends FeathersControl implements IListItemRenderer
	{
		public static const CHILD_NAME_FLEXIBLE_TEXTURE_LIST:String = "flexibleTextureList";
		
		public var normalIconTexture:Texture;
		public var selectedIconTexture:Texture;
		
		public function FlexibleTextureListItemRenderer()
		{
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
			_owner = value;
			invalidate(INVALIDATION_FLAG_DATA);
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
		
		protected var background:Quad;
		protected var label:Label;
		
		override protected function initialize():void
		{
			background = new Quad(100, 100, 0xffffff);
			background.alpha = 1.0;
			addChild(this.background);
			
			label = new Label();
			label.textRendererFactory = function():ITextRenderer
			{
				return new TextFieldTextRenderer();
			}
			label.textRendererProperties.textFormat = new TextFormat("_sans",24,0x111111);
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
			if(this._owner)
			{
				label.text = data.label;
				trace(label.text);
				//this.icon.source = _isSelected ? this._firstSelectedIconTexture : this._firstNormalIconTexture;
				background.color = _index % 2 == 0 ? 0xffcccc : 0xccffcc;
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
			
			if(_isSelected)
			{
				label.x = leftMarginWidth;
			}
			else
			{
				label.x = leftMarginWidth + (availableLabelWidth - label.width) / 2;
			}
			label.y = (availableLabelHeight - this.label.height) / 2;
		}
		
	}
}