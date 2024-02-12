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
    string kzStart;
    string kzEnd;
    KillZoneTypes killZoneType;
    
  public:
    // Constructor
    KillZone() {}
    
    //Initiate
    void init(ENUM_TIMEFRAMES tf, KillZoneTypes killZone, string start, string end) {
      TimeFrame = tf;
      boxNamePrefix = "PAM_" + killZone + "_KillZone_";
      isInKillZone = false;
      kzStart = start;
      kzEnd = end;
      killZoneType = killZone;
    }
    
    //+------------------------------------------------------------------+
    //| isInZillZone                                                     |
    //+------------------------------------------------------------------+
    bool isInZillZone() {
      datetime currentTime = TimeCurrent();
      datetime today = D'1970.01.01' + (currentTime / 86400) * 86400;
      datetime startTime = StringToTime(kzStart);
      datetime endTime = StringToTime(kzEnd);
      
      // Check if current time is within the kill zone
      isInKillZone = currentTime >= startTime && currentTime <= endTime;
      
      // Construct unique box name for today
      string boxName = boxNamePrefix + TimeToString(today, TIME_DATE);
      
      if (isInKillZone) {
         HighLowTimeframe response = GetLowestPriceFromStartTime(TimeFrame, startTime);
         DrawKillZone(startTime, endTime, boxName, response.high, response.low, killZoneType); 
      }
      
      return isInKillZone;
    }
};
