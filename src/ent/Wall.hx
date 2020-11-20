package ent;

class Wall extends Actor {
    var tile : h2d.Tile;
    var bmp : h2d.Bitmap;
    var health : Int = 4;

    public override function new(x : Float, y : Float) {
        super(x, y, 8);
        tile = game.wallSprites[0][0];
        bmp = new h2d.Bitmap(tile, spr);
        game.scene.addChild(spr);
    }

    public function damage() {
        health -= 1;

        if (health <= 0) {
            game.walls.remove(this);
            destroy();
        } else {
            switch (health) {
                case 1:
                    tile = game.wallSprites[1][0];
                case 2:
                    tile = game.wallSprites[1][1];
                case 3:
                    tile = game.wallSprites[0][1];
            }

            bmp.tile = tile;
        }
    }
}