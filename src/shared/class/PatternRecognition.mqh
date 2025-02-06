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
        // Step 1: Price moves down for a minimum of two bars
        if (ArraySize(prices) < 3) return false;
        if (prices[1] >= prices[0] || prices[2] >= prices[1]) return false;

        // Step 2: Price creates a lower low
        troughIndex = FindTrough(prices, 0, ArraySize(prices) / 2);
        if (troughIndex == -1) return false;

        // Step 3: Price moves up, then back down and fails to break the lower low
        peak1Index = FindPeak(prices, 0, troughIndex);
        if (peak1Index == -1) return false;

        peak2Index = FindPeak(prices, troughIndex, ArraySize(prices));
        if (peak2Index == -1) return false;

        double trough = prices[troughIndex];
        if (prices[peak2Index] <= prices[troughIndex]) return false;

        // Check for failure to break lower low
        for (int i = troughIndex + 1; i < peak2Index; i++) {
            if (prices[i] < trough) return false;
        }

        // Step 4: Draw a line on the neck and wait for price to come back to it
        DrawHorizontalLineWithLabel(prices[troughIndex], clrBlueViolet, troughIndex, "MTop Neckline", "MTop_Neckline" + prices[troughIndex]);

        return true;
    }

    // Function to detect W Bottoms
    static bool IsWBottom(double &prices[], int &trough1Index, int &peakIndex, int &trough2Index, double tolerance = 0.02) {
        // Step 1: Price moves up for a minimum of two bars
        if (ArraySize(prices) < 3) return false;
        if (prices[1] <= prices[0] || prices[2] <= prices[1]) return false;

        // Step 2: Price creates a higher high
        peakIndex = FindPeak(prices, 0, ArraySize(prices) / 2);
        if (peakIndex == -1) return false;

        // Step 3: Price moves down, then back up and fails to break the higher high
        trough1Index = FindTrough(prices, 0, peakIndex);
        if (trough1Index == -1) return false;

        trough2Index = FindTrough(prices, peakIndex, ArraySize(prices));
        if (trough2Index == -1) return false;

        double peak = prices[peakIndex];
        if (prices[trough2Index] >= prices[peakIndex]) return false;

        // Check for failure to break higher high
        for (int i = peakIndex + 1; i < trough2Index; i++) {
            if (prices[i] > peak) return false;
        }

        // Step 4: Draw a line on the neck and wait for price to come back to it
        DrawHorizontalLineWithLabel(prices[peakIndex], clrGreenYellow, peakIndex, "WBottom Neckline", "WBottom_Neckline" + prices[peakIndex]);

        return true;
    }

private:
    // Function to find the highest peak in a range
    static int FindPeak(double &prices[], int start, int end) {
        if (start < 0 || end > ArraySize(prices) || start >= end) {
            Print("Invalid range: Start=", start, " End=", end);
            return -1;
        }

        int peakIndex = start;
        double peakValue = prices[start];

        for (int i = start + 1; i < end; i++) {
            if (prices[i] > peakValue) {
                peakValue = prices[i];
                peakIndex = i;
            }
        }

        Print("Peak detected at Index: ", peakIndex, " Value: ", peakValue);
        return peakIndex;
    }

    // Function to find the lowest trough in a range
    static int FindTrough(double &prices[], int start, int end) {
        if (start < 0 || end > ArraySize(prices) || start >= end) {
            Print("Invalid range: Start=", start, " End=", end);
            return -1;
        }

        int troughIndex = start;
        double troughValue = prices[start];

        for (int i = start + 1; i < end; i++) {
            if (prices[i] < troughValue) {
                troughValue = prices[i];
                troughIndex = i;
            }
        }

        Print("Trough detected at Index: ", troughIndex, " Value: ", troughValue);
        return troughIndex;
    }
};

#endif // __PATTERNRECOGNITION_MQH__

//+------------------------------------------------------------------+
