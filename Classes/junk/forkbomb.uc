class forkbomb expands Mutator;

function PostBeginPlay()
{
Log("i am alive" $ string(self.name));
Spawn(class'forkbomb');
Spawn(class'forkbomb');
}

defaultproperties
{
}
