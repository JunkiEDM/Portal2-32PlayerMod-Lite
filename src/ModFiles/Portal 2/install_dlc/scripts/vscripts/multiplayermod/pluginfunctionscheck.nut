//---------------------------------------------------
//         *****!Do not edit this file!*****
//---------------------------------------------------
//   ___  _              _
//  | _ \| | _  _  __ _ (_) _ _
//  |  _/| || || |/ _` || || ' \
//  |_|_ |_| \_,_|\__, ||_||_||_|
//  | __|_  _  _ _|___/ | |_ (_) ___  _ _   ___
//  | _|| || || ' \ / _||  _|| |/ _ \| ' \ (_-<
//  |_|  \_,_||_||_|\__| \__||_|\___/|_||_|/__/
//    ___  _              _    _
//   / __|| |_   ___  __ | |__(_)
//  | (__ | ' \ / -_)/ _|| / / _
//   \___||_||_|\___|\__||_\_\(_)
//---------------------------------------------------
// Purpose: If the plugin isn't loaded or some broke
// over new updates, then we check and redefine each
//              function individually.
//---------------------------------------------------

// TODO: Replace everything with what is commented below
// This literally works, and is more efficient than the game loads lol
// I don't know how to make it slow down enough so that it can properly detect
// the first plugin function (GetPlayerName()) without treating it as false
/*
OurAddedFunctionsLoaded <- [
    GetPlayerNameLoaded <- false,
    GetSteamIDLoaded <- false,
    AddChatCallbackLoaded <- false,
    SetPhysTypeConvarLoaded <- false,
    SetMaxPortalSeparationConvarLoaded <- false
]

OurAddedFunctions <- [
    "GetPlayerName",
    "GetSteamID",
    "AddChatCallback",
    "SetPhysTypeConvar"
    "SetMaxPortalSeparationConvar"
]

//---------------------------------------------------

foreach (Function in OurAddedFunctions) {
    // Does the function exist?
    local exists = false
    if (Function in this) {
        exists = true
    }
    if (exists) {
        for (local i = 0; i < 4; i++) {
            if (Function == OurAddedFunctions[i]) {
            // Get the variable in OurAddedFunctionsLoaded[]
            // through the order of OurAddedFunctions[]
                OurAddedFunctionsLoaded[i] = true
            }
        }
    } else {
        // Redefine logic
        switch (Function) {
        case OurAddedFunctions[0]:
            function GetPlayerName(int) {
                return "player" + int
            }
        case OurAddedFunctions[1]:
            function GetSteamID(int) {
                return -1
            }
        case OurAddedFunctions[2]:
            function AddChatCallback(string) {
                printl("(P2:MM): Plugin not loaded. Unable to add chat callback for chat commands!")
            }
        case OurAddedFunctions[3]:
            function SetPhysTypeConvar(int) {
                printl("(P2:MM): Plugin not loaded. Unable to change game grab controllers!")
            }
        case OurAddedFunctions[4]:
            function SetMaxPortalSeparationConvar(int) {
                printl("(P2:MM): Plugin not loaded. Unable to change player collision amounts!")
            }
        }
        printl("(P2:MM): " + Function + "() has been redefined!")
    }
}

bHasNothingLoaded <- false
foreach (variable in OurAddedFunctionsLoaded) {
    if (variable) {
        // Something loaded, so the plugin must be as well
        PluginLoaded <- true
    } else {
        bHasNothingLoaded = true
    }
}

if (!bHasNothingLoaded) {
    // Nothing loaded
    PluginLoaded <- false
}*/

GetPlayerNameLoaded <- false
GetSteamIDLoaded <- false
AddChatCallbackLoaded <- false
SetPhysTypeConvarLoaded <- false
SetMaxPortalSeparationConvarLoaded <- false

function RedefinedMessage(functionname) {
    printl("(P2:MM): " + functionname + "() has been redefined!")
}

function ReplaceGetPlayerName() {
    // Does the function exist?
    if ("GetPlayerName" in this) {
        GetPlayerNameLoaded <- true
        return
    }
    // Redefine
    function GetPlayerName(entinx) {
        return "player" + entinx
    }
    RedefinedMessage("GetPlayerName")
}

function ReplaceGetSteamID() {
    if ("GetSteamID" in this) {
        GetSteamIDLoaded <- true
        return
    }
    function GetSteamID(string) {
        return -1
    }
    RedefinedMessage("GetSteamID")
}

function ReplaceAddChatCallback() {
    if ("AddChatCallback" in this) {
        AddChatCallbackLoaded <- true
        return
    }
    function AddChatCallback(string) {
        printl("(P2:MM): Plugin not loaded. Unable to add chat callback for chat commands!")
    }
    RedefinedMessage("AddChatCallback")
}

function ReplaceSetPhysTypeConvar() {
    if ("SetPhysTypeConvar" in this) {
        SetPhysTypeConvarLoaded <- true
        return
    }
    function SetPhysTypeConvar(string) {
        printl("(P2:MM): Plugin not loaded. Unable to change game grab controllers!")
    }
    RedefinedMessage("SetPhysTypeConvar")
}

function ReplaceSetMaxPortalSeparationConvar() {
    if ("SetMaxPortalSeparationConvar" in this) {
        SetMaxPortalSeparationConvarLoaded <- true
        return
    }
    function SetMaxPortalSeparationConvar(string) {
        printl("(P2:MM): Plugin not loaded. Unable to change player collision amounts!")
    }
    RedefinedMessage("SetMaxPortalSeparationConvar")
}

ReplaceGetPlayerName()
ReplaceGetSteamID()
ReplaceAddChatCallback()
ReplaceSetPhysTypeConvar()
ReplaceSetMaxPortalSeparationConvar()

if (GetPlayerNameLoaded || GetSteamIDLoaded || AddChatCallbackLoaded || SetPhysTypeConvarLoaded || SetMaxPortalSeparationConvarLoaded) {
    // Something loaded, so the plugin must be as well
    PluginLoaded <- true
}
else if (!GetPlayerNameLoaded && !GetSteamIDLoaded && !AddChatCallbackLoaded && !SetPhysTypeConvarLoaded && !SetMaxPortalSeparationConvarLoaded) {
    // Nothing loaded
    PluginLoaded <- false
}