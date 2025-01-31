package;
#if desktop
import sys.io.File;
import sys.io.FileOutput;
#end

class Achievement {
    public var icon:String;
    public var description:String;
    public var title:String;

    public function new(icon:String, description:String, title:String) {
        this.icon = icon;
        this.description = description;
        this.title = title;
    }
}
class AchievementSystem {
    public static var achievements:Array<Achievement> = [];

    public static function loadAchievements():Void {
        achievements = [];
        var fileContent:String = File.getContent("assets/data/achievements.txt");
        var lines:Array<String> = fileContent.split("\n");

        for (line in lines) {
            var parts:Array<String> = line.split("::");
            if (parts.length == 3) {
                var achievement:Achievement = new Achievement(parts[0], parts[1], parts[2]);
                achievements.push(achievement);
            }
        }
    }

    public static function addAchievement(icon:String, description:String, title:String):Void {
        var achievement:Achievement = new Achievement(icon, description, title);
        achievements.push(achievement);
        saveAchievements();
    }
    public static function luaAchievement(title:String, description:String, icon:String):Void {
        // Verificar si el logro ya existe para no duplicar
        for (achievement in achievements) {
            if (achievement.title == title) {
                trace("El logro ya existe: " + title);
                return;
            }
        }
        // Si no existe, crear un nuevo logro y añadirlo a la lista
        var newAchievement:Achievement = new Achievement(title, description, icon);
        achievements.push(newAchievement);
        trace("Nuevo logro añadido: " + title);
        // Guardar el estado de los logros en el archivo
        saveAchievementsToFile("assets/data/achievements.txt");
    }
    private static function saveAchievements():Void {
        var content:String = "";
        for (achievement in achievements) {
            content += achievement.icon + "::" + achievement.description + "::" + achievement.title + "\n";
        }
        File.saveContent("assets/data/achievements.txt", content);
    }
    public static function saveAchievementsToFile(filePath:String):Void {
        var file:FileOutput = File.write(filePath, false);
        for (achievement in achievements) {
            file.writeString(achievement.icon + "::" + achievement.description + "::" +  achievement.title + "\n");
        }
        file.close();
    }
}
