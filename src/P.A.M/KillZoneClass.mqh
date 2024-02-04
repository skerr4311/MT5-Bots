//+------------------------------------------------------------------+
//|                                    KillZone            P.A.M.mq5 |
//|                                    Copyright 2023, SDK Bots Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
class KillZone {
  private:
    ENUM_TIMEFRAMES TimeFrame;
    string boxNamePrefix;
    bool isInKillZone;
    
  public:
    // Constructor
    KillZone() {}
    
    //Initiate
    void init(ENUM_TIMEFRAMES tf, KillZoneTypes killZone) {
      TimeFrame = tf;
      boxNamePrefix = killZone + "_KillZone_";
      isInKillZone = false;
    }
    
    // Called on each tick
    void OnTick() {
      datetime currentTime = TimeCurrent();
      datetime today = D'1970.01.01' + (currentTime / 86400) * 86400;
      datetime startTime = StringToTime("09:30");
      datetime endTime = StringToTime("12:30");
      
      // Check if current time is within the kill zone
      isInKillZone = currentTime >= startTime && currentTime <= endTime;
      
      Print("current time: ", currentTime);
      Print("today: ", today);
      Print("start time: ", startTime);
      Print("end time: ", endTime);
      
      Print("isInKillZone: ", isInKillZone);
      
      // Construct unique box name for today
      string boxName = boxNamePrefix + TimeToString(today, TIME_DATE);
      
      if (isInKillZone) {
        double highestHigh = 0, lowestLow = DBL_MAX;
        UpdateKillZone(boxName, startTime, endTime, highestHigh, lowestLow, currentTime);
      } else {
        FinalizeKillZone(boxName, endTime);
      }
    }
    
  private:
    // Update or create the kill zone box
    void UpdateKillZone(string boxName, datetime startTime, datetime endTime, double &highestHigh, double &lowestLow, datetime currentTime) {
      for (int i = 0; i < Bars(_Symbol, TimeFrame); i++) {
        datetime barTime = iTime(_Symbol, TimeFrame, i);
        if (barTime >= startTime && barTime <= currentTime) {
          highestHigh = MathMax(highestHigh, iHigh(_Symbol, TimeFrame, i));
          lowestLow = MathMin(lowestLow, iLow(_Symbol, TimeFrame, i));
        }
      }
      
      DrawOrUpdateBox(boxName, startTime, highestHigh, lowestLow, currentTime);
    }
    
    // Draw or update the rectangle object
    void DrawOrUpdateBox(string boxName, datetime startTime, double highestHigh, double lowestLow, datetime currentTime) {
      if (ObjectFind(0, boxName) == -1) {
        if (!ObjectCreate(0, boxName, OBJ_RECTANGLE_LABEL, 0, startTime, highestHigh, currentTime, lowestLow))
          Print("Failed to create box object. Error code: ", GetLastError());
      } else {
        ObjectMove(0, boxName, 0, startTime, highestHigh);
        ObjectMove(0, boxName, 1, currentTime, lowestLow);
      }
      
      ObjectSetInteger(0, boxName, OBJPROP_COLOR, clrDodgerBlue);
      ObjectSetInteger(0, boxName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSetInteger(0, boxName, OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, boxName, OBJPROP_BACK, true);
      ObjectSetInteger(0, boxName, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, boxName, OBJPROP_SELECTED, false);
    }
    
    // Finalize the kill zone box after the end time
    void FinalizeKillZone(string boxName, datetime endTime) {
      if (ObjectFind(0, boxName) != -1) {
        double boxEndTime;
        // ObjectGetDouble(0, boxName, OBJPROP_TIME2, boxEndTime);
        if (boxEndTime != endTime) {
          double boxLow;
          // ObjectGetDouble(0, boxName, OBJPROP_PRICE2, boxLow);
          ObjectMove(0, boxName, 1, endTime, boxLow);
        }
      }
    }
};
