L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[EXECUTIONER.name] = "Executioner"
L["info_popup_" .. EXECUTIONER.name] = [[You are a Executioner!
Take out your target!]]
L["body_found_" .. EXECUTIONER.abbr] = "They were a Executioner!"
L["search_role_" .. EXECUTIONER.abbr] = "This person was a Executioner!"
L["target_" .. EXECUTIONER.name] = "Executioner"
L["ttt2_desc_" .. EXECUTIONER.name] = [[The Executioner is a Traitor working together with the other traitors with the goal to kill all other non-traitor players.
The Executioner is just able to collect some credits if he kills his target.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_executioner_target_killed"] = "You've killed your target!"
L["ttt2_executioner_chat_reveal"] = "'{playername}' is a Executioner!"
L["ttt2_executioner_target_died"] = "Your target died..."
L["ttt2_executioner_target_killed_wrong"] = "You killed the wrong target! You'll get a new contract after {punishtime} seconds!"
L["ttt2_executioner_player_target"] = "Your target! You deal {multiplier}x damage!"
L["ttt2_executioner_player_nontarget"] = "Not your target! You deal {multiplier}x damage!"

--EVENT STRINGS
L["desc_exc_target_kill_right"] = "This kill was the executioner's target."
L["desc_exc_target_kill_wrong"] = "This kill was not the executioner's target and broke their contract."
L["tooltip_exc_target_kill_score"] = "Kill: {score}"
L["tooltip_exc_target_kill"] = "Executioner killed"
L["exc_target_kill_score"] = "Kill:"
L["tooltip_exc_target_kill_score_exc_right"] = "Correct target: {score}"
L["tooltip_exc_target_kill_score_exc_wrong"] = "Wrong target: {score}"
L["exc_target_kill_score_exc_right"] = "Correct target:"
L["exc_target_kill_score_exc_wrong"] = "Wrong target:"

--SETTINGS STRINGS
L["label_executioner_punishment_time"] = "Delay for new target if wrong player killed"
L["label_executioner_target_multiplier"] = "Damage multiplier against target player"
L["label_executioner_non_target_multiplier"] = "Damage multiplier against non-target players"