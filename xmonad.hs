--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--
import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.Grid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- ### Basic config ###

defaults = defaultConfig {
    terminal            = "urxvt",
    normalBorderColor   = "#000000",
    focusedBorderColor  = "#ffffff",
    workspaces          = ["main","term","media","dev1","dev2", "misc1", "misc2" ,"down","game"],

    keys                = myKeys,
    mouseBindings       = myMouseBindings,

    layoutHook          = layouts,
    manageHook          = windowRules
}

-- ### Window rules ###
windowRules = composeAll
    [ className =? "jetbrains-idea"             --> doShift "dev1"
    , className =? "rstudio-bin"                --> doShift "dev2"
    , className =? "Transmission-remote-gtk"    --> doShift "down"
    , className =? "Vlc"                        --> doShift "media"
    , className =? "Smplayer"                   --> doShift "media"
    , resource  =? "Steam"                      --> doShift "game"
    , resource  =? "hl2_linux"                  --> doShift "misc1"
    , resource  =? "desktop_window"             --> doIgnore ]

-- ### Layouts ###

layouts = tiled ||| Grid ||| Mirror tiled ||| Full
    where
        tiled = Tall nmaster delta ratio
        nmaster =1
        ratio = 1/2
        delta = 3/100

-- ### Keys ###
--
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal, with the current path as working directory
    [ ((modm .|. shiftMask, xK_Return), spawn $ ((XMonad.terminal conf) ++ " -cd $(xcwd)"))

    -- launch a terminal in home
    , ((modm .|. shiftMask, xK_BackSpace), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu-launch")

    -- close focused window (untag if there exists another, kill otherwise)
    , ((modm .|. shiftMask, xK_c     ), kill1)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    -- , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
            , (\i -> W.greedyView i . W.shift i, controlMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

    ++

    -- mod-control-shift-[1..9] @@ Copy client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask), (copy, shiftMask .|. controlMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-- ### Xmobar ###

-- Colors
colorCurrent = "#0099cc"
colorVisible = "#ffffff"
colorHidden  = "#555555"
colorUrgent  = "#ff5555"

myBar = "xmobar"
myPP = xmobarPP { ppCurrent         = xmobarColor colorCurrent "" 
                , ppVisible         = xmobarColor colorVisible ""
                , ppHidden          = xmobarColor colorVisible ""
                , ppHiddenNoWindows = xmobarColor colorHidden ""
                , ppUrgent          = xmobarColor colorUrgent ""
                , ppTitle           = xmobarColor colorCurrent ""
                , ppSep             = " | "
                , ppOrder           = \(ws:l:t) ->  [ws] ++ [l]
                }
toggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

conf = defaults {
    startupHook = setWMName "LG3D",
    layoutHook = avoidStruts $ smartBorders $ layoutHook defaults,
    manageHook = manageHook defaults <+> manageDocks
}


-- ### Start xmonad ###
main = xmonad =<< statusBar myBar myPP toggleStrutsKey conf
