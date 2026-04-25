package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import lime.system.System as LimeSystem;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var cpuUsage:Float = 0;
	public var currentFPS(default, null):Int;

	/**
		The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	**/
	public var memoryMegas(get, never):Float;
	public var vramMegas(get, never):Float;

	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font("vcr.ttf"), 16, 0xFFFFFFFF);
		border = true;
		borderColor = 0xFF000000;
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
{
	final now:Float = haxe.Timer.stamp() * 1000;
	times.push(now);
	while (times[0] < now - 1000) times.shift();

	if (deltaTimeout < 50) {
		deltaTimeout += deltaTime;
		return;
	}

	currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;

	// CPU usage estimation
	var targetFrameTime = 1000 / FlxG.updateFramerate;
	cpuUsage = (deltaTime / targetFrameTime) * 100;

	updateText();
	deltaTimeout = 0.0;
}

	public dynamic function updateText():Void
{
	text = 'FPS: ${currentFPS}'
	+ '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}'
	+ '\nCPU: ${Std.int(cpuUsage)}%'
	+ '\nVRAM: ${Std.int(vramMegas)} MB';

	textColor = 0xFFFFFFFF;

	if (currentFPS < FlxG.drawFramerate * 0.5)
		textColor = 0xFFFF0000;
}

inline function get_vramMegas():Float
{
	#if cpp
	return System.totalMemory / (1024 * 1024);
	#else
	return 0;
	#end
}

	inline function get_memoryMegas():Float
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
}

