class megadrops_GR expands GameRules;


var megadrops MutatorPtr;


function NotifyKilled(Pawn Killed, Pawn Killer, name DamageType)
{
	if (Killed.IsA('playerpawn'))
		return;
	MutatorPtr.pawnKill(Killer,killed);
}




defaultproperties
{
				bNotifySpawnPoint=True
				bHandleDeaths=True
}
