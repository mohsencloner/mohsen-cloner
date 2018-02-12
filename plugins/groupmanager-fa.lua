local function modadd(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    if not is_admin(msg) then
   if not lang then
        return '_You are not bot admin_'
else
     return 'شما اجازه این کار را ندارید 😏👍🏻'
    end
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat_id_)] then
if not lang then
   return '_Group is already added_'
else
return 'ربات در گروه #فعال بود 😐❤️'
  end
end
        -- create data array in moderation.json
      data[tostring(msg.chat_id_)] = {
              owners = {},
      mods ={},
      banned ={},
      is_silent_users ={},
      filterlist ={},
      settings = {
          lock_link = 'yes',
          lock_tag = 'no',
	  lock_fosh = 'yes',
          lock_spam = 'no',
          lock_webpage = 'yes',
	  lock_arabic = 'no',
          lock_markdown = 'yes',
          flood = 'yes',
          lock_bots = 'yes',
          lock_pin = 'no',
          lock_tabchi = 'no',
          welcome = 'no'
          },
   mutes = {
                  mute_forward = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'yes',
                  mute_text = 'no',
                  mute_photos = 'no',
                  mute_gif = 'no',
                  mute_location = 'yes',
                  mute_document = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                  mute_all = 'no'
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.chat_id_)] = msg.chat_id_
      save_data(_config.moderation.data, data)
    if not lang then
  return '*Group has been added*'
else
  return 'انجام شد !\n\nربات با موفقیت در گروه #فعال شد 😐❤️'
end
end

local function modrem(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
     if not lang then
        return '_You are not bot admin_'
   else
        return 'شما #مدیرربات نمیباشید'
    end
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.chat_id_
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return '_Group is not added_'
else
    return 'ربات در گروه #فعال نیست 😐❤️'
   end
  end

  data[tostring(msg.chat_id_)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.chat_id_)] = nil
      save_data(_config.moderation.data, data)
 if not lang then
  return '*Group has been removed*'
 else
  return 'انجام شد !\n\nربات با موفقیت در گروه #غیرفعال شد 😐❤️'
end
end

local function filter_word(msg, word)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
  if not data[tostring(msg.chat_id_)]['filterlist'] then
    data[tostring(msg.chat_id_)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
if data[tostring(msg.chat_id_)]['filterlist'][(word)] then
   if not lang then
         return "_Word_ [ *"..word.."* ] _is already filtered_"
            else
         return "کلمه ی [ *"..word.."* ] فیلتر #شده بود 😐❤️"
    end
end
   data[tostring(msg.chat_id_)]['filterlist'][(word)] = true
     save_data(_config.moderation.data, data)
   if not lang then
         return "_Word_ [ *"..word.."*  _added to filtered words list_"
            else
	return "انجام شد !\n\nکلمه ی [ *"..word.."* ] با موفقیت #فیلتر شد 😐❤️"
    end
end

local function unfilter_word(msg, word)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.chat_id_)]['filterlist'] then
    data[tostring(msg.chat_id_)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
      if data[tostring(msg.chat_id_)]['filterlist'][word] then
      data[tostring(msg.chat_id_)]['filterlist'][(word)] = nil
       save_data(_config.moderation.data, data)
       if not lang then
         return "_Word_ [ *"..word.."* ] _removed from filtered words list_"
       elseif lang then
         return "انجام شد !\n\nکلمه ی [ *"..word.."* ] با موفقیت از فیلتر #حذف شد 😐❤️"
     end
      else
       if not lang then
         return "_Word_ [ *"..word.."* ] _is not filtered_"
       elseif lang then
         return "کلمه ی [ *"..word.."* ] فیلتر #نشده بود 😐❤️"
      end
   end
end

local function modlist(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return "_Group is not added_"
 else
    return "ربات در گروه #فعال نیست 😐❤️"
  end
 end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['mods']) == nil then --fix way
  if not lang then
    return "_No_ *moderator* _in this group_"
else
   return "هیچ #مدیری انتخاب نشده است 😐❤️"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = 'لیست #مدیران 😐❤️\n\n'
end
  for k,v in pairs(data[tostring(msg.chat_id_)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
if not lang then
    return "_Group is not added_"
else
return "ربات در گروه #فعال نیست 😐❤️"
  end
end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['owners']) == nil then --fix way
 if not lang then
    return "_No_ *owner* _in this group_"
else
    return "هیچ #مالکی انتخاب نشده است 😐❤️"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = 'لیست #مالکان 😐❤️\n\n'
end
  for k,v in pairs(data[tostring(msg.chat_id_)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function action_by_reply(arg, data)
local hash = "gp_lang:"..data.chat_id_
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
  if not administration[tostring(data.chat_id_)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_ربات در گروه #غیرفعال است 😐❤️_", 0, "md")
     end
  end
if cmd == "setowner" then
local function owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر  اکنون مالک #گروه است 😐❤️", "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* با موفقیت به مالک گروه #ارتقا یافت 😐❤️", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "promote" then
local function promote_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* اکنون مدیر #گروه است 😐❤️", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* به مدیر گروه #ارتقا یافت 😐❤️", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* مالک #گروه نیست 😐❤️", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* از مقام مالک گروه #حذف شد 😐❤️", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "demote" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* مدیر #گروه نیست 😐❤️", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* از مقام مدیر گروه #حذف شد 😐❤️", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "id" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "🔴 شناسه #کاربر => *"..data.id_.."*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "کاربر #موجود نیست 😐❤️", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "ربات در گروه #غیرفعال است 😐❤️", 0, "md")
     end
  end
if not arg.username then return false end
   if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* اکنون مالک #گروه است 😐❤️", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* به مالک گروه #ارتقا یافت 😐❤️", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* اکنون مدیر #گروه است 😐❤️", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* به مدیر گروه #ارتقا یافت 😐❤️", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* مالک #گروه نیست 😐❤️", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* از مقام مالک گروه #حذف شد 😐❤️", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* مدیر #گروه نیست 😐❤️", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* از مقام مدیر گروه #حذف شد 😐❤️", 0, "md")
   end
end
   if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
    if cmd == "res" then
    if not lang then
     text = "Result for [ ".. check_markdown(data.type_.user_.username_) .." ] :\n"
    .. "".. check_markdown(data.title_) .."\n"
    .. " [".. data.id_ .."]"
  else
     text = "اطلاعات #برای [ ".. check_markdown(data.type_.user_.username_) .." ] :\n"
    .. "".. check_markdown(data.title_) .."\n"
    .. " [".. data.id_ .."]"
       return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1, 'md')
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر #موجود نیست 😐❤️", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "ربات در گروه #غیرفعال است 😐❤️", 0, "md")
     end
  end
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.first_name_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if cmd == "setowner" then
  if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* اکنون مالک #گروه است 😐❤️", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* به مالک گروه #ارتقا یافت 😐❤️", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* اکنون مدیر #گروه است 😐❤️", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* به مدیر گروه #ارتقا یافت 😐❤️", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* مالک #گروه نیست 😐❤", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* از مقام مالک گروه #حذف شد 😐❤️", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "کاربر *[ "..data.first_name_.." ]* مدیر #گروه نیست 😐❤️", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "انجام شد !\n\nکاربر *[ "..data.first_name_.." ]* از مقام مدیر گروه #حذف شد 😐❤️", 0, "md")
   end
end
    if cmd == "whois" then
if data.username_ then
username = '@'..check_markdown(data.username_)
else
if not lang then
username = 'not found'
 else
username = 'کاربر مورد نظر #فاقد آیدی میباشد 😐❤️'
  end
end
     if not lang then
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'Info for [ '..data.id_..' ] :\nUserName : '..username..'\nName : '..data.first_name_, 1)
   else
       return tdcli.sendMessage(arg.chat_id, 0, 1, '🔴 آیدی => [ '..username..' ]\n\n🔴 نــــــام => '..data.first_name_, 1)
      end
   end
 else
    if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User not founded_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر #موجود نیست 😐❤️_", 0, "md")
    end
  end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر #موجود نیست 😐❤️_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end


---------------Lock Link-------------------
local function lock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نیستید 😐❤️"
end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
if not lang then
 return "🔒*Link* _Posting Is Already Locked_🔒"
elseif lang then
 return "قفل لینک #فعال است 😐❤️"
end
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Link* _Posting Has Been Locked_🔒"
else
 return "انجام شد !\n\nقفل لینک با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
if not lang then
return "🔓*Link* _Posting Is Not Locked_🔓" 
elseif lang then
 return "قفل لینک #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Link* _Posting Has Been Unlocked_🔓" 
else
 return "انجام شد !\n\nقفل لینک با موفقیت #غیرفعال شد  😐❤️"
end
end
end



---------------Lock fosh-------------------
local function lock_fosh(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به ایم کار نمیباشید 😐❤️"
end
end

local lock_fosh = data[tostring(target)]["settings"]["lock_fosh"] 
if lock_fosh == "yes" then
if not lang then
 return "🔒*Fosh* _Posting Is Already Locked_🔒"
elseif lang then
 return "قفل فحش #فعال است 😐❤️"
end
else
data[tostring(target)]["settings"]["lock_fosh"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Fosh* _ Has Been Locked_🔒"
else
 return "انجام شد !\n\nقفل فحش با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_fosh(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید"
end
end 

local lock_fosh = data[tostring(target)]["settings"]["lock_fosh"]
 if lock_fosh == "no" then
if not lang then
return "🔓*Fosh* _Is Not Locked_🔓" 
elseif lang then
 return "قفل فحش #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_fosh"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Fosh* _Has Been Unlocked_🔓" 
else
 return "انجام شد !\n\nقفل فحش با موفقیت #غیرفعال شد  😐❤️"
end
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
if not lang then
 return "🔒*Tag* _Posting Is Already Locked_🔒"
elseif lang then
 return "قفل تگ *(@ و #)* #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Tag* _Posting Has Been Locked_🔒"
else
 return "انجام شد !\n\nقفل تگ *(@ و #)* با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_tag(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end 
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
if not lang then
return "🔓*Tag* _Posting Is Not Locked_🔓" 
elseif lang then
 return "قفل تگ *(@ و #)* #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Tag* _Posting Has Been Unlocked_🔓" 
else
 return "انجام شد !\n\nقفل تگ *(@ و #)* با موفقیت #غیرفعال شد  😐❤️"
end
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
 local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
if not lang then
 return "🔒*Mention* _Posting Is Already Locked_🔒"
elseif lang then
 return "قفل هایپرلینک #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
if not lang then 
 return "🔒*Mention* _Posting Has Been Locked_🔒"
else 
 return "انجام شد !\n\nقفل هایپرلینک با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_mention(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
if not lang then
return "🔓*Mention* _Posting Is Not Locked_🔓" 
elseif lang then
 return "قفل هایپرلینک #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Mention* _Posting Has Been Unlocked_🔓" 
else
 return "انجام شد !\n\nقفل هایپرلینک با موفقیت #غیرفعال شد  😐❤️"
end
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
if not lang then
 return "🔒*Arabic/Persian* _Posting Is Already Locked_🔒"
elseif lang then
 return "قفل چت فارسی #فعال است 😐❤️"
end
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Arabic/Persian* _Posting Has Been Locked_🔒"
else
 return "انجام شد !\n\nقفل چت فارسی با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
if not lang then
return "🔓*Arabic/Persian* _Posting Is Not Locked_🔓" 
elseif lang then
 return "قفل چت فارسی #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Arabic/Persian* _Posting Has Been Unlocked_🔓" 
else
 return "انجام شد !\n\nقفل چت فارسی با موفقیت #غیرفعال شد  😐❤️"
end
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
if not lang then
 return "🔒*Editing* _Is Already Locked_🔒"
elseif lang then
 return "قفل ویرایش پیام #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Editing* _Has Been Locked_🔒"
else
 return "انجام شد !\n\nقفل ویرایش پیام با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_edit(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
if not lang then
return "🔓*Editing* _Is Not Locked_🔓" 
elseif lang then
 return "قفل ویرایش پیام #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Editing* _Has Been Unlocked_🔓" 
else
 return "انجام شد !\n\nقفل ویرایش پیام با موفقیت #غیرفعال شد  😐❤️"
end
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
if not lang then
 return "🔒*Spam* _Is Already Locked_🔒"
elseif lang then
 return "قفل هرزنامه #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Spam* _Has Been Locked_🔒"
else
 return "انجام شد !\n\nقفل هرزنامه با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_spam(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
if not lang then
return "🔓*Spam* _Posting Is Not Locked_🔓" 
elseif lang then
 return "قفل هرزنامه #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" save_data(_config.moderation.data, data)
if not lang then 
return "🔓*Spam* _Posting Has Been Unlocked_🔓" 
else
 return "انجام شد !\n\nقفل هرزنامه با موفقیت #غیرفعال شد  😐❤️"
end
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
if not lang then
 return "🔒*Flooding* _Is Already Locked_🔒"
elseif lang then
 return "قفل فلود #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Flooding* _Has Been Locked_🔒"
else
 return "انجام شد !\n\nقفل فلود با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_flood(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
if not lang then
return "🔓*Flooding* _Is Not Locked_🔓" 
elseif lang then
 return "قفل فلود #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Flooding* _Has Been Unlocked_🔓" 
else
 return "انجام شد !\n\nقفل فلود با موفقیت #غیرفعال شد  😐❤️"
end
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
if not lang then
 return "🔒*Bots* _Protection Is Already Enabled_🔒"
elseif lang then
 return "قفل ورود ربات #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Bots* _Protection Has Been Enabled_🔒"
else
 return "انجام شد !\n\nقفل ورود ربات با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_bots(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end 
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
if not lang then
return "🔓*Bots* _Protection Is Not Enabled_🔓" 
elseif lang then
 return "قفل ورود ربات #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Bots* _Protection Has Been Disabled_🔓" 
else
 return "انجام شد !\n\nقفل ورود ربات با موفقیت #غیرفعال شد  😐❤️"
end
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
if not lang then 
 return "🔒*Markdown* _Posting Is Already Locked_🔒"
elseif lang then
 return "قفل متن فونت دار #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Markdown* _Posting Has Been Locked_🔒"
else
 return "انجام شد !\n\nقفل متن فونت دار با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_markdown(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end 
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
if not lang then
return "🔓*Markdown* _Posting Is Not Locked_🔓"
elseif lang then
 return "قفل متن فونت دار #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Markdown* _Posting Has Been Unlocked_🔓"
else
 return "انجام شد !\n\nقفل متن فونت دار با موفقیت #غیرفعال شد  😐❤️"
end
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید😐❤️"
end
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
if not lang then
 return "🔒*Webpage* _Is Already Locked_🔒"
elseif lang then
 return "قفل آدرس اینترنتی #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "🔒*Webpage* _Has Been Locked_🔒"
else
 return "انجام شد !\n\nقفل آدرس اینترنتی با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_webpage(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end 
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
if not lang then
return "🔓*Webpage* _Is Not Locked_🔓" 
elseif lang then
 return "قفل آدرس اینترنتی #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "🔓*Webpage* _Has Been Unlocked_🔓" 
else
 return "انجام شد !\n\nقفل آدرس اینترنتی با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
if not lang then
 return "*Pinned Message* _Is Already Locked_"
elseif lang then
 return "قفل سنجاق #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Pinned Message* _Has Been Locked_"
else
 return "انجام شد !\n\nقفل سنجاق با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_pin(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end 
end

local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
if not lang then
return "*Pinned Message* _Is Not Locked_" 
elseif lang then
 return "قفل سنجاق #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "*Pinned Message* _Has Been Unlocked_" 
else
 return "انجام شد !\n\nقفل سنجاق با موفقیت #غیرفعال شد  😐❤️"
end
end
end
--------------Lock Tabchi-------------
local function lock_tabchi(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما مدیر گروه نمیباشید"
end
end

local lock_tabchi = data[tostring(target)]["settings"]["lock_tabchi"] 
if lock_tabchi == "yes" then
if not lang then
 return "*Tabchi* _Posting Is Already Locked_"
elseif lang then
 return "قفل تبچی #فعال است 😐❤️"
end
else
data[tostring(target)]["settings"]["lock_tabchi"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Tabchi* _Posting Has Been Locked_"
else
 return "انجام شد !\n\nقفل تبچی با موفقیت #فعال شد  😐❤️"
end
end
end

local function unlock_tabchi(msg, data, target)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما مدیر گروه نمیباشید"
end
end 

local lock_tabchi = data[tostring(target)]["settings"]["lock_tabchi"]
 if lock_tabchi == "no" then
if not lang then
return "*Tabchi* _Posting Is Not Locked_" 
elseif lang then
 return "قفل تبچی #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["lock_tabchi"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Tabchi* _Posting Has Been Unlocked_" 
else
 return "انجام شد !\n\nقفل تبچی با موفقیت #غیرفعال شد  😐❤️"
end
end
end

function group_settings(msg, target) 	
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "_You're Not_ *Moderator*"
else
  return "شما مدیر گروه نمیباشید"
end
end
end

function group_settings(msg, target) 	
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "_You're Not_ *Moderator*"
else
  return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 10
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_fosh"] then			
data[tostring(target)]["settings"]["lock_fosh"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_arabic"] then			
data[tostring(target)]["settings"]["lock_arabic"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["welcome"] then			
data[tostring(target)]["settings"]["welcome"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
 if not data[tostring(target)]["settings"]["lock_pin"] then			
 data[tostring(target)]["settings"]["lock_pin"] = "no"		
 end
 end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tabchi"] then			
data[tostring(target)]["settings"]["lock_tabchi"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_all"] then			
data[tostring(target)]["settings"]["mute_all"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_gif"] then			
data[tostring(target)]["settings"]["mute_gif"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_text"] then			
data[tostring(target)]["settings"]["mute_text"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_photo"] then			
data[tostring(target)]["settings"]["mute_photo"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_video"] then			
data[tostring(target)]["settings"]["mute_video"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_audio"] then			
data[tostring(target)]["settings"]["mute_audio"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_voice"] then			
data[tostring(target)]["settings"]["mute_voice"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_sticker"] then			
data[tostring(target)]["settings"]["mute_sticker"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_contact"] then			
data[tostring(target)]["settings"]["mute_contact"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_forward"] then			
data[tostring(target)]["settings"]["mute_forward"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_location"] then			
data[tostring(target)]["settings"]["mute_location"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_document"] then			
data[tostring(target)]["settings"]["mute_document"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_tgservice"] then			
data[tostring(target)]["settings"]["mute_tgservice"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_inline"] then			
data[tostring(target)]["settings"]["mute_inline"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_game"] then			
data[tostring(target)]["settings"]["mute_game"] = "no"		
end
end


 local expire_date = ''
local expi = redis:ttl('ExpireDate:'..msg.to.id)
if expi == -1 then
if lang then
	expire_date = 'نامحدود !'
else
	expire_date = 'Unlimited !'
end
else
	local day = math.floor(expi / 86400) + 1
if lang then
	expire_date = day..' روز !'
else
	expire_date = day..' Days !'
end
end


if not lang then
local settings = data[tostring(target)]["settings"] 
 text = "🔰*Group Settings*🔰\n\n🔐_Lock edit :_ *"..settings.lock_edit.."*\n🔐_Lock links :_ *"..settings.lock_link.."*\n🔐_Lock fosh :_ *"..settings.lock_fosh.."*\n🔐_Lock tags :_ *"..settings.lock_tag.."*\n🔐_Lock Persian* :_ *"..settings.lock_arabic.."*\n🔐_Lock flood :_ *"..settings.flood.."*\n🔐_Lock spam :_ *"..settings.lock_spam.."*\n🔐_Lock mention :_ *"..settings.lock_mention.."*\n🔐_Lock webpage :_ *"..settings.lock_webpage.."*\n🔐_Lock markdown :_ *"..settings.lock_markdown.."*\n🔐_Bots protection :_ *"..settings.lock_bots.."*\n🔐_Flood sensitivity :_ *"..NUM_MSG_MAX.."*\n✋_welcome :_ *"..settings.welcome.."*\n\n 🔊Group Mute List 🔊 \n\n🔇_Mute all : _ *"..settings.mute_all.."*\n🔇_Mute gif :_ *"..settings.mute_gif.."*\n🔇_Mute text :_ *"..settings.mute_text.."*\n🔇_Mute inline :_ *"..settings.mute_inline.."*\n🔇_Mute game :_ *"..settings.mute_game.."*\n🔇_Mute photo :_ *"..settings.mute_photo.."*\n🔇_Mute video :_ *"..settings.mute_video.."*\n🔇_Mute audio :_ *"..settings.mute_audio.."*\n🔇_Mute voice :_ *"..settings.mute_voice.."*\n🔇_Mute sticker :_ *"..settings.mute_sticker.."*\n🔇_Mute contact :_ *"..settings.mute_contact.."*\n🔇_Mute forward :_ *"..settings.mute_forward.."*\n🔇_Mute location :_ *"..settings.mute_location.."*\n🔇_Mute document :_ *"..settings.mute_document.."*\n🔇_Mute TgService :_ *"..settings.mute_tgservice.."*\n📆_eхpιreтιмe ➣_ *"..expire_date.."*\n*__________________*\n*____________________*\n*Language* : *EN*"
else
local settings = data[tostring(target)]["settings"] 
 text = "* 🔴  تنظیمات گروه :*\n\n"
.."● #قفل همه => "..settings.mute_all.."\n"
.."● #قفل خدمات => "..settings.mute_tgservice.."\n\n"
.."➖➖➖➖➖➖➖➖➖\n\n"
.." 🔴 *قفل های اصلی* :\n\n"
.."● #قفل ویرایش پیام => "..settings.lock_edit.."\n"
.."● #قفل لینک => "..settings.lock_link.."\n"
.."● #قفل تگ => "..settings.lock_tag.."\n"
.."● #قفل چت فارسی => "..settings.lock_arabic.."\n"
.."● #قفل فلود => "..settings.flood.."\n"
.."● #قفل اسپم => "..settings.lock_spam.."\n"
.."● #قفل هایپرلینک => "..settings.lock_mention.."\n"
.."● #قفل آدرس اینترنتی => "..settings.lock_webpage.."\n"
.."● #قفل دکمه شیشه ای => "..settings.mute_inline.."\n"
.."● #قفل بازی تحت وب => "..settings.mute_game.."\n"
.."● #قفل متن فونت دار => "..settings.lock_markdown.."\n"
.."● #قفل فروارد => "..settings.mute_forward.."\n"
.."● #قفل سنجاق => "..settings.lock_pin.."\n"
.."● #قفل ورود ربات => "..settings.lock_bots.."\n"
.."● #قفل تبچی => "..settings.lock_tabchi.."\n"
.."● #قفل فحش => "..settings.lock_fosh.."\n\n"
.."➖➖➖➖➖➖➖➖➖\n\n"
.." 🔴 *قفل های رسانه :*\n\n"
.."● #قفل متن [چت] => "..settings.mute_text.."\n"
.."● #قفل عکس => "..settings.mute_photo.."\n"
.."● #قفل فیلم => "..settings.mute_video.."\n"
.."● #قفل موزیک => "..settings.mute_audio.."\n"
.."● #قفل ویس => "..settings.mute_voice.."\n"
.."● #قفل استیکر => "..settings.mute_sticker.."\n"
.."● #قفل تصاویر متحرک => "..settings.mute_gif.."\n"
.."● #قفل فایل => "..settings.mute_document.."\n"
.."● #قفل اطلاعات تماس => "..settings.mute_contact.."\n"
.."● #قفل موقعیت مکانی => "..settings.mute_location.."\n\n"
.."➖➖➖➖➖➖➖➖➖\n\n"
.."● #تاریخ انقضا => "..expire_date.."\n"
.."● #حساسیت فلود => "..NUM_MSG_MAX.."\n"
.."● #خوش آمد گویی => "..settings.welcome.."\n\n"
.."➖➖➖➖➖➖➖➖➖\n\n"
.."● #زبان   => فارسی\n\n"
.."➖➖➖➖➖➖➖➖➖\n\n"
.."● #ارتباط با سازنده  =>   @ertejahi"
end
if not lang then
text = string.gsub(text, "yes", "| ✔️ |")
text =  string.gsub(text, "no", "| ✖️ |")
text =  string.gsub(text, "0", "⓪")
text =  string.gsub(text, "1", "➀")
text =  string.gsub(text, "2", "➁")
text =  string.gsub(text, "3", "➂")
text =  string.gsub(text, "4", "➃")
text =  string.gsub(text, "5", "➄")
text =  string.gsub(text, "6", "➅")
text =  string.gsub(text, "7", "➆")
text =  string.gsub(text, "8", "➇")
text =  string.gsub(text, "9", "➈")
 else
 text = string.gsub(text, "yes", "| ✔️ |")
 text =  string.gsub(text, "no", "| ✖️ |")
 end

return text
end
--------Mutes---------
--------Mute all------------------------
local function mute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "_You're Not_ *Moderator*" 
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_all = data[tostring(target)]["settings"]["mute_all"] 
if mute_all == "yes" then 
if not lang then
return "🔇*Mute All* _Is Already Enabled_🔇" 
elseif lang then
 return "قفل گروه #فعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔇*Mute All* _Has Been Enabled_🔇" 
else
 return "انجام شد !\n\nقفل گروه با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "_You're Not_ *Moderator*" 
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_all = data[tostring(target)]["settings"]["mute_all"] 
if mute_all == "no" then 
if not lang then
return "🔊*Mute All* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل گروه #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔊*Mute All* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل گروه با موفقیت #غیرفعال شد  😐❤️"
end 
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_gif = data[tostring(target)]["settings"]["mute_gif"] 
if mute_gif == "yes" then
if not lang then
 return "🔇*Mute Gif* _Is Already Enabled_🔇"
elseif lang then
 return "قفل تصاویر متحرک #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then 
 return "🔊*Mute Gif* _Has Been Enabled_🔊"
else
 return "انجام شد !\n\nقفل تصاویر متحرک با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_gif(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local mute_gif = data[tostring(target)]["settings"]["mute_gif"]
 if mute_gif == "no" then
if not lang then
return "🔇*Mute Gif* _Is Already Disabled_🔇" 
elseif lang then
 return "قفل تصاویر متحرک #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔇*Mute Gif* _Has Been Disabled_🔇" 
else
 return "انجام شد !\n\nقفل تصاویر متحرک با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_game = data[tostring(target)]["settings"]["mute_game"] 
if mute_game == "yes" then
if not lang then
 return "🔇*Mute Game* _Is Already Enabled_🔇"
elseif lang then
 return "قفل بازی های تحت وب #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Game* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل بازی های تحت وب با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_game(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end 
end

local mute_game = data[tostring(target)]["settings"]["mute_game"]
 if mute_game == "no" then
if not lang then
return "🔊*Mute Game* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل بازی های تحت وب #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_game"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "🔊*Mute Game* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل بازی های تحت وب با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_inline = data[tostring(target)]["settings"]["mute_inline"] 
if mute_inline == "yes" then
if not lang then
 return "🔇*Mute Inline* _Is Already Enabled_🔇"
elseif lang then
 return "قفل دکمه شیشه ای #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Inline* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل دکمه شیشه ای با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_inline(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local mute_inline = data[tostring(target)]["settings"]["mute_inline"]
 if mute_inline == "no" then
if not lang then
return "🔊*Mute Inline* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل دکمه شیشه ای #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔊*Mute Inline* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل دکمه شیشه ای با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_text = data[tostring(target)]["settings"]["mute_text"] 
if mute_text == "yes" then
if not lang then
 return "🔇*Mute Text* _Is Already Enabled_🔇"
elseif lang then
 return "قفل چت کردن [ متن ] #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Text* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل چت کردن [ متن ] با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_text(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end 
end

local mute_text = data[tostring(target)]["settings"]["mute_text"]
 if mute_text == "no" then
if not lang then
return "🔊*Mute Text* _Is Already Disabled_🔊"
elseif lang then
 return "قفل چت کردن [ متن ] #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔊*Mute Text* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل چت کردن [ متن ] با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "🔇_You're Not_ *Moderator*🔇"
else
 return "شما #مجاز به این کار نمیباشید"
end
end

local mute_photo = data[tostring(target)]["settings"]["mute_photo"] 
if mute_photo == "yes" then
if not lang then
 return "🔇*Mute Photo* _Is Already Enabled_🔇"
elseif lang then
 return "قفل عکس #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Photo* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل عکس با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_photo(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end
 
local mute_photo = data[tostring(target)]["settings"]["mute_photo"]
 if mute_photo == "no" then
if not lang then
return "🔊*Mute Photo* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل عکس #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔊*Mute Photo* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل عکس با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_video = data[tostring(target)]["settings"]["mute_video"] 
if mute_video == "yes" then
if not lang then
 return "🔇*Mute Video* _Is Already Enabled_🔇"
elseif lang then
 return "قفل فیلم #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then 
 return "🔇*Mute Video* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل فیلم با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_video(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local mute_video = data[tostring(target)]["settings"]["mute_video"]
 if mute_video == "no" then
if not lang then
return "🔊*Mute Video* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل فیلم #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔊*Mute Video* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل فیلم با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_audio = data[tostring(target)]["settings"]["mute_audio"] 
if mute_audio == "yes" then
if not lang then
 return "🔇*Mute Audio* _Is Already Enabled_🔇"
elseif lang then
 return "قفل موزیک #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Audio* _Has Been Enabled_🔇"
else 
 return "انجام شد !\n\nقفل موزیک با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_audio(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به اینن کار نمیباشید 😐❤️"
end
end 

local mute_audio = data[tostring(target)]["settings"]["mute_audio"]
 if mute_audio == "no" then
if not lang then
return "🔊*Mute Audio* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل موزیک #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "🔊*Mute Audio* _Has Been Disabled_🔊"
else
 return "انجام شد !\n\nقفل موزیک با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_voice = data[tostring(target)]["settings"]["mute_voice"] 
if mute_voice == "yes" then
if not lang then
 return "🔇*Mute Voice* _Is Already Enabled_🔇"
elseif lang then
 return "قفل ویس #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Voice* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل ویس با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_voice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local mute_voice = data[tostring(target)]["settings"]["mute_voice"]
 if mute_voice == "no" then
if not lang then
return "🔊*Mute Voice* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل ویس #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "🔊*Mute Voice* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل ویس با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_sticker = data[tostring(target)]["settings"]["mute_sticker"] 
if mute_sticker == "yes" then
if not lang then
 return "🔇*Mute Sticker* _Is Already Enabled_🔇"
elseif lang then
 return "قفل استیکر #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Sticker* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل استیکر با موفقیت #غیرفعال شد  😐❤️"
end
end
end

local function unmute_sticker(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end 
end

local mute_sticker = data[tostring(target)]["settings"]["mute_sticker"]
 if mute_sticker == "no" then
if not lang then
return "🔊*Mute Sticker* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل استیکر #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "🔊*Mute Sticker* _Has Been Disabled_🔊"
else
 return "انجام شد !\n\nقفل استیکر با موفقیت #غیرفعال شد  😐❤️"
end 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_contact = data[tostring(target)]["settings"]["mute_contact"] 
if mute_contact == "yes" then
if not lang then
 return "🔇*Mute Contact* _Is Already Enabled_🔇"
elseif lang then
 return "قفل اطلاعات تماس #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Contact* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل اطلاعات تماس با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_contact(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local mute_contact = data[tostring(target)]["settings"]["mute_contact"]
 if mute_contact == "no" then
if not lang then
return "🔊*Mute Contact* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل اطلاعات تماس #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔊*Mute Contact* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل اطلاعات تماس با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_forward = data[tostring(target)]["settings"]["mute_forward"] 
if mute_forward == "yes" then
if not lang then
 return "🔇*Mute Forward* _Is Already Enabled_🔇"
elseif lang then
 return "قفل فروارد #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Forward* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل فروارد با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_forward(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local mute_forward = data[tostring(target)]["settings"]["mute_forward"]
 if mute_forward == "no" then
if not lang then
return "🔊*Mute Forward* _Is Already Disabled_🔊"
elseif lang then
 return "قفل فروارد #غیرفعال است 😐❤️"
end 
else 
data[tostring(target)]["settings"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "🔊*Mute Forward* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل فروارد با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_location = data[tostring(target)]["settings"]["mute_location"] 
if mute_location == "yes" then
if not lang then
 return "🔇*Mute Location* _Is Already Enabled_🔇"
elseif lang then
 return "قفل موقعیت مکانی #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then
 return "🔇*Mute Location* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل موقعیت مکانی با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_location(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local mute_location = data[tostring(target)]["settings"]["mute_location"]
 if mute_location == "no" then
if not lang then
return "🔊*Mute Location* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل موقعیت مکانی #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔊*Mute Location* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل موقعیت مکانی با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_document = data[tostring(target)]["settings"]["mute_document"] 
if mute_document == "yes" then
if not lang then
 return "🔇*Mute Document* _Is Already Enabled_🔇"
elseif lang then
 return "قفل فایل #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute Document* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل فایل با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_document(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end 

local mute_document = data[tostring(target)]["settings"]["mute_document"]
 if mute_document == "no" then
if not lang then
return "🔊*Mute Document* _Is Already Disabled_🔊" 
elseif lang then
 return "قفل فایل #غیرفعال است 😐❤️"
end
else 
data[tostring(target)]["settings"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔊*Mute Document* _Has Been Disabled_🔊" 
else
 return "انجام شد !\n\nقفل فایل با موفقیت #غیرفعال شد  😐❤️"
end
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "شما #مجاز به این کار نمیباشید 😐❤️"
end
end

local mute_tgservice = data[tostring(target)]["settings"]["mute_tgservice"] 
if mute_tgservice == "yes" then
if not lang then
 return "🔇*Mute TgService* _Is Already Enabled_🔇"
elseif lang then
 return "قفل خدمات #فعال است 😐❤️"
end
else
 data[tostring(target)]["settings"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "🔇*Mute TgService* _Has Been Enabled_🔇"
else
 return "انجام شد !\n\nقفل خدمات با موفقیت #فعال شد  😐❤️"
end
end
end

local function unmute_tgservice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "شما #مجاز به این کار نیستید 😐❤️"
end 
end

local mute_tgservice = data[tostring(target)]["settings"]["mute_tgservice"]
 if mute_tgservice == "no" then
if not lang then
return "🔊*Mute TgService* _Is Already Disabled_🔊"
elseif lang then
 return "قفل خدمات #غیرفعال است 😐❤️"
end 
else 
data[tostring(target)]["settings"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "🔊*Mute TgService* _Has Been Disabled_🔊"
else
 return "انجام شد !\n\nقفل خدمات با موفقیت #غیرفعال شد  😐❤️"
end 
end
end


local function run(msg, matches)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
   local chat = msg.chat_id_
   local user = msg.sender_user_id_
if matches[1] == "ایدی" then
if not matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   if not lang then
return "*Chat ID :* _"..chat.."_\n*User ID :* _"..user.."_"
   else
return "🔴 شناسه #گروه => *[ "..chat.." ]*\n🔴 شناسه #شما => *[ "..user.." ]*"
   end
end
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="id"})
  end
if matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="id"})
      end
   end
if matches[1] == "سنجاق کن" and is_mod(msg) and msg.reply_to_message_id_ then
local lock_pin = data[tostring(msg.chat_id_)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(chat)]['pin'] = msg.reply_to_message_id_
save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.chat_id_, msg.reply_to_message_id_, 1)
if not lang then
return "*Message Has Been Pinned*"
else
return "انجام شد !\n\nپیام مورد نظر با موفقیت #سنجاق شد  😐❤️"
end
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(chat)]['pin'] = msg.reply_to_message_id_
	  save_data(_config.moderation.data, data)
tdcli.pinChannelMessage(msg.chat_id_, msg.reply_to_message_id_, 1)
if not lang then
return "*Message Has Been Pinned*"
elseif lang then
return "انجام شد !\n\nپیام مورد نظر با موفقیت #سنجاق شد  😐❤️"
end
end
end
if matches[1] == 'حذف سنجاق' and is_mod(msg) then
local lock_pin = data[tostring(msg.chat_id_)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
tdcli.unpinChannelMessage(msg.chat_id_)
if not lang then
return "*Pin message has been unpinned*"
elseif lang then
return "انجام شد !\n\nپیام سنجاق شده با موفقیت #حذف شد  😐❤️"
end
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
tdcli.unpinChannelMessage(msg.chat_id_)
if not lang then
return "*Pin message has been unpinned*"
elseif lang then
return "پیام سنجاق شده پاک شد"
end
end
end
if matches[1] == "فعال شو" then
return modadd(msg)
end
if matches[1] == "غیرفعال شو" then
return modrem(msg)
end
if matches[1] == "ارتقا به مالک" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="setowner"})
      end
   end
if matches[1] == "حذف مالک" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="remowner"})
      end
   end
if matches[1] == "ارتقا به مدیر" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="promote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="promote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="promote"})
      end
   end
if matches[1] == "حذف مدیر" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
 tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="demote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="demote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="demote"})
      end
   end

if matches[1] == "قفل" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "لینک" then
return lock_link(msg, data, target)
end
if matches[2] == "فحش" then
return lock_fosh(msg, data, target)
end
if matches[2] == "تگ" then
return lock_tag(msg, data, target)
end
if matches[2] == "هایپرلینک" then
return lock_mention(msg, data, target)
end
if matches[2] == "فارسی" then
return lock_arabic(msg, data, target)
end
if matches[2] == "ویرایش" then
return lock_edit(msg, data, target)
end
if matches[2] == "اسپم" then
return lock_spam(msg, data, target)
end
if matches[2] == "فلود" then
return lock_flood(msg, data, target)
end
if matches[2] == "ربات" then
return lock_bots(msg, data, target)
end
if matches[2] == "فونت" then
return lock_markdown(msg, data, target)
end
if matches[2] == "ادرس اینترنتی" then
return lock_webpage(msg, data, target)
end
if matches[2] == "سنجاق" and is_owner(msg) then
return lock_pin(msg, data, target)
end
if matches[2] == "تبچی" and is_owner(msg) then
return lock_tabchi(msg, data, target)
end
end

if matches[1] == "بازکردن" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "لینک" then
return unlock_link(msg, data, target)
end
if matches[2] == "فحش" then
return unlock_fosh(msg, data, target)
end
if matches[2] == "تگ" then
return unlock_tag(msg, data, target)
end
if matches[2] == "هایپرلینک" then
return unlock_mention(msg, data, target)
end
if matches[2] == "فارسی" then
return unlock_arabic(msg, data, target)
end
if matches[2] == "ویرایش" then
return unlock_edit(msg, data, target)
end
if matches[2] == "اسپم" then
return unlock_spam(msg, data, target)
end
if matches[2] == "فلود" then
return unlock_flood(msg, data, target)
end
if matches[2] == "ربات" then
return unlock_bots(msg, data, target)
end
if matches[2] == "فونت" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "ادرس اینترنتی" then
return unlock_webpage(msg, data, target)
end
if matches[2] == "سنجاق" and is_owner(msg) then
return unlock_pin(msg, data, target)
end
if matches[2] == "تبچی" and is_owner(msg) then
return unlock_tabchi(msg, data, target)
end
end
if matches[1] == "قفل" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "گروه" then
return mute_all(msg, data, target)
end
if matches[2] == "گیف" then
return mute_gif(msg, data, target)
end
if matches[2] == "متن" then
return mute_text(msg ,data, target)
end
if matches[2] == "عکس" then
return mute_photo(msg ,data, target)
end
if matches[2] == "فیلم" then
return mute_video(msg ,data, target)
end
if matches[2] == "موزیک" then
return mute_audio(msg ,data, target)
end
if matches[2] == "ویس" then
return mute_voice(msg ,data, target)
end
if matches[2] == "استیکر" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "اطلاعات تماس" then
return mute_contact(msg ,data, target)
end
if matches[2] == "فروارد" then
return mute_forward(msg ,data, target)
end
if matches[2] == "مکان" then
return mute_location(msg ,data, target)
end
if matches[2] == "فایل" then
return mute_document(msg ,data, target)
end
if matches[2] == "خدمات" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == "اینلاین" then
return mute_inline(msg ,data, target)
end
if matches[2] == "بازی" then
return mute_game(msg ,data, target)
end
end

if matches[1] == "بازکردن" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "گروه" then
return unmute_all(msg, data, target)
end
if matches[2] == "گیف" then
return unmute_gif(msg, data, target)
end
if matches[2] == "متن" then
return unmute_text(msg, data, target)
end
if matches[2] == "عکس" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "فیلم" then
return unmute_video(msg ,data, target)
end
if matches[2] == "موزیک" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "ویس" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "استیکر" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "اطلاعات تماس" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "فروارد" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "مکان" then
return unmute_location(msg ,data, target)
end
if matches[2] == "فایل" then
return unmute_document(msg ,data, target)
end
if matches[2] == "خدمات" then
return unmute_tgservice(msg ,data, target)
end
if matches[2] == "اینلاین" then
return unmute_inline(msg ,data, target)
end
if matches[2] == "بازی" then
return unmute_game(msg ,data, target)
end
end
if matches[1] == "اطلاعات گروه" and is_mod(msg) and gp_type(msg.chat_id_) == "channel" then
local function group_info(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not lang then
ginfo = "*📢Group Info :*📢\n👲_Admin Count :_ *"..data.administrator_count_.."*\n👥_Member Count :_ *"..data.member_count_.."*\n👿_Kicked Count :_ *"..data.kicked_count_.."*\n🆔_Group ID :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
elseif lang then
ginfo = "🔴 اطلاعات #گروه 😐❤️\n\n🔴 تعداد #اعضا => *[ "..data.member_count_.." ]*\n🔴 شناسه #گروه => *[ "..chat.." ]*"
print(serpent.block(data))
end
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
end
 tdcli.getChannelFull(msg.chat_id_, group_info, {chat_id=msg.chat_id_,msg_id=msg.id_})
end
		if matches[1] == 'تنظیم لینک' and is_owner(msg) then
			data[tostring(chat)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
      if not lang then
			return '_Please send the new group_ *link* _now_'
    else 
         return "انجام شد !\n\nبرای تنظیم کردن لطفا لینک گروه را #ارسال کنید  😐❤️"
       end
		end

		if msg.content_.text_ then
   local is_link = msg.content_.text_:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.content_.text_:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(chat)]['settings']['linkgp'] = msg.content_.text_
				save_data(_config.moderation.data, data)
            if not lang then
				return "*Newlink* _has been set_"
           else
           return "انجام شد !\n\nلینک گروه با موفقیت #ثبت شد  😐❤️"
		 	end
       end
		end
    if matches[1] == 'لینک' and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
      if not lang then
        return "_First set a link for group with using_ /setlink"
     else
        return "دوست عزیز !\n\nابتدا لینک گروه خود را با دستور [ تنظیم لینک ] #ثبت کنید  😐❤️"
      end
      end
     if not lang then
       text = "<b>Group Link :</b>\n"..linkgp
     else
      text = "لینک #گروه 😐❤️\n\n"..linkgp
         end
        return tdcli.sendMessage(chat, msg.id_, 1, text, 1, 'html')
     end
  if matches[1] == "تنظیم قوانین" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
     if not lang then
    return "*Group rules* _has been set_"
   else 
  return "انجام شد !\n\nقوانین مورد نظر با موفقیت #ثبت شد  😐❤️"
   end
  end
  if matches[1] == "قوانین" then
 if not data[tostring(chat)]['rules'] then
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n"
    elseif lang then
       rules = "ℹ️1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n"
 end
        else
     rules = "قوانین #گروه  😐❤️\n\n🔴"..data[tostring(chat)]['rules']
      end
    return rules
  end
if matches[1] == "رس" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="res"})
  end
if matches[1] == "چه کسی" and matches[2] and is_mod(msg) then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="whois"})
  end
  if matches[1] == 'تنظیم فلود' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "عدد وارد شده صحیح نیست !\n\nشما باید عددی بین *[ 1 - 50 ]* #انتخاب کنید  😐❤️"
      end
			local flood_max = matches[2]
			data[tostring(chat)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
	return "انجام شد !\n\nحساسیت فلود با موفقیت #تغییر کرد به عدد => *[ "..matches[2].." ]*  😐❤️"
       end
		if matches[1]:lower() == 'پاکسازی' and is_owner(msg) then
			if matches[2] == 'لیست مدیران' then
				if next(data[tostring(chat)]['mods']) == nil then
            if not lang then
					return "_No_ *moderators* _in this group_"
             else
                return "لیست مدیران #خالی لست 😐❤️"
				end
            end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *moderators* _has been demoted_"
          else
            
	return "انجام شد !\n\nلیست مدیران با موفقیت #پاکسازی شد 😐❤️"
			end
         end
			if matches[2] == 'لیست فیلتر' then
				if next(data[tostring(chat)]['filterlist']) == nil then
     if not lang then
					return "*Filtered words list* _is empty_"
         else
					return "لیست فیلتر #خالی لست 😐❤️"
             end
				end
				for k,v in pairs(data[tostring(chat)]['filterlist']) do
					data[tostring(chat)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
       if not lang then
				return "*Filtered words list* _has been cleaned_"
           else
				return "انجام شد !\n\nلیست فیلتر با موفقیت #پاکسازی شد 😐❤️"
           end
			end
			if matches[2] == 'قوانین' then
				if not data[tostring(chat)]['rules'] then
            if not lang then
					return "_No_ *rules* _available_"
             else
               return "قوانین #ثبت نشده است 😐❤️"
             end
				end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "*Group rules* _has been cleaned_"
          else
            return "انجام شد !\n\nقوانین گروه با موفقیت #پاکسازی شد 😐❤️"
			end
       end
			if matches[2] == 'خوش امد گویی' then
				if not data[tostring(chat)]['setwelcome'] then
            if not lang then
					return "*Welcome Message not set*"
             else
               return "پیام خوش آمد گویی #ثبت نشده است 😐❤️"
             end
				end
					data[tostring(chat)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "*Welcome message* _has been cleaned_"
          else
            return "انجام شد !\n\nپیام خوش امد گویی با موفقیت #پاکسازی شد 😐❤️"
			end
       end
			if matches[2] == 'درباره گروه' then
        if gp_type(chat) == "chat" then
				if not data[tostring(chat)]['about'] then
            if not lang then
					return "_No_ *description* _available_"
            else
              return "درباره گروه #ثبت نشده است 😐❤️"
          end
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
             if not lang then
				return "*Group description* _has been cleaned_"
           else
              return "انجام شد !\n\nدرباره ی گروه با موفقیت #پاکسازی شد 😐❤️"
             end
		   	end
        end
		if matches[1]:lower() == 'پاکسازی' and is_admin(msg) then
			if matches[2] == 'لیست مالکان' then
				if next(data[tostring(chat)]['owners']) == nil then
             if not lang then
					return "_No_ *owners* _in this group_"
            else
                return "لیست مالکان #خالی است"
            end
				end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *owners* _has been demoted_"
           else
            return "انجام شد !\n\nلیست مالکان با موفقیت #پاکسازی شد 😐❤️"
          end
			end
     end
if matches[1] == "تنظیم نام" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if matches[1] == "تنظیم درباره گروه" and matches[2] and is_mod(msg) then
     if gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif gp_type(chat) == "chat" then
    data[tostring(chat)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
     if not lang then
    return "*Group description* _has been set_"
    else
     return "انجام شد !\n\nدرباره ی گروه با موفقیت #تنظیم شد 😐❤️"
      end
  end
  if matches[1] == "درباره گروه" and gp_type(chat) == "chat" then
 if not data[tostring(chat)]['about'] then
     if not lang then
     about = "_No_ *description* _available_"
      elseif lang then
      about = "درباره گروه #ثبت نشده است 😐❤️"
       end
        else
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
  if matches[1] == 'فیلتر' and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'حذف فیلتر' and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
  if matches[1] == 'لیست فیلتر' and is_mod(msg) then
    return filter_list(msg)
  end
if matches[1] == "تنظیمات" then
return group_settings(msg, target)
end
if matches[1] == "لیست ممنوعیت" then
return mutes(msg, target)
end
if matches[1] == "لیست مدیران" then
return modlist(msg)
end
if matches[1] == "لیست مالکان" and is_owner(msg) then
return ownerlist(msg)
end

if matches[1] == "تنظیم زبان" and is_owner(msg) then
   if matches[2] == "انگلیسی" then
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 redis:del(hash)
return "انجام شد !\n\nزبان گروه با موفقیت به #انگلیسی تغییر کرد 😐❤️"
  elseif matches[2] == "فارسی" then
redis:set(hash, true)
return "انجام شد !\n\nزبان گروه با موفقیت به #فارسی تغییر کرد 😐❤️"
end
end




if matches[1] == "راهنما" and is_mod(msg) then
text = [[

*🔃 برای دیدن راهنمای بخش مورد نظر نام بخش دلخواه را وارد نمایید 😐❤️*

➖➖➖➖➖➖➖➖➖

* 🔴 برای دیدن راهنمای بخش مدیریت ، دستور زیر را ارسال فرمایید 😐❤️*

=>  #راهنمای مدیریت

➖➖➖➖➖➖➖➖➖

* 🔴 برای دیدن راهنمای بخش قفل ها ، دستور زیر را ارسال فرمایید 😐❤️*

=>  #راهنمای قفل ها

➖➖➖➖➖➖➖➖➖

* 🔴 برای دیدن راهنمای بخش سودو ها ، دستور زیر را ارسال فرمایید 😐❤️*

=>  #راهنمای سودو

➖➖➖➖➖➖➖➖➖

* 🔴 برای دیدن راهنمای بخش فان ، دستور زیر را ارسال فرمایید 😐❤️*

=>  #راهنمای فان

➖➖➖➖➖➖➖➖➖

* 🔴 برای ارتباط با سازنده ربات ، دستور زیر را ارسال فرمایید 😐❤️*

=>  #سازنده ربات

➖➖➖➖➖➖➖➖➖

* 🔴 برای اطلاع از انلاین بودن ربات ، دستور زیر را ارسال فرمایید 😐❤️*

=>  انلاینی

]]
return text 
end


if matches[1] == "#راهنمای قفل ها" and is_mod(msg) then
text1 = [[

*🔃قــــفـــــــــــــــل هــــا*

🔹 *برای #قفل کردن از دستور های زیر استفاده کنید* 🔹

➖➖➖➖➖➖➖➖➖

🔴 >>  lock link
🔴 >>  قفل  لینک

💬ارسال #لینک در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock tag
🔴 >>  قفل  تگ

💬ارسال #تگ (@ ، #) در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock edit
🔴 >>  قفل ویرایش

💬در گروه #ویرایش کردن پیام قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock farsi
🔴 >>  قفل  فارسی

💬چت کردن به زبان #فارسی در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock webpage
🔴 >>  قفل  ادرس اینترنتی

💬💬ارسال #ادرس اینترنتی در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock bots
🔴 >>  قفل  ربات

💬ورود #ربات در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock spam
🔴 >>  قفل  اسپم

💬ارسال #پیام های طولانی در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock flood
🔴 >>  قفل  فلود

💬ارسال #پیام پشت سرهم در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

*🔴 >>  setflood [ 1 - 50]*
*🔴 >>  تنظیم فلود [ 1 - 50 ]*

*💬 تعیین #میزان مجاز پست های رگباری*

➖➖➖➖➖➖➖➖➖

🔴 >>  lock markdown
🔴 >>  قفل  فونت

💬ارسال #متن فونت دار در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock mention
🔴 >>  قفل  هایپرلینک

💬ارسال #هایپرلینک در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock gif
🔴 >>  قفل گیف

💬ارسال #تصاویر متحرک در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock photo
🔴 >>  قفل  عکس

💬ارسال #عکس در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock document
🔴 >>  قفل  فایل

💬ارسال #فایل یا اسناد در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock sticker
🔴 >>  قفل  استیکر

💬ارسال #استیکر در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock video
🔴 >>  قفل  فیلم

💬ارسال #فیلم در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock text
🔴 >>  قفل  متن [ چت ]

💬در گروه #چت کردن قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock forward
🔴 >>  قفل  فروارد

💬ارسال پیام #فروارد شده در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock location
🔴 >>  قفل مکان

💬ارسال #موقعیت مکانی در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock audio
🔴 >>  قفل  موزیک

💬ارسال #موزیک در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock voice
🔴 >>  قفل  ویس

💬ارسال #صدای ضبط شده در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock contact
🔴 >>  قفل اطلاعات تماس

💬ارسال #شماره در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock fosh
🔴 >>  قفل  فحش

💬کلمات #رکیک در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock tgservice
🔴 >>  قفل  خدمات

💬پیام های #رفت و امد افراد توسط ربات پاک می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock inline
🔴 >>  قفل  اینلاین

💬ارسال #دکمه شیشه ای در گروه قفل می شود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock all
🔴 >>  قفل  گروه

💬گروه #قفل می شود و هیچکسی قادر به ارسال چیزی نخواد بود

➖➖➖➖➖➖➖➖➖

🔴 >>  lock time
🔴 >>  قفل  زمانی

💬 قفل #تایم دار ، عدد اول به معنای ساعت و عدد دوم به معنای دقیقه است

🔇 قفل زمانی 1 30
🔊 بازکردن زمانی

🔇 lock time 1 30
🔊 unlock time

➖➖➖➖➖➖➖➖➖

🔹برای #باز کردن هر یک از قفل های بالا در زبان فارسی به جای کلمه [ قفل ] از کلمه [ بازکردن ] استفاده کنید🔹
🔹برای #باز کردن هر یک از قفل های بالا در زبان انگلیسی به جای کلمه [ lock ] از کلمه [ unlock ] استفاده کنید🔹

به طور مثال 👇

✅ بازکردن لینک

✅ unlock link

]]
return text1 
end

if matches[1] == "#راهنمای مدیریت" and is_mod(msg) then
text2 = [[
*🔃 #دستــــورات مدیــــریـــت*

*🔴 >>  settings*
*🔴 >>  تنظیمات*

💬 نمایش #تنظیمات گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  silentlist*
*🔴 >>  لیست سکوت*

💬 نمایش لیست #سایلنت شده ها

➖➖➖➖➖➖➖➖➖

*🔴 >>  banlist*
*🔴 >>  لیست مسدود*

💬 نمایش لیست #مسدود شده ها

➖➖➖➖➖➖➖➖➖

*🔴 >>  ownerlist*
*🔴 >>  لیست مالکان*

💬 نمایش #لیست مالکان

➖➖➖➖➖➖➖➖➖

*🔴 >>  modlist*
*🔴 >>  لیست مدیران*

💬 نمایش #لیست مدیران

➖➖➖➖➖➖➖➖➖

*🔴 >>  gpinfo*
*🔴 >>  اطلاعات گروه*

💬 نمایش #اطلاعات گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  promote*
*🔴 >>  ارتقا به مدیر*

💬 تعیین #مدیرگروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  demote*
*🔴 >>  حذف مدیر*

💬 حذف #مدیرگروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  id*
*🔴 >>  ایدی*

💬 نمایش #آیدی با رپلی کردن 

➖➖➖➖➖➖➖➖➖

*🔴 >>  res [Id numeric]*
*🔴 >>  رس [شناسه عددی]*

💬 نمایش #آیدی با وارد کردن شناسه عددی 

➖➖➖➖➖➖➖➖➖

*🔴 >>  whois [Id]*
*🔴 >>  چه کسی [آیدی]*

💬 نمایش #یوزر با آیدی

➖➖➖➖➖➖➖➖➖

*🔴 >>  silent*
*🔴 >>  سکوت*

💬  سکوت #یک کاربر

➖➖➖➖➖➖➖➖➖

*🔴 >>  unsilent*
*🔴 >>  حذف سکوت*

💬  حذف سکوت #یک کاربر

➖➖➖➖➖➖➖➖➖

*🔴 >>  kick*
*🔴 >>  اخراج*

💬 اخراج کردن #یک کاربر

➖➖➖➖➖➖➖➖➖

*🔴 >>  ban*
*🔴 >>  مسدود*

💬 مسدود کردن #یک کاربر

➖➖➖➖➖➖➖➖➖

*🔴 >>  unban*
*🔴 >>  ازادکردن*

💬  ازادکردن #یک کاربر

➖➖➖➖➖➖➖➖➖

*🔴 >>  setlink*
*🔴 >>  تنظیم لینک*

💬  ثبت #لینک گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  link*
*🔴 >>  لینک*

💬  دریافت #لینک گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  setrules*
*🔴 >>  تنظیم قوانین*

💬  ثبت #قانون گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  rules*
*🔴 >>  قوانین*

💬  دریافت #قوانین گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  clean rules*
*🔴 >>  پاکسازی قانون*

💬  پاک کردن #قوانین گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  clean silentlist*
*🔴 >>  پاکسازی لیست سکوت*

💬  پاک کردن #لیست کاربران ساکت شده

➖➖➖➖➖➖➖➖➖

*🔴 >>  pin*
*🔴 >>  سنجاق کن*

💬 سنجاق کردن یک #متن در گروه

➖➖➖➖➖➖➖➖➖

*🔴 >>  unpin*
*🔴 >>  حذف سنجاق* 

💬 حذف پیام #سنجاق شده

➖➖➖➖➖➖➖➖➖

*🔴 >>  filter*
*🔴 >>  فیلتر* 

💬 فیلتر کردن #کلمه

➖➖➖➖➖➖➖➖➖

*🔴 >>  unfilter*
*🔴 >>  حذف فیلتر*
 
💬 حذف فیلتر #کلمه

➖➖➖➖➖➖➖➖➖

*🔴 >>  filterlist*
*🔴 >>  لیست فیلتر* 

💬 نمایش #لیست فیلتر

➖➖➖➖➖➖➖➖➖

*🔴 >>  welcome enable*
*🔴 >>  خوش امد گویی فعال*

💬 فعال کردن #خوشآمدگویی

➖➖➖➖➖➖➖➖➖

*🔴 >>  welcome disable*
*🔴 >>  خوش امد گویی غیرفعال*

💬 غیرفعال کردن #خوشآمدگویی

➖➖➖➖➖➖➖➖➖

*🔴 >>  set welcome [text]*
*🔴 >>  تنظیم حوش امد گویی [متن]*

💬 تنظیم کردن #پیام خوشآمدگویی

➖➖➖➖➖➖➖➖➖

*🔴 >>  del [ 1 - 1000 ]*
*🔴 >>  پاکسازی [ 1 - 1000 ]*

💬 حذف #پیام های گروه حداکثر 1000

➖➖➖➖➖➖➖➖➖

*🔴 >>  delall [reply]*
*🔴 >>  حذف کلی [reply]*

💬 حذف #همه پیام های یک کاربر

➖➖➖➖➖➖➖➖➖

*🔴 >>  check*
*🔴 >>  وضعیت شارژ*

💬 اطلاع از #تاریخ انقضای گروه

➖➖➖➖➖➖➖➖➖

...در زدن #دستورات به فاصله حروف دقت کنید

]]
return text2
end

if matches[1] == "#سازنده ربات" and is_mod(msg) then
text = "🔃 ارتـــــــباط با ما 😊\n\n🔴 برای ارتباط با سازنده ربات میتوانید از طریق آیدی زیر اقدام کنید 😊\n\n🔴 >>  @MardeMajazi\n\n🔴>>   +12518888201"
return text
end



if matches[1]=="پینگ" and is_mod(msg) then  
return  "نزن #لامصب آنلاینم  😡"
end

if matches[1]=="انلاینی" and is_mod(msg) then  
return  "انـــلاینـــم #عزیـــــــــزم 😜🖐"
end

if matches[1]=="ربات؟" and is_sudo(msg) then  
return  "جـون #دلــــم عشقـــم  😍💋"
end

--------------------- Welcome -----------------------
	if matches[1] == "خوش امد گویی" and is_mod(msg) then
		if matches[2] == "فعال" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "yes" then
       if not lang then
				return "_Group_ *welcome* _is already enabled_"
       elseif lang then
				return "خوش امد گویی #فعال است 😐❤️"
           end
			else
		data[tostring(chat)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
       if not lang then
				return "_Group_ *welcome* _has been enabled_"
       elseif lang then
				return "انجام شد !\n\nخوش امد گویی با موفقیت #فعال شد 😐❤️"
          end
			end
		end
		
		if matches[2] == "غیرفعال" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "no" then
      if not lang then
				return "_Group_ *Welcome* _is already disabled_"
      elseif lang then
				return "خوش امد گویی #فعال نیست 😐❤️"
         end
			else
		data[tostring(chat)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
      if not lang then
				return "_Group_ *welcome* _has been disabled_"
      elseif lang then
				return "انجام شد !\n\nخوش امد گویی با موفقیت #غیرفعال شد 😐❤️"
          end
			end
		end
	end
	if matches[1] == "تنظیم خوش امد گویی" and matches[2] and is_mod(msg) then
		data[tostring(chat)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
       if not lang then
		return "_Welcome Message Has Been Set To :_\n*"..matches[2].."*\n\n*You can use :*\n_{rules} ➣ Show Group Rules_\n_{name} ➣ New Member First Name_\n_{username} ➣ New Member Username_"
       else
		return "انجام شد !\n\nپیام خوش امد گویی با موفقیت #تنظیم شد به\n\n🔴*"..matches[2].."*"
     end
	end
end
-----------------------------------------
local function pre_process(msg)
   local chat = msg.chat_id_
   local user = msg.sender_user_id_
 local data = load_data(_config.moderation.data)
	local function welcome_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
		administration = load_data(_config.moderation.data)
    if administration[arg.chat_id]['setwelcome'] then
     welcome = administration[arg.chat_id]['setwelcome']
      else
     if not lang then
     welcome = "*Welcome Dude*"
    elseif lang then
     welcome = "سلام دوست عزیز به گروه خودت #خوش اومدی 😐❤️"
        end
     end
 if administration[tostring(arg.chat_id)]['rules'] then
rules = administration[arg.chat_id]['rules']
else
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n"
 end
end
if data.username_ then
user_name = "@"..check_markdown(data.username_)
else
user_name = ""
end
		local welcome = welcome:gsub("{rules}", rules)
		local welcome = welcome:gsub("{name}", check_markdown(data.first_name_))
		local welcome = welcome:gsub("{username}", user_name)
		local welcome = welcome:gsub("{gpname}", arg.gp_name)
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, welcome, 0, "md")
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
	if msg.adduser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.adduser
    	}, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
		else
			return false
		end
	end
	if msg.joinuser then
		welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.joinuser
    	}, welcome_cb, {chat_id=chat,msg_id=msg.id,gp_name=msg.to.title})
		else
			return false
        end
		end
	end
 end
return {
patterns ={

"^(پینگ)$",
"^(#راهنمای مدیریت)$",
"^(ربات؟)$",
"^(انلاینی)$",
"^(#سازنده ربات)$",
"^(#راهنمای قفل ها)$",
"^(ایدی)$",
"^(ایدی) (.*)$",
"^(سنجاق کن)$",
"^(حذف سنجاق)$",
"^(اطلاعات گروه)$",
"^(تست)$",
"^(فعال شو)$",
"^(غیرفعال شو)$",
"^(ارتقا به مدیر)$",
"^(ارتقا به مدیر) (.*)$",
"^(حذف مدیر)$",
"^(حذف مدیر) (.*)$",
"^(ارتقا به مالک)$",
"^(ارتقا به مالک) (.*)$",
"^(حذف مالک)$",
"^(حذف مالک) (.*)$",
"^(لیست مالکان)$",
"^(لیست مدیران)$",
"^(قفل) (.*)$",
"^(بازکردن) (.*)$",
"^(تنظیمات)$",
"^(لیست ممنوعیت)$",
"^(قفل) (.*)$",
"^(بازکردن) (.*)$",
"^(لینک)$",
"^(تنظیم لینک)$",
"^(قوانین)$",
"^(تنظیم قوانین) (.*)$",
"^(درباره گروه)$",
"^(تنظیم درباره گروه) (.*)$",
"^(تنظیم نام) (.*)$",
"^(پاکسازی) (.*)$",
"^(تنظیم فلود) (%d+)$",
"^(رس) (.*)$",
"^(چه کسی) (%d+)$",
"^(راهنما)$",
"^(تنظیم زبان) (.*)$",
"^(فیلتر) (.*)$",
"^(حذف فیلتر) (.*)$",
"^(لیست فیلتر)$",
"^([https?://w]*.?t.me/joinchat/%S+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",
"^(تنظیم خوش امد گویی) (.*)",
"^(خوش امد گویی) (.*)$"


},
run=run,
pre_process = pre_process
}
