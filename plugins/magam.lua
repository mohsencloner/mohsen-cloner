do

local function run(msg, matches)
if matches[1]=="مقام من" and is_sudo(msg) or matches[1]=="magam" and is_sudo(msg) then  
return  "شما صاحب ربات میباشید 😐❤️"
elseif matches[1]=="مقام من" and is_admin(msg) or matches[1]=="magam" and is_admin(msg) then 
return  "شما ادمین ربات میباشید 😐❤️"
elseif matches[1]=="مقام من" and is_owner(msg) or matches[1]=="magam" and is_owner(msg) then 
return  "شما صاحب گروه میباشید 😐❤️"
elseif matches[1]=="مقام من" and is_mod(msg) or matches[1]=="magam" and is_mod(msg) then 
return  "شما مدیر گروه میباشید 😐❤️"
else
return  "شما هیچ عنی نیستید 😐❤️"
end

end

return {
  patterns = {
    "^(مقام من)$",
    "^(magam)$",
    },
  run = run
}
end