class giveitemsGR expands GameRules
config(dropall227);



var giveitems  MutatorPtr;



function ModifyPlayer(Pawn Other)
{
	if (PlayerPawn(Other) == none || Other.IsA('Spectator'))
		return;
mutatorptr.kpGiveItems(other);
}

defaultproperties
{
				bNotifySpawnPoint=True
				bHandleDeaths=True
}
