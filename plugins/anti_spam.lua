
--An empty table for solving multiple kicking problem(thanks to @topkecleon )
kicktable = {}

do

local TIME_CHECK = 1 -- seconds
local data = load_data(_config.moderation.data)
local function pre_process(msg)
  if msg.service then
    return msg
  end
  if msg.from.id == our_id then
    return msg
  end
  
    -- Save user on Redis
  if msg.from.type == 'user' then
    local hash = 'user:'..msg.from.id
    print('Saving user', hash)
    if msg.from.print_name then
      redis:hset(hash, 'print_name', msg.from.print_name)
    end
    if msg.from.first_name then
      redis:hset(hash, 'first_name', msg.from.first_name)
    end
    if msg.from.last_name then
      redis:hset(hash, 'last_name', msg.from.last_name)
    end
    if msg.from.username then
      redis:hset(hash, 'username', msg.from.username)
    end
  end

  -- Save stats on Redis
  if msg.to.type == 'chat' then
    -- User is on chat
    local hash = 'chat:'..msg.to.id..':users'
    redis:sadd(hash, msg.from.id)
  end



  -- Total user msgs
  local hash = 'msgs:'..msg.from.id..':'..msg.to.id
  redis:incr(hash)

  --Load moderation data
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
    --Check if flood is one or off
    if data[tostring(msg.to.id)]['settings']['flood'] == 'no' then
      return msg
    end
  end

  -- Check flood
  if msg.from.type == 'user' then
    local hash = 'user:'..msg.from.id..':msgs'
    local msgs = tonumber(redis:get(hash) or 0)
    local data = load_data(_config.moderation.data)
    local NUM_MSG_MAX = 2
    if data[tostring(msg.to.id)] then
      if data[tostring(msg.to.id)]['settings']['flood_msg_max'] then
        NUM_MSG_MAX = tonumber(data[tostring(msg.to.id)]['settings']['flood_msg_max'])--Obtain group flood sensitivity
      end
    end
    local max_msg = NUM_MSG_MAX * 1
    if msgs > max_msg then
      local user = msg.from.id
      if is_momod(msg) then 
        return msg
      end
      local chat = msg.to.id
      local user = msg.from.id
      if kicktable[user] == true then
        return
      end
      kick_user(user, chat)
      if msg.to.type == "user" then
        banall_user("user#id"..msg.from.id,ok_cb,false)
        block_user("user#id"..msg.from.id,ok_cb,false)
      end
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] spammed and kicked ! ")
      local gbanspam = 'gban:spam'..msg.from.id
      redis:incr(gbanspam)
      local gbanspam = 'gban:spam'..msg.from.id
      local gbanspamonredis = redis:get(gbanspam)
      if gbanspamonredis then
        if tonumber(gbanspamonredis) ==  3 and not is_owner(msg) then
          banall_user(msg.from.id)
          local gbanspam = 'gban:spam'..msg.from.id
          redis:set(gbanspam, 0)
          local username = " "
          if msg.from.username ~= nil then
            username = msg.from.username
          end
          local name = user_print_name(msg.from)
          send_large_msg("chat#id"..msg.to.id, "User [ "..name.." ]"..msg.from.id.." globally banned (spamming)")
          local log_group = 1
          send_large_msg("chat#id"..log_group, "User [ "..name.." ] ( @"..username.." )"..msg.from.id.." globally banned from ( "..msg.to.print_name.." ) [ "..msg.to.id.." ] (spamming)")
        end
      end
      kicktable[user] = true
      msg = nil
    end
    redis:setex(hash, TIME_CHECK, msgs+1)
  end
  return msg
end

local function cron()
  kicktable = {}
end

return {
  patterns = {},
  cron = cron,
  pre_process = pre_process
}

end
