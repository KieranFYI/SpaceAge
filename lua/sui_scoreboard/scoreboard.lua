include("player_row.lua")
include("player_frame.lua")

surface.CreateFont("suiscoreboardheader", {
	font = "coolvetica",
	size = 28,
	weight = 100
})
surface.CreateFont("suiscoreboardsubtitle", {
	font = "coolvetica",
	size = 20,
	weight = 100
})
surface.CreateFont("suiscoreboardlogotext", {
	font = "coolvetica",
	size = 75,
	weight = 100
})
surface.CreateFont("suiscoreboardsuisctext", {
	font = "verdana",
	size = 12,
	weight = 100
})
surface.CreateFont("suiscoreboardplayername", {
	font = "verdana",
	size = 16,
	weight = 100
})

local texGradient = surface.GetTextureID("gui/center_gradient")

local PANEL = {}

function PANEL:Init()
	SCOREBOARD = self

	self.Hostname = vgui.Create("DLabel", self)
	self.Hostname:SetText(GetHostName())

	self.Logog = vgui.Create("DLabel", self)
	self.Logog:SetText("g")

	self.SuiSc = vgui.Create("DLabel", self)
	self.SuiSc:SetText("sui_scoreboard V2 by Suicidal.Banana, modifications by Rak")

	self.Description = vgui.Create("DLabel", self)
	self.Description:SetText(GAMEMODE.Name .. " - " .. GAMEMODE.Author)

	self.PlayerFrame = vgui.Create("suiplayerframe", self)

	self.PlayerRows = {}

	self:UpdateScoreboard()

	--Update the scoreboard every 1 second
	timer.Create("SuiScoreboardUpdater", 1, 0, function() SCOREBOARD:UpdateScoreboard() end)

	self.lblPing = vgui.Create("DLabel", self)
	self.lblPing:SetText("Ping")

	self.lblScore = vgui.Create("DLabel", self)
	self.lblScore:SetText("Score")

	self.lblTeam = vgui.Create("DLabel", self)
	self.lblTeam:SetText("Team")

end

function PANEL:AddPlayerRow(ply)
	local button = vgui.Create("suiscoreplayerrow", self.PlayerFrame:GetCanvas())
	button:SetPlayer(ply)
	self.PlayerRows[ply] = button
end

function PANEL:GetPlayerRow(ply)
	return self.PlayerRows[ply]
end

function PANEL:Paint(w, h)
	draw.RoundedBox(10, 0, 0, w, h, Color(50, 50, 50, 205))
	surface.SetTexture(texGradient)
	surface.SetDrawColor(100, 100, 100, 155)
	surface.DrawTexturedRect(0, 0, w, h)

	draw.RoundedBox(6, 15, self.Description.y - 8, w - 30, h - self.Description.y - 6, Color(230, 230, 230, 100))
	surface.SetTexture(texGradient)
	surface.SetDrawColor(255, 255, 255, 50)
	surface.DrawTexturedRect(15, self.Description.y - 8, w - 30, h - self.Description.y - 8)

	draw.RoundedBox(6, 108, self.Description.y - 4, w - 128, self.Description:GetTall() + 8, Color(100, 100, 100, 155))
	surface.SetTexture(texGradient)
	surface.SetDrawColor(255, 255, 255, 50)
	surface.DrawTexturedRect(108, self.Description.y - 4, w - 128, self.Description:GetTall() + 8)

	local tColor = Color(0, 155, 255, 255)

	if (tColor.r < 255) then
		tColorGradientR = tColor.r + 15
	else
		tColorGradientR = tColor.r
	end
	if (tColor.g < 255) then
		tColorGradientG = tColor.g + 15
	else
		tColorGradientG = tColor.g
	end
	if (tColor.b < 255) then
		tColorGradientB = tColor.b + 15
	else
		tColorGradientB = tColor.b
	end
	draw.RoundedBox(8, 24, 12, 80, 80, Color(tColor.r, tColor.g, tColor.b, 200))
	surface.SetTexture(texGradient)
	surface.SetDrawColor(tColorGradientR, tColorGradientG, tColorGradientB, 225)
	surface.DrawTexturedRect(24, 12, 80, 80)
end

function PANEL:PerformLayout(w, h)
	self:SetSize(ScrW()  *  0.75, ScrH()  *  0.65)

	self:SetPos((ScrW() - w) / 2, (ScrH() - h) / 2)

	self.Hostname:SizeToContents()
	self.Hostname:SetPos(115, 17)

	self.Logog:SetSize(80, 80)
	self.Logog:SetPos(45, 5)
	self.Logog:SetColor(color_white)

	self.SuiSc:SetSize(400, 15)
	self.SuiSc:SetPos(w - 350, h - 15)

	self.Description:SizeToContents()
	self.Description:SetPos(115, 60)
	self.Description:SetColor(Color(30, 30, 30, 255))

	self.PlayerFrame:SetPos(5, self.Description.y + self.Description:GetTall() + 20)
	self.PlayerFrame:SetSize(w - 10, h - self.PlayerFrame.y - 20)

	local y = 0

	local PlayerSorted = {}

	for k, v in pairs(self.PlayerRows) do
		if IsValid(k) then table.insert(PlayerSorted, v) end
	end

	table.sort(PlayerSorted, function (a , b) return a:HigherOrLower(b) end)

	for k, v in ipairs(PlayerSorted) do
		v:SetPos(0, y)
		v:SetSize(self.PlayerFrame:GetWide(), v:GetTall())

		self.PlayerFrame:GetCanvas():SetSize(self.PlayerFrame:GetCanvas():GetWide(), y + v:GetTall())

		y = y + v:GetTall() + 1
	end

	if self.lblPing then
		self.lblPing:SizeToContents()
	else
		self.lblPing = vgui.Create("DLabel", self)
		self.lblPing:SetText("Ping")
		self.lblPing:SizeToContents()
	end

	self.lblScore:SizeToContents()
	self.lblTeam:SizeToContents()

	self.lblPing:SetPos(w - 45 - self.lblPing:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3 )
	self.lblScore:SetPos(w - 45 * 5.4 - self.lblScore:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3 )
	self.lblTeam:SetPos(w - 45 * 10.2 - self.lblTeam:GetWide() / 2, self.PlayerFrame.y - self.lblPing:GetTall() - 3 )
end

function PANEL:ApplySchemeSettings()
	self.Hostname:SetFont("suiscoreboardheader")
	self.Description:SetFont("suiscoreboardsubtitle")
	self.Logog:SetFont("suiscoreboardlogotext")
	self.SuiSc:SetFont("suiscoreboardsuisctext")

	if self.lblPing then
		self.lblPing:SetFont("DefaultSmall")
	else
		self.lblPing = vgui.Create("DLabel", self)
		self.lblPing:SetText("Ping")
		self.lblPing:SizeToContents()
		self.lblPing:SetFont("DefaultSmall")
	end

	self.lblScore:SetFont("DefaultSmall")
	self.lblTeam:SetFont("DefaultSmall")

	self.Hostname:SetTextColor(Color(230, 230, 230, 200))
	self.Description:SetTextColor(Color(55, 55, 55, 255))
	self.Logog:SetTextColor(Color(0, 0, 0, 255))
	self.SuiSc:SetTextColor(Color(200, 200, 200, 200))
	self.lblPing:SetTextColor(Color(0, 0, 0, 255))
	self.lblScore:SetTextColor(Color(0, 0, 0, 255))
	self.lblTeam:SetTextColor(Color(0, 0, 0, 255))
end


function PANEL:UpdateScoreboard(force)
	if not self or (not force and not self:IsVisible()) then return end
	for k, v in pairs(self.PlayerRows) do
		if not IsValid(k) then
			v:Remove()
			self.PlayerRows[k] = nil
		end
	end

	local PlayerList = player.GetHumans()
	for id, pl in pairs(PlayerList) do
		if not self:GetPlayerRow(pl) then
			self:AddPlayerRow(pl)
		end
	end

	--Always invalidate the layout so the order gets updated
	self:InvalidateLayout()
end
vgui.Register("suiscoreboard", PANEL, "Panel")
