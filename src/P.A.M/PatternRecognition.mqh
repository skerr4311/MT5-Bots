//+------------------------------------------------------------------+
//| PatternRecognition.mqh                                           |
//| Module for detecting M tops and W bottoms in price data          |
//+------------------------------------------------------------------+

#ifndef __PATTERNRECOGNITION_MQH__
#define __PATTERNRECOGNITION_MQH__

// Enum to define pattern types
enum ENUM_PATTERN_TYPE {
    PATTERN_NONE,
    PATTERN_M_TOP,
    PATTERN_W_BOTTOM
};

class PatternRecognition {
public:
    // Function to detect M Tops
    static bool IsMTop(double &prices[], int &peak1Index, int &troughIndex, int &peak2Index, double tolerance = 0.02) {
        peak1Index = FindPeak(prices, 0, ArraySize(prices) / 2);
        troughIndex = FindTrough(prices, peak1Index, ArraySize(prices) / 2);
        peak2Index = FindPeak(prices, troughIndex, ArraySize(prices));

        if (peak1Index == -1 || troughIndex == -1 || peak2Index == -1)
            return false;

        double peak1 = prices[peak1Index];
        double trough = prices[troughIndex];
        double peak2 = prices[peak2Index];

        bool peaksSimilar = MathAbs(peak1 - peak2) / peak1 <= tolerance;
        bool breakout = prices[troughIndex + 1] < trough;

        return peaksSimilar && breakout;
    }

    // Function to detect W Bottoms
    static bool IsWBottom(double &prices[], int &trough1Index, int &peakIndex, int &trough2Index, double tolerance = 0.02) {
        trough1Index = FindTrough(prices, 0, ArraySize(prices) / 2);
        peakIndex = FindPeak(prices, trough1Index, ArraySize(prices) / 2);
        trough2Index = FindTrough(prices, peakIndex, ArraySize(prices));

        if (trough1Index == -1 || peakIndex == -1 || trough2Index == -1)
            return false;

        double trough1 = prices[trough1Index];
        double peak = prices[peakIndex];
        double trough2 = prices[trough2Index];

        bool troughsSimilar = MathAbs(trough1 - trough2) / trough1 <= tolerance;
        bool breakout = prices[peakIndex + 1] > peak;

        return troughsSimilar && breakout;
    }

private:
    // Function to find the highest peak in a range
    static int FindPeak(double &prices[], int start, int end) {
        int peakIndex = -1;
        double peakValue = -DBL_MAX;

        for (int i = start; i < end; i++) {
            if (prices[i] > peakValue) {
                peakValue = prices[i];
                peakIndex = i;
            }
        }
        return peakIndex;
    }

    // Function to find the lowest trough in a range
    static int FindTrough(double &prices[], int start, int end) {
        int troughIndex = -1;
        double troughValue = DBL_MAX;

        for (int i = start; i < end; i++) {
            if (prices[i] < troughValue) {
                troughValue = prices[i];
                troughIndex = i;
            }
        }
        return troughIndex;
    }
};

#endif // __PATTERNRECOGNITION_MQH__

//+------------------------------------------------------------------+
