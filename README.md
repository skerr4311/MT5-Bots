# PAM - Price Action Mitigation

Pam is a python script that will run with MT5. The plan is to have MT5 running and have PAM running at the same time. PAM will handle placing and exiting trades based on a set of rules.

#### Goal:

Using the H1 Supply / Demand Zones
if: price entres a zone drop down to the 15m / 5min time zone
if: 3 liquidity rules are met look for entry.
while: looking for entry
if: entry pattern is met - ENTER
Enter rules:
tp: set to the first thing that comes up 1. asia high / low 2. oppozite zome
sl: set to the low / high of the current order block + a buffer

        while: entered:
            do: trailstop loss - move sl to the low of every BOS + a buffer

---

#### Settings:

Decide on the following settings:

1. max risk allowed on an account.
2. max loss % allowed for a session before PAM exits.
3. max gain % for a session before PAM exits.
4. stop loss % 2-0.5%

---

#### Tasks:

###### Stage one - init

[] Connect with MT5 and test connections.
[] Test pulling and console logging candle information.
[] Test drawing boxes / lines / labeling.
[] Test removing said boxes / lines / labeling.

###### Stage two - functions

[] GetSupplyDemandZones

- draw the supply demand zones and label them.
- save them in an array of objects?
- decide if they have been mitigated or not.
- decide how far back to look?

[] ShowKeyTimes:

- London open / close.
- london Kill zone.
- New York open / clos.
- New York Kill zone.
- Asia open / close.
- Algorithm open / close.
- draw boxes and label all zones.

[] ShowKeyAreas:

- BOS lines.
- CHoCH lines.
- Asia high / low.
- Preveous day high / low.
- Preveous week high / low.

###### Stage three - create a basic GUI

This GUI will allow me to:

- show and hide the functions above.

###### Stage four - work on the main automation logic.

Functions needed:
[] isInZone:

- checks to see if price is in a supply / demmand zone.

[] isLiquidityChangeOfCharacter:

- has one liguidity been taken?
  - check the key areas.
- has two liquidity been taken?
  - check the key areas.
- has three liquidity been taken?
  - check the key areas.

[] isPriceActionPattern:

- check the preveous candle and the current forming candle on the 5min.
- is the first candle on of the price action candles?
  - isPriceActionCandle() - check the candle to see if it matches doji / hammer (tweaser will need to be handled differently)
- is the 2nd candle engulfing the first one?

[] enterTrade()

- calculate stop loss using the %, the current zone low / high.
- add the buffer ammount to the sl.
- calculate lot size. (might need to stick to US pairs to make the calcualtion easier)
- calculate the take proffit. key areas or opposite zone.
- enter trade with sl and tp.
- set inTrade = true

[] tradeMode()

- while in trade:
  - keep looking for BOS areas.
  - move sl to the low of the BOS area + a buffer.
  - check to make sure trade has not been closed it.
  - if trade closed:
    - collect information needed. % gained / % lost
    - if % loss or gained does not breach the settings / start again.

###### Stage five - Update GUI

- update GUI for the automation integration.

###### Stage six - Final stage

- build application to be an executable for Mac.
