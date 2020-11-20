class GameOver {
    var game : Game;

    var font : h2d.Font = hxd.res.DefaultFont.get();
    var tf : h2d.Text;
    var currentScore : Int = 0;
    var graphics : h2d.Graphics;
    var timer : Float = 0;
    var timeOut : Float = 2;

    public function new() {
        game = Game.inst;
    }

    public function gameOver() {
        //game.scene.removeChildren();

        game.entities = [];
        //game.activeInvaders = [];
        //game.invaders = [for (y in 0...Game.ALIEN_ROW) new Array<ent.Invader>()];

        graphics = new h2d.Graphics(game.scene);

        tf = new h2d.Text(font);
        tf.setScale(6);
        tf.x = game.scene.width / 2;
        tf.y = (game.scene.height / 2) - 200;
        tf.textAlign = Center;

        if (game.player.lives == 0) {
            graphics.beginFill(0xDE0000);
            graphics.drawRect(0, 0, game.scene.width, game.scene.height);
            graphics.endFill();

            tf.text = Std.string("Game Over!\nFinal score: " + game.gameScore.getScore() + "\n\nPress space to retry");
            game.scene.addChild(tf);
        } else {

        }
    }

    public function update(dt : Float) {
        if (game.player.lives > 0 && game.player.gameOver) {
            if (timer < timeOut) {
                timer += dt;
            } else {
                timer = 0;
                restart();
            }
        }
    }

    public function restart() {
        if (game.player.lives == 0) {
            // Restart entire level
            game.invaders = [for (y in 0...Game.ALIEN_ROW) new Array<ent.Invader>()];
            game.activeInvaders = [];
            game.walls = [];

            game.initLevel(0);
        } else {
            // Just respawn the player
            game.resetInvaders();

            game.player.x = game.scene.width / 2 - 48;
            game.player.y = game.scene.height - 120;
            game.entities.push(game.player);
            game.scene.addChild(game.player.getSprite());
        }

        tf.visible = false;
        graphics.clear();
        game.player.gameOver = false;
    }
}