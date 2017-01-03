

local modpath = minetest.get_modpath("decay")

-- Add everything:
local modname = "decay"

-- thanks, google
function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

local downgrade = {
	["default:tree"] = modname..":tree_rotten",
}


--[[
local priv = minetest.get_player_privs("singleplayer")
priv.fly = true
priv.fast = true
minetest.set_player_privs("singleplayer", {fly=true, fast=true})
]]



local function register_decay(goodname, decayname)
	local def = deepcopy(minetest.registered_nodes[goodname])
	
	if def == nil then
		print("Decay: no such node '"..goodname.."'\n")
		return
	end
	
	if desc ~= nil then
		def.description = desc
	else
		def.description = "Rotten " .. def.description
	end
	
-- 	def.groups.falling_node = 1
	def.groups.decayed = 1
	
	minetest.register_node(modname .. ":" ..decayname.. "_1", def)

	-- level 2
	local def = deepcopy(def)
	
	if desc ~= nil then
		def.description = desc
	else
		def.description = "Badly Rotten " .. def.description
	end
	
	def.groups.falling_node = 1
	def.groups.decayed = 2
	
	minetest.register_node(modname .. ":" ..decayname.. "_2", def)
	
	downgrade[goodname] = modname .. ":" ..decayname.. "_1"
	downgrade[modname .. ":" ..decayname.. "_1"] = modname .. ":" ..decayname.. "_2"
end


register_decay("default:tree", "rotten_tree")

minetest.register_abm({
	nodenames = {"default:tree"},
-- 	neighbors = {"group:soil"},
	interval = 3,
	chance = 5,
--	catch_up = true,
	action = function(pos, node)
		
		minetest.set_node(pos, {name= downgrade[node.name]})
	end,
})


