MSQ = LibStub("Masque", true)
if not MSQ then return end

MSQ:AddSkin("Vikinghug", {
	Author = "Vikinghug",
	Version = "1.2.1",
	Shape = "Square",
	Masque_Version = 80100,
	Backdrop = {
		Width = 36,
		Height = 36,
		Color = {ParseColor(VH_COLORS.BG, 0.8)},
		Texture = [[Interface\AddOns\Vikinghug\src\masque_skin\Textures\PlainBackdrop]],
	},
	Icon = {
		Width = 36,
		Height = 36,
		TexCoords = {0.08,0.92,0.08,0.92},
	},
	Flash = {
		Width = 36,
		Height = 36,
		Color = {ParseColor(VH_COLORS.RED, 0.3)},
		Texture = [[Interface\AddOns\Vikinghug\src\masque_skin\Textures\Overlay]],
	},
	Cooldown = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\AddOns\Vikinghug\src\masque_skin\Textures\Overlay]],
		Color = {ParseColor(VH_COLORS.BG, 0.8)},
	},
	Pushed = {
		Width = 36,
		Height = 36,
		Color = {ParseColor(VH_COLORS.BG, 0.5)},
		Texture = [[Interface\AddOns\Vikinghug\src\masque_skin\Textures\Overlay]],
	},
	Normal = {
		Width = 36,
		Height = 36,
		Color = {ParseColor(VH_COLORS.BG, 1)},
		Texture = [[Interface\AddOns\Vikinghug\src\masque_skin\Textures\Normal]],
	},
	Disabled = {
		-- Hide = true,
		TexCoords = {0.08,0.92,0.08,0.92},
		Width = 36,
		Height = 36,
		Color = {ParseColor(VH_COLORS.BG, 1)},
		Texture = [[Interface\AddOns\Vikinghug\src\masque_skin\Textures\Overlay]],
	},
	Checked = {
		Width = 36,
		Height = 36,
		BlendMode = "BLEND",
		Color = {1, 0.8, 0.0, 1},
		Texture = [[Interface\AddOns\Vikinghug\src\masque_skin\Textures\Border]],
	},
	Border = {
		Width = 36,
		Height = 36,
		Color = {ParseColor(VH_COLORS.BG, 0.8)},
		-- BlendMode = "BLEND",
		-- Texture = [[Interface\AddOns\Vikinghug\src\masque_skin\Textures\Normal]],
	},
	AutoCastable = {
		Width = 60,
		Height = 60,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 36,
		Height = 36,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.1},
		Texture = [[Interface\AddOns\Vikinghug\src\masque_skin\Textures\Highlight]],
	},
	Gloss = {
		Hide = true,
	},
	HotKey = {
		Width = 36,
		Height = 36,
		OffsetX = -2,
		OffsetY = -2,
		JustifyH = "RIGHT",
		JustifyV = "TOP"
	},
	Count = {
		Width = 36,
		Height = 36,
		OffsetX = -2,
		OffsetY = 0,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
	},
	Name = {
		Width = 36,
		Height = 36,
		OffsetX = 1,
		OffsetY = 3,
		JustifyH = "LEFT",
		JustifyV = "BOTTOM",
	},
	Duration = {
		Width = 36,
		Height = 36,
		OffsetX = 0,
		OffsetY = 0,
		JustifyH = "CENTER",
		JustifyV = "MIDDLE",
	},
	AutoCast = {
		Width = 36,
		Height = 36,
	},
}, true)

function ActionButton_UpdateRangeIndicator(self, checksRange, inRange)
	self.HotKey:SetFont(VH_FONTS.STAATLICHES, 18)
	self.HotKey:SetShadowColor(ParseColor(VH_COLORS.BG, 0.8))
	self.HotKey:SetShadowOffset(1, -1);
	self.Count:SetTextColor(1,1,1,1)
	self.Count:SetFont(VH_FONTS.STAATLICHES, 14)

	local isUsable, notEnoughMana = IsUsableAction(self.action)
	if (isUsable == false) then
		self.HotKey:SetVertexColor(1, 1, 1, 0.25)
		return self.icon:SetVertexColor(ParseColor(VH_COLORS.BG, 0.5))
	elseif (notEnoughMana) then
		self.HotKey:SetVertexColor(1, 1, 1, 0.25)
		return self.icon:SetVertexColor(ParseColor(VH_COLORS.BLUE, 0.75))		
	end

	if ( self.HotKey:GetText() == RANGE_INDICATOR ) then
		if ( checksRange ) then
			self.HotKey:Show()
			if ( inRange ) then
				self.HotKey:SetVertexColor(1,1,1,1)
				self.icon:SetVertexColor(1,1,1,1)
			else
				self.HotKey:SetVertexColor(ParseColor(VH_COLORS.RED, 1))
				self.icon:SetVertexColor(ParseColor(VH_COLORS.RED, 0.75))
			end
		else
			self.HotKey:Hide();
		end
	else
		if ( checksRange and not inRange ) then
			self.HotKey:SetVertexColor(ParseColor(VH_COLORS.RED, 1))
			self.icon:SetVertexColor(ParseColor(VH_COLORS.RED, 0.75))
		else
			self.HotKey:SetVertexColor(1,1,1,1)
			self.icon:SetVertexColor(1,1,1,1)
		end
	end
end
