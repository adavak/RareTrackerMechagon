-- Redefine often used functions locally.
local GetLocale = GetLocale

-- ####################################################################
-- ##                          Static Data                           ##
-- ####################################################################

-- The zones in which the addon is active.
RTM.target_zones = {}
RTM.target_zones[1462] = true
RTM.target_zones[1522] = true

-- NPCs that are banned during shard detection.
-- Player followers sometimes spawn with the wrong zone id.
RTM.banned_NPC_ids = {}
RTM.banned_NPC_ids[154297] = true
RTM.banned_NPC_ids[150202] = true
RTM.banned_NPC_ids[154304] = true
RTM.banned_NPC_ids[152108] = true
RTM.banned_NPC_ids[151300] = true
RTM.banned_NPC_ids[151310] = true
RTM.banned_NPC_ids[69792] = true
RTM.banned_NPC_ids[62821] = true
RTM.banned_NPC_ids[62822] = true
RTM.banned_NPC_ids[32639] = true
RTM.banned_NPC_ids[32638] = true
RTM.banned_NPC_ids[89715] = true

-- Simulate a set data structure for efficient existence lookups.
function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

-- The ids of the rares the addon monitors.
RTM.rare_ids = {
	151934, -- "Arachnoid Harvester"
	154342, -- "Arachnoid Harvester (F)"
	--150394, -- "Armored Vaultbot"
	151308, -- "Boggac Skullbash"
	153200, -- "Boilburn"
	152001, -- "Bonepicker"
	154739, -- "Caustic Mechaslime"
	152570, -- "Crazed Trogg (Blue)"
	152569, -- "Crazed Trogg (Green)"
	149847, -- "Crazed Trogg (Orange)"
	151569, -- "Deepwater Maw"
	--155060, -- "Doppel Ganger"
	150342, -- "Earthbreaker Gulroc"
	154153, -- "Enforcer KX-T57"
	151202, -- "Foul Manifestation"
	135497, -- "Fungarian Furor"
	153228, -- "Gear Checker Cogstar"
	153205, -- "Gemicide"
	154701, -- "Gorged Gear-Cruncher"
	151684, -- "Jawbreaker"
	152007, -- "Killsaw"
	151933, -- "Malfunctioning Beastbot"
	151124, -- "Mechagonian Nullifier"
	151672, -- "Mecharantula"
	8821909, -- "Mecharantula (F)"
	151627, -- "Mr. Fixthis"
	153206, -- "Ol' Big Tusk"
	151296, -- "OOX-Avenger/MG"
	152764, -- "Oxidized Leachbeast"
	151702, -- "Paol Pondwader"
	150575, -- "Rumblerocks"
	152182, -- "Rustfeather"
	155583, -- "Scrapclaw"
	150937, -- "Seaspit"
	153000, -- "Sparkqueen P'Emp"
	153226, -- "Steel Singer Freza"
	152113, -- "The Kleptoboss"
	154225, -- "The Rusty Prince (F)"
	151623, -- "The Scrap King (M)"
	151625, -- "The Scrap King"
	151940, -- "Uncle T'Rogg"
}

-- Create a table, such that we can look up a rare in constant time.
RTM.rare_ids_set = Set(RTM.rare_ids)

-- Get the rare names in the correct localization.
RTM.localization = GetLocale()
RTM.rare_names = {}

if RTM.localization == "enUS" or RTM.localization == "enGB" then
    -- The names to be displayed in the frames and general chat messages for English (US) localization.
    RTM.rare_names[151934] = "Arachnoid Harvester"
    RTM.rare_names[154342] = "Arachnoid Harvester (F)"
    RTM.rare_names[155060] = "Doppel Ganger"
    RTM.rare_names[152113] = "The Kleptoboss (CC88)"
    RTM.rare_names[154225] = "The Rusty Prince (F)"
    RTM.rare_names[151623] = "The Scrap King (M)"
    RTM.rare_names[151625] = "The Scrap King"
    RTM.rare_names[151940] = "Uncle T'Rogg"
    RTM.rare_names[150394] = "Armored Vaultbot"
    RTM.rare_names[153200] = "Boilburn (JD41)"
    RTM.rare_names[151308] = "Boggac Skullbash"
    RTM.rare_names[152001] = "Bonepicker"
    RTM.rare_names[154739] = "Caustic Mechaslime (CC73)"
    RTM.rare_names[149847] = "Crazed Trogg (Orange)"
    RTM.rare_names[152569] = "Crazed Trogg (Green)"
    RTM.rare_names[152570] = "Crazed Trogg (Blue)"
    RTM.rare_names[151569] = "Deepwater Maw"
    RTM.rare_names[150342] = "Earthbreaker Gulroc (TR35)"
    RTM.rare_names[154153] = "Enforcer KX-T57"
    RTM.rare_names[151202] = "Foul Manifestation"
    RTM.rare_names[135497] = "Fungarian Furor"
    RTM.rare_names[153228] = "Gear Checker Cogstar"
    RTM.rare_names[153205] = "Gemicide (JD99)"
    RTM.rare_names[154701] = "Gorged Gear-Cruncher (CC61)"
    RTM.rare_names[151684] = "Jawbreaker"
    RTM.rare_names[152007] = "Killsaw"
    RTM.rare_names[151933] = "Malfunctioning Beastbot"
    RTM.rare_names[151124] = "Mechagonian Nullifier"
    RTM.rare_names[151672] = "Mecharantula"
    RTM.rare_names[8821909] = "Mecharantula (F)"
    RTM.rare_names[151627] = "Mr. Fixthis"
    RTM.rare_names[151296] = "OOX-Avenger/MG"
    RTM.rare_names[153206] = "Ol' Big Tusk (TR28)"
    RTM.rare_names[152764] = "Oxidized Leachbeast"
    RTM.rare_names[151702] = "Paol Pondwader"
    RTM.rare_names[150575] = "Rumblerocks"
    RTM.rare_names[152182] = "Rustfeather"
    RTM.rare_names[155583] = "Scrapclaw"
    RTM.rare_names[150937] = "Seaspit"
    RTM.rare_names[153000] = "Sparkqueen P'Emp"
    RTM.rare_names[153226] = "Steel Singer Freza"

elseif RTM.localization == "deDE" then
    -- The names to be displayed in the frames and general chat messages for German localization.
    RTM.rare_names[151934] = "Arachnoider Ernter"
    RTM.rare_names[154342] = "Arachnoider Ernter (F)"
    RTM.rare_names[155060] = "Doppelgänger"
    RTM.rare_names[152113] = "Der Kleptoboss (CC88)"
    RTM.rare_names[154225] = "Der rostige Prinz (F)"
    RTM.rare_names[151623] = "Der Schrottkönig (M)"
    RTM.rare_names[151625] = "Der Schrottkönig"
    RTM.rare_names[151940] = "Onkel T'Rogg"
    RTM.rare_names[150394] = "Panzertresorbot"
    RTM.rare_names[153200] = "Siedebrand (JD41)"
    RTM.rare_names[151308] = "Boggac Schädelrums"
    RTM.rare_names[152001] = "Knochenpicker"
    RTM.rare_names[154739] = "Ätzender Mechaschleim (CC73)"
    RTM.rare_names[149847] = "Wahnsinniger Trogg (Orange)"
    RTM.rare_names[152569] = "Wahnsinniger Trogg (Grün)"
    RTM.rare_names[152570] = "Wahnsinniger Trogg (Blau)"
    RTM.rare_names[151569] = "Tiefseeschlund"
    RTM.rare_names[150342] = "Erdbrecher Gulroc (TR35)"
    RTM.rare_names[154153] = "Vollstrecker KX-T57"
    RTM.rare_names[151202] = "Üble Manifestation"
    RTM.rare_names[135497] = "Fungianischer Furor"
    RTM.rare_names[153228] = "Getriebeprüfer Radstern"
    RTM.rare_names[153205] = "Splitterzid (JD99)"
    RTM.rare_names[154701] = "Vollgefressener Ritzelknabberer (CC61)"
    RTM.rare_names[151684] = "Kieferbrecher"
    RTM.rare_names[152007] = "Todessäge"
    RTM.rare_names[151933] = "Defekter Gorillabot"
    RTM.rare_names[151124] = "Mechagonischer Nullifizierer"
    RTM.rare_names[151672] = "Mecharantel"
    RTM.rare_names[8821909] = "Mecharantel (F)"
    RTM.rare_names[151627] = "Herr Richter"
    RTM.rare_names[151296] = "OOX-Rächer/MG"
    RTM.rare_names[153206] = "Alter Großhauer (TR28)"
    RTM.rare_names[152764] = "Oxidierte Egelbestie"
    RTM.rare_names[151702] = "Paol Teichwandler"
    RTM.rare_names[150575] = "Rumpelfels"
    RTM.rare_names[152182] = "Rostfeder"
    RTM.rare_names[155583] = "Schrottklaue"
    RTM.rare_names[150937] = "Seespuck"
    RTM.rare_names[153000] = "Funkenkönigin P'Emp"
    RTM.rare_names[153226] = "Stahlsängerin Freza"

elseif RTM.localization == "frFR" then
    -- The names to be displayed in the frames and general chat messages for French localization.
    RTM.rare_names[151934] = "Arachnoïde moissonneur"
    RTM.rare_names[154342] = "Arachnoïde moissonneur (F)"
    RTM.rare_names[155060] = "Sosie"
    RTM.rare_names[152113] = "Le Cleptoboss (CC88)"
    RTM.rare_names[154225] = "Le Prince de la rouille (F)"
    RTM.rare_names[151623] = "Le roi-boulon (M)"
    RTM.rare_names[151625] = "Le roi-boulon"
    RTM.rare_names[151940] = "Oncle T'Rogg"
    RTM.rare_names[150394] = "Robot-coffre blindé"
    RTM.rare_names[153200] = "Brûlebouille (JD41)"
    RTM.rare_names[151308] = "Boggac Cogne-Crâne"
    RTM.rare_names[152001] = "Croc'os"
    RTM.rare_names[154739] = "Mécagelée caustique (CC73)"
    RTM.rare_names[149847] = "Trogg affolé (Orange)"
    RTM.rare_names[152569] = "Trogg affolé (Vert)"
    RTM.rare_names[152570] = "Trogg affolé (Bleu)"
    RTM.rare_names[151569] = "Gueule des eaux profondes"
    RTM.rare_names[150342] = "Brise-terre Gulroc (TR35)"
    RTM.rare_names[154153] = "Massacreur KX-T57"
    RTM.rare_names[151202] = "Manifestation infâme"
    RTM.rare_names[135497] = "Fongicien furieux"
    RTM.rare_names[153228] = "Pignonologue Clétoile"
    RTM.rare_names[153205] = "Gemmicide (JD99)"
    RTM.rare_names[154701] = "Croque-écrou gavé (CC61)"
    RTM.rare_names[151684] = "Mâchebrise"
    RTM.rare_names[152007] = "Autopscie"
    RTM.rare_names[151933] = "Robot-bête défectueux"
    RTM.rare_names[151124] = "Annulateur mécagonien"
    RTM.rare_names[151672] = "Mécatarentule"
    RTM.rare_names[8821909] = "Mécatarentule (F)"
    RTM.rare_names[151627] = "M. Réparetout"
    RTM.rare_names[151296] = "Vengeur-OOX/MG"
    RTM.rare_names[153206] = "Vieux Grande-Défense (TR28)"
    RTM.rare_names[152764] = "Lixiviaure oxydé"
    RTM.rare_names[151702] = "Paol Pêchemare"
    RTM.rare_names[150575] = "Gronderoche"
    RTM.rare_names[152182] = "Rouille-Plume"
    RTM.rare_names[155583] = "Récupince"
    RTM.rare_names[150937] = "Bruinemer"
    RTM.rare_names[153000] = "Électreine P’omp"
    RTM.rare_names[153226] = "Chante-acier Freza"

elseif RTM.localization == "esES" or RTM.localization == "esMX" then
    -- The names to be displayed in the frames and general chat messages for Spanish (Spain) localization.
    RTM.rare_names[151934] = "Cosechadora arácnida"
    RTM.rare_names[154342] = "Cosechadora arácnida (F)"
    RTM.rare_names[155060] = "Doble"
    RTM.rare_names[152113] = "El Cleptojefe (CC88)"
    RTM.rare_names[154225] = "El príncipe oxidado (F)"
    RTM.rare_names[151623] = "El rey de la chatarra (M)"
    RTM.rare_names[151625] = "El rey de la chatarra"
    RTM.rare_names[151940] = "Tío T'Rogg"
    RTM.rare_names[150394] = "Roboarcón acorazado"
    RTM.rare_names[153200] = "Ardequema (JD41)"
    RTM.rare_names[151308] = "Boggac Hundecráneos"
    RTM.rare_names[152001] = "Limpiahuesos"
    RTM.rare_names[154739] = "Mecababosa cáustica (CC73)"
    RTM.rare_names[149847] = "Trogg enloquecido (Naranja)"
    RTM.rare_names[152569] = "Trogg enloquecido (Verde)"
    RTM.rare_names[152570] = "Trogg enloquecido (Azul)"
    RTM.rare_names[151569] = "Fauce Aguahonda"
    RTM.rare_names[150342] = "Rompesuelos Gulroc (TR35)"
    RTM.rare_names[154153] = "Déspota KX-T57"
    RTM.rare_names[151202] = "Manifestación nauseabunda"
    RTM.rare_names[135497] = "Furor fúngico"
    RTM.rare_names[153228] = "Pruebachismes Dientestrella"
    RTM.rare_names[153205] = "Gemicida (JD99)"
    RTM.rare_names[154701] = "Mascaengranajes atiborrado (CC61)"
    RTM.rare_names[151684] = "Desgarracaras"
    RTM.rare_names[152007] = "Sierrasesina"
    RTM.rare_names[151933] = "Bestia robot estropeada"
    RTM.rare_names[151124] = "Nulificador de Mecandria"
    RTM.rare_names[151672] = "Mecatarántula"
    RTM.rare_names[8821909] = "Mecatarántula (F)"
    RTM.rare_names[151627] = "Sr. Apaño"
    RTM.rare_names[151296] = "OOX-Vengador/MG"
    RTM.rare_names[153206] = "Viejo Colmillón (TR28)"
    RTM.rare_names[152764] = "Bestia lixiviadora oxidada"
    RTM.rare_names[151702] = "Paol Vadeaestanques"
    RTM.rare_names[150575] = "Embrollarrocas"
    RTM.rare_names[152182] = "Alarroña"
    RTM.rare_names[155583] = "Garrachatarra"
    RTM.rare_names[150937] = "Escupemar"
    RTM.rare_names[153000] = "Chisparreina P'Emp"
    RTM.rare_names[153226] = "Cantoacero Freza"

elseif RTM.localization == "itIT" then
    -- The names to be displayed in the frames and general chat messages for Italian localization.
    RTM.rare_names = {}
    RTM.rare_names[151934] = "Raccoglitore Aracnoide"
    RTM.rare_names[154342] = "Raccoglitore Aracnoide (F)"
    RTM.rare_names[155060] = "Clone"
    RTM.rare_names[152113] = "Il Cleptoboss (CC88)"
    RTM.rare_names[154225] = "Il Principe Arrugginito (F)"
    RTM.rare_names[151623] = "Re degli Scarti (M)"
    RTM.rare_names[151625] = "Re degli Scarti"
    RTM.rare_names[151940] = "Zio T'rogg"
    RTM.rare_names[150394] = "Robobanca Corazzata"
    RTM.rare_names[153200] = "Bruciatura Ribollente (JD41)"
    RTM.rare_names[151308] = "Boggac Spaccacrani"
    RTM.rare_names[152001] = "Stuzzicaossa"
    RTM.rare_names[154739] = "Meccamelma Caustica (CC73)"
    RTM.rare_names[149847] = "Trogg Frenetico (Acancio)"
    RTM.rare_names[152569] = "Trogg Frenetico (Verde)"
    RTM.rare_names[152570] = "Trogg Frenetico (Blu)"
    RTM.rare_names[151569] = "Fauce Acquafonda"
    RTM.rare_names[150342] = "Spaccaterra Gulroc (TR35)"
    RTM.rare_names[154153] = "Agente KX-T57"
    RTM.rare_names[151202] = "Manifestazione Vile"
    RTM.rare_names[135497] = "Fungariano Furioso"
    RTM.rare_names[153228] = "Controllore Sgranastelle"
    RTM.rare_names[153205] = "Gemmicida (JD99)"
    RTM.rare_names[154701] = "Tritaviti Rimpinzato (CC61)"
    RTM.rare_names[151684] = "Rompifauci"
    RTM.rare_names[152007] = "Squarciamorte"
    RTM.rare_names[151933] = "Robobestia Malfunzionante"
    RTM.rare_names[151124] = "Abolitore Meccagoniano"
    RTM.rare_names[151672] = "Meccanantola"
    RTM.rare_names[151627] = "Ser Aggiustatutto"
    RTM.rare_names[8821909] = "Ser Aggiustatutto (F)"
    RTM.rare_names[151296] = "OOX-Vendicatore/MG"
    RTM.rare_names[153206] = "Vecchio Zannone (TR28)"
    RTM.rare_names[152764] = "Percolabestia Ossidata"
    RTM.rare_names[151702] = "Paol Acquastagna"
    RTM.rare_names[150575] = "Tuonarocce"
    RTM.rare_names[152182] = "Piumaruggine"
    RTM.rare_names[155583] = "Scartachela"
    RTM.rare_names[150937] = "Sputaspuma"
    RTM.rare_names[153000] = "Regina delle Scintille M'IEM"
    RTM.rare_names[153226] = "Cantacciaio Freza"

elseif RTM.localization == "ptPT" or RTM.localization == "ptBR" then
    -- The names to be displayed in the frames and general chat messages for Portuguese (European) localization.
    RTM.rare_names[151934] = "Ceifador Aracnídeo"
    RTM.rare_names[154342] = "Ceifador Aracnídeo (F)"
    RTM.rare_names[155060] = "Doppel Gângster"
    RTM.rare_names[152113] = "O Cleptochefe (CC88)"
    RTM.rare_names[154225] = "O Príncipe Ferrugem (F)"
    RTM.rare_names[151623] = "O Rei da Sucata (M)"
    RTM.rare_names[151625] = "O Rei da Sucata"
    RTM.rare_names[151940] = "Tio T'rogg"
    RTM.rare_names[150394] = "Cofremático Blindado"
    RTM.rare_names[153200] = "Queimadura de Óleo (JD41)"
    RTM.rare_names[151308] = "Brejac Broca-crânio"
    RTM.rare_names[152001] = "Limpa-osso"
    RTM.rare_names[154739] = "Mecavisgo Cáustico (CC73)"
    RTM.rare_names[149847] = "Trogg Enlouquecido (Laranja)"
    RTM.rare_names[152569] = "Trogg Enlouquecido (Verde)"
    RTM.rare_names[152570] = "Trogg Enlouquecido (Azul)"
    RTM.rare_names[151569] = "Bocarra de Águas Profundas"
    RTM.rare_names[150342] = "Rompe-terra Gulroc (TR35)"
    RTM.rare_names[154153] = "Impositor KX-T57"
    RTM.rare_names[151202] = "Manifestação Atroz"
    RTM.rare_names[135497] = "Furor Fungoriano"
    RTM.rare_names[153228] = "Inspetor de Engrenagens Multifresa"
    RTM.rare_names[153205] = "Gemocida (JD99)"
    RTM.rare_names[154701] = "Esmaga-engrenagens Empanturrado (CC61)"
    RTM.rare_names[151684] = "Quebra-queixo"
    RTM.rare_names[152007] = "Serra Mortífera"
    RTM.rare_names[151933] = "Bichômato Defeituoso"
    RTM.rare_names[151124] = "Nulificador Gnomecânico"
    RTM.rare_names[151672] = "Mecarântula"
    RTM.rare_names[8821909] = "Mecarântula (F)"
    RTM.rare_names[151627] = "Sr. Quebragalho"
    RTM.rare_names[151296] = "OOX-Vingadora/MG"
    RTM.rare_names[153206] = "Colmilhão Velho (TR28)"
    RTM.rare_names[152764] = "Monstro-peneira Oxidado"
    RTM.rare_names[151702] = "Paol Chafurdágua"
    RTM.rare_names[150575] = "Troapedras"
    RTM.rare_names[152182] = "Ferrujão"
    RTM.rare_names[155583] = "Pinçucata"
    RTM.rare_names[150937] = "Gota-do-mar"
    RTM.rare_names[153000] = "Rainha Fagulhosa Pem'P"
    RTM.rare_names[153226] = "Freza Canora de Aço"

elseif RTM.localization == "ruRU" then
    -- The names to be displayed in the frames and general chat messages for Portuguese (Brazilian) localization.
    RTM.rare_names[151934] = "Арахноид-пожинатель"
    RTM.rare_names[154342] = "Арахноид-пожинатель (F)"
    RTM.rare_names[155060] = "Двойник"
    RTM.rare_names[152113] = "Клептобосс (CC88)"
    RTM.rare_names[154225] = "Ржавый принц (F)"
    RTM.rare_names[151623] = "Король-над-свалкой (M)"
    RTM.rare_names[151625] = "Король-над-свалкой"
    RTM.rare_names[151940] = "Дядюшка Т'Рогг"
    RTM.rare_names[150394] = "Бронированный сейфобот"
    RTM.rare_names[153200] = "Ошпар (JD41)"
    RTM.rare_names[151308] = "Боггак Черепокол"
    RTM.rare_names[152001] = "Костегрыз"
    RTM.rare_names[154739] = "Едкий механослизень (CC73)"
    RTM.rare_names[149847] = "Обезумевший трогг (оранжевый)"
    RTM.rare_names[152569] = "Обезумевший трогг (зеленый)"
    RTM.rare_names[152570] = "Обезумевший трогг (синий)"
    RTM.rare_names[151569] = "Глубоководный пожиратель"
    RTM.rare_names[150342] = "Землекрушитель Гулрок (TR35)"
    RTM.rare_names[154153] = "Каратель KX-T57"
    RTM.rare_names[151202] = "Гнусноструй"
    RTM.rare_names[135497] = "Грозный грибостраж"
    RTM.rare_names[153228] = "Инспектор экипировки Искраддон"
    RTM.rare_names[153205] = "Драгоцид (JD99)"
    RTM.rare_names[154701] = "Прожорливый пожиратель шестеренок (CC61)"
    RTM.rare_names[151684] = "Зубодробитель"
    RTM.rare_names[152007] = "Циркулятор"
    RTM.rare_names[151933] = "Неисправный гориллобот"
    RTM.rare_names[151124] = "Мехагонский нейтрализатор"
    RTM.rare_names[151672] = "Мехарантул"
    RTM.rare_names[8821909] = "Мехарантул (F)"
    RTM.rare_names[151627] = "Господин Починятор"
    RTM.rare_names[151296] = "КПХ-Мститель/МГ"
    RTM.rare_names[153206] = "Старина Бивень (TR28)"
    RTM.rare_names[152764] = "Порождение сточной жижи"
    RTM.rare_names[151702] = "Паол Пруд-по-колено"
    RTM.rare_names[150575] = "Маховище"
    RTM.rare_names[152182] = "Ржавое Перо"
    RTM.rare_names[155583] = "Хламокоготь"
    RTM.rare_names[150937] = "Солеплюй"
    RTM.rare_names[153000] = "Паучиха на прокачку"
    RTM.rare_names[153226] = "Певица стали Фреза"

elseif RTM.localization == "zhCN" then
    -- The names to be displayed in the frames and general chat messages for Chinese (zhCN) localization.
    RTM.rare_names[151934] = "蜘蛛收割者"
    RTM.rare_names[154342] = "蜘蛛收割者 (平行)"
    RTM.rare_names[155060] = "同行者"
    RTM.rare_names[152113] = "防窃者首领 (CC88)"
    RTM.rare_names[154225] = "锈痕王子 (F)"
    RTM.rare_names[151623] = "废铁之王 (一阶段)"
    RTM.rare_names[151625] = "废铁之王"
    RTM.rare_names[151940] = "阿叔提罗格"
    RTM.rare_names[150394] = "重装保险柜机"
    RTM.rare_names[153200] = "燃沸 (JD41)"
    RTM.rare_names[151308] = "波加克·砸颅"
    RTM.rare_names[152001] = "剔骨者"
    RTM.rare_names[154739] = "腐蚀性的机甲软泥 (CC73)"
    RTM.rare_names[149847] = "疯狂的穴居人 (橙色)"
    RTM.rare_names[152569] = "疯狂的穴居人 (绿色)"
    RTM.rare_names[152570] = "疯狂的穴居人 (蓝色)"
    RTM.rare_names[151569] = "深水之喉"
    RTM.rare_names[150342] = "碎地者高洛克 (TR35)"
    RTM.rare_names[154153] = "执行者KX-T57"
    RTM.rare_names[151202] = "污秽具象"
    RTM.rare_names[135497] = "真菌人狂热者"
    RTM.rare_names[153228] = "齿轮检查者齿星"
    RTM.rare_names[153205] = "宝石粉碎者 (JD99)"
    RTM.rare_names[154701] = "饱食的齿轮啮咬者 (CC61)"
    RTM.rare_names[151684] = "断腭者"
    RTM.rare_names[152007] = "夺命锯士"
    RTM.rare_names[151933] = "失控的机械兽"
    RTM.rare_names[151124] = "麦卡贡中和者"
    RTM.rare_names[151672] = "机甲狼蛛"
    RTM.rare_names[151627] = "阿修先生"
    RTM.rare_names[8821909] = "阿修先生 (平行)"
    RTM.rare_names[151296] = "OOX-复仇者/MG"
    RTM.rare_names[153206] = "老獠 (TR28)"
    RTM.rare_names[152764] = "氧化沥兽"
    RTM.rare_names[151702] = "鲍尔·涉塘者"
    RTM.rare_names[150575] = "震岩"
    RTM.rare_names[152182] = "锈羽"
    RTM.rare_names[155583] = "废爪"
    RTM.rare_names[150937] = "唾海"
    RTM.rare_names[153000] = "火花女王皮恩普"
    RTM.rare_names[153226] = "钢铁歌手弗莉萨"
    
elseif RTM.localization == "zhTW" then
    -- The names to be displayed in the frames and general chat messages for English (US) localization.
    RTM.rare_names[151934] = "Arachnoid Harvester"
    RTM.rare_names[154342] = "Arachnoid Harvester (F)"
    RTM.rare_names[155060] = "Doppel Ganger"
    RTM.rare_names[152113] = "The Kleptoboss (CC88)"
    RTM.rare_names[154225] = "The Rusty Prince (F)"
    RTM.rare_names[151623] = "The Scrap King (M)"
    RTM.rare_names[151625] = "The Scrap King"
    RTM.rare_names[151940] = "Uncle T'Rogg"
    RTM.rare_names[150394] = "Armored Vaultbot"
    RTM.rare_names[153200] = "Boilburn (JD41)"
    RTM.rare_names[151308] = "Boggac Skullbash"
    RTM.rare_names[152001] = "Bonepicker"
    RTM.rare_names[154739] = "Caustic Mechaslime (CC73)"
    RTM.rare_names[149847] = "Crazed Trogg (Orange)"
    RTM.rare_names[152569] = "Crazed Trogg (Green)"
    RTM.rare_names[152570] = "Crazed Trogg (Blue)"
    RTM.rare_names[151569] = "Deepwater Maw"
    RTM.rare_names[150342] = "Earthbreaker Gulroc (TR35)"
    RTM.rare_names[154153] = "Enforcer KX-T57"
    RTM.rare_names[151202] = "Foul Manifestation"
    RTM.rare_names[135497] = "Fungarian Furor"
    RTM.rare_names[153228] = "Gear Checker Cogstar"
    RTM.rare_names[153205] = "Gemicide (JD99)"
    RTM.rare_names[154701] = "Gorged Gear-Cruncher (CC61)"
    RTM.rare_names[151684] = "Jawbreaker"
    RTM.rare_names[152007] = "Killsaw"
    RTM.rare_names[151933] = "Malfunctioning Beastbot"
    RTM.rare_names[151124] = "Mechagonian Nullifier"
    RTM.rare_names[151672] = "Mecharantula"
    RTM.rare_names[8821909] = "Mecharantula (F)"
    RTM.rare_names[151627] = "Mr. Fixthis"
    RTM.rare_names[151296] = "OOX-Avenger/MG"
    RTM.rare_names[153206] = "Ol' Big Tusk (TR28)"
    RTM.rare_names[152764] = "Oxidized Leachbeast"
    RTM.rare_names[151702] = "Paol Pondwader"
    RTM.rare_names[150575] = "Rumblerocks"
    RTM.rare_names[152182] = "Rustfeather"
    RTM.rare_names[155583] = "Scrapclaw"
    RTM.rare_names[150937] = "Seaspit"
    RTM.rare_names[153000] = "Sparkqueen P'Emp"
    RTM.rare_names[153226] = "Steel Singer Freza"
        
elseif RTM.localization == "koKR" then
    -- The names to be displayed in the frames and general chat messages for English (US) localization.
    RTM.rare_names[151934] = "Arachnoid Harvester"
    RTM.rare_names[154342] = "Arachnoid Harvester (F)"
    RTM.rare_names[155060] = "Doppel Ganger"
    RTM.rare_names[152113] = "The Kleptoboss (CC88)"
    RTM.rare_names[154225] = "The Rusty Prince (F)"
    RTM.rare_names[151623] = "The Scrap King (M)"
    RTM.rare_names[151625] = "The Scrap King"
    RTM.rare_names[151940] = "Uncle T'Rogg"
    RTM.rare_names[150394] = "Armored Vaultbot"
    RTM.rare_names[153200] = "Boilburn (JD41)"
    RTM.rare_names[151308] = "Boggac Skullbash"
    RTM.rare_names[152001] = "Bonepicker"
    RTM.rare_names[154739] = "Caustic Mechaslime (CC73)"
    RTM.rare_names[149847] = "Crazed Trogg (Orange)"
    RTM.rare_names[152569] = "Crazed Trogg (Green)"
    RTM.rare_names[152570] = "Crazed Trogg (Blue)"
    RTM.rare_names[151569] = "Deepwater Maw"
    RTM.rare_names[150342] = "Earthbreaker Gulroc (TR35)"
    RTM.rare_names[154153] = "Enforcer KX-T57"
    RTM.rare_names[151202] = "Foul Manifestation"
    RTM.rare_names[135497] = "Fungarian Furor"
    RTM.rare_names[153228] = "Gear Checker Cogstar"
    RTM.rare_names[153205] = "Gemicide (JD99)"
    RTM.rare_names[154701] = "Gorged Gear-Cruncher (CC61)"
    RTM.rare_names[151684] = "Jawbreaker"
    RTM.rare_names[152007] = "Killsaw"
    RTM.rare_names[151933] = "Malfunctioning Beastbot"
    RTM.rare_names[151124] = "Mechagonian Nullifier"
    RTM.rare_names[151672] = "Mecharantula"
    RTM.rare_names[8821909] = "Mecharantula (F)"
    RTM.rare_names[151627] = "Mr. Fixthis"
    RTM.rare_names[151296] = "OOX-Avenger/MG"
    RTM.rare_names[153206] = "Ol' Big Tusk (TR28)"
    RTM.rare_names[152764] = "Oxidized Leachbeast"
    RTM.rare_names[151702] = "Paol Pondwader"
    RTM.rare_names[150575] = "Rumblerocks"
    RTM.rare_names[152182] = "Rustfeather"
    RTM.rare_names[155583] = "Scrapclaw"
    RTM.rare_names[150937] = "Seaspit"
    RTM.rare_names[153000] = "Sparkqueen P'Emp"
    RTM.rare_names[153226] = "Steel Singer Freza"
end

-- Overrides for display names of rares that are too long.
local rare_display_name_overwrites = {}

rare_display_name_overwrites["enUS"] = {}
rare_display_name_overwrites["enGB"] = rare_display_name_overwrites["enUS"]
rare_display_name_overwrites["deDE"] = {}
rare_display_name_overwrites["deDE"][154701] = "Ritzelknabberer (CC61)"
rare_display_name_overwrites["frFR"] = {}
rare_display_name_overwrites["esES"] = {}
rare_display_name_overwrites["esES"][154701] = "Mascaengranajes (CC61)"
rare_display_name_overwrites["esMX"] = rare_display_name_overwrites["esES"]
rare_display_name_overwrites["itIT"] = {}
rare_display_name_overwrites["ptPT"] = {}
rare_display_name_overwrites["ptPT"][153228] = "Inspetor de Engrenagens"
rare_display_name_overwrites["ptPT"][154701] = "Esmaga Empanturrado (CC61)"
rare_display_name_overwrites["ptBR"] = rare_display_name_overwrites["ptPT"]
rare_display_name_overwrites["ruRU"] = {}
rare_display_name_overwrites["ruRU"][154701] = "шестеренок (CC61)"
rare_display_name_overwrites["ruRU"][153228] = "Инспектор Искраддон"
rare_display_name_overwrites["zhCN"] = {}
rare_display_name_overwrites["zhTW"] = {}
rare_display_name_overwrites["koKR"] = {}

RTM.rare_display_names = {}
for key, value in pairs(RTM.rare_names) do
    print(key, value)
    if rare_display_name_overwrites[RTM.localization][key] then
        RTM.rare_display_names[key] = rare_display_name_overwrites[RTM.localization][key]
    else
        RTM.rare_display_names[key] = value
    end
    print(RTM.rare_display_names[key])
end

-- The quest ids that indicate that the rare has been killed already.
RTM.completion_quest_ids = {}
RTM.completion_quest_ids[151934] = 55512 -- "Arachnoid Harvester"
RTM.completion_quest_ids[154342] = 55512 -- "Arachnoid Harvester (F)"
RTM.completion_quest_ids[155060] = 56419 -- "Doppel Ganger"
RTM.completion_quest_ids[152113] = 55858 -- "The Kleptoboss"
RTM.completion_quest_ids[154225] = 56182 -- "The Rusty Prince (F)"
RTM.completion_quest_ids[151623] = 55364 -- "The Scrap King (M)"
RTM.completion_quest_ids[151625] = 55364 -- "The Scrap King"
RTM.completion_quest_ids[151940] = 55538 -- "Uncle T'Rogg"
RTM.completion_quest_ids[150394] = 55546 -- "Armored Vaultbot"
RTM.completion_quest_ids[153200] = 55857 -- "Boilburn"
RTM.completion_quest_ids[151308] = 55539 -- "Boggac Skullbash"
RTM.completion_quest_ids[152001] = 55537 -- "Bonepicker"
RTM.completion_quest_ids[154739] = 56368 -- "Caustic Mechaslime"
RTM.completion_quest_ids[149847] = 55812 -- "Crazed Trogg (Orange)"
RTM.completion_quest_ids[152569] = 55812 -- "Crazed Trogg (Green)"
RTM.completion_quest_ids[152570] = 55812 -- "Crazed Trogg (Blue)"
RTM.completion_quest_ids[151569] = 55514 -- "Deepwater Maw"
RTM.completion_quest_ids[150342] = 55814 -- "Earthbreaker Gulroc"
RTM.completion_quest_ids[154153] = 56207 -- "Enforcer KX-T57"
RTM.completion_quest_ids[151202] = 55513 -- "Foul Manifestation"
RTM.completion_quest_ids[135497] = 55367 -- "Fungarian Furor"
RTM.completion_quest_ids[153228] = 55852 -- "Gear Checker Cogstar"
RTM.completion_quest_ids[153205] = 55855 -- "Gemicide"
RTM.completion_quest_ids[154701] = 56367 -- "Gorged Gear-Cruncher"
RTM.completion_quest_ids[151684] = 55399 -- "Jawbreaker"
RTM.completion_quest_ids[152007] = 55369 -- "Killsaw"
RTM.completion_quest_ids[151933] = 55544 -- "Malfunctioning Beastbot"
RTM.completion_quest_ids[151124] = 55207 -- "Mechagonian Nullifier"
RTM.completion_quest_ids[151672] = 55386 -- "Mecharantula"
RTM.completion_quest_ids[8821909] = 55386 -- "Mecharantula"
RTM.completion_quest_ids[151627] = 55859 -- "Mr. Fixthis"
RTM.completion_quest_ids[151296] = 55515 -- "OOX-Avenger/MG"
RTM.completion_quest_ids[153206] = 55853 -- "Ol' Big Tusk"
RTM.completion_quest_ids[152764] = 55856 -- "Oxidized Leachbeast"
RTM.completion_quest_ids[151702] = 55405 -- "Paol Pondwader"
RTM.completion_quest_ids[150575] = 55368 -- "Rumblerocks"
RTM.completion_quest_ids[152182] = 55811 -- "Rustfeather"
RTM.completion_quest_ids[155583] = 56737 -- "Scrapclaw"
RTM.completion_quest_ids[150937] = 55545 -- "Seaspit"
RTM.completion_quest_ids[153000] = 55810 -- "Sparkqueen P'Emp"
RTM.completion_quest_ids[153226] = 55854 -- "Steel Singer Freza"

RTM.completion_quest_inverse = {}
RTM.completion_quest_inverse[55512] = {151934, 154342}
RTM.completion_quest_inverse[56419] = {155060}
RTM.completion_quest_inverse[55858] = {152113}
RTM.completion_quest_inverse[56182] = {154225}
RTM.completion_quest_inverse[55364] = {151623, 151625}
RTM.completion_quest_inverse[55538] = {151940}
RTM.completion_quest_inverse[55546] = {150394}
RTM.completion_quest_inverse[55857] = {153200}
RTM.completion_quest_inverse[55539] = {151308}
RTM.completion_quest_inverse[55537] = {152001}
RTM.completion_quest_inverse[56368] = {154739}
RTM.completion_quest_inverse[55812] = {149847, 152569, 152570}
RTM.completion_quest_inverse[55514] = {151569}
RTM.completion_quest_inverse[55814] = {150342}
RTM.completion_quest_inverse[56207] = {154153}
RTM.completion_quest_inverse[55513] = {151202}
RTM.completion_quest_inverse[55367] = {135497}
RTM.completion_quest_inverse[55852] = {153228}
RTM.completion_quest_inverse[55855] = {153205}
RTM.completion_quest_inverse[56367] = {154701}
RTM.completion_quest_inverse[55399] = {151684}
RTM.completion_quest_inverse[55369] = {152007}
RTM.completion_quest_inverse[55544] = {151933}
RTM.completion_quest_inverse[55207] = {151124}
RTM.completion_quest_inverse[55386] = {151672, 8821909}
RTM.completion_quest_inverse[55859] = {151627}
RTM.completion_quest_inverse[55515] = {151296}
RTM.completion_quest_inverse[55853] = {153206}
RTM.completion_quest_inverse[55856] = {152764}
RTM.completion_quest_inverse[55405] = {151702}
RTM.completion_quest_inverse[55368] = {150575}
RTM.completion_quest_inverse[55811] = {152182}
RTM.completion_quest_inverse[56737] = {155583}
RTM.completion_quest_inverse[55545] = {150937}
RTM.completion_quest_inverse[55810] = {153000}
RTM.completion_quest_inverse[55854] = {153226}