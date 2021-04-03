--Load client--

local discordia = require('discordia')
local client = discordia.Client()

client:on('ready', function()
    print('Logged in as '.. client.user.username)
        ohnosave = io.open("ohnocounter.txt","r+")
        counter = ohnosave:read()
        client:setGame(counter .. " ohno")
        ohnosave:close()
end)

--Reactions--

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
                client:setGame(counter .. " ohno")
            end
    end
end)

--Help command--

client:on('messageCreate', function(help)

        if help.content == ".help" then
            help.channel:send{
            embed = {
                title = "Available commands:",
                fields = {
                            {name = "User commands", value = ".time \n .userinfo (ping user)", inline = true},
                            {name = "Moderator-only commands", value = ".warn \n .unwarn \n .warnings", inline = true},
                         },
                color = discordia.Color.fromRGB(254, 254, 254).value,
                     }
                              }
        end
end)

--Some functions for warn system--

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

--Warn command--

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

            if moder ~= nil and string.lower(moder.name) == "moderator" and warneduser ~= nil and command == ".warn" then

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

--Unwarn command--

        if warning.member ~= nil then
        moder = warning.member.roles:find(function(m) return string.lower(m.name) == 'moderator' end)
        end

        if moder ~= nil and string.lower(moder.name) == "moderator" and warneduser ~= nil and command == ".unwarn" then

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

--Warnings command--

        if moder ~= nil and string.lower(moder.name) == "moderator" and warneduser ~= nil and command == ".warnings" then

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
end)

--Time command--

client:on('messageCreate', function(time)

    if time.content == ".time" then
        time.channel:send{
                             embed = {
                                      fields = {
                                                {name = "UTC time: ", value = discordia.Date():toISO(), inline = false},
                                                {name = "Host time: ", value = discordia.Date():toString('%a %b %d %Y %T GMT%z'), inline = false},
                                                },
                                      color = discordia.Color.fromRGB(254, 254, 254).value,
                                      }
                            }
    end
end)

--Userinfo command--

client:on('messageCreate', function(userinfo)

    infocontent = userinfo.content
    targetuser = userinfo.mentionedUsers.first

    if string.find(infocontent, ".userinfo") and targetuser ~= nil then

        memb = userinfo.guild:getMember(targetuser)
        nick = targetuser.name
        joindate = memb.joinedAt
        servernick = memb.nickname
        accountcreated = targetuser.createdAt
        acISO = discordia.Date(accountcreated):toISO()
        pfp = targetuser.avatarURL

            if servernick == nil then
                servernick = "None"
            end

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
                                                  {name = "Profile picture:", value = pfp, inline = false},
                                                  },
                                        image = {
                                                 url = pfp
                                                },
                                        color = discordia.Color.fromRGB(254, 254, 254).value,
                                        }
                              }
    end
end)

client:on('messageCreate', function(system)
        if system.content == ".system" then
        end
end)
--Load token and run--

client:run("Bot "..io.open("./token.config"):read())



