--initialisation du mod
pandore = {
	mod_name = "pandore",					--nom du mod
	nombre_plaies = 0,						--nombre total de plaies chargées
	plaies = {},							--liste des plaies disponibles
	limite = 30,							--rayon de la limite en block pour poser une boîte autour du joueur
	delai_max = 180,						--temps d'attente maximum en secondes entre le déclenchement de deux plaies
	delai_min = 60, 						--temps d'attente minimum en secondes entre le déclenchement de deux plaies
	delai_pop = 10,							--delai entre l'apparition du joueur et la création de sa boîte
	delai_plaie = 2,						--delai entre l'ouverture de la boîte et le lancement de la plaie
	players = {},							--liste associative des noms des joueurs et de la date de dernière activation d'une boîte
	register_plaie = function(name,fn,all)	--enregistre une plaie dans la liste de plaies; si all = true, la plaie s'exécute sur tous les joueurs (par défaut, all=false => joueur au hasard)
		all = all or false
		if pandore.plaies[name] == nil then
			pandore.plaies[name] = {
				action = fn,
				tous = al
			}
			pandore.nombre_plaies = pandore.nombre_plaies+1
			minetest.log("info","La plaie "..name.." a été chargée")
		else
			minetest.log("info","La plaie '"..name.."' a déjà été chargée.")
		end
	end,
	ouvrir = function(player_name)			--ouvre la boite de Pandore
		if pandore.nombre_plaies > 0 then
			local ouv_ok = true
			local player = ""
			if not (player_name == nil) then
				--un joueur a ouvert la boîte
				player = " par "..player_name
				local now = minetest.get_gametime()
				if pandore.players[player_name] == nil then
					pandore.players[player_name] = minetest.get_gametime()
				elseif (now - pandore.players[player_name]) > pandore.delai_min then
					pandore.players[player_name] = minetest.get_gametime()
				else
					ouv_ok = false
					minetest.chat_send_all("Il ne faut pas abuser de la boîte de Pandore, "..player_name.."...")
				end
			end
			if ouv_ok then
				--ouverture de la boîte
				local plaie_names = {}
				for i,v in pairs(pandore.plaies) do
					plaie_names[#plaie_names+1] = i
				end
				local plaie = pandore.plaies[plaie_names[math.random(#plaie_names)]]
				local joueurs = minetest.get_connected_players()
				if plaie.tous then
					minetest.chat_send_all("Une boîte de Pandore a été ouverte"..player.."!")
					minetest.after(pandore.delai_plaie,function(joueurs)
						for _, victime in ipairs(joueurs) do
							plaie.action(victime)
						end
					end,joueurs)
				else
					local victime = joueurs[math.random(#joueurs)]
					minetest.chat_send_player(victime:get_player_name(),"Une boîte de Pandore a été ouverte pour toi"..player.."!")
					minetest.after(pandore.delai_plaie,plaie.action,victime)
				end
			end
		end
	end,
	ajouter = function(player)			--ajoute une boîte de Pandore près du joueur player
		if pandore.nombre_plaies > 0 then
			local nom = player:get_player_name()
			local pos = player:get_pos()
			local pos_inf = vector.subtract(pos,pandore.limite)
			local pos_sup = vector.add(pos,pandore.limite)
			local pos_boites = minetest.find_nodes_in_area_under_air(pos_inf, pos_sup,{"pandore:boite"})
			if #pos_boites == 0 then
				local pos_sols = minetest.find_nodes_in_area_under_air(pos_inf, pos_sup,{"group:soil"})
				if #pos_sols > 0 then
					local pos_boite = vector.add(pos_sols[math.random(#pos_sols)],{x=0,y=1,z=0})
					minetest.set_node(pos_boite, {name ='pandore:boite'})
					minetest.log("info","Une boîte de Pandore a été posée à "..dump(pos_boite))
					minetest.chat_send_all("Bienvenue "..nom..", une boîte de Pandore a été déposée pour toi!")
				else
					minetest.log("info","Aucune boîte de Pandore posée pour "..nom)
				end
			end
		end
	end,
}

-- on place une boîte de Pandore après le chargement des joueurs
minetest.register_on_joinplayer(function(player)
	minetest.after(pandore.delai_pop,pandore.ajouter,player)
end)

--la boîte de Pandore
minetest.register_node(pandore.mod_name..":boite", {
    description = "La boîte de Pandore",
    tiles = {"pandore.png"},
    is_ground_content = true,
    groups ={not_in_creative_inventory = 1},
    sunlight_propagates = false,
    walkable = false,
    pointable = true,
    diggable = false,
    climbable = false,
    buildable_to =false,
    drawtype = "normal",
    light_source = 2,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		pandore.ouvrir(player:get_player_name())
	end,
	on_construct = function(pos)
		local timer=minetest.get_node_timer(pos)
		timer:set((math.random(pandore.delai_max - pandore.delai_min) + pandore.delai_min),0)
	end,
	on_timer = function(pos, elapsed)
		pandore.ouvrir()
	end
 })
