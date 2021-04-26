EVENT.base = "kill"

if CLIENT then
    EVENT.icon = Material("vgui/ttt/dynamic/roles/icon_exc.vmt")

    function EVENT:GetText()
        local killText = self.BaseClass.GetText(self)

        if self.event.wasTarget then
            killText[#killText + 1] = {
                string = "desc_exc_target_kill_right"
            }
        else
            killText[#killText + 1] = {
                string = "desc_exc_target_kill_wrong"
            }
        end

        return killText
    end
end

if SERVER then
    function EVENT:Trigger(victim, attacker, dmgInfo, wasTarget)
        self.wasTarget = wasTarget

        victim.wasExecutionerDeath = true

        return self.BaseClass.Trigger(self, victim, attacker, dmgInfo)
    end

    function EVENT:CalculateScore()
        self.BaseClass.CalculateScore(self)

        local score = self:GetPlayerScore(self.event.attacker.sid64)

        if self.wasTarget then
            score.score_exc_right = 1
        elseif self.event.type ~= KILL_SUICIDE then
            score.score_exc_wrong = -1            
        end

        self.event.wasTarget = self.wasTarget
    end
end

hook.Add("TTT2OnTriggeredEvent", "cancel_executioner_kill_event", function(type, eventData)
    if type ~= EVENT_KILL then return end

    local ply = player.GetBySteamID64(eventData.victim.sid64)

    if not IsValid(ply) or not ply.wasExecutionerDeath then return end

    ply.wasExecutionerDeath = nil 

    return false
end)