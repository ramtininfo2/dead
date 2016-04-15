local function run (msg, matches)
local data = load_data(_config.moderation.data)
   if matches[1] == 'chat_add_user_link' then
        local user_id = msg.from.id
        if data[tostring(msg.to.id)] then
        if data[tostring(msg.to.id)]['settings'] then
        if data[tostring(msg.to.id)]['settings']['lock_join'] == 'yes' then
         if not is_momod(msg) and not is_banned(msg) and not is_gbanned(msg) then
        kick_user(user_id, msg.to.id)
     send_large_msg(get_receiver(msg), "Member join is lock!")
            end
          end
       end   
    end
  end
return {
  patterns = {
    "^!!tgservice (chat_add_user_link)$"
  },
  run = run
}
