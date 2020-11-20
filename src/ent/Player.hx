package ent;

import hxd.Key;

class Player extends Entity {
    static var SPEED = 200;

    var delta : Float = 0;
    var bullet : Bullet;
    public var lives : Int = 3;
    public var gameOver : Bool = false;
    public var over : GameOver;

    public override function init() {
        this.anim.pause = true;
        this.over = new GameOver();
    }

    public override function destroy() {
        super.destroy();
        lives -= 1;
        doGameOver(lives);
    }

    public function doGameOver(lives : Int) {
        this.lives = lives;
        game.lives.updateLives();
        this.over.gameOver();
        gameOver = true;
    }

    public function shoot() {
        if (!game.entities.contains(bullet)) {
            bullet = new Bullet(this.x + (this.spr.getSize().width / 2), this.y, -1, true, game.bulletTile);
            game.scene.addChild(bullet.getSprite());
        }
    }

    public function moveTo(dir : Int) {
        this.x += SPEED * delta * dir;
        this.anim.currentFrame = (dir == 1 ? 0 : 1);

        if (this.x < 0) {
            this.x = 0;
        } else if (this.x + this.spr.getBounds().width > game.scene.width) {
            this.x = game.scene.width - this.spr.getSize().width;
        }
    }

    public override function update(dt : Float) {
        delta = dt;

        if (!gameOver) {
            if (Key.isDown(Key.RIGHT))
                moveTo(1);
            else if (Key.isDown(Key.LEFT))
                moveTo(-1);

            if (Key.isPressed(Key.SPACE))
                shoot();
        }

        super.update(dt);
    }
}