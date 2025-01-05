//+------------------------------------------------------------------+
//|                                                        SuperTrend.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#include "../../P.A.M/iFunctions.mqh"

struct SuperTrend {
   double upperBand;
   double lowerBand;
   double close;
   bool isFail;
   double superTrend;
   int direction; 
};

class SuperTrendClass {
private:
    double factor;              // Multiplier for ATR
    int atrLength;              // ATR period
    ENUM_TIMEFRAMES timeframe;  // Timeframe for calculations

    double currentSuperTrend;   // Latest SuperTrend value
    int currentDirection;       // Current direction (1 = uptrend, -1 = downtrend)

    int atrHandle;              // Shared ATR indicator handle
    datetime lastCalculationTime;

    // Get superTrend details
    SuperTrend GetSuperTrendValues(int candleIndex = 0) {
        SuperTrend superTrend;
        superTrend.isFail = false;
        superTrend.close = 0.0;
        superTrend.upperBand = 0.0;
        superTrend.lowerBand = 0.0;
        superTrend.superTrend = 0.0;
        superTrend.direction = 0;



        if (Bars(Symbol(), timeframe) <= atrLength) {
            Print("Not enough bars to calculate SuperTrend.");
            superTrend.isFail = true;
            return superTrend;
        }

        // Get ATR value
        double atrValues[1];
        int copied = CopyBuffer(atrHandle, 0, candleIndex, 1, atrValues);
        if (copied <= 0) {
            Print("Error copying ATR values: ", GetLastError());
            superTrend.isFail = true;
            return superTrend;
        }
        double atrValue = atrValues[0];

        // Get high, low, and close prices
        double high = iHigh(Symbol(), timeframe, candleIndex);
        double low = iLow(Symbol(), timeframe, candleIndex);
        superTrend.close = iClose(Symbol(), timeframe, candleIndex);

        // Calculate bands
        double highLow = (high + low) / 2.0;
        superTrend.upperBand = highLow + (factor * atrValue);
        superTrend.lowerBand = highLow - (factor * atrValue);

        if (currentSuperTrend == 0.0) {
            Print("INIT IF");
            // Initialize currentSuperTrend based on the first candle's data
            currentSuperTrend = highLow;
            currentDirection = 1; // Default to an uptrend
        }

        if (superTrend.close > currentSuperTrend) {
            Print("IF");
            superTrend.direction = 1; // Uptrend
            superTrend.superTrend = MathMin(currentSuperTrend, superTrend.lowerBand);
            currentSuperTrend = superTrend.superTrend;
            currentDirection = superTrend.direction;
        } else if (superTrend.close < currentSuperTrend) {
            superTrend.direction = -1; // Downtrend
            superTrend.superTrend = MathMax(currentSuperTrend, superTrend.upperBand);
            currentSuperTrend = superTrend.superTrend;
            currentDirection = superTrend.direction;
            Print("ELSE IF: ", " st: ", superTrend.superTrend, " current st: ", currentSuperTrend);
        }

        return superTrend;
    }

public:
    // Constructor
    SuperTrendClass() {
        factor = 3.0;
        atrLength = 10;
        timeframe = PERIOD_CURRENT;
        currentSuperTrend = 0.0;
        currentDirection = 0;
        atrHandle = INVALID_HANDLE;
        lastCalculationTime = 0;
    }

    // Initialize the SuperTrend indicator
    void Init(double inputFactor, int inputAtrLength, ENUM_TIMEFRAMES inputTimeframe) {
        factor = inputFactor;
        atrLength = inputAtrLength;
        timeframe = inputTimeframe;

        // Create ATR handle
        atrHandle = iATR(Symbol(), timeframe, atrLength);
        if (atrHandle == INVALID_HANDLE) {
            Print("Error creating ATR handle: ", GetLastError());
        }

        Calculate(0);
    }

    // Calculate the SuperTrend value for a given candle
    void Calculate(int candleIndex = 0) {
        SuperTrend st = GetSuperTrendValues(candleIndex);

        if (st.isFail) {
            return;
        }

        // Print("DEBUG: close=", st.close, ", currentSuperTrend=", st.superTrend, ", currentDirection=", currentDirection);
        // Print("DEBUG:", ", UpperBand=", st.upperBand, ", LowerBand=", st.lowerBand);

        currentDirection = st.direction;
        currentSuperTrend = st.superTrend;

        // todo: there should be checks in place i.e require double confirmation when switching trends. i.e prev candle close. 
    }

    // Get the SuperTrend value for a specific bar
    double GetSuperTrendForBar(int candleIndex) {
        Calculate(candleIndex);  // Reuse the same logic for consistency
        return currentSuperTrend;
    }

    // Draw the SuperTrend line
    void DrawLine(int candleId) {
        datetime startTime = iTime(Symbol(), timeframe, candleId + 1);
        datetime endTime = iTime(Symbol(), timeframe, candleId);

        SuperTrend startSuperTrend = GetSuperTrendValues(candleId + 1);
        SuperTrend endSuperTrend = GetSuperTrendValues(candleId);

        string upperLineName = "SuperTrend_Upper" + IntegerToString(_Period) + "_" + (string)endTime;

        if (ObjectFind(0, upperLineName) == -1) {
            ObjectCreate(0, upperLineName, OBJ_TREND, 0, endTime, endSuperTrend.upperBand, startTime, startSuperTrend.upperBand);
            ObjectSetInteger(0, upperLineName, OBJPROP_COLOR, clrPurple);
            ObjectSetInteger(0, upperLineName, OBJPROP_WIDTH, 2);
        } else {
            ObjectMove(0, upperLineName, 0, endTime, endSuperTrend.upperBand);
            ObjectMove(0, upperLineName, 1, startTime, startSuperTrend.upperBand);
        }

        string lowerLineName = "SuperTrend_Lower" + IntegerToString(_Period) + "_" + (string)endTime;

        if (ObjectFind(0, lowerLineName) == -1) {
            ObjectCreate(0, lowerLineName, OBJ_TREND, 0, endTime, endSuperTrend.lowerBand, startTime, startSuperTrend.lowerBand);
            ObjectSetInteger(0, lowerLineName, OBJPROP_COLOR, clrPurple);
            ObjectSetInteger(0, lowerLineName, OBJPROP_WIDTH, 2);
        } else {
            ObjectMove(0, lowerLineName, 0, endTime, endSuperTrend.lowerBand);
            ObjectMove(0, lowerLineName, 1, startTime, startSuperTrend.lowerBand);
        }

        string superLineName = "SuperTrend_super" + IntegerToString(_Period) + "_" + (string)endTime;

        if (ObjectFind(0, superLineName) == -1) {
            ObjectCreate(0, superLineName, OBJ_TREND, 0, endTime, endSuperTrend.superTrend, startTime, startSuperTrend.superTrend);
            ObjectSetInteger(0, superLineName, OBJPROP_COLOR, clrRed);
            ObjectSetInteger(0, superLineName, OBJPROP_WIDTH, 2);
        } else {
            ObjectMove(0, superLineName, 0, endTime, endSuperTrend.superTrend);
            ObjectMove(0, superLineName, 1, startTime, startSuperTrend.superTrend);
        }
    }

    // Get direction
    int GetDirection() {
        return this.currentDirection;
    }

    // Get SuperTrend
    double GetSuperTrend() {
        return this.currentSuperTrend;
    }

    // Release resources
    void Deinit() {
        if (atrHandle != INVALID_HANDLE) {
            IndicatorRelease(atrHandle);
        }
    }
};
