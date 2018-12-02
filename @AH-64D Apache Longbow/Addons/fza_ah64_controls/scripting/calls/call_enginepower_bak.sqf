private ["_heli"];
_heli = _this select 0;

_e1Started = false;
_e2Started = false;
_e1SC = 0;
_e2SC = 0;
_e1FP = false;
_e2FP = false;

while {fza_ah64_estarted} do
{
  if((_heli animationphase "plt_eng1_throttle" > 0.2) && (_heli animationphase "plt_eng1_throttle" < 0.95) && (!(_e2Started && (_e2SC < 60)) || _e1FP)) then
  {
    if(!_e1Started) then
    {
      (vehicle player) setWantedRPMRTD [13500, 30, 0];
      _e1Started = true;
    };
    if(_e1Started && (_e1SC == 60)) then
    {
      (vehicle player) setWantedRPMRTD [13500, 10, 0];
      _e1FP = true;
    };
  };

  if((_heli animationphase "plt_eng1_throttle" > 0.95) && _e1FP) then
  {
    (vehicle player) setWantedRPMRTD [20000, 7, 0];
  };

  if((_heli animationphase "plt_eng2_throttle" > 0.2) && (_heli animationphase "plt_eng2_throttle" < 0.95) && (!(_e1Started && (_e1SC < 60)) || _e2FP)) then
  {
    if(!_e2Started) then
    {
      (vehicle player) setWantedRPMRTD [13500, 30, 1];
      _e2Started = true;
    };
    if(_e2Started && (_e2SC == 60)) then
    {
      (vehicle player) setWantedRPMRTD [13500, 10, 1];
      _e2FP = true;
    };
  };

  if((_heli animationphase "plt_eng2_throttle" > 0.95) && _e2FP) then
  {
    (vehicle player) setWantedRPMRTD [20000, 7, 1];
  };

  if((_heli animationphase "plt_eng1_throttle" == 0)) then
  {
    (vehicle player) setWantedRPMRTD [0, 30, 0];
    _e1Started = false;
    _e1SC = 0;
  };

  if((_heli animationphase "plt_eng2_throttle" == 0)) then
  {
    (vehicle player) setWantedRPMRTD [0, 30, 1];
    _e2Started = false;
    _e2SC = 0;
  };

  if ((_e1SC < 60) && (_e1Started)) then
  {
    _e1SC = _e1SC + 1;
  };
  if ((_e2SC < 60) && (_e2Started)) then
  {
    _e2SC = _e2SC + 1;
  };

  sleep 0.5;
};
