--Begin Tools.lua :)
local SUDO = 285512862 -- put Your ID here! <===
function exi_files(cpath)
    local files = {}
    local pth = cpath
    for k, v in pairs(scandir(pth)) do
		table.insert(files, v)
    end
    return files
end

local function file_exi(name, cpath)
    for k,v in pairs(exi_files(cpath)) do
        if name == v then
            return true
        end
    end
    return false
end
local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
local function index_function(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end

local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 

local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

local function exi_file()
    local files = {}
    local pth = tcpath..'/data/document'
    for k, v in pairs(scandir(pth)) do
        if (v:match('.lua$')) then
            table.insert(files, v)
        end
    end
    return files
end

local function pl_exi(name)
    for k,v in pairs(exi_file()) do
        if name == v then
            return true
        end
    end
    return false
end

local function sudolist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local sudo_users = _config.sudo_users
  if not lang then
 text = "*List of sudo users :*\n"
   else
 text = "لیست #سودوها 😐❤️\n\n"
  end
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end
local function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return 'No groups at the moment'
    end
    local message = 'List of Groups:\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
        for m,n in pairsByKeys(settings) do
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				group_name_id = name .. '\n(ID: ' ..group_id.. ')\n\n'
				if name:match("[\216-\219][\128-\191]") then
					group_info = i..' - \n'..group_name_id
				else
					group_info = i..' - '..group_name_id
				end
				i = i + 1
			end
        end
		message = message..group_info
    end
	return message
end

local function botrem(msg)
	local data = load_data(_config.moderation.data)
	data[tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	if redis:get('CheckExpire::'..msg.to.id) then
		redis:del('CheckExpire::'..msg.to.id)
	end
	if redis:get('ExpireDate:'..msg.to.id) then
		redis:del('ExpireDate:'..msg.to.id)
	end
	tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
end

local function warning(msg)
	local hash = "gp_lang:"..msg.to.id
	local lang = redis:get(hash)
	local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
	if expiretime == -1 then
		return
	else
	local d = math.floor(expiretime / 86400) + 1
        if tonumber(d) == 1 and not is_sudo(msg) and is_mod(msg) then
			if lang then
				tdcli.sendMessage(msg.to.id, 0, 1, 'تاریخ انقضای ربات رو به اتمام است 😐❤️\n\nبرای شارژ مجدد ربات میتوانید از طریق آیدی زیر با پشتیبانی در ارتباط باشید\n@mybotsuport\n\nدر غیر این صورت ربات گروه را ترک خواهد کرد ...', 1, 'md')
			else
				tdcli.sendMessage(msg.to.id, 0, 1, '_Group 1 day remaining charge, to recharge the robot contact with the sudo. With the completion of charging time, the group removed from the robot list and the robot will leave the group._', 1, 'md')
			end
		end
	end
end

local function action_by_reply(arg, data)
    local cmd = arg.cmd
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
    if cmd == "visudo" or cmd == "ارتقا به سودو" then
local function visudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* سودو ربات #است ... 😐❤️", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now_ *sudoer*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* به مقام سودو #ارتقا یافت ... 😐❤️", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, visudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "desudo" or cmd == "حذف سودو" then
local function desudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* سودو ربات #نیست ... 😐❤️", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* از مقام سودو #حذف شد ... 😐❤️", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, desudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "کاربر #موجود نیست ... 😐❤️", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local cmd = arg.cmd
if not arg.username then return false end
    if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end

    if cmd == "visudo" or cmd == "ارتقا به سودو" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* سودو ربات #است ... 😐❤️", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now_ *sudoer*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* به مقام سودو #ارتقا یافت ... 😐❤️", 0, "md")
   end
end
    if cmd == "desudo" or cmd == "حذف سودو" then
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* سودو ربات #نیست ... 😐❤️", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* از مقام سودو #حذف شد ... 😐❤️", 0, "md")
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر #موجود نیست ... 😐❤️", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local cmd = arg.cmd
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end

    if cmd == "visudo" or cmd == "ارتقا به سودو" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* سودو ربات #است ... 😐❤️", 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now_ *sudoer*", 0, "md")
  else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* به مقام سودو #ارتقا یافت ... 😐❤️", 0, "md")
   end
end
    if cmd == "desudo" or cmd == "حذف سودو" then
     if not already_sudo(data.id_) then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* سودو ربات #نیست ... 😐❤️", 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *sudoer*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* از مقام سودو #حذف شد ... 😐❤️", 0, "md")
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر #موجود نیست ... 😐❤️", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function pre_process(msg)
	if msg.to.type ~= 'pv' then
		local hash = "gp_lang:"..msg.to.id
		local lang = redis:get(hash)
		local data = load_data(_config.moderation.data)
		local gpst = data[tostring(msg.to.id)]
		local chex = redis:get('CheckExpire::'..msg.to.id)
		local exd = redis:get('ExpireDate:'..msg.to.id)
		if gpst and not chex and msg.from.id ~= SUDO and not is_sudo(msg) then
			redis:set('CheckExpire::'..msg.to.id,true)
			redis:set('ExpireDate:'..msg.to.id,true)
			redis:setex('ExpireDate:'..msg.to.id, 86400, true)
			if lang then
				tdcli.sendMessage(msg.to.id, msg.id_, 1, 'تاریخ انقضای ربات رو به اتمام است 😐❤️\n\nبرای شارژ مجدد ربات میتوانید از طریق آیدی زیر با پشتیبانی در ارتباط باشید ...\n@mybotsuport\n\n', 1, 'md')
			else
				tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Group charged 1 day. to recharge the robot contact with the sudo. With the completion of charging time, the group removed from the robot list and the robot will leave the group._', 1, 'md')
			end
		end
		if chex and not exd and msg.from.id ~= SUDO and not is_sudo(msg) then
			local text1 = 'تاریخ انقضای ربات در این گروه به پایان رسیده است 😐❤️ \n\nID:  <code>'..msg.to.id..'</code>\n\nبرای اینکه ربات گروه را ترک کند دستور زیر را وارد نمایید\n\nخارج شو '..msg.to.id..'\nبرای شارژ کردن دوباره ربات از دستورات زیر استفاده کنید...\n\n<b>شارژ کردن به مدت 1 ماه</b>\nپلن 1 '..msg.to.id..'\n\n<b>شارژ کردن به مدت 3 ماه</b>\nپلن 2 '..msg.to.id..'\n\n<b>شارژ کردن به مدت نامحدود</b>\nپلن 3 '..msg.to.id
			local text2 = 'متاسفم ! 😐❤️\n\nشارژ این گروه به #پایان رسیده است\nربات به دلیل عدم شارژ مجدد از گروه #خارج میشود ...'
			local text3 = '_Charging finished._\n\n*Group ID:*\n\n*ID:* `'..msg.to.id..'`\n\n*If you want the robot to leave this group use the following command:*\n\n`/Leave '..msg.to.id..'`\n\n*For Join to this group, you can use the following command:*\n\n`/Jointo '..msg.to.id..'`\n\n_________________\n\n_If you want to recharge the group can use the following code:_\n\n*To charge 1 month:*\n\n`/Plan 1 '..msg.to.id..'`\n\n*To charge 3 months:*\n\n`/Plan 2 '..msg.to.id..'`\n\n*For unlimited charge:*\n\n`/Plan 3 '..msg.to.id..'`'
			local text4 = '_Charging finished. Due to lack of recharge remove the group from the robot list and the robot leave the group._'
			if lang then
				tdcli.sendMessage(SUDO, 0, 1, text1, 1, 'html')
				tdcli.sendMessage(msg.to.id, 0, 1, text2, 1, 'md')
			else
				tdcli.sendMessage(SUDO, 0, 1, text3, 1, 'md')
				tdcli.sendMessage(msg.to.id, 0, 1, text4, 1, 'md')
			end
			botrem(msg)
		else
			local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
			local day = (expiretime / 86400)
			if tonumber(day) > 0.208 and not is_sudo(msg) and is_mod(msg) then
				warning(msg)
			end
		end
	end
end

local function run(msg, matches)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if tonumber(msg.from.id) == SUDO then
if matches[1] == "clear cache" or matches[1] == "پاکسازی کش" then
     run_bash("rm -rf ~/.telegram-cli/data/sticker/*")
     run_bash("rm -rf ~/.telegram-cli/data/photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/animation/*")
     run_bash("rm -rf ~/.telegram-cli/data/video/*")
     run_bash("rm -rf ~/.telegram-cli/data/audio/*")
     run_bash("rm -rf ~/.telegram-cli/data/voice/*")
     run_bash("rm -rf ~/.telegram-cli/data/temp/*")
     run_bash("rm -rf ~/.telegram-cli/data/thumb/*")
     run_bash("rm -rf ~/.telegram-cli/data/document/*")
     run_bash("rm -rf ~/.telegram-cli/data/profile_photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/encrypted/*")
    return "انجام شد ! 😐❤️\n\nپاکسازی کش با موفقیت #انجام شد"
   end
if matches[1] == "visudo" or matches[1] == "ارتقا به سودو" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="visudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="visudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="visudo"})
      end
   end
if matches[1] == "desudo" or matches[1] == "حذف سودو" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="desudo"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="desudo"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="desudo"})
      end
   end
end
if is_sudo(msg) then
   		if matches[1]:lower() == 'add' and not redis:get('ExpireDate:'..msg.to.id) or matches[1]:lower() == 'فعال شو' and not redis:get('ExpireDate:'..msg.to.id) then
			redis:set('ExpireDate:'..msg.to.id,true)
			redis:setex('ExpireDate:'..msg.to.id, 120, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id,true)
				end
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'گروه به مدت *[ 2 ]* دقیقه برای انجام تنظیمات #فعال شد 😐❤️', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Group charged 3 minutes  for settings._', 1, 'md')
				end
		end
		if matches[1] == 'rem' or matches[1] == 'غیرفعال شو' then
			if redis:get('CheckExpire::'..msg.to.id) then
				redis:del('CheckExpire::'..msg.to.id)
			end
			redis:del('ExpireDate:'..msg.to.id)
		end
		if matches[1]:lower() == 'gid' or matches[1]:lower() == 'شناسه گروه' then
			tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..msg.to.id..'`', 1,'md')
		end
		if matches[1] == 'leave' and matches[2] or matches[1] == 'خارج شو' and matches[2] then
			if lang then
				tdcli.sendMessage(matches[2], 0, 1, 'ربات با دستور سودو از گروه #خارج می شود 😐❤️\nبرای اطلاعات بیشتر با سودو تماس بگیرید.', 1, 'md')
				tdcli.changeChatMemberStatus(matches[2], our_id, 'Left', dl_cb, nil)
				tdcli.sendMessage(SUDO, msg.id_, 1, 'ربات با موفقیت از گروه '..matches[2]..' خارج شد.', 1,'md')
			else
				tdcli.sendMessage(matches[2], 0, 1, '_Robot left the group._\n*For more information contact The SUDO.*', 1, 'md')
				tdcli.changeChatMemberStatus(matches[2], our_id, 'Left', dl_cb, nil)
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Robot left from under group successfully:*\n\n`'..matches[2]..'`', 1,'md')
			end
		end
		if matches[1]:lower() == 'charge' and matches[2] and matches[3] or matches[1]:lower() == 'شارژکردن' and matches[2] and matches[3] then
		if string.match(matches[2], '^-%d+$') then
			if tonumber(matches[3]) > 0 and tonumber(matches[3]) < 2001 then
				local extime = (tonumber(matches[3]) * 86400)
				redis:setex('ExpireDate:'..matches[2], extime, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id,true)
				end
				if lang then
					tdcli.sendMessage(SUDO, 0, 1, 'تاریخ انقضای ربات '..matches[2]..' به مدت '..matches[3]..' #افزایش یافت 😐❤️.', 1, 'md')
					tdcli.sendMessage(matches[2], 0, 1, 'ربات توسط ادمین به مدت `'..matches[3]..'` روز #شارژ شد 😐❤️\nبرای مشاهده شارژ گروه دستور [ وضعیت شارژ ] را استفاده کنید...',1 , 'md')
				else
					tdcli.sendMessage(SUDO, 0, 1, '*Recharged successfully in the group:* `'..matches[2]..'`\n_Expire Date:_ `'..matches[3]..'` *Day(s)*', 1, 'md')
					tdcli.sendMessage(matches[2], 0, 1, '*Robot recharged* `'..matches[3]..'` *day(s)*\n*For checking expire date, send* `/check`',1 , 'md')
				end
			else
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'عدد وارد شده صحیح نمی باشد !\n\nتعداد روزها باید #عددی بین *[ 1 - 2000 ]* باشد 😐❤️', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Expire days must be between 1 - 2000_', 1, 'md')
				end
			end
		end
		end
		if matches[1]:lower() == 'plan' and matches[2] == '1' and matches[3] or matches[1]:lower() == 'پلن' and matches[2] == '1' and matches[3] then
		if string.match(matches[3], '^-%d+$') then
			local timeplan1 = 2592000
			redis:setex('ExpireDate:'..matches[3], timeplan1, true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, 'انجام شد !\n\nپلن *[ 1 ]* با موفقیت برای گروه *[ '..matches[3]..' ]* فعال شد 😐❤️\nربات تا *[ 30 ]* روز در گروه فعالیت #خواهد کرد !  *[ 1 ماه ]* ', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, 'انجام شد ! 😐❤️\n\nربات با موفقیت برای *[ 30 ]* روز #شارژ شد', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Plan 1 Successfully Activated!\nThis group recharged with plan 1 for 30 days (1 Month)*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '*Successfully recharged*\n*Expire Date:* `30` *Days (1 Month)*', 1, 'md')
			end
		end
		end
		if matches[1]:lower() == 'plan' and matches[2] == '2' and matches[3] or matches[1]:lower() == 'پلن' and matches[2] == '2' and matches[3] then
		if string.match(matches[3], '^-%d+$') then
			local timeplan2 = 7776000
			redis:setex('ExpireDate:'..matches[3],timeplan2,true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end

			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, 'انجام شد !\n\nپلن *[ 2 ]* با موفقیت برای گروه *[ '..matches[3]..' ]* فعال شد 😐❤️\nربات تا *[ 90 ]* روز در گروه فعالیت #خواهد کرد !  *[ 3 ماه ]* ', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, 'انجام شد ! 😐❤️\n\nربات با موفقیت برای *[ 90 ]* روز #شارژ شد', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Plan 2 Successfully Activated!\nThis group recharged with plan 2 for 90 days (3 Month)*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '*Successfully recharged*\n*Expire Date:* `90` *Days (3 Months)*', 1, 'md')
			end
		end
		end
		if matches[1]:lower() == 'plan' and matches[2] == '3' and matches[3] or matches[1]:lower() == 'پلن' and matches[2] == '3' and matches[3] then
		if string.match(matches[3], '^-%d+$') then
			redis:set('ExpireDate:'..matches[3],true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, 'انجام شد !\n\nپلن *[ 3 ]* با موفقیت برای گروه *[ '..matches[3]..' ]* فعال شد 😐❤️\nربات به صورت نا محدود در گروه فعالیت #خواهد کرد !  *[ نا محدود ]* ', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, 'انجام شد ! 😐❤️\n\nربات با موفقیت به صورت *[ نا محدود ]* #شارژ شد', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Plan 3 Successfully Activated!\nThis group recharged with plan 3 for unlimited*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '*Successfully recharged*\n*Expire Date:* `Unlimited`', 1, 'md')
			end
		end
		end
	
end
	if matches[1]:lower() == 'savefile' and matches[2] and is_sudo(msg) or matches[1]:lower() == 'ذخیره فایل' and matches[2] and is_sudo(msg) then
		if msg.reply_id  then
			local folder = matches[2]
            function get_filemsg(arg, data)
				function get_fileinfo(arg,data)
                    if data.content_.ID == 'MessageDocument' or data.content_.ID == 'MessagePhoto' or data.content_.ID == 'MessageSticker' or data.content_.ID == 'MessageAudio' or data.content_.ID == 'MessageVoice' or data.content_.ID == 'MessageVideo' or data.content_.ID == 'MessageAnimation' then
                        if data.content_.ID == 'MessageDocument' then
							local doc_id = data.content_.document_.document_.id_
							local filename = data.content_.document_.file_name_
                            local pathf = tcpath..'/data/document/'..filename
							local cpath = tcpath..'/data/document'
                            if file_exi(filename, cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(doc_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>فایل</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>File</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessagePhoto' then
							local photo_id = data.content_.photo_.sizes_[2].photo_.id_
							local file = data.content_.photo_.id_
                            local pathf = tcpath..'/data/photo/'..file..'_(1).jpg'
							local cpath = tcpath..'/data/photo'
                            if file_exi(file..'_(1).jpg', cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(photo_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>عکس</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Photo</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
		                if data.content_.ID == 'MessageSticker' then
							local stpath = data.content_.sticker_.sticker_.path_
							local sticker_id = data.content_.sticker_.sticker_.id_
							local secp = tostring(tcpath)..'/data/sticker/'
							local ffile = string.gsub(stpath, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(stpath, pfile)
                                file_dl(sticker_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>استیکر</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Sticker</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageAudio' then
						local audio_id = data.content_.audio_.audio_.id_
						local audio_name = data.content_.audio_.file_name_
                        local pathf = tcpath..'/data/audio/'..audio_name
						local cpath = tcpath..'/data/audio'
							if file_exi(audio_name, cpath) then
								local pfile = folder
								os.rename(pathf, pfile)
								file_dl(audio_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>صدای</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Audio</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
							else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
							end
						end
						if data.content_.ID == 'MessageVoice' then
							local voice_id = data.content_.voice_.voice_.id_
							local file = data.content_.voice_.voice_.path_
							local secp = tostring(tcpath)..'/data/voice/'
							local ffile = string.gsub(file, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(file, pfile)
                                file_dl(voice_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>صوت</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Voice</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageVideo' then
							local video_id = data.content_.video_.video_.id_
							local file = data.content_.video_.video_.path_
							local secp = tostring(tcpath)..'/data/video/'
							local ffile = string.gsub(file, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(file, pfile)
                                file_dl(video_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>ویديو</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Video</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageAnimation' then
							local anim_id = data.content_.animation_.animation_.id_
							local anim_name = data.content_.animation_.file_name_
                            local pathf = tcpath..'/data/animation/'..anim_name
							local cpath = tcpath..'/data/animation'
                            if file_exi(anim_name, cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(anim_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>تصویر متحرک</b> <code>'..folder..'</code> <b>ذخیره شد.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Gif</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_فایل مورد نظر وجود ندارد. فایل را دوباره ارسال کنید._', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
                    else
                        return
                    end
                end
                tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, get_fileinfo, nil)
            end
	        tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_to_message_id_ }, get_filemsg, nil)
        end
    end
	if msg.to.type == 'channel' or msg.to.type == 'chat' then
		if matches[1] == 'charge' and matches[2] and not matches[3] and is_sudo(msg) or matches[1] == 'شارژکردن' and matches[2] and not matches[3] and is_sudo(msg) then
			if tonumber(matches[2]) > 0 and tonumber(matches[2]) < 2001 then
				local extime = (tonumber(matches[2]) * 86400)
				redis:setex('ExpireDate:'..msg.to.id, extime, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id)
				end
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'انجام شد !\n\nربات با موفقیت در گروه به مدت *[ '..matches[2]..' ]* روز #شارژ شد ...  😐❤️', 1, 'md')
					tdcli.sendMessage(SUDO, 0, 1, 'ربات در گروه *[ '..msg.to.id..' ]* به مدت *[ '..matches[2]..' ]* روز #شارژ شد ... 😐❤️', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'انجام شد ! 😐❤️\n\nربات با موفقیت در گروه به مدت *[ '..matches[2]..' ]* روز #شارژ شد ...  😐❤️', 1, 'md')
					tdcli.sendMessage(SUDO, 0, 1, 'ربات در گروه *[ '..msg.to.id..' ]* به مدت *[ '..matches[2]..' ]* روز #شارژ شد ... 😐❤️', 1, 'md')
				end
			else
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'عدد وارد شده صحیح نمی باشد !\n\nتعداد روزها باید #عددی بین *[ 1 - 2000 ]* باشد ... 😐❤️', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Expire days must be between 1 - 1000_', 1, 'md')
				end
			end
		end
		if matches[1]:lower() == 'charge status' and is_mod(msg) and not matches[2] or matches[1]:lower() == 'وضعیت شارژ' and is_mod(msg) and not matches[2] then
			local expi = redis:ttl('ExpireDate:'..msg.to.id)
			if expi == -1 then
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'ربات به مدت نامحدود در گروه #شارژ می باشد 😐❤️', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Unlimited Charging!_', 1, 'md')
				end
			else
				local day = math.floor(expi / 86400) + 1
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'ربات به مدت *[ '..day..' ]* روز در گروه #شارژ می باشد  😐❤️', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..day..'` *Day(s) remaining until Expire.*', 1, 'md')
				end
			end
		end
		if matches[1] == 'charge status' and is_mod(msg) and matches[2] or matches[1] == 'وضعیت شارژ' and is_mod(msg) and matches[2] then
		if string.match(matches[2], '^-%d+$') then
			local expi = redis:ttl('ExpireDate:'..matches[2])
			if expi == -1 then
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'ربات به مدت نامحدود در گروه #شارژ می باشد 😐❤️', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Unlimited Charging!_', 1, 'md')
				end
			else
				local day = math.floor(expi / 86400 ) + 1
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'ربات به مدت *[ '..day..' ]* روز در گروه #شارژ می باشد  😐❤️', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..day..'` *Day(s) remaining until Expire.*', 1, 'md')
				end
			end
		end
		end
	end


if matches[1] == 'creategroup' and is_admin(msg) or matches[1] == 'ساخت گروه' and is_admin(msg) then
local text = matches[2]
tdcli.createNewGroupChat({[0] = msg.from.id}, text, dl_cb, nil)
  if not lang then
return '_Group Has Been Created!_'
  else
return 'انجام شد ! 😐❤️\n\nگروه مورد نظر #ساخته شد'
   end
end

if matches[1] == 'createsuper' and is_admin(msg) or matches[1] == 'ساخت سوپرگروه' and is_admin(msg) then
local text = matches[2]
tdcli.createNewChannelChat(text, 1, '', dl_cb, nil)
   if not lang then 
return '_SuperGroup Has Been Created!_'
  else
return 'انجام شد ! 😐❤️\n\nسوپر گروه مورد نظر #ساخته شد'
   end
end

if matches[1] == 'tosuper' and is_admin(msg) or matches[1] == 'ارتقا به سوپرگروه' and is_admin(msg) then
local id = msg.to.id
tdcli.migrateGroupChatToChannelChat(id, dl_cb, nil)
  if not lang then
return '_Group Has Been Changed To SuperGroup!_'
  else
return 'انجام شد ! 😐❤️\n\nگروه مورد نظر به سوپرگروه #ارتقا یافت'
   end
end

if matches[1] == 'jointo' and is_admin(msg) or matches[1] == 'واردشو' and is_admin(msg) then
tdcli.importChatInviteLink(matches[2])
   if not lang then
return '*Done!*'
  else
return 'انجام شد ! 😐❤️\n\nربات با لینک #وارد گروه شد'
  end
end

if matches[1] == 'setbotname' and is_sudo(msg) or matches[1] == 'تنظیم نام ربات' and is_sudo(msg) then
tdcli.changeName(matches[2])
   if not lang then
return '_Bot Name Changed To:_ *'..matches[2]..'*'
  else
return 'انجام شد ! 😐❤️\n\nبا موفقیت اسم ربات  #تغییر کرد به *'..matches[2]..'*'
   end
end

if matches[1] == 'setbotusername' and is_sudo(msg) or matches[1] == 'تنظیم ایدی ربات' and is_sudo(msg) then
tdcli.changeUsername(matches[2])
   if not lang then
return '_Bot Username Changed To:_ @'..matches[2]
  else
return 'انجام شد ! 😐❤️\n\nبا موفقیت آیدی ربات  #تغییر کرد به :*'..matches[2]..'*'
   end
end

if matches[1] == 'delbotusername' and is_sudo(msg) or matches[1] == 'حذف ایدی ربات' and is_sudo(msg) then
tdcli.changeUsername('')
   if not lang then
return '*Done!*'
  else
return 'انجام شد ! 😐❤️\n\nبا موفقیت آیدی ربات #حذف شد'
  end
end

if matches[1] == 'markread' and is_sudo(msg) or matches[1] == 'تیک دوم' and is_sudo(msg) then
if matches[2] == 'on' or matches[2] == 'فعال' then
redis:set('markread','on')
   if not lang then
return '_Markread >_ *ON*'
else
return 'انجام شد ! 😐❤️\n\nبا موفقیت تیک دوم #فعال شد'
   end
end
if matches[2] == 'off' or matches[2] == 'غیرفعال' then
redis:set('markread','off')
  if not lang then
return '_Markread >_ *OFF*'
   else
return 'انجام شد ! 😐❤️\n\nبا موفقیت تیک دوم #غیرفعال شد'
      end
   end
end

if matches[1] == 'bc' and is_admin(msg) or matches[1] == 'پیام خاص' and is_admin(msg) then
		local text = matches[2]
tdcli.sendMessage(matches[3], 0, 0, text, 0)	end

if matches[1] == 'broadcast' and is_sudo(msg) or matches[1] == 'پیام کلی' and is_sudo(msg) then		
local data = load_data(_config.moderation.data)		
local bc = matches[2]			
for k,v in pairs(data) do				
tdcli.sendMessage(k, 0, 0, bc, 0)			
end	
end

  if is_sudo(msg) then
	if matches[1]:lower() == "sendfile" and matches[2] and matches[3] or matches[1]:lower() == "ارسال فایل" and matches[2] and matches[3] then
		local send_file = 
"./"..matches[2].."/"..matches[3]
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 
1, nil, send_file, ' ', dl_cb, nil)
	end
	if matches[1]:lower() == "sendplug" and matches[2] or matches[1]:lower() == "ارسال پلاگین" and matches[2] then
	    local plug = "./plugins/"..matches[2]..".lua"
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 
1, nil, plug, ' ', dl_cb, nil)
    end
  end

    if matches[1]:lower() == 'save' and matches[2] and is_sudo(msg) or matches[1]:lower() == 'ذخیره پلاگین' and matches[2] and is_sudo(msg) then
        if tonumber(msg.reply_to_message_id_) ~= 0  then
            function get_filemsg(arg, data)
                function get_fileinfo(arg,data)
                    if data.content_.ID == 'MessageDocument' then
                        fileid = data.content_.document_.document_.id_
                        filename = data.content_.document_.file_name_
                        if (filename:lower():match('.lua$')) then
                            local pathf = tcpath..'/data/document/'..filename
                            if pl_exi(filename) then
                                local pfile = 'plugins/'..matches[2]..'.lua'
                                os.rename(pathf, pfile)
                                tdcli.downloadFile(fileid , dl_cb, nil)
                                tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Plugin</b> <code>'..matches[2]..'</code> <b>Has Been Saved.</b>', 1, 'html')
                            else
                                tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
                            end
                        else
                            tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file is not Plugin File._', 1, 'md')
                        end
                    else
                        return
                    end
                end
                tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, get_fileinfo, nil)
            end
	        tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_to_message_id_ }, get_filemsg, nil)
        end
    end

if matches[1] == 'sudolist' and is_sudo(msg) or matches[1] == 'لیست سودو' and is_sudo(msg) then
return sudolist(msg)
    end
if matches[1] == 'chats' and is_admin(msg) or matches[1] == 'چت ها' and is_admin(msg) then
return chat_list(msg)
    end
		if matches[1] == 'rem' and matches[2] and is_admin(msg) or matches[1] == 'غیرفعال شو' and matches[2] and is_admin(msg) then
    local data = load_data(_config.moderation.data)
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
	   tdcli.sendMessage(matches[2], 0, 1, "Group has been removed by admin command", 1, 'html')
    return '_Group_ *'..matches[2]..'* _removed_'
		end
if matches[1] == 'Behiiiiibots' or matches[1] == 'تله برتر' then
return tdcli.sendMessage(msg.to.id, msg.id, 1, _config.info_text, 1, 'html')
    end
if matches[1] == 'adminlist' and is_admin(msg) or matches[1] == 'لیست ادمین' and is_admin(msg) then
return adminlist(msg)
    end
     if matches[1] == 'leave' and is_admin(msg) or matches[1] == 'خارج شو' and is_admin(msg) then
  tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
   end
     if matches[1] == 'autoleave' and is_admin(msg) or matches[1] == 'خروج خودکار' and is_admin(msg) then
local hash = 'auto_leave_bot'
--Enable Auto Leave
     if matches[2] == 'enable' or matches[2] == 'فعال' then
    redis:del(hash)
return 'انجام شد ! 😐❤️\n\nبا موفقیت خروج خودکار #فعال شد'
--Disable Auto Leave
     elseif matches[2] == 'disable' or matches[2] == 'غیرفعال' then
    redis:set(hash, true)
return 'انجام شد ! 😐❤️\n\nبا موفقیت خروج خودکار #غیرفعال شد'
--Auto Leave Status
      elseif matches[2] == 'status' or matches[2] == '؟' then
      if not redis:get(hash) then
   return 'خروج خودکار #فعال است 😐❤️'
       else
   return 'خروج خودکار #غیرفعال است 😐❤️'
         end
      end
   end



if matches[1] == "#راهنمای سودو" and is_mod(msg) then
text = [[

*🔃راهنـــمای سودو هــا*

➖➖➖➖➖➖➖➖➖

*🔴 >>  visudo*
🔴 >>  ارتقا به سودو

💬 ارتقا دادن به مقام #صاحب ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  desudo*
🔴 >>  حذف سودو

💬 حذف کردن از مقام #صاحب ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  sudolist*
🔴 >>  لیست سودو

💬 نمایش لیست #صاحبان ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  setowner*
🔴 >>  ارتقا به مالک

💬 تعیین مدیرا#صلی گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  remowner*
🔴 >>  حذف مالک

💬 حذف #مدیراصلی 

➖➖➖➖➖➖➖➖➖

*🔴 >>  banall*
🔴 >>  مسدودسازی

💬 مسدود کردن شخصی از تمامی #گروه های ربات 

➖➖➖➖➖➖➖➖➖

*🔴 >>  unbanall*
🔴 >>  ازادسازی

💬 ازاد کردن شخصی از تمامی #گروه های ربات 

➖➖➖➖➖➖➖➖➖

*🔴 >>  leave*
🔴 >>  خارج شو

💬 ترک کردن گروه #توسط ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  autoleave enable*
🔴 >>  خروخ خودکار فعال

💬 خارج شدن خودکار ربات از گروه در صورت #فعال نبودن

➖➖➖➖➖➖➖➖➖

*🔴 >>  autoleave disable*
🔴 >>  خروخ خودکار غیرفعال

💬 خارج نشدن خودکار ربات از گروه در صورت #فعال نبودن

➖➖➖➖➖➖➖➖➖

*🔴 >>  creategroup*
🔴 >>  ساخت گروه

💬 ایجاد گروه #توسط ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  createsuper*
🔴 >>  ساخت سوپرگروه

💬 ایجاد سوپرگروه #توسط ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  tosuper*
🔴 >>  ارتقا به سوپرگروه

💬 تبدیل گروه به #سوپرگروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  rem*
🔴 >>  غیرفعال شو

💬 پاک کردن #تنظیمات ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  Jointo [ link ]*
🔴 >>  واردشو [ لینک ]

💬 وارد شدن #ربات با لینک

➖➖➖➖➖➖➖➖➖

*🔴 >>  setbotname*
🔴 >>  تنظیم نام ربات

💬 تغییردادن #نام ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  setbotusername*
🔴 >>  تنظیم ایدی ربات

💬 تغییر دادن #آیدی ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  delbotusername*
🔴 >>  حذف ایدی ربات

💬 حذف کردن #آیدی ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  markread on*
🔴 >>  تیک دوم فعال

💬 خوانده شدن پیام ها #توسط ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  markread off*
🔴 >>  تیک دوم غیرفعال

💬 خوانده نشدن پیام ها #توسط ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  broadcast*
🔴 >>  پیام کلی

💬 ارسال پیام به تمامی #گروه های ربات

➖➖➖➖➖➖➖➖➖

*🔴 >>  bc [ Text ] [ Gpid ]*
🔴 >>  پیام خاص [ متن ] [ آیدی گروه ]

💬 ارسال پیام به #گروه خاصی

➖➖➖➖➖➖➖➖➖

*🔴 >>  sendfile [ folder ] [ file ]*
🔴 >>  ارسال فایل [نام پوشه] [نام فایل]

💬 ارسال فایل #مورد نظر

➖➖➖➖➖➖➖➖➖

*🔴 >>  sendplug [ plug ]*
🔴 >>  ارسال پلاگین [ نام پلاگین ]

💬 ارسال فایل #مورد نظر

➖➖➖➖➖➖➖➖➖

*🔴 >>  save [ plugin name ] [ reply ]*
🔴 >>  ذخیره پلاگین [ نام پلاگین ] [ رپلی کردن ]

💬 ارسال فایل #مورد نظر

➖➖➖➖➖➖➖➖➖

*🔴 >>  savefile [ address/filename ] [ reply ]*
🔴 >>  ذخیره فایل [نام فایل/آدرس] [رپلی کردن]

💬 ارسال فایل #مورد نظر

➖➖➖➖➖➖➖➖➖

*🔴 >>  clear cache*
🔴 >>  پاکسازی کش

💬 پاکسازی فایل های #درون کش

➖➖➖➖➖➖➖➖➖

*🔴 >>  charge [ Number Of Days ]*
🔴 >>  شارژکردن [ تعداد روز ]

💬 تنظیم تاریخ انقضای #ربات در گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  charge [ GroupID ] [ Number Of Days ]*
🔴 >>  شارژکردن [ آیدی گروه] [ تعداد روز ]

💬 تنظیم تاریخ انقضای ربات بدون وارد شدن #سودو در گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  charge status*
🔴 >>  وضعیت شارژ

💬 اطلاع از تاریخ انقضای #ربات در گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  charge status [ GroupID ]*
🔴 >>  شارژکردن [ آیدی گروه]

💬 اطلاع از تاریخ انقضای ربات بدون وارد شدن #سودو به گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  leave [GroupID]*
🔴 >>  وضعیت شارژ [ آیدی گروه ]

💬 خارج شدن ربات بدون وارد شدن #سودو به گروه

➖➖➖➖➖➖➖➖➖



]]
return text

end
end

return { 
patterns = {                                                                   
"^(#راهنمای سودو)$", 
"^(visudo)$", 
"^(ارتقا به سودو)$", 
"^(desudo)$",
"^(حذف سودو)$",
"^(sudolist)$",
"^(لیست سودو)$",
"^(visudo) (.*)$", 
"^(ارتقا به سودو) (.*)$", 
"^(desudo) (.*)$",
"^(حذف سودو) (.*)$",
"^(adminprom)$", 
"^(ارتقا به ادمین)$", 
"^(admindem)$",
"^(حذف ادمین)$",
"^(adminlist)$",
"^(لیست ادمین)$",
"^(adminprom) (.*)$", 
"^(ارتقا به ادمین) (.*)$", 
"^(admindem) (.*)$",
"^(حذف ادمین) (.*)$",
"^(leave)$",
"^(خارج شو)$",
"^(autoleave) (.*)$", 
"^(خروج خودکار) (.*)$", 
"^(Behiiiiibots)$",
"^(تله برتر)$",
"^(creategroup) (.*)$",
"^(ساخت گروه) (.*)$",
"^(createsuper) (.*)$",
"^(ساخت سوپرگروه) (.*)$",
"^(tosuper)$",
"^(ارتقا به سوپرگروه)$",
"^(chats)$",
"^(چت ها)$",
"^(clear cache)$",
"^(پاکسازی کش)$",
"^(rem) (.*)$",
"^(غیرفعال شو) (.*)$",
"^(jointo) (.*)$",
"^(واردشو) (.*)$",
"^(setbotname) (.*)$",
"^(تنظیم نام ربات) (.*)$",
"^(setbotusername) (.*)$",
"^(تنظیم ایدی ربات) (.*)$",
"^(delbotusername) (.*)$",
"^(حذف ایدی ربات) (.*)$",
"^(markread) (.*)$",
"^(تیک دوم) (.*)$",
"^(bc) +(.*) (.*)$",
"^(پیام خاص) +(.*) (.*)$",
"^(broadcast) (.*)$",
"^(پیام کلی) (.*)$",
"^(sendfile) (.*) (.*)$",
"^(ارسال فایل) (.*) (.*)$",
"^(save) (.*)$",
"^(ذخیره پلاگین) (.*)$",
"^(sendplug) (.*)$",
"^(ارسال پلاگین) (.*)$",
"^(savefile) (.*)$",
"^(ذخیره فایل) (.*)$",
"^([Aa]dd)$",
"^(فعال شو)$",
"^([Gg]id)$",
"^(شناسه گروه)$",
"^([Cc]harge status)$",
"^(وضعیت شارژ)$",
"^([Cc]harge status) (.*)$",
"^(وضعیت شارژ) (.*)$",
"^([Cc]harge) (.*) (%d+)$",
"^(شارژکردن) (.*) (%d+)$",
"^([Cc]harge) (%d+)$",
"^(شارژکردن) (%d+)$",
"^([Ll]eave) (.*)$",
"^(خارج شو) (.*)$",
"^([Pp]lan) ([123]) (.*)$",
"^(پلن) ([123]) (.*)$",
"^([Rr]em)$",
"^(غیرفعال شو)$",
}, 
run = run, pre_process = pre_process
}