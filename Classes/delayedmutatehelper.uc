class delayedmutatehelper expands actor;


// i need a time deley to wait  seconds for player to replicate
// for first spawn authentication
// this is bullshit...

var playerpawn Mutateplayer;
var essentials backlink;


function PostBeginPlay()
{
SetTimer(3,false,'itreallyisbullshit');
}

// have to add even more time becuase ugold mp fucks over adminlogin for 1 second after spawn.


function itreallyisbullshit()
{

   if (Mutateplayer != none) // srsly it should end here if there is no pri ,
         {
          backlink.authuseratjoin(Mutateplayer);
          destroy();
         }else{
         log("Lost Our player callback Link",stringtoname("[Delayed_helper]"));
         destroy();
         }
}

defaultproperties
{
}
