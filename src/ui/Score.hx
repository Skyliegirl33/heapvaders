package ui;

class Score {
    var game : Game;

    var font : h2d.Font = hxd.res.DefaultFont.get();
    public var tf : h2d.Text;
    var currentScore : Int = 0;

    public function new(x : Int, y : Int) {
        game = Game.inst;

        tf = new h2d.Text(font);
        tf.setScale(4);
        tf.x = x;
        tf.y = y;
        tf.textAlign = Right;
        tf.text = Std.string(currentScore);

        game.scene.addChild(tf);
    }

    public function getScore() {
        return currentScore;
    }

    public function setScore(amount : Int) {
        currentScore = amount;
        tf.text = Std.string(currentScore);
    }

    public function addScore(amount : Int) {
        currentScore += amount;
        tf.text = Std.string(currentScore);
    }

    public function removeScore(amount : Int) {
        currentScore -= amount;
        tf.text = Std.string(currentScore);
    }
}