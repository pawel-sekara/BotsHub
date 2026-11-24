#include-once
#include '../../lib/GWA2_ID_Maps.au3'
#include '../../lib/GWA2_ID.au3'
#include '../../lib/GWA2.au3'
#include '../../lib/Utils-Agents.au3'
#include '../../lib/Utils-Console.au3'
#include '../../lib/Utils-Storage.au3'
#include '../../lib/Utils.au3'

; ==== Constants ====
Global Const $NORN_DRAKKAR_FARM_INFORMATIONS = 'Drakkar Lake vanquish starting from Sifhalla, bring solid heroes composition'
; Unverified estimate - route recorded by hand, adjust after the first runs
Global Const $NORN_DRAKKAR_FARM_DURATION = 70 * 60 * 1000

Global $norn_drakkar_farm_setup = False


Func NornDrakkarFarm()
	If Not $norn_drakkar_farm_setup Then NornDrakkarFarmSetup()

	If GoToDrakkarLake() == $FAIL Then Return $PAUSE
	AdlibRegister('TrackPartyStatus', 10000)
	Local $result = VanquishDrakkarLake()
	AdlibUnRegister('TrackPartyStatus')
	Return $result
EndFunc


Func NornDrakkarFarmSetup()
	Info('Setting up farm')
	TravelToOutpost($ID_SIFHALLA, $district_name)
	SetDisplayedTitle($ID_NORN_TITLE)
	SwitchMode($ID_HARD_MODE)
	$norn_drakkar_farm_setup = True
	Info('Preparations complete')
	Return $SUCCESS
EndFunc


Func GoToDrakkarLake()
	TravelToOutpost($ID_SIFHALLA, $district_name)
	For $attempt = 1 To 3
		Info('Moving to Drakkar Lake')
		MoveTo(10218, 23823)
		; The portal is right past (10218, 23823) towards -X - aim beyond it so the character walks into it
		Move(9600, 23810)
		RandomSleep(1000)
		WaitMapLoading($ID_DRAKKAR_LAKE, 10000, 2000)
		If GetMapID() == $ID_DRAKKAR_LAKE Then Return $SUCCESS
	Next
	Error('Could not leave Sifhalla to Drakkar Lake')
	Return $FAIL
EndFunc


Func VanquishDrakkarLake()
	If GetMapID() <> $ID_DRAKKAR_LAKE Then Return $FAIL

	If IsHardmodeEnabled() Then UseConset()
	UseSummoningStone()
	; Recorded route (RouteRecorder, map 513)
	Local Static $foes[][] = [ _
		[8872,	23295,	'Moving'	], _
		[7688,	23506,	'Moving'	], _
		[6428,	23225,	'Moving'	], _
		[5193,	22893,	'Moving'	], _
		[3978,	22462,	'Moving'	], _
		[3261,	21983,	'Group'	], _
		[2142,	22557,	'Moving'	], _
		[1051,	23234,	'Moving'	], _
		[-179,	23630,	'Moving'	], _
		[-952,	23863,	'Group'	], _
		[-2224,	23904,	'Moving'	], _
		[-3476,	23984,	'Group'	], _
		[-4648,	23451,	'Moving'	], _
		[-5903,	23550,	'Moving'	], _
		[-6987,	22984,	'Moving'	], _
		[-7503,	22544,	'Group'	], _
		[-8670,	23033,	'Moving'	], _
		[-9212,	23278,	'Sweep'	], _
		[-8596,	24425,	'Group'	], _
		[-9441,	23475,	'Moving'	], _
		[-9941,	22545,	'Group'	], _
		[-10092,	21987,	'Sweep'	], _
		[-9180,	21164,	'Group'	], _
		[-8552,	20049,	'Moving'	], _
		[-9277,	18989,	'Moving'	], _
		[-10034,	17939,	'Group'	], _
		[-10537,	16807,	'Moving'	], _
		[-10273,	15552,	'Moving'	], _
		[-9952,	14317,	'Moving'	], _
		[-9654,	13058,	'Moving'	], _
		[-9374,	11966,	'Group'	], _
		[-8998,	10761,	'Moving'	], _
		[-8166,	9810,	'Moving'	], _
		[-7008,	9270,	'Moving'	], _
		[-6446,	8341,	'Group'	], _
		[-7467,	7593,	'Moving'	], _
		[-8537,	7872,	'Group'	], _
		[-9124,	6955,	'Group'	], _
		[-9364,	5692,	'Moving'	], _
		[-9516,	5106,	'Group'	], _
		[-9567,	3870,	'Group'	], _
		[-9428,	3311,	'Group'	], _
		[-10193,	2366,	'Group'	], _
		[-10826,	1884,	'Group'	], _
		[-11303,	1723,	'Group'	], _
		[-12125,	813,	'Group'	], _
		[-12539,	2054,	'Moving'	], _
		[-12673,	3126,	'Group'	], _
		[-12121,	2035,	'Moving'	], _
		[-10839,	2044,	'Moving'	], _
		[-9823,	2808,	'Moving'	], _
		[-9577,	4074,	'Moving'	], _
		[-9435,	5354,	'Moving'	], _
		[-9168,	6610,	'Moving'	], _
		[-8871,	7799,	'Moving'	], _
		[-7618,	7702,	'Moving'	], _
		[-6450,	8057,	'Moving'	], _
		[-5789,	9105,	'Moving'	], _
		[-4899,	10046,	'Moving'	], _
		[-4079,	10955,	'Moving'	], _
		[-3472,	11866,	'Group'	], _
		[-4115,	12909,	'Moving'	], _
		[-4618,	14007,	'Group'	], _
		[-5120,	15186,	'Group'	], _
		[-3852,	14861,	'Moving'	], _
		[-3167,	14769,	'Group'	], _
		[-1910,	14880,	'Moving'	], _
		[-955,	14924,	'Group'	], _
		[211,	15371,	'Moving'	], _
		[1452,	15696,	'Group'	], _
		[2383,	16060,	'Group'	], _
		[3654,	16040,	'Moving'	], _
		[4642,	15721,	'Sweep'	], _
		[4714,	14510,	'Moving'	], _
		[5299,	13364,	'Group'	], _
		[4987,	12204,	'Moving'	], _
		[3853,	11687,	'Moving'	], _
		[2574,	11611,	'Moving'	], _
		[1402,	11279,	'Moving'	], _
		[894,	10375,	'Group'	], _
		[1554,	11482,	'Moving'	], _
		[2865,	11643,	'Moving'	], _
		[4164,	11810,	'Moving'	], _
		[5070,	12723,	'Moving'	], _
		[4890,	13983,	'Moving'	], _
		[4447,	15187,	'Moving'	], _
		[5669,	15438,	'Moving'	], _
		[6814,	14828,	'Moving'	], _
		[7994,	14290,	'Moving'	], _
		[9184,	14047,	'Moving'	], _
		[10403,	14249,	'Group'	], _
		[11252,	13343,	'Moving'	], _
		[12084,	12374,	'Moving'	], _
		[12331,	11160,	'Moving'	], _
		[12000,	9984,	'Group'	], _
		[11629,	8842,	'Moving'	], _
		[10951,	7818,	'Moving'	], _
		[11273,	7160,	'Group'	], _
		[12454,	7474,	'Moving'	], _
		[13500,	8224,	'Moving'	], _
		[14156,	9312,	'Moving'	], _
		[14324,	10562,	'Moving'	], _
		[14267,	11836,	'Moving'	], _
		[14108,	13120,	'Moving'	], _
		[13553,	14288,	'Moving'	], _
		[12995,	15461,	'Moving'	], _
		[12440,	16629,	'Moving'	], _
		[13051,	15500,	'Moving'	], _
		[13589,	14414,	'Moving'	], _
		[14150,	13236,	'Moving'	], _
		[14376,	11989,	'Moving'	], _
		[14327,	10690,	'Moving'	], _
		[14268,	9400,	'Moving'	], _
		[14171,	8110,	'Moving'	], _
		[14077,	6828,	'Moving'	], _
		[14044,	5552,	'Moving'	], _
		[14127,	4301,	'Moving'	], _
		[14367,	3046,	'Moving'	], _
		[13191,	2568,	'Moving'	], _
		[11940,	2663,	'Group'	], _
		[11677,	2228,	'Group'	], _
		[10994,	1708,	'Sweep'	], _
		[11071,	471,	'Moving'	], _
		[10739,	-350,	'Group'	], _
		[9497,	-368,	'Group'	], _
		[8496,	-311,	'Group'	], _
		[9012,	-334,	'Group'	], _
		[8601,	905,	'Moving'	], _
		[8160,	2049,	'Moving'	], _
		[7321,	2960,	'Moving'	], _
		[6073,	3277,	'Group'	], _
		[5995,	4486,	'Moving'	], _
		[6429,	5710,	'Moving'	], _
		[6862,	6933,	'Moving'	], _
		[7094,	8155,	'Moving'	], _
		[6099,	7345,	'Moving'	], _
		[5186,	6430,	'Moving'	], _
		[4350,	5591,	'Group'	], _
		[5063,	6631,	'Moving'	], _
		[5894,	7630,	'Moving'	], _
		[6934,	8326,	'Moving'	], _
		[7178,	7131,	'Moving'	], _
		[6615,	5962,	'Moving'	], _
		[6226,	4810,	'Moving'	], _
		[6334,	3545,	'Moving'	], _
		[6416,	2349,	'Group'	], _
		[6482,	1687,	'Group'	], _
		[5782,	618,	'Moving'	], _
		[4554,	324,	'Moving'	], _
		[3737,	-171,	'Group'	], _
		[3228,	-24,	'Group'	], _
		[2365,	816,	'Moving'	], _
		[1495,	1777,	'Group'	], _
		[800,	2450,	'Moving'	], _
		[200,	3000,	'Group'	], _
		[1495,	1777,	'Moving'	], _
		[767,	780,	'Moving'	], _
		[268,	-402,	'Group'	], _
		[-113,	-1628,	'Moving'	], _
		[-202,	-2150,	'Group'	], _
		[-46,	-1836,	'Sweep'	], _
		[1174,	-2291,	'Moving'	], _
		[2408,	-2558,	'Group'	], _
		[3679,	-2801,	'Moving'	], _
		[4935,	-2922,	'Group'	], _
		[6215,	-3008,	'Moving'	], _
		[7463,	-3279,	'Group'	], _
		[7502,	-3325,	'Sweep'	], _
		[7507,	-2795,	'Group'	], _
		[6612,	-2762,	'Group'	], _
		[5662,	-3608,	'Moving'	], _
		[5133,	-3965,	'Group'	], _
		[6156,	-3231,	'Moving'	], _
		[7091,	-2330,	'Moving'	], _
		[6835,	-1150,	'Moving'	], _
		[6836,	-1149,	'Sweep'	], _
		[6101,	-2173,	'Moving'	], _
		[5265,	-3041,	'Moving'	], _
		[4484,	-4014,	'Group'	], _
		[5402,	-4833,	'Moving'	], _
		[6299,	-5786,	'Group'	], _
		[5656,	-5583,	'Group'	], _
		[4503,	-5921,	'Moving'	], _
		[3319,	-6183,	'Group'	], _
		[2328,	-7015,	'Moving'	], _
		[1390,	-7895,	'Moving'	], _
		[1328,	-7954,	'Sweep'	], _
		[1942,	-8458,	'Group'	], _
		[1180,	-9511,	'Group'	], _
		[150,	-8845,	'Moving'	], _
		[-382,	-8302,	'Group'	], _
		[777,	-8929,	'Moving'	], _
		[1926,	-9296,	'Moving'	], _
		[3224,	-9379,	'Moving'	], _
		[4349,	-9869,	'Moving'	], _
		[4822,	-10379,	'Group'	], _
		[4822,	-10379,	'Sweep'	], _
		[5842,	-9766,	'Group'	], _
		[7019,	-9459,	'Moving'	], _
		[7871,	-10415,	'Moving'	], _
		[8296,	-10985,	'Group'	], _
		[9249,	-10672,	'Sweep'	], _
		[10179,	-9787,	'Moving'	], _
		[10597,	-8626,	'Moving'	], _
		[10985,	-7390,	'Moving'	], _
		[11390,	-6524,	'Group'	], _
		[11640,	-5251,	'Moving'	], _
		[12305,	-4213,	'Moving'	], _
		[13386,	-3476,	'Moving'	], _
		[14010,	-3050,	'Group'	], _
		[13047,	-3807,	'Moving'	], _
		[11923,	-4381,	'Moving'	], _
		[12935,	-3668,	'Moving'	], _
		[13198,	-3484,	'Sweep'	], _
		[12158,	-4183,	'Moving'	], _
		[11574,	-5281,	'Moving'	], _
		[11614,	-6539,	'Moving'	], _
		[11717,	-7828,	'Moving'	], _
		[12011,	-9083,	'Moving'	], _
		[12218,	-10321,	'Moving'	], _
		[12279,	-11354,	'Group'	], _
		[12298,	-11972,	'Group'	], _
		[12099,	-13164,	'Moving'	], _
		[11823,	-14409,	'Moving'	], _
		[11482,	-15612,	'Moving'	], _
		[10321,	-16176,	'Moving'	], _
		[10150,	-16360,	'Sweep'	], _
		[10890,	-16563,	'Group'	], _
		[11737,	-16912,	'Group'	], _
		[12994,	-16960,	'Moving'	], _
		[13855,	-17024,	'Group'	], _
		[14827,	-17097,	'Group'	], _
		[13555,	-17339,	'Moving'	], _
		[12268,	-17556,	'Moving'	], _
		[10989,	-17750,	'Moving'	], _
		[9703,	-17634,	'Moving'	], _
		[8496,	-17230,	'Moving'	], _
		[7572,	-16385,	'Moving'	], _
		[7219,	-15144,	'Moving'	], _
		[6798,	-13910,	'Moving'	], _
		[6275,	-12726,	'Group'	], _
		[5015,	-12715,	'Moving'	], _
		[3756,	-12951,	'Moving'	], _
		[2945,	-13895,	'Moving'	], _
		[2941,	-13986,	'Sweep'	], _
		[2421,	-14844,	'Group'	], _
		[1274,	-15368,	'Moving'	], _
		[426,	-15359,	'Group'	], _
		[282,	-16603,	'Moving'	], _
		[817,	-17782,	'Moving'	], _
		[1525,	-18802,	'Moving'	], _
		[2325,	-19794,	'Moving'	], _
		[2971,	-20400,	'Sweep'	], _
		[3301,	-20843,	'Group'	], _
		[4214,	-21758,	'Moving'	], _
		[4598,	-22144,	'Group'	], _
		[5511,	-23059,	'Group'	], _
		[4458,	-22482,	'Moving'	], _
		[3276,	-21953,	'Moving'	], _
		[2126,	-21363,	'Moving'	], _
		[1034,	-20801,	'Group'	], _
		[135,	-21715,	'Moving'	], _
		[-739,	-22689,	'Moving'	], _
		[-1101,	-23116,	'Group'	], _
		[-864,	-21858,	'Moving'	], _
		[-1669,	-20917,	'Moving'	], _
		[-2403,	-20119,	'Group'	], _
		[-3587,	-19892,	'Moving'	], _
		[-4394,	-19810,	'Group'	], _
		[-5608,	-20255,	'Moving'	], _
		[-6456,	-21135,	'Moving'	], _
		[-7014,	-21994,	'Sweep'	], _
		[-7753,	-23064,	'Group'	], _
		[-8853,	-22372,	'Moving'	], _
		[-9985,	-21734,	'Moving'	], _
		[-11116,	-21100,	'Group'	], _
		[-11856,	-20142,	'Moving'	], _
		[-11440,	-18924,	'Moving'	], _
		[-11006,	-17702,	'Moving'	], _
		[-10549,	-16485,	'Moving'	], _
		[-10088,	-15284,	'Moving'	], _
		[-9208,	-14539,	'Group'	], _
		[-8120,	-15075,	'Moving'	], _
		[-7291,	-16065,	'Moving'	], _
		[-7141,	-17318,	'Moving'	], _
		[-7259,	-17912,	'Group'	], _
		[-7224,	-17017,	'Group'	], _
		[-6027,	-16635,	'Moving'	], _
		[-4927,	-16270,	'Sweep'	], _
		[-4105,	-15459,	'Group'	], _
		[-5109,	-14652,	'Group'	], _
		[-5417,	-13473,	'Moving'	], _
		[-5959,	-12305,	'Group'	], _
		[-6294,	-11429,	'Group'	], _
		[-6354,	-12731,	'Moving'	], _
		[-6618,	-14004,	'Moving'	], _
		[-7848,	-14181,	'Group'	], _
		[-8942,	-13498,	'Moving'	], _
		[-9087,	-12217,	'Group'	], _
		[-9324,	-11677,	'Group'	], _
		[-9750,	-10456,	'Moving'	], _
		[-9734,	-9694,	'Group'	], _
		[-10959,	-9670,	'Group'	], _
		[-11644,	-8643,	'Moving'	], _
		[-11096,	-7556,	'Moving'	], _
		[-10643,	-6361,	'Moving'	], _
		[-9805,	-5394,	'Moving'	], _
		[-8733,	-4663,	'Moving'	], _
		[-7560,	-4149,	'Moving'	], _
		[-6283,	-4097,	'Moving'	], _
		[-5227,	-4237,	'Group'	], _
		[-5648,	-3017,	'Moving'	], _
		[-5470,	-1790,	'Moving'	], _
		[-4863,	-639,	'Moving'	], _
		[-4319,	544,	'Moving'	], _
		[-3878,	1475,	'Group'	], _
		[-3447,	2685,	'Moving'	], _
		[-3449,	2790,	'Sweep'	] _
	]

	If ClearVanquishSection($foes, 0, 1, $NORN_DRAKKAR_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(7367, 23752))
	Sleep(1000)
	Dialog(0x84)
	Sleep(1000)

	If ClearVanquishSection($foes, 2, 17, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 18, 21, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 22, 72, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 73, 106, $NORN_DRAKKAR_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(12338, 16844))
	Sleep(1000)

	If ClearVanquishSection($foes, 107, 117, $NORN_DRAKKAR_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(14523, 2357))
	Sleep(1000)

	If ClearVanquishSection($foes, 118, 121, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 122, 137, $NORN_DRAKKAR_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(4297, 5538))
	Sleep(1000)

	If ClearVanquishSection($foes, 138, 160, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 161, 167, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 168, 175, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 176, 186, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 187, 196, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 197, 201, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 202, 213, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 214, 226, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 227, 231, $NORN_DRAKKAR_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(15233, -17127))
	Sleep(1000)

	If ClearVanquishSection($foes, 232, 244, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 245, 252, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 253, 256, $NORN_DRAKKAR_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(5897, -23446))
	Sleep(1000)

	If ClearVanquishSection($foes, 257, 271, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 272, 275, $NORN_DRAKKAR_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(-11560, -20852))
	Sleep(1000)

	If ClearVanquishSection($foes, 276, 288, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL
	If ClearVanquishSection($foes, 289, 310, $NORN_DRAKKAR_FARM_DURATION) == $FAIL Then Return $FAIL

	Info('Taking Blessing')
	GoToNPC(GetNearestNPCToCoords(-5160, -4251))
	Sleep(1000)

	If ClearVanquishSection($foes, 311, 317, $NORN_DRAKKAR_FARM_DURATION, 3 * 60 * 1000) == $FAIL Then Return $FAIL

	If HuntVanquishLeftovers($foes, $NORN_DRAKKAR_FARM_DURATION) == $FAIL Then Return $FAIL

	If Not GetAreaVanquished() Then
		Error('The map has not been completely vanquished.')
		Return $FAIL
	EndIf
	Info('Map has been fully vanquished.')
	Return $SUCCESS
EndFunc
