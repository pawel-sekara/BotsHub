#include-once
#include '../../lib/GWA2_ID_Maps.au3'
#include '../../lib/GWA2_ID.au3'
#include '../../lib/GWA2.au3'
#include '../../lib/Utils-Agents.au3'
#include '../../lib/Utils-Console.au3'
#include '../../lib/Utils-Storage.au3'
#include '../../lib/Utils.au3'

; ==== Constants ====
Global Const $NORN_BOREAL_FARM_INFORMATIONS = 'Ice Cliff Chasms vanquish starting from Eye of the North, bring solid heroes composition'
; Unverified estimate - route recorded by hand, adjust after the first runs
Global Const $NORN_BOREAL_FARM_DURATION = 60 * 60 * 1000

Global $norn_boreal_farm_setup = False


Func NornBorealFarm()
	If Not $norn_boreal_farm_setup Then NornBorealFarmSetup()

	If GoToIceCliffChasms() == $FAIL Then Return $PAUSE
	AdlibRegister('TrackPartyStatus', 10000)
	Local $result = VanquishIceCliffChasms()
	AdlibUnRegister('TrackPartyStatus')
	Return $result
EndFunc


Func NornBorealFarmSetup()
	Info('Setting up farm')
	TravelToOutpost($ID_EYE_OF_THE_NORTH, $district_name)
	SetDisplayedTitle($ID_NORN_TITLE)
	SwitchMode($ID_HARD_MODE)
	$norn_boreal_farm_setup = True
	Info('Preparations complete')
	Return $SUCCESS
EndFunc


Func GoToIceCliffChasms()
	TravelToOutpost($ID_EYE_OF_THE_NORTH, $district_name)
	For $attempt = 1 To 3
		Info('Moving to Ice Cliff Chasms')
		MoveTo(692, 1123)
		; The portal is right past (692, 1123) towards +X/-Y - aim beyond it so the character walks into it
		Move(1192, 623)
		RandomSleep(1000)
		WaitMapLoading($ID_ICE_CLIFF_CHASMS, 10000, 2000)
		If GetMapID() == $ID_ICE_CLIFF_CHASMS Then Return $SUCCESS
	Next
	Error('Could not leave Eye of the North to Ice Cliff Chasms')
	Return $FAIL
EndFunc


Func VanquishIceCliffChasms()
	If GetMapID() <> $ID_ICE_CLIFF_CHASMS Then Return $FAIL

	If IsHardmodeEnabled() Then UseConset()
	UseSummoningStone()
	; Recorded route (RouteRecorder, map 499), 'Marked point' entries are spots marked by hand during the recording
	Local Static $foes[][] = [ _
		[2233,	77,	'Moving'	], _
		[1823,	-1156,	'Moving'	], _
		[2353,	32,	'Moving'	], _
		[2686,	1208,	'Moving'	], _
		[2931,	2502,	'Marked point'	], _
		[2801,	3699,	'Moving'	], _
		[2533,	4920,	'Moving'	], _
		[2496,	5170,	'Marked point'	], _
		[3702,	5105,	'Moving'	], _
		_ ; blessing
		[2658,	5788,	'Group'	], _
		[1424,	6170,	'Moving'	], _
		[1174,	6377,	'Marked point'	], _
		[143,	7167,	'Moving'	], _
		[-935,	7867,	'Moving'	], _
		[-1853,	8764,	'Moving'	], _
		[-2874,	9559,	'Group'	], _
		[-3359,	9925,	'Marked point'	], _
		[-4488,	10530,	'Moving'	], _
		[-5376,	11458,	'Moving'	], _
		[-6126,	12450,	'Moving'	], _
		[-7059,	13333,	'Group'	], _
		[-7513,	13771,	'Group'	], _
		[-7681,	14122,	'Marked point'	], _
		[-7415,	15328,	'Moving'	], _
		[-6831,	16450,	'Moving'	], _
		[-6068,	17287,	'Group'	], _
		[-5867,	18471,	'Moving'	], _
		[-6361,	19586,	'Group'	], _
		[-6697,	20788,	'Moving'	], _
		[-7005,	22029,	'Moving'	], _
		[-7291,	23209,	'Moving'	], _
		[-6819,	24381,	'Moving'	], _
		[-6103,	24544,	'Marked point'	], _
		[-5015,	24536,	'Group'	], _
		[-3772,	24598,	'Moving'	], _
		[-2797,	23838,	'Moving'	], _
		_ ; blessing
		[-1799,	22997,	'Moving'	], _
		[-941,	22035,	'Group'	], _
		[-832,	21492,	'Group'	], _
		[-586,	21461,	'Marked point'	], _
		[469,	20804,	'Moving'	], _
		[1594,	21382,	'Moving'	], _
		[2542,	22274,	'Moving'	], _
		[3568,	23071,	'Moving'	], _
		[4676,	23736,	'Group'	], _
		[5001,	22736,	'Group'	], _
		[6194,	22438,	'Group'	], _
		[6864,	22464,	'Group'	], _
		[8090,	22775,	'Moving'	], _
		[9052,	23252,	'Group'	], _
		[9617,	24316,	'Moving'	], _
		[10270,	25295,	'Group'	], _
		_ ; blessing
		[9926,	24045,	'Moving'	], _
		[9776,	22757,	'Moving'	], _
		[9535,	21823,	'Group'	], _
		[9796,	21024,	'Group'	], _
		[8758,	20269,	'Moving'	], _
		[7742,	19484,	'Marked point'	], _
		[7265,	18351,	'Moving'	], _
		[7741,	17649,	'Marked point'	], _
		[7224,	16534,	'Moving'	], _
		[7095,	15904,	'Marked point'	], _
		[6919,	14615,	'Moving'	], _
		[6502,	13415,	'Moving'	], _
		[5742,	12365,	'Group'	], _
		_ ; blessing
		[4568,	11793,	'Moving'	], _
		[3285,	11603,	'Moving'	], _
		[2002,	11627,	'Moving'	], _
		[1065,	12247,	'Marked point'	], _
		[1185,	13508,	'Moving'	], _
		[1067,	14703,	'Moving'	], _
		[916,	15951,	'Moving'	], _
		[759,	16906,	'Marked point'	], _
		[962,	15644,	'Moving'	], _
		[1056,	14352,	'Moving'	], _
		[1078,	13084,	'Moving'	], _
		[848,	11793,	'Moving'	], _
		[553,	10570,	'Moving'	], _
		[400,	9391,	'Marked point'	], _
		[1108,	8351,	'Moving'	], _
		[2191,	7645,	'Moving'	], _
		[3418,	7303,	'Moving'	], _
		[4570,	7045,	'Marked point'	], _
		[5849,	6820,	'Moving'	], _
		[6859,	6641,	'Marked point'	], _
		[7498,	7714,	'Moving'	], _
		[8166,	8829,	'Moving'	], _
		[8299,	9123,	'Marked point'	], _
		[8123,	10397,	'Moving'	], _
		[7899,	11677,	'Moving'	], _
		[7878,	11862,	'Marked point'	], _
		[8108,	10695,	'Moving'	], _
		[8172,	9417,	'Moving'	], _
		[7882,	8168,	'Moving'	], _
		[7316,	7012,	'Moving'	], _
		[6804,	5827,	'Moving'	], _
		[6438,	4592,	'Moving'	], _
		[6308,	4065,	'Marked point'	], _
		[6963,	2968,	'Moving'	], _
		[7622,	1941,	'Moving'	], _
		[8541,	1078,	'Moving'	], _
		[8968,	203,	'Group'	], _
		[9215,	-1045,	'Moving'	], _
		[8851,	-1830,	'Marked point'	], _
		[8139,	-821,	'Moving'	], _
		[6912,	-521,	'Moving'	], _
		[6613,	-581,	'Marked point'	], _
		[5334,	-995,	'Moving'	], _
		[4187,	-1397,	'Moving'	], _
		[3064,	-1847,	'Moving'	], _
		[1995,	-2421,	'Moving'	], _
		[1183,	-3122,	'Marked point'	], _
		[695,	-4318,	'Moving'	], _
		[247,	-5519,	'Moving'	], _
		[-12,	-6342,	'Marked point'	], _
		[-245,	-6219,	'Marked point'	], _
		[-952,	-5148,	'Moving'	], _
		[-1636,	-4042,	'Moving'	], _
		[-2520,	-3098,	'Marked point'	], _
		[-3644,	-2462,	'Moving'	], _
		[-4804,	-1878,	'Moving'	], _
		[-5194,	-1684,	'Marked point'	], _
		[-5761,	-1188,	'Group'	], _
		[-6469,	-634,	'Group'	], _
		[-7386,	238,	'Moving'	], _
		[-8004,	675,	'Marked point'	], _
		[-8289,	-581,	'Moving'	], _
		[-7846,	-1774,	'Group'	], _
		_ ; blessing
		[-6953,	-2594,	'Moving'	], _
		[-5723,	-2940,	'Moving'	], _
		[-4482,	-3272,	'Moving'	], _
		[-3211,	-3314,	'Moving'	], _
		[-1992,	-3701,	'Moving'	], _
		[-1414,	-4339,	'Marked point'	], _
		[-679,	-5378,	'Moving'	], _
		[513,	-5816,	'Moving'	], _
		[1732,	-6135,	'Moving'	], _
		[2644,	-6480,	'Marked point'	], _
		[3846,	-6941,	'Moving'	], _
		[5136,	-6910,	'Moving'	], _
		[6098,	-6763,	'Marked point'	], _
		[7374,	-6550,	'Group'	], _
		[8643,	-6269,	'Moving'	], _
		[9917,	-6006,	'Moving'	], _
		[10542,	-5846,	'Marked point'	], _
		[9419,	-6471,	'Moving'	], _
		[8581,	-7457,	'Moving'	], _
		[7835,	-8521,	'Moving'	], _
		_ ; blessing
		[7231,	-9647,	'Moving'	], _
		[7395,	-10873,	'Moving'	], _
		[7574,	-11418,	'Group'	], _
		[7953,	-12477,	'Marked point'	], _
		[8899,	-12775,	'Group'	], _
		[7656,	-12724,	'Moving'	], _
		[6399,	-12762,	'Moving'	], _
		[5790,	-12908,	'Marked point'	], _
		[5554,	-13707,	'Group'	], _
		[6031,	-14903,	'Moving'	], _
		[6165,	-15327,	'Marked point'	], _
		[4967,	-15637,	'Moving'	], _
		[3680,	-15719,	'Moving'	], _
		[2462,	-15546,	'Moving'	], _
		_ ; blessing
		[1485,	-14734,	'Moving'	], _
		[679,	-14432,	'Group'	], _
		[160,	-14282,	'Marked point'	], _
		[-727,	-13388,	'Moving'	], _
		[-1769,	-12646,	'Moving'	], _
		[-2442,	-12171,	'Group'	], _
		[-3384,	-11394,	'Group'	], _
		[-4012,	-10925,	'Group'	], _
		[-4420,	-10679,	'Marked point'	], _
		[-5409,	-11446,	'Moving'	], _
		[-5586,	-12670,	'Moving'	], _
		[-5439,	-13924,	'Moving'	], _
		[-5439,	-14196,	'Marked point'	], _
		[-5448,	-15490,	'Moving'	], _
		[-4890,	-16567,	'Moving'	], _
		[-3900,	-17562,	'Moving'	], _
		[-2802,	-17648,	'Marked point'	], _
		[-3209,	-16461,	'Moving'	], _
		[-4018,	-15753,	'Marked point'	] _
	]

	If ClearVanquishSection($foes, 0, 8, $NORN_BOREAL_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(3913, 5035))
	Sleep(1000)
	Dialog(0x84)
	Sleep(1000)

	If ClearVanquishSection($foes, 9, 35, $NORN_BOREAL_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(-2469, 23809))
	Sleep(1000)

	If ClearVanquishSection($foes, 36, 51, $NORN_BOREAL_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(10313, 25359))
	Sleep(1000)

	If ClearVanquishSection($foes, 52, 64, $NORN_BOREAL_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(5389, 11922))
	Sleep(1000)

	If ClearVanquishSection($foes, 65, 127, $NORN_BOREAL_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(-7659, -2221))
	Sleep(1000)

	If ClearVanquishSection($foes, 128, 147, $NORN_BOREAL_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(7174, -9465))
	Sleep(1000)

	If ClearVanquishSection($foes, 148, 161, $NORN_BOREAL_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(2401, -15537))
	Sleep(1000)

	If ClearVanquishSection($foes, 162, 180, $NORN_BOREAL_FARM_DURATION) == $FAIL Then Return $FAIL

	If HuntVanquishLeftovers($foes, $NORN_BOREAL_FARM_DURATION) == $FAIL Then Return $FAIL

	If Not GetAreaVanquished() Then
		Error('The map has not been completely vanquished.')
		Return $FAIL
	EndIf
	Info('Map has been fully vanquished.')
	Return $SUCCESS
EndFunc
