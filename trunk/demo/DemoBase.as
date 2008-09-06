﻿package  {

	import com.as3dmod.modifiers.Perlin;
	import com.as3dmod.ModifierStack;
	import com.as3dmod.util.Phase;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import com.as3dmod.modifiers.Bend;
	import com.as3dmod.modifiers.Noise;
	import com.as3dmod.util.ModConstant;
	
	import com.carlcalderon.arthropod.Debug;
	
	public class DemoBase extends Sprite {

		private var demo:Sprite;
		
		private var bone:Bend;
		private var bonePhase:Phase;
		
		private var btwo:Bend;
		private var btwoPhase:Phase;
		
		private var n:Noise;
		private var nph:Phase;
		
		private var p:Perlin;
		
		/**
		 *  Read the comments below to compile the example with different 
		 *  engines and get (hopefully) a basic idea of how the stack works.
		 */
		public function DemoBase() {
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Debug.clear();
			
			/*
			 * Uncomment one of this lines to compile a 
			 * version of the demo for the given engine
			 * 
			 * Look below to the setupstack() methode,
			 * and uncomment the proper line.
			 */
			//demo = new Pv3dDemo(this);
			//demo = new Away3dDemo(this);
			//demo = new Sandy3dDemo(this);
			demo = new Alternativa3dDemo(this);
			addChild(demo);
		}
		
		public function setupStack(m:ModifierStack):void {
			// ## 1. create a Noise modifier and constraint it to on axis only
			n = new Noise(10);
			//n.constraintAxes(ModConstant.X | ModConstant.Y); // alternativa / pv3d
			//n.constraintAxes(ModConstant.X | ModConstant.Z); // away
			n.constraintAxes(ModConstant.Y | ModConstant.X); // sandy
			// ## 2. add the modifier to the stack
			m.addModifier(n);
			// ## 3. collapse - apply the current modifications to the mesh and clear the stack
			m.collapse();
			
			// ## 4. after the collapse the stack is clear, so Perlin is added as 1st one now
			p = new Perlin(3); // alternativa / pv3d / sandy
			//p = new Perlin(1); // away (less force)
			// ## 5. the effect will be applied with decreasing intensity along the longes axis of the object
			p.setFalloff(1, 0);
			// ## 6. add the modifier to the stack
			m.addModifier(p);
			
			// ## 7. add a bend modifier. it works in a similar way, as the pv3d bend modifier
			bone = new Bend(0, .7);
			bone.constraint = ModConstant.LEFT;
			// ## 8. create a phase object to help animate it back and forth (using a sine wave)
			bonePhase = new Phase();
			m.addModifier(bone);
			
			// ## 9. add aother bend modifier
			btwo = new Bend(0, .3);
			btwo.constraint = ModConstant.RIGHT;
			btwoPhase = new Phase();
			m.addModifier(btwo);
		}
		
		public function onRender():void {
			// # 10. animate the sine wave and apply its value to the modifier
			bonePhase.value += 0.05;
			bone.force = bonePhase.phasedValue * 2;
			
			btwoPhase.value -= 0.02;
			btwo.force = btwoPhase.phasedValue * 2;
			
			// # 11. The Perlin modifier is self-animated, no need to do anything here
		}
	}	
}















