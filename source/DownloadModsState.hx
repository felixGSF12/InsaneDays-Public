package;

import flixel.FlxG;
import flixel.FlxSprite;
//import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Http;
import haxe.Json;
import haxe.zip.Entry;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.HTTPStatusEvent;
import openfl.net.URLRequest;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

private class ZipHandler 
{
	public static function saveUncompressed(zipPath:String, savePath:String):Void {
		var zipReader = new haxe.zip.Reader(File.read(zipPath));
		var fileList:haxe.ds.List<Entry> = zipReader.read();

		if(!savePath.endsWith('/')) savePath += '/';
		if(!FileSystem.exists('${savePath}')) FileSystem.createDirectory('${savePath}');

		for(file in fileList) {
			if(file.fileName.endsWith('/')) { FileSystem.createDirectory(savePath + file.fileName); continue; }
			final fileData:Null<haxe.io.Bytes> = uncompressFile(file);

			File.saveBytes(savePath + file.fileName, fileData);
		}
	}

	public static function uncompressFile(file:Entry):Null<haxe.io.Bytes> {
		if(!file.compressed)
			return file.data; //File is already uncompressed

		var c = new haxe.zip.Uncompress(-15);
		var s = haxe.io.Bytes.alloc(file.fileSize);
		var r = c.execute(file.data, 0, s, 0);
		c.close();
		if( !r.done || r.read != file.data.length || r.write != file.fileSize )
			throw 'Invalid compressed data for ${file.fileName}';
		file.compressed = false;
		file.dataSize = file.fileSize;
		file.data = s;

		return file.data;
	}
}

private typedef DownloadMetadata = {
	var link:String;
	var modpack:String;
    var min_version:String;
    var descripcion:String;
    var recommended:String;
	var author:String;
	var fileName:String;
	var logo:String;
	var updated:String;
}

class DownloadModsState extends MusicBeatState {
    var modpacks:Array<DownloadMetadata>;
    var progressBar:FlxBar;
    var progressTxt:FlxText;
    var blockInput:Bool = false;
    var receivedBytes:Int = 0;
    var totalBytes:Int = 0;
    var downloadedMB:Float;
    var totalMB:Float;
    var percent:Int;
    var currentIndex:Int = 0;

    // Grupos para los botones y logos
    var buttonGroup:FlxTypedGroup<FlxButton> = new FlxTypedGroup<FlxButton>();
    var logoGroup:FlxSpriteGroup = new FlxSpriteGroup();
    var textGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

    override function create() {
        FlxG.mouse.visible = true;

        var bg = new FlxSprite().loadGraphic(Paths.image("menumod/GalleryMenu"));
        add(bg);
		var fg = new FlxSprite().loadGraphic(Paths.image("menumod/Base"));
		fg.flipX = true;
        add(fg);

       // var http = new Http("https://raw.githubusercontent.com/MeguminBOT/Rhythm-Engine-Wiki/main/packList/modpackDownloadList.json");
	   var http = new Http("https://raw.githubusercontent.com/FelixGsf/insaneVersion/refs/heads/main/modpackDownloadList.json");
        http.onData = function(data:String) {
            modpacks = Json.parse(data);

            // Mostrar el primer modpack
            displayModpack(currentIndex);
        };

        http.onError = function(errorMsg:String) {
            trace("Error connecting to GitHub Repo:\n" + errorMsg);
            progressTxt.text = "Error connecting to GitHub Repo.\nGitHub might be experiencing some problems\nor there's a problem with your internet connection.\nPlease try again later\n" + errorMsg;
            add(progressTxt);
        };

        http.request();

        progressBar = new FlxBar(0, 0, FlxG.width, 20, null, totalBytes, 100, false);
        progressTxt = new FlxText(0, 250, FlxG.width, "");
        progressTxt.setFormat("rubik.ttf", 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

        super.create();
    }

    private function displayModpack(index:Int) {
        if (index >= 0 && index < modpacks.length) {
            var metadata = modpacks[index];
    
            // Eliminar objetos anteriores
            buttonGroup.clear();
            logoGroup.clear();
            textGroup.clear();
    
            var button:FlxButton = new FlxButton(FlxG.width / 2 + 350, FlxG.height / 2 + 110, 'Descargar', function() {
                downloadModpack(metadata);
            });
            button.scale.set(3,3);
            button.label.setFormat("rubik.ttf", 28, FlxColor.BLACK);
            buttonGroup.add(button);
    
            var logo:FlxSprite = new FlxSprite(FlxG.width / 2 - 50, FlxG.height / 2 - 50);
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event) {
                var bitmap:Bitmap = event.target.content;
                logo.loadGraphic(bitmap.bitmapData);
                logoGroup.add(logo);
            });
            loader.load(new URLRequest(metadata.logo));
    
            // Texto actualizado
            var updatedTxt:FlxText = new FlxText(0, 0, 423, "");
            updatedTxt.text = metadata.updated;
            updatedTxt.setFormat(Paths.font("vcr.ttf"), 34, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            updatedTxt.x = 400;
            updatedTxt.y = 12;
            trace(updatedTxt.y);
            textGroup.add(updatedTxt);

            var min_text_1:FlxText = new FlxText(0,580, FlxG.width,'Version Minima: ');
            min_text_1.text = "Version Minima: " + metadata.min_version;
            min_text_1.setFormat(Paths.font('vcr.ttf'),24);
            textGroup.add(min_text_1);

            var min_text_2:FlxText = new FlxText(0,610, FlxG.width,'recommended: ');
            min_text_2.text = "recommended: " + metadata.recommended;
            min_text_2.setFormat(Paths.font('vcr.ttf'),24);
            textGroup.add(min_text_2);

            var min_text_3:FlxText = new FlxText(0,670, FlxG.width,'author: ');
            min_text_3.text = "author: " + metadata.author;
            min_text_3.setFormat(Paths.font('vcr.ttf'),24);
            textGroup.add(min_text_3);
            
            var des_text:FlxText = new FlxText(870,170, 355,'');
            des_text.text = metadata.descripcion;
            des_text.setFormat(Paths.font('vcr.ttf'),24);
            textGroup.add(des_text);
            add(buttonGroup);
            add(logoGroup);
            add(textGroup);
        }
    }    
    private function downloadModpack(metadata:DownloadMetadata):Void {
        try {
            var request = new URLRequest(metadata.link);
            var urlLoader = new URLLoader();
            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            var directory = Paths.mods();
            var savePath = directory;
            var zipPath:String = directory + metadata.fileName;
            add(progressBar);
            add(progressTxt);
            urlLoader.addEventListener(ProgressEvent.PROGRESS, function(event:Dynamic) {
                receivedBytes = event.bytesLoaded;
                totalBytes = event.bytesTotal;
                downloadedMB = Math.round((receivedBytes / 1000000) * 100) / 100;
                totalMB = Math.round((totalBytes / 1000000) * 100) / 100;
                percent = Math.round((receivedBytes / totalBytes) * 100);

                progressBar.value = percent;
                if (percent < 100) {
                    progressTxt.text = "Downloading... " + Std.string(downloadedMB) + " MB" + "/" + Std.string(totalMB) + " MB";
                } else {
                    progressTxt.text = "Completed download of: " + metadata.modpack + " (" + totalMB + " MB)";
                }
                blockInput = true;
            });
            urlLoader.addEventListener(Event.COMPLETE, function(event:Event) {
                var data:haxe.io.Bytes = untyped urlLoader.data;
                if(!FileSystem.exists('${zipPath.replace(metadata.fileName, "")}')) FileSystem.createDirectory('${zipPath.replace(metadata.fileName, "")}');
                File.saveBytes(zipPath, data);
                ZipHandler.saveUncompressed(zipPath, savePath);
                blockInput = false;
                urlLoader.close();
                remove(progressTxt);
                remove(progressBar);
            });
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent) {
                trace("Error downloading modpack:\n" + event.text);
                progressTxt.text = "IOErrorEvent: Error downloading modpack:\n" + metadata.modpack + "\n" + event.text;
                blockInput = false;
                remove(progressBar);
            });
            urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(event:HTTPStatusEvent) {
                if (event.status > 400) {
                    trace("Error accessing modpack:\n" + event.status);
                    progressTxt.text = "HTTPStatusEvent: Error accessing modpack:\n" + metadata.modpack + "\nStatus code: " + event.status;
                }
                blockInput = false;
                remove(progressBar);
            });
            urlLoader.load(request);

        } catch (e:Dynamic) {
            trace("Unexpected: Error downloading modpack:\n" + e);
            progressTxt.text = "Unexpected: Error downloading modpack:\n" + metadata.modpack + "\n" + e;
            blockInput = false;
            remove(progressBar);
        }
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (blockInput) {
            FlxG.mouse.visible = false;
        } else {
            FlxG.mouse.visible = true;

            // Navegar con las teclas de flecha
            if (FlxG.keys.justPressed.UP) {
                currentIndex = (currentIndex - 1 + modpacks.length) % modpacks.length;
                displayModpack(currentIndex);
                FlxG.sound.play(Paths.sound('scrollMenu'));
            } else if (FlxG.keys.justPressed.DOWN) {
                currentIndex = (currentIndex + 1) % modpacks.length;
                FlxG.sound.play(Paths.sound('scrollMenu'));
                displayModpack(currentIndex);
            }

            if (controls.BACK) {
                MusicBeatState.switchState(new MainMenuState());
            }
        }
    }
}
