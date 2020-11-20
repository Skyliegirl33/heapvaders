package ent;

class Bullet extends Actor {
    static var SPEED = 500;
    var dir : Int = 0;
    var enemy : Bool = true;
    var bullet : h2d.Bitmap;
    var gone : Bool =  false;

    var timer : Float = 0;
    var timeOut : Float = 0.5;
    var font : h2d.Font = hxd.res.DefaultFont.get();
    var tf : h2d.Text;

    public override function init() {
        tf = new h2d.Text(font);
        tf.textAlign = Left;
        this.spr.addChild(tf);
        game.gameSFX.bulletSFX.play(false, 0.3);
    }

    public function new(x : Float, y : Float, dir : Int, enemy : Bool, bullet : h2d.Tile) {
        super(x, y, 6);
        this.dir = dir;
        this.enemy = enemy;
        this.bullet = new h2d.Bitmap(bullet, spr);
        this.init();
    }

    function isPlayerHit() : Player {
        if (this.getSprite().getBounds().intersects(game.player.getSprite().getBounds()))
            return game.player;
        else 
            return null;
    }

    function isHit() : Invader {
        /*for (y in game.invaders) {
            for (x in y) {
                if (this.getSprite().getBounds().intersects(x.getSprite().getBounds()))
                    return x;
            }
        }*/

        for (invader in game.activeInvaders) {
            if (invader == null)
                continue;

            if (this.getSprite().getBounds().intersects(invader.getSprite().getBounds()))
                return invader;
        }

        return null;
    }

    public override function destroy() {
        gone = true;
        super.destroy();
    }

    public override function update(dt : Float) {
        if (!gone) {
            this.y += dir * SPEED * dt;

            var wall = isWallHit();

            if (wall != null) {
                wall.damage();
                destroy();
            } else if (enemy) {
                var invader = isHit();

                if (invader != null) {
                    game.gameScore.addScore(10);
                    invader.destroy();
                    destroy();
                }
            } else {
                var player = isPlayerHit();

                if (player != null) {
                    player.destroy();
                    destroy();
                }
            }
        }

        if (this.y <= 0 || this.y >= game.scene.height) {
            gone = true;
            destroy();
        }

        if (timer <= timeOut)
            timer += dt;
        else {
            //tf.text = Std.string(game.invaders[0][0].anim.currentFrame);
            timer = 0;
        }

        super.update(dt);
    }
}