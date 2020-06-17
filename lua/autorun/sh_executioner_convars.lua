-- CreateConVar("ttt2_hitman_target_credit_bonus", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
-- CreateConVar("ttt2_hitman_target_chatreveal", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
--
-- hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_hitman_convars", function(tbl)
-- 	tbl[ROLE_HITMAN] = tbl[ROLE_HITMAN] or {}
--
-- 	table.insert(tbl[ROLE_HITMAN], {
-- 		cvar = "ttt2_hitman_target_credit_bonus",
-- 		slider = true,
-- 		min = 0,
-- 		max = 10,
-- 		decimal = 0,
-- 		desc = "ttt2_hitman_target_credit_bonus (def. 1)"
-- 	})
--
-- 	table.insert(tbl[ROLE_HITMAN], {
-- 		cvar = "ttt2_hitman_target_chatreveal",
-- 		checkbox = true,
-- 		desc = "ttt2_hitman_target_chatreveal (def. 0)"
-- 	})
-- end)

CreateConVar("ttt2_executioner_punishment_time", 60, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_executioner_target_multiplier", 2, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_executioner_non_target_multiplier", 0.5, {FCVAR_ARCHIVE, FCVAR_NOTIFY})

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
