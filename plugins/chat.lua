antichat = {}

do
local function run(msg, matches)
if msg.to.type == 'chat' then
  if is_momod(msg) then
    return nil
  end
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)]['settings']['lock_chat'] then
    if data[tostring(msg.to.id)]['settings']['lock_chat'] == 'yes' then
      if antichat[msg.from.id] == true then 
        return
      end
      send_large_msg("chat#id".. msg.to.id , "Chat is not allowed here")
      local name = user_print_name(msg.from)
      chat_del_user('chat#id'..msg.to.id,'user#id'..msg.from.id,ok_cb,false)
      savelog(msg.to.id, name.." ["..msg.from.id.."] kicked (chat was locked) ")
		  antichat[msg.from.id] = true
      return
    end
  end
  return
end
end
local function cron()
  antichat = {}
end
return {
  patterns = {
    "(.*)"
    },
  run = run,
	cron = cron
}

end
