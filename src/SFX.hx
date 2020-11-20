@:publicFields
class SFX {
    var bulletSFX : hxd.res.Sound = null;
    var moveSFX : hxd.res.Sound = null;
    var move2SFX : hxd.res.Sound = null;

    var oldFrame : Int = 0;
    var played : Bool = false;

    public function new() {
        initSFX();
    }

    public function initSFX() {
        bulletSFX = hxd.Res.pew;
        moveSFX = hxd.Res.movesound;
        move2SFX = hxd.Res.movesound2;
    }


	public function invaderSFX(frame : Int) {
        if (!played) {
            if (frame == 1) move2SFX.play(false, 0.3);
            else if (frame == 0) moveSFX.play(false, 0.3);
            played = true;
        }

        if (frame != oldFrame && played)
            played = false;

        oldFrame = frame;
    }
}