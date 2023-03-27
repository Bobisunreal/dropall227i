//=============================================================================
// sn_tracker.
// track spawnes wth spawn notify.
//pass themto  
//=============================================================================
class deco_tracker expands SpawnNotify Config(dropall227);

var deco_mutator MutatorPtr;





simulated event Actor SpawnNotification(Actor A) 
{
  if  (MutatorPtr!= none)
   {
   MutatorPtr.receivenotify(a);
   }

return A;
}

defaultproperties
{
}
