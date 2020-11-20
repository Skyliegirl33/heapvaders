package ent;

class Invader extends Entity {
    static var SPEED : Float = 20;
    var movingRight : Bool = true;
    var played : Bool = false;
    var oldFrame : Int = 0;
    var called : Bool = false;
    var extraAnim : h2d.Anim;
    public var multiplier : Float = 1;

    public function moveTo(dir : Int, delta : Float) {
        if (extraAnim != null) {
            if (dir == -1) {
                extraAnim.visible = true;
                anim.visible = false;
            } else {
                anim.visible = true;
                extraAnim.visible = false;
            }
        }

        this.x += (SPEED * multiplier) * delta * dir;
    }

    public function isAtEdge() : Bool {
        if (this.x < 0) { 
            this.x = 0;
            return true;
        } else if (this.x + this.spr.getSize().width > this.game.scene.width) {
            this.x = game.scene.width - this.spr.getSize().width;
            return true;
        }

        return false;
    }

    public override function init() {
        if (frames.length == 3) {
            extraAnim = new h2d.Anim([frames[0], frames[2]], 2, spr);
            extraAnim.visible = false;
        }
    }

    public override function destroy() {
        super.destroy();

        var i : Int = game.invaders.length - 1;

        while (i >= 0) {
            var y = game.invaders[i];
            if (y.contains(this)) {
                var index = y.indexOf(this);
                y[index] = null;
                game.aliens--;
            
                if (game.activeInvaders.contains(this)) {
                    var row = (i == 0 ? y : game.invaders[i - 1]);
                    game.activeInvaders[index] = null;                

                    if (row[index] != null) {
                        game.activeInvaders[index] = row[index];
                    }
                }
            }
            i--;
        }

        if (game.aliens <= 0) {
            new Win().youWin();
        }
    }

    public function moveDown(dt : Float) {
        movingRight = !movingRight;
        multiplier *= 1.2;

        this.y += (this.spr.getSize().height / 2) * 0.6;
        this.anim.speed += (multiplier / 10);
        if (this.extraAnim != null) this.extraAnim.speed += (multiplier / 10);
    }

    function downLogic() {
        if (game.shootTimeoutMax > 2)
            game.shootTimeoutMax -= 2;
        
        called = true;
    }

    function isPlayerHit() : Bool {
        return this.getSprite().getBounds().intersects(game.player.getSprite().getBounds());
    }

    public override function update(dt:Float) {
        if (this.anim.currentFrame >= 1) {
            if (movingRight)
                moveTo(1, dt);
            else 
                moveTo(-1, dt);
        } 

        if (isPlayerHit() || isWallHit() != null) {
            game.player.lives = 1;
            game.player.destroy();
        }

        if (isAtEdge()) {
            for (y in game.invaders) {
                for (x in y) {
                    if (x == game.activeInvaders[0])
                        downLogic();
                    if (x == null)
                        continue;

                    x.moveDown(dt);
                }
            }
        }

        oldFrame = Std.int(this.anim.currentFrame);

        super.update(dt);
    }
}