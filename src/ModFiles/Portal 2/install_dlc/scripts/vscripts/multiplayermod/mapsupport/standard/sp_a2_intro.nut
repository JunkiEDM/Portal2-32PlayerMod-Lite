//  ██████╗██████╗             █████╗ ██████╗            ██╗███╗  ██╗████████╗██████╗  █████╗
// ██╔════╝██╔══██╗           ██╔══██╗╚════██╗           ██║████╗ ██║╚══██╔══╝██╔══██╗██╔══██╗
// ╚█████╗ ██████╔╝           ███████║  ███╔═╝           ██║██╔██╗██║   ██║   ██████╔╝██║  ██║
//  ╚═══██╗██╔═══╝            ██╔══██║██╔══╝             ██║██║╚████║   ██║   ██╔══██╗██║  ██║
// ██████╔╝██║     ██████████╗██║  ██║███████╗██████████╗██║██║ ╚███║   ██║   ██║  ██║╚█████╔╝
// ╚═════╝ ╚═╝     ╚═════════╝╚═╝  ╚═╝╚══════╝╚═════════╝╚═╝╚═╝  ╚══╝   ╚═╝   ╚═╝  ╚═╝ ╚════╝

a2HasPortalGun <- false

function MapSupport(MSInstantRun, MSLoop, MSPostPlayerSpawn, MSPostMapSpawn, MSOnPlayerJoin, MSOnDeath, MSOnRespawn) {
    if (MSInstantRun) {
        Entities.FindByName(null, "incinerator_death_fade").Destroy()
        Entities.FindByName(null, "camera_ghostAnim").Destroy()
        Entities.FindByName(null, "door_0-close_door_rl").Destroy()
        Entities.FindByName(null, "incinerator_window_brush").Destroy()
        Entities.FindByName(null, "incinerator_portal").__KeyValueFromString("FadeStartDist", "1750")
        Entities.FindByName(null, "incinerator_portal").__KeyValueFromString("FadeDist", "1950")
        Entities.FindByName(null, "incinerator_portal").__KeyValueFromString("targetname", "incinerator_portal_custom")
        EntFire("@enable_arms", "Trigger", "", 0, null)
        Entities.FindByName(null, "InstanceAuto13-dangle_ceiling-disable_arms").Destroy()
        Entities.FindByClassnameNearest("info_player_start", Vector(2704, -1260, 112), 1024).Destroy()
        Entities.FindByClassnameNearest("trigger_once", Vector(2704, -1260, 112), 1024).Destroy()
        Entities.FindByClassnameNearest("trigger_once", Vector(-2250.5, 605.5, 6668), 1024).Destroy()

        // Make changing levels work
        EntFire("transition_trigger", "AddOutput", "OnStartTouch p2mm_servercommand:Command:changelevel sp_a2_laser_intro:0.3", 0, null)
    }

    if (MSPostPlayerSpawn) {
        printlP2MM(0, true, "MSPostPlayerSpawn Ran")
        SpA2IntroViewcontrol <- Entities.CreateByClassname("point_viewcontrol_multiplayer")
        SpA2IntroViewcontrol.__KeyValueFromString("targetname", "SpA2IntroViewcontrol")
        SpA2IntroViewcontrol.__KeyValueFromString("target_team", "-1")
        SpA2IntroViewcontrol.SetOrigin(Entities.FindByName(null, "ghostAnim").GetOrigin())
        EntFire("SpA2IntroViewcontrol", "setparent", "ghostAnim", 0, null)
        EntFire("SpA2IntroViewcontrol", "setparentattachment", "attach_1", 0, null)
        EntFire("SpA2IntroViewcontrol", "Enable", "", 0, null)
        EntFire("SpA2IntroViewcontrolTele", "disable", "", 20.75, null)
        EntFire("SpA2IntroViewcontrol", "AddOutput", "targetname SpA2IntroViewcontrolTele", 0.25, null)
        EntFire("SpA2IntroViewcontrolTele", "AddOutput", "targetname SpA2IntroViewcontrolDone", 20.80, null)
        SpA2IntroViewcontrol.PrecacheSoundScript("ScriptedSequence.IncineratorFall")
        local TempEnt = Entities.CreateByClassname("prop_dynamic")
        TempEnt.__KeyValueFromString("targetname", "TempEnt")
        EntFire("TempEnt", "AddOutput", "targetname PlayFallSound", 0, null)
        EntFire("start_fall_anim_relay", "Trigger", "", 0, null)
    }

    if (MSLoop) {

        if (Entities.FindByName(null, "PlayFallSound")) {
            Entities.FindByName(null, "blue").EmitSound("playonce\\scripted_sequences\\incinerator_fall_01.wav")
            Entities.FindByName(null, "PlayFallSound").Destroy()
        }

        if (Entities.FindByName(null, "SpA2IntroViewcontrolTele")) {
            for (local p = null; p = Entities.FindByClassname(p, "player");) {
                p.SetOrigin(Vector(2704, -1260, 92))
            }
        }

        if (Entities.FindByName(null, "SpA2IntroViewcontrolDone")) {
            for (local p = null; p = Entities.FindByClassname(p, "player");) {
                p.SetOrigin(Vector(-3308, 536, -10737))
                p.SetAngles(0 0 0)
            }
            EntFire("SpA2IntroViewcontrolDone", "AddOutput", "targetname SpA2IntroViewcontrolFinished", 0.15, null)
        }

        EntFire("shaft_areaportal_1", "Open", "", 0, null)
        EntFire("shaft_areaportal_2", "Open", "", 0, null)

        if (!a2HasPortalGun) {
            // Remove Portal Gun
            for (local ent = null; ent = Entities.FindByClassname(ent, "weapon_portalgun");) {
                ent.__KeyValueFromString("CanFirePortal1", "0")
                ent.__KeyValueFromString("CanFirePortal2", "0")
                EntFireByHandle(ent, "disabledraw", "", 0, null, null)
            }

            for (local ent = null; ent = Entities.FindByClassname(ent, "predicted_viewmodel");) {
                EntFireByHandle(ent, "disabledraw", "", 0, null, null)
            }
        } else {
            // Give Portal Gun
            for (local ent = null; ent = Entities.FindByClassname(ent, "weapon_portalgun");) {
                ent.__KeyValueFromString("CanFirePortal1", "1")
                ent.__KeyValueFromString("CanFirePortal2", "1.")
                EntFireByHandle(ent, "enabledraw", "", 0, null, null)
            }

            for (local ent = null; ent = Entities.FindByClassname(ent, "predicted_viewmodel");) {
                EntFireByHandle(ent, "enabledraw", "", 0, null, null)
            }
        }

        if (!Entities.FindByName(null, "portalgun")) {
            a2HasPortalGun = true
        }
    }
}