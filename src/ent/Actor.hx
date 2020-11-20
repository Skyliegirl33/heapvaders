package ent;

// Base class for all actors

class Actor {
	var game : Game;

	public var x : Float;
	public var y : Float;
	public var scale : Float;
    public var spr : h2d.Object;
    
    public function new(x : Float = 0, y : Float = 0, scale : Float = 1) { 
        game = Game.inst;
        this.x = x;
		this.y = y;
		this.scale = scale;
		this.spr = new h2d.Object();
		this.spr.x = x;
		this.spr.y = y;
        this.spr.setScale(scale);
        game.entities.push(this);
    }

	public function init() { }

	public function isWallHit() : Wall {
        for (wall in game.walls) {
            if (this.getSprite().getBounds().intersects(wall.getSprite().getBounds()))
                return wall;
        }

        return null;
    }

	public function destroy()  {
		game.scene.removeChild(this.getSprite());
		game.entities.remove(this);
	}

    public function getSprite() : h2d.Object {
		return spr;
	}

	public function setPosition(x : Float, y : Float) {
		this.x = x;
		this.y = y;
	}

	public function update(dt : Float) {
		spr.x = Std.int(x);
		spr.y = Std.int(y);
	}
}