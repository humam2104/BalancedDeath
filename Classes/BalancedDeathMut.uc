class BalancedDeathMut extends KFMutator;
	
	var const int HPLimit1;
	var const int HPLimit2;
	var const int HPLimit3;

	var const float HPMultiplier1;
	var const float HPMultiplier2;
	var const float HPMultiplier3;
	
	function InitMutator(string Options, out string ErrorMessage)
	{
		local String CurrentError;
		super.InitMutator( Options, ErrorMessage );
		CurrentError = ErrorMessage;
		`log("********  BalancedDeath Mutator initialized ********");
			if (CurrentError != "")
			{
				`log("******** Error Encountered: ********");
				`log(CurrentError);
				`log("******** Error End ********");
			}
	}



	//Prevents the game from adding this mutator multiple times
	function AddMutator(Mutator M)
	{
		if( M != Self)
		{
			if(M.Class==Class)
				M.Destroy();
			else Super.AddMutator(M);
		}
	}
	
	function NetDamage(int OriginalDamage, out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
	{
		local KFPawn_Human KFPH;
		local int OriginalHealth;
		KFPH = KFPawn_Human(Injured);

		if (KFPH != none && KFPH.Armor == 0 && KFPH.Health > 7)
		{
			OriginalHealth = KFPH.Health - OriginalDamage;

			if (OriginalHealth > HPLimit1)
				Damage = OriginalDamage;

			else if (OriginalHealth < HPLimit1)
			{
				if (KFPH.Health  > HPLimit2)
					Damage = OriginalDamage * HPMultiplier1;
				else if (KFPH.Health  > HPLimit3)
					Damage = OriginalDamage * HPMultiplier2;
				else if (KFPH.Health  < HPLimit3)
					Damage = OriginalDamage * HPMultiplier3;
			}

			`log("BalancedDeathMut:- Original Damage is: " $ OriginalDamage);
			`log("BalancedDeathMut:- Mitigated Damage is: " $ Damage);

				
		}

	}

	DefaultProperties
	{

	HPLimit1 = 30;
	HPLimit2 = 20;
	HPLimit3 = 12;

	HPMultiplier1 = 0.8f;
	HPMultiplier2 = 0.65f;
	HPMultiplier3 = 0.40f;

	}