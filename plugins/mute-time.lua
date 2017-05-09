
local function pre_process(msg)
  local hash = 'mute_time:'..msg.chat_id_
  if redis:get(hash) and gp_type(msg.chat_id_) == 'channel' and not is_admin(msg)  then
    tdcli.deleteMessages(msg.chat_id_, {[0] = tonumber(msg.id_)})
  end
 end
 
local function run(msg, matches)
  if matches[1]:lower() == 'lock time' and is_admin(msg) or matches[1]:lower() == 'قفل جی تایم ' and is_admin(msg) then
     local hash = 'mute_time:'..msg.chat_id_
     if not matches[2] then
		return "*لطفا بعد از دستور با ایجاد یک فاصله #مقدارساعت را وارد کنید سپس با ایجاد یک فاصله دیگر #مقداردقیقه را وارد کنید 😐❤️\nمثلا برای قفل کرده گروه برای نیم ساعت به صورت زیر عمل کنید\n\nقفل جی تایم 0 30*"
  else
     local hour = string.gsub(matches[2], 'h', '')
     local num1 = tonumber(hour) * 3600
     local minutes = string.gsub(matches[3], 'm', '')
     local num2 = tonumber(minutes) * 60
     local num4 = tonumber(num1 + num2)
	 redis:setex(hash, num4, true)
     return "انجام شد !\n\n⛔️ گروه با موفقیت به مدت\n*[ "..matches[2].. " ]* ساعت و \n*[ "..matches[3].." ]* دقیقه \n #قفل شد 😐❤️"
    end
  end
  if matches[1]:lower() == 'unlock time' and is_admin(msg) or matches[1]:lower() == 'بازکردن جی تایم' and is_admin(msg) then
     local hash = 'mute_time:'..msg.chat_id_
     redis:del(hash)
     return "انجام شد !\n\nقفل جی تایم با موفقیت #غیرفعال شد 😐❤️"
  end
end
return {
   patterns = {
      '^([Ll]ock time)$',
      '^(قفل جی تایم)$',
      '^([Uu]nlock time)$',
      '^(بازکردن جی تایم)$',
	  '^([Ll]ock time) (%d+) (%d+)$',
	  '^(قفل جی تایم) (%d+) (%d+)$',
 },
  run = run,
  pre_process = pre_process
}