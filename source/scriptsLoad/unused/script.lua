-----------------------------
                      -- WINDOW DARK MODE IN LUA --
                      -----------------------------                   
-- Script and code made by T-Bar: https://www.youtube.com/@tbar7460 --
--    (please leave this message in the script, acts as credits)    --
--                                :D                                --

local ffi = require("ffi");
local dwmapi = ffi.load("dwmapi");

ffi.cdef([[
	typedef void* CONST;
    typedef void* HWND;
    typedef unsigned long DWORD;
	typedef const void *LPCVOID;
	
	typedef long LONG;
	typedef LONG HRESULT;
	
	HWND GetActiveWindow();
	HRESULT DwmSetWindowAttribute(HWND hwnd, DWORD dwAttribute, LPCVOID pvAttribute, DWORD cbAttribute);
	void UpdateWindow(HWND hWnd);
]])

local S_OK = 0x00000000;
local windowColorMode = {
	0x7ffec8f410bf, --Dark mode
	000000 --Light mode
};

---Sets the window to dark mode
function setDarkMode()
	local window = ffi.C.GetActiveWindow();
	local isDark = dwmapi.DwmSetWindowAttribute(window, 19, ffi.new("int[1]", windowColorMode[1]), ffi.sizeof(ffi.cast("DWORD", 1)));

	if isDark == 0 or isDark ~= S_OK then
		dwmapi.DwmSetWindowAttribute(window, 20, ffi.new("int[1]", windowColorMode[1]), ffi.sizeof(ffi.cast("DWORD", 1)));
	end
	
	ffi.C.UpdateWindow(window);
end

---Sets the window to light mode
function setLightMode()
	local window = ffi.C.GetActiveWindow();
	local isLight = dwmapi.DwmSetWindowAttribute(window, 19, ffi.new("int[1]", windowColorMode[2]), ffi.sizeof(ffi.cast("DWORD", 0)));

	if isLight == 0 or isLight ~= S_OK then
		dwmapi.DwmSetWindowAttribute(window, 20, ffi.new("int[1]", windowColorMode[2]), ffi.sizeof(ffi.cast("DWORD", 0)));
	end
	
	ffi.C.UpdateWindow(window);
end

---Shortcut to both "setDarkMode" and "setLightMode", as one function
---@param isDark boolean Is the window dark mode?
function setWindowColorMode(isDark)
	local window = ffi.C.GetActiveWindow();
	local isColorMode = dwmapi.DwmSetWindowAttribute(window, 19, ffi.new("int[1]", windowColorMode[(isDark and 1 or 2)]), ffi.sizeof(ffi.cast("DWORD", (isDark and 1 or 0))));

	if isColorMode == 0 or isColorMode ~= S_OK then
		dwmapi.DwmSetWindowAttribute(window, 20, ffi.new("int[1]", windowColorMode[(isDark and 1 or 2)]), ffi.sizeof(ffi.cast("DWORD", (isDark and 1 or 0))));
	end
	
	ffi.C.UpdateWindow(window);
end

---Resets the window. Be sure to run this after using "setDarkMode" to force the effect immediately
function resetScreenSize()
	setPropertyFromClass('lime.app.Application', 'current.window.fullscreen', true);
	setPropertyFromClass('lime.app.Application', 'current.window.fullscreen', false);
end

--fbfiusdjbfisufbreisuegirsufbieurftbdrutdruteiengidrusfafa
	--runHaxeCode([[
	--	createGlobalCallback("setDarkMode", function() {
	--		parentLua.call("setDarkMode");
	--	});
	--	createGlobalCallback("setLightMode", function() {
	--		parentLua.call("setLightMode");
	--	});
	--	createGlobalCallback("setWindowColorMode", function(isDark:Bool) {
	--		parentLua.call("setWindowColorMode", [isDark]);
	--	});
	--]])

-- Add your extra code here. --

function onCreate()
	--setDarkMode()
	setWindowColorMode(true);
	resetScreenSize();
end

function onDestroy()
	--setLightMode()
	--setWindowColorMode(false);
	resetScreenSize();
end