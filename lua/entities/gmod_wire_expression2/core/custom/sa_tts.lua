--glualint:ignore-file
AddCSLuaFile("autorun/client/cl_sa_tts.lua")

E2Lib.RegisterExtension("sa_tts", false)

e2function void playTTS(string text)
	HTTP.Post("https://tts.spaceage.mp/make.php", { q = text }, function (body, length, headers, code)
		if code ~= 200 then
			return
		end
		local url = body

		net.Start("E2_TTS_PlayURL")
			net.WriteString(url)
			net.WriteVector(self:GetPos())
		net.Broadcast()
	end)
end

util.AddNetworkString("E2_TTS_PlayURL")