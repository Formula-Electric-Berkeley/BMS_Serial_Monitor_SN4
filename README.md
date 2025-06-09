# Serial Monitor

## Notes

Design inspired by CoolTerm serial monitor app on MacOS.

## Serial Input

Cell Data
- cell
- \<int bank>
- \<int cell>
- \<float voltage>
- \<float redundant voltage>
- \<float temperature>
- \<bool balance>

Relay Data
- relay
- \<bool AIR+ open>
- \<bool AIR- open>
- \<bool precharge open>

IVT Data
- ivt
- \<float current>
- \<float voltage 1>
- \<float voltage 2>
- \<float voltage 3>

Charger Data (BMS -> Charger)
- charger1
- \<int max voltage (100mV)>
- \<int max current (100mA)>
- \<int control (0 or 1)>

Charger Data (Charger -> BMS)
- charger2
- \<int output voltage (100mV)>
- \<int output current (100mA)>
- \<byte status flags>
