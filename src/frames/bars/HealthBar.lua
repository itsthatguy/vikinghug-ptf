local HealthBar = inheritsFrom(Vikinghug.BaseBar)

function HealthBar:CreateEvents()
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].configureBars, self.ConfigureBars, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].updateHealth, self.UpdatePlayerHealth, self)
end

function HealthBar:ConfigureBars(event, state)
  if (UnitExists(self.unit)) then
    self:SetOpacity(100)
  else
    self:SetOpacity(0)
  end
end

function HealthBar:UpdatePlayerHealth(event, state)
  self:SetMinMaxValues(0, state.healthMax)
  self:SetValue(state.health)
end

Vikinghug.HealthBar = HealthBar