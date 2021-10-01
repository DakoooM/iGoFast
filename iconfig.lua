GoFastConfig = {}

-- This Script use BanSQL for Ban (Example : TriggerEvent("BanSql:ICheat", "Auto-Cheat Custom Reason",TargetId)    )
GoFastConfig.BannissementActive = false
GoFastConfig.Bannissement = {
    NamesEventBAN = "BanSql:ICheat",
    ReasonBan = "The Cheater is not here",
    KickMessage = "Anti-Cheat Sécurité | Rendez-vous sur discord"
}

GoFastConfig.PriceRandom = {
    PriceDrogues = math.random(250, 685),
    PriceArgentSale = math.random(150, 580)
}

GoFastConfig.PositionMenu = { {PostionMenu = vector3(125.514, 6644.268, 31.78517)} }

GoFastConfig.RacheteurDrogues = {
    {
     PositionRacheteur = vector3(-63.25835, -1213.338, 27.54354),
    }
}

GoFastConfig.RacheteurArgentSale = {
    {
     PositionRacheteur = vector3(-112.7456, 1881.925, 197.3327),
    }
}

GoFastConfig.PedCoords = {
    {
        PedPos = {125.514, 6644.268, 30.78517, heading = 43.03146},
        ScenarioPeds = "WORLD_HUMAN_GUARD_STAND"
    },
    {
        PedPos = {-63.25835, -1213.338, 27.54354, heading = 299.3559},
        ScenarioPeds = "WORLD_HUMAN_GUARD_STAND"
    },
    {
        PedPos = {-112.7456, 1881.925, 196.3327, heading = 97.2248},
        ScenarioPeds = "WORLD_HUMAN_GUARD_STAND"
    }
}

GoFastConfig.RandomsPedSpawning = {
    "csb_fos_rep",
    "mp_m_exarmy_01",
    "a_m_m_eastsa_02",
    "a_m_y_downtown_01",
}

GoFastConfig.RandomsNamesOfPed = {
    "Marcos", 
    "Blanco", 
    "Rodriguez", 
    "Orejuela"
}

GoFastConfig.MenuSettings = {
    {
        typebtn = "Transport de Drogues",
        difficulter = 0.500,
        randomrenumeration = math.random(250, 685),
        typedetrajet = 1,
        nameveh = "adder",
        spawncoordsveh = vector3(119.0492, 6652.984, 31.61649),
        spawnheading = 130.6943,
    },
    {
        typebtn = "Transport d'Argents Sale",
        difficulter = 0.340,
        randomrenumeration = math.random(150, 580),
        typedetrajet = 2,
        nameveh = "brioso",
        spawncoordsveh = vector3(119.0492, 6652.984, 31.61649),
        spawnheading = 130.6943,
    },
}