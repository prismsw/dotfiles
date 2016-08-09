import Control.Exception
import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect
import XMonad.Layout.Grid
import XMonad.Util.Run
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- ### Basic config ###
myWS = ["web","term","media","dev","dev","dev","misc","misc","misc","mail"]
wsNumbers = [1..9] ++ [0]

defaults = def {
    terminal            = "urxvt",
    normalBorderColor   = "#000000",
    focusedBorderColor  = "#ffffff",
    workspaces          = zipWith (++) (map (++":") (map show wsNumbers)) myWS,

    keys                = myKeys,
    mouseBindings       = myMouseBindings,
    focusFollowsMouse   = True,

    layoutHook          = layouts,
    manageHook          = windowRules
}

-- ### Window rules ###
windowRules = composeAll []

-- ### Layouts ###

layouts = tiled ||| Grid ||| Mirror tiled ||| Full
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio = 1/2
        delta = 3/100

-- ### Mouse ###
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList []

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

    -- launch yeganesh (dmenu wrapper)
    , ((modm,               xK_p     ), spawn "$(yeganesh -x -- -fn \"xft:DejaVu Sans Mono:pixelsize=14:antialias=true:hinting=true\")")

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
    -- mod-control-[1..9], Move client to workspace N and switch to workspace N
    -- mod-control-shift-[1..9] @@ Copy client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [ (W.greedyView, 0), (W.shift, shiftMask)
                    , (\i -> W.greedyView i . W.shift i, controlMask)
                    , (copy, shiftMask .|. controlMask)
            ]
    ]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [ (W.view, 0)
                    , (W.shift, shiftMask)
                    ]
    ]

-- ### Xmobar ###

-- Colors
colorCurrent = "#0099cc"
colorVisible = "#ffffff"
colorHidden  = "#555555"
colorUrgent  = "#ff5555"

myBar = "xmobar -x 0"
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

startup :: X ()
startup = do
    setWMName "LG3D"

conf = defaults {
    startupHook = startup,
    layoutHook = avoidStruts $ smartBorders $ layoutHook defaults,
    manageHook = manageHook defaults <+> manageDocks
}


-- ### Start xmonad ###
main = do
    barConf <- statusBar myBar myPP toggleStrutsKey (ewmh conf)
    xmonad barConf
