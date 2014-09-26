
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

--require("app.WelcomeApp").new():run()
--require("app.WelcomeApp").startup()
--game.startup()
--xpcall(function()
    require("app.WelcomeApp")
    game.startup()
--end, __G__TRACKBACK__)