function SA.CAFInit()
	SA.RD = CAF.GetAddon("Resource Distribution")
	SA.SB = CAF.GetAddon("Spacebuild")
	SA.LS = CAF.GetAddon("Life Support")

	timer.Simple(0, function()
		SA.RD.AddProperResourceName("valuable minerals", "Valuable Minerals")
		SA.RD.AddProperResourceName("dark matter", "Dark Matter")
		SA.RD.AddProperResourceName("terracrystal", "Terracrystal")
		SA.RD.AddProperResourceName("permafrost", "Permafrost")
		SA.RD.AddProperResourceName("ore", "Ore")
		SA.RD.AddProperResourceName("tiberium", "Tiberium")
		SA.RD.AddProperResourceName("metals", "Metals")

		SA.RD.AddProperResourceName("oxygen isotopes", "Oxygen Isotopes")
		SA.RD.AddProperResourceName("hydrogen isotopes", "Hydrogen Isotopes")
		SA.RD.AddProperResourceName("helium isotopes", "Helium Isotopes")
		SA.RD.AddProperResourceName("nitrogen isotopes", "Nitrogen Isotopes")
		SA.RD.AddProperResourceName("carbon isotopes", "Carbon Isotopes")
		SA.RD.AddProperResourceName("strontium clathrates", "Strontium Clathrates")

		SA.RD.AddProperResourceName("blue ice", "Blue Ice")
		SA.RD.AddProperResourceName("clear ice", "Clear Ice")
		SA.RD.AddProperResourceName("glacial mass", "Glacial Mass")
		SA.RD.AddProperResourceName("white glaze", "White Glaze")
		SA.RD.AddProperResourceName("dark glitter", "Dark Glitter")
		SA.RD.AddProperResourceName("glare crust", "Glare Crust")
		SA.RD.AddProperResourceName("gelidus", "Gelidus")
		SA.RD.AddProperResourceName("krystallos", "Krystallos")
	end)

	hook.Run("SA_CAFInitComplete")
end
