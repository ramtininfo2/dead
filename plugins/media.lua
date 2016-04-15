kicktable = {}


local function run(msg, matches)
    if is_momod(msg) and is_banned(msg) and is_gbanned(msg) then
        return nil
    end
    local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)] then
        if data[tostring(msg.to.id)]['settings'] then
            if data[tostring(msg.to.id)]['settings']['lock_media'] then
                lock_media = data[tostring(msg.to.id)]['settings']['lock_media']
            end
        end
    end
    local chat = get_receiver(msg)
    local user = "user#id"..msg.from.id
    if lock_media == "yes" then
    send_large_msg(chat, 'Share media is not allowed here!!')
    chat_del_user(chat, user, ok_cb, true)
    end
end
 
return {
  patterns = {
  "%[(photo)%]",
  "%[(audio)%]",
  "%[(video)%]" 
  },
  run = run
}
