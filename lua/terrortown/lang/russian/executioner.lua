L = LANG.GetLanguageTableReference("Русский")

-- GENERAL ROLE LANGUAGE STRINGS
L[EXECUTIONER.name] = "Палач"
L["info_popup_" .. EXECUTIONER.name] = [[Вы палач!
Прервите  существование своей цели!]]
L["body_found_" .. EXECUTIONER.abbr] = "Он был палачом!"
L["search_role_" .. EXECUTIONER.abbr] = "Этот человек был палачом!"
L["target_" .. EXECUTIONER.name] = "Палач"
L["ttt2_desc_" .. EXECUTIONER.name] = [[Палач - предатель, работающий вместе с другими предателями с целью убить всех других игроков, не являющихся предателями.
Палач может просто получить несколько кредитов, если убьёт свою цель.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_executioner_target_killed"] = "Вы убили свою цель!"
L["ttt2_executioner_chat_reveal"] = "'{playername}' палач!"
L["ttt2_executioner_target_died"] = "Ваша цель умерла..."
L["ttt2_executioner_target_killed_wrong"] = "Вы убили не ту цель! Вы получите новый контракт через {punishtime} сек.!"
L["ttt2_executioner_player_target"] = "Ваша цель! Вы наносите {multiplier}x урона!"
L["ttt2_executioner_player_nontarget"] = "Не твоя цель! Вы наносите {multiplier}x урона!"
