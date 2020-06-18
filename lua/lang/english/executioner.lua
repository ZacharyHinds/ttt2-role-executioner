L = LANG.GetLanguageTableReference("english")

-- GENERAL ROLE LANGUAGE STRINGS
L[EXECUTIONER.name] = "Executioner"
L["info_popup_" .. EXECUTIONER.name] = [[You are a Executioner!
Try to get some credits!]]
L["body_found_" .. EXECUTIONER.abbr] = "They were a Executioner!"
L["search_role_" .. EXECUTIONER.abbr] = "This person was a Executioner!"
L["target_" .. EXECUTIONER.name] = "Executioner"
L["ttt2_desc_" .. EXECUTIONER.name] = [[The Executioner is a Traitor working together with the other traitors with the goal to kill all other non-traitor players.
The Executioner is just able to collect some credits if he kills his target.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_executioner_target_killed"] = "You've killed your target!"
L["ttt2_executioner_chat_reveal"] = "'{playername}' is a Executioner!"
L["ttt2_executioner_target_died"] = "Your target died..."
L["ttt2_executioner_target_killed_wrong"] = "You killed the wrong target! You'll get a new contract after some time!"
