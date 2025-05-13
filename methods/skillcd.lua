local coremem = require(game.Players.LocalPlayer.Character.ClientRuntime.CoreMemory)
local mem = require(game.Players.LocalPlayer.Character.ODMG.Client.Memory)

for i, v in pairs(mem) do
	if string.match(i:lower(), "cooldown") then
		warn("defmem", i)
	end
end

coremem.skillCooldowns.RightBurst.cooldown = 0
coremem.skillCooldowns.RightBurst.originalCooldown = 0
table.foreach(coremem.skillCooldowns.RightBurst, print)

-- table.foreach(coremem, print)

-- for i, v in pairs(coremem.skillCooldowns) do
-- 	if string.match(i:lower(), "cooldown") then
-- 		warn("coremem", i)
-- 	end
-- end

-- mem.forwardBurstStrength = 100
-- print(mem.forwardBurstStrength)
-- mem.rageMode = true