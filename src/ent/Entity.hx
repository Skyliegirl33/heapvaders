package ent;

import h2d.Anim;

class Entity extends Actor {
	public var anim : h2d.Anim;
	public var frames : Array<h2d.Tile>;

	public function new(frames : Array<h2d.Tile>, x : Float, y : Float, scale : Float, animEnabled : Bool = true) {
		super(x, y, scale);
		this.frames = frames;
		if (animEnabled) this.anim = new Anim([frames[0], frames[1]], 2, spr);
		this.init();
	}
}