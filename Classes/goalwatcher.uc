//=============================================================================
// goalwatcher.
// this is broken and alot of code it removed to compile 
// this is not functional
// had dependencies on jcoopz1, login manager ands others
//=============================================================================
class goalwatcher expands Actor;

var ()int goalnum;
var ()int g;
var essentials backlink;


function PostBeginPlay()
{
SetTimer(3,true,'itreallyisbullshit');
}


function itreallyisbullshit()
{
self.destroy();

}

 function adminmessage( string msg)
{
   local PlayerPawn q;
    foreach AllActors(class'PlayerPawn',q)
    {
      
    q.ClientMessage(msg);


    }
}


 function givecredit( string msg)
{
   local PlayerPawn q;
    foreach AllActors(class'PlayerPawn',q)
    {
    // gotta love calling functions over there from here .... right ? lol
    // dbobject is already a proxy actor , so we are linking tho 3 classes to save this data.;)
    backlink.dbobject.updatedatavalue (backlink.getplayername(q)$".achivments", "TeamKillGoal"$ goalnum," Complete a team based kill goal of"$ goalnum $ backlink.stampachevmet(q));
//q.Playsound(Sound'announcer.winner');

    }
}

defaultproperties
{
}
