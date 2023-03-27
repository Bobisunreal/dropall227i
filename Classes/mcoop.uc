class mcoop expands Mutator
	config(dropall227);


function PostBeginPlay()
{
	AddGameRules();
	SaveConfig();
}


function AddGameRules()
{
	local mcoopGR gr;

	gr = Spawn(class'mcoopGR');
	gr.MutatorPtr = self;

	if (Level.Game.GameRules == None)
		Level.Game.GameRules = gr;
	else if (gr != None)
		Level.Game.GameRules.AddRules(gr);
}




defaultproperties
{
}
