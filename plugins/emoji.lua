local function run(msg)
    local data = load_data(_config.moderation.data)
     if data[tostring(msg.to.id)]['settings']['lock_emoji'] == 'yes' then
	  if not is_momod(msg) and not is_banned(msg) and not is_gbanned(msg) then 
	 send_large_msg(get_receiver(msg), "Emoji is not allowed here!")
	 chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
    local msgtag = 'You cant emoji anything here '
   local receiver = msg.to.id
    send_large_msg('chat#id'..receiver, msgads.."\n", ok_cb, false)
      end
   end
 end
 return {
patterns = {
   
  },
 run = run
}
