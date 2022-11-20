--control.lua

global.factory_last_place = nil -- {x = 22, y = 55}

--все факторки на земле item-on-ground
local function factory_on_ground(play_er)
    local surface = game.surfaces[1]
    local found = false

    for key, ent in pairs(surface.find_entities_filtered({name = "item-on-ground"})) do
        if ent.stack.name:find("factory") ~= nul then
            found = true
            play_er.print(ent.stack.name .. " [gps=" .. ent.position.x .. "," .. ent.position.y .. "]")
        end
    end

    if found ~= true then
        play_er.print("На земле ничего не валяется")
    end
end

-- показать последнее место факторки
local function factory_last_place(play_er)
    if global.factory_last_place == nil then
        play_er.print("Координаты домика не найдены")
        return
    else
        play_er.print("[gps=" .. global.factory_last_place.x .. "," .. global.factory_last_place.y .. "]")
    end
end

-- разбор здания, проверка на факторку, на свободное место
script.on_event(
    defines.events.on_player_mined_entity,
    function(event)
        local play_er = game.players[event.player_index]
        local player_inv = play_er.get_main_inventory()

        --play_er.print("on_player_mined_entity")

        if event.entity.name:find("factory") ~= nul then
            --play_er.print(event.entity.name)
            if not player_inv.can_insert({name = "factory-1"}) then
                -- string.rep("1",22)
                -- "[img=warning-white]":rep(10)
                -- play_er.print( string.rep("[img=warning-white]", 10))

                play_er.print(
                    string.rep("[img=warning-white]", 10) ..
                        "АХТУНГ!!!! ДОМ НЕ ВЛЕЗ!!! АХТУНГ!!!!" .. string.rep("[img=warning-white]", 10),
                    {255, 000, 000}
                )
            end
        end
        --play_er.print(1)
        --factory_on_ground(play_er)
        --play_er.print(2)
    end
)

--[[ после постройки, проверка на факторку, сейв позиции
-- не работает почемут

8:19]Honktown: That's not right. Factorissimo might be destroying a proxy entity and rebuilding the "real one"
[8:19]Honktown: Watch script_raised_built, I'll see what factorissimo does. You have the right event, though maybe not "all" of them.
[8:20]Honktown: factorissimo2 or notnotmelon's fork?
[8:28]Honktown: notnotmelon's works for me the 2nd time [with on_builty_entity] (изменено)
[8:28]Priziv: it's in Factorissimo2 by MagmaMcFry
[8:29]Honktown: ...to be clear, how old is your game
[8:29]Honktown: version
[8:32]Honktown: I see it. Line 840 of control : 
            local newbuilding = entity.surface.create_entity{name=factory.layout.name, position=entity.position, force=factory.force}

You can add , raise_built=true as part of the table
[8:33]Honktown: Couple lines below (843) is where it destroys the original thing. There's no way around changing the original mod, unless there's something else "noisy" around the creation you can track. (изменено)
НОВОЕ
[8:34]Honktown: A build effect created_effect on the prototype factory.layout.name entity would make it noisy if you really didn't want to edit the original mod  


]]

--{defines.events.on_built_entity, defines.events.on_robot_built_entity}
script.on_event(
    defines.events.on_built_entity,
    function(event)
	
		game.print('on_built_entity')
		game.print(event.name)

	
        local play_er = game.players[event.player_index]
        --game.print(123)
        if event.created_entity.name:find("factory") ~= nul then
            global.factory_last_place = event.created_entity.position
            --play_er.print(event.created_entity.position)
            play_er.print("factory_last_place update")
        end
    end
)



script.on_event(
    defines.events.on_trigger_created_entity,
    function(event)
        game.print('on_trigger_created_entity')
    end
)


script.on_event(
    defines.events.on_script_trigger_effect,
    function(event)
        game.print('on_script_trigger_effect')
    end
)



script.on_event(
    "home_sweet_home-input",
    function(event)
        -- game.print(event.player_index)
        local play_er = game.players[event.player_index]
        --play_er.print("home_sweet_home-input")

        factory_on_ground(play_er)
        factory_last_place(play_er)
    end
)
