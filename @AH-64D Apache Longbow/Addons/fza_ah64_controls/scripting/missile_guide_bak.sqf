_jet = _this select 0;
_bomb = _this select 1;
if(!(local _bomb)) exitwith {};
_jetalt = getposasl _jet select 2;
_target = fza_ah64_mycurrenttarget;
fza_ah64_shotat_list = fza_ah64_shotat_list + [_target];
if(_bomb iskindof "fza_agm114c" || _bomb iskindof "fza_agm114k" || _bomb iskindof "fza_fim92") then {_target = cursortarget;};
_basedir = direction _bomb;
_poweredmunition = 0;
_prox = 0;
_pdist = 10;
_pitch = 0;
_targaltfactor = 0;
_theta = 0;
_jetreldir = 0;
_hilimit = 340;
_lolimit = 20;
_dirrate = 0.5;
_loftcomplete = 0;
_abstheta = 0;
_abspitch = 0;
_cdirrate = 0;
_cprate = 0;
_speedfactor = 1;
_time = 1;
_basetargdist = _bomb distance _target;
_designator = fza_ah64_hfmode;
_laserguided = 0;
_attached = 1;
_launchmode = fza_ah64_ltype;

if (_bomb isKindOf "fza_agm114k" && _designator != _jet && !(_launchmode == "direct.sqf" || _launchmode == "lobl.sqf")) then
{
		_target = _designator;
		_basetargdist = _bomb distance _target;
};

if (!(_bomb isKindOf "fza_f16_aim120c" || _bomb isKindOf "fza_f16_aim9m" || _bomb isKindOf "fza_f16_aim9x" || _bomb isKindOf "fza_agm114l" || _bomb isKindOf "fza_agm114k" || _bomb isKindOf "fza_agm114c" || _bomb isKindOf "fza_fim92")) exitwith {};
if (_bomb isKindOf "fza_f16_aim120c") then {_hilimit = 330; _lolimit = 30; _poweredmunition = 1; _prox = 1; _pdist = 20;};
if (_bomb isKindOf "fza_f16_aim9m") then {_hilimit = 300; _lolimit = 60; _poweredmunition = 1; _prox = 1; _pdist = 15; _dirrate = 1;};
if (_bomb isKindOf "fza_f16_aim9x") then {_hilimit = 270; _lolimit = 90; _poweredmunition = 1; _prox = 1; _pdist = 15; _dirrate = 1.5;};
if (_bomb isKindOf "fza_fim92") then {_hilimit = 270; _lolimit = 90; _poweredmunition = 1; _prox = 0; _pdist = 15; _dirrate = 6.25;};
if (_bomb isKindOf "fza_agm114l") then {_hilimit = 330; _lolimit = 30; _poweredmunition = 1; _dirrate = 5.7;};
if (_bomb isKindOf "fza_agm114k") then {_hilimit = 330; _lolimit = 30; _poweredmunition = 1; _dirrate = 5.7; _laserguided = 1;};
if (_bomb isKindOf "fza_agm114c") then {_hilimit = 330; _lolimit = 30; _poweredmunition = 1; _dirrate = 5.7; _laserguided = 1;};
if (_launchmode == "direct.sqf" && _bomb isKindOf "fza_agm114l") exitwith {};

_bombpb = _bomb call fza_ah64_getpb;
_pitch = _bombpb select 0;
_bank = _bombpb select 1;

_bomb setdir (180 + _basedir);
sleep 0.01;

_vecdx = sin(_basedir) * cos(_pitch);
_vecdy = cos(_basedir) * cos(_pitch);
_vecdz = sin(_pitch);

_vecux = cos(_basedir) * cos(_pitch) * sin(_bank);
_vecuy = sin(_basedir) * cos(_pitch) * sin(_bank);
_vecuz = cos(_pitch) * cos(_bank);

_bomb setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];

if (!(isnil "fza_ah64_miscam")) then {_bomb switchcamera "external"; _bombspeed = [_bomb] execvm "\fza_ah64_controls\scripting\speedcheck.sqf";};

sleep 0.02;

if ((fza_ah64_targlos == 0 && typeof _bomb == "fza_agm114l" && _launchmode == "lobl.sqf") || (_launchmode == "lobl.sqf" && typeof _bomb == "fza_agm114l" && fza_ah64_fcrstate == 0)) exitwith {fza_ah64_shotat_list = fza_ah64_shotat_list - [_target];};

_posdetector = "EmptyDetector" createvehiclelocal (getpos _target);
_posdetector attachto [_target,[0,0,0],"zamerny"];
if(fza_ah64_targlos == 0 && typeof _bomb == "fza_agm114l" && _launchmode != "lobl.sqf") then
{
detach _posdetector;
};

fza_ah64_114sc = fza_ah64_114sc + [_bomb];
fza_ah64_firedist = (_bomb distance _target) * 0.046;

while {(alive _bomb && (_theta > _hilimit || _theta < _lolimit))} do
{

if ((_bomb isKindOf "fza_agm114k" || _bomb isKindOf "fza_agm114c") && _designator != _jet && isNull _target) then
{
fza_ah64_shotat_list = fza_ah64_shotat_list - [_target];
detach _posdetector;
sleep 0.03;
_target = _designator;
sleep 0.03;
_posdetector attachto [_target,[0,0,0],"zamerny"];
sleep 0.03;
fza_ah64_shotat_list = fza_ah64_shotat_list + [_target];
};

if ((_bomb isKindOf "fza_agm114k" || _bomb isKindOf "fza_agm114c") && _designator == _jet && fza_ah64_targlos == 1 && !(_target == cursortarget)) then
{
fza_ah64_shotat_list = fza_ah64_shotat_list - [_target];
detach _posdetector;
sleep 0.03;
_target = cursortarget;
sleep 0.03;
_posdetector attachto [_target,[0,0,0],"zamerny"];
sleep 0.03;
fza_ah64_shotat_list = fza_ah64_shotat_list + [_target];
};

if (_attached == 1 && fza_ah64_targlos == 0 && (_bomb isKindOf "fza_agm114k" || _bomb isKindOf "fza_agm114c")) then
{
detach _posdetector;
_attached = 0;
};

if (_attached == 0 && fza_ah64_targlos == 1 && (_bomb isKindOf "fza_agm114k" || _bomb isKindOf "fza_agm114c")) then
{
_posdetector attachto [_target,[0,0,0],"zamerny"];
_attached = 1;
};

fza_ah64_firedist = (_bomb distance _target) * 0.046;
_dir = direction _bomb;
_basedir = _dir;
//calculate lead for target velocity
_relvel = sqrt((((velocity _bomb select 0)-(velocity _target select 0))^2)+(((velocity _bomb select 1)-(velocity _target select 1))^2)+(((velocity _bomb select 2)-(velocity _target select 2))^2));
_magvel = sqrt(((velocity _target select 0)^2)+((velocity _target select 1)^2)+((velocity _target select 2)^2));
if(_relvel == 0) then {_relvel = 1;};
_time = (_bomb distance _target) / (_relvel);
_distfactor = _magvel * _time;
_finalX = (getposasl _posdetector select 0) + ((Sin ((velocity _target select 0) atan2 (velocity _target select 1))) * (_distfactor));
_finaly = (getposasl _posdetector select 1) + ((Cos ((velocity _target select 0) atan2 (velocity _target select 1))) * (_distfactor));
_targetpb = _target call fza_ah64_getpb;
_targetp = _targetpb select 0;
_finalZ = (getposasl _posdetector select 2)+1.5 + ((sin ((velocity _target select 2) atan2 (sqrt((velocity _target select 0)^2+(velocity _target select 1)^2)))) * (_distfactor));
if(speed _target < 1 && speed _target > -1) then {_finalX = (getposasl _posdetector select 0); _finalY = (getposasl _posdetector select 1); _finalZ = (getposasl _posdetector select 2);};
if(getpos _target select 2 < 5) then {_finalZ = (getposasl _posdetector select 2)+1;};
///pitch and bank////
_bombpb = _bomb call fza_ah64_getpb;
_pitch = _bombpb select 0;
_bank = _bombpb select 1;
//direction correct
_speedfactor = speed _bomb;
if(speed _bomb < 1) then {_speedfactor = 1;};
_finalX = _finalX + ((sin _dir) * (2000 / _speedfactor));
_finalY = _finalY + ((cos _dir) * (2000 / _speedfactor));
_jdamtarget = [_finalX,_finaly,_finalZ];
_bombpos = getposasl _bomb;

_theta = [_bomb,(_bombpos select 0),(_bombpos select 1),(_jdamtarget select 0),(_jdamtarget select 1)] call fza_ah64_reldir;

//////pitch///////
_relpitch = ((_jdamtarget select 2) - (_bombpos select 2)) atan2 ([(_jdamtarget select 0),(_jdamtarget select 1),0] distance [(_bombpos select 0),(_bombpos select 1),0]);
_thetapitch = (_relpitch - _pitch);
//player globalchat format ["Pitch %1 Bombpitch %2 Direction %3 Altfactor %4",_thetapitch,_pitch,_theta,_targaltfactor];

_cdirrate = _dirrate;
_cprate = _dirrate;
if(_dirrate > _theta) then {_cdirrate = _dirrate * (_theta / _dirrate);};
if(_dirrate > (360 - _theta)) then {_cdirrate = _dirrate * ((360 - _theta) / _dirrate);};
if(_dirrate > (abs _thetapitch)) then {_cprate = _dirrate * ((abs _thetapitch) / _dirrate);};

if(_theta > 359.9 && _theta < 0.1) then {_dir = _dir;};
if(_theta > 180 && _theta < 359.9) then {_dir = _dir - _cdirrate;};
if(_theta < 180 && _theta > 0.1) then {_dir = _dir + _cdirrate;};
_basepitch = _pitch;
if(_thetapitch > -0.1 && _thetapitch < 0.1) then {_pitch = _pitch;};
if(_thetapitch < -0.1) then {_pitch = _pitch - _cprate;};
if(_thetapitch > 0.1) then {_pitch = _pitch + _cprate;};

_relalt = (getposasl _bomb select 2) - _jetalt;
_maxpitch = 30;
_pfactor = 1.2;
_maxalt = _basetargdist * 0.07;
if(_launchmode == "lobl.sqf") then {_maxpitch = ((_bomb distance _posdetector) * 0.005625);};
if(_launchmode == "loaldir.sqf") then {_maxpitch = ((_bomb distance _posdetector) * 0.004375); _maxalt = _basetargdist * 0.034;  _pfactor = 0.7;};
if(_launchmode == "loallo.sqf") then {_maxpitch = 70; _pfactor = 2; _maxalt = _basetargdist * 0.05;};
if(_launchmode == "loalhi.sqf") then {_maxpitch = 55; _pfactor = 1.5; _maxalt = _basetargdist * 0.075;};
if(typeOf _bomb == "fza_agm114l") then {_maxpitch = 30; _pfactor = 1.2; _maxalt = _basetargdist * 0.106;};

if(_loftcomplete == 0 && _basepitch < _maxpitch && (_bomb isKindOf "fza_agm114l") && _bomb distance _target > (_relalt+((_relalt)/((_relalt)*0.0013))) && (_relalt) < _maxalt) then
{
_pitch = _basepitch + _pfactor;
};

if(_loftcomplete == 0 && _basepitch > 0 && (_bomb isKindOf "fza_agm114l") && _bomb distance _target > (_relalt+((_relalt)/((_relalt)*0.0013))) && (_relalt) >= _maxalt) then
{
_pitch = _basepitch - 2;
if(_pitch <= 5) then
{
_loftcomplete = 1;
};
};

if(_loftcomplete == 1 && _bomb isKindOf "fza_agm114l" && _bomb distance _target > (_relalt+((_relalt)/((_relalt)*0.0013)))) then
{
_pitch = 2;
};

if(_designator == _jet && _bomb isKindOf "fza_agm114k" && fza_ah64_targlos == 0 && _bomb distance _target < (_relalt+((_relalt)/((_relalt)*0.0013)))) then
{
_pitch = _bombpb select 0;
_dir = _basedir;
};

if(_bomb isKindOf "fza_fim92" && (getposasl _bomb select 2) < ((_jetalt)+25) && _loftcomplete == 0) then {_pitch = _basepitch + 1;};
if(_bomb isKindOf "fza_fim92" && (getposasl _bomb select 2) > ((_jetalt)+25) && _loftcomplete == 0) then {_loftcomplete = 1;};

_bank = 0;


_vecdx = sin(_dir) * cos(_pitch);
_vecdy = cos(_dir) * cos(_pitch);
_vecdz = sin(_pitch);

_vecux = cos(_dir) * cos(_pitch) * sin(_bank);
_vecuy = sin(_dir) * cos(_pitch) * sin(_bank);
_vecuz = cos(_pitch) * cos(_bank);

_bomb setVectorDirAndUp [ [_vecdx,_vecdy,_vecdz], [_vecux,_vecuy,_vecuz] ];


//[_bomb,_pitch,_bank] call fza_ah64_setpb;

_jetreldir = [_jet,(getposasl _jet select 0),(getposasl _jet select 1),(_jdamtarget select 0),(_jdamtarget select 1)] call fza_ah64_reldir;

if(_laserguided == 1) then
{
	while {(_jetreldir > 120 && _jetreldir < 240)} do
	{
	_jetreldir = [_jet,(getposasl _jet select 0),(getposasl _jet select 1),(_jdamtarget select 0),(_jdamtarget select 1)] call fza_ah64_reldir;
	sleep 0.04;
	};
};

sleep 0.04;
};

if(_bomb distance _target < _pdist && _prox == 1) then
{
_bomb setposasl [(getposasl _target select 0)+(random 2),(getposasl _target select 1)+(random 2),(getposasl _target select 2)+(random 2)];
sleep 0.03;
_holder = createVehicle ["weaponHolder", getposatl _bomb, [], 0, "CAN_COLLIDE"];
_bomb setposatl (getposatl _holder);
sleep 0.1;
deletevehicle _holder;
};

if (!(isnil "fza_ah64_miscam")) then 
{
sleep 3;
(vehicle player) switchcamera "external";
};

deletevehicle _posdetector;
fza_ah64_114sc = fza_ah64_114sc - [_bomb];
fza_ah64_shotat_list = fza_ah64_shotat_list - [_target];