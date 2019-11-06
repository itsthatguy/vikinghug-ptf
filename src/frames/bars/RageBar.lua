local RageBar = inheritsFrom(Vikinghug.BaseBar)

function RageBar:CreateEvents()
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].configureBars, self.ConfigureBars, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].updatePower, self.UpdatePower, self)
end

function RageBar:UpdatePower(event, state)
  self:SetMinMaxValues(0, state.rageMax)
  self:SetValue(state.rage)
end

function RageBar:ConfigureBars(event, state)
  if (UnitClass(self.unit) == "Druid" and state.powerType == 1) then
    self:SetHeight(self.heightForm)
    self:SetOpacity(100)
  elseif (state.powerType ~= 1) then
    self:SetOpacity(0)
  end
end

Vikinghug.RageBar = RageBar