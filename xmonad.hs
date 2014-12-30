--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import Data.Maybe ( isNothing, isJust )
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Actions.CycleWS
import XMonad.Actions.RotSlaves
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.SetWMName
import XMonad.Actions.MouseGestures
import XMonad.Actions.CopyWindow
import Graphics.X11.ExtraTypes.XF86
import XMonad.Actions.DynamicWorkspaces
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane
import XMonad.Prompt
import XMonad.Hooks.ManageHelpers
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.GridSelect

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "xterm -bg black -fg green"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
--myNumlockMask   = mod2Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
--myWorkspaces = ["1","2"]
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)


    -- launch dmenu with clock and battery etc
	,((modm, xK_Menu), spawn "perl /home/fmaruki/codigos/perl/testedzen.pl > /home/fmaruki/.cache/dmenuclock && dmenu < /home/fmaruki/.cache/dmenuclock")

    -- close focused window
    , ((modm, xK_x     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm .|. mod1Mask, xK_Up ), sendMessage NextLayout)
    -- , ((modm .|. mod1Mask, xK_n ), sendMessage Prev Layout)

    -- Move focus to the next window
    , ((modm, xK_t ), windows W.focusDown >> updatePointer (Relative 0.5 0.5))
    , ((modm, xK_s ), windows W.focusUp >> updatePointer (Relative 0.5 0.5))
    , ((modm, xK_Right ), windows W.focusDown >> updatePointer (Relative 0.5 0.5))
    , ((modm, xK_Left ), windows W.focusUp >> updatePointer (Relative 0.5 0.5))
    , ((mod1Mask, xK_Tab ), windows W.focusDown >> updatePointer (Relative 0.5 0.5))
    , ((mod1Mask .|. shiftMask, xK_Tab ), windows W.focusUp >> updatePointer (Relative 0.5 0.5))

    -- Swap the focused window and the master window
    --, ((modm,               xK_Return), windows W.swapMaster >>  updatePointer (Relative 0.5 0.5))

    -- Swap the focused window with the next window
    --, ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    --, ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm .|. mod1Mask, xK_s), sendMessage Shrink)
    , ((modm .|. mod1Mask, xK_t), sendMessage Expand)
    , ((modm .|. mod1Mask, xK_Left), sendMessage Shrink)
    , ((modm .|. mod1Mask, xK_Right), sendMessage Expand)

    -- Push window back into tiling
    , ((modm .|. mod1Mask, xK_space ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    --, ((modm .|. mod1Mask, xK_s ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    --, ((modm .|. mod1Mask, xK_t), sendMessage (IncMasterN (-1)))

	-- XF86AudioMute
    , ((0 , 0x1008ff12), spawn "amixer -q set PCM toggle")
    , ((modm , 0x1008ff12), spawn "amixer -q set PCM toggle")

    -- XF86AudioLowerVolume
    , ((0 , 0x1008ff11), spawn "amixer sset Master 3-")
    , ((modm , 0x1008ff11), spawn "amixer sset Master 3-")

    -- XF86AudioRaiseVolume
    , ((0 , 0x1008ff13), spawn "amixer sset Master 3+")
    , ((modm , 0x1008ff13), spawn "amixer sset Master 3+")

	--rhythmbox buttons
	,((0, xF86XK_AudioNext), spawn "dbus-send --type=method_call  --print-reply --dest=org.mpris.MediaPlayer2.rhythmbox  /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
	,((0, xF86XK_AudioPrev), spawn "dbus-send --type=method_call  --print-reply --dest=org.mpris.MediaPlayer2.rhythmbox  /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
	,((0, xF86XK_AudioPlay), spawn "dbus-send --type=method_call  --print-reply --dest=org.mpris.MediaPlayer2.rhythmbox  /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
	,((modm, xF86XK_AudioNext), spawn "dbus-send --type=method_call  --print-reply --dest=org.mpris.MediaPlayer2.rhythmbox  /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")
	,((modm, xF86XK_AudioPrev), spawn "dbus-send --type=method_call  --print-reply --dest=org.mpris.MediaPlayer2.rhythmbox  /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
	,((modm, xF86XK_AudioPlay), spawn "dbus-send --type=method_call  --print-reply --dest=org.mpris.MediaPlayer2.rhythmbox  /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")

	--screenshot
	,((0,xK_Print),spawn "gnome-screenshot")

	--cycle windows
	,((modm .|. shiftMask, xK_t),rotAllUp)
	,((modm .|. shiftMask, xK_s),rotAllDown)
	,((modm .|. mod1Mask .|. shiftMask, xK_t),rotSlavesUp)
	,((modm .|. mod1Mask .|. shiftMask, xK_s),rotSlavesDown)
	,((modm .|. shiftMask, xK_Right),rotAllUp)
	,((modm .|. shiftMask, xK_Left),rotAllDown)
	,((modm .|. mod1Mask .|. shiftMask, xK_Right),rotSlavesUp)
	,((modm .|. mod1Mask .|. shiftMask, xK_Left),rotSlavesDown)

	-- workspace
	,((modm, xK_n),moveTo Prev NonEmptyWS)
	,((modm, xK_e),moveTo Next NonEmptyWS)
	,((modm .|. shiftMask, xK_n), shiftToNext >> nextWS )
	,((modm .|. shiftMask, xK_e), shiftToPrev >> prevWS )
	,((modm, xK_Down),moveTo Next HiddenNonEmptyWS)
	,((modm, xK_Up),moveTo Prev HiddenNonEmptyWS)
	,((modm .|. shiftMask, xK_Down), shiftToNext >> nextWS )
	,((modm .|. shiftMask, xK_Up), shiftToPrev >> prevWS )


  --, ((modm .|. mod1Mask, xK_Up ), windows copyToAll) -- @@ Make focused window always visible
  --, ((modm .|. mod1Mask .|. shiftMask, xK_Up ),  killAllOtherCopies) -- @@ Toggle window state back


	--screens
	,((modm .|. controlMask, xK_n), nextScreen >>  updatePointer (Relative 0.5 0.5))
	,((modm .|. controlMask, xK_e), prevScreen >>  updatePointer (Relative 0.5 0.5))
	,((modm .|. controlMask .|. shiftMask, xK_space), swapNextScreen >>  updatePointer (Relative 0.5 0.5))
	,((modm .|. controlMask .|. shiftMask, xK_n), shiftNextScreen >> nextScreen >>  updatePointer (Relative 0.5 0.5))
	,((modm .|. controlMask .|. shiftMask, xK_e), shiftPrevScreen >> prevScreen >>  updatePointer (Relative 0.5 0.5))
	,((modm .|. controlMask, xK_Up), nextScreen >>  updatePointer (Relative 0.5 0.5))
	,((modm .|. controlMask, xK_Down), prevScreen >>  updatePointer (Relative 0.5 0.5))
    ,((modm .|. controlMask, xK_Left), nextScreen >>  updatePointer (Relative 0.5 0.5))
    ,((modm .|. controlMask, xK_Right), prevScreen >>  updatePointer (Relative 0.5 0.5))
	,((modm .|. controlMask .|. shiftMask, xK_Up), shiftNextScreen >> nextScreen >>  updatePointer (Relative 0.5 0.5))
	,((modm .|. controlMask .|. shiftMask, xK_Down), shiftPrevScreen >> prevScreen >>  updatePointer (Relative 0.5 0.5))
    ,((modm .|. controlMask .|. shiftMask, xK_Left), shiftNextScreen >> nextScreen >>  updatePointer (Relative 0.5 0.5))
    ,((modm .|. controlMask .|. shiftMask, xK_Right), shiftPrevScreen >> prevScreen >>  updatePointer (Relative 0.5 0.5))

  	,((modm, xK_v), goToSelected defaultGSConfig{ gs_cellheight = 80, gs_cellwidth = 250 })

	--thunar
	,((modm,xK_a),spawn "thunar")
	--gpk-application
	,((modm,xK_z),spawn "software-center")

	--rhythmbox
	,((modm,xK_m),spawn "rhythmbox")

	--broffice
	,((modm,xK_b),spawn "/opt/libreoffice/program/soffice")

	--gnome-calculator
	,((modm,xK_c),spawn "gnome-calculator")

	--gnome-control-center
	,((modm .|. shiftMask, xK_z),spawn "gnome-control-center")

	--lock screen
	,((modm, xK_Escape),spawn "gnome-screensaver-command -l")

	, ((modm .|. mod1Mask, xK_Return), shellPrompt defaultXPConfig{position=Top})

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
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_b, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


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
	,((modm, button5), (\_ -> moveTo Next NonEmptyWS))
	,((modm, button4), (\_ -> moveTo Prev NonEmptyWS))
    ]


------------------------------------------------------------------------
-- Layouts:
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--myLayout = tiled ||| Mirror tiled ||| Full

myLayout = smartBorders $ simpleTabbed ||| TwoPane delta ratio ||| mybook
--	   onWorkspace "chrome" simpleTabbed $
--	   onWorkspaces ["1","2","emacs"] (Full ||| TwoPane delta ratio) $
--	   onWorkspace "gimp" (withIM(0.18)(Role "gimp-toolbox")tiled ||| withIM(0.18)(Role "gimp-toolbox")Full)
--	   onWorkspace "blender" (tiled ||| Full) $
--	   Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     mybook  = ThreeColMid nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100


------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [className =? "MPlayer"        --> doFloat
    , className =? "Rhythmbox"      --> doShift "9"
    , className =? "Totem"          --> doShift "8"
    , className =? "Gimp"           --> doShift "7"
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
--myEventHook = mempty
myEventHook = fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = dynamicLogWithPP dzenPP

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
	spawn "xmodmap ~/.xmodmap"
	-- spawn "setxkbmap -model abnt2 -layout br -variant ,a"
	spawn "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &"
	spawn "feh --bg-scale ~/Pictures/Black.jpg"
        spawn "xsetroot -cursor_name left_ptr"
	-- spawn "perl /home/fernandomn/.xmonad/mydzen.pl | dzen2 -h 15 -bg lightgray -p 1 -e 'key_Menu=togglehide'"
	spawn "gnome-settings-daemon"
	--spawn "gwibber-service"
	setWMName "LG3D"


--return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--

main = xmonad $ ewmh defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
       -- numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

