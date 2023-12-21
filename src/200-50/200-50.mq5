//+------------------------------------------------------------------+
//|                                                       200-50.mq5 |
//|                                         Copyright 2023, SDK Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
/************************************************************************************************************************/

// +------------------------------------------------------------------------------------------------------------------+ //

// |                       INPUT PARAMETERS, GLOBAL VARIABLES, CONSTANTS, IMPORTS and INCLUDES                        | //

// |                      System and Custom variables and other definitions used in the project                       | //

// +------------------------------------------------------------------------------------------------------------------+ //

/************************************************************************************************************************/



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//

// System constants (project settings) //

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//

//--

#define PROJECT_ID "mt5-6255"

//--

// Point Format Rules

#define POINT_FORMAT_RULES "0.001=0.01,0.00001=0.0001,0.000001=0.0001" // this is deserialized in a special function later

#define ENABLE_SPREAD_METER true

#define ENABLE_STATUS true

#define ENABLE_TEST_INDICATORS true

//--

// Events On/Off

#define ENABLE_EVENT_TICK 1 // enable "Tick" event

#define ENABLE_EVENT_TRADE 0 // enable "Trade" event

#define ENABLE_EVENT_TIMER 0 // enable "Timer" event

//--

// Virtual Stops

#define VIRTUAL_STOPS_ENABLED 0 // enable virtual stops

#define VIRTUAL_STOPS_TIMEOUT 0 // virtual stops timeout

#define USE_EMERGENCY_STOPS "no" // "yes" to use emergency (hard stops) when virtual stops are in use. "always" to use EMERGENCY_STOPS_ADD as emergency stops when there is no virtual stop.

#define EMERGENCY_STOPS_REL 0 // use 0 to disable hard stops when virtual stops are enabled. Use a value >=0 to automatically set hard stops with virtual. Example: if 2 is used, then hard stops will be 2 times bigger than virtual ones.

#define EMERGENCY_STOPS_ADD 0 // add pips to relative size of emergency stops (hard stops)

//--

// Settings for events

#define ON_TIMER_PERIOD 60 // Timer event period (in seconds)



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//

// System constants (predefined constants) //

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//

//--

#define TLOBJPROP_TIME1 801

#define OBJPROP_TL_PRICE_BY_SHIFT 802

#define OBJPROP_TL_SHIFT_BY_PRICE 803

#define OBJPROP_FIBOVALUE 804

#define OBJPROP_FIBOPRICEVALUE 805

#define OBJPROP_FIRSTLEVEL 806

#define OBJPROP_TIME1 807

#define OBJPROP_TIME2 808

#define OBJPROP_TIME3 809

#define OBJPROP_PRICE1 810

#define OBJPROP_PRICE2 811

#define OBJPROP_PRICE3 812

#define OBJPROP_BARSHIFT1 813

#define OBJPROP_BARSHIFT2 814

#define OBJPROP_BARSHIFT3 815

#define SEL_CURRENT 0

#define SEL_INITIAL 1



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//

// Enumerations, Imports, Constants, Variables //

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//













//--

// Constants (Input Parameters)

input double risk = 1.0; // Risk % 1.0 = 1% of equity

input int take_percent = 300; // TP % of SL 1:3 = 300

input string EA_Name = "200-50";

input int max_pips_distance = 25; // Max candle size (pips)

input int min_pips_distance = 10; // Min candle size (pips)

input bool enable_bullish_buy = true; // Enable Bull Buy

input bool enable_bearish_sell = true; // Enable Bear Sell

input bool enable_semi_bullish_buy = true; // Enable semi Bull Buy

input bool enable_semi_bearish_sell = true; // Enable semi Bear Sell

input double target_amount = 53050.00; // Target Amount (Stop trading)

input string london_killzone_start = "09:30"; // London KZ Start

input string london_killzone_end = "12:00"; // London KZ End

input string newyork_killzone_start = "15:00"; // New York KZ Start

input string newyork_killzone_end = "17:30"; // New York KZ End

input string asian_killzone_start = "00:00"; // Asia KZ Start

input string asian_killzone_end = "00:00"; // Asia KZ End

input bool isBreakEvenEnabled = true; // Enable Break Even

input int break_even_point = 100; // Break even point. % of SL

input int break_even_offset = 2; // Break even Offset (pips)

input int MagicStart = 6255; // Magic Number, kind of...

class c

{

		public:

	static double risk;

	static int take_percent;

	static string EA_Name;

	static int max_pips_distance;

	static int min_pips_distance;

	static bool enable_bullish_buy;

	static bool enable_bearish_sell;

	static bool enable_semi_bullish_buy;

	static bool enable_semi_bearish_sell;

	static double target_amount;

	static string london_killzone_start;

	static string london_killzone_end;

	static string newyork_killzone_start;

	static string newyork_killzone_end;

	static string asian_killzone_start;

	static string asian_killzone_end;

	static bool isBreakEvenEnabled;

	static int break_even_point;

	static int break_even_offset;

	static int MagicStart;

};

double c::risk;

int c::take_percent;

string c::EA_Name;

int c::max_pips_distance;

int c::min_pips_distance;

bool c::enable_bullish_buy;

bool c::enable_bearish_sell;

bool c::enable_semi_bullish_buy;

bool c::enable_semi_bearish_sell;

double c::target_amount;

string c::london_killzone_start;

string c::london_killzone_end;

string c::newyork_killzone_start;

string c::newyork_killzone_end;

string c::asian_killzone_start;

string c::asian_killzone_end;

bool c::isBreakEvenEnabled;

int c::break_even_point;

int c::break_even_offset;

int c::MagicStart;





//--

// Variables (Global Variables)







































































class v

{

		public:

	static bool isBullish;

	static bool isLondonKZ;

	static bool isNewYorkKZ;

	static bool isBearish;

	static bool isSemiBearish;

	static bool isSemiBullish;

	static double up_subtract_down;

	static double half;

	static double h4_fractal_mid;

	static bool is_target_hit;

	static bool bull_breaks_below;

	static double ny_kz_high;

	static double ny_kz_low;

	static int ny_kz_candle_count;

	static double l_kz_high;

	static double l_kz_low;

	static double l_kz_candle_count;

	static bool isAsianKZ;

	static double a_kz_candle_count;

	static double a_kz_high;

	static double a_kz_low;

	static double max_lot_size;

	static double max_units;

	static double h4_fractal_down_1;

	static double h4_fractal_down_2;

	static int h4_fractal_count_down;

	static double h4_fractal_up_1;

	static double h4_fractal_up_2;

	static int h4_fractal_count_up;

	static double cur_fractal_down_1;

	static double cur_fractal_down_2;

	static int cur_fractal_count_down;

	static double cur_fractal_up_1;

	static double cur_fractal_up_2;

	static int cur_fractal_count_up;

};

bool v::isBullish;

bool v::isLondonKZ;

bool v::isNewYorkKZ;

bool v::isBearish;

bool v::isSemiBearish;

bool v::isSemiBullish;

double v::up_subtract_down;

double v::half;

double v::h4_fractal_mid;

bool v::is_target_hit;

bool v::bull_breaks_below;

double v::ny_kz_high;

double v::ny_kz_low;

int v::ny_kz_candle_count;

double v::l_kz_high;

double v::l_kz_low;

double v::l_kz_candle_count;

bool v::isAsianKZ;

double v::a_kz_candle_count;

double v::a_kz_high;

double v::a_kz_low;

double v::max_lot_size;

double v::max_units;

double v::h4_fractal_down_1;

double v::h4_fractal_down_2;

int v::h4_fractal_count_down;

double v::h4_fractal_up_1;

double v::h4_fractal_up_2;

int v::h4_fractal_count_up;

double v::cur_fractal_down_1;

double v::cur_fractal_down_2;

int v::cur_fractal_count_down;

double v::cur_fractal_up_1;

double v::cur_fractal_up_2;

int v::cur_fractal_count_up;









//VVVVVVVVVVVVVVVVVVVVVVVVV//

// System global variables //

//^^^^^^^^^^^^^^^^^^^^^^^^^//

//--

// Blocks Lookup Functions

string fxdBlocksLookupTable[];



int FXD_CURRENT_FUNCTION_ID = 0;

double FXD_MILS_INIT_END    = 0;

int FXD_TICKS_FROM_START    = 0;

int FXD_MORE_SHIFT          = 0;

bool FXD_DRAW_SPREAD_INFO   = false;

bool FXD_FIRST_TICK_PASSED  = false;

bool FXD_BREAK              = false;

bool FXD_CONTINUE           = false;

bool USE_VIRTUAL_STOPS = VIRTUAL_STOPS_ENABLED;

string FXD_CURRENT_SYMBOL   = "";

int FXD_BLOCKS_COUNT        = 248;

datetime FXD_TICKSKIP_UNTIL = 0;



int FXD_ICUSTOM_HANDLES_IDS[]; // only used in MQL5

string FXD_ICUSTOM_HANDLES_KEYS[]; // only used in MQL5



//- for use in OnChart() event

struct fxd_onchart

{

	int id;

	long lparam;

	double dparam;

	string sparam;

};

fxd_onchart FXD_ONCHART;



/************************************************************************************************************************/

// +------------------------------------------------------------------------------------------------------------------+ //

// |                                                 EVENT FUNCTIONS                                                  | //

// |                           These are the main functions that controls the whole project                           | //

// +------------------------------------------------------------------------------------------------------------------+ //

/************************************************************************************************************************/



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//

// This function is executed once when the program starts //

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//

int OnInit()

{



	// Initiate Constants

	c::risk = risk;

	c::take_percent = take_percent;

	c::EA_Name = EA_Name;

	c::max_pips_distance = max_pips_distance;

	c::min_pips_distance = min_pips_distance;

	c::enable_bullish_buy = enable_bullish_buy;

	c::enable_bearish_sell = enable_bearish_sell;

	c::enable_semi_bullish_buy = enable_semi_bullish_buy;

	c::enable_semi_bearish_sell = enable_semi_bearish_sell;

	c::target_amount = target_amount;

	c::london_killzone_start = london_killzone_start;

	c::london_killzone_end = london_killzone_end;

	c::newyork_killzone_start = newyork_killzone_start;

	c::newyork_killzone_end = newyork_killzone_end;

	c::asian_killzone_start = asian_killzone_start;

	c::asian_killzone_end = asian_killzone_end;

	c::isBreakEvenEnabled = isBreakEvenEnabled;

	c::break_even_point = break_even_point;

	c::break_even_offset = break_even_offset;

	c::MagicStart = MagicStart;









	// do or do not not initilialize on reload

	if (UninitializeReason() != 0)

	{

		if (UninitializeReason() == REASON_CHARTCHANGE)

		{

			// if the symbol is the same, do not reload, otherwise continue below

			if (FXD_CURRENT_SYMBOL == Symbol()) {return INIT_SUCCEEDED;}

		}

		else

		{

			return INIT_SUCCEEDED;

		}

	}

	FXD_CURRENT_SYMBOL = Symbol();



	CurrentSymbol(FXD_CURRENT_SYMBOL); // CurrentSymbol() has internal memory that should be set from here when the symboll is changed

	CurrentTimeframe(PERIOD_CURRENT);



	v::isBullish = false;

	v::isLondonKZ = false;

	v::isNewYorkKZ = false;

	v::isBearish = false;

	v::isSemiBearish = false;

	v::isSemiBullish = false;

	v::up_subtract_down = 0.0;

	v::half = 0.0;

	v::h4_fractal_mid = 0.0;

	v::is_target_hit = false;

	v::bull_breaks_below = false;

	v::ny_kz_high = 0.0;

	v::ny_kz_low = 0.0;

	v::ny_kz_candle_count = -1;

	v::l_kz_high = 0.0;

	v::l_kz_low = 0.0;

	v::l_kz_candle_count = -1;

	v::isAsianKZ = false;

	v::a_kz_candle_count = -1;

	v::a_kz_high = 0.0;

	v::a_kz_low = 0.0;

	v::max_lot_size = 0.0;

	v::max_units = 0.0;

	v::h4_fractal_down_1 = 0.0;

	v::h4_fractal_down_2 = 0.0;

	v::h4_fractal_count_down = 2;

	v::h4_fractal_up_1 = 0.0;

	v::h4_fractal_up_2 = 0.0;

	v::h4_fractal_count_up = 0;

	v::cur_fractal_down_1 = 0.0;

	v::cur_fractal_down_2 = 0.0;

	v::cur_fractal_count_down = 0;

	v::cur_fractal_up_1 = 0.0;

	v::cur_fractal_up_2 = 0.0;

	v::cur_fractal_count_up = 0;









	Comment("");

	for (int i=ObjectsTotal(ChartID()); i>=0; i--)

	{

		string name = ObjectName(ChartID(), i);

		if (StringSubstr(name,0,8) == "fxd_cmnt") {ObjectDelete(ChartID(), name);}

	}

	ChartRedraw();







	//-- disable virtual stops in optimization, because graphical objects does not work

	// http://docs.mql4.com/runtime/testing

	if (MQLInfoInteger(MQL_OPTIMIZATION)) {

		USE_VIRTUAL_STOPS = false;

	}



	//-- set initial local and server time

	TimeAtStart("set");



	//-- set initial balance

	AccountBalanceAtStart();



	//-- draw the initial spread info meter

	if (ENABLE_SPREAD_METER == false) {

		FXD_DRAW_SPREAD_INFO = false;

	}

	else {

		FXD_DRAW_SPREAD_INFO = !(MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_VISUAL_MODE));

	}

	if (FXD_DRAW_SPREAD_INFO) DrawSpreadInfo();



	//-- draw initial status

	if (ENABLE_STATUS) DrawStatus("waiting for tick...");



	//-- draw indicators after test

	TesterHideIndicators(!ENABLE_TEST_INDICATORS);



	if (ENABLE_EVENT_TIMER) {

		OnTimerSet(ON_TIMER_PERIOD);

	}





	//-- Initialize blocks classes

	ArrayResize(_blocks_, 248);



	_blocks_[0] = new Block0();

	_blocks_[1] = new Block1();

	_blocks_[2] = new Block2();

	_blocks_[3] = new Block3();

	_blocks_[4] = new Block4();

	_blocks_[5] = new Block5();

	_blocks_[6] = new Block6();

	_blocks_[7] = new Block7();

	_blocks_[8] = new Block8();

	_blocks_[9] = new Block9();

	_blocks_[10] = new Block10();

	_blocks_[11] = new Block11();

	_blocks_[12] = new Block12();

	_blocks_[13] = new Block13();

	_blocks_[14] = new Block14();

	_blocks_[15] = new Block15();

	_blocks_[16] = new Block16();

	_blocks_[17] = new Block17();

	_blocks_[18] = new Block18();

	_blocks_[19] = new Block19();

	_blocks_[20] = new Block20();

	_blocks_[21] = new Block21();

	_blocks_[22] = new Block22();

	_blocks_[23] = new Block23();

	_blocks_[24] = new Block24();

	_blocks_[25] = new Block25();

	_blocks_[26] = new Block26();

	_blocks_[27] = new Block27();

	_blocks_[28] = new Block28();

	_blocks_[29] = new Block29();

	_blocks_[30] = new Block30();

	_blocks_[31] = new Block31();

	_blocks_[32] = new Block32();

	_blocks_[33] = new Block33();

	_blocks_[34] = new Block34();

	_blocks_[35] = new Block35();

	_blocks_[36] = new Block36();

	_blocks_[37] = new Block37();

	_blocks_[38] = new Block38();

	_blocks_[39] = new Block39();

	_blocks_[40] = new Block40();

	_blocks_[41] = new Block41();

	_blocks_[42] = new Block42();

	_blocks_[43] = new Block43();

	_blocks_[44] = new Block44();

	_blocks_[45] = new Block45();

	_blocks_[46] = new Block46();

	_blocks_[47] = new Block47();

	_blocks_[48] = new Block48();

	_blocks_[49] = new Block49();

	_blocks_[50] = new Block50();

	_blocks_[51] = new Block51();

	_blocks_[52] = new Block52();

	_blocks_[53] = new Block53();

	_blocks_[54] = new Block54();

	_blocks_[55] = new Block55();

	_blocks_[56] = new Block56();

	_blocks_[57] = new Block57();

	_blocks_[58] = new Block58();

	_blocks_[59] = new Block59();

	_blocks_[60] = new Block60();

	_blocks_[61] = new Block61();

	_blocks_[62] = new Block62();

	_blocks_[63] = new Block63();

	_blocks_[64] = new Block64();

	_blocks_[65] = new Block65();

	_blocks_[66] = new Block66();

	_blocks_[67] = new Block67();

	_blocks_[68] = new Block68();

	_blocks_[69] = new Block69();

	_blocks_[70] = new Block70();

	_blocks_[71] = new Block71();

	_blocks_[72] = new Block72();

	_blocks_[73] = new Block73();

	_blocks_[74] = new Block74();

	_blocks_[75] = new Block75();

	_blocks_[76] = new Block76();

	_blocks_[77] = new Block77();

	_blocks_[78] = new Block78();

	_blocks_[79] = new Block79();

	_blocks_[80] = new Block80();

	_blocks_[81] = new Block81();

	_blocks_[82] = new Block82();

	_blocks_[83] = new Block83();

	_blocks_[84] = new Block84();

	_blocks_[85] = new Block85();

	_blocks_[86] = new Block86();

	_blocks_[87] = new Block87();

	_blocks_[88] = new Block88();

	_blocks_[89] = new Block89();

	_blocks_[90] = new Block90();

	_blocks_[91] = new Block91();

	_blocks_[92] = new Block92();

	_blocks_[93] = new Block93();

	_blocks_[94] = new Block94();

	_blocks_[95] = new Block95();

	_blocks_[96] = new Block96();

	_blocks_[97] = new Block97();

	_blocks_[98] = new Block98();

	_blocks_[99] = new Block99();

	_blocks_[100] = new Block100();

	_blocks_[101] = new Block101();

	_blocks_[102] = new Block102();

	_blocks_[103] = new Block103();

	_blocks_[104] = new Block104();

	_blocks_[105] = new Block105();

	_blocks_[106] = new Block106();

	_blocks_[107] = new Block107();

	_blocks_[108] = new Block108();

	_blocks_[109] = new Block109();

	_blocks_[110] = new Block110();

	_blocks_[111] = new Block111();

	_blocks_[112] = new Block112();

	_blocks_[113] = new Block113();

	_blocks_[114] = new Block114();

	_blocks_[115] = new Block115();

	_blocks_[116] = new Block116();

	_blocks_[117] = new Block117();

	_blocks_[118] = new Block118();

	_blocks_[119] = new Block119();

	_blocks_[120] = new Block120();

	_blocks_[121] = new Block121();

	_blocks_[122] = new Block122();

	_blocks_[123] = new Block123();

	_blocks_[124] = new Block124();

	_blocks_[125] = new Block125();

	_blocks_[126] = new Block126();

	_blocks_[127] = new Block127();

	_blocks_[128] = new Block128();

	_blocks_[129] = new Block129();

	_blocks_[130] = new Block130();

	_blocks_[131] = new Block131();

	_blocks_[132] = new Block132();

	_blocks_[133] = new Block133();

	_blocks_[134] = new Block134();

	_blocks_[135] = new Block135();

	_blocks_[136] = new Block136();

	_blocks_[137] = new Block137();

	_blocks_[138] = new Block138();

	_blocks_[139] = new Block139();

	_blocks_[140] = new Block140();

	_blocks_[141] = new Block141();

	_blocks_[142] = new Block142();

	_blocks_[143] = new Block143();

	_blocks_[144] = new Block144();

	_blocks_[145] = new Block145();

	_blocks_[146] = new Block146();

	_blocks_[147] = new Block147();

	_blocks_[148] = new Block148();

	_blocks_[149] = new Block149();

	_blocks_[150] = new Block150();

	_blocks_[151] = new Block151();

	_blocks_[152] = new Block152();

	_blocks_[153] = new Block153();

	_blocks_[154] = new Block154();

	_blocks_[155] = new Block155();

	_blocks_[156] = new Block156();

	_blocks_[157] = new Block157();

	_blocks_[158] = new Block158();

	_blocks_[159] = new Block159();

	_blocks_[160] = new Block160();

	_blocks_[161] = new Block161();

	_blocks_[162] = new Block162();

	_blocks_[163] = new Block163();

	_blocks_[164] = new Block164();

	_blocks_[165] = new Block165();

	_blocks_[166] = new Block166();

	_blocks_[167] = new Block167();

	_blocks_[168] = new Block168();

	_blocks_[169] = new Block169();

	_blocks_[170] = new Block170();

	_blocks_[171] = new Block171();

	_blocks_[172] = new Block172();

	_blocks_[173] = new Block173();

	_blocks_[174] = new Block174();

	_blocks_[175] = new Block175();

	_blocks_[176] = new Block176();

	_blocks_[177] = new Block177();

	_blocks_[178] = new Block178();

	_blocks_[179] = new Block179();

	_blocks_[180] = new Block180();

	_blocks_[181] = new Block181();

	_blocks_[182] = new Block182();

	_blocks_[183] = new Block183();

	_blocks_[184] = new Block184();

	_blocks_[185] = new Block185();

	_blocks_[186] = new Block186();

	_blocks_[187] = new Block187();

	_blocks_[188] = new Block188();

	_blocks_[189] = new Block189();

	_blocks_[190] = new Block190();

	_blocks_[191] = new Block191();

	_blocks_[192] = new Block192();

	_blocks_[193] = new Block193();

	_blocks_[194] = new Block194();

	_blocks_[195] = new Block195();

	_blocks_[196] = new Block196();

	_blocks_[197] = new Block197();

	_blocks_[198] = new Block198();

	_blocks_[199] = new Block199();

	_blocks_[200] = new Block200();

	_blocks_[201] = new Block201();

	_blocks_[202] = new Block202();

	_blocks_[203] = new Block203();

	_blocks_[204] = new Block204();

	_blocks_[205] = new Block205();

	_blocks_[206] = new Block206();

	_blocks_[207] = new Block207();

	_blocks_[208] = new Block208();

	_blocks_[209] = new Block209();

	_blocks_[210] = new Block210();

	_blocks_[211] = new Block211();

	_blocks_[212] = new Block212();

	_blocks_[213] = new Block213();

	_blocks_[214] = new Block214();

	_blocks_[215] = new Block215();

	_blocks_[216] = new Block216();

	_blocks_[217] = new Block217();

	_blocks_[218] = new Block218();

	_blocks_[219] = new Block219();

	_blocks_[220] = new Block220();

	_blocks_[221] = new Block221();

	_blocks_[222] = new Block222();

	_blocks_[223] = new Block223();

	_blocks_[224] = new Block224();

	_blocks_[225] = new Block225();

	_blocks_[226] = new Block226();

	_blocks_[227] = new Block227();

	_blocks_[228] = new Block228();

	_blocks_[229] = new Block229();

	_blocks_[230] = new Block230();

	_blocks_[231] = new Block231();

	_blocks_[232] = new Block232();

	_blocks_[233] = new Block233();

	_blocks_[234] = new Block234();

	_blocks_[235] = new Block235();

	_blocks_[236] = new Block236();

	_blocks_[237] = new Block237();

	_blocks_[238] = new Block238();

	_blocks_[239] = new Block239();

	_blocks_[240] = new Block240();

	_blocks_[241] = new Block241();

	_blocks_[242] = new Block242();

	_blocks_[243] = new Block243();

	_blocks_[244] = new Block244();

	_blocks_[245] = new Block245();

	_blocks_[246] = new Block246();

	_blocks_[247] = new Block247();



	// fill the lookup table

	ArrayResize(fxdBlocksLookupTable, ArraySize(_blocks_));

	for (int i=0; i<ArraySize(_blocks_); i++)

	{

		fxdBlocksLookupTable[i] = _blocks_[i].__block_user_number;

	}



	// fill the list of inbound blocks for each BlockCalls instance

	for (int i=0; i<ArraySize(_blocks_); i++)

	{

		_blocks_[i].__announceThisBlock();

	}



	// List of initially disabled blocks

	int disabled_blocks_list[] = {};

	for (int l = 0; l < ArraySize(disabled_blocks_list); l++) {

		_blocks_[disabled_blocks_list[l]].__disabled = true;

	}



	//-- run blocks

	int blocks_to_run[] = {53,217,229,235};

	for (int i=0; i<ArraySize(blocks_to_run); i++) {

		_blocks_[blocks_to_run[i]].run();

	}





	FXD_MILS_INIT_END     = (double)GetTickCount();

	FXD_FIRST_TICK_PASSED = false; // reset is needed when changing inputs



	return(INIT_SUCCEEDED);

}



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//

// This function is executed on every incoming tick //

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//

void OnTick()

{

	FXD_TICKS_FROM_START++;



	if (ENABLE_STATUS && FXD_TICKS_FROM_START == 1) DrawStatus("working");



	//-- special system actions

	if (FXD_DRAW_SPREAD_INFO) DrawSpreadInfo();

	TicksData(""); // Collect ticks (if needed)

	TicksPerSecond(false, true); // Collect ticks per second

	if (USE_VIRTUAL_STOPS) {VirtualStopsDriver();}



	if (false) ExpirationWorker * expirationDummy = new ExpirationWorker();

	expirationWorker.Run();



	OCODriver(); // Check and close OCO orders



	// skip ticks

	if (TimeLocal() < FXD_TICKSKIP_UNTIL) {return;}



	//-- run blocks

	int blocks_to_run[] = {0,7,17,65,85,94,96,115,131,163,191,203};

	for (int i=0; i<ArraySize(blocks_to_run); i++) {

		_blocks_[blocks_to_run[i]].run();

	}





	return;

}



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//

// This function is executed on trade events - open, close, modify //

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//

void OnTrade()

{

	// This is needed so that the OnTradeEventDetector class is added into the code

	if (false) OnTradeEventDetector * dummy = new OnTradeEventDetector();



}





//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//

// This function is executed on a period basis //

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//

void OnTimer()

{



}





//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//

// This function is executed when chart event happens //

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//

void OnChartEvent(

	const int id,         // Event ID

	const long& lparam,   // Parameter of type long event

	const double& dparam, // Parameter of type double event

	const string& sparam  // Parameter of type string events

)

{

	//-- write parameter to the system global variables

	FXD_ONCHART.id     = id;

	FXD_ONCHART.lparam = lparam;

	FXD_ONCHART.dparam = dparam;

	FXD_ONCHART.sparam = sparam;





	return;

}



//VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV//

// This function is executed once when the program ends //

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//

void OnDeinit(const int reason)

{

	int reson = UninitializeReason();

	if (reson == REASON_CHARTCHANGE || reson == REASON_PARAMETERS || reason == REASON_TEMPLATE || reason == REASON_ACCOUNT) {return;}



	//-- if Timer was set, kill it here

	EventKillTimer();



	if (ENABLE_STATUS) DrawStatus("stopped");

	if (ENABLE_SPREAD_METER) DrawSpreadInfo();

	ChartSetString(0, CHART_COMMENT, "");







	if (MQLInfoInteger(MQL_TESTER)) {

		Print("Backtested in "+DoubleToString((GetTickCount()-FXD_MILS_INIT_END)/1000, 2)+" seconds");

		double tc = GetTickCount()-FXD_MILS_INIT_END;

		if (tc > 0)

		{

			Print("Average ticks per second: "+DoubleToString(FXD_TICKS_FROM_START/tc, 0));

		}

	}



	if (MQLInfoInteger(MQL_PROGRAM_TYPE) == PROGRAM_EXPERT)

	{

		switch(UninitializeReason())

		{

			case REASON_PROGRAM		: Print("Expert Advisor self terminated"); break;

			case REASON_REMOVE		: Print("Expert Advisor removed from the chart"); break;

			case REASON_RECOMPILE	: Print("Expert Advisor has been recompiled"); break;

			case REASON_CHARTCHANGE	: Print("Symbol or chart period has been changed"); break;

			case REASON_CHARTCLOSE	: Print("Chart has been closed"); break;

			case REASON_PARAMETERS	: Print("Input parameters have been changed by a user"); break;

			case REASON_ACCOUNT		: Print("Another account has been activated or reconnection to the trade server has occurred due to changes in the account settings"); break;

			case REASON_TEMPLATE		: Print("A new template has been applied"); break;

			case REASON_INITFAILED	: Print("OnInit() handler has returned a nonzero value"); break;

			case REASON_CLOSE			: Print("Terminal has been closed"); break;

		}

	}



	// delete dynamic pointers

	for (int i=0; i<ArraySize(_blocks_); i++)

	{

		delete _blocks_[i];

		_blocks_[i] = NULL;

	}

	ArrayResize(_blocks_, 0);



	return;

}



/************************************************************************************************************************/

// +------------------------------------------------------------------------------------------------------------------+ //

// |                                             Classes of blocks                                                    | //

// |              Classes that contain the actual code of the blocks and their input parameters as well               | //

// +------------------------------------------------------------------------------------------------------------------+ //

/************************************************************************************************************************/



/**

	The base class for all block calls

   */

class BlockCalls

{

	public:

		bool __disabled; // whether or not the block is disabled



		string __block_user_number;

        int __block_number;

		int __block_waiting;

		int __parent_number;

		int __inbound_blocks[];

		int __outbound_blocks[];



		void __addInboundBlock(int id = 0) {

			int size = ArraySize(__inbound_blocks);

			for (int i = 0; i < size; i++) {

				if (__inbound_blocks[i] == id) {

					return;

				}

			}

			ArrayResize(__inbound_blocks, size + 1);

			__inbound_blocks[size] = id;

		}



		void BlockCalls() {

			__disabled          = false;

			__block_user_number = "";

			__block_number      = 0;

			__block_waiting     = 0;

			__parent_number     = 0;

		}



		/**

		   Announce this block to the list of inbound connections of all the blocks to which this block is connected to

		   */

		void __announceThisBlock()

		{

		   // add the current block number to the list of inbound blocks

		   // for each outbound block that is provided

			for (int i = 0; i < ArraySize(__outbound_blocks); i++)

			{

				int block = __outbound_blocks[i]; // outbound block number

				int size  = ArraySize(_blocks_[block].__inbound_blocks); // the size of its inbound list



				// skip if the current block was already added

				for (int j = 0; j < size; j++) {

					if (_blocks_[block].__inbound_blocks[j] == __block_number)

					{

						return;

					}

				}



				// add the current block number to the list of inbound blocks of the other block

				ArrayResize(_blocks_[block].__inbound_blocks, size + 1);

				_blocks_[block].__inbound_blocks[size] = __block_number;

			}

		}



		// this is here, because it is used in the "run" function

		virtual void _execute_() = 0;



		/**

			In the derived class this method should be used to set dynamic parameters or other stuff before the main execute.

			This method is automatically called within the main "run" method below, before the execution of the main class.

			*/

		virtual void _beforeExecute_() {return;};

		bool _beforeExecuteEnabled; // for speed



		/**

			Same as _beforeExecute_, but to work after the execute method.

			*/

		virtual void _afterExecute_() {return;};

		bool _afterExecuteEnabled; // for speed



		/**

			This is the method that is used to run the block

			*/

		virtual void run(int _parent_=0) {

			__parent_number = _parent_;

			if (__disabled || FXD_BREAK) {return;}

			FXD_CURRENT_FUNCTION_ID = __block_number;



			if (_beforeExecuteEnabled) {_beforeExecute_();}

			_execute_();

			if (_afterExecuteEnabled) {_afterExecute_();}



			if (__block_waiting && FXD_CURRENT_FUNCTION_ID == __block_number) {fxdWait.Accumulate(FXD_CURRENT_FUNCTION_ID);}

		}

};



BlockCalls *_blocks_[];





// "Pass" model

class MDL_Pass: public BlockCalls

{

	virtual void _callback_(int r) {return;}



	public: /* The main method */

	virtual void _execute_()

	{

		_callback_(1);

	}

};



// "No position" model

template<typename T1,typename T2,typename T3,typename T4,typename T5>

class MDL_NoOpenedOrders: public BlockCalls

{

	public: /* Input Parameters */

	T1 GroupMode;

	T2 Group;

	T3 SymbolMode;

	T4 Symbol;

	T5 BuysOrSells;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_NoOpenedOrders()

	{

		GroupMode = (string)"group";

		Group = (string)"";

		SymbolMode = (string)"symbol";

		Symbol = (string)CurrentSymbol();

		BuysOrSells = (string)"both";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		bool exist = false;

		

		for (int index = TradesTotal()-1; index >= 0; index--)

		{

			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))

			{

				exist = true;

				break;

			}

		}

		

		if (exist == false) {_callback_(1);} else {_callback_(0);}

	}

};



// "Condition" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_,typename T4>

class MDL_Condition: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	T4 crosswidth;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Condition()

	{

		compare = (string)">";

		crosswidth = (int)1;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		bool output1 = false, output2 = false; // output 1 and output 2

		int crossover = 0;

		

		if (compare == "x>" || compare == "x<") {crossover = 1;}

		

		for (int i = 0; i <= crossover; i++)

		{

			// i=0 - normal pass, i=1 - crossover pass

		

			// Left operand of the condition

			FXD_MORE_SHIFT = i * crosswidth;

			_T1_ lo = _Lo_();

			if (MathAbs(lo) == EMPTY_VALUE) {return;}

		

			// Right operand of the condition

			FXD_MORE_SHIFT = i * crosswidth;

			_T3_ ro = _Ro_();

			if (MathAbs(ro) == EMPTY_VALUE) {return;}

		

			// Conditions

			if (CompareValues(compare, lo, ro))

			{

				if (i == 0)

				{

					output1 = true;

				}

			}

			else

			{

				if (i == 0)

				{

					output2 = true;

				}

				else

				{

					output2 = false;

				}

			}

		

			if (crossover == 1)

			{

				if (CompareValues(compare, ro, lo))

				{

					if (i == 0)

					{

						output2 = true;

					}

				}

				else

				{

					if (i == 1)

					{

						output1 = false;

					}

				}

			}

		}

		

		FXD_MORE_SHIFT = 0; // reset

		

			  if (output1 == true) {_callback_(1);}

		else if (output2 == true) {_callback_(0);}

	}

};



// "Buy now" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename T28,typename T29,typename T30,typename T31,typename T32,typename T33,typename T34,typename T35,typename T36,typename T37,typename _T37_,typename T38,typename _T38_,typename T39,typename _T39_,typename T40,typename T41,typename T42,typename T43,typename T44,typename _T44_,typename T45,typename _T45_,typename T46,typename _T46_,typename T47,typename T48,typename T49,typename T50,typename T51,typename _T51_,typename T52,typename T53,typename T54>

class MDL_BuyNow: public BlockCalls

{

	public: /* Input Parameters */

	T1 Group;

	T2 Symbol;

	T3 VolumeMode;

	T4 VolumeSize;

	T5 VolumeSizeRisk;

	T6 VolumeRisk;

	T7 VolumePercent;

	T8 VolumeBlockPercent;

	T9 dVolumeSize; virtual _T9_ _dVolumeSize_(){return(_T9_)0;}

	T10 FixedRatioUnitSize;

	T11 FixedRatioDelta;

	T12 mmTradesPool;

	T13 mmMgInitialLots;

	T14 mmMgMultiplyOnLoss;

	T15 mmMgMultiplyOnProfit;

	T16 mmMgAddLotsOnLoss;

	T17 mmMgAddLotsOnProfit;

	T18 mmMgResetOnLoss;

	T19 mmMgResetOnProfit;

	T20 mm1326InitialLots;

	T21 mm1326Reverse;

	T22 mmFiboInitialLots;

	T23 mmDalembertInitialLots;

	T24 mmDalembertReverse;

	T25 mmLabouchereInitialLots;

	T26 mmLabouchereList;

	T27 mmLabouchereReverse;

	T28 mmSeqBaseLots;

	T29 mmSeqOnLoss;

	T30 mmSeqOnProfit;

	T31 mmSeqReverse;

	T32 VolumeUpperLimit;

	T33 StopLossMode;

	T34 StopLossPips;

	T35 StopLossPercentPrice;

	T36 StopLossPercentTP;

	T37 dlStopLoss; virtual _T37_ _dlStopLoss_(){return(_T37_)0;}

	T38 dpStopLoss; virtual _T38_ _dpStopLoss_(){return(_T38_)0;}

	T39 ddStopLoss; virtual _T39_ _ddStopLoss_(){return(_T39_)0;}

	T40 TakeProfitMode;

	T41 TakeProfitPips;

	T42 TakeProfitPercentPrice;

	T43 TakeProfitPercentSL;

	T44 dlTakeProfit; virtual _T44_ _dlTakeProfit_(){return(_T44_)0;}

	T45 dpTakeProfit; virtual _T45_ _dpTakeProfit_(){return(_T45_)0;}

	T46 ddTakeProfit; virtual _T46_ _ddTakeProfit_(){return(_T46_)0;}

	T47 ExpMode;

	T48 ExpDays;

	T49 ExpHours;

	T50 ExpMinutes;

	T51 dExp; virtual _T51_ _dExp_(){return(_T51_)0;}

	T52 Slippage;

	T53 MyComment;

	T54 ArrowColorBuy;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_BuyNow()

	{

		Group = (string)"";

		Symbol = (string)CurrentSymbol();

		VolumeMode = (string)"fixed";

		VolumeSize = (double)0.1;

		VolumeSizeRisk = (double)50.0;

		VolumeRisk = (double)2.5;

		VolumePercent = (double)100.0;

		VolumeBlockPercent = (double)3.0;

		FixedRatioUnitSize = (double)0.01;

		FixedRatioDelta = (double)20.0;

		mmTradesPool = (int)0;

		mmMgInitialLots = (double)0.1;

		mmMgMultiplyOnLoss = (double)2.0;

		mmMgMultiplyOnProfit = (double)1.0;

		mmMgAddLotsOnLoss = (double)0.0;

		mmMgAddLotsOnProfit = (double)0.0;

		mmMgResetOnLoss = (int)0;

		mmMgResetOnProfit = (int)1;

		mm1326InitialLots = (double)0.1;

		mm1326Reverse = (bool)false;

		mmFiboInitialLots = (double)0.1;

		mmDalembertInitialLots = (double)0.1;

		mmDalembertReverse = (bool)false;

		mmLabouchereInitialLots = (double)0.1;

		mmLabouchereList = (string)"1,2,3,4,5,6";

		mmLabouchereReverse = (bool)false;

		mmSeqBaseLots = (double)0.1;

		mmSeqOnLoss = (string)"3,2,6";

		mmSeqOnProfit = (string)"1";

		mmSeqReverse = (bool)false;

		VolumeUpperLimit = (double)0.0;

		StopLossMode = (string)"fixed";

		StopLossPips = (double)50.0;

		StopLossPercentPrice = (double)0.55;

		StopLossPercentTP = (double)100.0;

		TakeProfitMode = (string)"fixed";

		TakeProfitPips = (double)50.0;

		TakeProfitPercentPrice = (double)0.55;

		TakeProfitPercentSL = (double)100.0;

		ExpMode = (string)"GTC";

		ExpDays = (int)0;

		ExpHours = (int)1;

		ExpMinutes = (int)0;

		Slippage = (ulong)4;

		MyComment = (string)"";

		ArrowColorBuy = (color)clrBlue;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		//-- stops ------------------------------------------------------------------

		double sll = 0, slp = 0, tpl = 0, tpp = 0;

		

		     if (StopLossMode == "fixed")         {slp = StopLossPips;}

		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}

		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}

		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}

		else if (StopLossMode == "percentPrice")  {sll = SymbolAsk(Symbol) - (SymbolAsk(Symbol) * StopLossPercentPrice / 100);}

		

		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}

		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}

		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}

		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}

		else if (TakeProfitMode == "percentPrice")  {tpl = SymbolAsk(Symbol) + (SymbolAsk(Symbol) * TakeProfitPercentPrice / 100);}

		

		if (StopLossMode == "percentTP") {

		   if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}

		   if (tpl > 0) {slp = toPips(MathAbs(SymbolAsk(Symbol) - tpl), Symbol)*StopLossPercentTP/100;}

		}

		if (TakeProfitMode == "percentSL") {

		   if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}

		   if (sll > 0) {tpp = toPips(MathAbs(SymbolAsk(Symbol) - sll), Symbol)*TakeProfitPercentSL/100;}

		}

		

		//-- lots -------------------------------------------------------------------

		double lots = 0;

		double pre_sll = sll;

		

		if (pre_sll == 0) {

			pre_sll = SymbolAsk(Symbol);

		}

		

		double pre_sl_pips = toPips(SymbolAsk(Symbol)-(pre_sll-toDigits(slp,Symbol)), Symbol);

		

		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}

		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}

		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}

		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}

		else if (VolumeMode == "1326")             {lots = Bet1326(Group, Symbol, mmTradesPool, mm1326InitialLots, mm1326Reverse);}

		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group, Symbol, mmTradesPool, mmFiboInitialLots);}

		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group, Symbol, mmTradesPool, mmDalembertInitialLots, mmDalembertReverse);}

		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group, Symbol, mmTradesPool, mmLabouchereInitialLots, mmLabouchereList, mmLabouchereReverse);}

		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, mmTradesPool, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}

		else if (VolumeMode == "sequence")         {lots = BetSequence(Group, Symbol, mmTradesPool, mmSeqBaseLots, mmSeqOnLoss, mmSeqOnProfit, mmSeqReverse);}

		

		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);

		

		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());

		

		//-- send -------------------------------------------------------------------

		long ticket = BuyNow(Symbol, lots, sll, tpl, slp, tpp, Slippage, (MagicStart+(int)Group), MyComment, ArrowColorBuy, exp);

		

		if (ticket > 0) {_callback_(1);} else {_callback_(0);}

	}

};



// "Sell now" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename T28,typename T29,typename T30,typename T31,typename T32,typename T33,typename T34,typename T35,typename T36,typename T37,typename _T37_,typename T38,typename _T38_,typename T39,typename _T39_,typename T40,typename T41,typename T42,typename T43,typename T44,typename _T44_,typename T45,typename _T45_,typename T46,typename _T46_,typename T47,typename T48,typename T49,typename T50,typename T51,typename _T51_,typename T52,typename T53,typename T54>

class MDL_SellNow: public BlockCalls

{

	public: /* Input Parameters */

	T1 Group;

	T2 Symbol;

	T3 VolumeMode;

	T4 VolumeSize;

	T5 VolumeSizeRisk;

	T6 VolumeRisk;

	T7 VolumePercent;

	T8 VolumeBlockPercent;

	T9 dVolumeSize; virtual _T9_ _dVolumeSize_(){return(_T9_)0;}

	T10 FixedRatioUnitSize;

	T11 FixedRatioDelta;

	T12 mmTradesPool;

	T13 mmMgInitialLots;

	T14 mmMgMultiplyOnLoss;

	T15 mmMgMultiplyOnProfit;

	T16 mmMgAddLotsOnLoss;

	T17 mmMgAddLotsOnProfit;

	T18 mmMgResetOnLoss;

	T19 mmMgResetOnProfit;

	T20 mm1326InitialLots;

	T21 mm1326Reverse;

	T22 mmFiboInitialLots;

	T23 mmDalembertInitialLots;

	T24 mmDalembertReverse;

	T25 mmLabouchereInitialLots;

	T26 mmLabouchereList;

	T27 mmLabouchereReverse;

	T28 mmSeqBaseLots;

	T29 mmSeqOnLoss;

	T30 mmSeqOnProfit;

	T31 mmSeqReverse;

	T32 VolumeUpperLimit;

	T33 StopLossMode;

	T34 StopLossPips;

	T35 StopLossPercentPrice;

	T36 StopLossPercentTP;

	T37 dlStopLoss; virtual _T37_ _dlStopLoss_(){return(_T37_)0;}

	T38 dpStopLoss; virtual _T38_ _dpStopLoss_(){return(_T38_)0;}

	T39 ddStopLoss; virtual _T39_ _ddStopLoss_(){return(_T39_)0;}

	T40 TakeProfitMode;

	T41 TakeProfitPips;

	T42 TakeProfitPercentPrice;

	T43 TakeProfitPercentSL;

	T44 dlTakeProfit; virtual _T44_ _dlTakeProfit_(){return(_T44_)0;}

	T45 dpTakeProfit; virtual _T45_ _dpTakeProfit_(){return(_T45_)0;}

	T46 ddTakeProfit; virtual _T46_ _ddTakeProfit_(){return(_T46_)0;}

	T47 ExpMode;

	T48 ExpDays;

	T49 ExpHours;

	T50 ExpMinutes;

	T51 dExp; virtual _T51_ _dExp_(){return(_T51_)0;}

	T52 Slippage;

	T53 MyComment;

	T54 ArrowColorSell;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_SellNow()

	{

		Group = (string)"";

		Symbol = (string)CurrentSymbol();

		VolumeMode = (string)"fixed";

		VolumeSize = (double)0.1;

		VolumeSizeRisk = (double)50.0;

		VolumeRisk = (double)2.5;

		VolumePercent = (double)100.0;

		VolumeBlockPercent = (double)3.0;

		FixedRatioUnitSize = (double)0.01;

		FixedRatioDelta = (double)20.0;

		mmTradesPool = (int)0;

		mmMgInitialLots = (double)0.1;

		mmMgMultiplyOnLoss = (double)2.0;

		mmMgMultiplyOnProfit = (double)1.0;

		mmMgAddLotsOnLoss = (double)0.0;

		mmMgAddLotsOnProfit = (double)0.0;

		mmMgResetOnLoss = (int)0;

		mmMgResetOnProfit = (int)1;

		mm1326InitialLots = (double)0.1;

		mm1326Reverse = (bool)false;

		mmFiboInitialLots = (double)0.1;

		mmDalembertInitialLots = (double)0.1;

		mmDalembertReverse = (bool)false;

		mmLabouchereInitialLots = (double)0.1;

		mmLabouchereList = (string)"1,2,3,4,5,6";

		mmLabouchereReverse = (bool)false;

		mmSeqBaseLots = (double)0.1;

		mmSeqOnLoss = (string)"3,2,6";

		mmSeqOnProfit = (string)"1";

		mmSeqReverse = (bool)false;

		VolumeUpperLimit = (double)0.0;

		StopLossMode = (string)"fixed";

		StopLossPips = (double)50.0;

		StopLossPercentPrice = (double)0.55;

		StopLossPercentTP = (double)100.0;

		TakeProfitMode = (string)"fixed";

		TakeProfitPips = (double)50.0;

		TakeProfitPercentPrice = (double)0.55;

		TakeProfitPercentSL = (double)100.0;

		ExpMode = (string)"GTC";

		ExpDays = (int)0;

		ExpHours = (int)1;

		ExpMinutes = (int)0;

		Slippage = (ulong)4;

		MyComment = (string)"";

		ArrowColorSell = (color)clrRed;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		//-- stops ------------------------------------------------------------------

		double sll = 0, slp = 0, tpl = 0, tpp = 0;

		

		     if (StopLossMode == "fixed")         {slp = StopLossPips;}

		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}

		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}

		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}

		else if (StopLossMode == "percentPrice")  {sll = SymbolBid(Symbol) + (SymbolBid(Symbol) * StopLossPercentPrice / 100);}

		

		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}

		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}

		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}

		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}

		else if (TakeProfitMode == "percentPrice")  {tpl = SymbolBid(Symbol) - (SymbolBid(Symbol) * TakeProfitPercentPrice / 100);}

		

		if (StopLossMode == "percentTP") {

		   if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}

		   if (tpl > 0) {slp = toPips(MathAbs(SymbolBid(Symbol) - tpl), Symbol)*StopLossPercentTP/100;}

		}

		if (TakeProfitMode == "percentSL") {

		   if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}

		   if (sll > 0) {tpp = toPips(MathAbs(SymbolBid(Symbol) - sll), Symbol)*TakeProfitPercentSL/100;}

		}

		

		//-- lots -------------------------------------------------------------------

		double lots = 0;

		double pre_sll = sll;

		

		if (pre_sll == 0) {

			pre_sll = SymbolBid(Symbol);

		}

		

		double pre_sl_pips = toPips((pre_sll+toDigits(slp,Symbol))-SymbolBid(Symbol), Symbol);

		

		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}

		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}

		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}

		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}

		else if (VolumeMode == "1326")             {lots = Bet1326(Group, Symbol, mmTradesPool, mm1326InitialLots, mm1326Reverse);}

		else if (VolumeMode == "fibonacci")        {lots = BetFibonacci(Group, Symbol, mmTradesPool, mmFiboInitialLots);}

		else if (VolumeMode == "dalembert")        {lots = BetDalembert(Group, Symbol, mmTradesPool, mmDalembertInitialLots, mmDalembertReverse);}

		else if (VolumeMode == "labouchere")       {lots = BetLabouchere(Group, Symbol, mmTradesPool, mmLabouchereInitialLots, mmLabouchereList, mmLabouchereReverse);}

		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, mmTradesPool, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}

		else if (VolumeMode == "sequence")         {lots = BetSequence(Group, Symbol, mmTradesPool, mmSeqBaseLots, mmSeqOnLoss, mmSeqOnProfit, mmSeqReverse);}

		

		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);

		

		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());

		

		//-- send -------------------------------------------------------------------

		long ticket = SellNow(Symbol, lots, sll, tpl, slp, tpp, Slippage, (MagicStart+(int)Group), MyComment, ArrowColorSell, exp);

		

		if (ticket > 0) {_callback_(1);} else {_callback_(0);}

	}

};



// "Comment" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename _T16_,typename T17,typename T18,typename T19,typename T20,typename _T20_,typename T21,typename T22,typename T23,typename T24,typename _T24_,typename T25,typename T26,typename T27,typename T28,typename _T28_,typename T29,typename T30,typename T31,typename T32,typename _T32_,typename T33,typename T34,typename T35,typename T36,typename _T36_,typename T37,typename T38,typename T39,typename T40,typename _T40_,typename T41,typename T42,typename T43,typename T44,typename _T44_,typename T45,typename T46>

class MDL_CommentEx: public BlockCalls

{

	public: /* Input Parameters */

	T1 Title;

	T2 ObjChartSubWindow;

	T3 ObjCorner;

	T4 ObjX;

	T5 ObjY;

	T6 ObjTitleFont;

	T7 ObjTitleFontColor;

	T8 ObjTitleFontSize;

	T9 ObjLabelsFont;

	T10 ObjLabelsFontColor;

	T11 ObjLabelsFontSize;

	T12 ObjFont;

	T13 ObjFontColor;

	T14 ObjFontSize;

	T15 Label1;

	T16 Value1; virtual _T16_ _Value1_(){return(_T16_)0;}

	T17 FormatNumber1;

	T18 FormatTime1;

	T19 Label2;

	T20 Value2; virtual _T20_ _Value2_(){return(_T20_)0;}

	T21 FormatNumber2;

	T22 FormatTime2;

	T23 Label3;

	T24 Value3; virtual _T24_ _Value3_(){return(_T24_)0;}

	T25 FormatNumber3;

	T26 FormatTime3;

	T27 Label4;

	T28 Value4; virtual _T28_ _Value4_(){return(_T28_)0;}

	T29 FormatNumber4;

	T30 FormatTime4;

	T31 Label5;

	T32 Value5; virtual _T32_ _Value5_(){return(_T32_)0;}

	T33 FormatNumber5;

	T34 FormatTime5;

	T35 Label6;

	T36 Value6; virtual _T36_ _Value6_(){return(_T36_)0;}

	T37 FormatNumber6;

	T38 FormatTime6;

	T39 Label7;

	T40 Value7; virtual _T40_ _Value7_(){return(_T40_)0;}

	T41 FormatNumber7;

	T42 FormatTime7;

	T43 Label8;

	T44 Value8; virtual _T44_ _Value8_(){return(_T44_)0;}

	T45 FormatNumber8;

	T46 FormatTime8;

	/* Static Parameters */

	bool initialized;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_CommentEx()

	{

		Title = (string)"Comment Message";

		ObjChartSubWindow = (string)"";

		ObjCorner = (int)CORNER_LEFT_UPPER;

		ObjX = (int)5;

		ObjY = (int)24;

		ObjTitleFont = (string)"Georgia";

		ObjTitleFontColor = (color)clrGold;

		ObjTitleFontSize = (int)13;

		ObjLabelsFont = (string)"Verdana";

		ObjLabelsFontColor = (color)clrDarkGray;

		ObjLabelsFontSize = (int)10;

		ObjFont = (string)"Verdana";

		ObjFontColor = (color)clrWhite;

		ObjFontSize = (int)10;

		Label1 = (string)"";

		FormatNumber1 = (int)EMPTY_VALUE;

		FormatTime1 = (int)EMPTY_VALUE;

		Label2 = (string)"";

		FormatNumber2 = (int)EMPTY_VALUE;

		FormatTime2 = (int)EMPTY_VALUE;

		Label3 = (string)"";

		FormatNumber3 = (int)EMPTY_VALUE;

		FormatTime3 = (int)EMPTY_VALUE;

		Label4 = (string)"";

		FormatNumber4 = (int)EMPTY_VALUE;

		FormatTime4 = (int)EMPTY_VALUE;

		Label5 = (string)"";

		FormatNumber5 = (int)EMPTY_VALUE;

		FormatTime5 = (int)EMPTY_VALUE;

		Label6 = (string)"";

		FormatNumber6 = (int)EMPTY_VALUE;

		FormatTime6 = (int)EMPTY_VALUE;

		Label7 = (string)"";

		FormatNumber7 = (int)EMPTY_VALUE;

		FormatTime7 = (int)EMPTY_VALUE;

		Label8 = (string)"";

		FormatNumber8 = (int)EMPTY_VALUE;

		FormatTime8 = (int)EMPTY_VALUE;

		/* Static Parameters (initial value) */

		initialized =  false;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		if (!MQLInfoInteger(MQL_TESTER) || MQLInfoInteger(MQL_VISUAL_MODE))

		{

			

		

			long ObjChartID = 0;

			int ObjAnchor   = ANCHOR_LEFT;

		

			if (ObjCorner == CORNER_RIGHT_UPPER || ObjCorner == CORNER_RIGHT_LOWER)

			{

				ObjAnchor = ANCHOR_RIGHT;

			}

		

			string namebase = "fxd_cmnt_" + __block_user_number;

		

			int subwindow = WindowFindVisible(ObjChartID, ObjChartSubWindow);

		

			if (subwindow >= 0)

			{

				//-- draw comment title

				if ((string)Title != "")

				{

					string nametitle = namebase;

		

					if(ObjectFind(ObjChartID, nametitle) < 0)

					{

						if (!ObjectCreate(ObjChartID, nametitle, OBJ_LABEL, subwindow, 0, 0, 0, 0))

						{

							Print(__FUNCTION__, ": failed to create text object! Error code = ", GetLastError());

						}

						else

						{

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_FONTSIZE, (int)(ObjTitleFontSize));

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_COLOR, ObjTitleFontColor);

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_BACK, 0);

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_SELECTABLE, 1);

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_SELECTED, 0);

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_HIDDEN, 1);

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_CORNER, ObjCorner);

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_ANCHOR, ObjAnchor);

		

							ObjectSetString(ObjChartID, nametitle, OBJPROP_FONT, ObjTitleFont);

		

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_XDISTANCE, ObjX);

							ObjectSetInteger(ObjChartID, nametitle, OBJPROP_YDISTANCE, ObjY);

						}

					}

					else

					{

						ObjX = (int)ObjectGetInteger(ObjChartID, nametitle, OBJPROP_XDISTANCE);

						ObjY = (int)ObjectGetInteger(ObjChartID, nametitle, OBJPROP_YDISTANCE);

					}

		

					ObjectSetString(ObjChartID, nametitle, OBJPROP_TEXT, (string)Title);

		

					ObjY = (int)(ObjY + ObjTitleFontSize / 3);

				}

		

				//-- draw comment rows

				for (int i = 1; i <= 8; i++)

				{

					string text    = "";

					string textlbl = "";

		

					switch(i)

					{

						case 1:

						{

							if (Label1 != "")

							{

								textlbl = Label1;

								text    = FormatValueForPrinting(_Value1_(), FormatNumber1, FormatTime1);

							}

		

							break;

						}

						case 2:

						{

							if (Label2 != "")

							{

								textlbl = Label2;

								text    = FormatValueForPrinting(_Value2_(), FormatNumber2, FormatTime2);

							}

		

							break;

						}

						case 3:

						{

							if (Label3 != "")

							{

								textlbl = Label3;

								text    = FormatValueForPrinting(_Value3_(), FormatNumber3, FormatTime3);

							}

		

							break;

						}

						case 4:

						{

							if (Label4 != "")

							{

								textlbl = Label4;

								text    = FormatValueForPrinting(_Value4_(), FormatNumber4, FormatTime4);

							}

		

							break;

						}

						case 5:

						{

							if (Label5 != "")

							{

								textlbl = Label5;

								text    = FormatValueForPrinting(_Value5_(), FormatNumber5, FormatTime5);

							}

		

							break;

						}

						case 6:

						{

							if (Label6 != "")

							{

								textlbl = Label6;

								text    = FormatValueForPrinting(_Value6_(), FormatNumber6, FormatTime6);

							}

		

							break;

						}

						case 7:

						{

							if (Label7 != "")

							{

								textlbl = Label7;

								text    = FormatValueForPrinting(_Value7_(), FormatNumber7, FormatTime7);

							}

		

							break;

						}

						case 8:

						{

							if (Label8 != "")

							{

								textlbl = Label8;

								text    = FormatValueForPrinting(_Value8_(), FormatNumber8, FormatTime8);

							}

		

							break;

						}

				   }

		

					string name    = namebase + "_" + (string)i;

					string namelbl = name + "_l";

		

					if (textlbl == "")

					{

						if (!initialized)

						{

							//-- pre-delete

							ObjectDelete(ObjChartID, namelbl);

							ObjectDelete(ObjChartID, name);

						}

		

						continue;

					}

		

					//-- draw initial objects

					if (ObjectFind(ObjChartID, name) < 0)

					{

						if (textlbl == "")

						{

							continue;

						}

		

						if (ObjectCreate(ObjChartID, namelbl, OBJ_LABEL, subwindow, 0, 0, 0, 0))

						{

							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_CORNER, ObjCorner);

							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_ANCHOR, ObjAnchor);

							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_BACK, 0);

							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_SELECTABLE, 0);

							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_SELECTED, 0);

							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_HIDDEN, 1);

							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_FONTSIZE, ObjLabelsFontSize);

							ObjectSetInteger(ObjChartID, namelbl, OBJPROP_COLOR, ObjLabelsFontColor);

							ObjectSetString(ObjChartID, namelbl, OBJPROP_FONT, ObjLabelsFont);

						}

						else

						{

							Print(__FUNCTION__, ": failed to create text object! Error code = ", GetLastError());

						}

		

						if (ObjectCreate(ObjChartID, name, OBJ_LABEL, subwindow, 0, 0, 0, 0))

						{

							ObjectSetInteger(ObjChartID, name, OBJPROP_CORNER, ObjCorner);

							ObjectSetInteger(ObjChartID, name, OBJPROP_ANCHOR, ObjAnchor);

							ObjectSetInteger(ObjChartID, name, OBJPROP_BACK, 0);

							ObjectSetInteger(ObjChartID, name, OBJPROP_SELECTABLE, 0);

							ObjectSetInteger(ObjChartID, name, OBJPROP_SELECTED, 0);

							ObjectSetInteger(ObjChartID, name, OBJPROP_HIDDEN, 1);

							ObjectSetInteger(ObjChartID, name, OBJPROP_FONTSIZE, ObjFontSize);

							ObjectSetInteger(ObjChartID, name, OBJPROP_COLOR, ObjFontColor);

							ObjectSetString(ObjChartID, name, OBJPROP_FONT, ObjFont);

						}

						else

						{

							Print(__FUNCTION__, ": failed to create text object! Error code = ", GetLastError());

						}

					}

					else

					{

						if (textlbl == "")

						{

							ObjectDelete(ObjChartID, namelbl);

							ObjectDelete(ObjChartID, name);

							continue;

						}

					}

		

					ObjY  = (int)(ObjY + ObjFontSize + ObjFontSize/2);

		

					//-- update label objects

					ObjectSetInteger(ObjChartID, namelbl, OBJPROP_XDISTANCE, ObjX);

					ObjectSetInteger(ObjChartID, namelbl, OBJPROP_YDISTANCE, ObjY);

					ObjectSetString(ObjChartID, namelbl, OBJPROP_TEXT, (string)textlbl);

		

					//-- update value objects

					int x        = 0;

					int xsizelbl = (int)ObjectGetInteger(ObjChartID, namelbl, OBJPROP_XSIZE);

		

					if (xsizelbl == 0) {

						//-- when the object is newly created, it returns 0 for XSIZE and YSIZE, so here we will trick it somehow

						xsizelbl = (int)(StringLen((string)textlbl) * ObjFontSize / 1.5 + ObjFontSize / 2);

					}

		

					x = ObjX + (xsizelbl + ObjFontSize/2);

		

					ObjectSetInteger(ObjChartID, name, OBJPROP_XDISTANCE, x);

					ObjectSetInteger(ObjChartID, name, OBJPROP_YDISTANCE, ObjY);

					ObjectSetString(ObjChartID, name, OBJPROP_TEXT, (string)text);

				}

				

				ChartRedraw();

			}

		

			initialized = true;

		}

		

		_callback_(1);

	}

};



// "Draw Shape" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename _T5_,typename T6,typename _T6_,typename T7,typename _T7_,typename T8,typename _T8_,typename T9,typename _T9_,typename T10,typename _T10_,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27>

class MDL_ChartDrawShape: public BlockCalls

{

	public: /* Input Parameters */

	T1 ObjectPerBar;

	T2 ObjectUpdate;

	T3 ObjName;

	T4 ObjectType;

	T5 ObjTime1; virtual _T5_ _ObjTime1_(){return(_T5_)0;}

	T6 ObjPrice1; virtual _T6_ _ObjPrice1_(){return(_T6_)0;}

	T7 ObjTime2; virtual _T7_ _ObjTime2_(){return(_T7_)0;}

	T8 ObjPrice2; virtual _T8_ _ObjPrice2_(){return(_T8_)0;}

	T9 ObjTime3; virtual _T9_ _ObjTime3_(){return(_T9_)0;}

	T10 ObjPrice3; virtual _T10_ _ObjPrice3_(){return(_T10_)0;}

	T11 ObjX;

	T12 ObjY;

	T13 ObjFill;

	T14 ObjXsize;

	T15 ObjYsize;

	T16 ObjBorderType;

	T17 ObjBgColor;

	T18 ObjCorner;

	T19 ObjColor;

	T20 ObjStyle;

	T21 ObjWidth;

	T22 ObjBack;

	T23 ObjSelectable;

	T24 ObjSelected;

	T25 ObjHidden;

	T26 ObjZorder;

	T27 ObjChartSubWindow;

	/* Static Parameters */

	int count;

	datetime time0;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_ChartDrawShape()

	{

		ObjectPerBar = (bool)true;

		ObjectUpdate = (bool)true;

		ObjName = (string)"";

		ObjectType = (ENUM_OBJECT)OBJ_RECTANGLE;

		ObjX = (int)10;

		ObjY = (int)10;

		ObjFill = (bool)false;

		ObjXsize = (int)100;

		ObjYsize = (int)100;

		ObjBorderType = (int)BORDER_FLAT;

		ObjBgColor = (color)clrSkyBlue;

		ObjCorner = (int)CORNER_LEFT_UPPER;

		ObjColor = (color)clrDeepPink;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

		ObjWidth = (int)1;

		ObjBack = (bool)false;

		ObjSelectable = (bool)true;

		ObjSelected = (bool)false;

		ObjHidden = (bool)false;

		ObjZorder = (int)0;

		ObjChartSubWindow = (string)"";

		/* Static Parameters (initial value) */

		count =  0;

		time0 =  0;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		string ObjNamePrefix = "fxd_shape_";

		long ObjChartID      = 0;

		int subwindow_id     = WindowFindVisible(ObjChartID, ObjChartSubWindow);

		

		if (subwindow_id >= 0)

		{

			string name       = "";

			string name_base  = "";

			bool get_new_name = false;

			bool do_update    = true;

		

			if (ObjectPerBar == true)

			{

				datetime time = iTime(Symbol(),0,1);

		

				if (time0 < time)

				{

					time0        = time;

					get_new_name = true;

				}

				else

				{

					if (ObjectUpdate == false) {do_update = false;}

				}

			}

			else

			{

				if (ObjectUpdate == false) {get_new_name = true;}

			}

		

			if (do_update)

			{

				if (ObjName != "") {name_base = ObjName;} else {name_base = ObjNamePrefix + __block_user_number + "_";}

		

				if (get_new_name == false)

				{

					name = name_base + IntegerToString(count);

				}

				else

				{

					while (true)

					{

						count++;

						name = name_base + IntegerToString(count);

		

						if (ObjectFind(ObjChartID,name) < 0) {break;}

					}

				}

		

				if (ObjName != "" && count == 0) {name = ObjName;}

		

				if (ObjectFind(ObjChartID,name) < 0 && !ObjectCreate(ObjChartID,name,(ENUM_OBJECT)ObjectType,subwindow_id,0,0))

				{

					Print(__FUNCTION__,": failed to create shape object! Error code = ",GetLastError());

				}

		

				double p1=0, p2=0, p3=0;

				datetime t1=0, t2=0, t3=0;

		

				switch(ObjectType)

				{

					case OBJ_RECTANGLE_LABEL : {break;}

					case OBJ_RECTANGLE       : {t1=1; p1=1; t2=1; p2=1; break;}

					case OBJ_TRIANGLE        : {t1=1; p1=1; t2=1; p2=1; t3=1; p3=1; break;}

					case OBJ_ELLIPSE         : {t1=1; p1=1; t2=1; p2=1; t3=1; p3=1; break;}

				}

		

				if (t1 == 1) {t1 = _ObjTime1_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,t1);}

				if (t2 == 1) {t2 = _ObjTime2_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,1,t2);}

				if (t3 == 1) {t3 = _ObjTime3_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,2,t3);}

				if (p1 == 1) {p1 = _ObjPrice1_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,p1);}

				if (p2 == 1) {p2 = _ObjPrice2_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,1,p2);}

				if (p3 == 1) {p3 = _ObjPrice3_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,2,p3);}

		

				if (ObjectType==OBJ_RECTANGLE_LABEL) {

					ObjectSetInteger(ObjChartID,name,OBJPROP_XDISTANCE,ObjX);

					ObjectSetInteger(ObjChartID,name,OBJPROP_YDISTANCE,ObjY);

					ObjectSetInteger(ObjChartID,name,OBJPROP_XSIZE,ObjXsize);

					ObjectSetInteger(ObjChartID,name,OBJPROP_YSIZE,ObjYsize);

					ObjectSetInteger(ObjChartID,name,OBJPROP_BGCOLOR,ObjBgColor);

					ObjectSetInteger(ObjChartID,name,OBJPROP_BORDER_TYPE,ObjBorderType);

					ObjectSetInteger(ObjChartID,name,OBJPROP_CORNER,ObjCorner);

				}

				else

				{

					ObjectSetInteger(ObjChartID,name,OBJPROP_FILL,ObjFill);

				}

		

				ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);

				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);

				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);

				ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);

				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,ObjSelectable);

				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,ObjSelected);

				ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,ObjHidden);

				ObjectSetInteger(ObjChartID,name,OBJPROP_ZORDER,ObjZorder);

		

				ChartRedraw();

			}

		}

		

		_callback_(1);

	}

};



// "Delete objects" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6>

class MDL_ChartDeleteObjects: public BlockCalls

{

	public: /* Input Parameters */

	T1 NameStartsWith;

	T2 NameContains;

	T3 ObjColor;

	T4 SortMode;

	T5 MaxObjects;

	T6 SkipObjects;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_ChartDeleteObjects()

	{

		NameStartsWith = (string)"";

		NameContains = (string)"";

		ObjColor = (color)EMPTY_VALUE;

		SortMode = (string)"z-a";

		MaxObjects = (int)0;

		SkipObjects = (int)0;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		// TODO: Combine "a-z" and "z-a" loops into one loop

		// TODO: Fix the problem with "Any color" and the EMPTY_VALUE value

		

		int index         = 0;

		int total         = ObjectsTotal(0,-1,-1);

		int length        = 0;

		bool deleted      = false;

		int deleted_count = 0;

		int skipped_count = 0;

		string name       = "";

		

		if (SortMode == "a-z")

		{

			for (index=0; index<total; index++)

			{

				name = ObjectName(0,index);

		

				if (name != "")

				{

					if (MaxObjects > 0 && deleted_count >= MaxObjects) {break;}

		

					deleted = false;

		

					// ObjColor != clrBlack below is because in MQL5 when the value is EMPTY_VALUE, it is turned into clrBlack because of the data type

					if (ObjColor != EMPTY_VALUE && ObjColor != clrBlack && ObjectGetInteger(0, name, OBJPROP_COLOR) != ObjColor) {continue;}

		

					if (NameStartsWith == "" && NameContains == "")

					{

						if (SkipObjects > 0 && skipped_count < SkipObjects)

						{

							skipped_count++;

							continue;

						}

		

						if (ObjectDelete(0,name))

						{

							deleted_count++;

						}

					}

					else

					{

						if (NameStartsWith != "")

						{

							length = StringLen(NameStartsWith);

		

							if (StringSubstr(name,0,length) == NameStartsWith)

							{

								if (SkipObjects > 0 && skipped_count < SkipObjects)

								{

									skipped_count++;

									continue;

								}

		

								if (ObjectDelete(0,name))

								{

									deleted_count++;

								}

							}

						}

		

						if (deleted == false && NameContains != "")

						{

							if (StringFind(name,NameContains,0) > -1)

							{

								if (SkipObjects > 0 && skipped_count < SkipObjects)

								{

									skipped_count++;

									continue;

								}

		

								if (ObjectDelete(0,name))

								{

									deleted_count++;

								}

							}

						}

					}

				}

			}

		}

		else if (SortMode == "z-a")

		{

			for (index=total-1; index>=0; index--)

			{

				name = ObjectName(0,index);

		

				if (name != "")

				{

					if (MaxObjects > 0 && deleted_count >= MaxObjects) {break;}

		

					deleted = false;

		

					// ObjColor != clrBlack below is because in MQL5 when the value is EMPTY_VALUE, it is turned into clrBlack because of the data type

					if (ObjColor != EMPTY_VALUE && ObjColor != clrBlack && ObjectGetInteger(0, name, OBJPROP_COLOR) != ObjColor) {continue;}

		

					if (NameStartsWith == "" && NameContains == "")

					{

						if (SkipObjects > 0 && skipped_count < SkipObjects)

						{

							skipped_count++;

							continue;

						}

		

						if (ObjectDelete(0,name))

						{

							deleted_count++;

						}

					}

					else

					{

						if (NameStartsWith != "")

						{

							length = StringLen(NameStartsWith);

		

							if (StringSubstr(name,0,length) == NameStartsWith)

							{

								if (SkipObjects > 0 && skipped_count < SkipObjects)

								{

									skipped_count++;

									continue;

								}

		

								if (ObjectDelete(0,name))

								{

									deleted_count++;

								}

							}

						}

		

						if (deleted == false && NameContains != "")

						{

							if (StringFind(name,NameContains,0) > -1)

							{

								if (SkipObjects > 0 && skipped_count < SkipObjects)

								{

									skipped_count++;

									continue;

								}

		

								if (ObjectDelete(0,name))

								{

									deleted_count++;

								}

							}

						}

					}

				}

			}

		}

		

		if (deleted_count > 0)

		{

			ChartRedraw();

		}

		

		_callback_(1);

	}

};



// "Draw Text" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename _T5_,typename T6,typename _T6_,typename T7,typename T8,typename T9,typename _T9_,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21>

class MDL_ChartDrawText: public BlockCalls

{

	public: /* Input Parameters */

	T1 ObjectPerBar;

	T2 ObjectUpdate;

	T3 ObjName;

	T4 ObjectType;

	T5 ObjTime1; virtual _T5_ _ObjTime1_(){return(_T5_)0;}

	T6 ObjPrice1; virtual _T6_ _ObjPrice1_(){return(_T6_)0;}

	T7 ObjX;

	T8 ObjY;

	T9 ObjText; virtual _T9_ _ObjText_(){return(_T9_)0;}

	T10 ObjFont;

	T11 ObjFontSize;

	T12 ObjAngle;

	T13 ObjCorner;

	T14 ObjAnchor;

	T15 ObjColor;

	T16 ObjBack;

	T17 ObjSelectable;

	T18 ObjSelected;

	T19 ObjHidden;

	T20 ObjZorder;

	T21 ObjChartSubWindow;

	/* Static Parameters */

	int count;

	datetime time0;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_ChartDrawText()

	{

		ObjectPerBar = (bool)true;

		ObjectUpdate = (bool)true;

		ObjName = (string)"";

		ObjectType = (ENUM_OBJECT)OBJ_TEXT;

		ObjX = (int)0;

		ObjY = (int)0;

		ObjFont = (string)"Arial";

		ObjFontSize = (int)10;

		ObjAngle = (double)0.0;

		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;

		ObjAnchor = (int)ANCHOR_LEFT_UPPER;

		ObjColor = (color)clrSkyBlue;

		ObjBack = (bool)false;

		ObjSelectable = (bool)true;

		ObjSelected = (bool)false;

		ObjHidden = (bool)false;

		ObjZorder = (int)0;

		ObjChartSubWindow = (string)"";

		/* Static Parameters (initial value) */

		count =  0;

		time0 =  0;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		string ObjNamePrefix = "fxd_text_";

		long ObjChartID      = 0;

		int subwindow_id     = WindowFindVisible(ObjChartID, ObjChartSubWindow);

		

		if (subwindow_id >= 0)

		{

			string name       = "";

			string name_base  = "";

			bool get_new_name = false;

			bool do_update    = true;

		

			if (ObjectPerBar == true)

			{

				datetime time = iTime(Symbol(),0,1);

		

				if (time0 < time)

				{

					time0        = time;

					get_new_name = true;

				}

				else

				{

					if (ObjectUpdate == false) {do_update = false;}

				}

			}

			else

			{

				if (ObjectUpdate == false) {get_new_name = true;}

			}

		

			if (do_update)

			{

				if (ObjName != "") {name_base = ObjName;} else {name_base = ObjNamePrefix + __block_user_number + "_";}

		

				if (get_new_name == false)

				{

					name = name_base + IntegerToString(count);

				}

				else

				{

					while (true)

					{

						count++;

						name = name_base + IntegerToString(count);

		

						if (ObjectFind(ObjChartID,name) < 0) {break;}

					}

				}

		

				if (ObjName != "" && count == 0) {name = ObjName;}

		

				if (ObjectFind(ObjChartID,name) < 0 && !ObjectCreate(ObjChartID,name,(ENUM_OBJECT)ObjectType,subwindow_id,0,0))

				{

					Print(__FUNCTION__,": failed to create text object! Error code = ",GetLastError());

				}

				

				double p1=0, p2=0;

				datetime t1=0, t2=0;

		

				if (ObjectType == OBJ_TEXT)

				{

					ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,(long)_ObjTime1_());

					ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,(double)_ObjPrice1_());

				}

				else

				{

					ObjectSetInteger(ObjChartID,name,OBJPROP_XDISTANCE,ObjX);

					ObjectSetInteger(ObjChartID,name,OBJPROP_YDISTANCE,ObjY);

				}

		

				ObjectSetString(ObjChartID,name,OBJPROP_TEXT,(string)(_ObjText_()));

				ObjectSetString(ObjChartID,name,OBJPROP_FONT,ObjFont);

				ObjectSetInteger(ObjChartID,name,OBJPROP_FONTSIZE,ObjFontSize);

				ObjectSetDouble(ObjChartID,name,OBJPROP_ANGLE,ObjAngle);

				ObjectSetInteger(ObjChartID,name,OBJPROP_CORNER,ObjCorner);

				ObjectSetInteger(ObjChartID,name,OBJPROP_ANCHOR,ObjAnchor);

		

				//ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);

				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);

				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);

				//ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);

				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,ObjSelectable);

				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,ObjSelected);

				ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,ObjHidden);

				ObjectSetInteger(ObjChartID,name,OBJPROP_ZORDER,ObjZorder);

		

				ChartRedraw();

			}

		}

		

		_callback_(1);

	}

};



// "Draw Line" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename _T5_,typename T6,typename _T6_,typename T7,typename _T7_,typename T8,typename _T8_,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21>

class MDL_ChartDrawLine: public BlockCalls

{

	public: /* Input Parameters */

	T1 ObjectPerBar;

	T2 ObjectUpdate;

	T3 ObjName;

	T4 ObjectType;

	T5 ObjTime1; virtual _T5_ _ObjTime1_(){return(_T5_)0;}

	T6 ObjPrice1; virtual _T6_ _ObjPrice1_(){return(_T6_)0;}

	T7 ObjTime2; virtual _T7_ _ObjTime2_(){return(_T7_)0;}

	T8 ObjPrice2; virtual _T8_ _ObjPrice2_(){return(_T8_)0;}

	T9 ObjAngle;

	T10 ObjRay;

	T11 ObjRayLeft;

	T12 ObjRayRight;

	T13 ObjColor;

	T14 ObjStyle;

	T15 ObjWidth;

	T16 ObjBack;

	T17 ObjSelectable;

	T18 ObjSelected;

	T19 ObjHidden;

	T20 ObjZorder;

	T21 ObjChartSubWindow;

	/* Static Parameters */

	int count;

	datetime time0;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_ChartDrawLine()

	{

		ObjectPerBar = (bool)true;

		ObjectUpdate = (bool)true;

		ObjName = (string)"";

		ObjectType = (ENUM_OBJECT)OBJ_VLINE;

		ObjAngle = (double)45.0;

		ObjRay = (bool)true;

		ObjRayLeft = (bool)false;

		ObjRayRight = (bool)false;

		ObjColor = (color)clrDeepPink;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

		ObjWidth = (int)1;

		ObjBack = (bool)false;

		ObjSelectable = (bool)true;

		ObjSelected = (bool)false;

		ObjHidden = (bool)false;

		ObjZorder = (int)0;

		ObjChartSubWindow = (string)"";

		/* Static Parameters (initial value) */

		count =  0;

		time0 =  0;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		string ObjNamePrefix = "fxd_line_";

		long ObjChartID      = 0;

		int subwindow_id     = WindowFindVisible(ObjChartID, ObjChartSubWindow);

		

		if (subwindow_id >= 0)

		{

			string name       = "";

			string name_base  = "";

			bool get_new_name = false;

			bool do_update    = true;

		

			if (ObjectPerBar == true)

			{

				datetime time = iTime(Symbol(),0,1);

		

				if (time0 < time)

				{

					time0        = time;

					get_new_name = true;

				}

				else

				{

					if (ObjectUpdate == false) {do_update = false;}

				}

			}

			else

			{

				if (ObjectUpdate == false) {get_new_name = true;}

			}

		

			if (do_update)

			{

				if (ObjName != "") {name_base = ObjName;} else {name_base = ObjNamePrefix + __block_user_number + "_";}

		

				if (get_new_name == false)

				{

					name = name_base + IntegerToString(count);

				}

				else

				{

					while (true)

					{

						count++;

						name = name_base + IntegerToString(count);

		

						if (ObjectFind(ObjChartID,name) < 0) {break;}

					}

				}

		

				if (ObjName != "" && count == 0) {name = ObjName;}

		

				if (ObjectFind(ObjChartID,name) < 0 && !ObjectCreate(ObjChartID,name,(ENUM_OBJECT)ObjectType,subwindow_id,0,0))

				{

					Print(__FUNCTION__,": failed to create line object! Error code = ",GetLastError());

				}

		

				double p1=0, p2=0;

				datetime t1=0, t2=0;

		

				switch(ObjectType)

				{

					case OBJ_VLINE        : {t1=1; break;}

					case OBJ_HLINE        : {p1=1; break;}

					case OBJ_TREND        : {t1=1; p1=1; t2=1; p2=1; break;}

					case OBJ_TRENDBYANGLE : {t1=1; p1=1; break;}

					case OBJ_CYCLES       : {t1=1; p1=1; t2=1; p2=1; break;}

				}

		

				if (t1 == 1) {t1 = _ObjTime1_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,0,t1);}

				if (t2 == 1) {t2 = _ObjTime2_(); ObjectSetInteger(ObjChartID,name,OBJPROP_TIME,1,t2);}

				if (p1 == 1) {p1 = _ObjPrice1_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,0,p1);}

				if (p2 == 1) {p2 = _ObjPrice2_(); ObjectSetDouble(ObjChartID,name,OBJPROP_PRICE,1,p2);}

		

				ObjectSetInteger(ObjChartID,name,OBJPROP_STYLE,ObjStyle);

				ObjectSetInteger(ObjChartID,name,OBJPROP_COLOR,ObjColor);

				ObjectSetInteger(ObjChartID,name,OBJPROP_BACK,ObjBack);

				ObjectSetInteger(ObjChartID,name,OBJPROP_WIDTH,ObjWidth);

				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTABLE,ObjSelectable);

				ObjectSetInteger(ObjChartID,name,OBJPROP_SELECTED,ObjSelected);

				ObjectSetInteger(ObjChartID,name,OBJPROP_HIDDEN,ObjHidden);

				ObjectSetInteger(ObjChartID,name,OBJPROP_ZORDER,ObjZorder);

		

				ObjectSetDouble(ObjChartID,name,OBJPROP_ANGLE,ObjAngle);

				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY,ObjRay);

				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY_LEFT,ObjRayLeft);

				ObjectSetInteger(ObjChartID,name,OBJPROP_RAY_RIGHT,ObjRayRight);

		

				ChartRedraw();

			}

		}

		

		_callback_(1);

	}

};



// "Indicator is visible" model

template<typename T1,typename _T1_,typename T2,typename T3>

class MDL_IndicatorIsVisible: public BlockCalls

{

	public: /* Input Parameters */

	T1 Indicator; virtual _T1_ _Indicator_(){return(_T1_)0;}

	T2 AdditionalCandles;

	T3 ExceptionCandles;

	/* Static Parameters */

	int itf;

	string isymbol;

	datetime bartime;

	bool lastpass;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_IndicatorIsVisible()

	{

		AdditionalCandles = (int)0;

		ExceptionCandles = (int)0;

		/* Static Parameters (initial value) */

		itf =  0;

		isymbol =  "";

		bartime =  0;

		lastpass =  false;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		bool next      = true;

		int exceptions = 0;

		

		for (int i=0; i <= AdditionalCandles; i++)

		{

			FXD_MORE_SHIFT = i;

			_T1_ ivalue=_Indicator_();

			FXD_MORE_SHIFT = 0; // reset

			

			if (ivalue == 0 || ivalue == EMPTY_VALUE || ivalue == -EMPTY_VALUE)

			{

				if (AdditionalCandles > 0 && ExceptionCandles > 0)

				{

					exceptions++;

		

					if (exceptions <= ExceptionCandles) {continue;}

				}

		

				next = false;

				break;

			}

		}

		

		lastpass = next;

		

		if (next == true) {_callback_(1);} else {_callback_(0);}

	}

};



// "Modify Variables" model

template<typename T1,typename T2,typename _T2_,typename T3,typename T4,typename _T4_,typename T5,typename T6,typename _T6_,typename T7,typename T8,typename _T8_,typename T9,typename T10,typename _T10_>

class MDL_ModifyVariables: public BlockCalls

{

	public: /* Input Parameters */

	T1 Variable1;

	T2 Value1; virtual _T2_ _Value1_(){return(_T2_)0;}

	T3 Variable2;

	T4 Value2; virtual _T4_ _Value2_(){return(_T4_)0;}

	T5 Variable3;

	T6 Value3; virtual _T6_ _Value3_(){return(_T6_)0;}

	T7 Variable4;

	T8 Value4; virtual _T8_ _Value4_(){return(_T8_)0;}

	T9 Variable5;

	T10 Value5; virtual _T10_ _Value5_(){return(_T10_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_ModifyVariables()

	{

		Variable1 = (int)0;

		Variable2 = (int)0;

		Variable3 = (int)0;

		Variable4 = (int)0;

		Variable5 = (int)0;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		// nothing here, because the actual code is generated in the generator

		// _Value1_()

		// _Value2_()

		// _Value3_()

		// _Value4_()

		// _Value5_()

		_callback_(1);

	}

};



// "Check distance" model

template<typename T1,typename _T1_,typename T2,typename _T2_,typename T3,typename T4,typename T5,typename _T5_>

class MDL_CheckDistance: public BlockCalls

{

	public: /* Input Parameters */

	T1 UpperLevel; virtual _T1_ _UpperLevel_(){return(_T1_)0;}

	T2 LowerLevel; virtual _T2_ _LowerLevel_(){return(_T2_)0;}

	T3 DistanceIsAbsolute;

	T4 CompareDistance;

	T5 dDistance; virtual _T5_ _dDistance_(){return(_T5_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_CheckDistance()

	{

		DistanceIsAbsolute = (bool)false;

		CompareDistance = (string)">";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		double upper_level = _UpperLevel_();

		double lower_level = _LowerLevel_();

		double distance    = _dDistance_();

		

		double diff = upper_level - lower_level;

		

		if (DistanceIsAbsolute == true && diff < 0)

		{

			diff = -1 * diff;

		}

		

		if (CompareValues(CompareDistance, diff, distance)) {_callback_(1);} else {_callback_(0);}

	}

};



// "Delete pending orders" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7>

class MDL_DeletePendingOrders: public BlockCalls

{

	public: /* Input Parameters */

	T1 GroupMode;

	T2 Group;

	T3 SymbolMode;

	T4 Symbol;

	T5 BuysOrSells;

	T6 LimitsOrStops;

	T7 ArrowColor;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_DeletePendingOrders()

	{

		GroupMode = (string)"group";

		Group = (string)"";

		SymbolMode = (string)"symbol";

		Symbol = (string)CurrentSymbol();

		BuysOrSells = (string)"both";

		LimitsOrStops = (string)"both";

		ArrowColor = (color)clrDeepPink;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		for (int index = OrdersTotal()-1; index >= 0; index--)

		{

			if (PendingOrderSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells, LimitsOrStops))

			{

				DeleteOrder(OrderTicket(), ArrowColor);

			}

		}

		

		_callback_(1);

	}

};



// "Buy pending order" model

template<typename T1,typename T2,typename T3,typename T4,typename _T4_,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename _T12_,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename _T27_,typename T28,typename _T28_,typename T29,typename _T29_,typename T30,typename T31,typename T32,typename T33,typename T34,typename _T34_,typename T35,typename _T35_,typename T36,typename _T36_,typename T37,typename T38,typename T39,typename T40,typename T41,typename _T41_,typename T42,typename T43,typename T44,typename T45>

class MDL_BuyPending: public BlockCalls

{

	public: /* Input Parameters */

	T1 Group;

	T2 Symbol;

	T3 Price;

	T4 dPrice; virtual _T4_ _dPrice_(){return(_T4_)0;}

	T5 PriceOffset;

	T6 VolumeMode;

	T7 VolumeSize;

	T8 VolumeSizeRisk;

	T9 VolumeRisk;

	T10 VolumePercent;

	T11 VolumeBlockPercent;

	T12 dVolumeSize; virtual _T12_ _dVolumeSize_(){return(_T12_)0;}

	T13 FixedRatioUnitSize;

	T14 FixedRatioDelta;

	T15 mmMgInitialLots;

	T16 mmMgMultiplyOnLoss;

	T17 mmMgMultiplyOnProfit;

	T18 mmMgAddLotsOnLoss;

	T19 mmMgAddLotsOnProfit;

	T20 mmMgResetOnLoss;

	T21 mmMgResetOnProfit;

	T22 VolumeUpperLimit;

	T23 StopLossMode;

	T24 StopLossPips;

	T25 StopLossPercentPrice;

	T26 StopLossPercentTP;

	T27 dlStopLoss; virtual _T27_ _dlStopLoss_(){return(_T27_)0;}

	T28 dpStopLoss; virtual _T28_ _dpStopLoss_(){return(_T28_)0;}

	T29 ddStopLoss; virtual _T29_ _ddStopLoss_(){return(_T29_)0;}

	T30 TakeProfitMode;

	T31 TakeProfitPips;

	T32 TakeProfitPercentPrice;

	T33 TakeProfitPercentSL;

	T34 dlTakeProfit; virtual _T34_ _dlTakeProfit_(){return(_T34_)0;}

	T35 ddTakeProfit; virtual _T35_ _ddTakeProfit_(){return(_T35_)0;}

	T36 dpTakeProfit; virtual _T36_ _dpTakeProfit_(){return(_T36_)0;}

	T37 ExpMode;

	T38 ExpDays;

	T39 ExpHours;

	T40 ExpMinutes;

	T41 dExp; virtual _T41_ _dExp_(){return(_T41_)0;}

	T42 CreateOCO;

	T43 Slippage;

	T44 MyComment;

	T45 ArrowColorBuy;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_BuyPending()

	{

		Group = (string)"";

		Symbol = (string)CurrentSymbol();

		Price = (string)"ask";

		PriceOffset = (double)20.0;

		VolumeMode = (string)"fixed";

		VolumeSize = (double)0.1;

		VolumeSizeRisk = (double)50.0;

		VolumeRisk = (double)2.5;

		VolumePercent = (double)100.0;

		VolumeBlockPercent = (double)3.0;

		FixedRatioUnitSize = (double)0.01;

		FixedRatioDelta = (double)20.0;

		mmMgInitialLots = (double)0.1;

		mmMgMultiplyOnLoss = (double)2.0;

		mmMgMultiplyOnProfit = (double)1.0;

		mmMgAddLotsOnLoss = (double)0.0;

		mmMgAddLotsOnProfit = (double)0.0;

		mmMgResetOnLoss = (int)0;

		mmMgResetOnProfit = (int)1;

		VolumeUpperLimit = (double)0.0;

		StopLossMode = (string)"fixed";

		StopLossPips = (double)50.0;

		StopLossPercentPrice = (double)0.55;

		StopLossPercentTP = (double)100.0;

		TakeProfitMode = (string)"fixed";

		TakeProfitPips = (double)50.0;

		TakeProfitPercentPrice = (double)0.55;

		TakeProfitPercentSL = (double)100.0;

		ExpMode = (string)"GTC";

		ExpDays = (int)0;

		ExpHours = (int)1;

		ExpMinutes = (int)0;

		CreateOCO = (int)0;

		Slippage = (ulong)4;

		MyComment = (string)"";

		ArrowColorBuy = (color)clrBlue;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		//-- open price -------------------------------------------------------------

		double op = 0;

		

		     if (Price == "ask")     {op = SymbolAsk(Symbol);}

		else if (Price == "bid")     {op = SymbolBid(Symbol);}

		else if (Price == "mid")     {op = (SymbolAsk(Symbol)+SymbolBid(Symbol))/2;}

		else if (Price == "dynamic") {op = _dPrice_();}

		

		op = op + toDigits(PriceOffset, Symbol);

		

		//-- stops ------------------------------------------------------------------

		double sll = 0, slp = 0, tpl = 0, tpp = 0;

		

		     if (StopLossMode == "fixed")         {slp = StopLossPips;}

		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}

		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}

		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}

		else if (StopLossMode == "percentPrice")  {sll = op - (op * StopLossPercentPrice / 100);}

		

		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}

		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}

		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}

		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}

		else if (TakeProfitMode == "percentPrice")  {tpl = op + (op * TakeProfitPercentPrice / 100);}

		

		if (StopLossMode == "percentTP")

		{

			if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}

			if (tpl > 0) {slp = toPips(MathAbs(op - tpl), Symbol)*StopLossPercentTP/100;}

		}

		

		if (TakeProfitMode == "percentSL")

		{

			if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}

			if (sll > 0) {tpp = toPips(MathAbs(op - sll), Symbol)*TakeProfitPercentSL/100;}

		}

		

		//-- lots -------------------------------------------------------------------

		double lots    = 0;

		double pre_sll = sll;

		

		if (pre_sll == 0) {pre_sll = op;}

		

		double pre_sl_pips = toPips(op-(pre_sll-toDigits(slp,Symbol)), Symbol);

		

		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}

		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}

		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}

		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, 0, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}

		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}

		

		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);

		

		//-- expiration -------------------------------------------------------------

		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());

		

		//-- send -------------------------------------------------------------------

		long ticket = BuyLater(Symbol,lots,op,sll,tpl,slp,tpp,Slippage,exp,(MagicStart+(int)Group),MyComment,ArrowColorBuy,CreateOCO);

		

		if (ticket > 0) {_callback_(1);} else {_callback_(0);}

	}

};



// "Log message" model

template<typename T1>

class MDL_PrintMessage: public BlockCalls

{

	public: /* Input Parameters */

	T1 PrintText;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_PrintMessage()

	{

		PrintText = (string)"Enter your text here";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		Print(PrintText);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_1: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_1()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::h4_fractal_count_down = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_2: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_2()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::up_subtract_down = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_3: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_3()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::half = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_4: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_4()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::h4_fractal_mid = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Spread Filter" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6>

class MDL_Spreadfilter: public BlockCalls

{

	public: /* Input Parameters */

	T1 Symbol;

	T2 SpreadCompare;

	T3 SpreadFilterMode;

	T4 maxSpread;

	T5 AvgSpreadPeriodSeconds;

	T6 AvgSpreadAdjust;

	/* Static Parameters */

	datetime utctime_data[];

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Spreadfilter()

	{

		Symbol = (string)CurrentSymbol();

		SpreadCompare = (string)"<";

		SpreadFilterMode = (string)"fixed";

		maxSpread = (double)5.0;

		AvgSpreadPeriodSeconds = (int)10;

		AvgSpreadAdjust = (double)0.0;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		// Array that holds UTC times

		static double	spreads_data[];   // Array that holds spreads

		static int		current_pos = -1; // Arrays are dynamic, this is the array index where the newest record is located

		static int		max_depth   = 50;	

		

		double compare_with_spread = 0;

		double current_spread      = SymbolInfoDouble(Symbol, SYMBOL_ASK)-SymbolInfoDouble(Symbol, SYMBOL_BID);

		int digits                 = (int)SymbolInfoInteger(Symbol, SYMBOL_DIGITS);

		

		if (SpreadFilterMode != "average")

		{

			compare_with_spread = toDigits(maxSpread, Symbol);

		}

		else

		{

			bool debug   = false;

			datetime now = TimeCurrent();

			int first_unassigned_address = 0;

		

			// What is the current amount of spread values that can be holded?

			int array_size = ArraySize(utctime_data);

		

			// Increase that amount if it is too small

			if (array_size < max_depth * 2)

			{

				first_unassigned_address = array_size;

				array_size               = max_depth * 2;

		

				if (debug) Print("Spread filter (block #",__block_user_number,"). Increasing buffer size to ",array_size," elements");

		

				ArrayResize(utctime_data, array_size);

				ArrayResize(spreads_data, array_size);

				

				// pre-assign some values, otherwise the arrays contain random values and can confuse the results

				for (int i = first_unassigned_address; i < array_size; i++)

				{

					utctime_data[i] = 0;

					spreads_data[i] = 0;

				}

			}

		

			// Update the position of the current spread value

			current_pos = current_pos + 1;

		

			if (current_pos >= array_size)

			{

				current_pos = 0;

			}

		

			// Update the database information

			utctime_data[current_pos] = now;

			spreads_data[current_pos] = NormalizeDouble(current_spread, digits);

		

			datetime old_time     = now - AvgSpreadPeriodSeconds; // This is the oldest time index to calculate average spread for. In database, we don't need older spreads_data.

			int pos               = current_pos + 1; // Initial position before the loop

			double avg_spread     = 0; // Average spread calculated

			int ticks             = 0; // How many spread values we have in database for the needed time AvgSpreadTimePeriodSeconds

			datetime diff_reached = 0; // If we didn't reach the oldest time we need in the whole database, this is the time difference between now and the oldest time recorded.

		

			if (debug) Print("============ tick ",FXD_TICKS_FROM_START," ============");

			

			while(!IsStopped())

			{

				// Oldest spread record is located at the next smallest array element

				pos = pos - 1;

		

				if (pos < 0) {pos = array_size - 1;}

				

				// This is the oldest array element, which is actually the current one + 1

				int next_pos = current_pos + 1;

		

				if (next_pos >= array_size)

				{

					next_pos = array_size - 1;

				}

				

				// Time record is empty

				if (utctime_data[pos] == 0)

				{

					if (pos == next_pos) {break;} // End of database - exit;

		

					continue; // In case of fresh added empty values at the physical end of the array, we need to skip them

				}

				

				// Reached oldest point - exit before calculations

				if (utctime_data[pos] < old_time) {break;}

				

				// Calculations

				ticks++;

				avg_spread += spreads_data[pos];

		

				if (debug) Print(utctime_data[pos], " => ", toPips(spreads_data[pos], Symbol), " pips");

				

				// End of database reached - obviously the array is too small

				if (pos == next_pos)

				{

					diff_reached = now - utctime_data[pos]; // The time range available in the database

		

					if (diff_reached == 0) {break;}

		

					ticks = ticks * (int)(AvgSpreadPeriodSeconds / diff_reached);

		

					if (debug) Print("Spread Filter (block #", __block_user_number, "). Buffer size will be increased to ", IntegerToString(ticks*2), " elements");

		

					break;

				}

			}

			

			avg_spread = (ticks > 0) ? avg_spread / ticks : current_spread;

			avg_spread = NormalizeDouble(avg_spread, digits);

		

			if (ticks > max_depth) {max_depth = ticks;}

			

			compare_with_spread = avg_spread + toDigits(AvgSpreadAdjust, Symbol);

			

			if (debug) Print("For the last ", AvgSpreadPeriodSeconds, " seconds the average spread is ", toPips(avg_spread, Symbol), " pips. It is calculated from ", ticks, " array elements.");

		}

		

		current_spread      = NormalizeDouble(current_spread, digits);

		compare_with_spread = NormalizeDouble(compare_with_spread, digits);

		

		if (CompareValues(SpreadCompare, current_spread, compare_with_spread)) {_callback_(1);} else {_callback_(0);}

	}

};



// "Once per bar" model

template<typename T1,typename T2,typename T3>

class MDL_OncePerBar: public BlockCalls

{

	public: /* Input Parameters */

	T1 Symbol;

	T2 Period;

	T3 PassMaxTimes;

	/* Static Parameters */

	string tokens[];

	int passes[];

	datetime old_values[];

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_OncePerBar()

	{

		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

		PassMaxTimes = (int)1;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		bool next    = false;

		string token = Symbol + IntegerToString(Period);

		int index    = ArraySearch(tokens, token);

		

		if (index == -1)

		{

			index = ArraySize(tokens);

			

			ArrayResize(tokens, index + 1);

			ArrayResize(old_values, index + 1);

			ArrayResize(passes, index + 1);

			

			tokens[index] = token;

			passes[index] = 0;

			old_values[index] = 0;

		}

		

		if (PassMaxTimes > 0)

		{

			// Sometimes CopyTime doesn't work properly. It happens when the history data is broken or something.

			// Then, CopyTime can't read any candles. It happens withing few candles only, but it's a problem that

			// I don't know how to fix. However, iTime() seems to work fine.

			datetime new_value = iTime(Symbol, Period, 1);

			

			if (new_value == 0) {

				Print("Failed to get the time from candle 1 on symbol ", Symbol, " and timeframe ", EnumToString((ENUM_TIMEFRAMES)Period), ". The history data needs to be fixed.");

			}

		

			if (new_value > old_values[index])

			{

				passes[index]++;

		

				if (passes[index] >= PassMaxTimes)

				{

					old_values[index]  = new_value;

					passes[index] = 0;

				}

		

				next = true;

			}

		}

		

		if (next) {_callback_(1);} else {_callback_(0);}

	}

};



// "If position" model

template<typename T1,typename T2,typename T3,typename T4,typename T5>

class MDL_IfOpenedOrders: public BlockCalls

{

	public: /* Input Parameters */

	T1 GroupMode;

	T2 Group;

	T3 SymbolMode;

	T4 Symbol;

	T5 BuysOrSells;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_IfOpenedOrders()

	{

		GroupMode = (string)"group";

		Group = (string)"";

		SymbolMode = (string)"symbol";

		Symbol = (string)CurrentSymbol();

		BuysOrSells = (string)"both";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		bool exist = false;

		

		for (int index = TradesTotal()-1; index >= 0; index--)

		{

			if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))

			{

				exist = true;

				break;

			}

		}

		

		if (exist == true) {_callback_(1);} else {_callback_(0);}

	}

};



// "Close positions" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8>

class MDL_CloseOpened: public BlockCalls

{

	public: /* Input Parameters */

	T1 GroupMode;

	T2 Group;

	T3 SymbolMode;

	T4 Symbol;

	T5 BuysOrSells;

	T6 OrderMinutes;

	T7 Slippage;

	T8 ArrowColor;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_CloseOpened()

	{

		GroupMode = (string)"group";

		Group = (string)"";

		SymbolMode = (string)"symbol";

		Symbol = (string)CurrentSymbol();

		BuysOrSells = (string)"both";

		OrderMinutes = (int)0;

		Slippage = (ulong)4;

		ArrowColor = (color)clrDeepPink;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		int closed_count = 0;

		bool finished    = false;

		

		while (finished == false)

		{

			int count = 0;

		

			for (int index = TradesTotal()-1; index >= 0; index--)

			{

				if (TradeSelectByIndex(index, GroupMode, Group, SymbolMode, Symbol, BuysOrSells))

				{

					datetime time_diff = TimeCurrent() - OrderOpenTime();

		

					if (time_diff < 0) {time_diff = 0;} // this actually happens sometimes

		

					if (time_diff >= 60 * OrderMinutes)

					{

						if (CloseTrade(OrderTicket(), Slippage, ArrowColor))

						{

							closed_count++;

						}

		

						count++;

					}

				}

			}

		

			if (count == 0) {finished = true;}

		}

		

		_callback_(1);

	}

};



// "Time filter" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23>

class MDL_TimeFilter: public BlockCalls

{

	public: /* Input Parameters */

	T1 ServerOrLocalTime;

	T2 TimeStartMode;

	T3 TimeStart;

	T4 TimeStartYear;

	T5 TimeStartMonth;

	T6 TimeStartDay;

	T7 TimeStartHour;

	T8 TimeStartMinute;

	T9 TimeStartSecond;

	T10 TimeEndMode;

	T11 TimeEnd;

	T12 TimeEndYear;

	T13 TimeEndMonth;

	T14 TimeEndDay;

	T15 TimeEndHour;

	T16 TimeEndMinute;

	T17 TimeEndSecond;

	T18 TimeEndRelYears;

	T19 TimeEndRelMonths;

	T20 TimeEndRelDays;

	T21 TimeEndRelHours;

	T22 TimeEndRelMinutes;

	T23 TimeEndRelSeconds;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_TimeFilter()

	{

		ServerOrLocalTime = (string)"server";

		TimeStartMode = (string)"text";

		TimeStart = (string)"00:00";

		TimeStartYear = (int)0;

		TimeStartMonth = (int)0;

		TimeStartDay = (double)0.0;

		TimeStartHour = (double)1.0;

		TimeStartMinute = (double)0.0;

		TimeStartSecond = (int)0;

		TimeEndMode = (string)"text";

		TimeEnd = (string)"00:01";

		TimeEndYear = (int)0;

		TimeEndMonth = (int)0;

		TimeEndDay = (double)0.0;

		TimeEndHour = (double)1.0;

		TimeEndMinute = (double)1.0;

		TimeEndSecond = (int)0;

		TimeEndRelYears = (int)0;

		TimeEndRelMonths = (int)0;

		TimeEndRelDays = (double)0.0;

		TimeEndRelHours = (double)0.0;

		TimeEndRelMinutes = (double)1.0;

		TimeEndRelSeconds = (int)0;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		datetime t0 = 0, t1 = 0, tx = 0, now = 0;

		int mode_time = 0;

		

		     if (ServerOrLocalTime == "server") {mode_time = 0; now = TimeCurrent();}

		else if (ServerOrLocalTime == "local")  {mode_time = 1; now = TimeLocal();}

		else if (ServerOrLocalTime == "gmt")    {mode_time = 2; now = TimeGMT();}

		

		//-- start time

		if (TimeStartMode == "text")

		{

			t0 = TimeFromString(mode_time, TimeStart);

		}

		else if (TimeStartMode == "component")

		{

			t0 = TimeFromComponents(mode_time, TimeStartYear, TimeStartMonth, TimeStartDay, TimeStartHour, TimeStartMinute, TimeStartSecond);

		}

		

		//-- end time

		if (TimeEndMode == "text")

		{

			t1 = TimeFromString(mode_time, TimeEnd);

		}

		else if (TimeEndMode == "component")

		{

			t1 = TimeFromComponents(mode_time, TimeEndYear, TimeEndMonth, TimeEndDay, TimeEndHour, TimeEndMinute, TimeEndSecond);

		}

		else if (TimeEndMode == "relative")

		{

			MqlDateTime tm;

			TimeToStruct(t0, tm);

		

			tm.year += TimeEndRelYears;

			tm.mon  += TimeEndRelMonths;

			tm.day  += (int)MathFloor(TimeEndRelDays);

			tm.hour += (int)(MathFloor(TimeEndRelHours) + (24 * (TimeEndRelDays - MathFloor(TimeEndRelDays))));

			tm.min  += (int)(MathFloor(TimeEndRelMinutes) + (60 * (TimeEndRelHours - MathFloor(TimeEndRelHours))));

			tm.sec  += (int)((double)TimeEndRelSeconds + (60 * (TimeEndRelMinutes - MathFloor(TimeEndRelMinutes))));

		

			t1 = StructToTime(tm);

		

			if (t1 < t0) {t1 = t1 + 86400;}

		}

		

		if ((now >= t0 && now < t1) || (t0 > t1 && (now >= t0 || now < t1))) {_callback_(1);} else {_callback_(0);}

	}

};



// "Sell pending order" model

template<typename T1,typename T2,typename T3,typename T4,typename _T4_,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11,typename T12,typename _T12_,typename T13,typename T14,typename T15,typename T16,typename T17,typename T18,typename T19,typename T20,typename T21,typename T22,typename T23,typename T24,typename T25,typename T26,typename T27,typename _T27_,typename T28,typename _T28_,typename T29,typename _T29_,typename T30,typename T31,typename T32,typename T33,typename T34,typename _T34_,typename T35,typename _T35_,typename T36,typename _T36_,typename T37,typename T38,typename T39,typename T40,typename T41,typename _T41_,typename T42,typename T43,typename T44,typename T45>

class MDL_SellPending: public BlockCalls

{

	public: /* Input Parameters */

	T1 Group;

	T2 Symbol;

	T3 Price;

	T4 dPrice; virtual _T4_ _dPrice_(){return(_T4_)0;}

	T5 PriceOffset;

	T6 VolumeMode;

	T7 VolumeSize;

	T8 VolumeSizeRisk;

	T9 VolumeRisk;

	T10 VolumePercent;

	T11 VolumeBlockPercent;

	T12 dVolumeSize; virtual _T12_ _dVolumeSize_(){return(_T12_)0;}

	T13 FixedRatioUnitSize;

	T14 FixedRatioDelta;

	T15 mmMgInitialLots;

	T16 mmMgMultiplyOnLoss;

	T17 mmMgMultiplyOnProfit;

	T18 mmMgAddLotsOnLoss;

	T19 mmMgAddLotsOnProfit;

	T20 mmMgResetOnLoss;

	T21 mmMgResetOnProfit;

	T22 VolumeUpperLimit;

	T23 StopLossMode;

	T24 StopLossPips;

	T25 StopLossPercentPrice;

	T26 StopLossPercentTP;

	T27 dlStopLoss; virtual _T27_ _dlStopLoss_(){return(_T27_)0;}

	T28 dpStopLoss; virtual _T28_ _dpStopLoss_(){return(_T28_)0;}

	T29 ddStopLoss; virtual _T29_ _ddStopLoss_(){return(_T29_)0;}

	T30 TakeProfitMode;

	T31 TakeProfitPips;

	T32 TakeProfitPercentPrice;

	T33 TakeProfitPercentSL;

	T34 dlTakeProfit; virtual _T34_ _dlTakeProfit_(){return(_T34_)0;}

	T35 ddTakeProfit; virtual _T35_ _ddTakeProfit_(){return(_T35_)0;}

	T36 dpTakeProfit; virtual _T36_ _dpTakeProfit_(){return(_T36_)0;}

	T37 ExpMode;

	T38 ExpDays;

	T39 ExpHours;

	T40 ExpMinutes;

	T41 dExp; virtual _T41_ _dExp_(){return(_T41_)0;}

	T42 CreateOCO;

	T43 Slippage;

	T44 MyComment;

	T45 ArrowColorSell;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_SellPending()

	{

		Group = (string)"";

		Symbol = (string)CurrentSymbol();

		Price = (string)"bid";

		PriceOffset = (double)20.0;

		VolumeMode = (string)"fixed";

		VolumeSize = (double)0.1;

		VolumeSizeRisk = (double)50.0;

		VolumeRisk = (double)2.5;

		VolumePercent = (double)100.0;

		VolumeBlockPercent = (double)3.0;

		FixedRatioUnitSize = (double)0.01;

		FixedRatioDelta = (double)20.0;

		mmMgInitialLots = (double)0.1;

		mmMgMultiplyOnLoss = (double)2.0;

		mmMgMultiplyOnProfit = (double)1.0;

		mmMgAddLotsOnLoss = (double)0.0;

		mmMgAddLotsOnProfit = (double)0.0;

		mmMgResetOnLoss = (int)0;

		mmMgResetOnProfit = (int)1;

		VolumeUpperLimit = (double)0.0;

		StopLossMode = (string)"fixed";

		StopLossPips = (double)50.0;

		StopLossPercentPrice = (double)0.55;

		StopLossPercentTP = (double)100.0;

		TakeProfitMode = (string)"fixed";

		TakeProfitPips = (double)50.0;

		TakeProfitPercentPrice = (double)0.55;

		TakeProfitPercentSL = (double)100.0;

		ExpMode = (string)"GTC";

		ExpDays = (int)0;

		ExpHours = (int)1;

		ExpMinutes = (int)0;

		CreateOCO = (int)0;

		Slippage = (ulong)4;

		MyComment = (string)"";

		ArrowColorSell = (color)clrRed;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		//-- open price -------------------------------------------------------------

		double op = 0;

		

		     if (Price == "ask")     {op = SymbolAsk(Symbol);}

		else if (Price == "bid")     {op = SymbolBid(Symbol);}

		else if (Price == "mid")     {op = (SymbolAsk(Symbol)+SymbolBid(Symbol))/2;}

		else if (Price == "dynamic") {op = _dPrice_();}

		

		op = op - toDigits(PriceOffset, Symbol);

		

		//-- stops ------------------------------------------------------------------

		double sll = 0, slp = 0, tpl = 0, tpp = 0;

		

		     if (StopLossMode == "fixed")         {slp = StopLossPips;}

		else if (StopLossMode == "dynamicPips")   {slp = _dpStopLoss_();}

		else if (StopLossMode == "dynamicDigits") {slp = toPips(_ddStopLoss_(),Symbol);}

		else if (StopLossMode == "dynamicLevel")  {sll = _dlStopLoss_();}

		else if (StopLossMode == "percentPrice")  {sll = op + (op * StopLossPercentPrice / 100);}

		

		     if (TakeProfitMode == "fixed")         {tpp = TakeProfitPips;}

		else if (TakeProfitMode == "dynamicPips")   {tpp = _dpTakeProfit_();}

		else if (TakeProfitMode == "dynamicDigits") {tpp = toPips(_ddTakeProfit_(),Symbol);}

		else if (TakeProfitMode == "dynamicLevel")  {tpl = _dlTakeProfit_();}

		else if (TakeProfitMode == "percentPrice")  {tpl = op - (op * TakeProfitPercentPrice / 100);}

		

		if (StopLossMode == "percentTP")

		{

			if (tpp > 0) {slp = tpp*StopLossPercentTP/100;}

			if (tpl > 0) {slp = toPips(MathAbs(op - tpl), Symbol)*StopLossPercentTP/100;}

		}

		

		if (TakeProfitMode == "percentSL")

		{

			if (slp > 0) {tpp = slp*TakeProfitPercentSL/100;}

			if (sll > 0) {tpp = toPips(MathAbs(op - sll), Symbol)*TakeProfitPercentSL/100;}

		}

		

		//-- lots -------------------------------------------------------------------

		double lots    = 0;

		double pre_sll = sll;

		

		if (pre_sll == 0) {pre_sll = op;}

		

		double pre_sl_pips = toPips((pre_sll+toDigits(slp,Symbol))-op, Symbol);

		

		     if (VolumeMode == "fixed")            {lots = DynamicLots(Symbol, VolumeMode, VolumeSize);}

		else if (VolumeMode == "block-equity")     {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "block-balance")    {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "block-freemargin") {lots = DynamicLots(Symbol, VolumeMode, VolumeBlockPercent);}

		else if (VolumeMode == "equity")           {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "balance")          {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "freemargin")       {lots = DynamicLots(Symbol, VolumeMode, VolumePercent);}

		else if (VolumeMode == "equityRisk")       {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "balanceRisk")      {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "freemarginRisk")   {lots = DynamicLots(Symbol, VolumeMode, VolumeRisk, pre_sl_pips);}

		else if (VolumeMode == "fixedRisk")        {lots = DynamicLots(Symbol, VolumeMode, VolumeSizeRisk, pre_sl_pips);}

		else if (VolumeMode == "fixedRatio")       {lots = DynamicLots(Symbol, VolumeMode, FixedRatioUnitSize, FixedRatioDelta);}

		else if (VolumeMode == "martingale")       {lots = BetMartingale(Group, Symbol, 0, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, mmMgAddLotsOnLoss, mmMgAddLotsOnProfit, mmMgResetOnLoss, mmMgResetOnProfit);}

		else if (VolumeMode == "dynamic")          {lots = _dVolumeSize_();}

		

		lots = AlignLots(Symbol, lots, 0, VolumeUpperLimit);

		

		//-- expiration -------------------------------------------------------------

		datetime exp = ExpirationTime(ExpMode,ExpDays,ExpHours,ExpMinutes,_dExp_());

		

		//-- send -------------------------------------------------------------------

		long ticket = SellLater(Symbol,lots,op,sll,tpl,slp,tpp,Slippage,exp,(MagicStart+(int)Group),MyComment,ArrowColorSell,CreateOCO);

		

		if (ticket > 0) {_callback_(1);} else {_callback_(0);}

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_5: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_5()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::ny_kz_candle_count = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "OR" model

class MDL_LogicalOR: public BlockCalls

{

	/* Static Parameters */

	int old_tick;

	virtual void _callback_(int r) {return;}



	public: /* The main method */

	virtual void _execute_()

	{

		int tickID = FXD_TICKS_FROM_START;

		

		if (old_tick != tickID)

		{

			old_tick = tickID;

		

		   _callback_(1);

		}

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_6: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_6()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::l_kz_candle_count = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_7: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_7()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::a_kz_candle_count = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Break even point" model

template<typename T1,typename T2,typename T3,typename T4,typename T5,typename T6,typename T7,typename T8,typename T9,typename T10,typename T11>

class MDL_BreakEvenPoint: public BlockCalls

{

	public: /* Input Parameters */

	T1 GroupMode;

	T2 Group;

	T3 SymbolMode;

	T4 Symbol;

	T5 BuysOrSells;

	T6 OnProfitMode;

	T7 OnProfitPips;

	T8 OnProfitPercentSL;

	T9 OnProfitPercentTP;

	T10 BEoffsetMode;

	T11 BEPoffsetPips;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_BreakEvenPoint()

	{

		GroupMode = (string)"group";

		Group = (string)"";

		SymbolMode = (string)"symbol";

		Symbol = (string)CurrentSymbol();

		BuysOrSells = (string)"both";

		OnProfitMode = (string)"fixed";

		OnProfitPips = (double)15.0;

		OnProfitPercentSL = (double)50.0;

		OnProfitPercentTP = (double)50.0;

		BEoffsetMode = (string)"none";

		BEPoffsetPips = (double)0.0;

	}



	public: /* The main method */

	virtual void _execute_()

	{

		for (int index = TradesTotal()-1; index >= 0; index--)

		{

			if (!TradeSelectByIndex(index,GroupMode,Group, SymbolMode,Symbol, BuysOrSells)) {continue;}

			

			string symbol   = OrderSymbol();

			double distance = 0;

		

			     if (OnProfitMode == "fixed")     {distance = toDigits(OnProfitPips,symbol);}

			else if (OnProfitMode == "percentSL") {distance = MathAbs(OrderOpenPrice()-attrStopLoss())*OnProfitPercentSL/100;}

			else if (OnProfitMode == "percentTP") {distance = MathAbs(OrderOpenPrice()-attrTakeProfit())*OnProfitPercentTP/100;}

		

			if (

				   (OrderType() == 0 && (SymbolInfoDouble(symbol,SYMBOL_ASK)-OrderOpenPrice() > distance) && (attrStopLoss() < OrderOpenPrice()))

				|| (OrderType() == 1 && (OrderOpenPrice()-SymbolInfoDouble(symbol,SYMBOL_BID) > distance) && ((attrStopLoss() > OrderOpenPrice()) || attrStopLoss() == 0))

			)

			{

				double be_offset = 0;

		

				if (BEoffsetMode == "pips")

				{

					be_offset = toDigits(BEPoffsetPips,symbol);

		

					if (OrderType() == 1) {be_offset = be_offset*(-1);}

				}

		

				ModifyStops(OrderTicket(), OrderOpenPrice()+be_offset, attrTakeProfit());

			}

		}

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_8: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_8()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::max_units = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_9: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_9()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::max_lot_size = formula(compare, lo, ro)-0.3;

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_10: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_10()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::h4_fractal_count_up = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_11: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_11()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::h4_fractal_up_2 = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_12: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_12()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::h4_fractal_down_2 = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_13: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_13()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::cur_fractal_count_down = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_14: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_14()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::cur_fractal_count_up = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_15: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_15()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::cur_fractal_down_2 = formula(compare, lo, ro);

		

		_callback_(1);

	}

};



// "Formula" model

template<typename T1,typename _T1_,typename T2,typename T3,typename _T3_>

class MDL_Formula_16: public BlockCalls

{

	public: /* Input Parameters */

	T1 Lo; virtual _T1_ _Lo_(){return(_T1_)0;}

	T2 compare;

	T3 Ro; virtual _T3_ _Ro_(){return(_T3_)0;}

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDL_Formula_16()

	{

		compare = (string)"+";

	}



	public: /* The main method */

	virtual void _execute_()

	{

		_T1_ lo = _Lo_();

		if (typename(_T1_) != "string" && MathAbs(lo) == EMPTY_VALUE) {return;}

		

		_T3_ ro = _Ro_();

		if (typename(_T3_) != "string" && MathAbs(ro) == EMPTY_VALUE) {return;}

		

		v::cur_fractal_up_2 = formula(compare, lo, ro);

		

		_callback_(1);

	}

};





//------------------------------------------------------------------------------------------------------------------------



// "Moving Average" model

class MDLIC_indicators_iMA

{

	public: /* Input Parameters */

	int MAperiod;

	int MAshift;

	ENUM_MA_METHOD MAmethod;

	ENUM_APPLIED_PRICE AppliedPrice;

	string Symbol;

	ENUM_TIMEFRAMES Period;

	int Shift;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_indicators_iMA()

	{

		MAperiod = (int)14;

		MAshift = (int)0;

		MAmethod = (ENUM_MA_METHOD)MODE_SMA;

		AppliedPrice = (ENUM_APPLIED_PRICE)PRICE_CLOSE;

		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

		Shift = (int)0;

	}



	public: /* The main method */

	double _execute_()

	{

		return iMA(Symbol, Period, MAperiod, MAshift, MAmethod, AppliedPrice, Shift + FXD_MORE_SHIFT);

	}

};



// "Candle" model

class MDLIC_candles_candles

{

	public: /* Input Parameters */

	string iOHLC;

	string ModeCandleFindBy;

	int CandleID;

	string TimeStamp;

	string Symbol;

	ENUM_TIMEFRAMES Period;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_candles_candles()

	{

		iOHLC = (string)"iClose";

		ModeCandleFindBy = (string)"id";

		CandleID = (int)0;

		TimeStamp = (string)"00:00";

		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}



	public: /* The main method */

	double _execute_()

	{

		int digits = (int)SymbolInfoInteger(Symbol, SYMBOL_DIGITS);

		

		double O[];

		double H[];

		double L[];

		double C[]; 

		long cTickVolume[];

		long cRealVolume[];

		datetime T[];

		

		double retval = EMPTY_VALUE;

		

		// candle's id will change, so we don't want to mess with the variable CandleID;

		int cID = CandleID;

		

		if (ModeCandleFindBy == "time")

		{

			cID = iCandleID(Symbol, Period, StringToTimeEx(TimeStamp, "server"));

		}

		

		cID = cID + FXD_MORE_SHIFT;

		

		//-- the common levels ----------------------------------------------------

		if (iOHLC == "iOpen")

		{

			if (CopyOpen(Symbol,Period,cID,1,O) > -1) retval = O[0];

		}

		else if (iOHLC == "iHigh")

		{

			if (CopyHigh(Symbol,Period,cID,1,H) > -1) retval = H[0];

		}

		else if (iOHLC == "iLow")

		{

			if (CopyLow(Symbol,Period,cID,1,L) > -1) retval = L[0];

		}

		else if (iOHLC == "iClose")

		{

			if (CopyClose(Symbol,Period,cID,1,C) > -1) retval = C[0];

		}

		

		//-- non-price values  ----------------------------------------------------

		else if (iOHLC == "iVolume" || iOHLC == "iTickVolume")

		{

			if (CopyTickVolume(Symbol,Period,cID,1,cTickVolume) > -1) retval = (double)cTickVolume[0];

			

			return retval;

		}

		else if (iOHLC == "iRealVolume")

		{

			if (CopyRealVolume(Symbol,Period,cID,1,cRealVolume) > -1) retval = (double)cRealVolume[0];

			

			return retval;

		}

		else if (iOHLC == "iTime")

		{

			if (CopyTime(Symbol,Period,cID,1,T) > -1) retval = (double)T[0];

			

			return retval;

		}

		

		//-- simple calculations --------------------------------------------------

		else if (iOHLC == "iMedian")

		{

			if (

				   CopyLow(Symbol,Period,cID,1,L) > -1

				&& CopyHigh(Symbol,Period,cID,1,H) > -1

			)

			{

				retval = ((L[0]+H[0])/2);

			}

		}

		else if (iOHLC == "iTypical")

		{

			if (

				   CopyLow(Symbol,Period,cID,1,L) > -1

				&& CopyHigh(Symbol,Period,cID,1,H) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

			)

			{

				retval = ((L[0]+H[0]+C[0])/3);

			}

		}

		else if (iOHLC == "iAverage")

		{

			if (

				   CopyLow(Symbol,Period,cID,1,L) > -1

				&& CopyHigh(Symbol,Period,cID,1,H) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

			)

			{

				retval = ((L[0]+H[0]+C[0]+C[0])/4);

			}

		}

		

		//-- more complex levels --------------------------------------------------

		else if (iOHLC=="iTotal")

		{

			if (

				   CopyHigh(Symbol,Period,cID,1,H) > -1

				&& CopyLow(Symbol,Period,cID,1,L) > -1

			)

			{

				retval = toPips(MathAbs(H[0]-L[0]),Symbol);

			}

		}

		else if (iOHLC == "iBody")

		{

			if (

				   CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

			)

			{

				retval = toPips(MathAbs(C[0]-O[0]),Symbol);

			}

		}

		else if (iOHLC == "iUpperWick")

		{

			if (

				   CopyHigh(Symbol,Period,cID,1,H) > -1

				&& CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& CopyLow(Symbol,Period,cID,1,L) > -1

			)

			{

				retval = (C[0] > O[0]) ? toPips(MathAbs(H[0]-C[0]),Symbol) : toPips(MathAbs(H[0]-O[0]),Symbol);

			}

		}

		else if (iOHLC == "iBottomWick")

		{

			if (

				   CopyHigh(Symbol,Period,cID,1,H) > -1

				&& CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& CopyLow(Symbol,Period,cID,1,L) > -1

			)

			{

				retval = (C[0] > O[0]) ? toPips(MathAbs(O[0]-L[0]),Symbol) : toPips(MathAbs(C[0]-L[0]),Symbol);

			}

		}

		else if (iOHLC == "iGap")

		{

			if (

				   CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID+1,1,C) > -1

			)

			{

				retval = toPips(MathAbs(O[0]-C[0]),Symbol);

			}

		}

		else if (iOHLC == "iBullTotal")

		{

			if (

				   CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& CopyHigh(Symbol,Period,cID,1,H) > -1

				&& CopyLow(Symbol,Period,cID,1,L) > -1

				&& C[0] > O[0]

			)

			{

				retval = toPips((H[0]-L[0]),Symbol);

			}

		}

		else if (iOHLC == "iBullBody")

		{

			if (

				   CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& C[0] > O[0]

			)

			{

				retval = toPips((C[0]-O[0]),Symbol);

			}

		}

		else if (iOHLC == "iBullUpperWick")

		{

			if (

				   CopyHigh(Symbol,Period,cID,1,H) > -1

				&& CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& C[0] > O[0]

			)

			{

				retval = toPips((H[0]-C[0]),Symbol);

			}

		}

		else if (iOHLC == "iBullBottomWick")

		{

			if (

				   CopyLow(Symbol,Period,cID,1,L) > -1

				&& CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& C[0] > O[0]

			)

			{

				retval = toPips((O[0]-L[0]),Symbol);

			}

		}

		else if (iOHLC == "iBearTotal")

		{

			if (

				   CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& CopyHigh(Symbol,Period,cID,1,H) > -1

				&& CopyLow(Symbol,Period,cID,1,L) > -1

				&& C[0] < O[0]

			)

			{

				retval = toPips((H[0]-L[0]),Symbol);

			}

		}

		else if (iOHLC == "iBearBody")

		{

			if (

				   CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& C[0] < O[0]

			)

			{

				retval = toPips((O[0]-C[0]),Symbol);

			}

		}

		else if (iOHLC == "iBearUpperWick")

		{

			if (

				   CopyHigh(Symbol,Period,cID,1,H) > -1

				&& CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& C[0] < O[0]

			)

			{

				retval = toPips((H[0]-O[0]),Symbol);

			}

		}

		else if (iOHLC == "iBearBottomWick")

		{

			if (

				   CopyLow(Symbol,Period,cID,1,L) > -1

				&& CopyOpen(Symbol,Period,cID,1,O) > -1

				&& CopyClose(Symbol,Period,cID,1,C) > -1

				&& C[0] < O[0]

			)

			{

				retval = toPips((C[0]-L[0]),Symbol);

			}

		}

		

		return NormalizeDouble(retval, digits);

	}

};



// "Numeric" model

class MDLIC_value_value

{

	public: /* Input Parameters */

	double Value;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_value_value()

	{

		Value = (double)1.0;

	}



	public: /* The main method */

	double _execute_()

	{

		return Value;

	}

};



// "Time" model

class MDLIC_value_time

{

	public: /* Input Parameters */

	int ModeTime;

	int TimeSource;

	string TimeStamp;

	int TimeCandleID;

	string TimeMarket;

	ENUM_TIMEFRAMES TimeCandleTimeframe;

	int TimeComponentYear;

	int TimeComponentMonth;

	double TimeComponentDay;

	double TimeComponentHour;

	double TimeComponentMinute;

	int TimeComponentSecond;

	datetime TimeValue;

	int ModeTimeShift;

	int TimeShiftYears;

	int TimeShiftMonths;

	int TimeShiftWeeks;

	double TimeShiftDays;

	double TimeShiftHours;

	double TimeShiftMinutes;

	int TimeShiftSeconds;

	bool TimeSkipWeekdays;

	/* Static Parameters */

	datetime retval;

	datetime retval0;

	datetime Time[];

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_value_time()

	{

		ModeTime = (int)0;

		TimeSource = (int)0;

		TimeStamp = (string)"00:00";

		TimeCandleID = (int)1;

		TimeMarket = (string)"";

		TimeCandleTimeframe = (ENUM_TIMEFRAMES)0;

		TimeComponentYear = (int)0;

		TimeComponentMonth = (int)0;

		TimeComponentDay = (double)0.0;

		TimeComponentHour = (double)12.0;

		TimeComponentMinute = (double)0.0;

		TimeComponentSecond = (int)0;

		TimeValue = (datetime)0;

		ModeTimeShift = (int)0;

		TimeShiftYears = (int)0;

		TimeShiftMonths = (int)0;

		TimeShiftWeeks = (int)0;

		TimeShiftDays = (double)0.0;

		TimeShiftHours = (double)0.0;

		TimeShiftMinutes = (double)0.0;

		TimeShiftSeconds = (int)0;

		TimeSkipWeekdays = (bool)false;

		/* Static Parameters (initial value) */

		retval =  0;

		retval0 =  0;

	}



	public: /* The main method */

	datetime _execute_()

	{

		// this is static for speed reasons

		

		if (TimeMarket == "") TimeMarket = Symbol();

		

		if (ModeTime == 0)

		{

			     if (TimeSource == 0) {retval = TimeCurrent();}

			else if (TimeSource == 1) {retval = TimeLocal() + (TimeCurrent() - TimeLocal());}

			else if (TimeSource == 2) {retval = TimeGMT() + (TimeCurrent() - TimeGMT());}

		}

		else if (ModeTime == 1)

		{

			retval  = StringToTime(TimeStamp);

			retval0 = retval;

		}

		else if (ModeTime==2)

		{

			retval = TimeFromComponents(TimeSource, TimeComponentYear, TimeComponentMonth, TimeComponentDay, TimeComponentHour, TimeComponentMinute, TimeComponentSecond);

		}

		else if (ModeTime == 3)

		{

			ArraySetAsSeries(Time,true);

			CopyTime(TimeMarket,TimeCandleTimeframe,TimeCandleID,1,Time);

			retval = Time[0];

		}

		else if (ModeTime == 4)

		{

			retval = TimeValue;

		}

		

		if (ModeTimeShift > 0)

		{

			int sh = 1;

		

			if (ModeTimeShift == 1) {sh = -1;}

		

			if (TimeShiftYears > 0 || TimeShiftMonths > 0)

			{

				int year = 0, month = 0, week = 0, day = 0, hour = 0, minute = 0, second = 0;

		

				if (ModeTime == 3)

				{

					year   = TimeComponentYear;

					month  = TimeComponentYear;

					day    = (int)MathFloor(TimeComponentDay);

					hour   = (int)(MathFloor(TimeComponentHour) + (24 * (TimeComponentDay - MathFloor(TimeComponentDay))));

					minute = (int)(MathFloor(TimeComponentMinute) + (60 * (TimeComponentHour - MathFloor(TimeComponentHour))));

					second = (int)(TimeComponentSecond + (60 * (TimeComponentMinute - MathFloor(TimeComponentMinute))));

				}

				else {

					year   = TimeYear(retval);

					month  = TimeMonth(retval);

					day    = TimeDay(retval);

					hour   = TimeHour(retval);

					minute = TimeMinute(retval);

					second = TimeSeconds(retval);

				}

		

				year  = year + TimeShiftYears * sh;

				month = month + TimeShiftMonths * sh;

		

				if (month < 0) {month = 12 - month;}

				else if (month > 12) {month = month - 12;}

		

				retval = StringToTime(IntegerToString(year)+"."+IntegerToString(month)+"."+IntegerToString(day)+" "+IntegerToString(hour)+":"+IntegerToString(minute)+":"+IntegerToString(second));

			}

		

			retval = retval + (sh * ((604800 * TimeShiftWeeks) + SecondsFromComponents(TimeShiftDays, TimeShiftHours, TimeShiftMinutes, TimeShiftSeconds)));

		

			if (TimeSkipWeekdays == true)

			{

				int weekday = TimeDayOfWeek(retval);

		

				if (sh > 0) { // forward

					     if (weekday == 0) {retval = retval + 86400;}

					else if (weekday == 6) {retval = retval + 172800;}

				}

				else if (sh < 0) { // back

					     if (weekday == 0) {retval = retval - 172800;}

					else if (weekday == 6) {retval = retval - 86400;}

				}

			}

		}

		

		

		return (datetime)retval;

	}

};



// "Balance" model

class MDLIC_account_AccountBalance

{

	public: /* Input Parameters */

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_account_AccountBalance()

	{

	}



	public: /* The main method */

	double _execute_()

	{

		return NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);

	}

};



// "Equity" model

class MDLIC_account_AccountEquity

{

	public: /* Input Parameters */

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_account_AccountEquity()

	{

	}



	public: /* The main method */

	double _execute_()

	{

		return NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY), 2);

	}

};



// "Boolean" model

class MDLIC_boolean_boolean

{

	public: /* Input Parameters */

	bool Boolean;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_boolean_boolean()

	{

		Boolean = (bool)true;

	}



	public: /* The main method */

	bool _execute_()

	{

		return Boolean;

	}

};



// "Profit (Equity - Balance)" model

class MDLIC_account_AccountProfit

{

	public: /* Input Parameters */

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_account_AccountProfit()

	{

	}



	public: /* The main method */

	double _execute_()

	{

		return NormalizeDouble(AccountInfoDouble(ACCOUNT_PROFIT), 2);

	}

};



// "Text" model

class MDLIC_text_text

{

	public: /* Input Parameters */

	string Text;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_text_text()

	{

		Text = (string)"sample text";

	}



	public: /* The main method */

	string _execute_()

	{

		return Text;

	}

};



// "Fractals" model

class MDLIC_indicators_iFractals

{

	public: /* Input Parameters */

	int Mode;

	string Symbol;

	ENUM_TIMEFRAMES Period;

	int Shift;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_indicators_iFractals()

	{

		Mode = (int)1;

		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

		Shift = (int)0;

	}



	public: /* The main method */

	double _execute_()

	{

		return iFractals(Symbol, Period, Mode, Shift + FXD_MORE_SHIFT);

	}

};



// "Pips" model

class MDLIC_value_points

{

	public: /* Input Parameters */

	double Value;

	int ModeValue;

	string Symbol;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_value_points()

	{

		Value = (double)10.0;

		ModeValue = (int)1;

		Symbol = (string)CurrentSymbol();

	}



	public: /* The main method */

	double _execute_()

	{

		double retval = 0;

		

		     if (ModeValue == 0) {retval = Value;}

		else if (ModeValue == 1) {retval = Value*SymbolInfoDouble(Symbol,SYMBOL_POINT)*PipValue(Symbol);}

		

		return retval;

	}

};



// "Parabolic SAR" model

class MDLIC_indicators_iSAR

{

	public: /* Input Parameters */

	double Step;

	double Maximum;

	string Symbol;

	ENUM_TIMEFRAMES Period;

	int Shift;

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_indicators_iSAR()

	{

		Step = (double)0.02;

		Maximum = (double)0.2;

		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

		Shift = (int)0;

	}



	public: /* The main method */

	double _execute_()

	{

		return iSAR(Symbol, Period, Step, Maximum, Shift + FXD_MORE_SHIFT);

	}

};



// "Free Margin" model

class MDLIC_account_AccountFreeMargin

{

	public: /* Input Parameters */

	virtual void _callback_(int r) {return;}



	public: /* Constructor */

	MDLIC_account_AccountFreeMargin()

	{

	}



	public: /* The main method */

	double _execute_()

	{

		return NormalizeDouble(AccountInfoDouble(ACCOUNT_MARGIN_FREE), 2);

	}

};





//------------------------------------------------------------------------------------------------------------------------



// Block 1 (Pass)

class Block0: public MDL_Pass

{



	public: /* Constructor */

	Block0() {

		__block_number = 0;

		__block_user_number = "1";





		// Fill the list of outbound blocks

		int ___outbound_blocks[3] = {15,150,16};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[15].run(0);

			_blocks_[16].run(0);

			_blocks_[150].run(0);

		}

	}

};



// Block 2 (No position)

class Block1: public MDL_NoOpenedOrders<string,string,string,string,string>

{



	public: /* Constructor */

	Block1() {

		__block_number = 1;

		__block_user_number = "2";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {84};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		GroupMode = "all";

		SymbolMode = "all";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[84].run(1);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

	}

};



// Block 3 (200ema &gt; candle close)

class Block2: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_candles_candles,double,int>

{



	public: /* Constructor */

	Block2() {

		__block_number = 2;

		__block_user_number = "3";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {3};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.MAperiod = 200;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.MAmethod = MODE_EMA;

		Lo.AppliedPrice = PRICE_CLOSE;

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[3].run(2);

		}

	}

};



// Block 6 (50ema &gt; candle high)

class Block3: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_candles_candles,double,int>

{



	public: /* Constructor */

	Block3() {

		__block_number = 3;

		__block_user_number = "6";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {22};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.MAperiod = 50;

		Ro.iOHLC = "iHigh";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.MAmethod = MODE_EMA;

		Lo.AppliedPrice = PRICE_CLOSE;

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[22].run(3);

		}

	}

};



// Block 7 (Buy nowCandle Low)

class Block4: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>

{



	public: /* Constructor */

	Block4() {

		__block_number = 4;

		__block_user_number = "7";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iLow";

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		ddTakeProfit.Value = 0.01;

		dExp.ModeTimeShift = 2;

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		MyComment = "lower tf bull -> breaks above -> higherer than min pips";

	}



	public: /* Custom methods */

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorBuy = (color)clrBlue;

	}

};



// Block 8 (Sell nowCandle high)

class Block5: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>

{



	public: /* Constructor */

	Block5() {

		__block_number = 5;

		__block_user_number = "8";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iHigh";

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		ddTakeProfit.Value = 0.01;

		dExp.ModeTimeShift = 2;

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		MyComment = "lower tf bear -> breaks below -> higher than min pips";

	}



	public: /* Custom methods */

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorSell = (color)clrRed;

	}

};



// Block 9 (candle low &gt; 50ema)

class Block6: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iMA,double,int>

{



	public: /* Constructor */

	Block6() {

		__block_number = 6;

		__block_user_number = "9";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {114};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iLow";

		Ro.MAperiod = 50;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.MAmethod = MODE_EMA;

		Ro.AppliedPrice = PRICE_CLOSE;

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[114].run(6);

		}

	}

};



// Block 10 (Pass)

class Block7: public MDL_Pass

{



	public: /* Constructor */

	Block7() {

		__block_number = 7;

		__block_user_number = "10";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {14,8};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[8].run(7);

			_blocks_[14].run(7);

		}

	}

};



// Block 11 (Comment)

class Block8: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_account_AccountBalance,double,int,int,string,MDLIC_account_AccountEquity,double,int,int,string,MDLIC_boolean_boolean,bool,int,int,string,MDLIC_boolean_boolean,bool,int,int,string,MDLIC_boolean_boolean,bool,int,int,string,MDLIC_boolean_boolean,bool,int,int,string,MDLIC_account_AccountProfit,double,int,int,string,MDLIC_value_value,double,int,int>

{



	public: /* Constructor */

	Block8() {

		__block_number = 8;

		__block_user_number = "11";

		_beforeExecuteEnabled = true;

		// Block input parameters

		Label1 = "Balance";

		Label2 = "Equity";

		Label3 = "Is Bullish";

		Label4 = "Is Semi Bullish";

		Label5 = "Is Semi Bearish";

		Label6 = "Is Bearish";

		Label7 = "Profit";

		Label8 = "Target Amount";

	}



	public: /* Custom methods */

	virtual double _Value1_() {return Value1._execute_();}

	virtual double _Value2_() {return Value2._execute_();}

	virtual bool _Value3_() {

		Value3.Boolean = v::isBullish;



		return Value3._execute_();

	}

	virtual bool _Value4_() {

		Value4.Boolean = v::isSemiBullish;



		return Value4._execute_();

	}

	virtual bool _Value5_() {

		Value5.Boolean = v::isSemiBearish;



		return Value5._execute_();

	}

	virtual bool _Value6_() {

		Value6.Boolean = v::isBearish;



		return Value6._execute_();

	}

	virtual double _Value7_() {return Value7._execute_();}

	virtual double _Value8_() {

		Value8.Value = c::target_amount;



		return Value8._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		/* Inputs, modified into the code must be set here every time */

		ObjY = 24;

		Title = (string)c::EA_Name;

		ObjCorner = (int)CORNER_RIGHT_UPPER;

		ObjTitleFontColor = (color)clrGold;

		ObjLabelsFontColor = (color)clrDarkGray;

		ObjFontColor = (color)clrWhite;

		FormatNumber1 = (int)EMPTY_VALUE;

		FormatTime1 = (int)EMPTY_VALUE;

		FormatNumber2 = (int)EMPTY_VALUE;

		FormatTime2 = (int)EMPTY_VALUE;

		FormatNumber3 = (int)EMPTY_VALUE;

		FormatTime3 = (int)EMPTY_VALUE;

		FormatNumber4 = (int)EMPTY_VALUE;

		FormatTime4 = (int)EMPTY_VALUE;

		FormatNumber5 = (int)EMPTY_VALUE;

		FormatTime5 = (int)EMPTY_VALUE;

		FormatNumber6 = (int)EMPTY_VALUE;

		FormatTime6 = (int)EMPTY_VALUE;

		FormatNumber7 = (int)EMPTY_VALUE;

		FormatTime7 = (int)EMPTY_VALUE;

		FormatNumber8 = (int)EMPTY_VALUE;

		FormatTime8 = (int)EMPTY_VALUE;

	}

};



// Block 21 (Draw NYKZ Box)

class Block9: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block9() {

		__block_number = 9;

		__block_user_number = "21";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {11};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		ObjTime3.ModeTime = 3;

		ObjTime3.TimeCandleID = 20;

		ObjPrice3.CandleID = 20;

		ObjPrice3.TimeStamp = "";

		// Block input parameters

		ObjName = "nykz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::ny_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::ny_kz_high;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::ny_kz_low;



		return ObjPrice2._execute_();

	}

	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}

	virtual double _ObjPrice3_() {

		ObjPrice3.Symbol = CurrentSymbol();

		ObjPrice3.Period = CurrentTimeframe();



		return ObjPrice3._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[11].run(9);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_RECTANGLE;

		ObjBorderType = (int)BORDER_FLAT;

		ObjBgColor = (color)clrNONE;

		ObjCorner = (int)CORNER_LEFT_UPPER;

		ObjColor = (color)clrBlueViolet;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_DASH;

	}

};



// Block 27 (Delete NYKZ)

class Block10: public MDL_ChartDeleteObjects<string,string,color,string,int,int>

{



	public: /* Constructor */

	Block10() {

		__block_number = 10;

		__block_user_number = "27";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {9};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		NameStartsWith = "nykz";

		MaxObjects = 4;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[9].run(10);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjColor = (color)EMPTY_VALUE;

	}

};



// Block 35 (Draw NYKZ Text)

class Block11: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block11() {

		__block_number = 11;

		__block_user_number = "35";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {12};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjText.Text = "NewYork KZ";

		// Block input parameters

		ObjName = "nykz";

		ObjFontSize = 11;

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::ny_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::ny_kz_high;



		return ObjPrice1._execute_();

	}

	virtual string _ObjText_() {return ObjText._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[12].run(11);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TEXT;

		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;

		ObjAnchor = (int)ANCHOR_LEFT_UPPER;

		ObjColor = (color)clrBlueViolet;

	}

};



// Block 39 (Draw Fractal Up Line)

class Block12: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block12() {

		__block_number = 12;

		__block_user_number = "39";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {13};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "nykz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::ny_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_up_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_up_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[13].run(12);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 40 (Draw Fractal Down Line)

class Block13: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block13() {

		__block_number = 13;

		__block_user_number = "40";

		_beforeExecuteEnabled = true;



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "nykz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::ny_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_down_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_down_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 41 (Debug)

class Block14: public MDL_CommentEx<string,string,int,int,int,string,color,int,string,color,int,string,color,int,string,MDLIC_boolean_boolean,bool,int,int,string,MDLIC_boolean_boolean,bool,int,int,string,MDLIC_boolean_boolean,bool,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int,string,MDLIC_value_value,double,int,int>

{



	public: /* Constructor */

	Block14() {

		__block_number = 14;

		__block_user_number = "41";

		_beforeExecuteEnabled = true;

		// Block input parameters

		Title = "Debug";

		Label1 = "isLondonKZ";

		Label2 = "isNewYorkKZ";

		Label3 = "isAsianKZ";

		Label4 = "Max lot size";

		Label5 = "CUR UP 1";

		Label6 = "CUR UP 2";

		Label7 = "CUR DOWN 1";

		Label8 = "CUR DOWN 2";

	}



	public: /* Custom methods */

	virtual bool _Value1_() {

		Value1.Boolean = v::isLondonKZ;



		return Value1._execute_();

	}

	virtual bool _Value2_() {

		Value2.Boolean = v::isNewYorkKZ;



		return Value2._execute_();

	}

	virtual bool _Value3_() {

		Value3.Boolean = v::isAsianKZ;



		return Value3._execute_();

	}

	virtual double _Value4_() {

		Value4.Value = v::max_lot_size;



		return Value4._execute_();

	}

	virtual double _Value5_() {

		Value5.Value = v::cur_fractal_up_1;



		return Value5._execute_();

	}

	virtual double _Value6_() {

		Value6.Value = v::cur_fractal_up_2;



		return Value6._execute_();

	}

	virtual double _Value7_() {

		Value7.Value = v::cur_fractal_down_1;



		return Value7._execute_();

	}

	virtual double _Value8_() {

		Value8.Value = v::cur_fractal_down_2;



		return Value8._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		/* Inputs, modified into the code must be set here every time */

		ObjY = 24;

		ObjCorner = (int)CORNER_LEFT_UPPER;

		ObjTitleFontColor = (color)clrGold;

		ObjLabelsFontColor = (color)clrDarkGray;

		ObjFontColor = (color)clrWhite;

		FormatNumber1 = (int)EMPTY_VALUE;

		FormatTime1 = (int)EMPTY_VALUE;

		FormatNumber2 = (int)EMPTY_VALUE;

		FormatTime2 = (int)EMPTY_VALUE;

		FormatNumber3 = (int)EMPTY_VALUE;

		FormatTime3 = (int)EMPTY_VALUE;

		FormatNumber4 = (int)EMPTY_VALUE;

		FormatTime4 = (int)EMPTY_VALUE;

		FormatNumber5 = (int)EMPTY_VALUE;

		FormatTime5 = (int)EMPTY_VALUE;

		FormatNumber6 = (int)EMPTY_VALUE;

		FormatTime6 = (int)EMPTY_VALUE;

		FormatNumber7 = (int)EMPTY_VALUE;

		FormatTime7 = (int)EMPTY_VALUE;

		FormatNumber8 = (int)EMPTY_VALUE;

		FormatTime8 = (int)EMPTY_VALUE;

	}

};



// Block 42 (Fractal Up visible)

class Block15: public MDL_IndicatorIsVisible<MDLIC_indicators_iFractals,double,int,int>

{



	public: /* Constructor */

	Block15() {

		__block_number = 15;

		__block_user_number = "42";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {246};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Indicator.Shift = 2;

	}



	public: /* Custom methods */

	virtual double _Indicator_() {

		Indicator.Symbol = CurrentSymbol();

		Indicator.Period = CurrentTimeframe();



		return Indicator._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[246].run(15);

		}

	}

};



// Block 44 (Fractal Down visible)

class Block16: public MDL_IndicatorIsVisible<MDLIC_indicators_iFractals,double,int,int>

{



	public: /* Constructor */

	Block16() {

		__block_number = 16;

		__block_user_number = "44";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {243};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Indicator.Mode = 2;

		Indicator.Shift = 2;

	}



	public: /* Custom methods */

	virtual double _Indicator_() {

		Indicator.Symbol = CurrentSymbol();

		Indicator.Period = CurrentTimeframe();



		return Indicator._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[243].run(16);

		}

	}

};



// Block 58 (Pass)

class Block17: public MDL_Pass

{



	public: /* Constructor */

	Block17() {

		__block_number = 17;

		__block_user_number = "58";





		// Fill the list of outbound blocks

		int ___outbound_blocks[3] = {18,58,60};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[18].run(17);

			_blocks_[58].run(17);

			_blocks_[60].run(17);

		}

	}

};



// Block 60 (200ema &gt; candle close)

class Block18: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_candles_candles,double,int>

{



	public: /* Constructor */

	Block18() {

		__block_number = 18;

		__block_user_number = "60";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {20,21};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.MAperiod = 200;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.MAmethod = MODE_EMA;

		Lo.AppliedPrice = PRICE_CLOSE;

		Lo.Symbol = CurrentSymbol();

		Lo.Period = PERIOD_H4;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Symbol = CurrentSymbol();

		Ro.Period = PERIOD_H4;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[21].run(18);

		}

		else if (value == 1) {

			_blocks_[20].run(18);

		}

	}

};



// Block 63 (isBearish)

class Block19: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block19() {

		__block_number = 19;

		__block_user_number = "63";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value2.Boolean = false;

		Value3.Boolean = false;

		Value4.Boolean = false;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual bool _Value2_() {return Value2._execute_();}

	virtual bool _Value3_() {return Value3._execute_();}

	virtual bool _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::isBearish = _Value1_();

		v::isSemiBearish = _Value2_();

		v::isBullish = _Value3_();

		v::isSemiBullish = _Value4_();

	}

};



// Block 64 (50ema &gt; candle high)

class Block20: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_candles_candles,double,int>

{



	public: /* Constructor */

	Block20() {

		__block_number = 20;

		__block_user_number = "64";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {36,39};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.MAperiod = 50;

		Ro.iOHLC = "iHigh";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.MAmethod = MODE_EMA;

		Lo.AppliedPrice = PRICE_CLOSE;

		Lo.Symbol = CurrentSymbol();

		Lo.Period = PERIOD_H4;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Symbol = CurrentSymbol();

		Ro.Period = PERIOD_H4;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[39].run(20);

		}

		else if (value == 1) {

			_blocks_[36].run(20);

		}

	}

};



// Block 67 (candle low &gt; 50ema)

class Block21: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iMA,double,int>

{



	public: /* Constructor */

	Block21() {

		__block_number = 21;

		__block_user_number = "67";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {42,45};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iLow";

		Ro.MAperiod = 50;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = PERIOD_H4;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.MAmethod = MODE_EMA;

		Ro.AppliedPrice = PRICE_CLOSE;

		Ro.Symbol = CurrentSymbol();

		Ro.Period = PERIOD_H4;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[45].run(21);

		}

		else if (value == 1) {

			_blocks_[42].run(21);

		}

	}

};



// Block 72 (Candle breaksbelow fractal)

class Block22: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block22() {

		__block_number = 22;

		__block_user_number = "72";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {70};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::cur_fractal_down_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[70].run(22);

		}

	}

};



// Block 74 (Check min distanceSell)

class Block23: public MDL_CheckDistance<MDLIC_candles_candles,double,MDLIC_candles_candles,double,bool,string,MDLIC_value_points,double>

{



	public: /* Constructor */

	Block23() {

		__block_number = 23;

		__block_user_number = "74";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {49,66};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		UpperLevel.iOHLC = "iHigh";

		// Block input parameters

		CompareDistance = "<";

	}



	public: /* Custom methods */

	virtual double _UpperLevel_() {

		UpperLevel.Symbol = CurrentSymbol();

		UpperLevel.Period = CurrentTimeframe();



		return UpperLevel._execute_();

	}

	virtual double _LowerLevel_() {

		LowerLevel.Symbol = CurrentSymbol();

		LowerLevel.Period = CurrentTimeframe();



		return LowerLevel._execute_();

	}

	virtual double _dDistance_() {

		dDistance.Value = c::min_pips_distance;

		dDistance.Symbol = CurrentSymbol();



		return dDistance._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[66].run(23);

		}

		else if (value == 1) {

			_blocks_[49].run(23);

		}

	}

};



// Block 75 (Sell nowpip SL)

class Block24: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>

{



	public: /* Constructor */

	Block24() {

		__block_number = 24;

		__block_user_number = "75";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iHigh";

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		ddTakeProfit.Value = 0.01;

		dExp.ModeTimeShift = 2;

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		MyComment = "lower tf bear -> breaks below -> lower than min pips";

	}



	public: /* Custom methods */

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		double value = (double)dlStopLoss._execute_();

		value = value+toDigits(6,CurrentSymbol()); // Adjust the value

		return value;

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorSell = (color)clrRed;

	}

};



// Block 76 (Check min distanceBuy)

class Block25: public MDL_CheckDistance<MDLIC_candles_candles,double,MDLIC_candles_candles,double,bool,string,MDLIC_value_points,double>

{



	public: /* Constructor */

	Block25() {

		__block_number = 25;

		__block_user_number = "76";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {51,71};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		UpperLevel.iOHLC = "iLow";

		// Block input parameters

		CompareDistance = "<";

	}



	public: /* Custom methods */

	virtual double _UpperLevel_() {

		UpperLevel.Symbol = CurrentSymbol();

		UpperLevel.Period = CurrentTimeframe();



		return UpperLevel._execute_();

	}

	virtual double _LowerLevel_() {

		LowerLevel.Symbol = CurrentSymbol();

		LowerLevel.Period = CurrentTimeframe();



		return LowerLevel._execute_();

	}

	virtual double _dDistance_() {

		dDistance.Value = c::min_pips_distance;

		dDistance.Symbol = CurrentSymbol();



		return dDistance._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[71].run(25);

		}

		else if (value == 1) {

			_blocks_[51].run(25);

		}

	}

};



// Block 77 (Buy nowpip SL)

class Block26: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>

{



	public: /* Constructor */

	Block26() {

		__block_number = 26;

		__block_user_number = "77";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iLow";

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		ddTakeProfit.Value = 0.01;

		dExp.ModeTimeShift = 2;

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		MyComment = "lower tf bull -> breaks above -> lower than min pips";

	}



	public: /* Custom methods */

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		double value = (double)dlStopLoss._execute_();

		value = value-toDigits(6,CurrentSymbol()); // Adjust the value

		return value;

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorBuy = (color)clrBlue;

	}

};



// Block 82 (Candle breaksabove fractal)

class Block27: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block27() {

		__block_number = 27;

		__block_user_number = "82";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {201};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::cur_fractal_up_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[201].run(27);

		}

	}

};



// Block 85 (isBearish)

class Block28: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block28() {

		__block_number = 28;

		__block_user_number = "85";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {30,79};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isBearish;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[30].run(28);

		}

		else if (value == 1) {

			_blocks_[79].run(28);

		}

	}

};



// Block 87 (Candle breaksabove fractal)

class Block29: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block29() {

		__block_number = 29;

		__block_user_number = "87";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {104};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::cur_fractal_up_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[104].run(29);

		}

	}

};



// Block 162 (isBullish)

class Block30: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block30() {

		__block_number = 30;

		__block_user_number = "162";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {76,81};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isBullish;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[76].run(30);

		}

		else if (value == 1) {

			_blocks_[81].run(30);

		}

	}

};



// Block 163 (Candle breaksbelow fractal)

class Block31: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block31() {

		__block_number = 31;

		__block_user_number = "163";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {91};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::cur_fractal_down_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[91].run(31);

		}

	}

};



// Block 165 (Delete pendingorders)

class Block32: public MDL_DeletePendingOrders<string,string,string,string,string,string,color>

{



	public: /* Constructor */

	Block32() {

		__block_number = 32;

		__block_user_number = "165";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {228};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		BuysOrSells = "buys";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[228].run(32);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		ArrowColor = (color)clrDeepPink;

	}

};



// Block 237 (Buy pendingorder)

class Block33: public MDL_BuyPending<string,string,string,MDLIC_candles_candles,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>

{



	public: /* Constructor */

	Block33() {

		__block_number = 33;

		__block_user_number = "237";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dPrice.iOHLC = "iHigh";

		dPrice.CandleID = 1;

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iLow";

		dlStopLoss.CandleID = 1;

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		ddTakeProfit.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		dExp.ModeTime = 1;

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		Price = "dynamic";

		PriceOffset = 0.0;

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		ExpMode = "custom";

		MyComment = "bull -> breaks below -> london";

	}



	public: /* Custom methods */

	virtual double _dPrice_() {

		dPrice.Symbol = CurrentSymbol();

		dPrice.Period = CurrentTimeframe();



		double value = (double)dPrice._execute_();

		value = value+toDigits(2,CurrentSymbol()); // Adjust the value

		return value;

	}

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual datetime _dExp_() {

		dExp.TimeStamp = c::london_killzone_end;



		return dExp._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorBuy = (color)clrBlue;

	}

};



// Block 247 (isLondonKZ)

class Block34: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block34() {

		__block_number = 34;

		__block_user_number = "247";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {47,48};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isLondonKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[48].run(34);

		}

		else if (value == 1) {

			_blocks_[47].run(34);

		}

	}

};



// Block 248 (Buy pendingorder)

class Block35: public MDL_BuyPending<string,string,string,MDLIC_candles_candles,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>

{



	public: /* Constructor */

	Block35() {

		__block_number = 35;

		__block_user_number = "248";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dPrice.iOHLC = "iHigh";

		dPrice.CandleID = 1;

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iLow";

		dlStopLoss.CandleID = 1;

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		ddTakeProfit.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		dExp.ModeTime = 1;

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		Price = "dynamic";

		PriceOffset = 0.0;

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		ExpMode = "custom";

		MyComment = "bull -> breaks below -> new york";

	}



	public: /* Custom methods */

	virtual double _dPrice_() {

		dPrice.Symbol = CurrentSymbol();

		dPrice.Period = CurrentTimeframe();



		double value = (double)dPrice._execute_();

		value = value+toDigits(2,CurrentSymbol()); // Adjust the value

		return value;

	}

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual datetime _dExp_() {

		dExp.TimeStamp = c::newyork_killzone_end;



		return dExp._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorBuy = (color)clrBlue;

	}

};



// Block 249 (isAlreadyBearish)

class Block36: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block36() {

		__block_number = 36;

		__block_user_number = "249";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {37};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isBearish;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[37].run(36);

		}

	}

};



// Block 250 (Log message)

class Block37: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block37() {

		__block_number = 37;

		__block_user_number = "250";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {19};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "H4 switching to bearish...";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[19].run(37);

		}

	}

};



// Block 251 (isSemiBearish)

class Block38: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block38() {

		__block_number = 38;

		__block_user_number = "251";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Boolean = false;

		Value3.Boolean = false;

		Value4.Boolean = false;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual bool _Value2_() {return Value2._execute_();}

	virtual bool _Value3_() {return Value3._execute_();}

	virtual bool _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::isBearish = _Value1_();

		v::isSemiBearish = _Value2_();

		v::isBullish = _Value3_();

		v::isSemiBullish = _Value4_();

	}

};



// Block 437 (isAlreadySemiBearish)

class Block39: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block39() {

		__block_number = 39;

		__block_user_number = "437";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {40};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isSemiBearish;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[40].run(39);

		}

	}

};



// Block 438 (Log message)

class Block40: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block40() {

		__block_number = 40;

		__block_user_number = "438";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {38};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "H4 switching to semi bearish...";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[38].run(40);

		}

	}

};



// Block 439 (isBullish)

class Block41: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block41() {

		__block_number = 41;

		__block_user_number = "439";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Boolean = false;

		Value2.Boolean = false;

		Value4.Boolean = false;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual bool _Value2_() {return Value2._execute_();}

	virtual bool _Value3_() {return Value3._execute_();}

	virtual bool _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::isBearish = _Value1_();

		v::isSemiBearish = _Value2_();

		v::isBullish = _Value3_();

		v::isSemiBullish = _Value4_();

	}

};



// Block 625 (isAlreadyBullish)

class Block42: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block42() {

		__block_number = 42;

		__block_user_number = "625";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {43};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isBullish;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[43].run(42);

		}

	}

};



// Block 626 (Log message)

class Block43: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block43() {

		__block_number = 43;

		__block_user_number = "626";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {41};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "H4 switching to bullish...";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[41].run(43);

		}

	}

};



// Block 627 (isSemiBullish)

class Block44: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block44() {

		__block_number = 44;

		__block_user_number = "627";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Boolean = false;

		Value2.Boolean = false;

		Value3.Boolean = false;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual bool _Value2_() {return Value2._execute_();}

	virtual bool _Value3_() {return Value3._execute_();}

	virtual bool _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::isBearish = _Value1_();

		v::isSemiBearish = _Value2_();

		v::isBullish = _Value3_();

		v::isSemiBullish = _Value4_();

	}

};



// Block 813 (isAlreadySemiBullish)

class Block45: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block45() {

		__block_number = 45;

		__block_user_number = "813";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {46};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isSemiBullish;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[46].run(45);

		}

	}

};



// Block 814 (Log message)

class Block46: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block46() {

		__block_number = 46;

		__block_user_number = "814";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {44};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "H4 switching to semi bullish...";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[44].run(46);

		}

	}

};



// Block 819 (Log message)

class Block47: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block47() {

		__block_number = 47;

		__block_user_number = "819";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {33};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "bull -> breaks below -> london";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[33].run(47);

		}

	}

};



// Block 820 (Log message)

class Block48: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block48() {

		__block_number = 48;

		__block_user_number = "820";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {35};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "bull -> breaks below -> new york";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[35].run(48);

		}

	}

};



// Block 823 (Log message)

class Block49: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block49() {

		__block_number = 49;

		__block_user_number = "823";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {24};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "lower tf bear -> breaks below -> lower than min pips";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[24].run(49);

		}

	}

};



// Block 824 (Log message)

class Block50: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block50() {

		__block_number = 50;

		__block_user_number = "824";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {5};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "lower tf bear -> breaks below -> higher than min pips";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[5].run(50);

		}

	}

};



// Block 825 (Log message)

class Block51: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block51() {

		__block_number = 51;

		__block_user_number = "825";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {26};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "lower tf bull -> breaks above -> lower than min pips";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[26].run(51);

		}

	}

};



// Block 826 (Log message)

class Block52: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block52() {

		__block_number = 52;

		__block_user_number = "826";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {4};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "lower tf bull -> breaks above -> higherer than min pips";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[4].run(52);

		}

	}

};



// Block 827 (Pass)

class Block53: public MDL_Pass

{



	public: /* Constructor */

	Block53() {

		__block_number = 53;

		__block_user_number = "827";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {57};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[57].run(53);

		}

	}

};



// Block 868 (Fractal Down visible)

class Block54: public MDL_IndicatorIsVisible<MDLIC_indicators_iFractals,double,int,int>

{



	public: /* Constructor */

	Block54() {

		__block_number = 54;

		__block_user_number = "868";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {56,57};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Indicator.Mode = 2;

	}



	public: /* Custom methods */

	virtual double _Indicator_() {

		Indicator.Symbol = CurrentSymbol();

		Indicator.Period = PERIOD_H4;

		Indicator.Shift = v::h4_fractal_count_down;



		return Indicator._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[57].run(54);

		}

		else if (value == 1) {

			_blocks_[56].run(54);

		}

	}

};



// Block 869 (set fractal down1)

class Block55: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block55() {

		__block_number = 55;

		__block_user_number = "869";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {57};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Value1.Mode = 2;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = PERIOD_H4;

		Value1.Shift = v::h4_fractal_count_down;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[57].run(55);

		}

	}



	virtual void _beforeExecute_()

	{



		v::h4_fractal_down_1 = _Value1_();

	}

};



// Block 873 (isFractalDown1Set)

class Block56: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block56() {

		__block_number = 56;

		__block_user_number = "873";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {216,55};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::h4_fractal_down_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[55].run(56);

		}

		else if (value == 1) {

			_blocks_[216].run(56);

		}

	}

};



// Block 874 (Count UP)

class Block57: public MDL_Formula_1<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block57() {

		__block_number = 57;

		__block_user_number = "874";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {54};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::h4_fractal_count_down;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[54].run(57);

		}

	}

};



// Block 875 (Fractal Up visible)

class Block58: public MDL_IndicatorIsVisible<MDLIC_indicators_iFractals,double,int,int>

{



	public: /* Constructor */

	Block58() {

		__block_number = 58;

		__block_user_number = "875";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {225};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Indicator.Shift = 2;

	}



	public: /* Custom methods */

	virtual double _Indicator_() {

		Indicator.Symbol = CurrentSymbol();

		Indicator.Period = PERIOD_H4;



		return Indicator._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[225].run(58);

		}

	}

};



// Block 876 (set fractal up 1)

class Block59: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block59() {

		__block_number = 59;

		__block_user_number = "876";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Shift = 2;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = PERIOD_H4;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::h4_fractal_up_1 = _Value1_();

	}

};



// Block 877 (Fractal Down visible)

class Block60: public MDL_IndicatorIsVisible<MDLIC_indicators_iFractals,double,int,int>

{



	public: /* Constructor */

	Block60() {

		__block_number = 60;

		__block_user_number = "877";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {226};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Indicator.Mode = 2;

		Indicator.Shift = 2;

	}



	public: /* Custom methods */

	virtual double _Indicator_() {

		Indicator.Symbol = CurrentSymbol();

		Indicator.Period = PERIOD_H4;



		return Indicator._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[226].run(60);

		}

	}

};



// Block 878 (set fractal down 1)

class Block61: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block61() {

		__block_number = 61;

		__block_user_number = "878";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Mode = 2;

		Value1.Shift = 2;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = PERIOD_H4;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::h4_fractal_down_1 = _Value1_();

	}

};



// Block 879 (Farctal upsubtractFractal down)

class Block62: public MDL_Formula_2<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block62() {

		__block_number = 62;

		__block_user_number = "879";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {63};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "-";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::h4_fractal_up_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::h4_fractal_down_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[63].run(62);

		}

	}

};



// Block 880 (Half)

class Block63: public MDL_Formula_3<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block63() {

		__block_number = 63;

		__block_user_number = "880";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {64};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 2.0;

		// Block input parameters

		compare = "/";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::up_subtract_down;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[64].run(63);

		}

	}

};



// Block 881 (Fractal Half)

class Block64: public MDL_Formula_4<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block64() {

		__block_number = 64;

		__block_user_number = "881";



	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::half;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::h4_fractal_down_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}

};



// Block 882 (Pass)

class Block65: public MDL_Pass

{



	public: /* Constructor */

	Block65() {

		__block_number = 65;

		__block_user_number = "882";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {62};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[62].run(65);

		}

	}

};



// Block 956 (Check max distanceSell)

class Block66: public MDL_CheckDistance<MDLIC_candles_candles,double,MDLIC_candles_candles,double,bool,string,MDLIC_value_points,double>

{



	public: /* Constructor */

	Block66() {

		__block_number = 66;

		__block_user_number = "956";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {50,68};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		UpperLevel.iOHLC = "iHigh";

	}



	public: /* Custom methods */

	virtual double _UpperLevel_() {

		UpperLevel.Symbol = CurrentSymbol();

		UpperLevel.Period = CurrentTimeframe();



		return UpperLevel._execute_();

	}

	virtual double _LowerLevel_() {

		LowerLevel.Symbol = CurrentSymbol();

		LowerLevel.Period = CurrentTimeframe();



		return LowerLevel._execute_();

	}

	virtual double _dDistance_() {

		dDistance.Value = c::max_pips_distance;

		dDistance.Symbol = CurrentSymbol();



		return dDistance._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[50].run(66);

		}

		else if (value == 1) {

			_blocks_[68].run(66);

		}

	}

};



// Block 957 (Sell nowmax pip SL)

class Block67: public MDL_SellNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_points,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>

{



	public: /* Constructor */

	Block67() {

		__block_number = 67;

		__block_user_number = "957";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dVolumeSize.Value = 0.1;

		dlStopLoss.ModeValue = 0;

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		ddTakeProfit.Value = 0.01;

		dExp.ModeTimeShift = 2;

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		MyComment = "lower tf bear -> breaks below -> fixed max pips";

	}



	public: /* Custom methods */

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Value = c::max_pips_distance;

		dlStopLoss.Symbol = CurrentSymbol();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorSell = (color)clrRed;

	}

};



// Block 1705 (Log message)

class Block68: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block68() {

		__block_number = 68;

		__block_user_number = "1705";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {67};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "lower tf bear -> breaks below ->max pips";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[67].run(68);

		}

	}

};



// Block 1831 (Spread Filter)

class Block69: public MDL_Spreadfilter<string,string,string,double,int,double>

{



	public: /* Constructor */

	Block69() {

		__block_number = 69;

		__block_user_number = "1831";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {23};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		maxSpread = 3.0;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[23].run(69);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

	}

};



// Block 1832 (Once per bar)

class Block70: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>

{



	public: /* Constructor */

	Block70() {

		__block_number = 70;

		__block_user_number = "1832";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {69};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[69].run(70);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}

};



// Block 1835 (Check max distanceBuy)

class Block71: public MDL_CheckDistance<MDLIC_candles_candles,double,MDLIC_candles_candles,double,bool,string,MDLIC_value_points,double>

{



	public: /* Constructor */

	Block71() {

		__block_number = 71;

		__block_user_number = "1835";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {52,73};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		UpperLevel.iOHLC = "iLow";

	}



	public: /* Custom methods */

	virtual double _UpperLevel_() {

		UpperLevel.Symbol = CurrentSymbol();

		UpperLevel.Period = CurrentTimeframe();



		return UpperLevel._execute_();

	}

	virtual double _LowerLevel_() {

		LowerLevel.Symbol = CurrentSymbol();

		LowerLevel.Period = CurrentTimeframe();



		return LowerLevel._execute_();

	}

	virtual double _dDistance_() {

		dDistance.Value = c::max_pips_distance;

		dDistance.Symbol = CurrentSymbol();



		return dDistance._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[52].run(71);

		}

		else if (value == 1) {

			_blocks_[73].run(71);

		}

	}

};



// Block 1836 (Buy nowmax pip SL)

class Block72: public MDL_BuyNow<string,string,string,double,double,double,double,double,MDLIC_value_value,double,double,double,int,double,double,double,double,double,int,int,double,bool,double,double,bool,double,string,bool,double,string,string,bool,double,string,double,double,double,MDLIC_value_points,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,ulong,string,color>

{



	public: /* Constructor */

	Block72() {

		__block_number = 72;

		__block_user_number = "1836";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dVolumeSize.Value = 0.1;

		dlStopLoss.ModeValue = 0;

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		ddTakeProfit.Value = 0.01;

		dExp.ModeTimeShift = 2;

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		MyComment = "lower tf bull -> breaks above -> fixed max pips";

	}



	public: /* Custom methods */

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Value = c::max_pips_distance;

		dlStopLoss.Symbol = CurrentSymbol();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorBuy = (color)clrBlue;

	}

};



// Block 2584 (Log message)

class Block73: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block73() {

		__block_number = 73;

		__block_user_number = "2584";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {72};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "lower tf bull -> breaks above -> lower than min pips";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[72].run(73);

		}

	}

};



// Block 2587 (200ema &gt; 50ema)

class Block74: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_indicators_iMA,double,int>

{



	public: /* Constructor */

	Block74() {

		__block_number = 74;

		__block_user_number = "2587";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {29};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.MAperiod = 200;

		Ro.MAperiod = 50;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.MAmethod = MODE_EMA;

		Lo.AppliedPrice = PRICE_CLOSE;

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.MAmethod = MODE_EMA;

		Ro.AppliedPrice = PRICE_CLOSE;

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[29].run(74);

		}

	}

};



// Block 2588 (50ema &gt; 200ema)

class Block75: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_indicators_iMA,double,int>

{



	public: /* Constructor */

	Block75() {

		__block_number = 75;

		__block_user_number = "2588";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {31};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.MAperiod = 50;

		Ro.MAperiod = 200;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.MAmethod = MODE_EMA;

		Lo.AppliedPrice = PRICE_CLOSE;

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.MAmethod = MODE_EMA;

		Ro.AppliedPrice = PRICE_CLOSE;

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[31].run(75);

		}

	}

};



// Block 2589 (isSemiBearish)

class Block76: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block76() {

		__block_number = 76;

		__block_user_number = "2589";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {77,80};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isSemiBearish;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[77].run(76);

		}

		else if (value == 1) {

			_blocks_[80].run(76);

		}

	}

};



// Block 2666 (isSemiBullish)

class Block77: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block77() {

		__block_number = 77;

		__block_user_number = "2666";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {82};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isSemiBullish;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[82].run(77);

		}

	}

};



// Block 2667 (200ema &gt; candle close)

class Block78: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_candles_candles,double,int>

{



	public: /* Constructor */

	Block78() {

		__block_number = 78;

		__block_user_number = "2667";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {6};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.MAperiod = 200;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.MAmethod = MODE_EMA;

		Lo.AppliedPrice = PRICE_CLOSE;

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[6].run(78);

		}

	}

};



// Block 2668 (isSellEnabled)

class Block79: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block79() {

		__block_number = 79;

		__block_user_number = "2668";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {74};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = c::enable_bearish_sell;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[74].run(79);

		}

	}

};



// Block 2669 (isSemiSellEnabled)

class Block80: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block80() {

		__block_number = 80;

		__block_user_number = "2669";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {2};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = c::enable_semi_bearish_sell;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[2].run(80);

		}

	}

};



// Block 2670 (isBuyEnabled)

class Block81: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block81() {

		__block_number = 81;

		__block_user_number = "2670";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {75};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = c::enable_bullish_buy;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[75].run(81);

		}

	}

};



// Block 2671 (isSemiBuyEnabled)

class Block82: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block82() {

		__block_number = 82;

		__block_user_number = "2671";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {227};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = c::enable_semi_bullish_buy;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[227].run(82);

		}

	}

};



// Block 2672 (SAR condition)

class Block83: public MDL_Condition<MDLIC_indicators_iSAR,double,string,MDLIC_candles_candles,double,int>

{



	public: /* Constructor */

	Block83() {

		__block_number = 83;

		__block_user_number = "2672";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {78};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[78].run(83);

		}

	}

};



// Block 2673 (isTargetHit)

class Block84: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block84() {

		__block_number = 84;

		__block_user_number = "2673";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {92};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {return Lo._execute_();}

	virtual bool _Ro_() {

		Ro.Boolean = v::is_target_hit;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[92].run(84);

		}

	}

};



// Block 2674 (Pass)

class Block85: public MDL_Pass

{



	public: /* Constructor */

	Block85() {

		__block_number = 85;

		__block_user_number = "2674";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {86};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[86].run(85);

		}

	}

};



// Block 2675 (If position)

class Block86: public MDL_IfOpenedOrders<string,string,string,string,string>

{



	public: /* Constructor */

	Block86() {

		__block_number = 86;

		__block_user_number = "2675";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {194,87};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[194].run(86);

		}

		else if (value == 1) {

			_blocks_[87].run(86);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

	}

};



// Block 2676 (Check forTarget EquityHit)

class Block87: public MDL_Condition<MDLIC_account_AccountEquity,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block87() {

		__block_number = 87;

		__block_user_number = "2676";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {88};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {return Lo._execute_();}

	virtual double _Ro_() {

		Ro.Value = c::target_amount;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[88].run(87);

		}

	}

};



// Block 2677 (Close positions)

class Block88: public MDL_CloseOpened<string,string,string,string,string,int,ulong,color>

{



	public: /* Constructor */

	Block88() {

		__block_number = 88;

		__block_user_number = "2677";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {89,90};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[89].run(88);

			_blocks_[90].run(88);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		ArrowColor = (color)clrDeepPink;

	}

};



// Block 2678 (update isTargetHit)

class Block89: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block89() {

		__block_number = 89;

		__block_user_number = "2678";

		_beforeExecuteEnabled = true;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::is_target_hit = _Value1_();

	}

};



// Block 2679 (Log message)

class Block90: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block90() {

		__block_number = 90;

		__block_user_number = "2679";



		// Block input parameters

		PrintText = "Target has been hit. Trading will stop";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}

};



// Block 2680 (set BullBreaks Bellow)

class Block91: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block91() {

		__block_number = 91;

		__block_user_number = "2680";

		_beforeExecuteEnabled = true;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::bull_breaks_below = _Value1_();

	}

};



// Block 2681 (isBullBreakBelow)

class Block92: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block92() {

		__block_number = 92;

		__block_user_number = "2681";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {28};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {return Lo._execute_();}

	virtual bool _Ro_() {

		Ro.Boolean = v::bull_breaks_below;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[28].run(92);

		}

	}

};



// Block 2682 (isBullBreakBelow)

class Block93: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block93() {

		__block_number = 93;

		__block_user_number = "2682";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {162};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {return Lo._execute_();}

	virtual bool _Ro_() {

		Ro.Boolean = v::bull_breaks_below;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[162].run(93);

		}

	}

};



// Block 2683 (Pass)

class Block94: public MDL_Pass

{



	public: /* Constructor */

	Block94() {

		__block_number = 94;

		__block_user_number = "2683";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {93};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[93].run(94);

		}

	}

};



// Block 2684 (Once per bar)

class Block95: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>

{



	public: /* Constructor */

	Block95() {

		__block_number = 95;

		__block_user_number = "2684";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {100};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[100].run(95);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}

};



// Block 2685 (Pass)

class Block96: public MDL_Pass

{



	public: /* Constructor */

	Block96() {

		__block_number = 96;

		__block_user_number = "2685";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {188};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[188].run(96);

		}

	}

};



// Block 2701 (London KZ)

class Block97: public MDL_TimeFilter<string,string,string,int,int,double,double,double,int,string,string,int,int,double,double,double,int,int,int,double,double,double,int>

{



	public: /* Constructor */

	Block97() {

		__block_number = 97;

		__block_user_number = "2701";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {98};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[98].run(97);

		}

	}



	virtual void _beforeExecute_()

	{



		TimeStart = (string)c::london_killzone_start;

		TimeEnd = (string)c::london_killzone_end;

	}

};



// Block 2703 (New York KZ)

class Block98: public MDL_TimeFilter<string,string,string,int,int,double,double,double,int,string,string,int,int,double,double,double,int,int,int,double,double,double,int>

{



	public: /* Constructor */

	Block98() {

		__block_number = 98;

		__block_user_number = "2703";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {99};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[99].run(98);

		}

	}



	virtual void _beforeExecute_()

	{



		TimeStart = (string)c::newyork_killzone_start;

		TimeEnd = (string)c::newyork_killzone_end;

	}

};



// Block 2704 (clear breaks)

class Block99: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block99() {

		__block_number = 99;

		__block_user_number = "2704";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {101};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Value1.Boolean = false;

		Value2.Boolean = false;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual bool _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[101].run(99);

		}

	}



	virtual void _beforeExecute_()

	{



		v::bull_breaks_below = _Value1_();

	}

};



// Block 2705 (No position)

class Block100: public MDL_NoOpenedOrders<string,string,string,string,string>

{



	public: /* Constructor */

	Block100() {

		__block_number = 100;

		__block_user_number = "2705";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {32};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		GroupMode = "all";

		SymbolMode = "all";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[32].run(100);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

	}

};



// Block 2706 (Delete pendingorders)

class Block101: public MDL_DeletePendingOrders<string,string,string,string,string,string,color>

{



	public: /* Constructor */

	Block101() {

		__block_number = 101;

		__block_user_number = "2706";

		_beforeExecuteEnabled = true;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		ArrowColor = (color)clrDeepPink;

	}

};



// Block 2707 (Check max distancebuy)

class Block102: public MDL_CheckDistance<MDLIC_candles_candles,double,MDLIC_candles_candles,double,bool,string,MDLIC_value_points,double>

{



	public: /* Constructor */

	Block102() {

		__block_number = 102;

		__block_user_number = "2707";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {34};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		UpperLevel.iOHLC = "iHigh";

		UpperLevel.CandleID = 1;

		LowerLevel.iOHLC = "iLow";

		LowerLevel.CandleID = 1;

		// Block input parameters

		CompareDistance = "<";

	}



	public: /* Custom methods */

	virtual double _UpperLevel_() {

		UpperLevel.Symbol = CurrentSymbol();

		UpperLevel.Period = CurrentTimeframe();



		return UpperLevel._execute_();

	}

	virtual double _LowerLevel_() {

		LowerLevel.Symbol = CurrentSymbol();

		LowerLevel.Period = CurrentTimeframe();



		return LowerLevel._execute_();

	}

	virtual double _dDistance_() {

		dDistance.Value = c::max_pips_distance;

		dDistance.Symbol = CurrentSymbol();



		return dDistance._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[34].run(102);

		}

	}

};



// Block 5221 (Sell pendingLKZ order)

class Block103: public MDL_SellPending<string,string,string,MDLIC_candles_candles,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>

{



	public: /* Constructor */

	Block103() {

		__block_number = 103;

		__block_user_number = "5221";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dPrice.iOHLC = "iLow";

		dPrice.CandleID = 1;

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iHigh";

		dlStopLoss.CandleID = 1;

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		ddTakeProfit.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		dExp.ModeTime = 1;

		dExp.TimeStamp = "12:00";

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		Price = "dynamic";

		PriceOffset = 0.0;

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		ExpMode = "custom";

		MyComment = "bear -> breaks above -> london";

	}



	public: /* Custom methods */

	virtual double _dPrice_() {

		dPrice.Symbol = CurrentSymbol();

		dPrice.Period = CurrentTimeframe();



		return dPrice._execute_();

	}

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorSell = (color)clrRed;

	}

};



// Block 5384 (Check max distanceSell)

class Block104: public MDL_CheckDistance<MDLIC_candles_candles,double,MDLIC_candles_candles,double,bool,string,MDLIC_value_points,double>

{



	public: /* Constructor */

	Block104() {

		__block_number = 104;

		__block_user_number = "5384";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {113};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		UpperLevel.iOHLC = "iHigh";

		UpperLevel.CandleID = 1;

		LowerLevel.iOHLC = "iLow";

		LowerLevel.CandleID = 1;

		// Block input parameters

		CompareDistance = "<";

	}



	public: /* Custom methods */

	virtual double _UpperLevel_() {

		UpperLevel.Symbol = CurrentSymbol();

		UpperLevel.Period = CurrentTimeframe();



		return UpperLevel._execute_();

	}

	virtual double _LowerLevel_() {

		LowerLevel.Symbol = CurrentSymbol();

		LowerLevel.Period = CurrentTimeframe();



		return LowerLevel._execute_();

	}

	virtual double _dDistance_() {

		dDistance.Value = c::max_pips_distance;

		dDistance.Symbol = CurrentSymbol();



		return dDistance._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[113].run(104);

		}

	}

};



// Block 5385 (isLondonKZ)

class Block105: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block105() {

		__block_number = 105;

		__block_user_number = "5385";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {110,112};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isLondonKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[112].run(105);

		}

		else if (value == 1) {

			_blocks_[110].run(105);

		}

	}

};



// Block 5386 (Sell pendingNYKZ order)

class Block106: public MDL_SellPending<string,string,string,MDLIC_candles_candles,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>

{



	public: /* Constructor */

	Block106() {

		__block_number = 106;

		__block_user_number = "5386";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dPrice.iOHLC = "iLow";

		dPrice.CandleID = 1;

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iHigh";

		dlStopLoss.CandleID = 1;

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		ddTakeProfit.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		dExp.ModeTime = 1;

		dExp.TimeStamp = "17:30";

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		Price = "dynamic";

		PriceOffset = 0.0;

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		ExpMode = "custom";

		MyComment = "bear -> breaks above -> new york";

	}



	public: /* Custom methods */

	virtual double _dPrice_() {

		dPrice.Symbol = CurrentSymbol();

		dPrice.Period = CurrentTimeframe();



		return dPrice._execute_();

	}

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorSell = (color)clrRed;

	}

};



// Block 5958 (Log message)

class Block107: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block107() {

		__block_number = 107;

		__block_user_number = "5958";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {103};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "bear -> breaks above -> london";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[103].run(107);

		}

	}

};



// Block 5959 (Log message)

class Block108: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block108() {

		__block_number = 108;

		__block_user_number = "5959";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {106};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "bear -> breaks above -> new york";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[106].run(108);

		}

	}

};



// Block 6072 (Spread Filter)

class Block109: public MDL_Spreadfilter<string,string,string,double,int,double>

{



	public: /* Constructor */

	Block109() {

		__block_number = 109;

		__block_user_number = "6072";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {107};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		maxSpread = 3.0;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[107].run(109);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

	}

};



// Block 6073 (Once per bar)

class Block110: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>

{



	public: /* Constructor */

	Block110() {

		__block_number = 110;

		__block_user_number = "6073";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {109};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[109].run(110);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}

};



// Block 6074 (Spread Filter)

class Block111: public MDL_Spreadfilter<string,string,string,double,int,double>

{



	public: /* Constructor */

	Block111() {

		__block_number = 111;

		__block_user_number = "6074";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {108};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		maxSpread = 3.0;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[108].run(111);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

	}

};



// Block 6075 (Once per bar)

class Block112: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>

{



	public: /* Constructor */

	Block112() {

		__block_number = 112;

		__block_user_number = "6075";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {111};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[111].run(112);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}

};



// Block 7726 (Delete pendingorders)

class Block113: public MDL_DeletePendingOrders<string,string,string,string,string,string,color>

{



	public: /* Constructor */

	Block113() {

		__block_number = 113;

		__block_user_number = "7726";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {105};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		BuysOrSells = "sells";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[105].run(113);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		ArrowColor = (color)clrDeepPink;

	}

};



// Block 7727 (50ema &lt; 200ema)

class Block114: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_indicators_iMA,double,int>

{



	public: /* Constructor */

	Block114() {

		__block_number = 114;

		__block_user_number = "7727";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {27};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.MAperiod = 50;

		Ro.MAperiod = 200;

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.MAmethod = MODE_EMA;

		Lo.AppliedPrice = PRICE_CLOSE;

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.MAmethod = MODE_EMA;

		Ro.AppliedPrice = PRICE_CLOSE;

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[27].run(114);

		}

	}

};



// Block 7728 (Pass)

class Block115: public MDL_Pass

{



	public: /* Constructor */

	Block115() {

		__block_number = 115;

		__block_user_number = "7728";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {146};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[146].run(115);

		}

	}

};



// Block 7729 (isInitialized)

class Block116: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block116() {

		__block_number = 116;

		__block_user_number = "7729";





		// Fill the list of outbound blocks

		int ___outbound_blocks[3] = {118,121,122};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

		// Block input parameters

		compare = "!=";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::ny_kz_high;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[118].run(116);

		}

		else if (value == 1) {

			_blocks_[121].run(116);

			_blocks_[122].run(116);

		}

	}

};



// Block 7730 (isNewYorkKZ)

class Block117: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block117() {

		__block_number = 117;

		__block_user_number = "7730";





		// Fill the list of outbound blocks

		int ___outbound_blocks[3] = {116,119,147};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isNewYorkKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[147].run(117);

		}

		else if (value == 1) {

			_blocks_[116].run(117);

			_blocks_[119].run(117);

		}

	}

};



// Block 7731 (InitializeNY_KZVariables)

class Block118: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_candles_candles,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block118() {

		__block_number = 118;

		__block_user_number = "7731";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {121,122};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {

		Value2.Symbol = CurrentSymbol();

		Value2.Period = CurrentTimeframe();



		return Value2._execute_();

	}

	virtual string _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[121].run(118);

			_blocks_[122].run(118);

		}

	}



	virtual void _beforeExecute_()

	{



		v::ny_kz_high = _Value1_();

		v::ny_kz_low = _Value2_();

	}

};



// Block 7732 (Once per bar)

class Block119: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>

{



	public: /* Constructor */

	Block119() {

		__block_number = 119;

		__block_user_number = "7732";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {120};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[120].run(119);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}

};



// Block 7733 (incrementcandle count)

class Block120: public MDL_Formula_5<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block120() {

		__block_number = 120;

		__block_user_number = "7733";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {10};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::ny_kz_candle_count;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[10].run(120);

		}

	}

};



// Block 7734 (candle high&nbsp;&gt; high variable)

class Block121: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block121() {

		__block_number = 121;

		__block_user_number = "7734";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {124};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iHigh";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::ny_kz_high;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[124].run(121);

		}

	}

};



// Block 7735 (candle low&nbsp;&lt;low variable)

class Block122: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block122() {

		__block_number = 122;

		__block_user_number = "7735";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {125};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iLow";

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::ny_kz_low;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[125].run(122);

		}

	}

};



// Block 7736 (OR)

class Block123: public MDL_LogicalOR

{



	public: /* Constructor */

	Block123() {

		__block_number = 123;

		__block_user_number = "7736";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {10};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[10].run(123);

		}

	}

};



// Block 7737 (updatehigh)

class Block124: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block124() {

		__block_number = 124;

		__block_user_number = "7737";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {123};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Value1.iOHLC = "iHigh";

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[123].run(124);

		}

	}



	virtual void _beforeExecute_()

	{



		v::ny_kz_high = _Value1_();

	}

};



// Block 7738 (updatelow)

class Block125: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block125() {

		__block_number = 125;

		__block_user_number = "7738";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {123};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Value1.iOHLC = "iLow";

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[123].run(125);

		}

	}



	virtual void _beforeExecute_()

	{



		v::ny_kz_low = _Value1_();

	}

};



// Block 7739 (Draw LKZ Box)

class Block126: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block126() {

		__block_number = 126;

		__block_user_number = "7739";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {128};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		ObjTime3.ModeTime = 3;

		ObjTime3.TimeCandleID = 20;

		ObjPrice3.CandleID = 20;

		ObjPrice3.TimeStamp = "";

		// Block input parameters

		ObjName = "lkz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::l_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::l_kz_high;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::l_kz_low;



		return ObjPrice2._execute_();

	}

	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}

	virtual double _ObjPrice3_() {

		ObjPrice3.Symbol = CurrentSymbol();

		ObjPrice3.Period = CurrentTimeframe();



		return ObjPrice3._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[128].run(126);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_RECTANGLE;

		ObjBorderType = (int)BORDER_FLAT;

		ObjBgColor = (color)clrNONE;

		ObjCorner = (int)CORNER_LEFT_UPPER;

		ObjColor = (color)clrDeepPink;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_DASH;

	}

};



// Block 7745 (Delete LKZ)

class Block127: public MDL_ChartDeleteObjects<string,string,color,string,int,int>

{



	public: /* Constructor */

	Block127() {

		__block_number = 127;

		__block_user_number = "7745";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {126};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		NameStartsWith = "lkz";

		MaxObjects = 4;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[126].run(127);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjColor = (color)EMPTY_VALUE;

	}

};



// Block 7753 (Draw LKZ Text)

class Block128: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block128() {

		__block_number = 128;

		__block_user_number = "7753";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {129};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjText.Text = "London KZ";

		// Block input parameters

		ObjName = "lkz";

		ObjFontSize = 11;

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::l_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::l_kz_high;



		return ObjPrice1._execute_();

	}

	virtual string _ObjText_() {return ObjText._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[129].run(128);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TEXT;

		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;

		ObjAnchor = (int)ANCHOR_LEFT_UPPER;

		ObjColor = (color)clrDeepPink;

	}

};



// Block 7757 (Draw Fractal Up Line)

class Block129: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block129() {

		__block_number = 129;

		__block_user_number = "7757";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {130};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "lkz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::l_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_up_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_up_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[130].run(129);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 7758 (Draw Fractal Down Line)

class Block130: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block130() {

		__block_number = 130;

		__block_user_number = "7758";

		_beforeExecuteEnabled = true;



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "lkz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::l_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_down_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_down_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 15446 (Pass)

class Block131: public MDL_Pass

{



	public: /* Constructor */

	Block131() {

		__block_number = 131;

		__block_user_number = "15446";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {142};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[142].run(131);

		}

	}

};



// Block 15447 (isInitialized)

class Block132: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block132() {

		__block_number = 132;

		__block_user_number = "15447";





		// Fill the list of outbound blocks

		int ___outbound_blocks[3] = {134,137,138};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

		// Block input parameters

		compare = "!=";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::l_kz_high;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[134].run(132);

		}

		else if (value == 1) {

			_blocks_[137].run(132);

			_blocks_[138].run(132);

		}

	}

};



// Block 15448 (isLondonKZ)

class Block133: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block133() {

		__block_number = 133;

		__block_user_number = "15448";





		// Fill the list of outbound blocks

		int ___outbound_blocks[3] = {132,135,143};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isLondonKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[143].run(133);

		}

		else if (value == 1) {

			_blocks_[132].run(133);

			_blocks_[135].run(133);

		}

	}

};



// Block 15449 (InitializeL_KZVariables)

class Block134: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_candles_candles,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block134() {

		__block_number = 134;

		__block_user_number = "15449";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {137,138};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {

		Value2.Symbol = CurrentSymbol();

		Value2.Period = CurrentTimeframe();



		return Value2._execute_();

	}

	virtual string _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[137].run(134);

			_blocks_[138].run(134);

		}

	}



	virtual void _beforeExecute_()

	{



		v::l_kz_high = _Value1_();

		v::l_kz_low = _Value2_();

	}

};



// Block 15450 (Once per bar)

class Block135: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>

{



	public: /* Constructor */

	Block135() {

		__block_number = 135;

		__block_user_number = "15450";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {136};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[136].run(135);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}

};



// Block 15451 (incrementcandle count)

class Block136: public MDL_Formula_6<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block136() {

		__block_number = 136;

		__block_user_number = "15451";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {127};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::l_kz_candle_count;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[127].run(136);

		}

	}

};



// Block 15452 (candle high&nbsp;&gt; high variable)

class Block137: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block137() {

		__block_number = 137;

		__block_user_number = "15452";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {140};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iHigh";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::l_kz_high;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[140].run(137);

		}

	}

};



// Block 15453 (candle low&nbsp;&lt;low variable)

class Block138: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block138() {

		__block_number = 138;

		__block_user_number = "15453";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {141};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iLow";

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::l_kz_low;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[141].run(138);

		}

	}

};



// Block 15454 (OR)

class Block139: public MDL_LogicalOR

{



	public: /* Constructor */

	Block139() {

		__block_number = 139;

		__block_user_number = "15454";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {127};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[127].run(139);

		}

	}

};



// Block 15455 (updatehigh)

class Block140: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block140() {

		__block_number = 140;

		__block_user_number = "15455";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {139};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Value1.iOHLC = "iHigh";

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[139].run(140);

		}

	}



	virtual void _beforeExecute_()

	{



		v::l_kz_high = _Value1_();

	}

};



// Block 15456 (updatelow)

class Block141: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block141() {

		__block_number = 141;

		__block_user_number = "15456";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {139};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Value1.iOHLC = "iLow";

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[139].run(141);

		}

	}



	virtual void _beforeExecute_()

	{



		v::l_kz_low = _Value1_();

	}

};



// Block 15457 (London KZ)

class Block142: public MDL_TimeFilter<string,string,string,int,int,double,double,double,int,string,string,int,int,double,double,double,int,int,int,double,double,double,int>

{



	public: /* Constructor */

	Block142() {

		__block_number = 142;

		__block_user_number = "15457";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {133,144};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[144].run(142);

		}

		else if (value == 1) {

			_blocks_[133].run(142);

		}

	}



	virtual void _beforeExecute_()

	{



		TimeStart = (string)c::london_killzone_start;

		TimeEnd = (string)c::london_killzone_end;

	}

};



// Block 15464 (set LKZ)

class Block143: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block143() {

		__block_number = 143;

		__block_user_number = "15464";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {132,135};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[132].run(143);

			_blocks_[135].run(143);

		}

	}



	virtual void _beforeExecute_()

	{



		v::isLondonKZ = _Value1_();

	}

};



// Block 15472 (notLondonKZ)

class Block144: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block144() {

		__block_number = 144;

		__block_user_number = "15472";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {158};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isLondonKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[158].run(144);

		}

	}

};



// Block 15473 (set LKZ)

class Block145: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block145() {

		__block_number = 145;

		__block_user_number = "15473";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Boolean = false;

		Value2.Value = 0.0;

		Value3.Value = 0.0;

		Value4.Value = -1;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::isLondonKZ = _Value1_();

		v::l_kz_high = _Value2_();

		v::l_kz_low = _Value3_();

		v::l_kz_candle_count = _Value4_();

	}

};



// Block 15474 (New York KZ)

class Block146: public MDL_TimeFilter<string,string,string,int,int,double,double,double,int,string,string,int,int,double,double,double,int,int,int,double,double,double,int>

{



	public: /* Constructor */

	Block146() {

		__block_number = 146;

		__block_user_number = "15474";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {117,148};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[148].run(146);

		}

		else if (value == 1) {

			_blocks_[117].run(146);

		}

	}



	virtual void _beforeExecute_()

	{



		TimeStart = (string)c::newyork_killzone_start;

		TimeEnd = (string)c::newyork_killzone_end;

	}

};



// Block 15484 (set NYKZ)

class Block147: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block147() {

		__block_number = 147;

		__block_user_number = "15484";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {116,119};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[116].run(147);

			_blocks_[119].run(147);

		}

	}



	virtual void _beforeExecute_()

	{



		v::isNewYorkKZ = _Value1_();

	}

};



// Block 15485 (notNewYorkKZ)

class Block148: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block148() {

		__block_number = 148;

		__block_user_number = "15485";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {153};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isNewYorkKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[153].run(148);

		}

	}

};



// Block 15486 (set NYKZ)

class Block149: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block149() {

		__block_number = 149;

		__block_user_number = "15486";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Boolean = false;

		Value2.Value = 0.0;

		Value3.Value = 0.0;

		Value4.Value = -1;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::isNewYorkKZ = _Value1_();

		v::ny_kz_high = _Value2_();

		v::ny_kz_low = _Value3_();

		v::ny_kz_candle_count = _Value4_();

	}

};



// Block 15487 (isNewYorkKZ)

class Block150: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block150() {

		__block_number = 150;

		__block_user_number = "15487";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {1,151};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isNewYorkKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[151].run(150);

		}

		else if (value == 1) {

			_blocks_[1].run(150);

		}

	}

};



// Block 15488 (isLondonKZ)

class Block151: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block151() {

		__block_number = 151;

		__block_user_number = "15488";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {1,189};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isLondonKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[189].run(151);

		}

		else if (value == 1) {

			_blocks_[1].run(151);

		}

	}

};



// Block 15491 (Draw NYKZ Box)

class Block152: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block152() {

		__block_number = 152;

		__block_user_number = "15491";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {154};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		ObjTime3.ModeTime = 3;

		ObjTime3.TimeCandleID = 20;

		ObjPrice3.CandleID = 20;

		ObjPrice3.TimeStamp = "";

		// Block input parameters

		ObjName = "nykz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::ny_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::ny_kz_high;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::ny_kz_low;



		return ObjPrice2._execute_();

	}

	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}

	virtual double _ObjPrice3_() {

		ObjPrice3.Symbol = CurrentSymbol();

		ObjPrice3.Period = CurrentTimeframe();



		return ObjPrice3._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[154].run(152);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_RECTANGLE;

		ObjBorderType = (int)BORDER_FLAT;

		ObjBgColor = (color)clrNONE;

		ObjCorner = (int)CORNER_LEFT_UPPER;

		ObjColor = (color)clrBlueViolet;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_DASH;

	}

};



// Block 15497 (Delete NYKZ)

class Block153: public MDL_ChartDeleteObjects<string,string,color,string,int,int>

{



	public: /* Constructor */

	Block153() {

		__block_number = 153;

		__block_user_number = "15497";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {152};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		NameStartsWith = "nykz";

		MaxObjects = 4;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[152].run(153);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjColor = (color)EMPTY_VALUE;

	}

};



// Block 15505 (Draw NYKZ Text)

class Block154: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block154() {

		__block_number = 154;

		__block_user_number = "15505";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {155};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjText.Text = "NewYork KZ";

		// Block input parameters

		ObjName = "nykz";

		ObjFontSize = 11;

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::ny_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::ny_kz_high;



		return ObjPrice1._execute_();

	}

	virtual string _ObjText_() {return ObjText._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[155].run(154);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TEXT;

		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;

		ObjAnchor = (int)ANCHOR_LEFT_UPPER;

		ObjColor = (color)clrBlueViolet;

	}

};



// Block 15509 (Draw Fractal Up Line)

class Block155: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block155() {

		__block_number = 155;

		__block_user_number = "15509";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {156};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "nykz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::ny_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_up_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_up_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[156].run(155);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 15510 (Draw Fractal Down Line)

class Block156: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block156() {

		__block_number = 156;

		__block_user_number = "15510";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {149};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "nykz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::ny_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_down_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_down_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[149].run(156);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 15511 (Draw LKZ Box)

class Block157: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block157() {

		__block_number = 157;

		__block_user_number = "15511";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {159};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		ObjTime3.ModeTime = 3;

		ObjTime3.TimeCandleID = 20;

		ObjPrice3.CandleID = 20;

		ObjPrice3.TimeStamp = "";

		// Block input parameters

		ObjName = "lkz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::l_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::l_kz_high;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::l_kz_low;



		return ObjPrice2._execute_();

	}

	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}

	virtual double _ObjPrice3_() {

		ObjPrice3.Symbol = CurrentSymbol();

		ObjPrice3.Period = CurrentTimeframe();



		return ObjPrice3._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[159].run(157);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_RECTANGLE;

		ObjBorderType = (int)BORDER_FLAT;

		ObjBgColor = (color)clrNONE;

		ObjCorner = (int)CORNER_LEFT_UPPER;

		ObjColor = (color)clrDeepPink;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_DASH;

	}

};



// Block 15517 (Delete LKZ)

class Block158: public MDL_ChartDeleteObjects<string,string,color,string,int,int>

{



	public: /* Constructor */

	Block158() {

		__block_number = 158;

		__block_user_number = "15517";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {157};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		NameStartsWith = "lkz";

		MaxObjects = 4;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[157].run(158);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjColor = (color)EMPTY_VALUE;

	}

};



// Block 15525 (Draw LKZ Text)

class Block159: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block159() {

		__block_number = 159;

		__block_user_number = "15525";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {160};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjText.Text = "London KZ";

		// Block input parameters

		ObjName = "lkz";

		ObjFontSize = 11;

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::l_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::l_kz_high;



		return ObjPrice1._execute_();

	}

	virtual string _ObjText_() {return ObjText._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[160].run(159);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TEXT;

		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;

		ObjAnchor = (int)ANCHOR_LEFT_UPPER;

		ObjColor = (color)clrDeepPink;

	}

};



// Block 15529 (Draw Fractal Up Line)

class Block160: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block160() {

		__block_number = 160;

		__block_user_number = "15529";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {161};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "lkz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::l_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_up_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_up_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[161].run(160);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 15530 (Draw Fractal Down Line)

class Block161: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block161() {

		__block_number = 161;

		__block_user_number = "15530";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {145};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "lkz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::l_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_down_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_down_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[145].run(161);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 15531 (isTargetHit)

class Block162: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block162() {

		__block_number = 162;

		__block_user_number = "15531";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {95};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {return Lo._execute_();}

	virtual bool _Ro_() {

		Ro.Boolean = v::is_target_hit;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[95].run(162);

		}

	}

};



// Block 23239 (Pass)

class Block163: public MDL_Pass

{



	public: /* Constructor */

	Block163() {

		__block_number = 163;

		__block_user_number = "23239";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {174};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[174].run(163);

		}

	}

};



// Block 23240 (isInitialized)

class Block164: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block164() {

		__block_number = 164;

		__block_user_number = "23240";





		// Fill the list of outbound blocks

		int ___outbound_blocks[3] = {166,169,170};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

		// Block input parameters

		compare = "!=";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::a_kz_high;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[166].run(164);

		}

		else if (value == 1) {

			_blocks_[169].run(164);

			_blocks_[170].run(164);

		}

	}

};



// Block 23241 (isAsianKZ)

class Block165: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block165() {

		__block_number = 165;

		__block_user_number = "23241";





		// Fill the list of outbound blocks

		int ___outbound_blocks[3] = {164,167,175};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isAsianKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[175].run(165);

		}

		else if (value == 1) {

			_blocks_[164].run(165);

			_blocks_[167].run(165);

		}

	}

};



// Block 23242 (InitializeL_KZVariables)

class Block166: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_candles_candles,double,int,MDLIC_text_text,string,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block166() {

		__block_number = 166;

		__block_user_number = "23242";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {169,170};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {

		Value2.Symbol = CurrentSymbol();

		Value2.Period = CurrentTimeframe();



		return Value2._execute_();

	}

	virtual string _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[169].run(166);

			_blocks_[170].run(166);

		}

	}



	virtual void _beforeExecute_()

	{



		v::a_kz_high = _Value1_();

		v::a_kz_low = _Value2_();

	}

};



// Block 23243 (Once per bar)

class Block167: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>

{



	public: /* Constructor */

	Block167() {

		__block_number = 167;

		__block_user_number = "23243";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {168};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[168].run(167);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}

};



// Block 23244 (incrementcandle count)

class Block168: public MDL_Formula_7<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block168() {

		__block_number = 168;

		__block_user_number = "23244";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {184};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::a_kz_candle_count;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[184].run(168);

		}

	}

};



// Block 23245 (candle high&nbsp;&gt; high variable)

class Block169: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block169() {

		__block_number = 169;

		__block_user_number = "23245";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {172};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iHigh";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::a_kz_high;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[172].run(169);

		}

	}

};



// Block 23246 (candle low&nbsp;&lt;low variable)

class Block170: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block170() {

		__block_number = 170;

		__block_user_number = "23246";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {173};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iLow";

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::a_kz_low;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[173].run(170);

		}

	}

};



// Block 23247 (OR)

class Block171: public MDL_LogicalOR

{



	public: /* Constructor */

	Block171() {

		__block_number = 171;

		__block_user_number = "23247";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {184};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[184].run(171);

		}

	}

};



// Block 23248 (updatehigh)

class Block172: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block172() {

		__block_number = 172;

		__block_user_number = "23248";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {171};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Value1.iOHLC = "iHigh";

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[171].run(172);

		}

	}



	virtual void _beforeExecute_()

	{



		v::a_kz_high = _Value1_();

	}

};



// Block 23249 (updatelow)

class Block173: public MDL_ModifyVariables<int,MDLIC_candles_candles,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block173() {

		__block_number = 173;

		__block_user_number = "23249";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {171};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Value1.iOHLC = "iLow";

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[171].run(173);

		}

	}



	virtual void _beforeExecute_()

	{



		v::a_kz_low = _Value1_();

	}

};



// Block 23250 (Asian KZ)

class Block174: public MDL_TimeFilter<string,string,string,int,int,double,double,double,int,string,string,int,int,double,double,double,int,int,int,double,double,double,int>

{



	public: /* Constructor */

	Block174() {

		__block_number = 174;

		__block_user_number = "23250";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {165,176};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[176].run(174);

		}

		else if (value == 1) {

			_blocks_[165].run(174);

		}

	}



	virtual void _beforeExecute_()

	{



		TimeStart = (string)c::asian_killzone_start;

		TimeEnd = (string)c::asian_killzone_end;

	}

};



// Block 23257 (set AKZ)

class Block175: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block175() {

		__block_number = 175;

		__block_user_number = "23257";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {164,167};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[164].run(175);

			_blocks_[167].run(175);

		}

	}



	virtual void _beforeExecute_()

	{



		v::isAsianKZ = _Value1_();

	}

};



// Block 23265 (notAsianKZ)

class Block176: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block176() {

		__block_number = 176;

		__block_user_number = "23265";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {179};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isAsianKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[179].run(176);

		}

	}

};



// Block 23266 (set AKZ)

class Block177: public MDL_ModifyVariables<int,MDLIC_boolean_boolean,bool,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block177() {

		__block_number = 177;

		__block_user_number = "23266";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Boolean = false;

		Value2.Value = 0.0;

		Value3.Value = 0.0;

		Value4.Value = -1;

	}



	public: /* Custom methods */

	virtual bool _Value1_() {return Value1._execute_();}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::isAsianKZ = _Value1_();

		v::a_kz_high = _Value2_();

		v::a_kz_low = _Value3_();

		v::a_kz_candle_count = _Value4_();

	}

};



// Block 23304 (Draw AKZ Box)

class Block178: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block178() {

		__block_number = 178;

		__block_user_number = "23304";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {180};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		ObjTime3.ModeTime = 3;

		ObjTime3.TimeCandleID = 20;

		ObjPrice3.CandleID = 20;

		ObjPrice3.TimeStamp = "";

		// Block input parameters

		ObjName = "akz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::a_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::a_kz_high;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::a_kz_low;



		return ObjPrice2._execute_();

	}

	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}

	virtual double _ObjPrice3_() {

		ObjPrice3.Symbol = CurrentSymbol();

		ObjPrice3.Period = CurrentTimeframe();



		return ObjPrice3._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[180].run(178);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_RECTANGLE;

		ObjBorderType = (int)BORDER_FLAT;

		ObjBgColor = (color)clrNONE;

		ObjCorner = (int)CORNER_LEFT_UPPER;

		ObjColor = (color)clrOrangeRed;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_DASH;

	}

};



// Block 23310 (Delete AKZ)

class Block179: public MDL_ChartDeleteObjects<string,string,color,string,int,int>

{



	public: /* Constructor */

	Block179() {

		__block_number = 179;

		__block_user_number = "23310";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {178};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		NameStartsWith = "akz";

		MaxObjects = 4;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[178].run(179);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjColor = (color)EMPTY_VALUE;

	}

};



// Block 23318 (Draw AKZ Text)

class Block180: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block180() {

		__block_number = 180;

		__block_user_number = "23318";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {181};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjText.Text = "Asian KZ";

		// Block input parameters

		ObjName = "akz";

		ObjFontSize = 11;

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::a_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::a_kz_high;



		return ObjPrice1._execute_();

	}

	virtual string _ObjText_() {return ObjText._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[181].run(180);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TEXT;

		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;

		ObjAnchor = (int)ANCHOR_LEFT_UPPER;

		ObjColor = (color)clrOrangeRed;

	}

};



// Block 23322 (Draw Fractal Up Line)

class Block181: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block181() {

		__block_number = 181;

		__block_user_number = "23322";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {182};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "akz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::a_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_up_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_up_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[182].run(181);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 23323 (Draw Fractal Down Line)

class Block182: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block182() {

		__block_number = 182;

		__block_user_number = "23323";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {177};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "akz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::a_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_down_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_down_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[177].run(182);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 23324 (Draw AKZ Box)

class Block183: public MDL_ChartDrawShape<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_time,datetime,MDLIC_candles_candles,double,int,int,bool,int,int,int,color,int,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block183() {

		__block_number = 183;

		__block_user_number = "23324";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {185};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		ObjTime3.ModeTime = 3;

		ObjTime3.TimeCandleID = 20;

		ObjPrice3.CandleID = 20;

		ObjPrice3.TimeStamp = "";

		// Block input parameters

		ObjName = "akz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::a_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::a_kz_high;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::a_kz_low;



		return ObjPrice2._execute_();

	}

	virtual datetime _ObjTime3_() {return ObjTime3._execute_();}

	virtual double _ObjPrice3_() {

		ObjPrice3.Symbol = CurrentSymbol();

		ObjPrice3.Period = CurrentTimeframe();



		return ObjPrice3._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[185].run(183);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_RECTANGLE;

		ObjBorderType = (int)BORDER_FLAT;

		ObjBgColor = (color)clrNONE;

		ObjCorner = (int)CORNER_LEFT_UPPER;

		ObjColor = (color)clrOrangeRed;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_DASH;

	}

};



// Block 23330 (Delete AKZ)

class Block184: public MDL_ChartDeleteObjects<string,string,color,string,int,int>

{



	public: /* Constructor */

	Block184() {

		__block_number = 184;

		__block_user_number = "23330";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {183};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		NameStartsWith = "akz";

		MaxObjects = 4;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[183].run(184);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjColor = (color)EMPTY_VALUE;

	}

};



// Block 23338 (Draw AKZ Text)

class Block185: public MDL_ChartDrawText<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,int,int,MDLIC_text_text,string,string,int,double,ENUM_BASE_CORNER,int,color,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block185() {

		__block_number = 185;

		__block_user_number = "23338";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {186};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjText.Text = "Asian KZ";

		// Block input parameters

		ObjName = "akz";

		ObjFontSize = 11;

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::a_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::a_kz_high;



		return ObjPrice1._execute_();

	}

	virtual string _ObjText_() {return ObjText._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[186].run(185);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TEXT;

		ObjCorner = (ENUM_BASE_CORNER)CORNER_LEFT_UPPER;

		ObjAnchor = (int)ANCHOR_LEFT_UPPER;

		ObjColor = (color)clrOrangeRed;

	}

};



// Block 23342 (Draw Fractal Up Line)

class Block186: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block186() {

		__block_number = 186;

		__block_user_number = "23342";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {187};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "akz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::a_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_up_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_up_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[187].run(186);

		}

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 23343 (Draw Fractal Down Line)

class Block187: public MDL_ChartDrawLine<bool,bool,string,ENUM_OBJECT,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_candles_candles,double,MDLIC_value_value,double,double,bool,bool,bool,color,ENUM_LINE_STYLE,int,bool,bool,bool,bool,int,string>

{



	public: /* Constructor */

	Block187() {

		__block_number = 187;

		__block_user_number = "23343";

		_beforeExecuteEnabled = true;



		// IC input parameters

		ObjTime1.iOHLC = "iTime";

		ObjTime2.iOHLC = "iTime";

		// Block input parameters

		ObjName = "akz";

	}



	public: /* Custom methods */

	virtual double _ObjTime1_() {

		ObjTime1.CandleID = v::a_kz_candle_count;

		ObjTime1.Symbol = CurrentSymbol();

		ObjTime1.Period = CurrentTimeframe();



		return ObjTime1._execute_();

	}

	virtual double _ObjPrice1_() {

		ObjPrice1.Value = v::cur_fractal_down_1;



		return ObjPrice1._execute_();

	}

	virtual double _ObjTime2_() {

		ObjTime2.Symbol = CurrentSymbol();

		ObjTime2.Period = CurrentTimeframe();



		return ObjTime2._execute_();

	}

	virtual double _ObjPrice2_() {

		ObjPrice2.Value = v::cur_fractal_down_1;



		return ObjPrice2._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		ObjectType = (ENUM_OBJECT)OBJ_TREND;

		ObjColor = (color)clrBlue;

		ObjStyle = (ENUM_LINE_STYLE)STYLE_SOLID;

	}

};



// Block 23344 (Asian KZ)

class Block188: public MDL_TimeFilter<string,string,string,int,int,double,double,double,int,string,string,int,int,double,double,double,int,int,int,double,double,double,int>

{



	public: /* Constructor */

	Block188() {

		__block_number = 188;

		__block_user_number = "23344";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {97};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[97].run(188);

		}

	}



	virtual void _beforeExecute_()

	{



		TimeStart = (string)c::asian_killzone_start;

		TimeEnd = (string)c::asian_killzone_end;

	}

};



// Block 23345 (isAsianKZ)

class Block189: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block189() {

		__block_number = 189;

		__block_user_number = "23345";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {1};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isAsianKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[1].run(189);

		}

	}

};



// Block 23346 (Break even point)

class Block190: public MDL_BreakEvenPoint<string,string,string,string,string,string,double,double,double,string,double>

{



	public: /* Constructor */

	Block190() {

		__block_number = 190;

		__block_user_number = "23346";

		_beforeExecuteEnabled = true;

		// Block input parameters

		OnProfitMode = "percentSL";

		BEoffsetMode = "pips";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		OnProfitPercentSL = (double)c::break_even_point;

		BEPoffsetPips = (double)c::break_even_offset;

	}

};



// Block 23347 (Pass)

class Block191: public MDL_Pass

{



	public: /* Constructor */

	Block191() {

		__block_number = 191;

		__block_user_number = "23347";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {193};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[193].run(191);

		}

	}

};



// Block 23348 (isBreakevenEnabled)

class Block192: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block192() {

		__block_number = 192;

		__block_user_number = "23348";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {190};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = c::isBreakEvenEnabled;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[190].run(192);

		}

	}

};



// Block 23349 (If position)

class Block193: public MDL_IfOpenedOrders<string,string,string,string,string>

{



	public: /* Constructor */

	Block193() {

		__block_number = 193;

		__block_user_number = "23349";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {192};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[192].run(193);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

	}

};



// Block 23350 (Max volume(Units))

class Block194: public MDL_Formula_8<MDLIC_account_AccountFreeMargin,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block194() {

		__block_number = 194;

		__block_user_number = "23350";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {195};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 10.0;

		// Block input parameters

		compare = "*";

	}



	public: /* Custom methods */

	virtual double _Lo_() {return Lo._execute_();}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[195].run(194);

		}

	}

};



// Block 23351 (Max Lots(Standard))

class Block195: public MDL_Formula_9<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block195() {

		__block_number = 195;

		__block_user_number = "23351";





		// IC input parameters

		Ro.Value = 100000.0;

		// Block input parameters

		compare = "/";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::max_units;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}

};



// Block 23352 (candle1 close &lt;&nbsp; 50ema)

class Block196: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iMA,double,int>

{



	public: /* Constructor */

	Block196() {

		__block_number = 196;

		__block_user_number = "23352";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {202};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.CandleID = 1;

		Ro.MAperiod = 50;

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.MAmethod = MODE_EMA;

		Ro.AppliedPrice = PRICE_CLOSE;

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[202].run(196);

		}

	}

};



// Block 23353 (50ema &lt; 200ema)

class Block197: public MDL_Condition<MDLIC_indicators_iMA,double,string,MDLIC_indicators_iMA,double,int>

{



	public: /* Constructor */

	Block197() {

		__block_number = 197;

		__block_user_number = "23353";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {198};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.MAperiod = 50;

		Ro.MAperiod = 200;

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.MAmethod = MODE_EMA;

		Lo.AppliedPrice = PRICE_CLOSE;

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.MAmethod = MODE_EMA;

		Ro.AppliedPrice = PRICE_CLOSE;

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[198].run(197);

		}

	}

};



// Block 23354 (SAR condition)

class Block198: public MDL_Condition<MDLIC_indicators_iSAR,double,string,MDLIC_candles_candles,double,int>

{



	public: /* Constructor */

	Block198() {

		__block_number = 198;

		__block_user_number = "23354";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {199};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[199].run(198);

		}

	}

};



// Block 23419 (Candle breaksbelow fractal)

class Block199: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block199() {

		__block_number = 199;

		__block_user_number = "23419";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {206};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::cur_fractal_down_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[206].run(199);

		}

	}

};



// Block 25178 (Spread Filter)

class Block200: public MDL_Spreadfilter<string,string,string,double,int,double>

{



	public: /* Constructor */

	Block200() {

		__block_number = 200;

		__block_user_number = "25178";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {25};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		maxSpread = 3.0;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[25].run(200);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

	}

};



// Block 25179 (Once per bar)

class Block201: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>

{



	public: /* Constructor */

	Block201() {

		__block_number = 201;

		__block_user_number = "25179";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {200};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[200].run(201);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}

};



// Block 25180 (candle1 high &lt; 50ema)

class Block202: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iMA,double,int>

{



	public: /* Constructor */

	Block202() {

		__block_number = 202;

		__block_user_number = "25180";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {197};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iHigh";

		Lo.CandleID = 1;

		Ro.MAperiod = 50;

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.MAmethod = MODE_EMA;

		Ro.AppliedPrice = PRICE_CLOSE;

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[197].run(202);

		}

	}

};



// Block 25182 (isEnabled)

class Block203: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block203() {

		__block_number = 203;

		__block_user_number = "25182";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {204,214};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual double _Lo_() {return Lo._execute_();}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[204].run(203);

			_blocks_[214].run(203);

		}

	}

};



// Block 25184 (Debug)

class Block204: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block204() {

		__block_number = 204;

		__block_user_number = "25184";



		// Block input parameters

		PrintText = "Debug....";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}

};



// Block 25185 (candle1 high &gt; 50ema)

class Block205: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_indicators_iMA,double,int>

{



	public: /* Constructor */

	Block205() {

		__block_number = 205;

		__block_user_number = "25185";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {102};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.iOHLC = "iHigh";

		Lo.CandleID = 1;

		Ro.MAperiod = 50;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		double value = (double)Lo._execute_();

		value = value+toDigits(2,CurrentSymbol()); // Adjust the value

		return value;

	}

	virtual double _Ro_() {

		Ro.MAmethod = MODE_EMA;

		Ro.AppliedPrice = PRICE_CLOSE;

		Ro.Symbol = CurrentSymbol();

		Ro.Period = CurrentTimeframe();



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[102].run(205);

		}

	}

};



// Block 25250 (Candle breaksbelow fractal)

class Block206: public MDL_Condition<MDLIC_candles_candles,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block206() {

		__block_number = 206;

		__block_user_number = "25250";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {208};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::cur_fractal_down_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[208].run(206);

		}

	}

};



// Block 27009 (Spread Filter)

class Block207: public MDL_Spreadfilter<string,string,string,double,int,double>

{



	public: /* Constructor */

	Block207() {

		__block_number = 207;

		__block_user_number = "27009";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {215};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		maxSpread = 3.0;

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[215].run(207);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

	}

};



// Block 27010 (Once per bar)

class Block208: public MDL_OncePerBar<string,ENUM_TIMEFRAMES,int>

{



	public: /* Constructor */

	Block208() {

		__block_number = 208;

		__block_user_number = "27010";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {207};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[207].run(208);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		Period = (ENUM_TIMEFRAMES)CurrentTimeframe();

	}

};



// Block 27011 (Sell pendingLKZ order)

class Block209: public MDL_SellPending<string,string,string,MDLIC_candles_candles,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>

{



	public: /* Constructor */

	Block209() {

		__block_number = 209;

		__block_user_number = "27011";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dPrice.iOHLC = "iLow";

		dPrice.CandleID = 1;

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iHigh";

		dlStopLoss.CandleID = 1;

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		ddTakeProfit.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		dExp.ModeTime = 1;

		dExp.TimeStamp = "12:00";

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		Price = "dynamic";

		PriceOffset = 0.0;

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		ExpMode = "custom";

		MyComment = "semi bear -> breaks below -> counter trade -> london";

	}



	public: /* Custom methods */

	virtual double _dPrice_() {

		dPrice.Symbol = CurrentSymbol();

		dPrice.Period = CurrentTimeframe();



		return dPrice._execute_();

	}

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorSell = (color)clrRed;

	}

};



// Block 27175 (isLondonKZ)

class Block210: public MDL_Condition<MDLIC_boolean_boolean,bool,string,MDLIC_boolean_boolean,bool,int>

{



	public: /* Constructor */

	Block210() {

		__block_number = 210;

		__block_user_number = "27175";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {212,213};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "==";

	}



	public: /* Custom methods */

	virtual bool _Lo_() {

		Lo.Boolean = v::isLondonKZ;



		return Lo._execute_();

	}

	virtual bool _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[213].run(210);

		}

		else if (value == 1) {

			_blocks_[212].run(210);

		}

	}

};



// Block 27176 (Sell pendingNYKZ order)

class Block211: public MDL_SellPending<string,string,string,MDLIC_candles_candles,double,double,string,double,double,double,double,double,MDLIC_value_value,double,double,double,double,double,double,double,double,int,int,double,string,double,double,double,MDLIC_candles_candles,double,MDLIC_value_value,double,MDLIC_value_value,double,string,double,double,double,MDLIC_value_value,double,MDLIC_value_value,double,MDLIC_value_value,double,string,int,int,int,MDLIC_value_time,datetime,int,ulong,string,color>

{



	public: /* Constructor */

	Block211() {

		__block_number = 211;

		__block_user_number = "27176";

		_beforeExecuteEnabled = true;



		// IC input parameters

		dPrice.iOHLC = "iLow";

		dPrice.CandleID = 1;

		dVolumeSize.Value = 0.1;

		dlStopLoss.iOHLC = "iHigh";

		dlStopLoss.CandleID = 1;

		dpStopLoss.Value = 100.0;

		ddStopLoss.Value = 0.01;

		ddTakeProfit.Value = 0.01;

		dpTakeProfit.Value = 100.0;

		dExp.ModeTime = 1;

		dExp.TimeStamp = "17:30";

		dExp.TimeShiftDays = 1.0;

		dExp.TimeSkipWeekdays = true;

		// Block input parameters

		Price = "dynamic";

		PriceOffset = 0.0;

		VolumeMode = "freemarginRisk";

		StopLossMode = "dynamicLevel";

		TakeProfitMode = "percentSL";

		ExpMode = "custom";

		MyComment = "semi bear -> breaks below -> counter trade -> new york";

	}



	public: /* Custom methods */

	virtual double _dPrice_() {

		dPrice.Symbol = CurrentSymbol();

		dPrice.Period = CurrentTimeframe();



		return dPrice._execute_();

	}

	virtual double _dVolumeSize_() {return dVolumeSize._execute_();}

	virtual double _dlStopLoss_() {

		dlStopLoss.Symbol = CurrentSymbol();

		dlStopLoss.Period = CurrentTimeframe();



		return dlStopLoss._execute_();

	}

	virtual double _dpStopLoss_() {return dpStopLoss._execute_();}

	virtual double _ddStopLoss_() {return ddStopLoss._execute_();}

	virtual double _dlTakeProfit_() {return dlTakeProfit._execute_();}

	virtual double _ddTakeProfit_() {return ddTakeProfit._execute_();}

	virtual double _dpTakeProfit_() {return dpTakeProfit._execute_();}

	virtual datetime _dExp_() {return dExp._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		VolumeRisk = (double)c::risk;

		VolumeUpperLimit = (double)v::max_lot_size;

		TakeProfitPercentSL = (double)c::take_percent;

		ArrowColorSell = (color)clrRed;

	}

};



// Block 27748 (Log message)

class Block212: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block212() {

		__block_number = 212;

		__block_user_number = "27748";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {209};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "bear -> breaks above -> london";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[209].run(212);

		}

	}

};



// Block 27749 (Log message)

class Block213: public MDL_PrintMessage<string>

{



	public: /* Constructor */

	Block213() {

		__block_number = 213;

		__block_user_number = "27749";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {211};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		PrintText = "bear -> breaks above -> new york";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[211].run(213);

		}

	}

};



// Block 27750 (H4 SAR condition)

class Block214: public MDL_Condition<MDLIC_indicators_iSAR,double,string,MDLIC_candles_candles,double,int>

{



	public: /* Constructor */

	Block214() {

		__block_number = 214;

		__block_user_number = "27750";



		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = PERIOD_H4;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Symbol = CurrentSymbol();

		Ro.Period = PERIOD_H4;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}

};



// Block 27751 (Delete pendingorders)

class Block215: public MDL_DeletePendingOrders<string,string,string,string,string,string,color>

{



	public: /* Constructor */

	Block215() {

		__block_number = 215;

		__block_user_number = "27751";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {210};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		BuysOrSells = "buys";

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[210].run(215);

		}

	}



	virtual void _beforeExecute_()

	{



		Symbol = (string)CurrentSymbol();

		ArrowColor = (color)clrDeepPink;

	}

};



// Block 27800 (set fractal down2)

class Block216: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block216() {

		__block_number = 216;

		__block_user_number = "27800";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Mode = 2;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = PERIOD_H4;

		Value1.Shift = v::h4_fractal_count_down;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::h4_fractal_down_2 = _Value1_();

	}

};



// Block 27801 (Pass)

class Block217: public MDL_Pass

{



	public: /* Constructor */

	Block217() {

		__block_number = 217;

		__block_user_number = "27801";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {221};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[221].run(217);

		}

	}

};



// Block 27842 (Fractal Up visible)

class Block218: public MDL_IndicatorIsVisible<MDLIC_indicators_iFractals,double,int,int>

{



	public: /* Constructor */

	Block218() {

		__block_number = 218;

		__block_user_number = "27842";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {220,221};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Indicator_() {

		Indicator.Symbol = CurrentSymbol();

		Indicator.Period = PERIOD_H4;

		Indicator.Shift = v::h4_fractal_count_up;



		return Indicator._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[221].run(218);

		}

		else if (value == 1) {

			_blocks_[220].run(218);

		}

	}

};



// Block 27843 (set fractal up1)

class Block219: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block219() {

		__block_number = 219;

		__block_user_number = "27843";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {221};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = PERIOD_H4;

		Value1.Shift = v::h4_fractal_count_up;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[221].run(219);

		}

	}



	virtual void _beforeExecute_()

	{



		v::h4_fractal_up_1 = _Value1_();

	}

};



// Block 27847 (isFractal Up 1Set)

class Block220: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block220() {

		__block_number = 220;

		__block_user_number = "27847";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {219,222};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::h4_fractal_up_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[219].run(220);

		}

		else if (value == 1) {

			_blocks_[222].run(220);

		}

	}

};



// Block 27848 (Count UP)

class Block221: public MDL_Formula_10<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block221() {

		__block_number = 221;

		__block_user_number = "27848";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {218};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::h4_fractal_count_up;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[218].run(221);

		}

	}

};



// Block 54774 (set fractal up2)

class Block222: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block222() {

		__block_number = 222;

		__block_user_number = "54774";

		_beforeExecuteEnabled = true;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = PERIOD_H4;

		Value1.Shift = v::h4_fractal_count_up;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::h4_fractal_up_2 = _Value1_();

	}

};



// Block 54777 (set fractal up 2)

class Block223: public MDL_Formula_11<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block223() {

		__block_number = 223;

		__block_user_number = "54777";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {59};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::h4_fractal_up_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[59].run(223);

		}

	}

};



// Block 54778 (set fractal down 2)

class Block224: public MDL_Formula_12<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block224() {

		__block_number = 224;

		__block_user_number = "54778";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {61};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::h4_fractal_down_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[61].run(224);

		}

	}

};



// Block 54779 (isFractalUpDone)

class Block225: public MDL_Condition<MDLIC_indicators_iFractals,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block225() {

		__block_number = 225;

		__block_user_number = "54779";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {223};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.Shift = 2;

		// Block input parameters

		compare = "!=";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = PERIOD_H4;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::h4_fractal_up_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[223].run(225);

		}

	}

};



// Block 54780 (isFractalDownDone)

class Block226: public MDL_Condition<MDLIC_indicators_iFractals,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block226() {

		__block_number = 226;

		__block_user_number = "54780";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {224};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.Mode = 2;

		// Block input parameters

		compare = "!=";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = PERIOD_H4;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::h4_fractal_down_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[224].run(226);

		}

	}

};



// Block 54781 (H4 Fractal 1&gt;H4 Fractal 2)

class Block227: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block227() {

		__block_number = 227;

		__block_user_number = "54781";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {196,83};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::h4_fractal_up_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::h4_fractal_up_2;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[196].run(227);

		}

		else if (value == 1) {

			_blocks_[83].run(227);

		}

	}

};



// Block 54782 (H4 Fractal 1&gt;H4 Fractal 2)

class Block228: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block228() {

		__block_number = 228;

		__block_user_number = "54782";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {247};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::h4_fractal_up_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::h4_fractal_up_2;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[247].run(228);

		}

	}

};



// Block 54783 (Pass)

class Block229: public MDL_Pass

{



	public: /* Constructor */

	Block229() {

		__block_number = 229;

		__block_user_number = "54783";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {233};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[233].run(229);

		}

	}

};



// Block 54824 (Fractal Down visible)

class Block230: public MDL_IndicatorIsVisible<MDLIC_indicators_iFractals,double,int,int>

{



	public: /* Constructor */

	Block230() {

		__block_number = 230;

		__block_user_number = "54824";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {232,233};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Indicator.Mode = 2;

	}



	public: /* Custom methods */

	virtual double _Indicator_() {

		Indicator.Symbol = CurrentSymbol();

		Indicator.Period = CurrentTimeframe();

		Indicator.Shift = v::cur_fractal_count_down;



		return Indicator._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[233].run(230);

		}

		else if (value == 1) {

			_blocks_[232].run(230);

		}

	}

};



// Block 54825 (set fractal down1)

class Block231: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block231() {

		__block_number = 231;

		__block_user_number = "54825";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {233};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Value1.Mode = 2;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();

		Value1.Shift = v::cur_fractal_count_down;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[233].run(231);

		}

	}



	virtual void _beforeExecute_()

	{



		v::cur_fractal_down_1 = _Value1_();

	}

};



// Block 54829 (isFractalDown1Set)

class Block232: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block232() {

		__block_number = 232;

		__block_user_number = "54829";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {231,234};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::cur_fractal_down_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[231].run(232);

		}

		else if (value == 1) {

			_blocks_[234].run(232);

		}

	}

};



// Block 54830 (Count UP)

class Block233: public MDL_Formula_13<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block233() {

		__block_number = 233;

		__block_user_number = "54830";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {230};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::cur_fractal_count_down;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[230].run(233);

		}

	}

};



// Block 81756 (set fractal down2)

class Block234: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block234() {

		__block_number = 234;

		__block_user_number = "81756";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Mode = 2;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();

		Value1.Shift = v::cur_fractal_count_down;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::cur_fractal_down_2 = _Value1_();

	}

};



// Block 81757 (Pass)

class Block235: public MDL_Pass

{



	public: /* Constructor */

	Block235() {

		__block_number = 235;

		__block_user_number = "81757";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {239};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[239].run(235);

		}

	}

};



// Block 81798 (Fractal Up visible)

class Block236: public MDL_IndicatorIsVisible<MDLIC_indicators_iFractals,double,int,int>

{



	public: /* Constructor */

	Block236() {

		__block_number = 236;

		__block_user_number = "81798";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {238,239};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Indicator_() {

		Indicator.Symbol = CurrentSymbol();

		Indicator.Period = CurrentTimeframe();

		Indicator.Shift = v::cur_fractal_count_up;



		return Indicator._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[239].run(236);

		}

		else if (value == 1) {

			_blocks_[238].run(236);

		}

	}

};



// Block 81799 (set fractal up1)

class Block237: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block237() {

		__block_number = 237;

		__block_user_number = "81799";

		_beforeExecuteEnabled = true;



		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {239};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();

		Value1.Shift = v::cur_fractal_count_up;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[239].run(237);

		}

	}



	virtual void _beforeExecute_()

	{



		v::cur_fractal_up_1 = _Value1_();

	}

};



// Block 81803 (isFractal Up 1Set)

class Block238: public MDL_Condition<MDLIC_value_value,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block238() {

		__block_number = 238;

		__block_user_number = "81803";





		// Fill the list of outbound blocks

		int ___outbound_blocks[2] = {237,240};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::cur_fractal_up_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 0) {

			_blocks_[237].run(238);

		}

		else if (value == 1) {

			_blocks_[240].run(238);

		}

	}

};



// Block 81804 (Count UP)

class Block239: public MDL_Formula_14<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block239() {

		__block_number = 239;

		__block_user_number = "81804";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {236};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::cur_fractal_count_up;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[236].run(239);

		}

	}

};



// Block 108730 (set fractal up2)

class Block240: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block240() {

		__block_number = 240;

		__block_user_number = "108730";

		_beforeExecuteEnabled = true;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();

		Value1.Shift = v::cur_fractal_count_up;



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::cur_fractal_up_2 = _Value1_();

	}

};



// Block 108731 (set fractal down 1)

class Block241: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block241() {

		__block_number = 241;

		__block_user_number = "108731";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Mode = 2;

		Value1.Shift = 2;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::cur_fractal_down_1 = _Value1_();

	}

};



// Block 162631 (set fractal down 2)

class Block242: public MDL_Formula_15<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block242() {

		__block_number = 242;

		__block_user_number = "162631";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {241};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::cur_fractal_down_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[241].run(242);

		}

	}

};



// Block 162633 (isFractalDownDone)

class Block243: public MDL_Condition<MDLIC_indicators_iFractals,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block243() {

		__block_number = 243;

		__block_user_number = "162633";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {242};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.Mode = 2;

		Lo.Shift = 2;

		// Block input parameters

		compare = "!=";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::cur_fractal_down_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[242].run(243);

		}

	}

};



// Block 162634 (set fractal up 1)

class Block244: public MDL_ModifyVariables<int,MDLIC_indicators_iFractals,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double,int,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block244() {

		__block_number = 244;

		__block_user_number = "162634";

		_beforeExecuteEnabled = true;



		// IC input parameters

		Value1.Shift = 2;

	}



	public: /* Custom methods */

	virtual double _Value1_() {

		Value1.Symbol = CurrentSymbol();

		Value1.Period = CurrentTimeframe();



		return Value1._execute_();

	}

	virtual double _Value2_() {return Value2._execute_();}

	virtual double _Value3_() {return Value3._execute_();}

	virtual double _Value4_() {return Value4._execute_();}

	virtual double _Value5_() {return Value5._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

	}



	virtual void _beforeExecute_()

	{



		v::cur_fractal_up_1 = _Value1_();

	}

};



// Block 216535 (set fractal up 2)

class Block245: public MDL_Formula_16<MDLIC_value_value,double,string,MDLIC_value_value,double>

{



	public: /* Constructor */

	Block245() {

		__block_number = 245;

		__block_user_number = "216535";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {244};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Ro.Value = 0.0;

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Value = v::cur_fractal_up_1;



		return Lo._execute_();

	}

	virtual double _Ro_() {return Ro._execute_();}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[244].run(245);

		}

	}

};



// Block 216537 (isFractalUpDone)

class Block246: public MDL_Condition<MDLIC_indicators_iFractals,double,string,MDLIC_value_value,double,int>

{



	public: /* Constructor */

	Block246() {

		__block_number = 246;

		__block_user_number = "216537";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {245};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);



		// IC input parameters

		Lo.Shift = 2;

		// Block input parameters

		compare = "!=";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = CurrentTimeframe();



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Value = v::cur_fractal_up_1;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[245].run(246);

		}

	}

};



// Block 216539 (SAR condition)

class Block247: public MDL_Condition<MDLIC_indicators_iSAR,double,string,MDLIC_candles_candles,double,int>

{



	public: /* Constructor */

	Block247() {

		__block_number = 247;

		__block_user_number = "216539";





		// Fill the list of outbound blocks

		int ___outbound_blocks[1] = {205};

		ArrayCopy(__outbound_blocks, ___outbound_blocks);

		// Block input parameters

		compare = "<";

	}



	public: /* Custom methods */

	virtual double _Lo_() {

		Lo.Symbol = CurrentSymbol();

		Lo.Period = PERIOD_H4;



		return Lo._execute_();

	}

	virtual double _Ro_() {

		Ro.Symbol = CurrentSymbol();

		Ro.Period = PERIOD_H4;



		return Ro._execute_();

	}



	public: /* Callback & Run */

	virtual void _callback_(int value) {

		if (value == 1) {

			_blocks_[205].run(247);

		}

	}

};





/************************************************************************************************************************/

// +------------------------------------------------------------------------------------------------------------------+ //

// |                                                   Functions                                                      | //

// |                                 System and Custom functions used in the program                                  | //

// +------------------------------------------------------------------------------------------------------------------+ //

/************************************************************************************************************************/





double AccountBalance()

{

	return NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);

}



double AccountBalanceAtStart()

{

	// This function MUST be run once at pogram's start

	static double memory = 0;



	if (memory == 0)

	{

		memory = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);

	}



	return memory;

}



double AccountEquity()

{

	return AccountInfoDouble(ACCOUNT_EQUITY);

}



double AccountFreeMargin()

{

	return AccountInfoDouble(ACCOUNT_FREEMARGIN);

}



double AlignLots(string symbol, double lots, double lowerlots = 0.0, double upperlots = 0.0)

{

	double LotStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);

	double LotSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);

	double MinLots = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

	double MaxLots = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);



	if (LotStep > MinLots) MinLots = LotStep;



	if (lots == EMPTY_VALUE) {lots = 0.0;}



	lots = MathRound(lots / LotStep) * LotStep;



	if (lots < MinLots) {lots = MinLots;}

	if (lots > MaxLots) {lots = MaxLots;}



	if (lowerlots > 0.0)

	{

		lowerlots = MathRound(lowerlots / LotStep) * LotStep;

		if (lots < lowerlots) {lots = lowerlots;}

	}



	if (upperlots > 0.0)

	{

		upperlots = MathRound(upperlots / LotStep) * LotStep;

		if (lots > upperlots) {lots = upperlots;}

	}



	return lots;

}



double AlignStopLoss(

	string symbol,

	int type,

	double price,

	double slo = 0.0, // original sl, used when modifying

	double sll = 0.0,

	double slp = 0.0,

	bool consider_freezelevel = false

	)

{

	double sl = 0.0;

	

	if (MathAbs(sll) == EMPTY_VALUE) {sll = 0.0;}

	if (MathAbs(slp) == EMPTY_VALUE) {slp = 0.0;}



	if (sll == 0.0 && slp == 0.0)

	{

		return 0.0;

	}



	if (price <= 0.0)

	{

		Print(__FUNCTION__ + " error: No price entered");



		return -1;

	}



	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);

	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

	slp          = slp * PipValue(symbol) * point;



	//-- buy-sell identifier ---------------------------------------------

	int bs = 1;



	if (

		   type == ORDER_TYPE_SELL

		|| type == ORDER_TYPE_SELL_STOP

		|| type == ORDER_TYPE_SELL_LIMIT

		|| type == ORDER_TYPE_SELL_STOP_LIMIT

		)

	{

		bs = -1;

	}



	//-- prices that will be used ----------------------------------------

	double askbid = price;

	double bidask = price;



	if (type < 2)

	{

		double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);

		double bid = SymbolInfoDouble(symbol, SYMBOL_BID);



		askbid = ask;

		bidask = bid;



		if (bs < 0)

		{

		  askbid = bid;

		  bidask = ask;

		}

	}



	//-- build sl level -------------------------------------------------- 

	if (sll == 0.0 && slp != 0.0) {sll = price;}



	if (sll > 0.0) {sl = sll - slp * bs;}



	if (sl < 0.0)

	{

		return -1;

	}



	sl  = NormalizeDouble(sl, digits);

	slo = NormalizeDouble(slo, digits);



	if (sl == slo)

	{

		return sl;

	}



	//-- build limit levels ----------------------------------------------

	double minstops = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);



	if (consider_freezelevel == true)

	{

		double freezelevel = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);



		if (freezelevel > minstops) {minstops = freezelevel;}

	}



	minstops = NormalizeDouble(minstops * point,digits);



	double sllimit = bidask - minstops * bs; // SL min price level



	//-- check and align sl, print errors --------------------------------

	//-- do not do it when the stop is the same as the original

	if (sl > 0.0 && sl != slo)

	{

		if ((bs > 0 && sl > askbid) || (bs < 0 && sl < askbid))

		{

			string abstr = "";



			if (bs > 0) {abstr = "Bid";} else {abstr = "Ask";}



			Print(

				"Error: Invalid SL requested (",

				DoubleToStr(sl, digits),

				" for ", abstr, " price ",

				bidask,

				")"

			);



			return -1;

		}

		else if ((bs > 0 && sl > sllimit) || (bs < 0 && sl < sllimit))

		{

			if (USE_VIRTUAL_STOPS)

			{

				return sl;

			}



			Print(

				"Warning: Too short SL requested (",

				DoubleToStr(sl, digits),

				" or ",

				DoubleToStr(MathAbs(sl - askbid) / point, 0),

				" points), minimum will be taken (",

				DoubleToStr(sllimit, digits),

				" or ",

				DoubleToStr(MathAbs(askbid - sllimit) / point, 0),

				" points)"

			);



			sl = sllimit;



			return sl;

		}

	}



	// align by the ticksize

	double ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);

	sl = MathRound(sl / ticksize) * ticksize;



	return sl;

}



double AlignTakeProfit(

	string symbol,

	int type,

	double price,

	double tpo = 0.0, // original tp, used when modifying

	double tpl = 0.0,

	double tpp = 0.0,

	bool consider_freezelevel = false

	)

{

	double tp = 0.0;

	

	if (MathAbs(tpl) == EMPTY_VALUE) {tpl = 0.0;}

	if (MathAbs(tpp) == EMPTY_VALUE) {tpp = 0.0;}



	if (tpl == 0.0 && tpp == 0.0)

	{

		return 0.0;

	}



	if (price <= 0.0)

	{

		Print(__FUNCTION__ + " error: No price entered");



		return -1;

	}



	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);

	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

	tpp          = tpp * PipValue(symbol) * point;

	

	//-- buy-sell identifier ---------------------------------------------

	int bs = 1;



	if (

		   type == ORDER_TYPE_SELL

		|| type == ORDER_TYPE_SELL_STOP

		|| type == ORDER_TYPE_SELL_LIMIT

		|| type == ORDER_TYPE_SELL_STOP_LIMIT

		)

	{

		bs = -1;

	}

	

	//-- prices that will be used ----------------------------------------

	double askbid = price;

	double bidask = price;

	

	if (type < 2)

	{

		double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);

		double bid = SymbolInfoDouble(symbol, SYMBOL_BID);

		

		askbid = ask;

		bidask = bid;



		if (bs < 0)

		{

		  askbid = bid;

		  bidask = ask;

		}

	}

	

	//-- build tp level --------------------------------------------------- 

	if (tpl == 0.0 && tpp != 0.0) {tpl = price;}



	if (tpl > 0.0) {tp = tpl + tpp * bs;}

	

	if (tp < 0.0)

	{

		return -1;

	}



	tp  = NormalizeDouble(tp, digits);

	tpo = NormalizeDouble(tpo, digits);



	if (tp == tpo)

	{

		return tp;

	}

	

	//-- build limit levels ----------------------------------------------

	double minstops = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);



	if (consider_freezelevel == true)

	{

		double freezelevel = (double)SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);



		if (freezelevel > minstops) {minstops = freezelevel;}

	}



	minstops = NormalizeDouble(minstops * point,digits);

	

	double tplimit = bidask + minstops * bs; // TP min price level

	

	//-- check and align tp, print errors --------------------------------

	//-- do not do it when the stop is the same as the original

	if (tp > 0.0 && tp != tpo)

	{

		if ((bs > 0 && tp < bidask) || (bs < 0 && tp > bidask))

		{

			string abstr = "";



			if (bs > 0) {abstr = "Bid";} else {abstr = "Ask";}



			Print(

				"Error: Invalid TP requested (",

				DoubleToStr(tp, digits),

				" for ", abstr, " price ",

				bidask,

				")"

			);



			return -1;

		}

		else if ((bs > 0 && tp < tplimit) || (bs < 0 && tp > tplimit))

		{

			if (USE_VIRTUAL_STOPS)

			{

				return tp;

			}



			Print(

				"Warning: Too short TP requested (",

				DoubleToStr(tp, digits),

				" or ",

				DoubleToStr(MathAbs(tp - askbid) / point, 0),

				" points), minimum will be taken (",

				DoubleToStr(tplimit, digits),

				" or ",

				DoubleToStr(MathAbs(askbid - tplimit) / point, 0),

				" points)"

			);



			tp = tplimit;



			return tp;

		}

	}

	

	// align by the ticksize

	double ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);

	tp = MathRound(tp / ticksize) * ticksize;

	

	return tp;

}



template<typename T>

bool ArrayEnsureValue(T &array[], T value)

{

	int size   = ArraySize(array);



	if (size > 0)

	{

		if (InArray(array, value))

		{

			// value found -> exit

			return false; // no value added

		}

	}



	// value does not exists -> add it

	ArrayResize(array, size+1);

	array[size] = value;



	return true; // value added

}



template<typename T>

int ArraySearch(T &array[], T value)

{

	int index = -1;

	int size  = ArraySize(array);



	for (int i = 0; i < size; i++)

	{

		if (array[i] == value)

		{

			index = i;

			break;

		}  

	}



   return index;

}



template<typename T>

bool ArrayStripKey(T &array[], int key)

{

	int x    = 0;

	int size = ArraySize(array);



	for (int i=0; i<size; i++)

	{

		if (i != key)

		{

			array[x] = array[i];

			x++;

		}

	}



	if (x < size)

	{

		ArrayResize(array, x);

		

		return true; // stripped

	}



	return false; // not stripped

}



template<typename T>

bool ArrayStripValue(T &array[], T value)

{

	int x    = 0;

	int size = ArraySize(array);



	for (int i=0; i<size; i++)

	{

		if (array[i] != value)

		{

			array[x] = array[i];

			x++;

		}

	}



	if (x < size)

	{

		ArrayResize(array, x);

		

		return true; // stripped

	}



	return false; // not stripped

}



double Bet1326(

	string group,

	string symbol,

	int pool,

	double initialLots,

	bool reverse = false

) {  

	double info[];

	GetBetTradesInfo(info, group, symbol, pool, false);



	double lots         = info[0];

	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss



	//-- 1-3-2-6 Logic

	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);



	if (initialLots < minLot)

	{

		initialLots = minLot;  

	}



	if (lots == 0)

	{

		lots = initialLots;

	}

	else

	{

		if (

			   (reverse == false && profitOrLoss == 1)

			|| (reverse == true && profitOrLoss == -1)

		) {

			double div = lots / initialLots;



			     if (div < 1.5) {lots = initialLots * 3;}

			else if (div < 2.5) {lots = initialLots * 6;}

			else if (div < 3.5) {lots = initialLots * 2;}

			else {lots = initialLots;}

		}

		else

		{

			lots = initialLots;

		}

	}



	return lots;

}



double BetDalembert(

	string group,

	string symbol,

	int pool,

	double initialLots,

	double reverse = false

) {  

	double info[];

	GetBetTradesInfo(info, group, symbol, pool, false);



	double lots         = info[0];

	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss



	//-- Dalembert Logic

	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);



	if (initialLots < minLot)

	{

		initialLots = minLot;  

	}



	if (lots == 0)

	{

		lots = initialLots;

	}

	else

	{

		if (

			   (reverse == 0 && profitOrLoss == 1)

			|| (reverse == 1 && profitOrLoss == -1)

		) {

			lots = lots - initialLots;

			if (lots < initialLots) {lots = initialLots;}

		}

		else

		{

			lots = lots + initialLots;

		}

	}



	return lots;

}



double BetFibonacci(

	string group,

	string symbol,

	int pool,

	double initialLots

) {

	double info[];

	GetBetTradesInfo(info, group, symbol, pool, false);



	double lots         = info[0];

	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss



	//-- Fibonacci Logic

	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);



	if (initialLots < minLot)

	{

		initialLots = minLot;  

	}



	if (lots == 0)

	{

		lots = initialLots;

	}

	else

	{  

		int fibo1 = 1;

		int fibo2 = 0;

		int fibo3 = 0;

		int fibo4 = 0;

		double div = lots / initialLots;



		if (div <= 0) {div = 1;}



		while (true)

		{

			fibo1 = fibo1 + fibo2;

			fibo3 = fibo2;

			fibo2 = fibo1 - fibo2;

			fibo4 = fibo2 - fibo3;



			if (fibo1 > NormalizeDouble(div, 2))

			{

				break;

			}

		}



		if (profitOrLoss == 1)

		{

			if (fibo4 <= 0) {fibo4 = 1;}

			lots = initialLots * fibo4;

		}

		else

		{

			lots = initialLots * fibo1;

		}

	}



	lots = NormalizeDouble(lots, 2);



	return lots;

}



double BetLabouchere(

	string group,

	string symbol,

	int pool,

	double initialLots,

	string listOfNumbers,

	double reverse = false

) {

	double info[];

	GetBetTradesInfo(info, group, symbol, pool, false);



	double lots         = info[0];

	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss



	//-- Labouchere Logic

	static string memGroup[];

	static string memList[];

	static long memTicket[];



	int startAgain = false;



	//- get the list of numbers as it is stored in the memory, or store it

	int id = ArraySearch(memGroup, group);



	if (id == -1)

	{

		startAgain = true;



		if (listOfNumbers == "") {listOfNumbers = "1";}



		id = ArraySize(memGroup);



		ArrayResize(memGroup, id+1, id+1);

		ArrayResize(memList, id+1, id+1);

		ArrayResize(memTicket, id+1, id+1);



		memGroup[id] = group;

		memList[id]  = listOfNumbers;

	}



	if (memTicket[id] == (long)OrderTicket())

	{

		// the last known ticket (memTicket[id]) should be different than OderTicket() normally

		// when failed to create a new trade - the last ticket remains the same

		// so we need to reset

		memList[id] = listOfNumbers;

	}



	memTicket[id] = (long)OrderTicket();



	//- now turn the string into integer array

	int list[];

	string listS[];



	StringExplode(",", memList[id], listS);

	ArrayResize(list, ArraySize(listS));



	for (int s = 0; s < ArraySize(listS); s++)

	{

		list[s] = (int)StringToInteger(StringTrim(listS[s]));  

	}



	//-- 

	int size = ArraySize(list);



	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);



	if (initialLots < minLot)

	{

		initialLots = minLot;  

	}



	if (lots == 0)

	{

		startAgain = true;

	}



	if (startAgain == true)

	{

		if (size == 1)

		{

			lots = initialLots * list[0];

		}

		else {

			lots = initialLots * (list[0] + list[size-1]);

		}

	}

	else 

	{

		if (

			   (reverse == 0 && profitOrLoss == 1)

			|| (reverse == 1 && profitOrLoss == -1)

		) {

			size = size - 2;

			

			if (size < 0) {

				size = 0;

			}

			

			if (size == 0) {

				// Set the initial list of numbers

				StringExplode(",", listOfNumbers, listS);

				ArrayResize(list, ArraySize(listS));

			

				for (int s = 0; s < ArraySize(listS); s++)

				{

					list[s] = (int)StringToInteger(StringTrim(listS[s]));  

				}

				

				size = ArraySize(list);

			}

			else {

				// Cancel the first and the last number in the list

				// shift array 1 step left

				for (int pos = 0; pos < ArraySize(list) - 1; pos++) {

					list[pos] = list[pos+1];

				}

				

				ArrayResize(list, size);

			}

			

			int rightNum = (size > 1) ? list[size - 1] : 0;

			lots = initialLots * (list[0] + rightNum);



			if (lots < initialLots) {lots = initialLots;}

		}

		else

		{

			size = size + 1;

			ArrayResize(list, size);

			

			int rightNum = (size > 2) ? list[size - 2] : 0;



			list[size - 1] = list[0] + rightNum;

			lots       = initialLots * (list[0] + list[size - 1]);



			if (lots < initialLots) {lots = initialLots;}

		}

	}



	Print("Labouchere (for group "

		+ (string)id

		+ ") current list of numbers: "

		+ StringImplode(",", list)

	);



	size=ArraySize(list);



	if (size == 0)

	{

		ArrayStripKey(memGroup, id);

		ArrayStripKey(memList, id);

		ArrayStripKey(memTicket, id);

	}

	else {

		memList[id] = StringImplode(",", list);

	}



	return lots;

}



double BetMartingale(

	string group,

	string symbol,

	int pool,

	double initialLots,

	double multiplyOnLoss,

	double multiplyOnProfit,

	double addOnLoss,

	double addOnProfit,

	int resetOnLoss,

	int resetOnProfit

) {

	double info[];

	GetBetTradesInfo(info, group, symbol, pool, true);



	double lots         = info[0];

	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss

	double consecutive  = info[2];



	//-- Martingale Logic

	if (lots == 0)

	{

		lots = initialLots;

	}

	else

	{

		if (profitOrLoss == 1)

		{

			if (resetOnProfit > 0 && consecutive >= resetOnProfit)

			{

				lots = initialLots;

			}

			else

			{

				if (multiplyOnProfit <= 0)

				{

					multiplyOnProfit = 1;

				}



				lots = (lots * multiplyOnProfit) + addOnProfit;

			}

		}

		else

		{

			if (resetOnLoss > 0 && consecutive >= resetOnLoss)

			{

				lots = initialLots;  

			}

			else

			{

				if (multiplyOnLoss <= 0)

				{

					multiplyOnLoss = 1;

				}



				lots = (lots * multiplyOnLoss) + addOnLoss;

			}

		}

	}



	return lots;

}



double BetSequence(

	string group,

	string symbol,

	int pool,

	double initialLots,

	string sequenceOnLoss,

	string sequenceOnProfit,

	bool reverse = false

) {  

	double info[];

	GetBetTradesInfo(info, group, symbol, pool, false);



	double lots         = info[0];

	double profitOrLoss = info[1]; // 0 - unknown, 1 - profit, -1 - loss



	//-- Sequence stuff

	static string memGroup[];

	static string memLossList[];

	static string memProfitList[];

	static long memTicket[];



	//- get the list of numbers as it is stored in the memory, or store it

	int id = ArraySearch(memGroup, group);



	if (id == -1)

	{

		if (sequenceOnLoss == "") {sequenceOnLoss = "1";}



		if (sequenceOnProfit == "") {sequenceOnProfit = "1";}



		id = ArraySize(memGroup);



		ArrayResize(memGroup, id+1, id+1);

		ArrayResize(memLossList, id+1, id+1);

		ArrayResize(memProfitList, id+1, id+1);

		ArrayResize(memTicket, id+1, id+1);



		memGroup[id]      = group;

		memLossList[id]   = sequenceOnLoss;

		memProfitList[id] = sequenceOnProfit;

	}



	bool lossReset   = false;

	bool profitReset = false;



	if (profitOrLoss == -1 && memLossList[id] == "")

	{

		lossReset         = true;

		memProfitList[id] = "";

	}



	if (profitOrLoss == 1 && memProfitList[id] == "")

	{

		profitReset     = true;

		memLossList[id] = "";

	}



	if (profitOrLoss == 1 || memLossList[id] == "")

	{

		memLossList[id] = sequenceOnLoss;



		if (lossReset) {

			memLossList[id] = "1," + memLossList[id];

		}

	}



	if (profitOrLoss == -1 || memProfitList[id] == "")

	{

		memProfitList[id] = sequenceOnProfit;



		if (profitReset) {

			memProfitList[id] = "1," + memProfitList[id];

		}

	}



	if (memTicket[id] == (long)OrderTicket())

	{

		// Normally the last known ticket (memTicket[id]) should be different than OderTicket()

		// when failed to create a new trade, the last ticket remains the same

		// so we need to reset

		memLossList[id]   = sequenceOnLoss;

		memProfitList[id] = sequenceOnProfit;

	}



	memTicket[id] = (long)OrderTicket();



	//- now turn the string into integer array

	int s = 0;

	double listLoss[];

	double listProfit[];

	string listS[];



	StringExplode(",", memLossList[id], listS);

	ArrayResize(listLoss, ArraySize(listS), ArraySize(listS));



	for (s = 0; s < ArraySize(listS); s++)

	{

		listLoss[s] = (double)StringToDouble(StringTrim(listS[s]));  

	}



	StringExplode(",", memProfitList[id], listS);

	ArrayResize(listProfit, ArraySize(listS), ArraySize(listS));



	for (s = 0; s < ArraySize(listS); s++)

	{

		listProfit[s] = (double)StringToDouble(StringTrim(listS[s]));  

	}



	//--

	double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);



	if (initialLots < minLot)

	{

		initialLots = minLot;  

	}



	if (lots == 0)

	{

		lots = initialLots;

	}

	else

	{

		if (

			   (reverse == false && profitOrLoss ==1)

			|| (reverse == true && profitOrLoss == -1)

		) {

			lots = initialLots * listProfit[0];



			// shift array 1 step left

			int size = ArraySize(listProfit);



			for(int pos = 0; pos < size-1; pos++)

			{

				listProfit[pos] = listProfit[pos+1];

			}



			if (size > 0)

			{

				ArrayResize(listProfit, size-1, size-1);

				memProfitList[id] = StringImplode(",", listProfit);

			}

		}

		else

		{

			lots = initialLots * listLoss[0];



			// shift array 1 step left

			int size = ArraySize(listLoss);



			for(int pos = 0; pos < size-1; pos++)

			{

				listLoss[pos] = listLoss[pos+1];

			}



			if (size > 0)

			{

				ArrayResize(listLoss, size-1, size-1);

				memLossList[id] = StringImplode(",", listLoss);

			}

		}

	}



	return lots;

}



long BuyLater(

	string symbol,

	double lots,

	double price,

	double sll = 0, // SL level

	double tpl = 0, // TP level

	double slp = 0, // SL adjust in points

	double tpp = 0, // TP adjust in points

	double slippage = 0,

	datetime expiration = 0,

	int magic = 0,

	string comment = "",

	color arrowcolor = clrNONE,

	bool oco = false

	)

{

	double ask = SymbolInfoDouble(symbol,SYMBOL_ASK);

	ENUM_ORDER_TYPE type = 0;



	     if (price == ask) {type = ORDER_TYPE_BUY;}

	else if (price < ask)  {type = ORDER_TYPE_BUY_LIMIT;}

	else if (price > ask)  {type = ORDER_TYPE_BUY_STOP;}



	return OrderCreate(

		symbol,

		type,

		lots,

		price,

		sll,

		tpl,

		slp,

		tpp,

		slippage,

		magic,

		comment,

		arrowcolor,

		expiration,

		oco

	);

}



long BuyNow(

	string symbol,

	double lots,

	double sll,

	double tpl,

	double slp,

	double tpp,

	double slippage = 0,

	int magic = 0,

	string comment = "",

	color arrowcolor = clrNONE,

	datetime expiration = 0

	)

{

	return OrderCreate(

		symbol,

		POSITION_TYPE_BUY,

		lots,

		0,

		sll,

		tpl,

		slp,

		tpp,

		slippage,

		magic,

		comment,

		arrowcolor,

		expiration

	);

}



int CheckForTradingError(int error_code=-1, string msg_prefix="")

{

   // return 0 -> no error

   // return 1 -> overcomable error

   // return 2 -> fatal error

   

   int retval=0;

   static int tryouts=0;

   

   //-- error check -----------------------------------------------------

   switch(error_code)

   {

      //-- no error

      case 0:

         retval=0;

         break;

      //-- overcomable errors

      case TRADE_RETCODE_REQUOTE:

      case TRADE_RETCODE_REJECT:

      case TRADE_RETCODE_ERROR:

      case TRADE_RETCODE_TIMEOUT:

      case TRADE_RETCODE_INVALID_VOLUME:

      case TRADE_RETCODE_INVALID_PRICE:

      case TRADE_RETCODE_INVALID_STOPS:

      case TRADE_RETCODE_INVALID_EXPIRATION:

      case TRADE_RETCODE_PRICE_CHANGED:

      case TRADE_RETCODE_PRICE_OFF:

      case TRADE_RETCODE_TOO_MANY_REQUESTS:

      case TRADE_RETCODE_NO_CHANGES:

      case TRADE_RETCODE_CONNECTION:

         retval=1;

         break;

      //-- critical errors

      default:

         retval=2;

         break;

   }

   

   if (error_code > 0)

   {

      string msg = "";

      if (retval == 1)

      {

         StringConcatenate(msg, msg_prefix,": ",ErrorMessage(error_code),". Retrying in 5 seconds..");

         Sleep(500); 

      }

      else if (retval == 2)

      {

         StringConcatenate(msg, msg_prefix,": ",ErrorMessage(error_code));

      }

      Print(msg);

   }

   

   if (retval==0)

   {

      tryouts=0;

   }

   else if (retval==1)

   {

      tryouts++;

      if (tryouts>=10)

      {

         tryouts=0;

         retval=2;

      }

      else

      {

         Print("retry #"+(string)tryouts+" of 10");

      }

   }

   

   return(retval);

}



bool CloseTrade(ulong ticket, ulong deviation = 0, color clr = clrNONE)

{

	while(true)

	{

		bool success = false;



		if (!PositionSelectByTicket(ticket))

		{

			return false;

		}



		string symbol = PositionGetString(POSITION_SYMBOL);

		long magic    = PositionGetInteger(POSITION_MAGIC);

		double volume = PositionGetDouble(POSITION_VOLUME);



		// With some CFD we can open position with the max volume more than once,

		// so we get a position that has volume bigger than the maximum.

		// Then we cannot close that position, because the volume is too high.

		// For that reason here we will close it in parts.

		double max_volume  = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);

		double part_volume = (volume > max_volume) ? max_volume : volume;



		//-- close --------------------------------------------------------

		MqlTradeRequest request;

		MqlTradeResult result;

		MqlTradeCheckResult check_result;

		ZeroMemory(request);

		ZeroMemory(result);

		ZeroMemory(check_result);



		if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)

		{

			//--- prepare request for close BUY position

			request.type  = ORDER_TYPE_SELL;

			request.price = SymbolInfoDouble(symbol, SYMBOL_BID);

		}

		else

		{

			//--- prepare request for close SELL position

			request.type  = ORDER_TYPE_BUY;

			request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);

		}



		request.action    = TRADE_ACTION_DEAL;

		request.symbol    = symbol;

		request.volume    = part_volume;

		request.magic     = magic;

		request.deviation = (int)(deviation * PipValue(symbol));



		// for hedging mode

		request.position  = ticket;



		// filling type

		if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))

			request.type_filling = ORDER_FILLING_FOK;

		else if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))

			request.type_filling = ORDER_FILLING_IOC;

		else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case

			request.type_filling = ORDER_FILLING_RETURN;

		else

			request.type_filling = ORDER_FILLING_RETURN;



		success = OrderSend(request, result);



		//-- error check --------------------------------------------------

		if (!success || (result.retcode != TRADE_RETCODE_DONE && result.retcode != TRADE_RETCODE_PLACED && result.retcode != TRADE_RETCODE_DONE_PARTIAL))

		{

			string errmsgpfx = "Closing position/trade error";



			int erraction = CheckForTradingError(result.retcode, errmsgpfx);



			switch(erraction)

			{

				case 0: break;    // no error

				case 1: continue; // overcomable error

				case 2: break;    // fatal error

			}



			return false;

		}

		

		//-- finish work --------------------------------------------------

		if (result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_PLACED)

		{

			// we are closing the position in parts?

			if (volume != part_volume)

			{

				continue; // continue the "while" loop, so that the whole volume could be closed

			}



			while (true)

			{

			  	if (MQLInfoInteger(MQL_TESTER) || !PositionSelectByTicket(ticket))

				{

					break;

				}



				Sleep(10);

			}

		}



		if (success == true)

		{

			if (USE_VIRTUAL_STOPS)

			{

				VirtualStopsDriver("clear", ticket);

			}



			expirationWorker.RemoveExpiration(ticket);

		}

		

		break;

	}

	

	OnTrade();



	return true;

}



template<typename DT1, typename DT2>

bool CompareValues(string sign, DT1 v1, DT2 v2)

{

	     if (sign == ">") return(v1 > v2);

	else if (sign == "<") return(v1 < v2);

	else if (sign == ">=") return(v1 >= v2);

	else if (sign == "<=") return(v1 <= v2);

	else if (sign == "==") return(v1 == v2);

	else if (sign == "!=") return(v1 != v2);

	else if (sign == "x>") return(v1 > v2);

	else if (sign == "x<") return(v1 < v2);



	return false;

}



string CurrentSymbol(string symbol = "")

{

   static string memory = "";



	// Set

   if (symbol != "")

	{

		memory = symbol;

	}

	// Get

	else if (memory == "")

	{

		memory = Symbol();

	}



   return memory;

}



ENUM_TIMEFRAMES CurrentTimeframe(ENUM_TIMEFRAMES tf=-1)

{

   static ENUM_TIMEFRAMES memory=0;

   if (tf>=0) {memory=tf;}

   return(memory);

}



double CustomPoint(string symbol)

{

	static string symbols[];

	static double points[];

	static string last_symbol = "-";

	static double last_point  = 0;

	static int last_i         = 0;

	static int size           = 0;



	//-- variant A) use the cache for the last used symbol

	if (symbol == last_symbol)

	{

		return last_point;

	}



	//-- variant B) search in the array cache

	int i			= last_i;

	int start_i	= i;

	bool found	= false;



	if (size > 0)

	{

		while (true)

		{

			if (symbols[i] == symbol)

			{

				last_symbol	= symbol;

				last_point	= points[i];

				last_i		= i;



				return last_point;

			}



			i++;



			if (i >= size)

			{

				i = 0;

			}

			if (i == start_i) {break;}

		}

	}



	//-- variant C) add this symbol to the cache

	i		= size;

	size	= size + 1;



	ArrayResize(symbols, size);

	ArrayResize(points, size);



	symbols[i]	= symbol;

	points[i]	= 0;

	last_symbol	= symbol;

	last_i		= i;



	//-- unserialize rules from FXD_POINT_FORMAT_RULES

	string rules[];

	StringExplode(",", POINT_FORMAT_RULES, rules);



	int rules_count = ArraySize(rules);



	if (rules_count > 0)

	{

		string rule[];



		for (int r = 0; r < rules_count; r++)

		{

			StringExplode("=", rules[r], rule);



			//-- a single rule must contain 2 parts, [0] from and [1] to

			if (ArraySize(rule) != 2) {continue;}



			double from = StringToDouble(rule[0]);

			double to	= StringToDouble(rule[1]);



			//-- "to" must be a positive number, different than 0

			if (to <= 0) {continue;}



			//-- "from" can be a number or a string

			// a) string

			if (from == 0 && StringLen(rule[0]) > 0)

			{

				string s_from = rule[0];

				int pos       = StringFind(s_from, "?");



				if (pos < 0) // ? not found

				{

					if (StringFind(symbol, s_from) == 0) {points[i] = to;}

				}

				else if (pos == 0) // ? is the first symbol => match the second symbol

				{

					if (StringFind(symbol, StringSubstr(s_from, 1), 3) == 3)

					{

						points[i] = to;

					}

				}

				else if (pos > 0) // ? is the second symbol => match the first symbol

				{

					if (StringFind(symbol, StringSubstr(s_from, 0, pos)) == 0)

					{

						points[i] = to;

					}

				}

			}



			// b) number

			if (from == 0) {continue;}



			if (SymbolInfoDouble(symbol, SYMBOL_POINT) == from)

			{

				points[i] = to;

			}

		}

	}



	if (points[i] == 0)

	{

		points[i] = SymbolInfoDouble(symbol, SYMBOL_POINT);

	}



	last_point = points[i];



	return last_point;

}



bool DeleteOrder(ulong ticket, color arrowcolor=clrNONE)

{

   while(true)

   {

      MqlTradeRequest request;

      MqlTradeResult result;

      MqlTradeCheckResult check_result;

      ZeroMemory(request);

      ZeroMemory(result);

      ZeroMemory(check_result);

   

      request.order=ticket;

      request.action=TRADE_ACTION_REMOVE;

      request.comment="Pending order canceled";

   

      if (!OrderCheck(request,check_result))  {

         Print("OrderCheck() failed: "+(string)check_result.comment+" ("+(string)check_result.retcode+")");

         return false;

      }

      

      bool success = OrderSend(request,result);

      

      //-- error check --------------------------------------------------

      if (!success || result.retcode!=TRADE_RETCODE_DONE)

      {

         string errmsgpfx="Delete order error";

         int erraction=CheckForTradingError(result.retcode, errmsgpfx);

         switch(erraction)

         {

            case 0: break;    // no error

            case 1: continue; // overcomable error

            case 2: break;    // fatal error

         }

         return(false);

      }

      

      //-- finish work --------------------------------------------------

      if (result.retcode==TRADE_RETCODE_DONE)

      {

         //== Wait until MT5 updates it's cache

         int w;

         for (w=0; w<5000; w++)

         {

            if (!OrderSelect(ticket)) {break;}

            Sleep(1);

         }

         if (w==5000) {

            Print("Check error: Delete order");  

         }

         if (OrderSelect(ticket)) {

            Print("Something went wrong with the order");

            return false;

         }

      }

		

		if (success==true) {

         if (USE_VIRTUAL_STOPS) {

            VirtualStopsDriver("clear",ticket);

         }

         //RegisterEvent("trade");

         //return(true);

      }

		

      break;

   }

   OnTrade();

   return(true);

}



string DoubleToStr(double d, int dig){return(DoubleToString(d,dig));}



void DrawSpreadInfo()

{

   static bool allow_draw = true;

   if (allow_draw==false) {return;}

   if (MQLInfoInteger(MQL_TESTER) && !MQLInfoInteger(MQL_VISUAL_MODE)) {allow_draw=false;} // Allowed to draw only once in testing mode



   static bool passed         = false;

   static double max_spread   = 0;

   static double min_spread   = EMPTY_VALUE;

   static double avg_spread   = 0;

   static double avg_add      = 0;

   static double avg_cnt      = 0;



   double custom_point = CustomPoint(Symbol());

   double current_spread = 0;

   if (custom_point > 0) {

      current_spread = (SymbolInfoDouble(Symbol(),SYMBOL_ASK)-SymbolInfoDouble(Symbol(),SYMBOL_BID))/custom_point;

   }

   if (current_spread > max_spread) {max_spread = current_spread;}

   if (current_spread < min_spread) {min_spread = current_spread;}

   

   avg_cnt++;

   avg_add     = avg_add + current_spread;

   avg_spread  = avg_add / avg_cnt;



   int x=0; int y=0;

   string name;



   // create objects

   if (passed == false)

   {

      passed=true;

      

      name="fxd_spread_current_label";

      if (ObjectFind(0, name)==-1) {

         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);

         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+1);

         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);

         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 18);

         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);

         ObjectSetString(0, name, OBJPROP_FONT, "Arial");

         ObjectSetString(0, name, OBJPROP_TEXT, "Spread:");

      }

      name="fxd_spread_max_label";

      if (ObjectFind(0, name)==-1) {

         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);

         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+148);

         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+17);

         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);

         ObjectSetInteger(0, name, OBJPROP_COLOR, clrOrangeRed);

         ObjectSetString(0, name, OBJPROP_FONT, "Arial");

         ObjectSetString(0, name, OBJPROP_TEXT, "max:");

      }

      name="fxd_spread_avg_label";

      if (ObjectFind(0, name)==-1) {

         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);

         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+148);

         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+9);

         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);

         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);

         ObjectSetString(0, name, OBJPROP_FONT, "Arial");

         ObjectSetString(0, name, OBJPROP_TEXT, "avg:");

      }

      name="fxd_spread_min_label";

      if (ObjectFind(0, name)==-1) {

         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);

         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+148);

         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);

         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);

         ObjectSetInteger(0, name, OBJPROP_COLOR, clrGold);

         ObjectSetString(0, name, OBJPROP_FONT, "Arial");

         ObjectSetString(0, name, OBJPROP_TEXT, "min:");

      }

      name="fxd_spread_current";

      if (ObjectFind(0, name)==-1) {

         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);

         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+93);

         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);

         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 18);

         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);

         ObjectSetString(0, name, OBJPROP_FONT, "Arial");

         ObjectSetString(0, name, OBJPROP_TEXT, "0");

      }

      name="fxd_spread_max";

      if (ObjectFind(0, name)==-1) {

         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);

         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+173);

         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+17);

         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);

         ObjectSetInteger(0, name, OBJPROP_COLOR, clrOrangeRed);

         ObjectSetString(0, name, OBJPROP_FONT, "Arial");

         ObjectSetString(0, name, OBJPROP_TEXT, "0");

      }

      name="fxd_spread_avg";

      if (ObjectFind(0, name)==-1) {

         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);

         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+173);

         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+9);

         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);

         ObjectSetInteger(0, name, OBJPROP_COLOR, clrDarkOrange);

         ObjectSetString(0, name, OBJPROP_FONT, "Arial");

         ObjectSetString(0, name, OBJPROP_TEXT, "0");

      }

      name="fxd_spread_min";

      if (ObjectFind(0, name)==-1) {

         ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);

         ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x+173);

         ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y+1);

         ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

         ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

         ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 7);

         ObjectSetInteger(0, name, OBJPROP_COLOR, clrGold);

         ObjectSetString(0, name, OBJPROP_FONT, "Arial");

         ObjectSetString(0, name, OBJPROP_TEXT, "0");

      }

   }

   

   ObjectSetString(0, "fxd_spread_current", OBJPROP_TEXT, DoubleToStr(current_spread,2));

   ObjectSetString(0, "fxd_spread_max", OBJPROP_TEXT, DoubleToStr(max_spread,2));

   ObjectSetString(0, "fxd_spread_avg", OBJPROP_TEXT, DoubleToStr(avg_spread,2));

   ObjectSetString(0, "fxd_spread_min", OBJPROP_TEXT, DoubleToStr(min_spread,2));

}



string DrawStatus(string text="")

{

   static string memory;

   if (text=="") {

      return(memory);

   }

   

   static bool passed = false;

   int x=210; int y=0;

   string name;



   //-- draw the objects once

   if (passed == false)

   {

      passed = true;

      name="fxd_status_title";

      ObjectCreate(0,name, OBJ_LABEL, 0, 0, 0);

      ObjectSetInteger(0,name, OBJPROP_BACK, false);

      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

      ObjectSetInteger(0,name, OBJPROP_XDISTANCE, x);

      ObjectSetInteger(0,name, OBJPROP_YDISTANCE, y+17);

      ObjectSetString(0,name, OBJPROP_TEXT, "Status");

      ObjectSetString(0,name, OBJPROP_FONT, "Arial");

      ObjectSetInteger(0,name, OBJPROP_FONTSIZE, 7);

      ObjectSetInteger(0,name, OBJPROP_COLOR, clrGray);

      

      name="fxd_status_text";

      ObjectCreate(0,name, OBJ_LABEL, 0, 0, 0);

      ObjectSetInteger(0,name, OBJPROP_BACK, false);

      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_LOWER);

      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);

      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);

      ObjectSetInteger(0,name, OBJPROP_XDISTANCE, x+2);

      ObjectSetInteger(0,name, OBJPROP_YDISTANCE, y+1);

      ObjectSetString(0,name, OBJPROP_FONT, "Arial");

      ObjectSetInteger(0,name, OBJPROP_FONTSIZE, 12);

      ObjectSetInteger(0,name, OBJPROP_COLOR, clrAqua);

   }



   //-- update the text when needed

   if (text != memory) {

      memory=text;

      ObjectSetString(0,"fxd_status_text", OBJPROP_TEXT, text);

   }

   

   return(text);

}



double DynamicLots(string symbol, string mode="balance", double value=0, double sl=0, string align="align")

{

   double size=0;

   double LotStep=SymbolLotStep(symbol);

   double LotSize=SymbolLotSize(symbol);

   double MinLots=SymbolMinLot(symbol);

   double MaxLots=SymbolMaxLot(symbol);

   double TickValue=SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE);

   double margin_required=0;

   bool ocm = OrderCalcMargin(ORDER_TYPE_BUY,symbol,1,ask(symbol),margin_required); // This is the MODE_MARGINREQUIRED analog in MQL5

   //if (value>MaxLots) {value=value/LotSize;} // Money-to-Lot conversion

   

        if (mode=="fixed" || mode=="lots") {size=value;}

   else if (mode=="block-equity")     {size=(value/100)*AccountEquity()/margin_required;}

   else if (mode=="block-balance")    {size=(value/100)*AccountBalance()/margin_required;}

   else if (mode=="block-freemargin") {size=(value/100)*AccountFreeMargin()/margin_required;}

   else if (mode=="equity")     {size=(value/100)*AccountEquity()/(LotSize*TickValue);}

   else if (mode=="balance")    {size=(value/100)*AccountBalance()/(LotSize*TickValue);}

   else if (mode=="freemargin") {size=(value/100)*AccountFreeMargin()/(LotSize*TickValue);}

   else if (mode=="equityRisk") {size=((value/100)*AccountEquity())/(sl*TickValue*PipValue(symbol));}

   else if (mode=="balanceRisk"){size=((value/100)*AccountBalance())/(sl*TickValue*PipValue(symbol));}

   else if (mode=="freemarginRisk") {size=((value/100)*AccountFreeMargin())/(sl*TickValue*PipValue(symbol));}

   else if (mode=="fixedRisk")   {size=(value)/(sl*TickValue*PipValue(symbol));}

   else if (mode=="fixedRatio" || mode=="RJFR") { 

      /////

      // Ryan Jones Fixed Ratio MM static data

      static double RJFR_start_lots=0;

      static double RJFR_delta=0;

      static double RJFR_units=1;

      static double RJFR_target_lower=0;

      static double RJFR_target_upper=0;

      /////

      

      if (RJFR_start_lots<=0) {RJFR_start_lots=value;}

      if (RJFR_start_lots<MinLots) {RJFR_start_lots=MinLots;}

      if (RJFR_delta<=0) {RJFR_delta=sl;}

      if (RJFR_target_upper<=0) {

         RJFR_target_upper=AccountEquity()+(RJFR_units*RJFR_delta);

         Print("Fixed Ratio MM: Units=>",RJFR_units,"; Delta=",RJFR_delta,"; Upper Target Equity=>",RJFR_target_upper);

      }

      if (AccountEquity()>=RJFR_target_upper)

      {

         while(true) {

            Print("Fixed Ratio MM going up to ",(RJFR_start_lots*(RJFR_units+1))," lots: Equity is above Upper Target Equity (",AccountEquity(),">=",RJFR_target_upper,")");

            RJFR_units++;

            RJFR_target_lower=RJFR_target_upper;

            RJFR_target_upper=RJFR_target_upper+(RJFR_units*RJFR_delta);

            Print("Fixed Ratio MM: Units=>",RJFR_units,"; Delta=",RJFR_delta,"; Lower Target Equity=>",RJFR_target_lower,"; Upper Target Equity=>",RJFR_target_upper);

            if (AccountEquity()<RJFR_target_upper) {break;}

         }

      }

      else if (AccountEquity()<=RJFR_target_lower)

      {

         while(true) {

         if (AccountEquity()>RJFR_target_lower) {break;}

            if (RJFR_units>1) {         

               Print("Fixed Ratio MM going down to ",(RJFR_start_lots*(RJFR_units-1))," lots: Equity is below Lower Target Equity | ", AccountEquity()," <= ",RJFR_target_lower,")");

               RJFR_target_upper=RJFR_target_lower;

               RJFR_target_lower=RJFR_target_lower-((RJFR_units-1)*RJFR_delta);

               RJFR_units--;

               Print("Fixed Ratio MM: Units=>",RJFR_units,"; Delta=",RJFR_delta,"; Lower Target Equity=>",RJFR_target_lower,"; Upper Target Equity=>",RJFR_target_upper);

            } else {break;}

         }

      }

      size=RJFR_start_lots*RJFR_units;

   }

		

	if (size==EMPTY_VALUE) {size=0;}

   

   static bool alert_min_lots=false;

   if (size<MinLots && alert_min_lots==false) {alert_min_lots=true;

      Alert("You want to trade ",size," lot, but your broker's minimum is ",MinLots," lot. The trade/order will continue with ",MinLots," lot instead of ",size," lot. The same rule will be applied for next trades/orders with desired lot size lower than the minimum. You will not see this message again until you restart the program.");

   }



   size=MathRound(size/LotStep)*LotStep;

   

   if (align=="align") {

      if (size<MinLots) {size=MinLots;}

      if (size>MaxLots) {size=MaxLots;}

   }

   

   return (size);

}



string ErrorMessage(int error_code=-1)

{

	string e = "";

	if (error_code<0) {error_code=GetLastError();}

	



	switch(error_code)

	{

		//--- success

		case 0: return("The operation completed successfully");

		

		//--- Runtime

		case 4001: e = "Unexpected internal error"; break;

		case 4002: e = "Wrong parameter in the inner call of the client terminal function"; break;

		case 4003: e = "Wrong parameter when calling the system function"; break;

		case 4004: e = "Not enough memory to perform the system function"; break;

		case 4005: e = "The structure contains objects of strings and/or dynamic arrays and/or structure of such objects and/or classes"; break;

		case 4006: e = "Array of a wrong type, wrong size, or a damaged object of a dynamic array"; break;

		case 4007: e = "Not enough memory for the relocation of an array, or an attempt to change the size of a static array"; break;

		case 4008: e = "Not enough memory for the relocation of string"; break;

		case 4009: e = "Not initialized string"; break;

		case 4010: e = "Invalid date and/or time"; break;

		case 4011: e = "Requested array size exceeds 2 GB"; break;

		case 4012: e = "Wrong pointer"; break;

		case 4013: e = "Wrong type of pointer"; break;

		case 4014: e = "System function is not allowed to call"; break;

		case 4015: e = "The names of the dynamic and the static resource match"; break;

		case 4016: e = "Resource with this name has not been found in EX5"; break;

		case 4017: e = "Unsupported resource type or its size exceeds 16 Mb"; break;

		case 4018: e = "The resource name exceeds 63 characters"; break;

		

		//-- Charts

		case 4101: e = "Wrong chart ID"; break;

		case 4102: e = "Chart does not respond"; break;

		case 4103: e = "Chart not found"; break;

		case 4104: e = "No Expert Advisor in the chart that could handle the event"; break;

		case 4105: e = "Chart opening error"; break;

		case 4106: e = "Failed to change chart symbol and period"; break;

		case 4107: e = "Wrong parameter for timer"; break;

		case 4108: e = "Failed to create timer"; break;

		case 4109: e = "Wrong chart property ID"; break;

		case 4110: e = "Error creating screenshots"; break;

		case 4111: e = "Error navigating through chart"; break;

		case 4112: e = "Error applying template"; break;

		case 4113: e = "Subwindow containing the indicator was not found"; break;

		case 4114: e = "Error adding an indicator to chart"; break;

		case 4115: e = "Error deleting an indicator from the chart"; break;

		case 4116: e = "Indicator not found on the specified chart"; break;



		//-- Graphical Objects

		case 4201: e = "Error working with a graphical object"; break;

		case 4202: e = "Graphical object was not found"; break;

		case 4203: e = "Wrong ID of a graphical object property"; break;

		case 4204: e = "Unable to get date corresponding to the value"; break;

		case 4205: e = "Unable to get value corresponding to the date"; break;



		//-- Market Info

		case 4301: e = "Unknown symbol"; break;

		case 4302: e = "Symbol is not selected in MarketWatch"; break;

		case 4303: e = "Wrong identifier of a symbol property"; break;

		case 4304: e = "Time of the last tick is not known (no ticks)"; break;

		case 4305: e = "Error adding or deleting a symbol in MarketWatch"; break;



		//-- History Access

		case 4401: e = "Requested history not found"; break;

		case 4402: e = "Wrong ID of the history property"; break;



		//-- Global Variables

		case 4501: e = "Global variable of the client terminal is not found"; break;

		case 4502: e = "Global variable of the client terminal with the same name already exists"; break;

		case 4510: e = "Email sending failed"; break;

		case 4511: e = "Sound playing failed"; break;

		case 4512: e = "Wrong identifier of the program property"; break;

		case 4513: e = "Wrong identifier of the terminal property"; break;

		case 4514: e = "File sending via ftp failed"; break;

		case 4515: e = "Failed to send a notification"; break;

		case 4516: e = "Invalid parameter for sending a notification - an empty string or NULL has been passed to the SendNotification() function"; break;

		case 4517: e = "Wrong settings of notifications in the terminal (ID is not specified or permission is not set)"; break;

		case 4518: e = "Too frequent sending of notifications"; break;



		//-- Custom Indicator Buffers

		case 4601: e = "Not enough memory for the distribution of indicator buffers"; break;

		case 4602: e = "Wrong indicator buffer index"; break;



		//-- Custom Indicator Properties

		case 4603: e = "Wrong ID of the custom indicator property"; break;



		//-- Account

		case 4701: e = "Wrong account property ID"; break;

		case 4751: e = "Wrong trade property ID"; break;

		case 4752: e = "Trading by Expert Advisors prohibited"; break;

		case 4753: e = "Position not found"; break;

		case 4754: e = "Order not found"; break;

		case 4755: e = "Deal not found"; break;

		case 4756: e = "Trade request sending failed"; break;



		//-- Indicators

		case 4801: e = "Unknown symbol"; break;

		case 4802: e = "Indicator cannot be created"; break;

		case 4803: e = "Not enough memory to add the indicator"; break;

		case 4804: e = "The indicator cannot be applied to another indicator"; break;

		case 4805: e = "Error applying an indicator to chart"; break;

		case 4806: e = "Requested data not found"; break;

		case 4807: e = "Wrong indicator handle"; break;

		case 4808: e = "Wrong number of parameters when creating an indicator"; break;

		case 4809: e = "No parameters when creating an indicator"; break;

		case 4810: e = "The first parameter in the array must be the name of the custom indicator"; break;

		case 4811: e = "Invalid parameter type in the array when creating an indicator"; break;

		case 4812: e = "Wrong index of the requested indicator buffer"; break;



		//-- Depth of Market

		case 4901: e = "Depth Of Market can not be added"; break;

		case 4902: e = "Depth Of Market can not be removed"; break;

		case 4903: e = "The data from Depth Of Market can not be obtained"; break;

		case 4904: e = "Error in subscribing to receive new data from Depth Of Market"; break;



		//-- File Operations

		case 5001: e = "More than 64 files cannot be opened at the same time"; break;

		case 5002: e = "Invalid file name"; break;

		case 5003: e = "Too long file name"; break;

		case 5004: e = "File opening error"; break;

		case 5005: e = "Not enough memory for cache to read"; break;

		case 5006: e = "File deleting error"; break;

		case 5007: e = "A file with this handle was closed, or was not opening at all"; break;

		case 5008: e = "Wrong file handle"; break;

		case 5009: e = "The file must be opened for writing"; break;

		case 5010: e = "The file must be opened for reading"; break;

		case 5011: e = "The file must be opened as a binary one"; break;

		case 5012: e = "The file must be opened as a text"; break;

		case 5013: e = "The file must be opened as a text or CSV"; break;

		case 5014: e = "The file must be opened as CSV"; break;

		case 5015: e = "File reading error"; break;

		case 5016: e = "String size must be specified, because the file is opened as binary"; break;

		case 5017: e = "A text file must be for string arrays, for other arrays - binary"; break;

		case 5018: e = "This is not a file, this is a directory"; break;

		case 5019: e = "File does not exist"; break;

		case 5020: e = "File can not be rewritten"; break;

		case 5021: e = "Wrong directory name"; break;

		case 5022: e = "Directory does not exist"; break;

		case 5023: e = "This is a file, not a directory"; break;

		case 5024: e = "The directory cannot be removed"; break;

		case 5025: e = "Failed to clear the directory (probably one or more files are blocked and removal operation failed)"; break;

		case 5026: e = "Failed to write a resource to a file"; break;



		//-- String Casting

		case 5030: e = "No date in the string"; break;

		case 5031: e = "Wrong date in the string"; break;

		case 5032: e = "Wrong time in the string"; break;

		case 5033: e = "Error converting string to date"; break;

		case 5034: e = "Not enough memory for the string"; break;

		case 5035: e = "The string length is less than expected"; break;

		case 5036: e = "Too large number, more than ULONG_MAX"; break;

		case 5037: e = "Invalid format string"; break;

		case 5038: e = "Amount of format specifiers more than the parameters"; break;

		case 5039: e = "Amount of parameters more than the format specifiers"; break;

		case 5040: e = "Damaged parameter of string type"; break;

		case 5041: e = "Position outside the string"; break;

		case 5042: e = "0 added to the string end, a useless operation"; break;

		case 5043: e = "Unknown data type when converting to a string"; break;

		case 5044: e = "Damaged string object"; break;



		//-- Operations with Arrays

		case 5050: e = "Copying incompatible arrays. String array can be copied only to a string array, and a numeric array - in numeric array only"; break;

		case 5051: e = "The receiving array is declared as AS_SERIES, and it is of insufficient size"; break;

		case 5052: e = "Too small array, the starting position is outside the array"; break;

		case 5053: e = "An array of zero length"; break;

		case 5054: e = "Must be a numeric array"; break;

		case 5055: e = "Must be a one-dimensional array"; break;

		case 5056: e = "Timeseries cannot be used"; break;

		case 5057: e = "Must be an array of type double"; break;

		case 5058: e = "Must be an array of type float"; break;

		case 5059: e = "Must be an array of type long"; break;

		case 5060: e = "Must be an array of type int"; break;

		case 5061: e = "Must be an array of type short"; break;

		case 5062: e = "Must be an array of type char"; break;

		

		//-- Operations with OpenCL

		case 5100: e = "OpenCL functions are not supported on this computer"; break;

		case 5101: e = "Internal error occurred when running OpenCL"; break;

		case 5102: e = "Invalid OpenCL handle"; break;

		case 5103: e = "Error creating the OpenCL context"; break;

		case 5104: e = "Failed to create a run queue in OpenCL"; break;

		case 5105: e = "Error occurred when compiling an OpenCL program"; break;

		case 5106: e = "Too long kernel name (OpenCL kernel)"; break;

		case 5107: e = "Error creating an OpenCL kernel"; break;

		case 5108: e = "Error occurred when setting parameters for the OpenCL kernel"; break;

		case 5109: e = "OpenCL program runtime error"; break;

		case 5110: e = "Invalid size of the OpenCL buffer"; break;

		case 5111: e = "Invalid offset in the OpenCL buffer"; break;

		case 5112: e = "Failed to create an OpenCL buffer"; break;

		

		//-- Operations with WebRequest

		case 5200: e = "Invalid URL"; break;

		case 5201: e = "Failed to connect to specified URL"; break;

		case 5202: e = "Timeout exceeded"; break;

		case 5203: e = "HTTP request failed"; break;



		//-- trading errors

		case 10004: e = "Requote occured"; break;

		case 10006: e = "Order is not accepted by the server"; break;

		case 10007: e = "Request canceled by trader"; break;

		case 10010: e = "Only part of the request was completed"; break;

		case 10011: e = "Request processing error"; break;

		case 10012: e = "Request canceled by timeout"; break;

		case 10013: e = "Invalid request"; break;

		case 10014: e = "Invalid volume"; break;

		case 10015: e = "Invalid price"; break;

		case 10016: e = "Invalid SL or TP"; break;

		case 10017: e = "Trading is disabled"; break;

		case 10018: e = "Market is closed"; break;

		case 10019: e = "Not enough money to trade"; break;

		case 10020: e = "Prices changed"; break;

		case 10021: e = "There are no quotes to process the request"; break;

		case 10022: e = "Invalid expiration date in the order request"; break;

		case 10023: e = "Order state changed"; break;

		case 10024: e = "Too frequent requests"; break;

		case 10025: e = "No changes in request"; break;

		case 10026: e = "Autotrading is disabled by the server"; break;

		case 10027: e = "Autotrading is disabled by the client terminal"; break;

		case 10028: e = "Request locked for processing"; break;

		case 10029: e = "Order or trade frozen"; break;

		case 10030: e = "Invalid order filling type"; break;

		case 10031: e = "No connection with the trade server"; break;

		case 10032: e = "Operation is allowed only for live accounts"; break;

		case 10033: e = "The number of pending orders has reached the limit"; break;

		case 10034: e = "The volume of orders and trades for the symbol has reached the limit"; break;

		case 10035: e = "Incorrect or prohibited order type"; break;

		case 10036: e = "Position with the specified POSITION_IDENTIFIER has already been closed"; break;

		case 10038: e = "A close volume exceeds the current position volume"; break;

		case 10039: e = "A close order already exists for a specified position"; break;

		//-- User-Defined Errors

		case 65536: e = "User defined errors"; break;

		default:	e = "Unknown error";

	}



	StringConcatenate(e, e," (",error_code,")");

	

	return e;

}



datetime ExpirationTime(string mode="GTC",int days=0, int hours=0, int minutes=0, datetime custom=0)

{

	datetime now        = TimeCurrent();

   datetime expiration = now;



	     if (mode == "GTC" || mode == "") {expiration = 0;}

	else if (mode == "today")             {expiration = (datetime)(MathFloor((now + 86400.0) / 86400.0) * 86400.0);}

	else if (mode == "specified")

	{

		expiration = 0;



		if ((days + hours + minutes) > 0)

		{

			expiration = now + (86400 * days) + (3600 * hours) + (60 * minutes);

		}

	}

	else

	{

		if (custom <= now)

		{

			if (custom < 31557600)

			{

				custom = now + custom;

			}

			else

			{

				custom = 0;

			}

		}



		expiration = custom;

	}



	return expiration;

}



ENUM_ORDER_TYPE_TIME ExpirationTypeByTime(string symbol, datetime expiration)

{

	datetime now                   = TimeCurrent();

	ENUM_ORDER_TYPE_TIME type_time = ORDER_TIME_GTC;



	// Detect Type Time

	if (expiration == 0 || expiration <= now)

	{

		type_time = ORDER_TIME_GTC;

	}

	else if (expiration == (datetime)(MathFloor((now + 86400.0) / 86400.0) * 86400.0))

	{

		type_time = ORDER_TIME_DAY;

	}

	else

	{

		type_time = ORDER_TIME_SPECIFIED;

	}



	// What if certain Type Time is not allowed?

	if (type_time == ORDER_TIME_GTC && !IsExpirationTypeAllowed(symbol, SYMBOL_EXPIRATION_GTC))

	{

		type_time = ORDER_TIME_DAY;

	}

	

	if (type_time == ORDER_TIME_DAY && !IsExpirationTypeAllowed(symbol, SYMBOL_EXPIRATION_DAY))

	{

		type_time = ORDER_TIME_SPECIFIED;

	}



	// Return Type Time

	return type_time;

}



class ExpirationWorker

{

private:

	struct CachedItems

	{

		long ticket;

		datetime expiration;

	};



	CachedItems cachedItems[];

	long chartID;

	string chartObjectPrefix;

	string chartObjectSuffix;



	template<typename T>

	void ArrayClone(T &dest[], T &src[])

	{

		int size = ArraySize(src);

		ArrayResize(dest, size);



		for (int i = 0; i < size; i++)

		{

			dest[i] = src[i];

		}

	}



	void InitialDiscovery()

	{

		ArrayResize(cachedItems, 0);



		int total = PositionsTotal();



		for (int index = 0; index <= total; index++)

		{

			long ticket = GetTicketByIndex(index);



			if (ticket == 0) continue;



			datetime expiration = GetExpirationFromObject(ticket);



			if (expiration > 0)

			{

				SetExpirationInCache(ticket, expiration);

			}

		}

	}



	long GetTicketByIndex(int index)

	{

		return (long)PositionGetTicket(index);

	}



	datetime GetExpirationFromObject(long ticket)

	{

		datetime expiration = (datetime)0;

		

		string objectName = chartObjectPrefix + IntegerToString(ticket) + chartObjectSuffix;



		if (ObjectFind(chartID, objectName) == chartID)

		{

			expiration = (datetime)ObjectGetInteger(chartID, objectName, OBJPROP_TIME);

		}



		return expiration;

	}



	bool RemoveExpirationObject(long ticket)

	{

		bool success      = false;

		string objectName = "";



		objectName = chartObjectPrefix + IntegerToString(ticket) + chartObjectSuffix;

		success    = ObjectDelete(chartID, objectName);



		return success;

	}



	void RemoveExpirationFromCache(long ticket)

	{

		int size = ArraySize(cachedItems);

		CachedItems newItems[];

		int newSize = 0;

		bool itemRemoved = false;



		for (int i = 0; i < size; i++)

		{

			if (cachedItems[i].ticket == ticket)

			{

				itemRemoved = true;

			}

			else

			{

				newSize++;

				ArrayResize(newItems, newSize);

				newItems[newSize - 1].ticket     = cachedItems[i].ticket;

				newItems[newSize - 1].expiration = cachedItems[i].expiration;

			}

		}



		if (itemRemoved) ArrayClone(cachedItems, newItems);

	}



	void SetExpirationInCache(long ticket, datetime expiration)

	{

		bool alreadyExists = false;

		int size           = ArraySize(cachedItems);



		for (int i = 0; i < size; i++)

		{

			if (cachedItems[i].ticket == ticket)

			{

				cachedItems[i].expiration = expiration;

				alreadyExists = true;

				break;

			}

		}



		if (alreadyExists == false)

		{

			ArrayResize(cachedItems, size + 1);

			cachedItems[size].ticket     = ticket;

			cachedItems[size].expiration = expiration;

		}

	}



	bool SetExpirationInObject(long ticket, datetime expiration)

	{

		if (!PositionSelectByTicket(ticket)) return false;



		string objectName = chartObjectPrefix + IntegerToString(ticket) + chartObjectSuffix;

		double price      = OrderOpenPrice();



		if (ObjectFind(chartID, objectName) == chartID)

		{

			ObjectSetInteger(chartID, objectName, OBJPROP_TIME, expiration);

			ObjectSetDouble(chartID, objectName, OBJPROP_PRICE, price);

		}

		else

		{

			ObjectCreate(chartID, objectName, OBJ_ARROW, 0, expiration, price);

		}



		ObjectSetInteger(chartID, objectName, OBJPROP_ARROWCODE, 77);

		ObjectSetInteger(chartID, objectName, OBJPROP_HIDDEN, true);

		ObjectSetInteger(chartID, objectName, OBJPROP_ANCHOR, ANCHOR_TOP);

		ObjectSetInteger(chartID, objectName, OBJPROP_COLOR, clrRed);

		ObjectSetInteger(chartID, objectName, OBJPROP_SELECTABLE, false);

		ObjectSetInteger(chartID, objectName, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);

		ObjectSetString(chartID, objectName, OBJPROP_TEXT, TimeToString(expiration));



		return true;

	}

	

	bool TradeExists(long ticket)

	{

		bool exists  = false;



		for (int i = 0; i < PositionsTotal(); i++)

		{

			long positionTicket = (long)PositionGetTicket(i);



			if (!positionTicket) continue;



			if (positionTicket == ticket)

			{

				exists = true;

				break;

			}

		}



		return exists;

	}



public:

	// Default constructor

	ExpirationWorker()

	{

		chartID           = 0;

		chartObjectPrefix = "#";

		chartObjectSuffix = " Expiration Marker";



		InitialDiscovery();

	}



	void SetExpiration(long ticket, datetime expiration)

	{

		if (expiration <= 0)

		{

			RemoveExpiration(ticket);

		}

		else

		{

			SetExpirationInObject(ticket, expiration);

			SetExpirationInCache(ticket, expiration);

		}

	}



	datetime GetExpiration(long ticket)

	{

		datetime expiration = (datetime)0;

		int size            = ArraySize(cachedItems);



		for (int i = 0; i < size; i++)

		{

			if (cachedItems[i].ticket == ticket)

			{

				expiration = cachedItems[i].expiration;

				break;

			}

		}



		return expiration;

	}



	void RemoveExpiration(long ticket)

	{

		RemoveExpirationObject(ticket);

		RemoveExpirationFromCache(ticket);

	}



	void Run()

	{

		int count = ArraySize(cachedItems);



		if (count > 0)

		{

			datetime timeNow = TimeCurrent();



			for (int i = 0; i < count; i++)

			{

				if (timeNow >= cachedItems[i].expiration)

				{

					long ticket           = cachedItems[i].ticket;

					bool removeExpiration = false;



					if (TradeExists(ticket))

					{

						if (CloseTrade(ticket))

						{

							Print("close #", ticket, " by expiration");

							removeExpiration = true;

						}

					}

					else

					{

						removeExpiration = true;

					}



					if (removeExpiration)

					{

						RemoveExpiration(ticket);



						// Removing expiration causes change in the size of the cache,

						// so reset of the size and one step back of the index is needed

						count = ArraySize(cachedItems);

						i--;

					}

				}

			}

		}

	}

};



ExpirationWorker expirationWorker;



bool FilterOrderBy(

	string group_mode    = "all",

	string group         = "0",

	string market_mode   = "all",

	string market        = "",

	string BuysOrSells   = "both",

	string LimitsOrStops = "",

	int unused           = 0, // for MQL4 compatibility

	bool onTrade         = false

) {

	//-- db

	static string markets[];

	static string market0	= "-";

	static int markets_size = 0;

	

	static string groups[];

	static string group0	  = "-";

	static int groups_size = 0;

	

	//-- local variables

	bool type_pass	  = false;

	bool market_pass = false;

	bool group_pass  = false;



	int i;

	long type;

	ulong magic_number;

	string symbol;

	

	// Trades

	if (onTrade == false)

	{

		type         = OrderType();

		magic_number = OrderMagicNumber();

		symbol       = OrderSymbol();

	}

	else

	{

		type         = e_attrType();

		magic_number = e_attrMagicNumber();

		symbol       = e_attrSymbol();

	}

	

	// Trades && History trades

	if (LimitsOrStops == "")

	{

		if (

				(BuysOrSells == "both"  && (type == ORDER_TYPE_BUY || type == ORDER_TYPE_SELL))

			|| (BuysOrSells == "buys"  && type == ORDER_TYPE_BUY)

			|| (BuysOrSells == "sells" && type == ORDER_TYPE_SELL)

			)

		{

			type_pass = true;

		}

	}

	// Pending orders

	else

	{

		if (

				(BuysOrSells == "both" && (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP))

			||	(BuysOrSells == "buys" && (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_BUY_STOP))

			|| (BuysOrSells == "sells" && (type == ORDER_TYPE_SELL_LIMIT || type == ORDER_TYPE_SELL_STOP))

			)

		{

			if (

					(LimitsOrStops == "both" && (type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_STOP || type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_SELL_LIMIT))

				||	(LimitsOrStops == "stops" && (type == ORDER_TYPE_BUY_STOP || type == ORDER_TYPE_SELL_STOP))

				|| (LimitsOrStops == "limits" && (type == ORDER_TYPE_BUY_LIMIT || type == ORDER_TYPE_SELL_LIMIT))	

				)

			{

				type_pass = true;

			}

		}

	}

	if (type_pass == false) {return false;}

	

	//-- check group

	if (group_mode == "group")

	{

		if (group == "")

		{

			if (magic_number == MagicStart)

			{

				group_pass = true;

			}

		}

		else

		{

			if (group0 != group)

			{

				group0 = group;

				StringExplode(",", group, groups);

				groups_size = ArraySize(groups);



				for(i = 0; i < groups_size; i++)

				{

					groups[i] = StringTrim(groups[i]);



					if (groups[i] == "")

					{

						groups[i] = "0";

					}

				}

			}



			for(i = 0; i < groups_size; i++)

			{

				if (magic_number == (MagicStart + (int)groups[i]))

				{

					group_pass = true;



					break;

				}

			}

		}

	}

	else if (group_mode == "all" || (group_mode == "manual" && magic_number == 0))

	{

		group_pass = true;  

	}



	if (group_pass == false) {return false;}

	

	// check market

	if (market_mode == "all")

	{

		market_pass = true;

	}

	else

	{

		if (symbol == market)

		{

			market_pass = true;

		}

		else

		{

			if (market0 != market)

			{

				market0 = market;



				if (market == "")

				{

					markets_size = 1;

					ArrayResize(markets,1);

					markets[0] = Symbol();

				}

				else

				{

					StringExplode(",", market, markets);

					markets_size = ArraySize(markets);



					for(i = 0; i < markets_size; i++)

					{

						markets[i] = StringTrim(markets[i]);



						if (markets[i] == "")

						{

							markets[i] = Symbol();

						}

					}

				}

			}



			for(i = 0; i < markets_size; i++)

			{

				if (symbol == markets[i])

				{

					market_pass = true;



					break;

				}

			}

		}

	}



	if (market_pass == false) {return false;}

 

	return(true);

}



/**

* This overload works for numeric values and for boolean values

*/

template<typename T>

string FormatValueForPrinting(

	T value,

	int digits,

	int timeFormat

) {

	string outputValue = "";

	string typeName    = typename(value);



	if (typeName == "double" || typeName == "float")

	{

		if (digits >= -16 && digits <= 8)

		{

			if (value > -1.0 && value < 1.0)

			{

				/**

				* Find how many zeroes are after the point, but before the first non-zero digit.

				* For example 0.000195 has 3 zeroes

				* The function would return negative value for values bigger than 0

				*

				* @see https://stackoverflow.com/questions/31001901/how-can-i-count-the-number-of-zero-decimals-in-javascript/31002148#31002148

				*/

				int zeroesAfterPoint = (int)-MathFloor(MathLog10(MathAbs(value)) + 1);



				digits = zeroesAfterPoint + digits;

			}

			

			T normalizedValue  = NormalizeDouble(value, digits);

			outputValue = DoubleToString(normalizedValue, digits);

		}

		else

		{

			outputValue = (string)NormalizeDouble(value, 8);

		}

	}

	else {

		outputValue = IntegerToString((long)value);

	}



	return outputValue;

}



/**

* Bool overload

*/

string FormatValueForPrinting(

	bool value,

	int digits,

	int timeFormat

) {

	return (value) ? "true" : "false";

}



/**

* Datetime overload

*/

string FormatValueForPrinting(

	datetime value,

	int digits,

	int timeFormat

) {

	if (

		timeFormat == (int)EMPTY_VALUE

		|| timeFormat == EMPTY_VALUE

	) timeFormat = TIME_DATE|TIME_MINUTES;

	return TimeToString(value, timeFormat);

}



/**

* String overload

*/

string FormatValueForPrinting(

	string value,

	int digits,

	int timeFormat

) {

	return value;

}



void GetBetTradesInfo(

	double &output[],

	string group,

	string symbol,

	int pool, // 0: try running trades first and then history trades, 1: try running only, 2: try history only

	bool findConsecutive = false

) {

	if (ArraySize(output) < 4)

	{

		ArrayResize(output, 4);

		ArrayInitialize(output, 0.0);

	}



	double lots         = output[0]; // will be the lot size of the first loaded trade

	double profitOrLoss = output[1]; // 0 is initial value, 1 is profit, -1 is loss

	double consecutive  = output[2]; // the number of consecutive profitable or losable trades

	double profit       = output[3]; // will be the profit of the first loaded trade

	bool historyTrades  = (pool == 2) ? true : false;

	

	int total = (historyTrades) ? HistoryTradesTotal() : TradesTotal();



	for (int pos = total - 1; pos >= 0; pos--)

	{

		if (

			   (!historyTrades && TradeSelectByIndex(pos, "group", group, "symbol", symbol))

			|| (historyTrades && HistoryTradeSelectByIndex(pos, "group", group, "symbol", symbol))

		) {

			if (

				((pool == 0 || pool == 1) && TimeCurrent() - OrderOpenTime() < 3) // skip for brand new trades

				||

				(

					// exclude expired pending orders

					!historyTrades

					&& OrderExpiration() > 0

					&& OrderExpiration() <= OrderCloseTime()

				)

			) {

				continue;

			}



			if (lots == 0.0)

			{

				lots = OrderLots();

			}



			profit = OrderClosePrice() - OrderOpenPrice();

			profit = NormalizeDouble(profit, SymbolDigits(OrderSymbol()));

			

			if (profit == 0.0)

			{

				// Consider a trade with zero profit as non existent

				continue;

			}



			if (IsOrderTypeSell())

			{

				profit = -1 * profit;

			}



			if (profitOrLoss == 0)

			{

				// We enter here only for the first trade

				profitOrLoss = (profit < 0.0) ? -1 : 1;



				consecutive++;



				if (findConsecutive == false) break;

			}

			else

			{

				// For the trades after the first one, if its profit is the opposite of profitOrLoss, we need to break

				if (

					   (profitOrLoss > 0.0 && profit < 0.0)

					|| (profitOrLoss < 0.0 && profit > 0.0)

				) {

					break;

				}



				consecutive++;

			}

		}

	}



	output[0] = lots;

	output[1] = profitOrLoss;

	output[2] = consecutive;

	output[3] = profit;

	

	if (pool == 0 && (findConsecutive || profitOrLoss == 0))

	{

		// running trades tried, continue with the history trades

		pool = 2;

		GetBetTradesInfo(output, group, symbol, pool, findConsecutive);

	}

}



bool HistoryTradeSelectByIndex(

	int index,

	string group_mode    = "all",

	string group         = "0",

	string market_mode   = "all",

	string market        = "",

	string BuysOrSells   = "both"

) {

	if (LoadHistoryTrade(index, "select_by_pos") && LoadedType() == 3)

	{

		if (FilterOrderBy(

			group_mode,

			group,

			market_mode,

			market,

			BuysOrSells)

		) {

			return true;

		}

	}



	return false;

}



int HistoryTradesTotal(datetime from_date=0, datetime to_date=0)

{

	if (to_date == 0) {to_date = TimeCurrent() + 1;}

	

	HistorySelect(from_date, to_date);

	

	SelectedHistoryFromTime(from_date);

	SelectedHistoryToTime(to_date);

	

	return HistoryDealsTotal();

}



void HistoryTradesTotalReset()

{

	if (SelectedHistoryToTime() > 0 || SelectedHistoryFromTime() > 0) {

		HistorySelect(SelectedHistoryFromTime(), SelectedHistoryToTime());

	}

}



template<typename T>

bool InArray(T &array[], T value)

{

	int size = ArraySize(array);



	if (size > 0)

	{

		for (int i = 0; i < size; i++)

		{

			if (array[i] == value)

			{

				return true;

			}

		}

	}



	return false;

}



//+------------------------------------------------------------------+

//| Checks if the specified expiration mode is allowed               |

//+------------------------------------------------------------------+

bool IsExpirationTypeAllowed(string symbol,int exp_type)

  {

//--- Obtain the value of the property that describes allowed expiration modes

   int expiration=(int)SymbolInfoInteger(symbol,SYMBOL_EXPIRATION_MODE);

//--- Return true, if mode exp_type is allowed

   return((expiration&exp_type)==exp_type);

  }



bool IsFillingTypeAllowed(string symbol,int fill_type)

{

//--- Obtain the value of the property that describes allowed filling modes

   int filling=(int)SymbolInfoInteger(symbol,SYMBOL_FILLING_MODE);

//--- Return true, if mode fill_type is allowed

   return((filling & fill_type)==fill_type);

}



bool IsOrderTypeSell()

{

	int loadedType = LoadedType();



	if (loadedType == 1)

	{

		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)

		{

			return true;

		}

	}

	else if (loadedType == 3)

	{

		return (OrderType() == ORDER_TYPE_SELL);

	}

	else if (loadedType == 4)

	{

		if (

			HistoryOrderGetInteger(OrderTicket(), ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT

			|| HistoryOrderGetInteger(OrderTicket(), ORDER_TYPE) == ORDER_TYPE_SELL_STOP

		) {

			return true;

		}

	}

	else if (

		OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT

		|| OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP

	) {

		return true;

	}



	return false;

}



bool LoadHistoryTrade(int index, string selectby="select_by_pos")

{

	if (selectby == "select_by_pos")

	{

		ulong ticket  = HistoryDealGetTicket(index);



		if (ticket > 0)

		{

			if (

				   //HistoryDealSelect(ticket) - commented, because it breaks HistorySelect()

				   HistoryDealGetInteger(ticket, DEAL_TYPE) < 2

				&& (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT

				)

			{

				OrderTicket(ticket);



				LoadedType(3);



				return true;

			}

		}

	}



	if (selectby == "select_by_ticket")

	{

		if (HistoryDealSelect(index))

		{

			OrderTicket(index);



			if (HistoryDealGetInteger(index, DEAL_TYPE) < 2)

			{

				LoadedType(3);



				return true;

			}

		}

	}



	return false;

}



bool LoadPendingOrder(long ticket)

{

	bool success = false;



   if (OrderSelect(ticket))

	{

		// The order could be from any type, so check the type

		// and allow only true pending orders.

		ENUM_ORDER_TYPE type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);



		if (

			   type == ORDER_TYPE_BUY_LIMIT

			|| type == ORDER_TYPE_SELL_LIMIT

			|| type == ORDER_TYPE_BUY_STOP

			|| type == ORDER_TYPE_SELL_STOP

		) {

			LoadedType(2);

			OrderTicket(ticket);

			success = true;

		}

	}



   return success;

}



bool LoadPosition(ulong ticket)

{

   bool success = PositionSelectByTicket(ticket);



   if (success) {

		LoadedType(1);

		OrderTicket(ticket);

	}



   return success;

}



int LoadedType(int type = 0)

{

	// 1 - position

	// 2 - pending order

	// 3 - history position

	// 4 - history pending order



	static int memory;



	if (type > 0) {memory = type;}



	return memory;

}



bool ModifyOrder(

	long ticket,

	double op,

	double sll = 0,

	double tpl = 0,

	double slp = 0,

	double tpp = 0,

	datetime exp = 0,

	color clr = clrNONE

) {

	int bs = 1;



	if (LoadedType() == 1)

	{

		if (OrderType() == POSITION_TYPE_SELL)

		{bs = -1;} // Positive when Buy, negative when Sell

	}

	else

	{

		if (

				OrderType() == ORDER_TYPE_SELL

			|| OrderType() == ORDER_TYPE_SELL_STOP

			|| OrderType() == ORDER_TYPE_SELL_LIMIT

		)

		{bs = -1;} // Positive when Buy, negative when Sell

	}



	while (true)

	{

		uint time0 = GetTickCount();

		

		if (LoadedType() == 1)

		{

			if (!PositionSelectByTicket(ticket)) {return false;}

		}

		else

		{

			if (!OrderSelect(ticket)) {return false;}

		}



		string symbol      = OrderSymbol();

		int type           = OrderType();

		int digits         = (int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);

		double ask         = SymbolInfoDouble(symbol,SYMBOL_ASK);

		double bid         = SymbolInfoDouble(symbol,SYMBOL_BID);

		double point       = SymbolInfoDouble(symbol,SYMBOL_POINT);

		double stoplevel   = point * SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);

		double freezelevel = point * SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);



		if (OrderType() < 2) {op = OrderOpenPrice();} else {op = NormalizeDouble(op,digits);}

		

		sll = NormalizeDouble(sll,digits);

		tpl = NormalizeDouble(tpl,digits);



		if (op < 0 || op >= EMPTY_VALUE || sll < 0 || slp < 0 || tpl < 0 || tpp < 0)

		{

			break;

		}



		//-- OP -----------------------------------------------------------

		// https://book.mql4.com/appendix/limits

		if (type == ORDER_TYPE_BUY_LIMIT)

		{

			if (ask - op < stoplevel) {op = ask - stoplevel;}

			if (ask - op <= freezelevel) {op = ask - freezelevel - point;}

		}

		else if (type == ORDER_TYPE_BUY_STOP)

		{

			if (op - ask < stoplevel) {op = ask + stoplevel;}

			if (op - ask <= freezelevel) {op = ask + freezelevel + point;}

		}

		else if (type == ORDER_TYPE_SELL_LIMIT)

		{

			if (op - bid < stoplevel) {op = bid + stoplevel;}

			if (op - bid <= freezelevel) {op = bid + freezelevel + point;}

		}

		else if (type == ORDER_TYPE_SELL_STOP)

		{

			if (bid - op < stoplevel) {op = bid - stoplevel;}

			if (bid - op < freezelevel) {op = bid - freezelevel - point;}

		}



		op = NormalizeDouble(op, digits);



		//-- SL and TP ----------------------------------------------------

		double sl = 0, tp = 0, vsl = 0, vtp = 0;



		sl = AlignStopLoss(symbol, type, op, attrStopLoss(), sll, slp);



		if (sl < 0) {break;}



		tp = AlignTakeProfit(symbol, type, op, attrTakeProfit(), tpl, tpp);



		if (tp < 0) {break;}



		if (USE_VIRTUAL_STOPS)

		{

			//-- virtual SL and TP --------------------------------------------

			vsl = sl;

			vtp = tp;

			sl  = 0;

			tp  = 0;



			double askbid = ask;



			if (bs < 0) {askbid = bid;}



			if (vsl > 0 || USE_EMERGENCY_STOPS == "always")

			{

				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)

				{

					sl = vsl - EMERGENCY_STOPS_REL*MathAbs(askbid-vsl)*bs;



					if (sl <= 0) {sl = askbid;}

					sl = sl-toDigits(EMERGENCY_STOPS_ADD,symbol)*bs;

				}

			}



			if (vtp > 0 || USE_EMERGENCY_STOPS == "always")

			{

				if (EMERGENCY_STOPS_REL>0 || EMERGENCY_STOPS_ADD>0)

				{

					tp=vtp+EMERGENCY_STOPS_REL*MathAbs(vtp-askbid)*bs;



					if (tp <= 0) {tp = askbid;}



					tp = tp + toDigits(EMERGENCY_STOPS_ADD,symbol)*bs;

				}

			}



			vsl = NormalizeDouble(vsl,digits);

			vtp = NormalizeDouble(vtp,digits);

		}



		sl = NormalizeDouble(sl,digits);

		tp = NormalizeDouble(tp,digits);



		//-- modify -------------------------------------------------------

		ResetLastError();

		

		if (USE_VIRTUAL_STOPS)

		{

			if (vsl != attrStopLoss() || vtp != attrTakeProfit())

			{

				VirtualStopsDriver("set", ticket, vsl, vtp, toPips(MathAbs(op-vsl), symbol), toPips(MathAbs(vtp-op), symbol));

			}

		}

		

		bool success = false;

		

		// check if needed to modify

		if (LoadedType() == 1)

		{

			if (

				   sl == NormalizeDouble(PositionGetDouble(POSITION_SL),digits)

				&& tp == NormalizeDouble(PositionGetDouble(POSITION_TP),digits)

				&& exp == OrderExpirationTime()

			) {

				return true;

			}

		}

		else

		{

			if (

				   op == NormalizeDouble(OrderGetDouble(ORDER_PRICE_OPEN),digits)

				&& sl == NormalizeDouble(OrderGetDouble(ORDER_SL),digits)

				&& tp == NormalizeDouble(OrderGetDouble(ORDER_TP),digits)

			) {

				return true;

			}

		}



		// prepare to modify

		MqlTradeRequest request;

		MqlTradeResult result;

		MqlTradeCheckResult check_result;

		ZeroMemory(request);

		ZeroMemory(result);

		ZeroMemory(check_result);



		// modify

		if (LoadedType() == 1)

		{

			// in case of position, only sl and tp are going to be modified

			request.action   = TRADE_ACTION_SLTP;

			request.symbol   = symbol;

			request.position = PositionGetInteger(POSITION_TICKET);

			request.magic    = PositionGetInteger(POSITION_MAGIC);

			request.comment  = PositionGetString(POSITION_COMMENT);

		}

		else

		{

			// in case of pending order

			request.action     = TRADE_ACTION_MODIFY;

			request.order      = ticket;

			request.price      = op;

			request.volume     = OrderGetDouble(ORDER_VOLUME_CURRENT);

			request.magic      = OrderGetInteger(ORDER_MAGIC);

			request.type_time  = ExpirationTypeByTime(symbol, exp);

			request.expiration = exp;

			request.comment    = OrderGetString(ORDER_COMMENT);



			//-- filling type

			uint filling = (uint)SymbolInfoInteger(request.symbol,SYMBOL_FILLING_MODE);



			if (filling == SYMBOL_FILLING_FOK)

			{

				request.type_filling = ORDER_FILLING_FOK;

			}

			else if (filling == SYMBOL_FILLING_IOC)

			{

				request.type_filling = ORDER_FILLING_IOC;

			}

		}

		

		request.sl = sl;

		request.tp = tp;



		if (!OrderCheck(request,check_result))

		{

			Print("OrderCheck() failed: " + (string)check_result.comment + " (" + (string)check_result.retcode + ")");



			return false;

		}



		success = OrderSend(request, result);



		//-- error check --------------------------------------------------

		if (result.retcode != TRADE_RETCODE_DONE)

		{

			string errmsgpfx = "Modify error";

			int erraction = CheckForTradingError(result.retcode, errmsgpfx);



			switch(erraction)

			{

				case 0: break;    // no error

				case 1: continue; // overcomable error

				case 2: break;    // fatal error

			}



			return false;

		}



		//-- finish work --------------------------------------------------

		if (result.retcode == TRADE_RETCODE_DONE)

		{

			//== Wait until MT5 updates its cache

			int w;



			for (w = 0; w < 5000; w++)

			{

				if (((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket)) && (sl == NormalizeDouble(OrderStopLoss(), digits) && tp == NormalizeDouble(OrderTakeProfit(), digits)))

				{

					break;

				}



				Sleep(1);

			}



			if (w == 5000)

			{

				Print("Check error: Modify order stops");  

			}



			if (!((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket)) || (sl != NormalizeDouble(OrderStopLoss(), digits) || tp != NormalizeDouble(OrderTakeProfit(), digits)))

			{

				Print("Something went wrong when trying to modify the stops");



				return false;

			}



			if (!((LoadedType() == 1 && PositionSelectByTicket(ticket)) || OrderSelect(ticket)))

			{

				return false;

			}



			OrderModified((int)ticket);

		}



		break;

	}



	OnTrade();



	return true;

}



bool ModifyStops(ulong ticket, double sl=-1, double tp=-1, color clr=clrNONE)

{

   return ModifyOrder(

		ticket,

		OrderOpenPrice(),

		sl,

		tp,

		0,

		0,

		OrderExpirationTime()

	);

}



int OCODriver()

{

	static long last_known_ticket = 0;

	static long orders1[];

	static long orders2[];

	int i, size;



	int total = OrdersTotal();



	for (int pos=total-1; pos>=0; pos--)

	{

		if (LoadPendingOrder(OrderGetTicket(pos)))

		{

			long ticket = OrderTicket();



			//-- end here if we reach the last known ticket

			if (ticket == last_known_ticket) {break;}



			//-- set the last known ticket, only if this is the first iteration

			if (pos == total-1) {

				last_known_ticket = ticket;

			}



			//-- we are searching for pending orders, skip trades

			if (OrderType() <= ORDER_TYPE_SELL) {continue;}



			//--

			if (StringSubstr(OrderComment(), 0, 5) == "[oco:")

			{

				int ticket_oco = StrToInteger(StringSubstr(OrderComment(), 5, StringLen(OrderComment())-1)); 



				bool found = false;

				size = ArraySize(orders2);

				for (i=0; i<size; i++)

				{

					if (orders2[i] == ticket_oco) {

						found = true;

						break;

					}

				}



				if (found == false) {

					ArrayResize(orders1, size+1);

					ArrayResize(orders2, size+1);

					orders1[size] = ticket_oco;

					orders2[size] = ticket;

				}

			}

		}

	}



	size = ArraySize(orders1);

	int dbremove = false;



	for (i = size - 1; i >= 0; i--)

	{

		if (LoadPendingOrder(orders1[i]) == false || OrderType() <= ORDER_TYPE_SELL)

		{

			if (LoadPendingOrder(orders2[i])) {

				if (DeleteOrder(orders2[i]))

				{

					dbremove = true;

				}

			}

			else {

				dbremove = true;

			}

			

			if (dbremove == true)

			{

				ArrayStripKey(orders1, i);

				ArrayStripKey(orders2, i);

			}

		}

	}



	size = ArraySize(orders2);

	dbremove = false;

	for (i=size-1; i>=0; i--)

	{

		if (LoadPendingOrder(orders2[i]) == false || OrderType() <= ORDER_TYPE_SELL)

		{

			if (LoadPendingOrder(orders1[i])) {

				if (DeleteOrder(orders1[i]))

				{

					dbremove = true;

				}

			}

			else {

				dbremove = true;

			}

			

			if (dbremove == true)

			{

				ArrayStripKey(orders1, i);

				ArrayStripKey(orders2, i);

			}

		}

	}



	return true;

}



bool OnTimerSet(double seconds)

{

   if (seconds<=0) {

      EventKillTimer();

   }

   else if (seconds < 1) {

      return (EventSetMillisecondTimer((int)(seconds*1000)));  

   }

   else {

      return (EventSetTimer((int)seconds));

   }

   

   return true;

}



class OnTradeEventDetector

{

private:

	//--- structures

	struct EventValues

	{

		// special fields

		string   reason,

		         detail;



		// order related fields

		long     magic,

		         ticket;

		int      type;

		datetime timeClose,

		         timeOpen,

		         timeExpiration;

		double   commission,

		         priceOpen,

		         priceClose,

		         profit,

		         stopLoss,

		         swap,

		         takeProfit,

		         volume;

		string   comment,

		         symbol;

	};



	struct Position

	{

		ENUM_POSITION_TYPE type;

		ENUM_POSITION_REASON reason;

		long     positionId,

		         magic,

		         ticket,

		         timeMs,

		         timeUpdateMs;

		datetime time,

					timeExpiration,

		         timeUpdate;

		double   priceCurrent,

		         priceOpen,

		         profit,

		         stopLoss,

		         swap,

		         takeProfit,

		         volume;

		string   externalId,

		         comment,

		         symbol;

	};



	struct PendingOrder

	{

		ENUM_ORDER_TYPE type;

		ENUM_ORDER_STATE state;

		ENUM_ORDER_TYPE_FILLING typeFilling;

		ENUM_ORDER_TYPE_TIME typeTime;

		ENUM_ORDER_REASON reason;

		long     magic,

		         positionId,

		         positionById,

		         ticket,

		         timeSetupMs,

		         timeDoneMs;

		datetime timeDone,

		         timeExpiration,

		         timeSetup;

		double   priceCurrent,

		         priceOpen,

		         priceStopLimit,

		         stopLoss,

		         takeProfit,

		         volume,

		         volumeInitial;

		string   externalId,

		         comment,

		         symbol;

	};

	

	struct PositionExpirationTimes

	{

		long ticket;

		datetime timeExpiration;

	};



	//--- variables and arrays

	bool debug;

	

	// Because we can have multiple new events at once, the idea is

	// to run the detector repeatedly until no new event is detected.

	// When this variable is true, it means that the event detection

	// is repeated. It should stop repeating when no new event is detected.

	bool isRepeat;



	int eventValuesQueueIndex;

	EventValues eventValues[];



	PendingOrder previousPendingOrders[];

	PendingOrder pendingOrders[];



	Position previousPositions[];

	Position positions[];



	PositionExpirationTimes positionExpirationTimes[];



	//--- methods



	/**

	* Like ArrayCopy(), but for any type.

	*/

	template<typename T>

	void CopyList(T &dest[], T &src[])

	{

		int size = ArraySize(src);

		ArrayResize(dest, size);



		for (int i = 0; i < size; i++)

		{

			dest[i] = src[i];

		}

	}



	/**

	* Overloaded method 1 of 2

	*/

	int MakeListOf(PendingOrder &list[])

	{

		ArrayResize(list, 0);



		int count        = OrdersTotal();

		int howManyAdded = 0;



		for (int index = 0; index < count; index++)

		{

			if (OrderGetTicket(index) <= 0) continue;



			ENUM_ORDER_TYPE orderType = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);



			if (

				orderType != ORDER_TYPE_BUY_LIMIT

				&& orderType != ORDER_TYPE_SELL_LIMIT

				&& orderType != ORDER_TYPE_BUY_STOP

				&& orderType != ORDER_TYPE_SELL_STOP

				&& orderType != ORDER_TYPE_BUY_STOP_LIMIT

				&& orderType != ORDER_TYPE_SELL_STOP_LIMIT

			) {

				continue;

			}



			howManyAdded++;

			ArrayResize(list, howManyAdded);

			int i = howManyAdded - 1;



			// enum types

			list[i].type        = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);

			list[i].state       = (ENUM_ORDER_STATE)OrderGetInteger(ORDER_STATE);

			list[i].typeFilling = (ENUM_ORDER_TYPE_FILLING)OrderGetInteger(ORDER_TYPE_FILLING);

			list[i].typeTime    = (ENUM_ORDER_TYPE_TIME)OrderGetInteger(ORDER_TYPE_TIME);

			list[i].reason      = (ENUM_ORDER_REASON)OrderGetInteger(ORDER_REASON);



			// long

			list[i].magic        = (long)OrderGetInteger(ORDER_MAGIC);

			list[i].positionId   = (long)OrderGetInteger(ORDER_POSITION_ID);

			list[i].positionById = (long)OrderGetInteger(ORDER_POSITION_BY_ID);

			list[i].ticket       = (long)OrderGetInteger(ORDER_TICKET);

			list[i].timeSetupMs  = (long)OrderGetInteger(ORDER_TIME_SETUP_MSC);

			list[i].timeDoneMs   = (long)OrderGetInteger(ORDER_TIME_DONE_MSC);



			// datetime

			list[i].timeDone       = (datetime)OrderGetInteger(ORDER_TIME_DONE);

			list[i].timeExpiration = (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);

			list[i].timeSetup      = (datetime)OrderGetInteger(ORDER_TIME_SETUP);



			// double

			list[i].priceCurrent   = OrderGetDouble(ORDER_PRICE_CURRENT);

			list[i].priceOpen      = OrderGetDouble(ORDER_PRICE_OPEN);

			list[i].priceStopLimit = OrderGetDouble(ORDER_PRICE_STOPLIMIT);

			list[i].stopLoss       = OrderGetDouble(ORDER_SL);

			list[i].takeProfit     = OrderGetDouble(ORDER_TP);

			list[i].volume         = OrderGetDouble(ORDER_VOLUME_CURRENT);

			list[i].volumeInitial  = OrderGetDouble(ORDER_VOLUME_INITIAL);



			// string

			list[i].externalId = OrderGetString(ORDER_EXTERNAL_ID);

			list[i].comment    = OrderGetString(ORDER_COMMENT);

			list[i].symbol     = OrderGetString(ORDER_SYMBOL);

		}



		return howManyAdded;

	}



	/**

	* Overloaded method 2 of 2

	*/

	int MakeListOf(Position &list[])

	{

		ArrayResize(list, 0);



		int count        = PositionsTotal();

		int howManyAdded = 0;



		for (int index = 0; index < count; index++)

		{

			if (PositionGetTicket(index) <= 0) continue;



			howManyAdded++;

			ArrayResize(list, howManyAdded);

			int i = howManyAdded - 1;



			// enum types

			list[i].type   = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

			list[i].reason = (ENUM_POSITION_REASON)PositionGetInteger(POSITION_REASON);



			// long

			list[i].positionId   = (long)PositionGetInteger(POSITION_IDENTIFIER);

			list[i].magic        = (long)PositionGetInteger(POSITION_MAGIC);

			list[i].ticket       = (long)PositionGetInteger(POSITION_TICKET);

			list[i].timeMs       = (long)PositionGetInteger(POSITION_TIME_MSC);

			list[i].timeUpdateMs = (long)PositionGetInteger(POSITION_TIME_UPDATE_MSC);



			// datetime

			list[i].time           = (datetime)PositionGetInteger(POSITION_TIME);

			list[i].timeExpiration = (datetime)0;

			list[i].timeUpdate     = (datetime)PositionGetInteger(POSITION_TIME_UPDATE);



			// double

			list[i].priceCurrent = PositionGetDouble(POSITION_PRICE_CURRENT);

			list[i].priceOpen    = PositionGetDouble(POSITION_PRICE_OPEN);

			list[i].profit       = PositionGetDouble(POSITION_PROFIT);

			list[i].stopLoss     = PositionGetDouble(POSITION_SL);

			list[i].swap         = PositionGetDouble(POSITION_SWAP);

			list[i].takeProfit   = PositionGetDouble(POSITION_TP);

			list[i].volume       = PositionGetDouble(POSITION_VOLUME);



			// string

			list[i].externalId = PositionGetString(POSITION_EXTERNAL_ID);

			list[i].comment    = PositionGetString(POSITION_COMMENT);

			list[i].symbol     = PositionGetString(POSITION_SYMBOL);



			// extract expiration

			list[i].timeExpiration = expirationWorker.GetExpiration(list[i].ticket);



			if (USE_VIRTUAL_STOPS)

			{

				list[i].stopLoss   = VirtualStopsDriver("get sl", list[i].ticket);

				list[i].takeProfit = VirtualStopsDriver("get tp", list[i].ticket);

			}

		}



		return howManyAdded;

	}



	/**

	* This method loops through 2 lists of items and finds a difference. This difference is the event.

	* "Items" are either pending orders or positions.

	*

	* Returns true if an event is detected or false if not.

	*/

	template<typename ITEMS_TYPE> 

	bool DetectEvent(ITEMS_TYPE &previousItems[], ITEMS_TYPE &currentItems[])

	{

		ITEMS_TYPE item;

		string reason   = "";

		string detail   = "";

		int countBefore = ArraySize(previousItems);

		int countNow    = ArraySize(currentItems);



		// closed

		if (reason == "") {

			for (int index = 0; index < countBefore; index++) {

				item = FindMissingItem(previousItems, currentItems);



				if (item.ticket > 0) {

					DeleteItem(previousItems, item);

					reason = "close";



					break;

				}

			}

		}



		// new

		if (reason == "") {

			for (int index = 0; index < countNow; index++) {

				item = FindMissingItem(currentItems, previousItems);



				if (item.ticket > 0) {

					if (

						item.type < 2 // it's a running trade

						&& item.ticket != attrTicketParent(item.ticket)

					) {

						// In MQL4: When a trade is closed partially, the ticket changes.

						// The original (parent) trade is closed and a new one is created,

						// with a different ticket.

						reason = "decrement";

					}

					else {

						reason = "new";

					}



					PushItem(previousItems, item);



					break;

				}

			}

		}



		// modified

		if (reason == "") {

			if (countBefore != countNow) {

				Print("OnTrade event detector: Uncovered situation reached");

			}



			for (int index = 0; index < countNow; index++) {

				int previousIndex = -1;



				ITEMS_TYPE current = currentItems[index];

				ITEMS_TYPE previous;

				previous.ticket = 0;



				for (int j = 0; j < countBefore; j++) {

					if (current.ticket == previousItems[j].ticket) {

						previousIndex = j;

						previous = previousItems[j];



						break;

					}

				}



				if (current.ticket != previous.ticket) {

					Print("OnTrade event detector: Uncovered situation reached (2)");

				}



				if (previous.volume < current.volume) {

					previousItems[previousIndex].volume = current.volume;

					item = previousItems[previousIndex];



					reason = "increment";



					break;

				}



				if (previous.volume > current.volume) {

					previousItems[previousIndex].volume = current.volume;

					item = previousItems[previousIndex];



					reason = "decrement";



					break;

				}



				if (

					previous.stopLoss != current.stopLoss

					&& previous.takeProfit != current.takeProfit

				) {

					previousItems[previousIndex].stopLoss = current.stopLoss;

					previousItems[previousIndex].takeProfit = current.takeProfit;

					item = previousItems[previousIndex];



					reason = "modify";

					detail = "sltp";



					break;

				}

				// SL modified

				else if (previous.stopLoss != current.stopLoss) {

					previousItems[previousIndex].stopLoss = current.stopLoss;

					item = previousItems[previousIndex];



					reason = "modify";

					detail = "sl";



					break;

				}

				// TP modified

				else if (previous.takeProfit != current.takeProfit) {

					previousItems[previousIndex].takeProfit = current.takeProfit;

					item = previousItems[previousIndex];



					reason = "modify";

					detail = "tp";



					break;

				}



				if (previous.timeExpiration != current.timeExpiration) {

					previousItems[previousIndex].timeExpiration = current.timeExpiration;

					item = previousItems[previousIndex];



					reason = "modify";

					detail = "expiration";



					break;

				}

			}

		}



		if (reason == "")

		{

			return false;

		}



		UpdateValues(item, reason, detail);



		return true;

	}



	/**

	* From the source list of orders or positions, find the item that is missing

	* in the target list of orders or positions. The searching is by the item's ticket.

	*

	* If all items from the source list exist in the target list, return an empty item with ticket 0.

	* If for some item in source list there is no item in the target list, return that source item.

	*/

	template<typename T> 

	T FindMissingItem(T &source[], T &target[])

	{

		int sourceCount = ArraySize(source);

		int targetCount  = ArraySize(target);

		T item;

		item.ticket = 0;



		long ticket = 0;



		for (int i = 0; i < sourceCount; i++)

		{

			bool found = false;



			for (int j = 0; j < targetCount; j++)

			{

				if (source[i].ticket == target[j].ticket)

				{

					found = true;

					break;

				}

			}



			if (found == false)

			{

				item = source[i];

				break;

			}

		}



		return item;

	}



	/**

	* From the list of previous orders or positions, find and remove the

	* provided item.

	*/

	template<typename T> 

	bool DeleteItem(T &list[], T &item)

	{

		int listCount = ArraySize(list);

		bool removed = false;



		for (int i = 0; i < listCount; i++)

		{

			if (list[i].ticket == item.ticket) {

				ArrayStripKey(list, i);

				removed = true;



				break;

			}

		}



		return removed;

	}



	/**

	* Push a new item in the list

	*/

	template<typename T> 

	void PushItem(T &list[], T &item)

	{

		int listCount = ArraySize(list);



		ArrayResize(list, listCount + 1);



		list[listCount] = item;

	}



	/**

	* Overloaded method 1 of 2

	*/

	void UpdateValues(Position &item, string reason, string detail)

	{

		long ticket        = item.ticket;

		datetime timeOpen  = item.time;

		datetime timeClose = (datetime)0;

		double priceOpen   = item.priceOpen;

		double priceClose  = item.priceCurrent;

		double profit      = item.profit;

		double swap        = item.swap;

		double commission  = 0.0;

		double volume      = item.volume;



		if (reason == "close" || reason == "decrement")

		{

			if (HistorySelectByPosition(item.positionId))

			{

				int total = HistoryDealsTotal();



				if (total > 0)

				{

					long firstTicket = (long)HistoryDealGetTicket(0);

					long lastTicket  = (long)HistoryDealGetTicket(total - 1);



					// Ticket is the ticket of the previous deal, the one before the last one

					ticket = (long)HistoryDealGetTicket(total - 2);



					// Open Time and Open Price - get them from the very first deal

					priceOpen = HistoryDealGetDouble(firstTicket, DEAL_PRICE);

					timeOpen  = (datetime)HistoryDealGetInteger(firstTicket, DEAL_TIME);



					// Close Time - get it from the very last deal

					timeClose  = (datetime)HistoryDealGetInteger(lastTicket, DEAL_TIME);

					priceClose = HistoryDealGetDouble(lastTicket, DEAL_PRICE);



					profit     = HistoryDealGetDouble(lastTicket, DEAL_PROFIT);

					swap       = HistoryDealGetDouble(lastTicket, DEAL_SWAP);

					commission = HistoryDealGetDouble(lastTicket, DEAL_COMMISSION);



					volume = HistoryDealGetDouble(lastTicket, DEAL_VOLUME);



					// Find why the position has been closed

					if (detail == "")

					{

						if (

							item.timeExpiration > 0

							&& item.timeExpiration <= timeClose

						) {

							detail = "expiration";

						}

					}



					if (detail == "")

					{

						ENUM_DEAL_REASON dealReason = (ENUM_DEAL_REASON)HistoryDealGetInteger(lastTicket, DEAL_REASON);

	

						switch (dealReason)

						{

							case DEAL_REASON_SL: detail = "sl"; break;

							case DEAL_REASON_TP: detail = "tp"; break;

							case DEAL_REASON_SO: detail = "so"; break;

						}

					}

				}

			}

		}



		int i = eventValuesQueueIndex;



		eventValues[i].reason = reason;

		eventValues[i].detail = detail;



		eventValues[i].priceClose     = priceClose;

		eventValues[i].timeClose      = timeClose;

		eventValues[i].comment        = item.comment;

		eventValues[i].commission     = commission;

		eventValues[i].timeExpiration = item.timeExpiration;

		eventValues[i].volume         = volume;

		eventValues[i].magic          = item.magic;

		eventValues[i].priceOpen      = priceOpen;

		eventValues[i].timeOpen       = timeOpen;

		eventValues[i].profit         = profit;

		eventValues[i].stopLoss       = item.stopLoss;

		eventValues[i].swap           = swap;

		eventValues[i].symbol         = item.symbol;

		eventValues[i].takeProfit     = item.takeProfit;

		eventValues[i].ticket         = ticket;

		eventValues[i].type           = item.type;



		if (debug)

		{

			PrintUpdatedValues();

		}

	}



	/**

	* Overloaded method 2 of 2

	*/

	void UpdateValues(PendingOrder &item, string reason, string detail)

	{

		datetime timeExpiration = item.timeExpiration;



		// When the lifetime of the order is ORDER_TIME_DAY,

		// the expiration (ORDER_TIME_EXPIRATION) equals to the time of opening.

		// Here we fix this.

		if (item.typeTime == ORDER_TIME_DAY)

		{

			timeExpiration = (datetime)(MathFloor(((double)item.timeSetup + 86400.0) / 86400.0) * 86400.0);

		}



		int i = eventValuesQueueIndex;



		eventValues[i].reason = reason;

		eventValues[i].detail = detail;



		eventValues[i].priceClose     = item.priceCurrent;

		eventValues[i].timeClose      = item.timeDone;

		eventValues[i].comment        = item.comment;

		eventValues[i].commission     = 0.0;

		eventValues[i].timeExpiration = timeExpiration;

		eventValues[i].volume         = item.volume;

		eventValues[i].magic          = item.magic;

		eventValues[i].priceOpen      = item.priceOpen;

		eventValues[i].timeOpen       = item.timeSetup;

		eventValues[i].profit         = 0.0;

		eventValues[i].stopLoss       = item.stopLoss;

		eventValues[i].swap           = 0.0;

		eventValues[i].symbol         = item.symbol;

		eventValues[i].takeProfit     = item.takeProfit;

		eventValues[i].ticket         = item.ticket;

		eventValues[i].type           = item.type;



		if (debug)

		{

			PrintUpdatedValues();

		}

	}



	void PrintUpdatedValues()

	{

		Print(

			" <<<\n",

			" | reason: ", e_Reason(),

			" | detail: ", e_ReasonDetail(),

			" | ticket: ", e_attrTicket(),

			" | type: ", EnumToString((ENUM_ORDER_TYPE)e_attrType()),

			"\n",

			" | openTime : ", e_attrOpenTime(),

			" | openPrice : ", e_attrOpenPrice(),

			"\n",

			" | closeTime: ", e_attrCloseTime(),

			" | closePrice: ", e_attrClosePrice(),

			"\n",

			" | volume: ", e_attrLots(),

			" | sl: ", e_attrStopLoss(),

			" | tp: ", e_attrTakeProfit(),

			" | profit: ", e_attrProfit(),

			" | swap: ", e_attrSwap(),

			" | exp: ", e_attrExpiration(),

			" | comment: ", e_attrComment(),

			"\n >>>"

		);

	}



	int AddEventValues()

	{

		eventValuesQueueIndex++;

		ArrayResize(eventValues, eventValuesQueueIndex + 1);



		return eventValuesQueueIndex;

	}



	int RemoveEventValues()

	{

		if (eventValuesQueueIndex == -1)

		{

			Print("Cannot remove event values, add them first. (in function ", __FUNCTION__, ")");

		}

		else

		{

			eventValuesQueueIndex--;

			ArrayResize(eventValues, eventValuesQueueIndex + 1);

		}



		return eventValuesQueueIndex;

	}



public:

	/**

	* Default constructor

	*/

	OnTradeEventDetector(void)

	{

		debug = false;

		isRepeat = false;

		eventValuesQueueIndex = -1;

	};



	bool Start()

	{

		AddEventValues();



		if (isRepeat == false) {

			MakeListOf(pendingOrders);

			MakeListOf(positions);

		}



		bool success = false;



		if (!success) success = DetectEvent(previousPendingOrders, pendingOrders);



		if (!success) success = DetectEvent(previousPositions, positions);



		//CopyList(previousPendingOrders, pendingOrders);

		//CopyList(previousPositions, positions);



		isRepeat = success; // Repeat until no success



		return success;

	}



	void End()

	{

		RemoveEventValues();

	}



	string EventValueReason() {return eventValues[eventValuesQueueIndex].reason;}

	string EventValueDetail() {return eventValues[eventValuesQueueIndex].detail;}



	int EventValueType() {return eventValues[eventValuesQueueIndex].type;}



	datetime EventValueTimeClose()      {return eventValues[eventValuesQueueIndex].timeClose;}

	datetime EventValueTimeOpen()       {return eventValues[eventValuesQueueIndex].timeOpen;}

	datetime EventValueTimeExpiration() {return eventValues[eventValuesQueueIndex].timeExpiration;}



	long EventValueMagic()  {return eventValues[eventValuesQueueIndex].magic;}

	long EventValueTicket() {return eventValues[eventValuesQueueIndex].ticket;}



	double EventValueCommission() {return eventValues[eventValuesQueueIndex].commission;}

	double EventValuePriceOpen()  {return eventValues[eventValuesQueueIndex].priceOpen;}

	double EventValuePriceClose() {return eventValues[eventValuesQueueIndex].priceClose;}

	double EventValueProfit()     {return eventValues[eventValuesQueueIndex].profit;}

	double EventValueStopLoss()   {return eventValues[eventValuesQueueIndex].stopLoss;}

	double EventValueSwap()       {return eventValues[eventValuesQueueIndex].swap;}

	double EventValueTakeProfit() {return eventValues[eventValuesQueueIndex].takeProfit;}

	double EventValueVolume()     {return eventValues[eventValuesQueueIndex].volume;}



	string EventValueComment() {return eventValues[eventValuesQueueIndex].comment;}

	string EventValueSymbol()  {return eventValues[eventValuesQueueIndex].symbol;}

};



OnTradeEventDetector onTradeEventDetector;



double OrderClosePrice()

{

	int type = LoadedType();



	if (type == 1)

	{

		if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)

		{

			return SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_BID);

		}

		else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)

		{

			return SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_ASK);

		}

	}

	if (type == 3) {

		ulong dealTicket = OrderTicket();

		ENUM_DEAL_ENTRY dealEntry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(dealTicket, DEAL_ENTRY);

		long positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);

		double price = HistoryDealGetDouble(dealTicket, DEAL_PRICE);



		HistorySelectByPosition(positionId);

		

		// Search for the first OUT deal after this one and get the price from it



		int total = HistoryDealsTotal();

	

		for (int i = total - 1; i >= 0; i--) {

			ulong ticket = HistoryDealGetTicket(i);

	

			if (ticket == dealTicket) {

				// Get the current value if the deal is the the last one

				if (i == total - 1 && PositionSelectByDeal(ticket))

				{

					if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)

					{

						price = SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_BID);

					}

					else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)

					{

						price = SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_ASK);

					}

				}

		

				break;

			}

	

			if (HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT) {

				price = HistoryDealGetDouble(ticket, DEAL_PRICE);

			}

		}

		

		HistoryTradesTotalReset();

		

		return price;

	}

	if (type == 4) {return HistoryDealGetDouble(OrderTicket(), DEAL_PRICE);}



	return(OrderGetDouble(ORDER_PRICE_CURRENT));

}



datetime OrderCloseTime()

{

	int type = LoadedType();



	if (type == 1)

	{

		return 0;

	}



	if (type == 3)

	{

		ulong dealTicket = OrderTicket();

		ENUM_DEAL_ENTRY dealEntry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(dealTicket, DEAL_ENTRY);

		long positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);

		datetime time = (datetime)HistoryDealGetInteger(dealTicket, DEAL_TIME);



		HistorySelectByPosition(positionId);



		// Search for the first OUT deal after this one and get the time from it



		int total = HistoryDealsTotal();



		for (int i = total - 1; i >= 0; i--) {

			ulong ticket = HistoryDealGetTicket(i);



			if (ticket == dealTicket) {

				if (i == total - 1 && PositionSelectByDeal(ticket))

				{

					time = (datetime)0;

				}



				break;

			}



			if (HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT) {

				time = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);

			}

		}



		HistoryTradesTotalReset();



		return time;

	}



	if (type == 4)

	{

		return (datetime)HistoryOrderGetInteger(OrderTicket(),ORDER_TIME_DONE);

	}

	

	return (datetime)OrderGetInteger(ORDER_TIME_DONE);

}



string OrderComment()

{

	int type = LoadedType();



	if (type == 1) {return PositionGetString(POSITION_COMMENT);}

	if (type == 3) {return HistoryOrderGetString(HistoryDealGetInteger(OrderTicket(), DEAL_POSITION_ID), ORDER_COMMENT);}

	if (type == 4) {return HistoryOrderGetString(OrderTicket(), ORDER_COMMENT);}



	return OrderGetString(ORDER_COMMENT);

}



long OrderCreate(

	string   symbol     = "",

	int      type       = ORDER_TYPE_BUY,

	double   lots       = 0,

	double   op         = 0,

	double   sll        = 0,

	double   tpl        = 0,

	double   slp        = 0,

	double   tpp        = 0,

	double   slippage   = 0,

	ulong    magic      = 0,

	string   comment    = NULL,

	color    arrowcolor = clrNONE,

	datetime expiration = 0,

	bool     oco        = false

	)

{

	OnTrade(); // When position is closed by sl or tp, this event is not fired (by MetaTrader) until the end of the tick, and if a new position is opened, it will be missed. 



	uint time0 = GetTickCount(); // used to measure speed of execution of the order

	

	bool placeExpirationObject = false; // whether or not to create an object for expiration for trades



	bool closing = false;

	double lots0 = 0;

	long type0   = type;



	if (

		   (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING)

		&& (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)

		)

	{

		if (PositionSelect(symbol))

		{

			if ((int)PositionGetInteger(POSITION_TYPE) != type)

			{

				closing = true;

			}



			lots0 = NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5);

			type0 = PositionGetInteger(POSITION_TYPE);

		}

	}



	ulong ticket = -1;



	// calculate buy/sell flag (1 when Buy or -1 when Sell)

	int bs = 1;



	if (

		   type == ORDER_TYPE_SELL

		|| type == ORDER_TYPE_SELL_STOP

		|| type == ORDER_TYPE_SELL_LIMIT

	)

	{

		bs = -1;

	}



	if (symbol == "") {symbol = Symbol();}



	lots = AlignLots(symbol, lots);



	int digits = 0;

	double ask = 0, bid = 0, point = 0, ticksize = 0;

	double sl = 0, tp = 0;

	double vsl = 0, vtp = 0;

	bool successed = false;



	//-- attempts to send position/order ---------------------------------

	while (true)

	{

		digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

		ask      = SymbolInfoDouble(symbol, SYMBOL_ASK);

		bid      = SymbolInfoDouble(symbol, SYMBOL_BID);

		point    = SymbolInfoDouble(symbol, SYMBOL_POINT);

		ticksize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);



		//- not enough money check: fix maximum possible lot by margin required, or quit

		if ((type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL) && closing == false)

		{

			double LotStep         = SymbolLotStep(symbol);

			double MinLots         = SymbolMinLot(symbol);

			double margin_required = 0;

			bool ocm               = OrderCalcMargin((ENUM_ORDER_TYPE)type, symbol, 1, SymbolInfoDouble(symbol, SYMBOL_ASK), margin_required);

			static bool not_enough_message = false;



			if (margin_required != 0)

			{

				double max_size_by_margin = AccountFreeMargin() / margin_required;

			

				if (lots > max_size_by_margin)

				{

					double lots_old = lots;

					lots = max_size_by_margin;



					if (lots < MinLots)

					{

						if (not_enough_message == false)

						{

							Print("Not enough money to trade :( The robot is still working, waiting for some funds to appear...");

						}



						not_enough_message = true;



						return -1;

					}

					else

					{

						lots = MathFloor(lots / LotStep) * LotStep;

						Print("Not enough money to trade " + DoubleToString(lots_old, 2) + ", the volume to trade will be the maximum possible of " + DoubleToString(lots, 2));

					}

				}

			}



			not_enough_message = false;

		}



		// fix the comment, because it seems that the comment is deleted if its lenght is > 31 symbols

		if (StringLen(comment) > 31)

		{

			comment = StringSubstr(comment, 0, 31);

		}



		//- expiration for trades

		if (type == POSITION_TYPE_BUY || type == POSITION_TYPE_SELL)

		{

			if (expiration > 0)

			{

				//- bo broker?

				if (

					   StringLen(symbol) > 6

					&& StringSubstr(symbol, StringLen(symbol) - 2) == "bo"

				) {

					//- convert UNIX to seconds

					if (expiration > TimeCurrent()-100)

					{

						expiration = expiration - TimeCurrent();

					}



					comment = "BO exp:" + (string)expiration;

				}

				else

				{

					// The expiration in this case is a vertical line

					// Comment doesn't always work,

					// because it changes when the trade is partially closed

					placeExpirationObject = true;

				}

			}

		}



		if (type == ORDER_TYPE_BUY || type == ORDER_TYPE_SELL)

		{

			op = (bs > 0) ? ask : bid;

		}



		op  = NormalizeDouble(op, digits);

		sll = NormalizeDouble(sll, digits);

		tpl = NormalizeDouble(tpl, digits);



		if (op < 0 || op >= EMPTY_VALUE || sll < 0 || slp < 0 || tpl < 0 || tpp < 0)

		{

			break;

		}



		//-- SL and TP ----------------------------------------------------

		vsl = 0;

		vtp = 0;



		sl = AlignStopLoss(symbol, type, op, 0, NormalizeDouble(sll,digits), slp);



		if (sl < 0) {break;}



		tp = AlignTakeProfit(symbol, type, op, 0, NormalizeDouble(tpl,digits), tpp);



		if (tp < 0) {break;}



		if (USE_VIRTUAL_STOPS)

		{

			//-- virtual SL and TP --------------------------------------------

			vsl = sl;

			vtp = tp;

			sl = 0;

			tp = 0;

			

			double askbid = (bs > 0) ? ask : bid;

			

			if (vsl > 0 || USE_EMERGENCY_STOPS == "always")

			{

				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)

				{

					sl = vsl - EMERGENCY_STOPS_REL * MathAbs(askbid - vsl) * bs;



					if (sl <= 0) {sl = askbid;}



					sl = sl - toDigits(EMERGENCY_STOPS_ADD, symbol) * bs;

				}

			}



			if (vtp > 0 || USE_EMERGENCY_STOPS == "always")

			{

				if (EMERGENCY_STOPS_REL > 0 || EMERGENCY_STOPS_ADD > 0)

				{

					tp = vtp + EMERGENCY_STOPS_REL * MathAbs(vtp - askbid) * bs;



					if (tp <= 0) {tp = askbid;}



					tp = tp + toDigits(EMERGENCY_STOPS_ADD, symbol) * bs;

				}

			}



			vsl = NormalizeDouble(vsl, digits);

			vtp = NormalizeDouble(vtp, digits);

		}



		sl = NormalizeDouble(sl, digits);

		tp = NormalizeDouble(tp, digits);



		//-- send ---------------------------------------------------------

		MqlTradeRequest request;

		MqlTradeResult result;

		MqlTradeCheckResult check_result;

		ZeroMemory(request);

		ZeroMemory(result);

		ZeroMemory(check_result);



		ENUM_SYMBOL_TRADE_EXECUTION exec = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(symbol,SYMBOL_TRADE_EXEMODE);



		//-- fix prices by ticksize

		op = MathRound(op / ticksize) * ticksize;

		sl = MathRound(sl / ticksize) * ticksize;

		tp = MathRound(tp / ticksize) * ticksize;



		request.symbol     = symbol;

		request.type       = (ENUM_ORDER_TYPE)type;

		request.volume     = lots;

		request.price      = op;

		request.deviation  = (ulong)(slippage * PipValue(symbol));

		request.sl         = sl;

		request.tp         = tp;

		request.comment    = comment;

		request.magic      = magic;

		request.type_time  = ExpirationTypeByTime(symbol, expiration);

		request.expiration = expiration;



		//-- request action

		if (type > ORDER_TYPE_SELL)

		{

			request.action = TRADE_ACTION_PENDING;

		}

		else

		{

			request.action = TRADE_ACTION_DEAL;

		}

		//-- filling type

		

		// check ORDER_FILLING_RETURN for pending orders only 

		if (type > ORDER_TYPE_SELL)

		{

			if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN))

				request.type_filling = ORDER_FILLING_RETURN;

			else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_FOK))

				request.type_filling = ORDER_FILLING_FOK;

			else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_IOC))

				request.type_filling = ORDER_FILLING_IOC;

		}

		else

		{

			// in case of positions I would check for SYMBOL_FILLING_ and then set ORDER_FILLING_

			// this is because it appears that IsFillingTypeAllowed() works correct with SYMBOL_FILLING_, but then the position works correctly with ORDER_FILLING_

			// FOK and IOC integer values are not the same for ORDER and SYMBOL



			if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_FOK))

				request.type_filling = ORDER_FILLING_FOK;

			else if (IsFillingTypeAllowed(symbol, SYMBOL_FILLING_IOC))

				request.type_filling = ORDER_FILLING_IOC;

			else if (IsFillingTypeAllowed(symbol, ORDER_FILLING_RETURN)) // just in case

				request.type_filling = ORDER_FILLING_RETURN;

			else

				request.type_filling = ORDER_FILLING_RETURN;

		}



		if (!OrderCheck(request,check_result))

		{

			Print("OrderCheck() failed: ", (string)check_result.comment, " (", (string)check_result.retcode, ")");



			return -1;

		}



		bool success = OrderSend(request, result);



		//-- check security flag ------------------------------------------

		if (successed == true)

		{

			Print("The program will be removed because of suspicious attempt to create a new position");

			ExpertRemove();

			Sleep(10000);



			break;

		}



		if (success) {successed = true;}



		//-- error check --------------------------------------------------

		if (

			   success == false

			|| (

				   result.retcode != TRADE_RETCODE_DONE

				&& result.retcode != TRADE_RETCODE_PLACED

				&& result.retcode != TRADE_RETCODE_DONE_PARTIAL

			)

		)

		{

			string errmsgpfx = (type > ORDER_TYPE_SELL) ? "New pending order error" : "New position error";



			int erraction = CheckForTradingError(result.retcode, errmsgpfx);



			switch (erraction)

			{

				case 0: break;    // no error

				case 1: continue; // overcomable error

				case 2: break;    // fatal error

			}



			return -1;

		}



		//-- finish work --------------------------------------------------

		if (

			   result.retcode == TRADE_RETCODE_DONE

			|| result.retcode == TRADE_RETCODE_PLACED

			|| result.retcode == TRADE_RETCODE_DONE_PARTIAL

		) {

			ticket = result.order;

			//== Whatever was created, we need to wait until MT5 updates it's cache



			//-- Synchronize: Position

			if (type <= ORDER_TYPE_SELL)

			{

				if (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING)

				{

					if (closing == false)

					{

						//- new position: 2 situations here - new position or add to position

						//- ... because of that we will check the lot size instead of PositionSelect

						while (true)

						{

							if (PositionSelect(symbol) && (lots0 != NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5))) {break;}

							Sleep(10);

						}

					}

					else

					{

						//- closing position: full

						if (lots0 == NormalizeDouble(result.volume, 5))

						{

							while (true)

							{

								if (!PositionSelect(symbol)) {break;}

								Sleep(10);

							}

						}

						//- closing position: partial

						else if (lots0 > NormalizeDouble(result.volume, 5))

						{

							while (true)

							{

								if (PositionSelect(symbol) && (lots0 != NormalizeDouble(PositionGetDouble(POSITION_VOLUME), 5))) {break;}

								Sleep(10);

							}

						}

						else if (lots0 < NormalizeDouble(result.volume, 5))

						{

						//-- position reverse

							while (true)

							{

								if (PositionSelect(symbol) && (type0 != PositionGetInteger(POSITION_TYPE))) {break;}

								Sleep(10);

							}

						}

					}

				}

				else if (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)

				{

					if (closing == false)

					{

						while (true)

						{

							if (PositionSelectByTicket(ticket)) {break;}

							Sleep(10);

						}

					}

				}

			}

			//-- Synchronize: Order

			else

			{

				while (true)

				{

					if (LoadPendingOrder(result.order)) {break;}

					Sleep(10);

				}

			}



			//-- fix arrow color (it works only in visual mode)

			// TODO: this piece of code slows down the backtest for some reason

			if (0 && MQLInfoInteger(MQL_VISUAL_MODE) && arrowcolor != CLR_NONE)

			{

				if (type <= ORDER_TYPE_SELL)

				{

					uint t0 = GetTickCount();

					ENUM_OBJECT objType = (type==POSITION_TYPE_BUY) ? OBJ_ARROW_BUY : OBJ_ARROW_SELL;



					// wait for the object to be created (MQL5 is async even here)

					while(true)

					{

						int total        = ObjectsTotal(0,0,objType);

						string name      = ObjectName(0,total-1,0,objType);

						datetime objTime = (datetime)ObjectGetInteger(0,name,OBJPROP_TIME);



						if (objTime > TimeCurrent()-1)

						{

							if (StringFind(name, "#" + IntegerToString(ticket) + " ") == 0)

							{

								ObjectSetInteger(0,name,OBJPROP_COLOR,arrowcolor);

							}



							break;

						}



						if (GetTickCount() - t0 > 1000) break;

					}

				}

				else

				{

					// Pending orders don't have arrows

				}

			}

		}



		if (ticket > 0)

		{

			if (USE_VIRTUAL_STOPS)

			{

				VirtualStopsDriver("set", ticket, vsl, vtp, toPips(MathAbs(op-vsl), symbol), toPips(MathAbs(vtp-op), symbol));

			}



			//-- show some info

			double slip = 0;



			if (LoadPosition(ticket))

			{

				if (placeExpirationObject)

				{

					expirationWorker.SetExpiration(ticket, expiration);

				}



				if (

					   !MQLInfoInteger(MQL_TESTER)

					&& !MQLInfoInteger(MQL_VISUAL_MODE)

					&& !MQLInfoInteger(MQL_OPTIMIZATION)

				) {

					slip = OrderOpenPrice() - op;



					Print(

						"Operation details: Speed ",

						(GetTickCount() - time0),

						" ms | Slippage ",

						DoubleToStr(toPips(slip, symbol), 1),

						" pips"

					);

				}

			}

			

			//-- fix stops in case of slippage

			if (

				   !MQLInfoInteger(MQL_TESTER)

				&& !MQLInfoInteger(MQL_VISUAL_MODE)

				&& !MQLInfoInteger(MQL_OPTIMIZATION)

			) {



				slip = NormalizeDouble(OrderOpenPrice(), digits) - NormalizeDouble(op, digits);



				if (slip != 0 && (OrderStopLoss() != 0 || OrderTakeProfit() != 0))

				{

					Print("Correcting stops because of slippage...");



					sl = OrderStopLoss();

					tp = OrderTakeProfit();



					if (sl != 0 || tp != 0)

					{

						if (sl != 0) {sl = NormalizeDouble(OrderStopLoss() + slip, digits);}

						if (tp != 0) {tp = NormalizeDouble(OrderTakeProfit() + slip, digits);}



						ModifyOrder(ticket, OrderOpenPrice(), sl, tp, 0, 0);

					}

				}

			}



			//RegisterEvent("trade");



			break;

		}



		break;

	}



	if (oco == true && ticket > 0)

	{

		if (USE_VIRTUAL_STOPS)

		{

			sl = vsl;

			tp = vtp;

		}



		sl = (sl > 0) ? NormalizeDouble(MathAbs(op-sl), digits) : 0;

		tp = (tp > 0) ? NormalizeDouble(MathAbs(op-tp), digits) : 0;

		

		int typeoco = type;



		if (typeoco == ORDER_TYPE_BUY_STOP)

		{

			typeoco = ORDER_TYPE_SELL_STOP;

			op = bid - MathAbs(op-ask);

		}

		else if (typeoco == ORDER_TYPE_BUY_LIMIT)

		{

			typeoco = ORDER_TYPE_SELL_LIMIT;

			op = bid + MathAbs(op-ask);

		}

		else if (typeoco == ORDER_TYPE_SELL_STOP)

		{

			typeoco = ORDER_TYPE_BUY_STOP;

			op = ask + MathAbs(op-bid);

		}

		else if (typeoco == ORDER_TYPE_SELL_LIMIT)

		{

			typeoco = ORDER_TYPE_BUY_LIMIT;

			op = ask - MathAbs(op-bid);

		}



		if (typeoco == ORDER_TYPE_BUY_STOP || typeoco == ORDER_TYPE_BUY_LIMIT)

		{

			sl = (sl > 0) ? op - sl : 0;

			tp = (tp > 0) ? op + tp : 0;

		}

		else {

			sl = (sl > 0) ? op + sl : 0;

			tp = (tp > 0) ? op - tp : 0;

		}



		comment = "[oco:" + (string)ticket + "]";



		OrderCreate(

			symbol,

			typeoco,

			lots,

			op,

			sl,

			tp,

			0,

			0,

			slippage,

			magic,

			comment,

			arrowcolor,

			expiration,

			false

		);

	}



	OnTrade();



	return (long)ticket;

}



datetime OrderExpiration()

{

	return OrderExpirationTime();

}



datetime OrderExpirationTime()

{

	int LoadedType = LoadedType();



	if (LoadedType == 1) return expirationWorker.GetExpiration(PositionGetInteger(POSITION_TICKET));

	if (LoadedType == 2) return (datetime)OrderGetInteger(ORDER_TIME_EXPIRATION);



	return 0;

}



double OrderLots()

{

	int type    = LoadedType();

	double lots = 0;



	if (type == 1) {

		lots = PositionGetDouble(POSITION_VOLUME);

	}

	else if (type == 3) {

		// Calculate lots as the difference between the intial lots

		// and the lots of all 



		long positionId = HistoryDealGetInteger(OrderTicket(), DEAL_POSITION_ID);



		HistorySelectByPosition(positionId);



		int total = HistoryDealsTotal();



		lots = 0.0;



		for (int i = 0; i < total; i++) {

			ulong ticket = HistoryDealGetTicket(i);

			ENUM_DEAL_ENTRY entry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY);

			double dealVolume = HistoryDealGetDouble(ticket, DEAL_VOLUME);



			if (entry == DEAL_ENTRY_IN) {

				lots += dealVolume;

			}

			else {

				// If the last deal is the final close, it's size would be the same as the

				// calculated lots. In this case, skip, otherwise the final lots will be 0.

				if (NormalizeDouble(dealVolume, 4) < NormalizeDouble(lots, 4)) {

					lots -= dealVolume;

				}

			}

		}



		HistoryTradesTotalReset();

	}

	else if (type == 4) {lots = HistoryOrderGetDouble(OrderTicket(),ORDER_VOLUME_INITIAL);}

	else                {lots = OrderGetDouble(ORDER_VOLUME_CURRENT);}



	return NormalizeDouble(lots, 2);

}



int OrderMagicNumber()

{

	int type = LoadedType();



	if (type == 1) {return (int)PositionGetInteger(POSITION_MAGIC);}

	if (type == 3) {return (int)HistoryOrderGetInteger(HistoryDealGetInteger(OrderTicket(),DEAL_POSITION_ID),ORDER_MAGIC);}

	if (type == 4) {return (int)HistoryOrderGetInteger(OrderTicket(),ORDER_MAGIC);}



	return (int)OrderGetInteger(ORDER_MAGIC);

}



bool OrderModified(ulong ticket = 0, string action = "set")

{

	static ulong memory[];



	if (ticket == 0)

	{

		ticket = OrderTicket();

		action = "get";

	}

	else if (ticket > 0 && action != "clear")

	{

		action = "set";

	}



	bool modified_status = InArray(memory, ticket);

	

	if (action == "get")

	{

		return modified_status;

	}

	else if (action == "set")

	{

		ArrayEnsureValue(memory, ticket);



		return true;

	}

	else if (action == "clear")

	{

		ArrayStripValue(memory, ticket);



		return true;

	}



	return false;

}



double OrderOpenPrice()

{

	double op  = 0.0;

	int type   = LoadedType();

	int digits = (int)SymbolInfoInteger(OrderSymbol(), SYMBOL_DIGITS);



	if (type == 1)

	{

		op = PositionGetDouble(POSITION_PRICE_OPEN);

	}

	else if (type == 3)

	{

		// Get the value from the very first deal in the position



		ulong positionId = HistoryDealGetInteger(OrderTicket(), DEAL_POSITION_ID);



		HistorySelectByPosition(positionId);



		ulong ticket = HistoryDealGetTicket(0);



		op = HistoryDealGetDouble(ticket, DEAL_PRICE);



		HistoryTradesTotalReset();

	}

	else if (type == 4)

	{

		op = HistoryOrderGetDouble(OrderTicket(), ORDER_PRICE_OPEN);

	}

   else

   {

   	op = OrderGetDouble(ORDER_PRICE_OPEN);

   }



	return NormalizeDouble(op, digits);

}



datetime OrderOpenTime()

{

	datetime time = 0;

	int type      = LoadedType();



	if (type == 1)

	{

		time = (datetime)PositionGetInteger(POSITION_TIME);

	}

	else if (type == 3)

	{

		// Get the value from the very first deal in the position



		ulong positionId = HistoryDealGetInteger(OrderTicket(), DEAL_POSITION_ID);



		HistorySelectByPosition(positionId);



		ulong ticket = HistoryDealGetTicket(0);

		

		time = (datetime)HistoryDealGetInteger(ticket, DEAL_TIME);

		

		HistoryTradesTotalReset();

	}

	else if (type == 4)

	{

		time = (datetime)HistoryOrderGetInteger(OrderTicket(), ORDER_TIME_SETUP);

	}

	else

	{

		time = (datetime)OrderGetInteger(ORDER_TIME_SETUP);

	}

	

	return time;

}



double OrderStopLoss()

{

	int type = LoadedType();



	if (type == 1) {return PositionGetDouble(POSITION_SL);}

	if (type == 3) {return HistoryDealGetDouble(OrderTicket(), DEAL_SL);}

	if (type == 4) {return HistoryOrderGetDouble(OrderTicket(), ORDER_SL);}



	return OrderGetDouble(ORDER_SL);

}



string OrderSymbol()

{

	int type = LoadedType();



	if (type == 1) {return PositionGetString(POSITION_SYMBOL);}

	if (type == 3) {return HistoryDealGetString(OrderTicket(),DEAL_SYMBOL);}

	if (type == 4) {return HistoryOrderGetString(OrderTicket(),ORDER_SYMBOL);}



	return OrderGetString(ORDER_SYMBOL);

}



double OrderTakeProfit()

{

	int type = LoadedType();



	if (type == 1) {return PositionGetDouble(POSITION_TP);}

	if (type == 3) {return HistoryDealGetDouble(OrderTicket(), DEAL_TP);}

	if (type == 4) {return HistoryOrderGetDouble(OrderTicket(),ORDER_TP);}



	return OrderGetDouble(ORDER_TP);

}



long OrderTicket(long ticket = 0)

{

	static long memory = 0;



	if (ticket > 0) {memory = ticket;}



	return memory;

}



int OrderType()

{

	int type = LoadedType();



	if (type == 1) {return (int)PositionGetInteger(POSITION_TYPE);}

	if (type == 2) {return (int)OrderGetInteger(ORDER_TYPE);}

	if (type == 3)

	{

		ulong dealTicket = OrderTicket();

		long positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);



		HistorySelectByPosition(positionId);



		ulong firstDealTicket = HistoryDealGetTicket(0);

		

		int orderType = (int)HistoryDealGetInteger(firstDealTicket, DEAL_TYPE);



		HistoryTradesTotalReset();



		return orderType;

	}

	if (type == 4) {return (int)HistoryOrderGetInteger(OrderTicket(),ORDER_TYPE);}



	return (int)OrderGetInteger(ORDER_TYPE);

}



bool PendingOrderSelectByIndex(

	int index,

	string group_mode    = "all",

	string group         = "0",

	string market_mode   = "all",

	string market        = "",

	string BuysOrSells   = "both",

	string LimitsOrStops = "both"

)

{

	if (LoadPendingOrder(OrderGetTicket(index)))

	{

		if (FilterOrderBy(

			group_mode,

			group,

			market_mode,

			market,

			BuysOrSells,

			LimitsOrStops,

			1)

		) {

			return true;

		}

	}



	return false;

}



bool PendingOrderSelectByTicket(ulong ticket)

{

	bool success = OrderSelect(ticket);



	if (success) {

		LoadedType(2);

		OrderTicket(ticket);

	}



	return success;

}



double PipValue(string symbol)

{

	if (symbol == "") symbol = Symbol();



	return CustomPoint(symbol) / SymbolInfoDouble(symbol, SYMBOL_POINT);

}



bool PositionSelectByDeal(ulong dealTicket)

{

	bool success = false;

	long positionId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);

	

	if (positionId)

	{

		int total = PositionsTotal();

		

		for (int i = total - 1; i >= 0; i--)

		{

			if (PositionGetTicket(i))

			{

				if (PositionGetInteger(POSITION_IDENTIFIER) == positionId)

				{

					success = true;



					break;

				}

			}

		}

	}



	return success;

}



int SecondsFromComponents(double days, double hours, double minutes, int seconds)

{

	int retval =

		86400 * (int)MathFloor(days)

		+ 3600 * (int)(MathFloor(hours) + (24 * (days - MathFloor(days))))

		+ 60 * (int)(MathFloor(minutes) + (60 * (hours - MathFloor(hours))))

		+ (int)((double)seconds + (60 * (minutes - MathFloor(minutes))));



	return retval;

}



datetime SelectedHistoryFromTime(datetime setTime = -1)

{

	static datetime time;

	

	if (setTime > -1)

	{

		time = setTime;

	}

	

	return time;

}



datetime SelectedHistoryToTime(datetime setTime = -1)

{

	static datetime time;

	

	if (setTime > -1)

	{

		time = setTime;

	}

	

	return time;

}



long SellLater(

	string symbol,

	double lots,

	double price,

	double sll = 0, // SL level

	double tpl = 0, // TP level

	double slp = 0, // SL adjust in points

	double tpp = 0, // TP adjust in points

	double slippage = 0,

	datetime expiration = 0,

	int magic = 0,

	string comment = "",

	color arrowcolor = clrNONE,

	bool oco = false

	)

{

	double bid = SymbolInfoDouble(symbol,SYMBOL_BID);

	ENUM_ORDER_TYPE type = 0;



	     if (price == bid) {type = ORDER_TYPE_SELL;}

	else if (price < bid)  {type = ORDER_TYPE_SELL_STOP;}

	else if (price > bid)  {type = ORDER_TYPE_SELL_LIMIT;}



	return OrderCreate(

		symbol,

		type,

		lots,

		price,

		sll,

		tpl,

		slp,

		tpp,

		slippage,

		magic,

		comment,

		arrowcolor,

		expiration,

		oco

	);

}



long SellNow(

	string symbol,

	double lots,

	double sll,

	double tpl,

	double slp,

	double tpp,

	double slippage = 0,

	int magic = 0,

	string comment = "",

	color arrowcolor = clrNONE,

	datetime expiration = 0

	)

{

	return OrderCreate(

		symbol,

		POSITION_TYPE_SELL,

		lots,

		0,

		sll,

		tpl,

		slp,

		tpp,

		slippage,

		magic,

		comment,

		arrowcolor,

		expiration

	);

}



int StrToInteger(string value)

{

	return (int)StringToInteger(value);

}



template<typename T>

void StringExplode(string delimiter, string inputString, T &output[])

{

	int begin   = 0;

	int end     = 0;

	int element = 0;

	int length  = StringLen(inputString);

	int length_delimiter = StringLen(delimiter);

	T empty_val  = (typename(T) == "string") ? (T)"" : (T)0;



	if (length > 0)

	{

		while (true)

		{

			end = StringFind(inputString, delimiter, begin);



			ArrayResize(output, element + 1);

			output[element] = empty_val;

	

			if (end != -1)

			{

				if (end > begin)

				{

					output[element] = (T)StringSubstr(inputString, begin, end - begin);

				}

			}

			else

			{

				output[element] = (T)StringSubstr(inputString, begin, length - begin);

				break;

			}

			

			begin = end + 1 + (length_delimiter - 1);

			element++;

		}

	}

	else

	{

		ArrayResize(output, 1);

		output[element] = empty_val;

	}

}



template<typename T>

string StringImplode(string delimeter, T &array[])

{

   string retval = "";

	int size      = ArraySize(array);



   for (int i = 0; i < size; i++)

	{

      StringConcatenate(retval, retval, (string)array[i], delimeter);

   }



   return StringSubstr(retval, 0, (StringLen(retval) - StringLen(delimeter)));

}



datetime StringToTimeEx(string str, string mode="server")

{

	// mode: server, local, gmt

	int offset = 0;



	if (mode == "server") {offset = 0;}

	else if (mode == "local") {offset = (int)(TimeLocal() - TimeCurrent());}

	else if (mode == "gmt") {offset = (int)(TimeGMT() - TimeCurrent());}



	datetime time = StringToTime(str) - offset;



	return time;

}



string StringTrim(string text)

{

	StringTrimRight(text);

	StringTrimLeft(text);



	return text;

}



double SymbolAsk(string symbol)

{

	if (symbol == "") symbol = Symbol();



	return SymbolInfoDouble(symbol, SYMBOL_ASK);

}



double SymbolBid(string symbol)

{

	if (symbol == "") symbol = Symbol();



	return SymbolInfoDouble(symbol, SYMBOL_BID);

}



int SymbolDigits(string symbol)

{

	if (symbol == "") symbol = Symbol();



	return (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

}



double SymbolLotSize(string symbol)

{

	if (symbol == "") symbol = Symbol();



	return SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);

}



double SymbolLotStep(string symbol)

{

	if (symbol == "") symbol = Symbol();



	return SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);

}



double SymbolMaxLot(string symbol)

{

	if (symbol == "") symbol = Symbol();



	return SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);

}



double SymbolMinLot(string symbol)

{

	if (symbol == "") symbol = Symbol();



	return SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);

}



double TicksData(string symbol = "", int type = 0, int shift = 0)

{

	static bool collecting_ticks = false;

	static string symbols[];

	static int zero_sid[];

	static double memoryASK[][100];

	static double memoryBID[][100];



	int sid = 0, size = 0, i = 0, id = 0;

	double ask = 0, bid = 0, retval = 0;

	bool exists = false;



	if (ArraySize(symbols) == 0)

	{

		ArrayResize(symbols, 1);

		ArrayResize(zero_sid, 1);

		ArrayResize(memoryASK, 1);

		ArrayResize(memoryBID, 1);



		symbols[0] = _Symbol;

	}



	if (type > 0 && shift > 0)

	{

		collecting_ticks = true;

	}



	if (collecting_ticks == false)

	{

		if (type > 0 && shift == 0)

		{

			// going to get ticks

		}

		else

		{

			return 0;

		}

	}



	if (symbol == "") symbol = _Symbol;



	if (type == 0)

	{

		exists = false;

		size   = ArraySize(symbols);



		if (size == 0) {ArrayResize(symbols, 1);}



		for (i=0; i<size; i++)

		{

			if (symbols[i] == symbol)

			{

				exists = true;

				sid    = i;

				break;

			}

		}



		if (exists == false)

		{

			int newsize = ArraySize(symbols) + 1;



			ArrayResize(symbols, newsize);

			symbols[newsize-1] = symbol;



			ArrayResize(zero_sid, newsize);

			ArrayResize(memoryASK, newsize);

			ArrayResize(memoryBID, newsize);



			sid=newsize;

		}



		if (sid >= 0)

		{

			ask = SymbolInfoDouble(symbol, SYMBOL_ASK);

			bid = SymbolInfoDouble(symbol, SYMBOL_BID);



			if (bid == 0 && MQLInfoInteger(MQL_TESTER))

			{

				Print("Ticks data collector error: " + symbol + " cannot be backtested. Only the current symbol can be backtested. The EA will be terminated.");

				ExpertRemove();

			}



			if (

				   symbol == _Symbol

				|| ask != memoryASK[sid][0]

				|| bid != memoryBID[sid][0]

			)

			{

				memoryASK[sid][zero_sid[sid]] = ask;

				memoryBID[sid][zero_sid[sid]] = bid;

				zero_sid[sid]                 = zero_sid[sid] + 1;



				if (zero_sid[sid] == 100)

				{

					zero_sid[sid] = 0;

				}

			}

		}

	}

	else

	{

		if (shift <= 0)

		{

			if (type == SYMBOL_ASK)

			{

				return SymbolInfoDouble(symbol, SYMBOL_ASK);

			}

			else if (type == SYMBOL_BID)

			{

				return SymbolInfoDouble(symbol, SYMBOL_BID); 

			}

			else

			{

				double mid = ((SymbolInfoDouble(symbol, SYMBOL_ASK) + SymbolInfoDouble(symbol, SYMBOL_BID)) / 2);



				return mid;

			}

		}

		else

		{

			size = ArraySize(symbols);



			for (i = 0; i < size; i++)

			{

				if (symbols[i] == symbol)

				{

					sid = i;

				}

			}



			if (shift < 100)

			{

				id = zero_sid[sid] - shift - 1;



				if(id < 0) {id = id + 100;}



				if (type == SYMBOL_ASK)

				{

					retval = memoryASK[sid][id];



					if (retval == 0)

					{

						retval = SymbolInfoDouble(symbol, SYMBOL_ASK);

					}

				}

				else if (type == SYMBOL_BID)

				{

					retval = memoryBID[sid][id];



					if (retval == 0)

					{

						retval = SymbolInfoDouble(symbol, SYMBOL_BID);

					}

				}

			}

		}

	}



	return retval;

}



int TicksPerSecond(bool get_max = false, bool set = false)

{

	static datetime time0 = 0;

	static int ticks      = 0;

	static int tps        = 0;

	static int tpsmax     = 0;



	datetime time1 = TimeLocal();



	if (set == true)

	{

		if (time1 > time0)

		{

			if (time1 - time0 > 1)

			{

				tps = 0;

			}

			else

			{

				tps = ticks;

			}



			time0 = time1;

			ticks = 0;

		}



		ticks++;



		if (tps > tpsmax) {tpsmax = tps;}

	}



	if (get_max)

	{

		return tpsmax;

	}



	return tps;

}



datetime TimeAtStart(string cmd = "server")

{

	static datetime local  = 0;

	static datetime server = 0;



	if (cmd == "local")

	{

		return local;

	}

	else if (cmd == "server")

	{

		return server;

	}

	else if (cmd == "set")

	{

		local  = TimeLocal();

		server = TimeCurrent();

	}



	return 0;

}



int TimeDay(datetime time)

{

	MqlDateTime tm;

   TimeToStruct(time,tm);

   return(tm.day);

}



int TimeDayOfWeek(datetime time)

{

   MqlDateTime tm;

   TimeToStruct(time,tm);

   return(tm.day_of_week);

}



datetime TimeFromComponents(

	int time_src = 0,

	int    y = 0,

	int    m = 0,

	double d = 0,

	double h = 0,

	double i = 0,

	int    s = 0

) {

	MqlDateTime tm;

	int offset = 0;



	if (time_src == 0) {

		TimeCurrent(tm);

	}

	else if (time_src == 1) {

		TimeLocal(tm); 

		offset = (int)(TimeLocal() - TimeCurrent());

	}

	else if (time_src == 2) {

		TimeGMT(tm);

		offset = (int)(TimeGMT() - TimeCurrent());

	}



	if (y > 0)

	{

		if (y < 100) {y = 2000 + y;}

		tm.year = y;

	}

	if (m > 0) {tm.mon = m;}

	if (d > 0) {tm.day = (int)MathFloor(d);}



	tm.hour = (int)(MathFloor(h) + (24 * (d - MathFloor(d))));

	tm.min  = (int)(MathFloor(i) + (60 * (h - MathFloor(h))));

	tm.sec  = (int)((double)s + (60 * (i - MathFloor(i))));

	

	datetime time = StructToTime(tm) - offset;



	return time;

}



datetime TimeFromString(int mode_time, string stamp)

{

	datetime t = 0;



	     if (mode_time == 0) t = TimeCurrent();

	else if (mode_time == 1) t = TimeLocal();

	else if (mode_time == 2) t = TimeGMT();



	int stamplen = StringLen(stamp);



	if (stamplen < 9)

	{

		int thour    = TimeHour(t);

		int tminute  = TimeMinute(t);

		int tseconds = TimeSeconds(t);



		int hour   = (int)StringSubstr(stamp, 0, 2);

		int minute = (int)StringSubstr(stamp, 3, 2);

		int second = 0;



		if (stamplen > 5)

		{

			second = (int)StringSubstr(stamp, 6, 2);

		}



		datetime t1 = (datetime)(t - (thour-hour)*3600 - (tminute - minute)*60 - (tseconds-second));



		return t1;

	}



	return StringToTime(stamp);

}



int TimeHour(datetime time)

{

	MqlDateTime tm;

	TimeToStruct(time,tm);



	return tm.hour;

}



int TimeMinute(datetime time)

{

	MqlDateTime tm;

	TimeToStruct(time,tm);

	

	return tm.min;

}



int TimeMonth(datetime time)

{

	MqlDateTime tm;

	TimeToStruct(time,tm);



	return tm.mon;

}



int TimeSeconds(datetime time)

{

	MqlDateTime tm;

	TimeToStruct(time,tm);



	return tm.sec;

}



int TimeYear(datetime time)

{

   MqlDateTime tm;

	TimeToStruct(time,tm);



	return tm.year;

}



bool TradeSelectByIndex(

	int index,

	string group_mode    = "all",

	string group         = "0",

	string market_mode   = "all",

	string market        = "",

	string BuysOrSells   = "both"

) {

	if (LoadPosition(PositionGetTicket(index)))

	{

		if (FilterOrderBy(

			group_mode,

			group,

			market_mode,

			market,

			BuysOrSells)

			)

		{

			return true;

		}

	}



	return false;

}



bool TradeSelectByTicket(ulong ticket)

{

	if (LoadPosition(ticket) && OrderType() < 2)

	{

		return true;

	}



	return false;

}



int TradesTotal()

{

	return PositionsTotal();

}



double VirtualStopsDriver(

	string command = "",

	ulong ti       = 0,

	double sl      = 0,

	double tp      = 0,

	double slp     = 0,

	double tpp     = 0

)

{

	static bool initialized     = false;

	static string name          = "";

	static string loop_name[2]  = {"sl", "tp"};

	static color  loop_color[2] = {DeepPink, DodgerBlue};

	static double loop_price[2] = {0, 0};

	static ulong mem_to_ti[]; // tickets

	static int mem_to[];      // timeouts

	static bool trade_pass = false;

	int i = 0;



	// Are Virtual Stops even enabled?

	if (!USE_VIRTUAL_STOPS)

	{

		return 0;

	}

	

	if (initialized == false || command == "initialize")

	{

		initialized = true;

	}



	// Listen

	if (command == "" || command == "listen")

	{

		int total     = ObjectsTotal(0, -1, OBJ_HLINE);

		int length    = 0;

		color clr     = clrNONE;

		int sltp      = 0;

		ulong ticket  = 0;

		double level  = 0;

		double askbid = 0;

		int polarity  = 0;

		string symbol = "";



		for (i = total - 1; i >= 0; i--)

		{

			name = ObjectName(0, i, -1, OBJ_HLINE); // for example: #1 sl



			if (StringSubstr(name, 0, 1) != "#")

			{

				continue;

			}



			length = StringLen(name);



			if (length < 5)

			{

				continue;

			}



			clr = (color)ObjectGetInteger(0, name, OBJPROP_COLOR);



			if (clr != loop_color[0] && clr != loop_color[1])

			{

				continue;

			}



			string last_symbols = StringSubstr(name, length-2, 2);



			if (last_symbols == "sl")

			{

				sltp = -1;

			}

			else if (last_symbols == "tp")

			{

				sltp = 1;

			}

			else

			{

				continue;	

			}



			ulong ticket0 = StringToInteger(StringSubstr(name, 1, length - 4));



			// prevent loading the same ticket number twice in a row

			if (ticket0 != ticket)

			{

				ticket = ticket0;



				if (TradeSelectByTicket(ticket))

				{

					symbol     = OrderSymbol();

					polarity   = (OrderType() == 0) ? 1 : -1;

					askbid   = (OrderType() == 0) ? SymbolInfoDouble(symbol, SYMBOL_BID) : SymbolInfoDouble(symbol, SYMBOL_ASK);

					

					trade_pass = true;

				}

				else

				{

					trade_pass = false;

				}

			}



			if (trade_pass)

			{

				level    = ObjectGetDouble(0, name, OBJPROP_PRICE, 0);



				if (level > 0)

				{

					// polarize levels

					double level_p  = polarity * level;

					double askbid_p = polarity * askbid;



					if (

						   (sltp == -1 && (level_p - askbid_p) >= 0) // sl

						|| (sltp == 1 && (askbid_p - level_p) >= 0)  // tp

					)

					{

						//-- Virtual Stops SL Timeout

						if (

							   (VIRTUAL_STOPS_TIMEOUT > 0)

							&& (sltp == -1 && (level_p - askbid_p) >= 0) // sl

						)

						{

							// start timeout?

							int index = ArraySearch(mem_to_ti, ticket);



							if (index < 0)

							{

								int size = ArraySize(mem_to_ti);

								ArrayResize(mem_to_ti, size+1);

								ArrayResize(mem_to, size+1);

								mem_to_ti[size] = ticket;

								mem_to[size]    = (int)TimeLocal();



								Print(

									"#",

									ticket,

									" timeout of ",

									VIRTUAL_STOPS_TIMEOUT,

									" seconds started"

								);



								return 0;

							}

							else

							{

								if (TimeLocal() - mem_to[index] <= VIRTUAL_STOPS_TIMEOUT)

								{

									return 0;

								}

							}

						}



						if (CloseTrade(ticket))

						{

							// check this before deleting the lines

							//OnTradeListener();



							// delete objects

							ObjectDelete(0, "#" + (string)ticket + " sl");

							ObjectDelete(0, "#" + (string)ticket + " tp");

						}

					}

					else

					{

						if (VIRTUAL_STOPS_TIMEOUT > 0)

						{

							i = ArraySearch(mem_to_ti, ticket);



							if (i >= 0)

							{

								ArrayStripKey(mem_to_ti, i);

								ArrayStripKey(mem_to, i);

							}

						}

					}

				}

			}

			else if (

					!PendingOrderSelectByTicket(ticket)

				|| OrderCloseTime() > 0 // in case the order has been closed

			)

			{

				ObjectDelete(0, name);

			}

			else

			{

				PendingOrderSelectByTicket(ticket);

			}

		}

	}

	// Get SL or TP

	else if (

		ti > 0

		&& (

			   command == "get sl"

			|| command == "get tp"

		)

	)

	{

		double value = 0;



		name = "#" + IntegerToString(ti) + " " + StringSubstr(command, 4, 2);



		if (ObjectFind(0, name) > -1)

		{

			value = ObjectGetDouble(0, name, OBJPROP_PRICE, 0);

		}



		return value;

	}

	// Set SL and TP

	else if (

		ti > 0

		&& (

			   command == "set"

			|| command == "modify"

			|| command == "clear"

			|| command == "partial"

		)

	)

	{

		loop_price[0] = sl;

		loop_price[1] = tp;



		for (i = 0; i < 2; i++)

		{

			name = "#" + IntegerToString(ti) + " " + loop_name[i];

			

			if (loop_price[i] > 0)

			{

				// 1) create a new line

				if (ObjectFind(0, name) == -1)

				{

						 ObjectCreate(0, name, OBJ_HLINE, 0, 0, loop_price[i]);

					ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);

					ObjectSetInteger(0, name, OBJPROP_COLOR, loop_color[i]);

					ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DOT);

					ObjectSetString(0, name, OBJPROP_TEXT, name + " (virtual)");

				}

				// 2) modify existing line

				else

				{

					ObjectSetDouble(0, name, OBJPROP_PRICE, 0, loop_price[i]);

				}

			}

			else

			{

				// 3) delete existing line

				ObjectDelete(0, name);

			}

		}



		// print message

		if (command == "set" || command == "modify")

		{

			Print(

				command,

				" #",

				IntegerToString(ti),

				": virtual sl ",

				DoubleToStr(sl, (int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS)),

				" tp ",

				DoubleToStr(tp,(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS))

			);

		}



		return 1;

	}



	return 1;

}



int WindowFindVisible(long chart_id, string term)

{

   //-- the search term can be chart name, such as Force(13), or subwindow index

   if (term == "" || term == "0") {return 0;}

   

   int subwindow = (int)StringToInteger(term);

   

   if (subwindow == 0 && StringLen(term) > 1)

   {

      subwindow = ChartWindowFind(chart_id, term);

   }

   

   if (subwindow > 0 && !ChartGetInteger(chart_id, CHART_WINDOW_IS_VISIBLE, subwindow))

   {

      return -1;  

   }

   

   return subwindow;

}



double ask(string symbol = NULL)

{

	return SymbolInfoDouble(symbol, SYMBOL_ASK);

}



double attrStopLoss()

{

	if (USE_VIRTUAL_STOPS)

	{

		return VirtualStopsDriver("get sl", OrderTicket());

	}



	return OrderStopLoss();

}



double attrTakeProfit()

{

	if (USE_VIRTUAL_STOPS)

	{

		return VirtualStopsDriver("get tp", OrderTicket());

	}



   return OrderTakeProfit();

}



/**

* Get the parent position ticket when the current position

* was created as "add to volume" child.

* In other cases, return the input ticket.

*/

long attrTicketParent(long ticket)

{

	long parentTicket = 0;



	if (PositionSelectByTicket(ticket)) {

		string comment = PositionGetString(POSITION_COMMENT);

		int tagPos     = StringFind(comment, "[p=");

		

		if (tagPos >= 0) {

			string tag   = StringSubstr(comment, tagPos);

			tag          = StringSubstr(tag, 0, StringFind(tag, "]") + 1);

			parentTicket = StringToInteger(StringSubstr(tag, 3, -1));

		}

	}



	if (parentTicket == 0) {

		parentTicket = ticket;

	}



	return parentTicket;

}



string e_Reason() {return onTradeEventDetector.EventValueReason();}



string e_ReasonDetail() {return onTradeEventDetector.EventValueDetail();}



double e_attrClosePrice() {return onTradeEventDetector.EventValuePriceClose();}



datetime e_attrCloseTime() {return onTradeEventDetector.EventValueTimeClose();}



string e_attrComment() {return onTradeEventDetector.EventValueComment();}



datetime e_attrExpiration() {return onTradeEventDetector.EventValueTimeExpiration();}



double e_attrLots() {return onTradeEventDetector.EventValueVolume();}



long e_attrMagicNumber() {return onTradeEventDetector.EventValueMagic();}



double e_attrOpenPrice() {return onTradeEventDetector.EventValuePriceOpen();}



datetime e_attrOpenTime() {return onTradeEventDetector.EventValueTimeOpen();}



double e_attrProfit() {return onTradeEventDetector.EventValueProfit();}



double e_attrStopLoss() {return onTradeEventDetector.EventValueStopLoss();}



double e_attrSwap() {return onTradeEventDetector.EventValueSwap();}



string e_attrSymbol() {return onTradeEventDetector.EventValueSymbol();}



double e_attrTakeProfit() {return onTradeEventDetector.EventValueTakeProfit();}



long e_attrTicket() {return onTradeEventDetector.EventValueTicket();}



int e_attrType() {return onTradeEventDetector.EventValueType();}



template<typename DT1, typename DT2>

double formula(string sign, DT1 v1, DT2 v2)

{

	     if (sign == "+") return(v1 + v2);

	else if (sign == "-") return(v1 - v2);

	else if (sign == "*") return(v1 * v2);

	else if (sign == "/") return(v1 / v2);



	return false;

}



string formula(string sign, string v1, string v2)

{

	if (sign == "+") return(v1 + v2);

	else {

		double _v1 = StringToDouble(v1);

		double _v2 = StringToDouble(v2);

		

		     if (sign == "-") return DoubleToString(_v1 - _v2);

		else if (sign == "*") return DoubleToString(_v1 * _v2);

		else if (sign == "/") return DoubleToString(_v1 / _v2);

	}



	return v1 + v2;

}



double formula(string sign, string v1, double v2)

{

	     if (sign == "+") return StringToDouble(v1) + v2;

	else if (sign == "-") return StringToDouble(v1) - v2;

	else if (sign == "*") return StringToDouble(v1) * v2;

	else if (sign == "/") return StringToDouble(v1) / v2;



	return StringToDouble(v1) + v2;

}



double formula(string sign, double v1, string v2)

{

	if (sign == "+") return (v1 + StringToDouble(v2));

	else if (sign == "-") return v1 - StringToDouble(v2);

	else if (sign == "*") return v1 * StringToDouble(v2);

	else if (sign == "/") return v1 / StringToDouble(v2);



	return v1 + StringToDouble(v2);

}



double fxdCustomIndicator(int handle, int mode=0, int shift=0)

{

	static double buffer[1];



	if (handle < 0)

	{

		Print("Error: Indicator not handled. (handle=",handle," | error code=",GetLastError(),")");

		return 0;

	}



	int tryouts = 0;



	while (true)

	{

		if (BarsCalculated(handle) > 0) break;

		else

		{

			tryouts++;



			if (MQLInfoInteger(MQL_TESTER))

			{

				Sleep(10);

			}

			else

			{

				if (tryouts > 100)

				{

					Print("Error: Custom indicator could not load (handle=",handle," | error code=",GetLastError(),")");



					break;

				}



				Sleep(50);

			}

		}

	}



	int success = CopyBuffer(handle,mode,shift,1,buffer);



	if (success < 0)

	{

		Print("Error: Cannot get value from a custom indicator. (handle=",handle," | error code=",GetLastError(),")");

		return 0;

	}



	//ArraySetAsSeries(buffer,true);



	return buffer[0];

}



int iCandleID(string SYMBOL, ENUM_TIMEFRAMES TIMEFRAME, datetime time_stamp)

{

	bool TimeStampPrevDayShift = true;

	int CandleID               = 0;



	// get the time resolution of the desired period, in minutes

	int mins_tf  = TIMEFRAME;

	int mins_tf0 = 0;



	if (TIMEFRAME == PERIOD_CURRENT)

	{

		mins_tf = (int)PeriodSeconds(PERIOD_CURRENT) / 60;

	}



	// get the difference between now and the time we want, in minutes

	int days_adjust = 0;



	if (TimeStampPrevDayShift)

	{

		// automatically shift to the previous day

		if (time_stamp > TimeCurrent())

		{

			time_stamp = time_stamp - 86400;

		}



		// also shift weekdays

		while (true)

		{

			int dow = TimeDayOfWeek(time_stamp);



			if (dow > 0 && dow < 6) {break;}



			time_stamp = time_stamp - 86400;

			days_adjust++;

		}

	}



	int mins_diff = (int)(TimeCurrent() - time_stamp);

	mins_diff = mins_diff - days_adjust*86400;

	mins_diff = mins_diff / 60;



	// the difference is negative => quit here

	if (mins_diff < 0)

	{

		return (int)EMPTY_VALUE;

	}



	// now calculate the candle ID, it is relative to the current time

	if (mins_diff > 0)

	{

		CandleID = (int)MathCeil((double)mins_diff/(double)mins_tf);

	}



	// now, after all the shifting and in case of missing candles, the calculated candle id can be few candles early

	// so we will search for the right candle

	while(true)

	{

		if (iTime(SYMBOL, TIMEFRAME, CandleID) >= time_stamp) {break;}



		CandleID--;



		if (CandleID <= 0) {CandleID = 0; break;}

	}



	return CandleID;

}



double iFractals( 

	string             symbol,

	ENUM_TIMEFRAMES    timeframe,

	int                mode,

	int                shift

)

{

	mode--; // upper/lower in MQL4 is 1/2, but in MQL5 it's 0/1



	int handle = iFractals(symbol, timeframe);

	double val = fxdCustomIndicator(handle, mode, shift);



	return NormalizeDouble(val, 10);

}



double iMA( 

	string             symbol,

	ENUM_TIMEFRAMES    timeframe,

	int                ma_period,

	int                ma_shift,

	ENUM_MA_METHOD     ma_method,

	ENUM_APPLIED_PRICE applied_price,

	int                shift

)

{

	int handle = iMA(symbol, timeframe, ma_period, ma_shift, ma_method, applied_price);

	double val = fxdCustomIndicator(handle, 0, shift);



	return NormalizeDouble(val, 10);

}



double iSAR( 

	string             symbol,

	ENUM_TIMEFRAMES    timeframe,

	double             step,

	double             maximum,

	int                shift

)

{

	int handle = iSAR(symbol, timeframe, step, maximum);

	double val = fxdCustomIndicator(handle, 0, shift);



	return NormalizeDouble(val, 10);

}



double toDigits(double pips, string symbol)

{

	if (symbol == "") symbol = Symbol();



	int digits   = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);

	double point = SymbolInfoDouble(symbol, SYMBOL_POINT);



	return NormalizeDouble(pips * PipValue(symbol) * point, digits);

}



double toPips(double digits, string symbol)

{

	if (symbol == "") symbol = Symbol();



   return digits / (PipValue(symbol) * SymbolInfoDouble(symbol, SYMBOL_POINT));

}













class FxdWaiting

{

	private:

		int beginning_id;

		ushort bank  [][2][20]; // 2 banks, 20 possible parallel waiting blocks per chain of blocks

		ushort state [][2];     // second dimention values: 0 - count of the blocks put on hold, 1 - current bank id



	public:

		void Initialize(int count)

		{

			ArrayResize(bank, count);

			ArrayResize(state, count);

		}



		bool Run(int id = 0)

		{

			beginning_id = id;



			int range = ArrayRange(state, 0);

			if (range < id+1) {

				ArrayResize(bank, id+1);

				ArrayResize(state, id+1);



				// set values to 0, otherwise they have random values

				for (int ii = range; ii < id+1; ii++)

				{

				   state[ii][0] = 0;

				   state[ii][1] = 0;

				}

			}



			// are there blocks put on hold?

			int count = state[id][0];

			int bank_id = state[id][1];



			// if no block are put on hold -> escape

			if (count == 0) {return false;}

			else

			{

				state[id][0] = 0; // null the count

				state[id][1] = (bank_id) ? 0 : 1; // switch to the other bank

			}



			//== now we will run the blocks put on hold



			for (int i = 0; i < count; i++)

			{

				int block_to_run = bank[id][bank_id][i];

				_blocks_[block_to_run].run();

			}



			return true;

		}



		void Accumulate(int block_id = 0)

		{

			int count   = ++state[beginning_id][0];

			int bank_id = state[beginning_id][1];



			bank[beginning_id][bank_id][count-1] = (ushort)block_id;

		}

};

FxdWaiting fxdWait;







//+------------------------------------------------------------------+

//| END                                                              |

//| Created with fxDreema EA Builder           https://fxdreema.com/ |

//+------------------------------------------------------------------+



/*<fxdreema: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

:fxdreema>*/