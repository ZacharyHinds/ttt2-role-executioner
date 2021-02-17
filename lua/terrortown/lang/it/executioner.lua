L = LANG.GetLanguageTableReference("it")

-- GENERAL ROLE LANGUAGE STRINGS
L[EXECUTIONER.name] = "Boia"
L["info_popup_" .. EXECUTIONER.name] = [[Sei un Boia!
Uccidi i tuoi bersagli!]]
L["body_found_" .. EXECUTIONER.abbr] = "Loro erano Boia!"
L["search_role_" .. EXECUTIONER.abbr] = "Questa persona era un Boia!"
L["target_" .. EXECUTIONER.name] = "Boia"
L["ttt2_desc_" .. EXECUTIONER.name] = [[Il Boia è un traditore che lavora con gli altri traditori, con l'obbiettivo di uccidere i player non traditori.
Il Boia è in grado di guadagnare crediti uccidendo i suoi bersagli.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_executioner_target_killed"] = "Hai ucciso il tuo bersaglio!"
L["ttt2_executioner_chat_reveal"] = "'{playername}' è un Boia!"
L["ttt2_executioner_target_died"] = "Il tuo bersaglio è morto..."
L["ttt2_executioner_target_killed_wrong"] = "Hai ucciso la persona sbagliata! Avrai un nuovo contratto tra {punishtime} secondi!"
L["ttt2_executioner_player_target"] = "Il tuo bersaglio! gli fai {multiplier}x danno!"
L["ttt2_executioner_player_nontarget"] = "Non il tuo bersaglio! gli fai {multiplier}x danno!"
