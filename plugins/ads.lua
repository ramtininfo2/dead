local function run(msg)   
    local data = load_data(_config.moderation.data)   
     if data[tostring(msg.to.id)]['settings']['lock_ads'] == 'yes' then
     if not is_momod(msg) and not is_banned(msg) and not is_gbanned(msg) then
    send_large_msg(get_receiver(msg), "Ads is not allowed here!")
    chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
    local msgads = 'ForbiddenAdText'
    local receiver = msg.to.id
    send_large_msg('chat#id'..receiver, msg.."\n", ok_cb, false)
      end
   end
end
return {
patterns = {
"[Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/",
"[Hh][Tt][Tt][Pp][Ss]://[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]",
"[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/",
"[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/",
"[Hh][Tt][Tt][Pp]://",
"[Ww][Ww][Ww]:",
"https://(.*)",
"@(.*)",
"#(.*)"
},
run = run
}
