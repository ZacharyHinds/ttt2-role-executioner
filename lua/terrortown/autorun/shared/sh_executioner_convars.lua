CreateConVar("ttt2_executioner_punishment_time", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_executioner_target_multiplier", 2, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_executioner_non_target_multiplier", 0.5, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

if CLIENT then
  hook.Add("TTT2FinishedLoading", "mes_devicon", function() -- addon developer emblem for me ^_^
    AddTTT2AddonDev("76561198049910438")
  end)
end

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_executioner_convars", function(tbl)
  tbl[ROLE_EXECUTIONER] = tbl[ROLE_EXECUTIONER] or {}

  table.insert(tbl[ROLE_EXECUTIONER], {
      cvar = "ttt2_executioner_punishment_time",
      slider = true,
      min = 0,
      max = 240,
      decimal = 0,
      desc = "ttt2_executioner_punishment_time (def. 60)"
  })

  table.insert(tbl[ROLE_EXECUTIONER], {
      cvar = "ttt2_executioner_target_multiplier",
      slider = true,
      min = 1,
      max = 10,
      decimal = 1,
      desc = "ttt2_executioner_target_multiplier (def. 2)"
  })

  table.insert(tbl[ROLE_EXECUTIONER], {
      cvar = "ttt2_executioner_non_target_multiplier",
      slider = true,
      min = 0,
      max = 1,
      decimal = 1,
      desc = "ttt2_executioner_non_target_multiplier (def. 0.5)"
  })
end)
