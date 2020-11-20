class Win {
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

    public function youWin() {
        game.entities = [];
        game.walls = [];
        graphics = new h2d.Graphics(game.scene);

        tf = new h2d.Text(font);
        tf.setScale(6);
        tf.x = game.scene.width / 2;
        tf.y = (game.scene.height / 2) - 200;
        tf.textAlign = Center;

        graphics.beginFill(0x00DE00);
        graphics.drawRect(0, 0, game.scene.width, game.scene.height);
        graphics.endFill();

        tf.text = Std.string("You win!!\nFinal score: " + game.gameScore.getScore());
        game.scene.addChild(tf);
    }
}