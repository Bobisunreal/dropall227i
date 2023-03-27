class SpawnProtectionGR expands GameRules;

var SpawnProtection MutatorPtr;


function ModifyPlayer(Pawn Other)
{
	if (PlayerPawn(Other) == none || Other.IsA('Spectator'))
		return;
mutatorptr.protectme(Other);

}







defaultproperties
{
				bNotifySpawnPoint=True
				bHandleDeaths=True
}
