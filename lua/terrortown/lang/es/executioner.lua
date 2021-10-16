L = LANG.GetLanguageTableReference("es")

-- GENERAL ROLE LANGUAGE STRINGS
L[EXECUTIONER.name] = "Verdugo"
L["info_popup_" .. EXECUTIONER.name] = [[¡Eres un Verdugo!
¡Deja fuera a tu objetivo!]]
L["body_found_" .. EXECUTIONER.abbr] = "¡Era un Verdugo!"
L["search_role_" .. EXECUTIONER.abbr] = "Esta persona era un Verdugo."
L["target_" .. EXECUTIONER.name] = "Verdugo"
L["ttt2_desc_" .. EXECUTIONER.name] = [[El Verdugo es un traidor que hace más daño a su objetivo y menos daño a los que no lo son.
Sólo podrás obtener créditos si matas a tu objetivo.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_executioner_target_killed"] = "¡Has asesinado a tu objetivo!"
L["ttt2_executioner_chat_reveal"] = "¡'{playername}' es un Verdugo!"
L["ttt2_executioner_target_died"] = "Tu objetivo murió..."
L["ttt2_executioner_target_killed_wrong"] = "¡Has asesinado a la persona incorrecta! Obtendrás un nuevo objetivo en {punishtime} segundos."
L["ttt2_executioner_player_target"] = "¡Tu objetivo! Haces {multiplier}x de daño."
L["ttt2_executioner_player_nontarget"] = "¡No es tu objetivo! Haces {multiplier}x de daño."

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
