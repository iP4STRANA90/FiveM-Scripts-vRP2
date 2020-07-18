
local Crypto = class("Crypto", vRP.Extension)
Crypto.User = class("User")

local useable_cryptos = {
  {id = "snailcoin", name = "Snail Coin", value = 5},
}
local sell_type = {
  ["illegal"] = 0.01,
  ["legal"] = 0.05,
}

function menu_sell_crypto(self)
  vRP.EXT.GUI:registerMenuBuilder("crypto_sell", function (menu)
    menu.title = "Sell a crpyto"
    local user = menu.user
    local dealer = menu.data.dealer
    local tax = sell_type[dealer]

    function ask_sell(menu, data, mod)
      local id = data.id
      local many = user:getCrypto(id)
      local crp = Crypto:GetCryptoDef(id)
      local amount = 0
      if mod == -1 then
        amount = tonumber(many or 0)
      else
        prompt = user:prompt("How many <span style=color:#ba993f>"..crp.name.."</span> would you like to sell (max: "..many..")", 0)
        amount = tonumber(prompt or 0)
      end
      if amount > 0 then
        amount = amount * (1 - tax)
        local ok = user:request("Are you sure you would like to sell <span style=color:#ba993f>"..vRP:formatMoney(amount).." "..crp.name.."</span> for ".." ("..(tax*100).."% tax)?", 15)
        if ok then
          if user:tryCryptoPayment(id, amount) then
            user:giveWallet(amount * crp.value)
            vRP.EXT.Base.remote._notify(user.source, "You sold ~y~"..vRP:formatMoney(amount).." Snail Coins~w~ for ~g~"..vRP:formatMoney(amount * crp.value))
          else
            vRP.EXT.Base.remote._notify(user.source, "~r~You do not have ~y~"..vRP:formatMoney(amount).." Snail Coins~r~ to sell!")
          end
        end
      end
    end

    local vcrypto = user.cdata.crypto
    local has = false

    if type(vcrypto) == "table" then
      for k,v in pairs(vcrypto) do
        if Crypto:GetCryptoDef(k) and v > 0 then
          local sto = 'You have: <span style=color:#ba993f>%s %ss</span>, worth: <span style=color:#60bf40>%s</span><br><br>If you would like to sell these you can select it and then put in how many to sell.<br>(if you would like to sell all you can press left arrow key.)<br>Tax: %s because you are selling it to a %s dealer'
          local sto_name = Crypto:GetCryptoDef(k).name
          local sto_worth = vRP:formatMoney(math.floor((v * (1 - tax))* Crypto:GetCryptoDef(k).value).."$")
          local description = sto:format(vRP:formatMoney(v), sto_name, sto_worth.." ("..(tax*100).."% tax)", (tax*100), dealer)
          menu:addOption(Crypto:GetCryptoDef(k).name, ask_sell, description, {id = k})
          has = true
        end
      end
      if not has then
        menu:addOption("You do not have any crypto currencies", nil)
      end
    end

  end)


end


function main_crypto(self)

  function m_crypto(menu)
    menu.user:openMenu("crypto_self")
  end

  function m_sell_crypto(menu)
    local user = menu.user
    user:openMenu("crypto_sell", {dealer = "legal"})
  end


  vRP.EXT.GUI:registerMenuBuilder("crypto_self", function (menu)
    menu.title = "Your Crypto's"
    local user = menu.user
    local vcrypto = user.cdata.crypto
    local has = false

    if type(vcrypto) == "table" then
      for k,v in pairs(vcrypto) do
        if Crypto:GetCryptoDef(k) and v > 0 then
          local sto = [[
            You have: <span style=color:#ba993f>%s %ss</span>, worth: <span style=color:#60bf40>%s</span><br><br>
            You can sell these for money. Or just keep them i guess.
          ]]
          menu:addOption(Crypto:GetCryptoDef(k).name, nil, sto:format(vRP:formatMoney(v), Crypto:GetCryptoDef(k).name, vRP:formatMoney(math.floor(v * Crypto:GetCryptoDef(k).value).."$")))
        else
          menu:addOption("You do not have any crypto currencies", nil)
          end
          has = true
        end
        if not has then
          menu:addOption("You do not have any crypto currencies", nil)
        end
        menu:addOption("Sell Crypto", m_sell_crypto)
      end
    end)

  vRP.EXT.GUI:registerMenuBuilder("main", function(menu)
    local user = menu.user
    menu:addOption("Cryptocurrency", m_crypto)
  end)
end

function Crypto:__construct()
  vRP.Extension.__construct(self)


  function menu_crypto(self)
  end

  menu_sell_crypto(self)
  menu_crypto(self)
  main_crypto(self)
end


function Crypto:GetCryptoDef(id)
  for k,v in pairs(useable_cryptos) do
    if v.id == id then
      return v
    end
  end
  return nil
end

function Crypto:openCryptoSellMenu(type)
  local user = vRP.users_by_source[source]
  user:openMenu("crypto_sell", {dealer = type})
end


function Crypto.User:getCrypto(id)
  if not self.cdata.crypto[id] then
    self.cdata.crypto[id] = 0
  end
  return self.cdata.crypto[id]
end

function Crypto.User:setCrypto(id, amount)
  if self.cdata.crypto[id] ~= amount then
    self.cdata.crypto[id] = amount
  end
end

function Crypto.User:tryCryptoPayment(id, amount, dry)
  local cryptos = self:getCrypto(id)
  if amount >= 0 and cryptos >= amount then
    if not dry then
      self:setCrypto(id,cryptos-amount)
    end
    return true
  else
    return false
  end
end


function Crypto.User:giveCrypto(id, amount)
  self:setCrypto(id, self:getCrypto(id)+math.abs(amount))

end

Crypto.tunnel = {}
Crypto.tunnel.openCryptoSellMenu = Crypto.openCryptoSellMenu

Crypto.event = {}

function Crypto.event:characterLoad(user)
  if not user.cdata.crypto then
    user.cdata.crypto = {}
  end
end



vRP:registerExtension(Crypto)
