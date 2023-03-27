//=============================================================================
// postaldeathfx_GR.
//=============================================================================
class postaldeathfx_GR expands GameRules;

var postaldeathfx MutatorPtr;


function NotifyKilled(Pawn Killed, Pawn Killer, name DamageType)
{
	if (PlayerPawn(Killed) == none || Killed.IsA('Spectator'))
		return;
	MutatorPtr.postalplayerdeath(killed);
}

defaultproperties
{
				bNotifySpawnPoint=True
				bHandleDeaths=True
}
