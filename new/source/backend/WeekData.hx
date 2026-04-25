package backend;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;
import states.CharacterSelector;
typedef WeekFile =
{
	// JSON variables
	var songs:Array<Dynamic>;
	var portrait:String;
	var weekCharacters:Array<String>;
	var weekBackground:String;
	var weekBefore:String;
	var storyName:String;
	var weekName:String;
	var startUnlocked:Bool;
	var hiddenUntilUnlocked:Bool;
	var hideStoryMode:Bool;
	var hideFreeplay:Bool;
	var difficulties:String;
}

class WeekData {
	public static var weeksLoaded:Map<String, WeekData> = new Map<String, WeekData>();
	public static var weeksList:Array<String> = [];
	public var folder:String = '';

	// JSON variables
	public var songs:Array<Dynamic>;
	public var portrait:String;
	public var weekCharacters:Array<String>;
	public var weekBackground:String;
	public var weekBefore:String;
	public var storyName:String;
	public var weekName:String;
	public var startUnlocked:Bool;
	public var hiddenUntilUnlocked:Bool;
	public var hideStoryMode:Bool;
	public var hideFreeplay:Bool;
	public var difficulties:String;

	public var fileName:String;

	public static function createWeekFile():WeekFile {
		var weekFile:WeekFile = {
			songs: [["Bopeebo", "face", [146, 113, 253]], ["Fresh", "face", [146, 113, 253]], ["Dad Battle", "face", [146, 113, 253]]],
			#if BASE_GAME_FILES
			weekCharacters: ['dad', 'bf', 'gf'],
			#else
			weekCharacters: ['bf', 'bf', 'gf'],
			#end
			weekBackground: 'stage',
			weekBefore: 'tutorial',
			storyName: 'Your New Week',
			portrait: 'rayo',
			weekName: 'Custom Week',
			startUnlocked: true,
			hiddenUntilUnlocked: false,
			hideStoryMode: false,
			hideFreeplay: false,
			difficulties: ''
		};
		return weekFile;
	}

	// HELP: Is there any way to convert a WeekFile to WeekData without having to put all variables there manually? I'm kind of a noob in haxe lmao
	public function new(weekFile:WeekFile, fileName:String) {
		// here ya go - MiguelItsOut
		for (field in Reflect.fields(weekFile))
			if(Reflect.fields(this).contains(field)) // Reflect.hasField() won't fucking work :/
				Reflect.setProperty(this, field, Reflect.getProperty(weekFile, field));

		this.fileName = fileName;
	}

public static function reloadWeekFiles(isStoryMode:Null<Bool> = false)
{
    weeksList = [];
    weeksLoaded.clear();

    #if MODS_ALLOWED
    var directories:Array<String> = [Paths.mods(), Paths.getSharedPath()];
    var originalLength:Int = directories.length;

    for (mod in Mods.parseList().enabled)
        directories.push(Paths.mods(mod + '/'));
    #else
    var directories:Array<String> = [Paths.getSharedPath()];
    var originalLength:Int = directories.length;
    #end

    // ==========================
    // 🔄 1. CARGAR TODAS LAS WEEKS (SIN ORDEN)
    // ==========================
    var allWeeks:Map<String, WeekData> = new Map();

    for (dir in directories)
    {
        var weekFolder:String = dir + 'weeks/';
        if (!FileSystem.exists(weekFolder)) continue;

        for (subfolder in FileSystem.readDirectory(weekFolder))
        {
            var fullSubfolderPath:String = weekFolder + subfolder + '/';
            if (!FileSystem.isDirectory(fullSubfolderPath)) continue;

            if (!isStoryMode && CharacterSelector.selectedCharacter != null && subfolder != CharacterSelector.selectedCharacter)
                continue;

            for (file in FileSystem.readDirectory(fullSubfolderPath))
            {
                if (!file.endsWith('.json')) continue;

                var weekName:String = file.substr(0, file.length - 5);
                var path:String = fullSubfolderPath + file;

                if (!allWeeks.exists(weekName))
                {
                    var week:WeekFile = getWeekFile(path);
                    if (week != null)
                    {
                        var weekFile:WeekData = new WeekData(week, weekName);

                        #if MODS_ALLOWED
                        if (dir != Paths.getSharedPath())
                            weekFile.folder = dir.substring(Paths.mods().length, dir.length - 1);
                        #end

                        if (weekFile != null && (
                            isStoryMode == null ||
                            (isStoryMode && !weekFile.hideStoryMode) ||
                            (!isStoryMode && !weekFile.hideFreeplay)
                        ))
                        {
                            allWeeks.set(weekName, weekFile);
                        }
                    }
                }
            }
        }
    }
    var weekList:Array<String> = [];

    if (isStoryMode)
    {
        weekList = CoolUtil.coolTextFile(Paths.getSharedPath('weeks/weekList.txt'));
    }
    else if (CharacterSelector.selectedCharacter != null)
    {
        for (dir in directories)
        {
            var path = dir + 'weeks/' + CharacterSelector.selectedCharacter + '/weekList.txt';
            if (FileSystem.exists(path))
            {
                weekList = CoolUtil.coolTextFile(path);
                break;
            }
        }
    }

    for (weekName in weekList)
    {
        if (allWeeks.exists(weekName))
        {
            weeksLoaded.set(weekName, allWeeks.get(weekName));
            weeksList.push(weekName);
        }
        else
        {
            trace('Week not found: ' + weekName);
        }
    }

    // Luego: fallback (weeks no listadas)
    for (weekName in allWeeks.keys())
    {
        if (!weeksLoaded.exists(weekName))
        {
            weeksLoaded.set(weekName, allWeeks.get(weekName));
            weeksList.push(weekName);
        }
    }
}
	private static function addWeek(weekToCheck:String, path:String, directory:String, i:Int, originalLength:Int)
	{
		if(!weeksLoaded.exists(weekToCheck))
		{
			var week:WeekFile = getWeekFile(path);
			if(week != null)
			{
				var weekFile:WeekData = new WeekData(week, weekToCheck);
				if(i >= originalLength)
				{
					#if MODS_ALLOWED
					weekFile.folder = directory.substring(Paths.mods().length, directory.length-1);
					#end
				}
				if((PlayState.isStoryMode && !weekFile.hideStoryMode) || (!PlayState.isStoryMode && !weekFile.hideFreeplay))
				{
					weeksLoaded.set(weekToCheck, weekFile);
					weeksList.push(weekToCheck);
				}
			}
		}
	}

	private static function getWeekFile(path:String):WeekFile {
		var rawJson:String = null;
		#if MODS_ALLOWED
		if(FileSystem.exists(path)) {
			rawJson = File.getContent(path);
		}
		#else
		if(OpenFlAssets.exists(path)) {
			rawJson = Assets.getText(path);
		}
		#end

		if(rawJson != null && rawJson.length > 0) {
			return cast tjson.TJSON.parse(rawJson);
		}
		return null;
	}

	//   FUNCTIONS YOU WILL PROBABLY NEVER NEED TO USE

	//To use on PlayState.hx or Highscore stuff
	public static function getWeekFileName():String {
		return weeksList[PlayState.storyWeek];
	}

	//Used on LoadingState, nothing really too relevant
	public static function getCurrentWeek():WeekData {
		return weeksLoaded.get(weeksList[PlayState.storyWeek]);
	}

	public static function setDirectoryFromWeek(?data:WeekData = null) {
		Mods.currentModDirectory = '';
		if(data != null && data.folder != null && data.folder.length > 0) {
			Mods.currentModDirectory = data.folder;
		}
	}
}
