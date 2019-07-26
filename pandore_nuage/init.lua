--initialisation du mod
pandore_nuage = {
	mod_name = "pandore_nuage", 	--nom du mod
	dommages = 10,					--dommages infligées par les flèches
	vitesse_fleche = 10,			--vitesse de chute d'une flèche
	delai_fleches = 3,				--coefficient de délai entre deux flèches
	hauteur_nuage = 10,				--hauteur du nuage par rapport au joueur
	duree_nuage = 10,				--durée en secondes du nuage
	set_nuage = function(player)	--place un nuage au dessus du joueur player
		minetest.chat_send_all(player:get_player_name() .. ": tu es maudit!")
		local pos = vector.add(player:get_pos(),{x=0, y=pandore_nuage.hauteur_nuage, z=0})
		minetest.set_node(pos, {name =pandore_nuage.mod_name .. ":nuage_maudit"})
		minetest.set_node(vector.add(pos,{x=-1, y=0, z=0}), {name =pandore_nuage.mod_name .. ":nuage_maudit"})
		minetest.set_node(vector.add(pos,{x=1, y=0, z=0}), {name =pandore_nuage.mod_name .. ":nuage_maudit"})
		minetest.set_node(vector.add(pos,{x=0, y=0, z=-1}), {name =pandore_nuage.mod_name .. ":nuage_maudit"})
		minetest.set_node(vector.add(pos,{x=0, y=0, z=1}), {name =pandore_nuage.mod_name .. ":nuage_maudit"})
	end
}

minetest.register_node(pandore_nuage.mod_name .. ":nuage_maudit", {
    description = "vole et envoi des fleches enpoisones",
    tiles = {"nuage.png"},
	groups ={
		snappy = 2,
	},
    is_ground_content = false,
    sunlight_propagates = false,
    walkable = false,
    pointable = true,
    diggable = true,
    climbable = false,
    buildable_to =false,
    drawtype = "normal",
    light_source = 0,
	on_construct = function(pos)
		local timer=minetest.get_node_timer(pos)
		timer:set((math.random(pandore_nuage.delai_fleches)+8)/10,0)
		minetest.after(pandore_nuage.duree_nuage,function(pos)
			minetest.remove_node(pos)
		end,pos)
	end,
	on_timer = function (pos,elapsed)
		minetest.set_node(vector.add(pos,{x=0,y=-1,z=0}),{name=pandore_nuage.mod_name .. ":fleche"})
		local timer=minetest.get_node_timer(pos)
		timer:set((math.random(pandore_nuage.delai_fleches)+1)/10,0)
	end
 })
 
minetest.register_node(pandore_nuage.mod_name .. ":fleche", {
	description='enpoisoner',
	tiles={'fleche.png'},
	drawtype="plantlike",
	groups={
		not_in_creative_inventory=1,
	},
    is_ground_content = false,
    sunlight_propagates = false,
    walkable = false,
    pointable = false,
    diggable = false,
    climbable = false,
    buildable_to =false,
	damage_per_second = pandore_nuage.dommages,
	on_construct = function(pos)
		local timer=minetest.get_node_timer(pos)
		timer:set(1/pandore_nuage.vitesse_fleche,0)
	end,
	on_timer = function (pos,elapsed)
		local pos_under = vector.add(pos,{x=0,y=-1,z=0})
		local node_under = minetest.get_node(pos_under)
		if node_under.name == "air" then
			minetest.set_node(pos_under,{name=pandore_nuage.mod_name .. ":fleche"})
		end
		minetest.remove_node(pos)
	end
 }) 

pandore.register_plaie(pandore_nuage.mod_name,pandore_nuage.set_nuage)
