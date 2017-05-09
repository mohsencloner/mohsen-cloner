do

local function run(msg, matches)
if matches[1]=="😐" and is_sudo(msg) then  
return  "😐"
elseif matches[1]=="😐" and is_admin(msg) then 
return  "😐"
elseif matches[1]=="😐" and is_owner(msg) then 
return  "😐"

end

end

return {
  patterns = {
    "^(😐)$",
    },
  run = run
}
end


--By @Tele_Sudo
-- @LuaError