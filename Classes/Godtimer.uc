//=============================================================================
// godtimer.
//=============================================================================
class godtimer expands Actor;

var playerpawn p;

event BeginPlay()
{
      Super.BeginPlay();
      //SetTimer(3.0, true); 
}
function Timer()
   {
   
   if (p != none)
        {
        p.ReducedDamageType ='none';
        p.ReducedDamagePct = 0;
        p.style=sty_normal;
         log ("invulnerability off",'spawnprotect');
         }else{
		  log("invalid player instance",'godtimer');
		 }
destroy();
   }
   

defaultproperties
{
}
