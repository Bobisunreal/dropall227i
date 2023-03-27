//=============================================================================
// sn_shit.
//=============================================================================
class sn_shit expands SpawnNotify Config(dropall227);


struct spawnnote  {// shit is now other shit
    var() config string           thing;
    var() config string           newthing;
    var() config bool             isenabled;


	              };

var  () config  array<spawnnote>  spawnnote_list;
var() config bool bdebug;
var sn_shit_mutator MutatorPtr;


function BeginPlay()
{

	log( "Spawn notify Listener Spawned" ,stringtoname("[SN_SHIT]"));
}



simulated event Actor SpawnNotification(Actor A)
{
local int z;

  // for pass on, weird to split just this, however i dont want to recode tall configs.
  if  (MutatorPtr!= none)
   {
   MutatorPtr.receivenotify(a);
   }





if (bdebug)
{
log(a.name, stringtoname("[Sn_Shit debug]"));
}
    if (A!=None)
	{
		For( z = 0; z < Array_Size(spawnnote_list) ; z++ )
        {
         if ( spawnnote_list[z].thing != ""  &&  spawnnote_list[z].newthing != "" &&  spawnnote_list[z].isenabled)
		     {
                if(A.IsA(StringToName(spawnnote_list[z].thing)))
                {
                //log(a.name);
                replacewith(a,spawnnote_list[z].newthing);

                }
             }

        }
   }



return A;
}



simulated function bool ReplaceWith(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;

	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
		A = Spawn(aClass,other.owner,Other.tag,Other.Location, Other.Rotation);
	if ( Other.IsA('Inventory') && Inventory(Other).myMarker != None )
	{
		Inventory(Other).MyMarker.markedItem = Inventory(A);
		if ( Inventory(A) != None )
			Inventory(A).myMarker = Inventory(Other).myMarker;
		Inventory(Other).myMarker = None;
	}
	if ( A != None )

 other.destroy();

	return false;
}

defaultproperties
{
}
