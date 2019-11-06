local ManaBar = inheritsFrom(Vikinghug.BaseBar)

function ManaBar:CreateEvents()
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].configureBars, self.ConfigureBars, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].updatePower, self.UpdatePower, self)
end

function ManaBar:UpdatePower(event, state)
  self:SetMinMaxValues(0, state.manaMax)
  self:SetValue(state.mana)
end

function ManaBar:ConfigureBars(event, state)
  if (UnitClass(self.unit) == "Druid" and state.powerType ~= 0) then
    self:SetHeight(self.heightForm)
    self:SetOpacity(100)
  elseif (UnitExists(self.unit) and state.powerType == 0) then
    self:SetOpacity(100)
    self:SetHeight(self.heightMax)
  else
    self:SetOpacity(0)
  end
end

Vikinghug.ManaBar = ManaBar