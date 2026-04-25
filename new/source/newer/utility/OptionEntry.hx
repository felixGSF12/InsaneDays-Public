package newer.utility;

typedef OptionValue = Dynamic;

enum OptionType {
    BoolType;
    NumberType(min:Int, max:Int);
    ListType(items:Array<String>);
}

class OptionEntry {
    public var key:String;         // la clave interna, ej "showHitTimings"
    public var name:String;        // display name
    public var description:String; // descripción
    public var type:OptionType;
    public var value:OptionValue;  // valor actual (Bool / Int / String)

    public function new(key:String, name:String, description:String, type:OptionType, defaultValue:OptionValue) {
        this.key = key;
        this.name = name;
        this.description = description;
        this.type = type;
        this.value = defaultValue;
    }
}
