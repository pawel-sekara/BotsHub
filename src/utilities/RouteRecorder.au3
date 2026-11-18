#include-once
#include '../../lib/GWA2_ID_Maps.au3'
#include '../../lib/GWA2_ID.au3'
#include '../../lib/GWA2.au3'
#include '../../lib/Utils-Agents.au3'
#include '../../lib/Utils-Console.au3'
#include '../../lib/Utils.au3'

Global Const $ROUTE_RECORDER_INFORMATIONS = 'Records a vanquish route while you play it manually in an explorable area.' & @CRLF _
	& 'Route points are added as you walk, and kills mark the spot as a group.' & @CRLF _
	& 'F8 - sweep the compass here (ends the section), F9 - mark current position, F10 - blessing (talk only), F11 - blessing with the accept button (Dialog 0x84).' & @CRLF _
	& 'Recording stops on bot stop or map change, output goes to logs/route-<mapID>.au3'

Global Const $ROUTE_RECORDER_POINT_SPACING = 1200
Global Const $ROUTE_RECORDER_GROUP_SPACING = 500
Global Const $ROUTE_RECORDER_SWEEP_TIMEOUT_CODE = '3 * 60 * 1000'

Global $route_recorder_points[0][3]
; [index of the first route point after the blessing, NPC x, NPC y, needs accept dialog]
Global $route_recorder_blessings[0][4]
; Indexes of route points that end a section with a compass sweep
Global $route_recorder_sweeps[0]
; Hotkey callbacks only leave a request - the main loop reads game memory and records
Global $route_recorder_request = ''

Func RouteRecorderFarm()
	If GetMapType() <> $ID_EXPLORABLE Then
		Warn('Route recorder needs an explorable area - go to the map you want to record first')
		Return $PAUSE
	EndIf
	Local $mapID = GetMapID()
	Local $noPoints[0][3], $noBlessings[0][4], $noSweeps[0]
	$route_recorder_points = $noPoints
	$route_recorder_blessings = $noBlessings
	$route_recorder_sweeps = $noSweeps
	HotKeySet('{F8}', 'RouteRecorderMarkSweep')
	HotKeySet('{F9}', 'RouteRecorderMarkPoint')
	HotKeySet('{F10}', 'RouteRecorderMarkBlessing')
	HotKeySet('{F11}', 'RouteRecorderMarkBlessingWithAccept')
	Info('Recording route in map ' & $mapID & ' - F8 sweep, F9 point, F10 blessing, F11 blessing with accept')

	Local $foesLeft = GetFoesToKill(), $currentFoesLeft, $me, $x, $y, $changed
	While $runtime_status == 'RUNNING' And GetMapID() == $mapID
		$me = GetMyAgent()
		$x = Round(DllStructGetData($me, 'X'))
		$y = Round(DllStructGetData($me, 'Y'))
		$changed = True
		$currentFoesLeft = GetFoesToKill()
		If $route_recorder_request == 'point' Then
			AddRecordedRoutePoint($x, $y, 'Marked point')
		ElseIf $route_recorder_request == 'sweep' Then
			RecordSweep($x, $y)
		ElseIf $route_recorder_request <> '' Then
			RecordBlessing($me, $route_recorder_request == 'blessing-accept')
		ElseIf $currentFoesLeft < $foesLeft Then
			RecordGroup($x, $y)
		ElseIf DistanceToLastRecordedPoint($x, $y) > $ROUTE_RECORDER_POINT_SPACING Then
			AddRecordedRoutePoint($x, $y, 'Moving')
		Else
			$changed = False
		EndIf
		$route_recorder_request = ''
		$foesLeft = $currentFoesLeft
		If $changed Then WriteRecordedRoute($mapID)
		Sleep(300)
	WEnd

	HotKeySet('{F8}')
	HotKeySet('{F9}')
	HotKeySet('{F10}')
	HotKeySet('{F11}')
	WriteRecordedRoute($mapID)
	Info('Route recording finished: ' & UBound($route_recorder_points) & ' points, ' & UBound($route_recorder_blessings) & ' blessings, ' & UBound($route_recorder_sweeps) & ' sweeps')
	Return $PAUSE
EndFunc


Func RouteRecorderMarkSweep()
	$route_recorder_request = 'sweep'
EndFunc


Func RouteRecorderMarkPoint()
	$route_recorder_request = 'point'
EndFunc


Func RouteRecorderMarkBlessing()
	$route_recorder_request = 'blessing'
EndFunc


Func RouteRecorderMarkBlessingWithAccept()
	$route_recorder_request = 'blessing-accept'
EndFunc


Func AddRecordedRoutePoint($x, $y, $label)
	Local $count = UBound($route_recorder_points)
	ReDim $route_recorder_points[$count + 1][3]
	$route_recorder_points[$count][0] = $x
	$route_recorder_points[$count][1] = $y
	$route_recorder_points[$count][2] = $label
	Info('Recorded point ' & $count & ': ' & $x & ', ' & $y & ' ' & $label)
EndFunc


;~ Every kill of a group lowers the foe counter - only the first kill near a spot adds a point
Func RecordGroup($x, $y)
	Local $last = UBound($route_recorder_points) - 1
	If $last >= 0 And DistanceToLastRecordedPoint($x, $y) <= $ROUTE_RECORDER_GROUP_SPACING Then
		If $route_recorder_points[$last][2] == 'Moving' Then $route_recorder_points[$last][2] = 'Group'
		Return
	EndIf
	AddRecordedRoutePoint($x, $y, 'Group')
EndFunc


;~ The talked-to NPC stays targeted, so the target is preferred over the nearest NPC
Func RecordBlessing($me, $withAccept)
	Local $npc = GetCurrentTarget()
	If $npc == Null Or Not NPCAgentFilter($npc) Then $npc = GetNearestNPCToAgent($me, $RANGE_SPELLCAST)
	If $npc == Null Then
		Warn('No NPC found near you - target the blessing NPC and press the key again')
		Return
	EndIf
	Local $count = UBound($route_recorder_blessings)
	ReDim $route_recorder_blessings[$count + 1][4]
	$route_recorder_blessings[$count][0] = UBound($route_recorder_points)
	$route_recorder_blessings[$count][1] = Round(DllStructGetData($npc, 'X'))
	$route_recorder_blessings[$count][2] = Round(DllStructGetData($npc, 'Y'))
	$route_recorder_blessings[$count][3] = $withAccept
	Info('Recorded blessing NPC at ' & $route_recorder_blessings[$count][1] & ', ' & $route_recorder_blessings[$count][2] & ($withAccept ? ' with accept' : ''))
EndFunc


Func RecordSweep($x, $y)
	AddRecordedRoutePoint($x, $y, 'Sweep')
	Local $count = UBound($route_recorder_sweeps)
	ReDim $route_recorder_sweeps[$count + 1]
	$route_recorder_sweeps[$count] = UBound($route_recorder_points) - 1
EndFunc


Func DistanceToLastRecordedPoint($x, $y)
	Local $last = UBound($route_recorder_points) - 1
	If $last < 0 Then Return 999999
	Return Sqrt(($x - $route_recorder_points[$last][0]) ^ 2 + ($y - $route_recorder_points[$last][1]) ^ 2)
EndFunc


;~ Output is meant to be pasted into a vanquish function body - same layout as Vanguard.au3
Func WriteRecordedRoute($mapID)
	Local $pointCount = UBound($route_recorder_points)
	Local $code = '; Recorded in map ' & $mapID & @CRLF & 'Local Static $foes[][] = [ _' & @CRLF
	For $i = 0 To $pointCount - 1
		$code &= @TAB & '[' & $route_recorder_points[$i][0] & ',' & @TAB & $route_recorder_points[$i][1] & ',' & @TAB _
			& "'" & $route_recorder_points[$i][2] & "'" & ']' & ($i < $pointCount - 1 ? ', _' : ' _') & @CRLF
	Next
	$code &= ']' & @CRLF & @CRLF

	; A section ends before a blessing, after a sweep point, and at the end of the route
	Local $sectionStart = 0, $blessing = 0, $sweep = 0, $endsWithSweep
	For $next = 0 To $pointCount
		$endsWithSweep = $sweep < UBound($route_recorder_sweeps) And $route_recorder_sweeps[$sweep] == $next - 1
		If $endsWithSweep Then $sweep += 1
		If Not $endsWithSweep And $next < $pointCount And Not ($blessing < UBound($route_recorder_blessings) And $route_recorder_blessings[$blessing][0] == $next) Then ContinueLoop
		$code &= RecordedSectionCode($sectionStart, $next - 1, $endsWithSweep)
		$sectionStart = $next
		While $blessing < UBound($route_recorder_blessings) And $route_recorder_blessings[$blessing][0] == $next
			$code &= "Info('Taking Blessing')" & @CRLF _
				& 'GoToNPC(GetNearestNPCToCoords(' & $route_recorder_blessings[$blessing][1] & ', ' & $route_recorder_blessings[$blessing][2] & '))' & @CRLF _
				& 'Sleep(1000)' & @CRLF
			If $route_recorder_blessings[$blessing][3] Then $code &= 'Dialog(0x84)' & @CRLF & 'Sleep(1000)' & @CRLF
			$code &= @CRLF
			$blessing += 1
		WEnd
	Next
	$code &= 'If HuntVanquishLeftovers($foes, $FARM_DURATION) == $FAIL Then Return $FAIL' & @CRLF

	Local $file = FileOpen(@ScriptDir & '/logs/route-' & $mapID & '.au3', $FO_OVERWRITE + $FO_CREATEPATH + $FO_UTF8)
	If $file == -1 Then
		Warn('Could not write the recorded route to logs/route-' & $mapID & '.au3')
		Return
	EndIf
	FileWrite($file, $code)
	FileClose($file)
EndFunc


Func RecordedSectionCode($first, $last, $withSweep)
	If $last < $first Then Return ''
	Return 'If ClearVanquishSection($foes, ' & $first & ', ' & $last & ', $FARM_DURATION' & ($withSweep ? ', ' & $ROUTE_RECORDER_SWEEP_TIMEOUT_CODE : '') _
		& ') == $FAIL Then Return $FAIL' & @CRLF & @CRLF
EndFunc
