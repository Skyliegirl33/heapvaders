import hxd.Key;
import ent.Actor;
import hxd.Window;
import h2d.Scene;
import hxd.Res;
import h2d.Tile;
import Random;

@:publicFields
class Game extends hxd.App {
    static var SCALE = 4;
	static var WIDTH = 256 * SCALE;
    static var HEIGHT = 224 * SCALE;
    static var ALIEN_COL = 10;
    static var ALIEN_ROW = 4;
    static var ALIEN_NO = (ALIEN_COL * ALIEN_ROW);
       
    var shootTime : Float = 0;
    var shootTimeoutMin : Float = 3;
    var shootTimeoutMax : Float = 15;
    var shootTimeout : Float = 0;

    var gameScore : ui.Score;
    var gameSFX : SFX;
    var lives : ui.Lives;
    var walls : Array<ent.Wall> = [];

    var aliens : Int;
    var currentLevel : Int;
    var tiles : Array<Array<h2d.Tile>>;
    var bulletTile : h2d.Tile;
    var sprites : h2d.Tile;
    var wallSprites : Array<Array<h2d.Tile>>;

    var player : ent.Player;
    var entities : Array<Actor> = [];
    var invaders : Array<Array<ent.Invader>> = [for (y in 0...ALIEN_ROW) new Array<ent.Invader>()];
    var activeInvaders : Array<ent.Invader> = [];
    var scene : h2d.Scene;
    var world : h2d.Layers;

    var bg : h2d.Bitmap;

    override function init() {
        Res.initEmbed();

        super.init();

        window.title = "Heapvaders";
        window.vsync = true;
        window.resize(WIDTH, HEIGHT);

        scene = new h2d.Scene();
        scene.scaleMode = Resize;
        setScene(scene);

        initLevel(0);
    }

    function initLevel(level : Int) {
        currentLevel = level;
        aliens = ALIEN_NO;
        shootTime = 0;
        shootTimeoutMin = 3;
        shootTimeoutMax = 15;

        bg = new h2d.Bitmap(hxd.Res.invader_bg.toTile(), scene);
        bg.setScale(SCALE);
        world = new h2d.Layers(scene);

        sprites = hxd.Res.sprites.toTile().center();
        bulletTile = hxd.Res.bullet.toTile().center();
        tiles = sprites.grid(16);
        wallSprites = hxd.Res.walls.toTile().center().grid(18);

        gameSFX = new SFX();
        gameScore = new ui.Score(scene.width - 40, 10);

        walls.push(new ent.Wall(60, scene.height - 250));
        walls.push(new ent.Wall(256 + walls[0].x, scene.height - 250));
        walls.push(new ent.Wall(512 + walls[0].x, scene.height - 250));
        walls.push(new ent.Wall(768 + walls[0].x, scene.height - 250));

        setupInvaders();

        player = new ent.Player([tiles[1][2], tiles[2][2]], scene.width / 2 - 48, scene.height - 120, 6);
        scene.addChild(player.getSprite());

        lives = new ui.Lives(10, 10);
    }

    function invaderShoot(delta : Float) {
        var randomInvader = Random.fromArray(activeInvaders);

        if (randomInvader == null)
            return;

        var bullet = new ent.Bullet(randomInvader.x + (randomInvader.getSprite().getSize().width / 2), randomInvader.y + randomInvader.getSprite().getSize().height, 
                                        1, false, bulletTile);
        scene.addChild(bullet.getSprite());
    }

    function resetInvaders() {
        for (y in 0...ALIEN_ROW) {
            for (x in 0...ALIEN_COL)  {
                var invader = invaders[y][x];

                if (invader == null)
                    continue;

                entities.push(invader);
            }
        }
    }

    function setupInvaders() {
        var width : Float = tiles[0][0].width + 72;
        var height : Float = tiles[0][0].height + 72;

        for (y in 0...ALIEN_ROW) {
            for (x in 0...ALIEN_COL)  {
                var _tiles : Array<h2d.Tile> = [];

                if (y == 0)
                    _tiles = [tiles[0][0], tiles[1][0]];
                else if (y == 1)
                    _tiles = [tiles[2][0], tiles[3][0]];
                else if (y == 2) 
                    _tiles = [tiles[0][1], tiles[1][1]];
                else if (y == 3) 
                    _tiles = [tiles[2][1], tiles[3][1], tiles[0][2]];

                var invader = new ent.Invader(_tiles, (x + 0.5) * width, (y + 0.6) * height, 6);
                invaders[y].push(invader);
                scene.addChild(invader.getSprite());
            }
        }
        activeInvaders = invaders[ALIEN_ROW - 1].copy();
    }

    override function update(dt : Float) {
        super.update(dt);
        for(e in entities) {
            e.update(dt);
        }
        player.over.update(dt);

        if (Key.isPressed(Key.SPACE) && player.gameOver && player.lives == 0) {
            player.over.restart();
        }

        if (shootTime <= shootTimeout) {
            if (shootTime == 0)
                shootTimeout = Random.int(Std.int(shootTimeoutMin), Std.int(shootTimeoutMax));
            shootTime += dt;
        } else {
            shootTime = 0;
            if (activeInvaders.length != 0 && !player.gameOver)
                invaderShoot(dt);
        }

        if (activeInvaders.length > 0) {
            var alien = activeInvaders.filter(function(v) { return (v != null); } )[0];
            if (alien != null && !player.gameOver) gameSFX.invaderSFX(Std.int(alien.anim.currentFrame));
        }
    }

    public static var inst : Game;
    public static var window : Window;
    
    static function main() {
       inst = new Game();
       window = Window.getInstance();
    }
}