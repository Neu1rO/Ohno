local discordia = require('discordia')
local client = discordia.Client()

client:on('ready', function()
    print('Logged in as '.. client.user.username)
        ohnosave = io.open("ohnocounter.txt","r+")
        counter = ohnosave:read()
        ohnosave:close()
end)

--Main task--

client:on('messageCreate', function(message)
    
    if message.guild ~= nil then
        ohno = message.guild.emojis:find(function(e) return e.name == 'ohno' end)
        msg = message.content
        lowmsg = string.lower(msg)
            if string.find(lowmsg, "ohno") or string.find(lowmsg, "oh no") then
                message:addReaction(ohno)
                counter = counter + 1
                ohnosave = io.open ("ohnocounter.txt", "r+")
                ohnosave:write(counter)
                ohnosave:close()
                stat = tostring(counter) .. " ohnos"
                client:setGame(stat)
            end
    end
end)
         
--Commands--

client:on('messageCreate', function(help)
          
        if help.content == "~help" then
            help.channel:send{
            embed = {
            title = "Available commands:",
            fields = {
                {name = "Use ~ prefix", value = "anuke \n router \n pingme \n do sk \n pfp (ping user for their pfp) \n time \n userinfo (ping user) \n brazil \n \\**iOS** (without prefix)", inline = false},                      
                     },
                color = discordia.Color.fromRGB(254, 254, 254).value,
                     }
                              }
        end
end)

--Simple Warn System--

        function stringsearch()
            if string.find(linearr[linenumber], usrid) then
                warnusrid = string.sub(linearr[linenumber], 1, 18)
                warncount = string.sub(linearr[linenumber], 20)
                warncount = warncount + 1
                linearr[linenumber] = warnusrid .. " " .. warncount
                found = true
                founduserid = warnusrid
                founduserwarncount = warncount
                return found
            end
         end
         
         function stringsearchclear()
            if string.find(linearr[linenumber], usrid) then
                warnusrid = string.sub(linearr[linenumber], 1, 18)
                warncount = string.sub(linearr[linenumber], 20)
                if warncount ~= "0" then
                warncount = warncount - 1
                end
                linearr[linenumber] = warnusrid .. " " .. warncount
                found = true
                founduserid = warnusrid
                founduserwarncount = warncount
                return found
            end
         end
         
--[start of warn command]

client:on('messageCreate', function(warning)

        warneduser = warning.mentionedUsers.first
        warningmessage = warning.content
        pref = warningmessage:sub(1, 1)
        subcommand = warningmessage:match("(%w+)(.+)")
        
        if pref ~= nil and subcommand ~= nil then
        command = pref .. subcommand
        end
         
        if warning.member ~= nil then
        moder = warning.member.roles:find(function(m) return string.lower(m.name) == 'moderator' end)
        end
         
        if moder ~= nil and string.lower(moder.name) == "moderator" and warneduser ~= nil and command == "~warn" then
         
            warnfile = io.open("warnlist.txt", "r")
            found = false
            usrid = warneduser.id
            linearr = {}
            linenumber = 0

                for line in warnfile:lines() do
                    linenumber = linenumber + 1
                    linearr[linenumber] = line
                    stringsearch()
                end
         
                    if found == false then
                        linenumber = linenumber + 1
                        linearr[linenumber] = usrid .. " 1"
                        warnfile:write(linearr[linenumber] .. "\n")
                        founduserid = usrid
                        founduserwarncount = 1
                    end
         
            warnfile:close()
            io.open("warnlist.txt", "w"):close()
            warnfile = io.open("warnlist.txt", "r+")
         
                for i = 1, linenumber do
                    warnfile:write(linearr[i] .. "\n")
                end
         
            warnfile:close()
            warning.channel:send("<@" .. founduserid .. ">" .. " has been warned " .. founduserwarncount .. " time(s)")
         end
         
        if command == "~warn" and (moder == nil or warneduser == nil) then
            warning.channel:send("You have no permission to warn users or user id is invalid")
        end
         
--[end of warn command]
         
--[start of unwarn command]
        
        if warning.member ~= nil then
        moder = warning.member.roles:find(function(m) return string.lower(m.name) == 'moderator' end)
        end
         
        if moder ~= nil and string.lower(moder.name) == "moderator" and warneduser ~= nil and command == "~unwarn" then
         
            warnfile = io.open("warnlist.txt", "r")
            found = false
            usrid = warneduser.id
            linearr = {}
            linenumber = 0

                for line in warnfile:lines() do
                    linenumber = linenumber + 1
                    linearr[linenumber] = line
                    stringsearchclear()
                end
         
                    if found == false or founduserwarncount == "0" then
                        warning.channel:send("This user has 0 warnings")
                    end
         
            warnfile:close()
            io.open("warnlist.txt", "w"):close()
            warnfile = io.open("warnlist.txt", "r+")
         
                for i = 1, linenumber do
                    warnfile:write(linearr[i] .. "\n")
                end
         
            warnfile:close()
         
                if found == true and founduserwarncount ~= "0" then
                    warning.channel:send("Removed one warning from user " .. "<@" .. founduserid .. ">")
                end
         end

--[end of unwarn command]
         
--[start of warnings command]
         
         if moder ~= nil and string.lower(moder.name) == "moderator" and warneduser ~= nil and command == "~warnings" then
         
            warnfile = io.open("warnlist.txt", "r")
            found = false
            usrid = warneduser.id
            linearr = {}
            linenumber = 0
         
                for line in warnfile:lines() do
                    linenumber = linenumber + 1
                    linearr[linenumber] = line
         
                        if string.find(linearr[linenumber], usrid) then
                        warnusrid = string.sub(linearr[linenumber], 1, 18)
                        warncount = string.sub(linearr[linenumber], 20)
                        found = true
                        founduserid = warnusrid
                        founduserwarncount = warncount
                        end
                end
         
            warnfile:close()
         
                if found == true then
                    warning.channel:send("<@" .. founduserid .. ">" .. " has " .. founduserwarncount .. " warning(s)")
                else warning.channel:send("<@" .. warneduser.id .. ">" .. " has 0 warning(s)")
                end
         
         end
         if (moder == nil or string.lower(moder.name) ~= "moderator") and command == "~warnings" then
            warning.channel:send("This is moderator-only command")
         end
end)
         
--[end of warn system]
         
--Other stuff--

client:on('messageCreate', function(anukechannel)
    cmd = anukechannel.content
        if anukechannel.member ~= nil then
            mod = anukechannel.member.roles:find(function(m) return string.lower(m.name) == 'moderator' end)
        end
                if mod ~= nil and string.lower(mod.name) == "moderator" and cmd == "~setanukechannel" then
                    anukech = anukechannel.channel
                end
end)

client:on('messageCreate', function(anuk)
        anook = anuk.content
            if string.find(anook, "~anuke") and anuk.channel == anukech then
                quotenumber = math.random(1, 132)
                quote = "./anukequotes/" .. quotenumber .. ".png"
                anuk.channel:send{file = quote}
            end
end)
     
client:on('messageCreate', function(stuff)

        if stuff.content == "~router" and stuff.guild ~= nil then
            router = stuff.guild.emojis:find(function(r) return r.name == 'router' end)
            stuff.channel:send("<:router:" .. router.id .. ">")
        end
         
        if stuff.content == "~pingme" then
            stuff.channel:send(stuff.author.mentionString)
        end
         
        if stuff.content == "~time" then
            stuff.channel:send{
                    embed = {
                             fields = {
                                {name = "UTC time: ", value = discordia.Date():toISO(), inline = false},
                                {name = "Host time: ", value = discordia.Date():toString('%a %b %d %Y %T GMT%z'), inline = false},
                                       },
                            color = discordia.Color.fromRGB(254, 254, 254).value,
                            }}
        end
         
        if stuff.content == "~do sk" then
            stuff.channel:send('do not the sk.')
        end
        
        if stuff.content == "**iOS**" then
            stuff.channel:send('*1. You can\'t*')
        end
end)

client:on('messageCreate', function(brazil)
         brazilcontent = brazil.content
         brazilmention = brazil.mentionedUsers.first
         if brazil.content == "~brazil" then
            brazil.channel:send(brazil.author.name .. ' is going to ' .. ':flag_br:')
         elseif brazilmention ~= nil then
            if string.find(brazilcontent, "~brazil") then
                brazil.channel:send(brazilmention.name .. ' is going to ' .. ':flag_br:')
            end
         end
    end)

--User info--

client:on('messageCreate', function(userinfo)
        
    infocontent = userinfo.content
    targetuser = userinfo.mentionedUsers.first 
          
    if string.find(infocontent, "~userinfo") and targetuser ~= nil then
        
        memb = userinfo.guild:getMember(targetuser)
        nick = targetuser.name
        joindate = memb.joinedAt
        servernick = memb.nickname
            
            if servernick == nil then
                servernick = "None"
            end
         
        accountcreated = targetuser.createdAt
        acISO = discordia.Date(accountcreated):toISO()
         
            if targetuser.bot == true then
                isbot = "Yes"
            else isbot = "No"
            end

         userinfo.channel:send{
                               embed = {
                                        title = "Info about user " .. nick .. "#" .. targetuser.discriminator,
                                        fields = {
                                                  {name = "User ID:", value = targetuser.id, inline = false},
                                                  {name = "Bot?", value = isbot, inline = false},
                                                  {name = "Server nickname:",  value = servernick, inline = false},
                                                  {name = "Account created at:", value = acISO, inline = false},
                                                  {name = "Joined at:", value = joindate, inline = false},
                                                  },
                                        color = discordia.Color.fromRGB(254, 254, 254).value,
                                        }
                              }
    end
end)

--Get profile picture--

client:on('messageCreate', function(profile)
          
        profilemsg = profile.content
        mentioneduser = profile.mentionedUsers.first 
         
            if profilemsg == "~pfp" then
                pfp = profile.author.avatarURL
                profile.channel:send{
                    embed = {
                    title = profile.author.name .. "'s profile picture:",
                    image = {
                        url = pfp                     
                            },
                        color = discordia.Color.fromRGB(254, 254, 254).value,
                            }
                                    }
         elseif mentioneduser ~= nil then
         
         if string.find(profilemsg, "~pfp") then
            pfp = mentioneduser.avatarURL
            profile.channel:send{
                embed = {
                title = mentioneduser.name .. "'s profile picture:",
                image = {
                    url = pfp                      
                        },
                    color = discordia.Color.fromRGB(254, 254, 254).value,
                        }
                                }
         end
         end
    end)

client:run("Bot "..io.open("./token.config"):read())
