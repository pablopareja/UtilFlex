package be.multimediacollege {
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	/**
	 * @author Steven Peeters
	 *         Adobe Flex Certified Instructor
	 *         steven@multimediacollege.be
	 * 
	 * This component creates a random captcha image which includes
	 * the possibility to control which type of characters are used
	 * and distorts the background using a gradient fill and some
	 * extra circles to make it harder on the OCR drones.
	 * 
	 * To verify the code provided by the user, call the verifyCode()
	 * method. In case of a mismatch, a new captcha image will be
	 * generated and will replace the old one for better security.
	 */
	public class CaptchaImage extends Canvas {
		
		// Constants to group characters
		private const LOWERCASE:String = "abcdefghijklmnopqrstuvwxyz";
		private const UPPERCASE:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		private const NUMBERS:String = "0123456789";
		
		// Constants to indicate which characters are allowed
		private const STYLE_NUMBERS_ONLY:String = "numbersOnly";
		private const STYLE_LOWER_ONLY:String = "lowercaseOnly";
		private const STYLE_UPPER_ONLY:String = "uppercaseOnly";
		private const STYLE_LOWER_ALPHANUM:String = "lowercaseAlphaNum";
		private const STYLE_UPPER_ALPHANUM:String = "uppercaseAlphaNum";
		private const STYLE_ALPHANUM:String = "alphaNum";
		
		// Embed the font so we can rotate it for further distortion
		/*[Embed(systemFont="Comic Sans MS",
               fontName="boldFont",
               fontWeight="bold",
               advancedAntiAliasing="true",
               mimeType="application/x-font")]*/
        private var font:Class;

		// Some additional parameters
		private var _style:String;
		private var _nrChars:uint;
		private var _noise:Array;
		private var allowedChars:String;
		private var imageHeight:uint;
		private var code:String;
		private var captchaCreated:Boolean = false;
		
		// The box containing the aptcha image
		private var box:Canvas = new Canvas();
		// The mask for the captcha image
		private var boxMask:UIComponent = new UIComponent();
		// The code input field
		private var input:TextInput = new TextInput();
		
		/**
		 * The constructor will initialise the component and set some
		 * defaults for further use later on.
		 */
		public function CaptchaImage(){
			super();
						
			// Set the default allowed characters
			style = STYLE_LOWER_ALPHANUM;
			nrChars = 8;
			_noise = [0xFF6633, 0xC0C0C0];
			imageHeight = 70;
			
			// When the component has been fully created, we draw it for the first time.
			addEventListener(FlexEvent.CREATION_COMPLETE, creationComplete);
		}
		
		/**
		 * This method is just a wrapper for the captcha generation function.
		 * the generate function cannot be called directly because we may have
		 * to do some extra work in his method when overriding the component.
		 */
		public function refreshCaptcha():void {
			generateCaptcha();
		}
		
		/**
		 * @return Boolean Whether or not the provided code is the same as the generated captcha
		 * 
		 * This method verifies the input code with the generated captcha
		 * and returns a Boolean value indicating the result.
		 */
		public function verifyCode():Boolean {
			if(input.text == code) {
				return true;
			} else {
				refreshCaptcha();
				input.setFocus();
				
				return false;
			}
		}
		
		/**
		 * @param event The event object that is dispatched by the framework
		 * 
		 * This method is executed when the component is fully initialised.
		 * This is the time to start doing our own drawing. 
		 */
		private function creationComplete(event:FlexEvent):void {
			captchaCreated = true;
			generateCaptcha();
			
			// Add the box container for the captcha image
			var child:DisplayObject = addChild(box);
			child.x = 0;
			child.y = 0;

			// Add the mask for the captcha image to the box container
			child = addChild(boxMask);
			child.x = 0;
			child.y = 0;
			box.mask = boxMask;
			
			// Create an input field to contain the code
			input.width = box.width;
			input.maxChars = _nrChars;
			input.restrict = allowedChars;
			child = addChild(input);
			child.x = 0;
			child.y = imageHeight + box.getStyle("verticalGap"); 
		}
		
		/**
		 * This method actually does the drawing of the captcha.
		 * I specifically chose not to override the updateDisplayList 
		 * method, because it is called too often, so the captcha
		 * would change itself when it's not requested. Instead, 
		 * I call the draw method myself, whenever it is necessary.
		 */
		protected function generateCaptcha():void {
			var child:DisplayObject;
			
			// Remove all previously generated characters from the component.
			box.removeAllChildren();

			// Since we removed all children, the text input field is also
			// removed. So we have to add the text input field again.Âµ
			input.text = null;

			// Define the mask for the captcha image to be equal to the
			// size of the background gradient. This is necessary to keep
			// the circles used as noise contained within the gradient area.
			boxMask.graphics.beginFill(0x000000);
			boxMask.graphics.drawRect(0, 0, box.width, imageHeight);
			boxMask.graphics.endFill();
			
			// Clear the previously drawn captcha.
			box.graphics.clear();
						
			// Create a vertical gradient backgound
			var myMatrix:Matrix = new Matrix();        
			myMatrix.createGradientBox(box.width, imageHeight, Math.PI/2); // Math.PI/2 = 90Â°
			box.graphics.beginGradientFill(GradientType.LINEAR, _noise, [1, 1], [0, 255], myMatrix);
			box.graphics.drawRect(0, 0, box.width, imageHeight);
			box.graphics.endFill();
				
			// Draw some random circles to distort the letters	
			var nrCircles:uint = (Math.random() * 100 % 10) + 10;
			for(var i:int = 0; i < nrCircles; i++) {
				box.graphics.lineStyle((i % 2) + 1, 0x333333);	
				box.graphics.drawCircle(Math.random() * 1000 % box.width, 
										Math.random() * 1000 % imageHeight, 
										Math.random() * 1000 % 20);
			}
			
			// Make different canvas containers that will hold exactly 1 character each.
			code = new String();
			var arr:Array = new Array();
			for(var y:int = 0; y < nrChars; y++) {
				var label:Label = new Label();
				label.setStyle("textAlign", "center");
				label.setStyle("fontSize", 30);
				label.setStyle("fontWeight", "bold");
				label.setStyle("color", 0x333333);
				label.setStyle("fontFamily", "boldFont");
				
				// Select a random character
				label.text = allowedChars.charAt(Math.round(Math.random() * (allowedChars.length - 1)));
				code += label.text;
				
				arr.push(label);
			}
			
			// Now we have nrChars containers, but they still need to be positioned
			// within the current container.
			child = box.addChild(arr[0]);
			child.x = 0;
			child.y = 20 - Math.round(Math.random() * 100 % 30);
			for(var z:int = 1; z < arr.length; z++) {
				child = box.addChild(arr[z]);
				child.x = arr[z-1].x + 20 + (Math.random() * 100 % 10);
				child.y = 20 - Math.round(Math.random() * 100 % 30);
				child.rotation = 15 - Math.round(Math.random() * 100 % 30);
			}
		}
		
		/**
		 * @param value The style of the allowed characters to set
		 * 
		 * This method allows the user to override the default character set
		 * that is used to generate te captcha code. Possible values are
		 * defined, so it's easier for the user to use the predefined values.
		 */
		[Inspectable(enumeration = "numbersOnly, lowercaseOnly, uppercaseOnly, lowercaseAlphaNum, uppercaseAlphaNum, alphaNum")]
		public function set style(value:String):void {
			_style = value;
			
			switch(value) {
				case STYLE_NUMBERS_ONLY:
						allowedChars = NUMBERS;
						break;
				case STYLE_UPPER_ONLY:
						allowedChars = UPPERCASE;
						break;
				case STYLE_LOWER_ONLY:
						allowedChars = LOWERCASE;
						break;
				case STYLE_ALPHANUM:
						allowedChars = UPPERCASE + LOWERCASE + NUMBERS;
						break;
				case STYLE_UPPER_ALPHANUM:
						allowedChars = UPPERCASE + NUMBERS;
						break;
				case STYLE_LOWER_ALPHANUM:
				default:
						allowedChars = LOWERCASE + NUMBERS;
						break;
			}
			
			// If the value was set after the captcha was generated,
			// re-generate the image and code.
			if(captchaCreated) {
				input.restrict = allowedChars;
				generateCaptcha();
			}
		}
		
		/**
		 * @return String The style of allowed characters
		 * 
		 * This method returns the style of allowed characters that
		 * is currently set for the component.
		 */
		public function get style():String {
			return _style;
		}
		
		/**
		 * @param value The number of characters for the captcha code
		 * 
		 * This method sets the number of characters for the generated catpcha code
		 * and regenerates the captcha in case the number is set during programming.
		 * The size of the captcha image is then adjusted to accommodate for all
		 * characters. The size of the input field is then set equal to the width of
		 * the image.
		 */
		public function set nrChars(value:uint):void {
			_nrChars = value;
			// Set the width for the image
			box.width = _nrChars * 30 + 10;
			
			// Set the with of the input field equal to the width of the image
			input.width = box.width;
			input.maxChars = _nrChars;
			
			// If the value was set after the captcha was generated,
			// re-generate the image and code.
			if(captchaCreated) {
				generateCaptcha();
			}
		}
		
		/**
		 * @return uint The number of characters in the code
		 * 
		 * This mehod returns the number of characters in the captcha code.
		 */
		public function get nrChars():uint {
			return _nrChars;
		}
		
		/**
		 * @param value An array of 2 colors for the gradient background
		 * 
		 * This method sets the colors for the gradient background noise
		 * in the captcha image. Only 2 colors are allowed to create the 
		 * gradient.
		 */
		public function set noise(value:Array):void {
			_noise = value;

			// If the value was set after the captcha was generated,
			// re-generate the image and code.
			if(captchaCreated) {
				generateCaptcha();
			}
		}
		
		/**
		 * @return The array of 2 colors from the gradient background
		 * 
		 * This method returns the array of 2 colors that have been used
		 * to create the graient background noise in the captcha image.
		 */
		public function get noise():Array {
			return _noise;
		}
	}
}