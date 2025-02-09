	--script by perrobot64
    IntroTextSize = 25    
IntroSubTextSize = 35 --tamaño del nombre de la cancion.
IntroSubText2Size = 25 --tamaño del nombre del compocitor.
IntroTagColor = '4ef514' --aqui va el color de la caja de color (box color).
IntroTagWidth = 15    
IntroTagWidth2 = 1
NombreDelCompocitor = ""
NombreDeLaCancion = "Dog-Song"
--script facil de configurar.

--actual script
function onCreate()
    --caja de color.
    makeLuaSprite('JukeBoxTag', 'boxs color', -423-IntroTagWidth, 200)
    setProperty('JukeBoxTag' .. '.color', getColorFromHex(IntroTagColor))
    setObjectCamera('JukeBoxTag', 'other')
    addLuaSprite('JukeBoxTag', true)

    --caja.
    makeLuaSprite('JukeBox', 'boxs', -713-IntroTagWidth2, 200)
    setObjectCamera('JukeBox', 'other')
    addLuaSprite('JukeBox', true)

    --texto del nombre de la cancion. 
    makeLuaText('JukeBoxSubText', songName, 300, -305-IntroTagWidth, 230)
    setTextAlignment('JukeBoxSubText', 'left')
    setObjectCamera('JukeBoxSubText', 'other')
    setTextSize('JukeBoxSubText', IntroSubTextSize)
    addLuaText('JukeBoxSubText')

    --texto del nombre del compocitor.
    makeLuaText('JukeBoxSubText2', NombreDelCompocitor, 300, -305-IntroTagWidth, 282)
    setTextAlignment('JukeBoxSubText2', 'left')
    setObjectCamera('JukeBoxSubText2', 'other')
    setTextSize('JukeBoxSubText2',IntroSubText2Size)
    addLuaText('JukeBoxSubText2')

    -- Leer y procesar el archivo de créditos
    checkTxtFile()
end

--funciones de movimiento.
function onSongStart()
    doTweenX('MoveInOne', 'JukeBoxTag', 0, 1, 'CircInOut')
    doTweenX('MoveInTwo', 'JukeBox', -55, 1, 'CircInOut')
    doTweenX('MoveInThree', 'JukeBoxText', 0, 1, 'CircInOut')
    doTweenX('MoveInFour', 'JukeBoxSubText', 0, 1, 'CircInOut')
    doTweenX('MoveInFive', 'JukeBoxSubText2', 0, 1, 'CircInOut')
    
    runTimer('JukeBoxWait', 3, 1)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'JukeBoxWait' then
        doTweenX('MoveOutOne', 'JukeBoxTag', -450, 1.5, 'CircInOut')
        doTweenX('MoveOutTwo', 'JukeBox', -750, 1.5, 'CircInOut')
        doTweenX('MoveOutThree', 'JukeBoxText', -450, 1.5, 'CircInOut')
        doTweenX('MoveOutFour', 'JukeBoxSubText', -450, 1.5, 'CircInOut')
        doTweenX('MoveOutFive', 'JukeBoxSubText2', -450, 1.5, 'CircInOut')
    end
end

function checkTxtFile()
    -- Asegúrate de que songName tenga un valor válido
    if not songName or songName == "" then
        debugPrint("songName no tiene un valor válido")
        return
    end
    
    -- Reemplazar espacios con guiones en songName
    local sanitizedSongName = string.gsub(songName, " ", "-")
    
    -- Ruta al archivo
    local filePath = "data/" .. sanitizedSongName .. "/credits.txt"
    --debugPrint("Ruta del archivo: " .. filePath)
    
    -- Leer el contenido del archivo utilizando getTextFromFile
    local content = getTextFromFile(filePath, false)
    
    if content then
       -- debugPrint("Contenido original: " .. content)
        
        -- Dividir el contenido en líneas
        for line in string.gmatch(content, "[^\r\n]+") do
            -- Dividir cada línea en partes usando "::" como delimitador
            local name, barColor = string.match(line, "([^::]+)::([^::]+)")
            
            if name and barColor then
                -- Reemplazar espacios con guiones en el nombre y el color de la barra
                name = string.gsub(name, " ", "-")
                barColor = string.gsub(barColor, " ", "-")
                
                -- Asignar valores extraídos a las variables adecuadas
                NombreDelCompocitor = name
                IntroTagColor = barColor
                
                -- Actualizar el texto del nombre del compositor
                setTextString('JukeBoxSubText2','por: '.. NombreDelCompocitor)
                
                -- Actualizar el color de la caja de color
                setProperty('JukeBoxTag' .. '.color', getColorFromHex(IntroTagColor))
                
                -- Imprimir los valores extraídos y modificados
                --debugPrint("Nombre del compositor: " .. NombreDelCompocitor .. ", Color de la barra: " .. IntroTagColor)
            else
                debugPrint("Formato de línea inválido: " .. line)
            end
        end
    else
        debugPrint("No se pudo leer el contenido del archivo")
    end 
end
