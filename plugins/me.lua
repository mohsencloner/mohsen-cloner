-- Begin myinfo.lua
local function run(msg, matches)
	if matches[1]:lower() == 'me' or matches[1]:lower() == 'اطلاعات من' then
		function get_id(arg, data)
			local username
			if data.first_name_ then
				if data.username_ then
					username = '@'..data.username_
				else
					username = '<i>No Username!</i>'
				end
				local telNum
				if data.phone_number_ then
					telNum = '+'..data.phone_number_
				else
					telNum = '----'
				end
				local lastName
				if data.last_name_ then
					lastName = data.last_name_
				else
					lastName = '----'
				end
				local rank
				if is_sudo(msg) then
					rank = 'صاحب ربات'
				elseif is_owner(msg) then
					rank = 'مالک گروه'
				elseif is_admin(msg) then
					rank = 'ادمین ربات'
				elseif is_mod(msg) then
					rank = 'مدیر ربات'
				else
					rank = 'ممبر گروه'
				end
				local text = '<b>🔃 اطلاعات شما 😐❤️</b>\n\n<b>🔴 نام >></b> <b>'..data.first_name_..'</b>\n<b>🔴 نام خانوادگی >></b> <b>'..lastName..'</b>\n<b>🔴 یوزرنیم >></b> <b>'..username..'</b>\n<b>🔴 آیدی >></b> [ <code>'..data.id_..'</code> ]\n<b>🔴 آیدی گروه >></b> [ <code>'..arg.chat_id..'</code> ]\n<b>🔴 شماره تلفن >></b> [ <code>'..telNum..'</code> ]\n<b>🔴 مقام >></b> <i>'..rank..'</i>'
				tdcli.sendMessage(arg.chat_id, msg.id_, 1, text, 1, 'html')
			end
		end
		tdcli_function({ ID = 'GetUser', user_id_ = msg.sender_user_id_, }, get_id, {chat_id=msg.chat_id_, user_id=msg.sendr_user_id_})
	end
end

return { patterns = { 
"^([Mm][Ee])$",
"^(اطلاعات من)$",
 }, run = run }