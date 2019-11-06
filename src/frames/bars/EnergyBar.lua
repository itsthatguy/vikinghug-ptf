local EnergyBar = inheritsFrom(Vikinghug.BaseBar)

function EnergyBar:CreateEvents()
  -- Vikinghug.RegisterCallback(self, ACTIONS[self.unit].resizeDruidBars, self.ResizeDruidBars, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].configureBars, self.ConfigureBars, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].updatePower, self.UpdatePower, self)
end

function EnergyBar:UpdatePower(event, state)
  self:SetMinMaxValues(0, state.energyMax)
  self:SetValue(state.energy)
end

function EnergyBar:ConfigureBars(event, state)
  if (UnitClass(self.unit) == "Druid" and state.powerType == 3) then
    self:SetHeight(self.heightForm)
    self:SetOpacity(100)
  elseif (state.powerType ~= 3) then
    self:SetOpacity(0)
  end
end

Vikinghug.EnergyBar = EnergyBar