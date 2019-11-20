function SetAllPoints(...) Texture.SetAllPoints(...) end

Texture = {
  SetAllPoints = function(frame)
    return {}
  end
}

Frame = {
  CreateTexture = CreateTexture
}

function CreateTexture(name, layer, inheritsFrom)
  return Texture
end

function CreateFrame(type, name, parent, id)
end
