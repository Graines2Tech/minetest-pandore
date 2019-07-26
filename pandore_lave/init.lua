--initialisation du mod
pandore_lave = {
	mod_name = "pandore_lave",				--nom du mod
	duree_lave = 5,							--durée avant disparition de la lave
	node_test = "default:dirt_with_grass",	--node à remplacer par de la lave
	rayon = 0,								--étendue de la lave (0=1 seul node)
	set_lave = function(player)				--place de la lave sous le joueur player
		local pos_under = vector.subtract(player:get_pos(),{x=0,y=1,z=0})
		local nom = player:get_player_name()
		local node_under = minetest.get_node(pos_under)
		if  node_under.name == pandore_lave.node_test then
			minetest.chat_send_all(nom .. ": le sol c'est de la lave!")
			for i=0-pandore_lave.rayon,0+pandore_lave.rayon do
				for j=0-pandore_lave.rayon,0+pandore_lave.rayon do
					minetest.set_node(vector.add(pos_under,{x=i,y=0,z=j}), {name = 'default:lava_source'})
				end
			end
			minetest.after(pandore_lave.duree_lave,function(pos)
				for i=0-pandore_lave.rayon,0+pandore_lave.rayon do
					for j=0-pandore_lave.rayon,0+pandore_lave.rayon do
						minetest.set_node(vector.add(pos_under,{x=i,y=0,z=j}), {name = pandore_lave.node_test})
					end
				end
			end,pos_under)
		else
			minetest.chat_send_all(nom .. " échappe à la lave, dommage...")
		end
	end
}

pandore.register_plaie(pandore_lave.mod_name,pandore_lave.set_lave)
