--initialisation du mod
pandore_ivy = {
	mod_name = "pandore_ivy",				--nom du mod
	delai_expansion = 15,					--délai d'expansion de la plaie
	rayon_max_expansion = 10,				--rayon maximal d'expansion de la plaie
	dommages = 20,							--dommages infligés par la plaie
	delai_remede = 2,						--délai d'expansion du remède
	rayon_max_remede = 10,					--rayon maximal d'expansion du remède
	delai_suppression = 5,					--délai avant suppression du remede
	node_test = "default:dirt_with_grass",	--node à tester avant de placer la plaie	
	set_ivy = function(player)				--place une plante au pied du joueur player
		local pos_under = vector.subtract(player:get_pos(),{x=0,y=1,z=0})
		local node_under = minetest.get_node(pos_under)
		local nom = player:get_player_name()
		if  node_under.name == pandore_ivy.node_test then
			minetest.chat_send_all(nom .. ": tu vas te faire planter...")
			minetest.set_node(pos, {name =pandore_ivy.mod_name..":ivy"})
		else
			minetest.chat_send_all(nom .. " ne se trouve pas sur l'herbe, dommage...")
		end
	end,
}

minetest.register_node(pandore_ivy.mod_name .. ":ivy", {
    description = "Ivy",
    tiles = {"ivy.png"},
    is_ground_content = false,
    groups ={
		snappy = 2, 
		choppy = 2, 
		oddly_breakable_by_hand = 3,
		flammable = 18, 
	},
    sunlight_propagates = false,
    walkable = false,
    pointable = true,
    diggable = true,
    climbable = false,
    buildable_to =true,
    drawtype = "plantlike",
    light_source = 0,
    drop = pandore_ivy.mod_name .. ":ivy",
    damage_per_second = pandore_ivy.dommages,
	on_construct = function(pos)
		local timer=minetest.get_node_timer(pos)
		timer:set(math.random(pandore_ivy.delai_expansion) + 15,0)
	end,
	on_timer = function(pos, elapsed)
		local pos_grasss = minetest.find_nodes_in_area_under_air(vector.add(pos,{x=-math.random(pandore_ivy.rayon_max_expansion),y=-math.random(pandore_ivy.rayon_max_expansion),z=-math.random(pandore_ivy.rayon_max_expansion)}),vector.add(pos,{x=math.random(pandore_ivy.rayon_max_expansion),y=math.random(pandore_ivy.rayon_max_expansion),z=math.random(pandore_ivy.rayon_max_expansion)}),{pandore_ivy.node_test})
		if #pos_grasss > 0 then
			minetest.set_node(vector.add(pos_grasss[math.random(#pos_grasss)],{x=0,y=1,z=0}), {name =pandore_ivy.mod_name..":ivy"})
			local timer=minetest.get_node_timer(pos)
			timer:set(math.random(pandore_ivy.delai_expansion) + 15,0)
		end
	end

 })
 
minetest.register_craft({
    type = "shapeless",
    output = pandore_ivy.mod_name .. ":ivy2",
	recipe = {pandore_ivy.mod_name .. ":ivy", "fire:flint_and_steel"},
 })
 
minetest.register_node(pandore_ivy.mod_name .. ":ivy2", {
    description = "Ivy Brulée",
    tiles = {"ivy2.png"},
    is_ground_content = false,
    groups ={
		snappy = 2, 
		choppy = 2, 
		oddly_breakable_by_hand = 3,
		flammable = 3
	},
    sunlight_propagates = false,
    walkable = false,
    pointable = true,
    diggable = true,
    climbable = false,
    buildable_to =true,
    drawtype = "plantlike",
    light_source = 0,
    drop = pandore_ivy.mod_name .. ":ivy2",
    damage_per_second = 0,
	on_construct = function(pos)
		local timer=minetest.get_node_timer(pos)
		timer:set(pandore_ivy.delai_suppression,0)
		minetest.after(pandore_ivy.delai_remede,function(pos)
			local pos_inf = vector.add(pos,{x=-math.random(pandore_ivy.rayon_max_remede),y=-math.random(pandore_ivy.rayon_max_remede),z=-math.random(pandore_ivy.rayon_max_remede)})
			local pos_sup = vector.add(pos,{x=math.random(pandore_ivy.rayon_max_remede),y=math.random(pandore_ivy.rayon_max_remede),z=math.random(pandore_ivy.rayon_max_remede)})
			local pos_ivys = minetest.find_nodes_in_area(pos_inf,pos_sup,{pandore_ivy.mod_name..":ivy"})
			for i,v in ipairs(pos_ivys) do
				minetest.set_node(v,{name=pandore_ivy.mod_name..":ivy2"})
			end
		end,pos)
	end,
	on_timer = function(pos, elapsed)
		minetest.remove_node(pos)
	end

 })

pandore.register_plaie(pandore_ivy.mod_name,pandore_ivy.set_ivy)

