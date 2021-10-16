L = LANG.GetLanguageTableReference("ru")

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

-- --EVENT STRINGS
-- L["desc_exc_target_kill_right"] = "This kill was the executioner's target."
-- L["desc_exc_target_kill_wrong"] = "This kill was not the executioner's target and broke their contract."
-- L["tooltip_exc_target_kill_score"] = "Kill: {score}"
-- L["tooltip_exc_target_kill"] = "Executioner killed"
-- L["exc_target_kill_score"] = "Kill:"
-- L["tooltip_exc_target_kill_score_exc_right"] = "Correct target: {score}"
-- L["tooltip_exc_target_kill_score_exc_wrong"] = "Wrong target: {score}"
-- L["exc_target_kill_score_exc_right"] = "Correct target:"
-- L["exc_target_kill_score_exc_wrong"] = "Wrong target:"

-- --SETTINGS STRINGS
-- L["label_executioner_punishment_time"] = "Delay for new target if wrong player killed"
-- L["label_executioner_target_multiplier"] = "Damage multiplier against target player"
-- L["label_executioner_non_target_multiplier"] = "Damage multiplier against non-target players"