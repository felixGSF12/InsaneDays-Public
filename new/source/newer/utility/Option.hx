package newer.utility;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;

typedef OptionValue = Dynamic;

enum OptionType {
    BoolType;
    NumberType(min:Int, max:Int);
    ListType(items:Array<String>);
}

class Option {
    public var name:String;
    public var type:OptionType;
    public var value:OptionValue;

    public function new(name:String, type:OptionType, value:OptionValue) {
        this.name = name;
        this.type = type;
        this.value = value;
    }
}

class OptionMenu {
    public var options:Array<Option>;
    public var selected:Int;

    public function new() {
        options = [];
        selected = 0;
    }

    public function addOption(name:String, type:OptionType, defaultValue:OptionValue):Void {
        options.push(new Option(name, type, defaultValue));
    }

    public function getSelectedOption():Option {
        if(options.length == 0) return null;
        return options[selected];
    }

    public function nextOption():Void {
        if(options.length == 0) return;
        selected++;
        if(selected >= options.length) selected = 0;
    }

    public function prevOption():Void {
        if(options.length == 0) return;
        selected--;
        if(selected < 0) selected = options.length - 1;
    }

    private function getOptionByName(tag:String):Option {
        for(opt in options) {
            if(opt.name == tag) return opt;
        }
        return null;
    }

    public function setOptionValue(tag:String, value:OptionValue):Void {
        var opt = getOptionByName(tag);
        if(opt != null) opt.value = value;
    }

    public function getOptionValue(tag:String):OptionValue {
        var opt = getOptionByName(tag);
        if(opt != null) return opt.value;
        return null;
    }

    public function handleInput():Void {
        var opt = getSelectedOption();
        if(opt == null) return;

        switch(opt.type) {
            case BoolType:
                if(FlxG.keys.justPressed.SPACE) {
                    opt.value = !opt.value;
                    trace("Bool toggled: " + opt.value);
                }
            case NumberType(min, max):
                if(FlxG.keys.pressed.LEFT) opt.value = Math.max(min, opt.value - 1);
                if(FlxG.keys.pressed.RIGHT) opt.value = Math.min(max, opt.value + 1);
            case ListType(items):
                var index = items.indexOf(opt.value);
                if(FlxG.keys.justPressed.LEFT) index = (index - 1 + items.length) % items.length;
                if(FlxG.keys.justPressed.RIGHT) index = (index + 1) % items.length;
                opt.value = items[index];
        }
    }

    public function debugPrint():Void {
        for(opt in options) {
            trace(opt.name + " = " + opt.value + " (" + opt.type + ")");
        }
    }
}
