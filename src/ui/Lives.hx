package ui;

class Lives {
    var game : Game;

    var font : h2d.Font = hxd.res.DefaultFont.get();
    public var tf : h2d.Text;

    public function new(x : Int, y : Int) {
        game = Game.inst;

        tf = new h2d.Text(font);
        tf.setScale(4);
        tf.x = x;
        tf.y = y;
        tf.textAlign = Left;
        tf.text = "Lives: " + Std.string(game.player.lives);

        game.scene.addChild(tf);
    }

    public function updateLives() {
        tf.text = "Lives: " + Std.string(game.player.lives);
    }
}