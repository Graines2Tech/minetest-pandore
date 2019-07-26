--initialisation du mod
pandore_cage = {
	mod_name = "pandore_cage",				--nom du mod
	node_base = "default:obsidian_block",	--nom du node servant de sol et de toit à la cage
	node_paroi = "default:glass",			--nom du node servant de paroi à la cage
	node_interieur = "default:lava_source",	--nom du node servant de contenu à la cage
	delai_cage = 5,							--délai avant disparition de la cage
	set_cage = function(player)				--place une cage autour du joueur player
		local pos = player:get_pos()

		minetest.chat_send_all(player:get_player_name() .. ": bonne baignade!")

		--etage du bas
		for i=-2,2 do
			for a=-2,2 do
				minetest.set_node(vector.add(pos,{x=a,y=-1,z=i}),{name=pandore_cage.node_base})
			end
		end
		--etage du haut
		for i=-2,2 do
			for a=-2,2 do
				minetest.set_node(vector.add(pos,{x=a,y=3,z=i}),{name=pandore_cage.node_base})
			end
		end
		--etage milieu
		for b=0,2 do
			--paroi
			for i=-2,2 do
				minetest.set_node(vector.add(pos,{x=2,y=b,z=i}),{name=pandore_cage.node_paroi})
				minetest.set_node(vector.add(pos,{x=-2,y=b,z=i}),{name=pandore_cage.node_paroi})
			end
			for a=-1,1 do
				minetest.set_node(vector.add(pos,{x=a,y=b,z=2}),{name=pandore_cage.node_paroi})
				minetest.set_node(vector.add(pos,{x=a,y=b,z=-2}),{name=pandore_cage.node_paroi})
			end
			--contenu
			for i=-1,1 do
				for a=-1,1 do
					minetest.set_node(vector.add(pos,{x=a,y=b,z=i}),{name=pandore_cage.node_interieur})
				end
			end
		end
		
		--suppression de la cage
		minetest.after(pandore_cage.delai_cage,function(pos)
			pandore_cage.remove_cage(pos)
		end,pos)
	end,
	remove_cage = function(pos)				--supprimer une cage à la position pos
		for b=-1,3 do
			for i=-2,2 do
				for a=-2,2 do
					minetest.remove_node(vector.add(pos,{x=a,y=b,z=i}))
				end
			end
		end
	end,
}

pandore.register_plaie(pandore_cage.mod_name,pandore_cage.set_cage)

