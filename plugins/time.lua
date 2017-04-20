--Begin Time.lua By @ImChieF
function run(msg, matches)
local url , res = http.request('http://irapi.ir/time/')
if res ~= 200 then return "No connection" end
local jdat = json:decode(url)
local text = '*🕒 ساعت:* _'..jdat.FAtime..'_\n*📆 امروز :* _'..jdat.FAdate..'_\n-----------------------------------------------------------\n*🕒:* _'..jdat.ENtime..'_\n *📆:* _'..jdat.ENdate.. '_\n'
  tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'md')
end
return {
  patterns = {
  "^[/!]([Tt][iI][Mm][Ee])$",
  "^([Tt][iI][Mm][Ee])$",
  "^(ساعت)$"
  }, 
run = run 
}
--End Time.lua--