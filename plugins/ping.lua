--start by edit by @Professortelegram
local datebase = {
  "  ♻️This Is a Online♻️ ",

  }
local function run(msg, matches) 
return datebase[math.random(#datebase)]
end
return {
  patterns = {
    "^(انلاینی)",
"^(روشنی)",
  },
  run = run
}

--end by edit by @Professortelegram
--Channel 
