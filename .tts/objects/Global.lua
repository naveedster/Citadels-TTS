-- ============================================================
--  CITADELS — Tabletop Simulator Global Script
--  Features: Scenarios, Random, Manual character selection
--  Supports 2–8 players
-- ============================================================

-- ------------------------------------------------------------
--  GUIDs
-- ------------------------------------------------------------
local GUID = {
    assassin='563dd6', witch='b28b42', magistrate='e1aa3c',
    thief='dff2e7', spy='fb9049', blackmailer='5a0d51',
    magician='0c6b16', seer='e31386', wizard='428a9e',
    king='af751d', emperor='38d93e', patrician='e6e4bd',
    bishop='a5b07c', abbot='60f448', cardinal='63cdd9',
    merchant='805c3c', alchemist='0b991f', trader='35f323',
    architect='9281ca', navigator='5b758d', scholar='7317f2',
    warlord='b5cb6b', diplomat='fbe3ec', marshal='0bbb37',
    queen='dd03e0', artist='5ba6d2', taxcollector='d50501',

    assassinToken='711482', witchToken='6de41d', magistrateToken='74f3dd',
    thiefToken='5c7535', spyToken='754046', blackmailerToken='be1915',
    magicianToken='e34170', seerToken='f45379', wizardToken='2fd378',
    kingToken='d0999d', emperorToken='31d3be', patricianToken='95f662',
    bishopToken='be7b87', abbotToken='3a3a2a', cardinalToken='58e369',
    merchantToken='9541ee', alchemistToken='708e38', traderToken='1624fa',
    architectToken='1dfe39', navigatorToken='4370cb', scholarToken='bef0fd',
    warlordToken='860ec5', diplomatToken='814055', marshalToken='5d2bda',
    queenToken='7553d4', artistToken='01cd1d', taxcollectorToken='80d503',

    warrant1='85eac5', warrant2='39ae53', warrant3='9089fb',
    threat1='21d6ca', threat2='32f577',

    uniqueDistricts='d0d04b', districtCards='562430',
    setupBoard='83e8c3', checker2='45f325', bag='72a034', bag2='d7a03f',
}

local KNOWN_RESET_GUIDS = {
    GUID.assassin, GUID.witch, GUID.magistrate,
    GUID.thief, GUID.spy, GUID.blackmailer,
    GUID.magician, GUID.seer, GUID.wizard,
    GUID.king, GUID.emperor, GUID.patrician,
    GUID.bishop, GUID.abbot, GUID.cardinal,
    GUID.merchant, GUID.alchemist, GUID.trader,
    GUID.architect, GUID.navigator, GUID.scholar,
    GUID.warlord, GUID.diplomat, GUID.marshal,
    GUID.queen, GUID.artist, GUID.taxcollector,
    GUID.assassinToken, GUID.witchToken, GUID.magistrateToken,
    GUID.thiefToken, GUID.spyToken, GUID.blackmailerToken,
    GUID.magicianToken, GUID.seerToken, GUID.wizardToken,
    GUID.kingToken, GUID.emperorToken, GUID.patricianToken,
    GUID.bishopToken, GUID.abbotToken, GUID.cardinalToken,
    GUID.merchantToken, GUID.alchemistToken, GUID.traderToken,
    GUID.architectToken, GUID.navigatorToken, GUID.scholarToken,
    GUID.warlordToken, GUID.diplomatToken, GUID.marshalToken,
    GUID.queenToken, GUID.artistToken, GUID.taxcollectorToken,
    GUID.warrant1, GUID.warrant2, GUID.warrant3,
    GUID.threat1, GUID.threat2,
}

-- ------------------------------------------------------------
--  UNIQUE DISTRICT DATA
-- ------------------------------------------------------------
-- Cards that have their own GUID (were outside the deck at some point)
local UNIQUE_GUID = {
    ['Secret Vault']    = '60daeb',
    ['Stables']         = 'f7c60f',
    ['Theater']         = 'f9d4bb',
    ['Library']         = 'efc5fe',
    ['Keep']            = '274e1d',
    ['Haunted Quarter'] = '15775f',
    ['Gold Mine']       = 'bb2580',
    ['Dragon Gate']     = '73dc3e',
    ['Basilica']        = '26959e',
}


-- ============================================================
--  MASTER DISTRICT LOOKUP TABLE
--  Covers all standard + unique districts in the 2021 edition.
--  Used by onObjectDrop so NO card script is needed on any card.
--  Format: [name] = {cost, type}
-- ============================================================
local DISTRICT_DATA = {
    -- ── Noble (yellow) — 12 cards ──
    ['Manor']   = {3,'noble'},
    ['Castle']  = {4,'noble'},
    ['Palace']  = {5,'noble'},
    -- ── Religious (blue) — 11 cards ──
    ['Temple']    = {1,'religious'},
    ['Church']    = {2,'religious'},
    ['Monastery'] = {3,'religious'},
    ['Cathedral'] = {5,'religious'},
    -- ── Trade (green) — 20 cards ──
    ['Tavern']       = {1,'trade'},
    ['Trading Post'] = {2,'trade'},
    ['Market']       = {2,'trade'},
    ['Docks']        = {3,'trade'},
    ['Harbor']       = {4,'trade'},
    ['Town Hall']    = {5,'trade'},
    -- ── Military (red) — 11 cards ──
    ['Watchtower'] = {1,'military'},
    ['Prison']     = {2,'military'},
    ['Barracks']   = {3,'military'},
    ['Fortress']   = {5,'military'},
    -- ── Unique (purple) — all 30 ──
    ['Dragon Gate']        = {6,'unique'}, ['Keep']           = {3,'unique'},
    ['Great Wall']         = {6,'unique'}, ['Laboratory']     = {5,'unique'},
    ['Smithy']             = {5,'unique'}, ['Observatory']    = {4,'unique'},
    ['Library']            = {6,'unique'}, ['School of Magic']= {6,'unique'},
    ['Quarry']             = {5,'unique'}, ['Museum']         = {4,'unique'},
    ['Imperial Treasury']  = {5,'unique'}, ['Map Room']       = {5,'unique'},
    ['Wishing Well']       = {5,'unique'}, ['Monument']       = {4,'unique'},
    ['Treasury']           = {5,'unique'}, ['Poor House']     = {4,'unique'},
    ['Statue']             = {3,'unique'}, ['Capitol']        = {5,'unique'},
    ['Park']               = {6,'unique'}, ['Haunted Quarter']= {2,'unique'},
    ['Factory']            = {5,'unique'}, ['Necropolis']     = {5,'unique'},
    ['Secret Vault']       = {3,'unique'}, ["Thieves' Den"]   = {6,'unique'},
    ['Gold Mine']          = {6,'unique'}, ['Basilica']       = {4,'unique'},
    ['Framework']          = {3,'unique'}, ['Theater']        = {6,'unique'},
    ['Armory']             = {3,'unique'}, ['Ivory Tower']    = {5,'unique'},
    ['Stables']            = {2,'unique'}, -- build does not count toward limit that turn
}

-- TTS player color → display hex
local COLOR_HEX = {
    Red='#FF5555', Orange='#FF9922', Yellow='#FFDD33', Green='#55EE55',
    Teal='#22DDBB', Blue='#5599FF', Purple='#BB66FF', Pink='#FF66CC',
    White='#DDDDDD', Brown='#CC9955', master='#AAAAAA',
}
-- TTS player color → button colors string (normal|hover|pressed|disabled)
local COLOR_BTN = {
    Red    ='#881111|#CC2222|#550000|#881111',
    Orange ='#884400|#CC6600|#552200|#884400',
    Yellow ='#887700|#CCAA00|#554400|#887700',
    Green  ='#116611|#229922|#0A440A|#116611',
    Teal   ='#116655|#229977|#0A4433|#116655',
    Blue   ='#113388|#2255CC|#0A1F55|#113388',
    Purple ='#551188|#8833CC|#330055|#551188',
    Pink   ='#881155|#CC2277|#550033|#881155',
    White  ='#555566|#8888AA|#333344|#555566',
    Brown  ='#664422|#997733|#442211|#664422',
}
local function hexOf(c) return COLOR_HEX[c] or '#CCCCCC' end

-- TTS player color → {r,g,b} (0-1) used for highlightOn()
local COLOR_RGB = {
    Red    = {1.00, 0.33, 0.33},
    Orange = {1.00, 0.60, 0.13},
    Yellow = {1.00, 0.87, 0.20},
    Green  = {0.33, 0.93, 0.33},
    Teal   = {0.13, 0.87, 0.73},
    Blue   = {0.33, 0.60, 1.00},
    Purple = {0.73, 0.40, 1.00},
    Pink   = {1.00, 0.40, 0.80},
    White  = {0.87, 0.87, 0.87},
}



-- Ordered list of all 30 unique district names (for custom selection UI)
local ALL_UNIQUE_NAMES = {
    'Armory','Basilica','Capitol','Dragon Gate','Factory','Framework',
    'Gold Mine','Great Wall','Haunted Quarter','Imperial Treasury','Ivory Tower',
    'Keep','Laboratory','Library','Map Room','Monument','Museum',
    'Necropolis','Observatory','Park','Poor House','Quarry','School of Magic',
    'Secret Vault','Smithy','Stables','Statue',"Thieves' Den",'Theater',
    'Treasury','Wishing Well',
}

-- Build a set from a list for O(1) lookup
local function makeSet(list)
    local s = {}
    for _,v in ipairs(list) do s[v] = true end
    return s
end


-- ------------------------------------------------------------
--  CHARACTER DATA
-- ------------------------------------------------------------

-- All ranks, each with their 3 options in order
-- Index in outer table = rank number
local RANKS = {
    {GUID.assassin,  GUID.witch,     GUID.magistrate},
    {GUID.thief,     GUID.spy,       GUID.blackmailer},
    {GUID.magician,  GUID.seer,      GUID.wizard},
    {GUID.king,      GUID.emperor,   GUID.patrician},
    {GUID.bishop,    GUID.abbot,     GUID.cardinal},
    {GUID.merchant,  GUID.alchemist, GUID.trader},
    {GUID.architect, GUID.navigator, GUID.scholar},
    {GUID.warlord,   GUID.diplomat,  GUID.marshal},
    {GUID.queen,     GUID.artist,    GUID.taxcollector},
}

local CHAR_RANK = {
    [GUID.assassin]=1,[GUID.witch]=1,[GUID.magistrate]=1,
    [GUID.thief]=2,[GUID.spy]=2,[GUID.blackmailer]=2,
    [GUID.magician]=3,[GUID.seer]=3,[GUID.wizard]=3,
    [GUID.king]=4,[GUID.emperor]=4,[GUID.patrician]=4,
    [GUID.bishop]=5,[GUID.abbot]=5,[GUID.cardinal]=5,
    [GUID.merchant]=6,[GUID.alchemist]=6,[GUID.trader]=6,
    [GUID.architect]=7,[GUID.navigator]=7,[GUID.scholar]=7,
    [GUID.warlord]=8,[GUID.diplomat]=8,[GUID.marshal]=8,
    [GUID.queen]=9,[GUID.artist]=9,[GUID.taxcollector]=9,
}

local CHAR_NAME = {
    [GUID.assassin]='Assassin',[GUID.witch]='Witch',[GUID.magistrate]='Magistrate',
    [GUID.thief]='Thief',[GUID.spy]='Spy',[GUID.blackmailer]='Blackmailer',
    [GUID.magician]='Magician',[GUID.seer]='Seer',[GUID.wizard]='Wizard',
    [GUID.king]='King',[GUID.emperor]='Emperor',[GUID.patrician]='Patrician',
    [GUID.bishop]='Bishop',[GUID.abbot]='Abbot',[GUID.cardinal]='Cardinal',
    [GUID.merchant]='Merchant',[GUID.alchemist]='Alchemist',[GUID.trader]='Trader',
    [GUID.architect]='Architect',[GUID.navigator]='Navigator',[GUID.scholar]='Scholar',
    [GUID.warlord]='Warlord',[GUID.diplomat]='Diplomat',[GUID.marshal]='Marshal',
    [GUID.queen]='Queen',[GUID.artist]='Artist',[GUID.taxcollector]='Tax Collector',
}

local CHAR_TOKEN = {
    [GUID.assassin]=GUID.assassinToken,[GUID.witch]=GUID.witchToken,[GUID.magistrate]=GUID.magistrateToken,
    [GUID.thief]=GUID.thiefToken,[GUID.spy]=GUID.spyToken,[GUID.blackmailer]=GUID.blackmailerToken,
    [GUID.magician]=GUID.magicianToken,[GUID.seer]=GUID.seerToken,[GUID.wizard]=GUID.wizardToken,
    [GUID.king]=GUID.kingToken,[GUID.emperor]=GUID.emperorToken,[GUID.patrician]=GUID.patricianToken,
    [GUID.bishop]=GUID.bishopToken,[GUID.abbot]=GUID.abbotToken,[GUID.cardinal]=GUID.cardinalToken,
    [GUID.merchant]=GUID.merchantToken,[GUID.alchemist]=GUID.alchemistToken,[GUID.trader]=GUID.traderToken,
    [GUID.architect]=GUID.architectToken,[GUID.navigator]=GUID.navigatorToken,[GUID.scholar]=GUID.scholarToken,
    [GUID.warlord]=GUID.warlordToken,[GUID.diplomat]=GUID.diplomatToken,[GUID.marshal]=GUID.marshalToken,
    [GUID.queen]=GUID.queenToken,[GUID.artist]=GUID.artistToken,[GUID.taxcollector]=GUID.taxcollectorToken,
}

local BANNED_2P  = { [GUID.emperor]=true }
local REQUIRES_5P = { [GUID.queen]=true }

-- ------------------------------------------------------------
--  SCENARIOS  (from the rulebook, page 9)
--  Each entry is one GUID per rank 1–8.
--  rank9 = optional rank 9 GUID (nil if not used).
--  desc  = flavour text shown in the UI.
-- ------------------------------------------------------------
local SCENARIOS = {
    {
        name  = 'First Game',
        desc  = 'The recommended introductory cast.',
        chars = {
            GUID.assassin,  -- rank 1
            GUID.thief,     -- rank 2
            GUID.magician,  -- rank 3
            GUID.king,      -- rank 4
            GUID.bishop,    -- rank 5
            GUID.merchant,  -- rank 6
            GUID.architect, -- rank 7
            GUID.warlord,   -- rank 8
        },
        rank9 = nil,
        uniqueDistricts = {
            'Dragon Gate','Factory','Haunted Quarter','Imperial Treasury',
            'Keep','Laboratory','Library','Map Room','Quarry','School of Magic',
            'Smithy','Statue',"Thieves' Den",'Wishing Well',
        },
    },
    {
        name  = 'Ambitious Aristocrats',
        desc  = 'Focuses on building districts with many ways to build multiple per turn.',
        chars = {
            GUID.magistrate, -- rank 1
            GUID.thief,      -- rank 2
            GUID.wizard,     -- rank 3
            GUID.patrician,  -- rank 4
            GUID.bishop,     -- rank 5
            GUID.trader,     -- rank 6
            GUID.architect,  -- rank 7
            GUID.marshal,    -- rank 8
        },
        rank9 = GUID.queen,
        uniqueDistricts = {
            'Capitol','Factory','Framework','Great Wall','Haunted Quarter',
            'Keep','Necropolis','Park','Poor House','Quarry',
            'School of Magic','Stables','Statue',"Thieves' Den",
        },
    },
    {
        name  = 'Cunning Agents',
        desc  = 'Strong direct confrontation with tricksy, zany twists.',
        chars = {
            GUID.witch,      -- rank 1
            GUID.blackmailer,-- rank 2
            GUID.magician,   -- rank 3
            GUID.emperor,    -- rank 4
            GUID.abbot,      -- rank 5
            GUID.alchemist,  -- rank 6
            GUID.architect,  -- rank 7
            GUID.warlord,    -- rank 8
        },
        rank9 = GUID.taxcollector,
        uniqueDistricts = {
            'Armory','Basilica','Dragon Gate','Gold Mine','Keep',
            'Monument','Museum','Necropolis','Park','Poor House',
            'Quarry','Secret Vault','Smithy','Theater',
        },
    },
    {
        name  = 'Devious Dignitaries',
        desc  = 'Bluff, outguess, and outmaneuver sinister machinations.',
        chars = {
            GUID.magistrate, -- rank 1
            GUID.blackmailer,-- rank 2
            GUID.wizard,     -- rank 3
            GUID.king,       -- rank 4
            GUID.abbot,      -- rank 5
            GUID.alchemist,  -- rank 6
            GUID.navigator,  -- rank 7
            GUID.marshal,    -- rank 8
        },
        rank9 = GUID.queen,
        uniqueDistricts = {
            'Dragon Gate','Factory','Framework','Haunted Quarter','Laboratory',
            'Necropolis','Park','Poor House','Secret Vault','Smithy',
            'Stables','Theater',"Thieves' Den",'Wishing Well',
        },
    },
    {
        name  = 'Illustrious Emissaries',
        desc  = 'Less aggressive; defend holdings and gather from unconventional sources.',
        chars = {
            GUID.witch,      -- rank 1
            GUID.spy,        -- rank 2
            GUID.seer,       -- rank 3
            GUID.emperor,    -- rank 4
            GUID.bishop,     -- rank 5
            GUID.merchant,   -- rank 6
            GUID.scholar,    -- rank 7
            GUID.diplomat,   -- rank 8
        },
        rank9 = GUID.artist,
        uniqueDistricts = {
            'Factory','Framework','Great Wall','Haunted Quarter','Ivory Tower',
            'Keep','Library','Museum','Observatory','Park',
            'Poor House','Quarry','School of Magic','Smithy',
        },
    },
    {
        name  = 'Tenacious Delegates',
        desc  = 'Maximize character combos and district synergies to their fullest.',
        chars = {
            GUID.assassin,   -- rank 1
            GUID.spy,        -- rank 2
            GUID.seer,       -- rank 3
            GUID.king,       -- rank 4
            GUID.cardinal,   -- rank 5
            GUID.trader,     -- rank 6
            GUID.scholar,    -- rank 7
            GUID.diplomat,   -- rank 8
        },
        rank9 = GUID.artist,
        uniqueDistricts = {
            'Basilica','Capitol','Haunted Quarter','Imperial Treasury','Laboratory',
            'Library','Map Room','Observatory','School of Magic','Secret Vault',
            'Smithy','Stables','Statue','Wishing Well',
        },
    },
    {
        name  = 'Vicious Nobles',
        desc  = 'A no-holds-barred fight of brutal aggression. Not for the faint of heart.',
        chars = {
            GUID.assassin,   -- rank 1
            GUID.thief,      -- rank 2
            GUID.magician,   -- rank 3
            GUID.patrician,  -- rank 4
            GUID.cardinal,   -- rank 5
            GUID.merchant,   -- rank 6
            GUID.navigator,  -- rank 7
            GUID.warlord,    -- rank 8
        },
        rank9 = GUID.taxcollector,
        uniqueDistricts = {
            'Armory','Basilica','Dragon Gate','Gold Mine','Imperial Treasury',
            'Ivory Tower','Laboratory','Map Room','Monument','Museum',
            'School of Magic','Statue',"Thieves' Den",'Wishing Well',
        },
    },
}

-- ------------------------------------------------------------
--  POSITIONS  — adjust X/Z to match your table
-- ------------------------------------------------------------
local PLAYER_POS = {
    White  = {x= 18.74, y=0.97, z=-27.75},
    Pink   = {x= 45.99, y=0.97, z=-12.80},
    Red    = {x=-19.95, y=0.97, z=-27.63},
    Orange = {x=-45.92, y=0.98, z=-14.17},
    Yellow = {x=-45.87, y=0.98, z= 12.10},
    Green  = {x=-18.24, y=0.97, z= 28.21},  -- fixed double-minus typo
    Blue   = {x= 19.62, y=0.97, z= 28.09},
    Purple = {x= 45.90, y=0.97, z= 15.02},  -- right side, mirrors Yellow
}

local DISCARD_UP_POS   = {x=-4,  y=1.5, z= 2}   -- left of bowl, face-up discards
local DISCARD_DOWN_POS = {x= 4,  y=1.5, z= 2}   -- right of bowl, face-down discard
local STAGING_POS      = {x=-18, y=1.5, z=-4}   -- left edge, clear of bowl and hand zones
local TOKEN_ROW_POS    = {x=-16, y=1.5, z= 8}   -- row of char tokens, away from bowl
local MARKER_POS = {
    warrant = {x= 12, y=3.0, z=-8},
    threat  = {x= 16, y=3.0, z=-8},
}
local CARD_SPREAD_GAP  = 2.4
local CITY_DISTRICT_GAP = 4.1
local CITY_BOT_ROW_SIZE = 4
local CITY_BOT_ROW_GAP  = 5.8
local CITY_ROW_OFFSET   = 6
local CITY_SIDE_INSET   = 2.8
local TOKEN_SPREAD_GAP  = 4.2
local LIFT_Y           = 8    -- height to fly over hand zones (table surface ~y=1)

-- Return a stable staging slot for a character card during round setup.
-- Using fixed slots prevents cards from piling together and auto-stacking.
local function charStagingPos(slotIndex, rowOffset)
    local idx = math.max(0, (slotIndex or 1) - 1)
    local row = rowOffset or 0
    return {
        x = STAGING_POS.x + (idx % 9) * CARD_SPREAD_GAP,
        y = STAGING_POS.y,
        z = STAGING_POS.z + row * 3.5 + math.floor(idx / 9) * 3.5,
    }
end

-- Exact centre of each player's hand zone (measured in-game).
-- Use these when placing cards directly into a player's hand.
local HAND_POS = {
    White  = {x= 18.58, y=2.75, z=-41.07},
    Red    = {x=-16.68, y=2.75, z=-40.89},
    Orange = {x=-58.05, y=2.75, z=-11.73},
    Yellow = {x=-58.34, y=2.75, z= 11.73},
    Green  = {x=-19.99, y=2.75, z= 40.92},
    Blue   = {x= 19.62, y=2.75, z= 40.85},
    Purple = {x= 58.11, y=2.75, z= 11.73},
    Pink   = {x= 58.07, y=2.75, z=-11.73},
}

-- ------------------------------------------------------------
--  GAME STATE
-- ------------------------------------------------------------
local G = {
    phase='SETUP', playerCount=0, players={}, crownIndex=1,
    roundNumber=0, gameOver=false, completedFirst=nil,
    debugMode = false,             -- enable via setup toggle; writes to console (visible to all!)
    autoEndTurn = false,           -- auto-end human turns when no legal actions remain
    resetting = false,             -- suppress callbacks while the table is being reset

    -- Setup choices
    -- mode: 'scenario' | 'random' | 'manual'
    setupMode       = 'scenario',
    scenarioIndex   = 1,           -- which scenario is selected (1–4)
    -- For manual mode: one selected GUID per rank (index = rank number)
    manualSelection = {nil,nil,nil,nil,nil,nil,nil,nil,nil},
    includeRank9    = false,       -- rank-9 toggle (scenario/random/manual)
    -- Unique district mode: 'scenario' | 'custom' | 'alluniques'
    uniqueMode      = 'scenario',
    randomizeUniques = false,      -- if true, use a random scenario-sized unique package from all 30
    customUniques   = {},          -- [districtName]=true for custom selection

    -- Resolved cast for this game (9 GUIDs, one per rank, nil = not used)
    gameCast        = {},

    -- Selection phase
    activeCharGuids={}, selectionOrder={}, selectionStep=0, chosenBy={},
    selectionBusy=false,  -- guard against double-clicks on btnReady
    botSeenChars={},      -- per-round public character cards each bot saw during draft

    -- Turn phase
    turnOrder={}, turnStep=0, currentColor=nil, hasGathered=false,
    currentChar=nil,       -- GUID of the current character card
    turnAdvancePending=false, -- true once end-turn has queued the next reveal
    roundEnding=false,        -- true while the round cleanup / next-round handoff is running
    buildCount=0,          -- districts built this turn
    buildLimit=1,          -- build limit (Architect=3, Seer=2, Scholar=2, Navigator=0)
    extraBuildSpent=false, -- Architect already used extra build
    seerReturnTargets={},  -- [color]=true for players who still need a Seer return
    mustDiscardShuffle=false, -- true when pending discards should be shuffled back after the last return

    -- Ability state (reset each round)
    targeting=nil,         -- active targeting mode string, or nil
    killedChar=nil,        -- GUID killed by Assassin
    bewitchedChar=nil,     -- GUID bewitched by Witch
    witchColor=nil,        -- color of the Witch player
    robbedChar=nil,        -- GUID targeted by Thief
    thiefColor=nil,        -- color of the Thief player
    taxGold=0,             -- gold on Tax Collector's plate (carries over between rounds)
    taxInCast=false,       -- true when Tax Collector is in this game's cast
    taxCollectorColor=nil, -- color of Tax Collector player
    alchemistGold=0,       -- gold spent building this turn (for refund)
    abilityUsed=false,     -- generic: rank ability already used this turn
    beautified={},         -- districts already beautified this game (Artist)
    beautifyCoins={},      -- [color][districtName] = beautify coin GUID
    beautifyCoinMeta={},   -- [coinGuid] = { color=ownerColor, districtName=name }

    -- Per-player
    gold={}, citySize={}, cityScore={}, cityTypes={},
    buildTypes={},         -- tracks built district types per player for Trader/income
    uniqueBuilt={},        -- [color][districtName]=true for unique districts built
    cityCosts={},          -- [color] = list of built district costs (for Basilica)
    museumCards={},        -- [color] = number of cards placed under Museum
    labUsed=false, labPending=false, labPendingDiscarded=false, labPendingCardName=nil,
    frameworkPendingBuild=nil, frameworkMode=false, frameworkResume=false,
    smithyUsed=false,                  -- Smithy turn state
    necropolisMode=false,  necropolisUsed=false,
    theaterUsed={},        -- [color]=true when used this turn
}

-- ------------------------------------------------------------
--  HELPERS
-- ------------------------------------------------------------
local function log(msg) printToAll('[Citadels] '..msg,{1,0.9,0.4}) end
local function logTo(c, msg)
    -- Guard: printToColor crashes if no player is seated at that color
    if not c or not Player[c] or not Player[c].seated then return end
    printToColor('[Citadels] '..msg, c, {1,1,0.6})
end

-- Debug logging: only writes to the scripting console when G.debugMode is enabled.
-- Uses print() NOT log() — print() goes to console only (host/modder view).
-- log() in this codebase is a wrapper around printToAll which broadcasts to all players.
local function debugLog(msg)
    if G.debugMode then print('[DEBUG] '..msg) end
end
local function obj(guid) if not guid or guid == '' then return nil end return getObjectFromGUID(guid) end
local RESET_DECK_ANCHORS = {district=nil, unique=nil}
local RESET_HOME = {}

local function normCardName(s)
    return (s or ''):match('^%s*(.-)%s*$') or ''
end

local function captureKnownResetHomes()
    for _, guid in ipairs(KNOWN_RESET_GUIDS) do
        local o = obj(guid)
        if o and not RESET_HOME[guid] then
            RESET_HOME[guid] = {
                position = o.getPosition(),
                rotation = o.getRotation(),
            }
        end
    end
end

local function playerCanUseHandApi(p)
    return p and p.seated
end

local function getPlayerHandObjectsForReset(color)
    local p = Player[color]
    if not p then return nil, {} end
    local hand = {}
    pcall(function() hand = p.getHandObjects() or {} end)
    return p, hand
end

local function liftHandObjectOutOfZone(color, hobj)
    if not hobj then return end
    local dest = PLAYER_POS[color] and {x=PLAYER_POS[color].x, y=PLAYER_POS[color].y + 4, z=PLAYER_POS[color].z - 5}
              or STAGING_POS
    pcall(function()
        hobj.setPosition(dest)
    end)
end

local function detachHandObjectForReset(color, p, hobj)
    liftHandObjectOutOfZone(color, hobj)
end

local function captureDeckResetAnchors()
    local districtDeck = obj(GUID.districtCards)
    if districtDeck and not RESET_DECK_ANCHORS.district then
        RESET_DECK_ANCHORS.district = {
            position = districtDeck.getPosition(),
            rotation = districtDeck.getRotation(),
        }
    end
    local uniqueDeck = obj(GUID.uniqueDistricts)
    if uniqueDeck and not RESET_DECK_ANCHORS.unique then
        RESET_DECK_ANCHORS.unique = {
            position = uniqueDeck.getPosition(),
            rotation = uniqueDeck.getRotation(),
        }
    end
end

local function districtDeckKindForName(name)
    local d = DISTRICT_DATA[normCardName(name)]
    if not d then return nil end
    return (d[2] == 'unique') and 'unique' or 'standard'
end

-- Find the district card deck by GUID first; if the deck was recreated (GUID
-- changed because it ran empty and was rebuilt), fall back to scanning the table
-- for the largest deck of district cards.
local function findDistrictDeck()
    local d = getObjectFromGUID(GUID.districtCards)
    if d then return d end
    -- Fallback: find the biggest deck containing known district cards
    local best, bestN = nil, 0
    for _, o in ipairs(getAllObjects()) do
        pcall(function()
            if o.type == 'Deck' then
                local ok, contents = pcall(function() return o.getObjects() end)
                if ok and contents and #contents > bestN then
                    -- Verify at least one card is a known district
                    for _, entry in ipairs(contents) do
                        if DISTRICT_DATA[entry.name or ''] then
                            best = o; bestN = #contents; break
                        end
                    end
                end
            end
        end)
    end
    if best then
        log('District deck relocated — updating GUID from '..GUID.districtCards..' to '..best.getGUID())
        GUID.districtCards = best.getGUID()
    end
    return best
end

local function findUniqueDeck()
    local d = getObjectFromGUID(GUID.uniqueDistricts)
    if d then return d end
    local best, bestN = nil, 0
    for _, o in ipairs(getAllObjects()) do
        pcall(function()
            local uniqueCount = 0
            local directKind = districtDeckKindForName(o.getName() or '')
            if directKind == 'unique' then
                uniqueCount = 1
            elseif o.type == 'Deck' or o.type == 'DeckCustom' then
                local ok, contents = pcall(function() return o.getObjects() end)
                if ok and contents then
                    for _, entry in ipairs(contents) do
                        if districtDeckKindForName(entry.name or '') == 'unique' then
                            uniqueCount = uniqueCount + 1
                        end
                    end
                end
            end
            if uniqueCount > bestN then
                best = o
                bestN = uniqueCount
            end
        end)
    end
    if best then
        debugLog('Unique deck relocated â€” updating GUID from '..GUID.uniqueDistricts..' to '..best.getGUID())
        GUID.uniqueDistricts = best.getGUID()
    end
    return best
end

local function districtResetAnchor(kind)
    if kind == 'unique' then return RESET_DECK_ANCHORS.unique end
    if kind == 'standard' then return RESET_DECK_ANCHORS.district end
    return nil
end

local function districtHomeSpawnPos(kind, lift)
    local anchor = districtResetAnchor(kind)
    if not anchor or not anchor.position then return nil end
    return {
        x = anchor.position.x,
        y = anchor.position.y + (lift or 1.5),
        z = anchor.position.z,
    }
end

local function nearAnchorXZ(pos, anchor, radius)
    if not pos or not anchor or not anchor.position then return false end
    local r = radius or 1.5
    local dx = (pos.x or 0) - (anchor.position.x or 0)
    local dz = (pos.z or 0) - (anchor.position.z or 0)
    return (dx * dx + dz * dz) <= (r * r)
end

local function districtHomeKindForObject(o)
    if not o then return nil end
    local pos = nil
    pcall(function() pos = o.getPosition() end)
    if nearAnchorXZ(pos, RESET_DECK_ANCHORS.district, 1.5) then return 'standard' end
    if nearAnchorXZ(pos, RESET_DECK_ANCHORS.unique, 1.5) then return 'unique' end
    return nil
end

local function moveDistrictCardToHomeDeck(cardObj, kind)
    if not cardObj or not kind then return false end
    local anchor = districtResetAnchor(kind)
    local dest = districtHomeSpawnPos(kind, 1.5)
    if not anchor or not dest then return false end
    local moved = false
    pcall(function()
        cardObj.setRotation(anchor.rotation)
        cardObj.setPosition(dest)
        moved = true
    end)
    return moved
end

local function restoreDistrictCardsToHomeDecks()
    captureDeckResetAnchors()

    local function extractCarrierDistrictCards(carrier)
        if not carrier or (carrier.type ~= 'Deck' and carrier.type ~= 'DeckCustom') then return 0 end
        local ok, contents = pcall(function() return carrier.getObjects() end)
        if not ok or not contents or #contents == 0 then return 0 end
        local carrierHomeKind = districtHomeKindForObject(carrier)
        local moved = 0
        for _, entry in ipairs(contents) do
            local kind = districtDeckKindForName(entry.name or '')
            if kind and carrierHomeKind ~= kind then
                local extracted = nil
                pcall(function()
                    extracted = carrier.takeObject({
                        guid = entry.guid,
                        position = districtHomeSpawnPos(kind, 2.0) or carrier.getPosition(),
                        smooth = false,
                        flip = false,
                    })
                end)
                if extracted and moveDistrictCardToHomeDeck(extracted, kind) then
                    moved = moved + 1
                end
            end
        end
        return moved
    end

    local function sweepTopLevelObjects()
        local moved = 0
        for _, o in ipairs(getAllObjects()) do
            local kind = districtDeckKindForName(o.getName() or '')
            if kind then
                if districtHomeKindForObject(o) ~= kind and moveDistrictCardToHomeDeck(o, kind) then
                    moved = moved + 1
                end
            else
                moved = moved + extractCarrierDistrictCards(o)
            end
        end
        return moved
    end

    sweepTopLevelObjects()
    sweepTopLevelObjects()
end

-- ── Helper: send a district card to the BOTTOM of the district deck ──────────
-- TTS putObject() always adds to the top. To insert at the bottom we teleport
-- the card just below the deck's lowest face so physics merges it underneath.
local function discardToBottom(cardObj)
    if not cardObj then return end
    pcall(function()
        cardObj.setRotation({0, 0, 180})   -- face-down
        local deck = findDistrictDeck()
        if deck then
            local dp = deck.getPosition()
            cardObj.setPosition({
                dp.x + (math.random() - 0.5) * 0.08,
                dp.y - 1.0,   -- below the deck so TTS merges at bottom
                dp.z + (math.random() - 0.5) * 0.08,
            })
        else
            cardObj.setPosition({DISCARD_DOWN_POS.x, DISCARD_DOWN_POS.y, DISCARD_DOWN_POS.z})
        end
    end)
end

local function shuffle(t)
    for i=#t,2,-1 do local j=math.random(i); t[i],t[j]=t[j],t[i] end
end

local function removeValue(t,val)
    for i,v in ipairs(t) do if v==val then table.remove(t,i); return end end
end

local function cityThreshold()
    return (G.playerCount<=3) and 8 or 7
end

-- Return how much this district contributes toward city completion.
-- Most districts count as 1, Stables counts as 0, and Monument counts as 2.
local function districtCompletionValue(distName)
    if distName == 'Stables' then return 0 end
    if distName == 'Monument' then return 2 end
    return 1
end

-- Add this district's completion value to the player's city-size tracker.
local function addCityCompletion(color, distName)
    G.citySize[color] = (G.citySize[color] or 0) + districtCompletionValue(distName)
end

-- Remove this district's completion value from the player's city-size tracker.
local function removeCityCompletion(color, distName)
    G.citySize[color] = math.max(0, (G.citySize[color] or 0) - districtCompletionValue(distName))
end

-- Flexible districts can impersonate different types at end-game scoring.
-- This helper picks the assignment that maximizes the 5-type bonus and then
-- minimizes remaining unique count for Ivory Tower / Wishing Well scoring.
local function optimizeFlexibleTypeScoring(color)
    local builtTypes = G.buildTypes and G.buildTypes[color] or {}
    local uniqueBuilt = G.uniqueBuilt and G.uniqueBuilt[color] or {}
    local baseCounts = {
        noble = builtTypes.noble or 0,
        religious = builtTypes.religious or 0,
        trade = builtTypes.trade or 0,
        military = builtTypes.military or 0,
        unique = builtTypes.unique or 0,
    }

    local flexible = {}
    if uniqueBuilt['Haunted Quarter'] then table.insert(flexible, 'Haunted Quarter') end
    if uniqueBuilt['School of Magic'] then table.insert(flexible, 'School of Magic') end

    local options = {'unique', 'noble', 'religious', 'trade', 'military'}
    local best = nil
    local current = {}

    local function evaluate()
        local counts = {
            noble = baseCounts.noble,
            religious = baseCounts.religious,
            trade = baseCounts.trade,
            military = baseCounts.military,
            unique = baseCounts.unique,
        }
        for _, name in ipairs(flexible) do
            local choice = current[name] or 'unique'
            if choice ~= 'unique' then
                counts.unique = math.max(0, counts.unique - 1)
                counts[choice] = counts[choice] + 1
            end
        end

        local typeCount = 0
        for _, dtype in ipairs({'noble','religious','trade','military','unique'}) do
            if (counts[dtype] or 0) > 0 then typeCount = typeCount + 1 end
        end
        local uniqueCount = counts.unique or 0

        if not best
           or typeCount > best.typeCount
           or (typeCount == best.typeCount and uniqueCount < best.uniqueCount) then
            best = {typeCount = typeCount, uniqueCount = uniqueCount}
        end
    end

    local function walk(idx)
        if idx > #flexible then
            evaluate()
            return
        end
        local name = flexible[idx]
        for _, choice in ipairs(options) do
            current[name] = choice
            walk(idx + 1)
        end
    end

    walk(1)
    return best or {typeCount = 0, uniqueCount = 0}
end

local function contains(t,val)
    for _,v in ipairs(t) do if v==val then return true end end
    return false
end

-- Moves an object in two steps: lift straight up to LIFT_Y, then glide to dest.
-- This clears all hand zones which are flat volumes near table height.
-- delay = extra seconds before the lift (default 0)
local function liftThenPlace(o, dest, delay)
    if not o then return end
    -- Guard: object may be in a hand zone or otherwise invalid — use pcall
    local ok, src = pcall(function() return o.getPosition() end)
    if not ok or not src then return end
    delay = delay or 0
    local function doMove()
        local ok2 = pcall(function()
            o.setPositionSmooth({x=src.x, y=LIFT_Y, z=src.z}, false, false)
        end)
        if not ok2 then return end
        Wait.time(function()
            pcall(function()
                o.setPositionSmooth(dest, false, false)
            end)
        end, 0.6)
    end
    if delay > 0 then Wait.time(doMove, delay) else doMove() end
end

-- Returns the standard city placement destination/rotation for a player's district.
-- Side seats need the yaw reversed so the card reads correctly without flipping it over.
local function cityDistrictAnchor(color)
    local pos = PLAYER_POS[color]
    if not pos then return nil end
    local isSideSeat = math.abs(pos.x) > 40
    return {
        x = isSideSeat and (pos.x + ((pos.x > 0) and -CITY_SIDE_INSET or CITY_SIDE_INSET)) or pos.x,
        y = pos.y,
        z = pos.z + CITY_ROW_OFFSET,
    }
end

local function cityUsesBotRows(color)
    return G.bots and G.bots[color] == true
end

local function cityBotPrimaryDirection(color)
    local pos = PLAYER_POS[color]
    if not pos then return 1 end
    if math.abs(pos.x) > 40 then
        return (pos.z < 0) and 1 or -1
    end
    return 1
end

local function cityBotSecondaryDirection(color)
    local pos = PLAYER_POS[color]
    if not pos then return 1 end
    if math.abs(pos.x) > 40 then
        return (pos.x > 0) and -1 or 1
    end
    return (pos.z > 0) and -1 or 1
end

local function cityDistrictPlacement(color, slotIndex)
    local pos = PLAYER_POS[color]
    local anchor = cityDistrictAnchor(color)
    if not pos or not anchor then return nil, nil end
    local slot = math.max(0, math.floor(slotIndex or 0))
    if cityUsesBotRows(color) then
        local col = slot % CITY_BOT_ROW_SIZE
        local row = math.floor(slot / CITY_BOT_ROW_SIZE)
        local colOffset = (col - (CITY_BOT_ROW_SIZE - 1) * 0.5) * CITY_DISTRICT_GAP
        local rowOffset = row * CITY_BOT_ROW_GAP * cityBotSecondaryDirection(color)
        if math.abs(pos.x) > 40 then
            local primaryDir = cityBotPrimaryDirection(color)
            return {
                x = anchor.x + rowOffset,
                y = anchor.y,
                z = anchor.z + colOffset * primaryDir,
            }, {
                0,
                (pos.x > 0) and 90 or 270,
                0,
            }
        end
        return {
            x = anchor.x + colOffset,
            y = anchor.y,
            z = anchor.z + rowOffset,
        }, {
            0,
            (pos.z < 0) and 180 or 0,
            0,
        }
    end
    local spread = math.max(0, slotIndex or 0) * CITY_DISTRICT_GAP
    if math.abs(pos.x) > 40 then
        return {
            x = anchor.x,
            y = anchor.y,
            z = anchor.z + spread,
        }, {
            0,
            (pos.x > 0) and 90 or 270,
            0,
        }
    end
    return {
        x = anchor.x + spread,
        y = anchor.y,
        z = anchor.z,
    }, {
        0,
        (pos.z < 0) and 180 or 0,
        0,
    }
end

local function citySlotIndexFromPosition(color, objPos)
    local pos = PLAYER_POS[color]
    local anchor = cityDistrictAnchor(color)
    if not pos or not anchor or not objPos then return nil end
    local laneTol = CITY_DISTRICT_GAP * 0.9
    if cityUsesBotRows(color) then
        local colTol = CITY_DISTRICT_GAP * 0.75
        local rowTol = CITY_BOT_ROW_GAP * 0.75
        local centerCol = (CITY_BOT_ROW_SIZE - 1) * 0.5
        if math.abs(pos.x) > 40 then
            local primaryDir = cityBotPrimaryDirection(color)
            local secondaryDir = cityBotSecondaryDirection(color)
            local colRel = ((objPos.z - anchor.z) * primaryDir) / CITY_DISTRICT_GAP
            local col = math.floor(colRel + centerCol + 0.5)
            local rowRel = ((objPos.x - anchor.x) * secondaryDir) / CITY_BOT_ROW_GAP
            local row = math.floor(rowRel + 0.5)
            if col < 0 or col >= CITY_BOT_ROW_SIZE or row < 0 then return nil end
            local expectedZ = anchor.z + (col - centerCol) * CITY_DISTRICT_GAP * primaryDir
            local expectedX = anchor.x + row * CITY_BOT_ROW_GAP * secondaryDir
            if math.abs(objPos.z - expectedZ) > colTol or math.abs(objPos.x - expectedX) > rowTol then return nil end
            return row * CITY_BOT_ROW_SIZE + col
        end
        local secondaryDir = cityBotSecondaryDirection(color)
        local colRel = (objPos.x - anchor.x) / CITY_DISTRICT_GAP
        local col = math.floor(colRel + centerCol + 0.5)
        local rowRel = ((objPos.z - anchor.z) * secondaryDir) / CITY_BOT_ROW_GAP
        local row = math.floor(rowRel + 0.5)
        if col < 0 or col >= CITY_BOT_ROW_SIZE or row < 0 then return nil end
        local expectedX = anchor.x + (col - centerCol) * CITY_DISTRICT_GAP
        local expectedZ = anchor.z + row * CITY_BOT_ROW_GAP * secondaryDir
        if math.abs(objPos.x - expectedX) > colTol or math.abs(objPos.z - expectedZ) > rowTol then return nil end
        return row * CITY_BOT_ROW_SIZE + col
    end
    if math.abs(pos.x) > 40 then
        if math.abs(objPos.x - anchor.x) > laneTol then return nil end
        local rel = (objPos.z - anchor.z) / CITY_DISTRICT_GAP
        local slot = math.floor(rel + 0.5)
        if slot < 0 then return nil end
        local expected = anchor.z + slot * CITY_DISTRICT_GAP
        if math.abs(objPos.z - expected) > laneTol then return nil end
        return slot
    end
    if math.abs(objPos.z - anchor.z) > laneTol then return nil end
    local rel = (objPos.x - anchor.x) / CITY_DISTRICT_GAP
    local slot = math.floor(rel + 0.5)
    if slot < 0 then return nil end
    local expected = anchor.x + slot * CITY_DISTRICT_GAP
    if math.abs(objPos.x - expected) > laneTol then return nil end
    return slot
end

local function cityOccupiedSlots(color, ignoreObj)
    local ignoreGuid = nil
    if type(ignoreObj) == 'string' then
        ignoreGuid = ignoreObj
    elseif ignoreObj and ignoreObj.getGUID then
        pcall(function() ignoreGuid = ignoreObj.getGUID() end)
    end

    local occupied = {}
    for _, o in ipairs(getAllObjects()) do
        pcall(function()
            if ignoreGuid and o.getGUID() == ignoreGuid then return end

            local isDistrictCarrier = DISTRICT_DATA[o.getName() or ''] ~= nil
            if not isDistrictCarrier and (o.type == 'Deck' or o.type == 'DeckCustom') then
                local ok, contents = pcall(function() return o.getObjects() end)
                if ok and contents then
                    for _, entry in ipairs(contents) do
                        if DISTRICT_DATA[entry.name or ''] then
                            isDistrictCarrier = true
                            break
                        end
                    end
                end
            end

            if isDistrictCarrier then
                local slot = citySlotIndexFromPosition(color, o.getPosition())
                if slot ~= nil then occupied[slot] = true end
            end
        end)
    end
    return occupied
end

local function firstOpenCitySlot(color, ignoreObj)
    local occupied = cityOccupiedSlots(color, ignoreObj)
    local slot = 0
    while occupied[slot] do slot = slot + 1 end
    return slot
end

-- District placement should use the first physically open city slot so holes
-- left by destruction/confiscation do not cause future cards to stack.
local function citySlotForAddedDistrict(color, distName)
    return firstOpenCitySlot(color)
end

local function citySlotForPendingDistrict(color, replacingCardObj)
    return firstOpenCitySlot(color, replacingCardObj)
end

local function moveDistrictCardToCity(color, distName, cardObj, delay)
    if not color or not distName or not cardObj then return false end
    local dest, rot = cityDistrictPlacement(color, citySlotForAddedDistrict(color, distName))
    if not dest then return false end
    pcall(function()
        if rot then cardObj.setRotation(rot) end
        liftThenPlace(cardObj, dest, delay or 0)
    end)
    return true
end

-- ------------------------------------------------------------
--  GOLD MANAGEMENT
-- ------------------------------------------------------------
local BOWL_GUID   = 'f95274'
local BOWL_RADIUS = 8   -- search radius around bowl for loose coins
local CROWN_GUID  = '19a682'

-- Return the bowl object's current position (used as the return destination)
local function bowlPos()
    local bowl = getObjectFromGUID(BOWL_GUID)
    if bowl then return bowl.getPosition() end
    return {x=0, y=1, z=0}  -- fallback: table center
end

-- Move the physical crown to the crowned player's area
local function moveCrown(color)
    local crown = getObjectFromGUID(CROWN_GUID)
    local pos   = PLAYER_POS[color]
    if crown and pos then
        liftThenPlace(crown, {x=pos.x, y=pos.y, z=pos.z - 6})
    end
end

-- Collect up to `amount` Gold coins from the bowl area and liftThenPlace them
-- to `dest`. Returns the number actually moved (may be less if supply is short).
local function takeFromBowl(dest, amount)
    local bp   = bowlPos()
    local moved = 0
    for _,o in ipairs(getAllObjects()) do
        if moved >= amount then break end
        pcall(function()
            if o.getName() == 'Gold' then
                local p = o.getPosition()
                if math.sqrt((p.x-bp.x)^2+(p.z-bp.z)^2) <= BOWL_RADIUS then
                    liftThenPlace(o, {
                        x = dest.x + (math.random()-0.5)*1.2,
                        y = dest.y,
                        z = dest.z + (math.random()-0.5)*1.2,
                    }, moved * 0.08)
                    moved = moved + 1
                end
            end
        end)
    end
    if moved < amount then
        log('WARNING: returnToBowl only moved '..moved..'/'..amount..' coins (some may be locked beautify tokens).')
    end
    return moved
end

-- Collect up to `amount` Gold coins from near `src` and return them to the bowl.
local function returnToBowl(src, amount)
    local bp     = bowlPos()
    local radius = 10
    local moved  = 0
    for _,o in ipairs(getAllObjects()) do
        if moved >= amount then break end
        pcall(function()
            if o.getName() == 'Gold' then
                -- Skip coins locked onto beautified district cards
                if G.lockedCoins and G.lockedCoins[o.getGUID()] then return end
                local p = o.getPosition()
                if math.sqrt((p.x-src.x)^2+(p.z-src.z)^2) <= radius then
                    liftThenPlace(o, {
                        x = bp.x + (math.random()-0.5)*2,
                        y = bp.y + 0.5 + moved * 0.1,
                        z = bp.z + (math.random()-0.5)*2,
                    }, moved * 0.08)
                    moved = moved + 1
                end
            end
        end)
    end
    return moved
end

local function giveGold(color, amount)
    G.gold[color] = (G.gold[color] or 0) + amount
    local p = PLAYER_POS[color]
    if p then takeFromBowl({x=p.x, y=p.y, z=p.z-4}, amount) end
    updateGoldUI()
end

local function takeGold(color, amount)
    amount = math.min(amount, G.gold[color] or 0)
    G.gold[color] = (G.gold[color] or 0) - amount
    local p = PLAYER_POS[color]
    if p then returnToBowl({x=p.x, y=p.y, z=p.z-4}, amount) end
    updateGoldUI()
    return amount
end

-- Charge 1g property tax to `taxPayerColor` and place the coin on the Tax Collector token.
-- Called after each successful district build (including free builds).
-- Exempt: the Tax Collector himself. Skipped: player has no gold after building.
-- The tax plate always applies whenever Tax Collector is in the cast.
local function chargeTax(taxPayerColor)
    if not G.taxInCast then return end                       -- TC not in this game's cast
    local tcColor = G.taxCollectorColor                      -- nil if TC not chosen/alive this round
    -- The Tax Collector PLAYER never pays their own tax, regardless of which character
    -- they are currently acting as (rules: "after any other PLAYER builds a district").
    if taxPayerColor == tcColor then return end
    -- Check gold AFTER the build cost was already deducted — if they have none left, no tax
    if (G.gold[taxPayerColor] or 0) <= 0 then return end
    -- Deduct 1g from player's tracked gold
    G.gold[taxPayerColor] = (G.gold[taxPayerColor] or 0) - 1
    G.taxGold = (G.taxGold or 0) + 1
    updateGoldUI()
    local tcNote = tcColor and ('Tax Collector ('..tcColor..')') or 'Tax Collector (not chosen this round)'
    logTo(taxPayerColor, 'PROPERTY TAX: -1g to tax plate. ('..tcNote..' — total on plate: '..G.taxGold..'g.)')
    if tcColor then logTo(tcColor, 'Tax plate: +1g from '..taxPayerColor..' (total: '..G.taxGold..'g).') end

    -- Physical coin: wait ~0.5s so the build-cost coins have lifted off and left the player's
    -- area (liftThenPlace takes ~0.6s to animate). Then grab a coin still near the player
    -- and move it directly to the tax plate. This ensures the player visually loses the
    -- correct number of coins — not just the bowl losing/gaining the same coin.
    local pp      = PLAYER_POS[taxPayerColor]
    local taxSlot = G.taxGold  -- capture current slot before async delay
    Wait.time(function()
        local tcToken = obj(GUID.taxcollectorToken)
        local dest
        if tcToken then
            local tp = tcToken.getPosition()
            dest = {x=tp.x+(math.random()-0.5)*1.0, y=tp.y+0.4+(taxSlot-1)*0.15, z=tp.z+(math.random()-0.5)*1.0}
        else
            dest = {x=0, y=1.5, z=0}  -- fallback: table centre
        end
        -- Try to find a coin still near the player at table level (not in-flight)
        -- liftThenPlace raises coins to y=8 before moving them, so any coin at y < 3
        -- is genuinely resting near the player, not a build-cost coin in transit.
        local moved = false
        if pp then
            for _, o in ipairs(getAllObjects()) do
                if moved then break end
                pcall(function()
                    if o.getName() == 'Gold' then
                        if G.lockedCoins and G.lockedCoins[o.getGUID()] then return end
                        local op = o.getPosition()
                        if op.y < 3 and math.sqrt((op.x-pp.x)^2+(op.z-pp.z)^2) <= 12 then
                            liftThenPlace(o, dest)
                            moved = true
                        end
                    end
                end)
            end
        end
        -- Fallback: if no player coin found (they may have slid away), take from bowl
        if not moved then takeFromBowl(dest, 1) end
    end, 0.55)
end

-- ------------------------------------------------------------
--  CAST RESOLUTION
--  Turns the setup choices into G.gameCast (list of GUIDs, one per rank)
-- ------------------------------------------------------------
local function resolveCast()
    local cast = {}
    local n = G.playerCount

    if G.setupMode == 'scenario' then
        local s = SCENARIOS[G.scenarioIndex]
        for rank, guid in ipairs(s.chars) do
            -- Enforce 2-player ban
            if BANNED_2P[guid] and n==2 then
                -- Fall back to another char at same rank
                for _, alt in ipairs(RANKS[rank]) do
                    if not BANNED_2P[alt] then guid=alt; break end
                end
            end
            cast[rank] = guid
        end
        -- Rank 9: required for 3p/8p regardless of toggle; otherwise respect G.includeRank9
        local r9 = s.rank9
        if r9 and (REQUIRES_5P[r9] and n<5) then r9=nil end -- Queen needs 5+
        local forceRank9 = (n==3 or n==8)
        if forceRank9 then
            -- Must have rank 9; use scenario's if valid, else pick random
            if r9 then cast[9]=r9
            else
                local pool={}
                for _,g in ipairs(RANKS[9]) do
                    if not (REQUIRES_5P[g] and n<5) then table.insert(pool,g) end
                end
                if #pool>0 then cast[9]=pool[math.random(#pool)] end
            end
            if not r9 then log('Rank 9 auto-assigned for '..n..'-player game: '..CHAR_NAME[cast[9]]) end
        elseif G.includeRank9 and r9 then
            cast[9]=r9
        end
        -- If rank 9 was forced off by toggle and it's not a 3/8p game, cast[9] stays nil

    elseif G.setupMode == 'random' then
        for rank=1,8 do
            local pool={}
            for _,g in ipairs(RANKS[rank]) do
                if not (BANNED_2P[g] and n==2) then table.insert(pool,g) end
            end
            cast[rank]=pool[math.random(#pool)]
        end
        -- Rank 9
        local need9 = (n==3 or n==8) or G.includeRank9
        if need9 then
            local pool={}
            for _,g in ipairs(RANKS[9]) do
                if not (REQUIRES_5P[g] and n<5) then table.insert(pool,g) end
            end
            if #pool>0 then cast[9]=pool[math.random(#pool)] end
        end

    elseif G.setupMode == 'manual' then
        for rank=1,9 do
            cast[rank]=G.manualSelection[rank]
        end
        -- Force rank 9 for 3p/8p if not set
        if (n==3 or n==8) and not cast[9] then
            local pool={}
            for _,g in ipairs(RANKS[9]) do
                if not (REQUIRES_5P[g] and n<5) then table.insert(pool,g) end
            end
            if #pool>0 then cast[9]=pool[math.random(#pool)]
                log('Rank 9 auto-assigned for '..n..'-player game: '..CHAR_NAME[cast[9]])
            end
        end
    end

    G.gameCast = cast

    debugLog('Cast for this game:')
    for rank=1,9 do
        if cast[rank] then
            debugLog('  Rank '..rank..': '..CHAR_NAME[cast[rank]])
        end
    end
end

-- ------------------------------------------------------------
--  VALIDATE MANUAL SELECTION
--  Returns true + "" if valid, false + error message if not
-- ------------------------------------------------------------
function configuredPlayerList()
    local seated = getSeatedPlayers()
    for color, isbot in pairs(G.bots or {}) do
        if isbot and PLAYER_POS[color] then
            local already = false
            for _, c in ipairs(seated) do
                if c == color then
                    already = true
                    break
                end
            end
            if not already then table.insert(seated, color) end
        end
    end
    return seated
end

local function validateManual()
    local n = #configuredPlayerList()
    for rank=1,8 do
        if not G.manualSelection[rank] then
            return false, 'Rank '..rank..' has no character selected.'
        end
    end
    -- Check Emperor ban for 2p
    if n==2 and G.manualSelection[4]==GUID.emperor then
        return false, 'Emperor cannot be used in a 2-player game.'
    end
    -- Check Queen requires 5+
    if G.manualSelection[9]==GUID.queen and n<5 then
        return false, 'Queen requires 5+ players.'
    end
    return true, ''
end

-- ============================================================
--  UI — Two panels:
--    1. setupPanel  (character/scenario selection, hidden during game)
--    2. mainPanel   (game controls, always visible)
-- ============================================================

function buildUI()
    -- Build the rank-picker rows for manual mode dynamically
    -- Each rank row has 3 toggle buttons (only one can be active at a time)
    local rankRows = ''
    for rank=1,9 do
        local label = rank==9 and 'Rank 9 (opt):' or 'Rank '..rank..':'
        local btns  = ''
        for col=1,3 do
            local g    = RANKS[rank][col]
            local name = CHAR_NAME[g]
            local short = name:len()>9 and name:sub(1,8)..'' or name
            btns = btns .. string.format(
                '<Button id="mBtn_%d_%d" fontSize="9" color="white" '..
                'colors="#333355|#5555AA|#222244|#333355" '..
                'preferredHeight="26" onClick="onManualBtn">%s</Button>',
                rank, col, short
            )
        end
        rankRows = rankRows .. string.format(
            '<HorizontalLayout spacing="3" preferredHeight="28">'..
            '<Text fontSize="9" color="#AAAAAA" preferredWidth="68" alignment="MiddleRight">%s</Text>'..
            '%s</HorizontalLayout>',
            label, btns
        )
    end

    UI.setXml(string.format([[
<!-- ============================================================
     CITADELS UI
     setupPanel: shown only during SETUP phase
     mainPanel:  always visible during game
============================================================ -->

<!-- SETUP PANEL -->
<Panel id="setupPanel"
       width="320" height="640"
       anchorMin="0.5 0.5" anchorMax="0.5 0.5"
       pivot="0.5 0.5"
       offsetMin="-490 -320" offsetMax="-170 320"
       color="#0d0d1fEE">

  <VerticalLayout spacing="5" padding="10 10 10 10" childAlignment="UpperCenter">

    <HorizontalLayout spacing="4" preferredHeight="28">
      <Text fontSize="15" fontStyle="Bold" color="#FFD700"
            alignment="MiddleLeft" flexibleWidth="1">Character Setup</Text>
      <Button id="btnMinimizeSetup" fontSize="13" color="white"
              colors="#333355|#5566AA|#222244|#333355"
              preferredWidth="28" preferredHeight="28"
              onClick="onBtnMinimizeSetup" tooltip="Minimize / restore this panel">—</Button>
    </HorizontalLayout>


    <!-- Bot Players -->
    <Text fontSize="10" fontStyle="Bold" color="#88CCFF"
          alignment="MiddleCenter" preferredHeight="18">🤖 Computer Players</Text>
    <HorizontalLayout spacing="3" preferredHeight="22">
      <Toggle id="togBot_Red"    fontSize="9" color="#FF6666" preferredHeight="22" onValueChanged="onBotToggle">Red</Toggle>
      <Toggle id="togBot_Green"  fontSize="9" color="#66FF66" preferredHeight="22" onValueChanged="onBotToggle">Green</Toggle>
      <Toggle id="togBot_Blue"   fontSize="9" color="#6699FF" preferredHeight="22" onValueChanged="onBotToggle">Blue</Toggle>
      <Toggle id="togBot_White"  fontSize="9" color="white"   preferredHeight="22" onValueChanged="onBotToggle">White</Toggle>
    </HorizontalLayout>
    <HorizontalLayout spacing="3" preferredHeight="22">
      <Toggle id="togBot_Pink"   fontSize="9" color="#FF88CC" preferredHeight="22" onValueChanged="onBotToggle">Pink</Toggle>
      <Toggle id="togBot_Yellow" fontSize="9" color="#FFEE44" preferredHeight="22" onValueChanged="onBotToggle">Yellow</Toggle>
      <Toggle id="togBot_Orange" fontSize="9" color="#FFAA44" preferredHeight="22" onValueChanged="onBotToggle">Orange</Toggle>
      <Toggle id="togBot_Purple" fontSize="9" color="#CC88FF" preferredHeight="22" onValueChanged="onBotToggle">Purple</Toggle>
    </HorizontalLayout>

    <!-- Mode selector -->
    <HorizontalLayout spacing="4" preferredHeight="34">
      <Button id="btnModeScenario" fontSize="11" color="white"
              colors="#1B6B3A|#27AE60|#145A32|#1B6B3A"
              preferredHeight="34" onClick="onModeScenario"
                tooltip="Choose from preset character combinations.">Scenario</Button>
      <Button id="btnModeRandom" fontSize="11" color="white"
              colors="#333355|#5555AA|#222244|#333355"
              preferredHeight="34" onClick="onModeRandom"
                tooltip="Randomly select 8 characters each round.">Random</Button>
      <Button id="btnModeManual" fontSize="11" color="white"
              colors="#333355|#5555AA|#222244|#333355"
              preferredHeight="34" onClick="onModeManual"
                tooltip="Hand-pick each character for each rank slot.">Manual</Button>
    </HorizontalLayout>

    <!-- ── SCENARIO PANEL ── -->
    <Panel id="paneScenario" color="#00000000" preferredHeight="320">
      <VerticalLayout spacing="4" padding="0 0 0 0" childAlignment="UpperCenter">

        <Text fontSize="11" color="#AADDFF" alignment="MiddleCenter" preferredHeight="20">
          Select a scenario:
        </Text>

        <Button id="btnScen0" fontSize="10" color="white"
                colors="#1B6B3A|#27AE60|#145A32|#1B6B3A"
                preferredHeight="30" onClick="onScenBtn">
          First Game
        </Button>
        <Button id="btnScen1" fontSize="10" color="white"
                colors="#333355|#5555AA|#222244|#333355"
                preferredHeight="30" onClick="onScenBtn">
          Ambitious Aristocrats
        </Button>
        <Button id="btnScen2" fontSize="10" color="white"
                colors="#333355|#5555AA|#222244|#333355"
                preferredHeight="30" onClick="onScenBtn">
          Cunning Agents
        </Button>
        <Button id="btnScen3" fontSize="10" color="white"
                colors="#333355|#5555AA|#222244|#333355"
                preferredHeight="30" onClick="onScenBtn">
          Devious Dignitaries
        </Button>
        <Button id="btnScen4" fontSize="10" color="white"
                colors="#333355|#5555AA|#222244|#333355"
                preferredHeight="30" onClick="onScenBtn">
          Illustrious Emissaries
        </Button>
        <Button id="btnScen5" fontSize="10" color="white"
                colors="#333355|#5555AA|#222244|#333355"
                preferredHeight="30" onClick="onScenBtn">
          Tenacious Delegates
        </Button>
        <Button id="btnScen6" fontSize="10" color="white"
                colors="#333355|#5555AA|#222244|#333355"
                preferredHeight="30" onClick="onScenBtn">
          Vicious Nobles
        </Button>

        <Text id="txtScenDesc" fontSize="10" color="#CCCCCC"
              alignment="MiddleCenter" preferredHeight="44"
              resizeTextForBestFit="false">
          The recommended introductory cast.
        </Text>

        <Text id="txtScenCast" fontSize="10" color="#AAFFAA"
              alignment="MiddleLeft" preferredHeight="160"
              resizeTextForBestFit="false">
        </Text>

        <Toggle id="togRank9Scenario" fontSize="10" color="white"
                preferredHeight="28" onValueChanged="onTogRank9Scenario">
          Include Rank 9
        </Toggle>

        <Text fontSize="9" color="#888888" alignment="MiddleCenter"
              preferredHeight="28" resizeTextForBestFit="false">
          Always included for 3- and 8-player games.
        </Text>

      </VerticalLayout>
    </Panel>

    <!-- ── RANDOM PANEL ── -->
    <Panel id="paneRandom" color="#00000000" preferredHeight="320" active="false">
      <VerticalLayout spacing="6" padding="4 4 4 4" childAlignment="UpperCenter">
        <Text fontSize="12" color="#CCCCCC" alignment="MiddleCenter" preferredHeight="60"
              resizeTextForBestFit="false">
          One random character per rank will be chosen when the game starts.
        </Text>
        <Toggle id="togRank9Random" fontSize="11" color="white" preferredHeight="30"
                onValueChanged="onTogRank9Random">
          Include Rank 9
        </Toggle>
        <Text fontSize="10" color="#888888" alignment="MiddleCenter" preferredHeight="50"
              resizeTextForBestFit="false">
          Rank 9 is always included in 3- and 8-player games.
        </Text>
      </VerticalLayout>
    </Panel>

    <!-- ── MANUAL PANEL ── -->
    <Panel id="paneManual" color="#00000000" preferredHeight="320" active="false">
      <VerticalLayout spacing="2" padding="2 2 2 2" childAlignment="UpperCenter">
        <Text fontSize="10" color="#AADDFF" alignment="MiddleCenter" preferredHeight="18">
          Pick one character per rank:
        </Text>
        %s
        <Toggle id="togRank9Manual" fontSize="10" color="white" preferredHeight="26"
                onValueChanged="onTogRank9Manual">
          Include Rank 9
        </Toggle>
        <Text id="txtManualValid" fontSize="10" color="#FF8888"
              alignment="MiddleCenter" preferredHeight="22">
        </Text>
      </VerticalLayout>
    </Panel>


  </VerticalLayout>
</Panel>

<!-- UNIQUE DISTRICTS SETUP PANEL -->
<Panel id="pnlUniqueDist"
       width="320" height="600"
       anchorMin="0.5 0.5" anchorMax="0.5 0.5"
       pivot="0.5 0.5"
       offsetMin="-830 -380" offsetMax="-510 220"
       color="#0d0d1fEE">
  <VerticalLayout spacing="4" padding="8 8 8 8" childAlignment="UpperCenter">

    <HorizontalLayout spacing="4" preferredHeight="24">
      <Text fontSize="13" fontStyle="Bold" color="#FFD700"
            alignment="MiddleLeft" flexibleWidth="1">Unique Districts</Text>
      <Button id="btnMinimizeUq" fontSize="13" color="white"
              colors="#333355|#5566AA|#222244|#333355"
              preferredWidth="24" preferredHeight="24"
              onClick="onBtnMinimizeUq" tooltip="Minimize / restore this panel">—</Button>
    </HorizontalLayout>


    <HorizontalLayout spacing="4" preferredHeight="30">
      <Button id="btnUqScenario" fontSize="10" color="white"
              colors="#1B6B3A|#27AE60|#145A32|#1B6B3A"
              preferredHeight="30" onClick="onUqModeScenario"
                tooltip="Use the recommended unique districts for the chosen scenario.">Scenario</Button>
      <Button id="btnUqCustom" fontSize="10" color="white"
              colors="#333355|#5555AA|#222244|#333355"
              preferredHeight="30" onClick="onUqModeCustom"
                tooltip="Manually pick which unique districts to include.">Custom</Button>
      <Button id="btnUqAll" fontSize="10" color="white"
              colors="#6B1010|#AA2222|#500000|#6B1010"
              preferredHeight="30" onClick="onUqModeAll"
                tooltip="Include all 30 unique districts. Warning: some may not be balanced together.">All 30 ⚠</Button>
    </HorizontalLayout>

    <Text id="txtUqDesc" fontSize="10" color="#CCCCCC"
          alignment="MiddleCenter" preferredHeight="46"
          resizeTextForBestFit="false">Use unique districts from selected scenario.</Text>

    <Toggle id="togRandomizeUniques" fontSize="10" color="white"
            preferredHeight="26" onValueChanged="onTogRandomizeUniques"
            tooltip="Ignore the list above and use 14 random unique districts from the full 30-card set.">
      Randomize uniques (14 random)
    </Toggle>

    <!-- Custom toggle grid (hidden unless Custom mode selected) -->
    <Panel id="pnlUqToggles" color="#00000000" preferredHeight="400" active="false">
      <VerticalLayout spacing="1" padding="2 2 2 2" childAlignment="UpperCenter">
        <Text fontSize="9" color="#AAAAAA" alignment="MiddleCenter" preferredHeight="14">
          Toggle which unique districts to include:
        </Text>
        <Text id="txtUqCount" fontSize="9" color="#FFD700"
              alignment="MiddleCenter" preferredHeight="14">Selected: 0 / 30</Text>
        <HorizontalLayout spacing="4" padding="0 0 0 0" childAlignment="UpperCenter"
                          preferredHeight="360">
          <VerticalLayout spacing="1" padding="0 0 0 0" childAlignment="UpperCenter"
                          flexibleWidth="1">
        <Toggle id="uq_Armory" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Armory (cost 3, military): Destroy one of your own districts to destroy any district in another city.">Armory</Toggle>
        <Toggle id="uq_Basilica" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Basilica (cost 4, religious): Score +1 for each odd-cost district in your city at game end.">Basilica</Toggle>
        <Toggle id="uq_Capitol" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Capitol (cost 5, noble): Score +3 if you have 3+ districts of the same type.">Capitol</Toggle>
        <Toggle id="uq_Dragon_Gate" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Dragon Gate (cost 6, unique): Worth 6 pts + 2 bonus points at end.">Dragon Gate</Toggle>
        <Toggle id="uq_Factory" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Factory (cost 5, unique): Pay 1 less gold to build other unique districts.">Factory</Toggle>
        <Toggle id="uq_Framework" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Framework (cost 3, unique): When you attempt to build a district, you may destroy Framework to build that district for free.">Framework</Toggle>
        <Toggle id="uq_Gold_Mine" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Gold Mine (cost 6, unique): When you choose Take Gold, gain 1 extra gold.">Gold Mine</Toggle>
        <Toggle id="uq_Great_Wall" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Great Wall (cost 6, unique): Warlord/Marshal pay +1 to destroy your districts.">Great Wall</Toggle>
        <Toggle id="uq_Haunted_Quarter" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Haunted Quarter (cost 2, unique): Counts as any district type for income and end-game bonuses.">Haunted Qtr</Toggle>
        <Toggle id="uq_Imperial_Treasury" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Imperial Treasury (cost 5, unique): Score +1 per gold you have at end of game.">Imp. Treasury</Toggle>
        <Toggle id="uq_Ivory_Tower" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Ivory Tower (cost 5, unique): Score +5 if this is your only unique district.">Ivory Tower</Toggle>
        <Toggle id="uq_Keep" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Keep (cost 3, unique): Cannot be destroyed by Warlord or Marshal.">Keep</Toggle>
        <Toggle id="uq_Laboratory" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Laboratory (cost 5, unique): Once per turn, discard a card to gain 2 gold.">Laboratory</Toggle>
        <Toggle id="uq_Library" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Library (cost 6, unique): When drawing cards, keep both instead of one.">Library</Toggle>
        <Toggle id="uq_Map_Room" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Map Room (cost 5, unique): Score +1 per district card in your hand at game end.">Map Room</Toggle>
          </VerticalLayout>
          <VerticalLayout spacing="1" padding="0 0 0 0" childAlignment="UpperCenter"
                          flexibleWidth="1">
        <Toggle id="uq_Monument" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Monument (cost 4, unique): Counts as 2 districts toward completing your city. Score +4 if hand empty.">Monument</Toggle>
        <Toggle id="uq_Museum" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Museum (cost 4, unique): Once per turn, tuck a card under — score +1 per tucked card.">Museum</Toggle>
        <Toggle id="uq_Necropolis" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Necropolis (cost 5, unique): Build this for free by destroying one of your own districts.">Necropolis</Toggle>
        <Toggle id="uq_Observatory" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Observatory (cost 4, unique): When drawing cards, draw 3 and keep 1.">Observatory</Toggle>
        <Toggle id="uq_Park" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Park (cost 6, unique): At end of your turn, if hand is empty draw 2 cards.">Park</Toggle>
        <Toggle id="uq_Poor_House" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Poor House (cost 4, unique): At the end of your turn, if you have 0 gold, gain 1 gold.">Poor House</Toggle>
        <Toggle id="uq_Quarry" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Quarry (cost 5, unique): May build duplicate copies of any district, including other unique districts.">Quarry</Toggle>
        <Toggle id="uq_School_of_Magic" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="School of Magic (cost 6, unique): Counts as any district type for income.">School/Magic</Toggle>
        <Toggle id="uq_Secret_Vault" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Secret Vault (cost 3, unique): Score 3 pts. Keep this card in hand — never plays to the table.">Secret Vault</Toggle>
        <Toggle id="uq_Smithy" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Smithy (cost 5, unique): Once per turn, pay 2 gold to draw 3 cards.">Smithy</Toggle>
        <Toggle id="uq_Statue" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Statue (cost 3, unique): Score +3 if you hold the crown at end of game.">Statue</Toggle>
        <Toggle id="uq_Thieves_Den" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Thieves' Den (cost 6, unique): Pay for any district using cards instead of gold (1 card = 1 gold).">Thieves' Den</Toggle>
        <Toggle id="uq_Theater" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Theater (cost 6, unique): Once per round, swap a built district with another player.">Theater</Toggle>
        <Toggle id="uq_Treasury" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Treasury (cost 5, unique): Gain 1 gold whenever you build a district.">Treasury</Toggle>
        <Toggle id="uq_Wishing_Well" fontSize="9" color="white" preferredHeight="20" onValueChanged="onUniqueToggle"
                tooltip="Wishing Well (cost 5, unique): Score +1 per unique district in your city at game end.">Wishing Well</Toggle>
          </VerticalLayout>
        </HorizontalLayout>
      </VerticalLayout>
    </Panel>


  </VerticalLayout>
</Panel>

<!-- MINIMIZED TAB: Character Setup — bottom-left corner, hidden by default -->
<Panel id="pnlSetupTab"
       anchorMin="0 0" anchorMax="0 0"
       pivot="0 0"
       offsetMin="10 10" offsetMax="230 54"
       color="#0d0d1fEE" active="false">
  <HorizontalLayout spacing="4" padding="8 6 8 6" childAlignment="MiddleLeft">
    <Text fontSize="13" fontStyle="Bold" color="#FFD700"
          alignment="MiddleLeft" flexibleWidth="1">Character Setup</Text>
    <Button id="btnRestoreSetup" fontSize="14" color="white"
            colors="#1B6B3A|#27AE60|#145A32|#1B6B3A"
            preferredWidth="44" preferredHeight="36"
            onClick="onBtnMinimizeSetup" tooltip="Restore Character Setup panel">▲</Button>
  </HorizontalLayout>
</Panel>

<!-- MINIMIZED TAB: Unique Districts — bottom-left corner above setup tab, hidden by default -->
<Panel id="pnlUqTab"
       anchorMin="0 0" anchorMax="0 0"
       pivot="0 0"
       offsetMin="10 62" offsetMax="230 106"
       color="#0d0d1fEE" active="false">
  <HorizontalLayout spacing="4" padding="8 6 8 6" childAlignment="MiddleLeft">
    <Text fontSize="13" fontStyle="Bold" color="#FFD700"
          alignment="MiddleLeft" flexibleWidth="1">Unique Districts</Text>
    <Button id="btnRestoreUq" fontSize="14" color="white"
            colors="#1B6B3A|#27AE60|#145A32|#1B6B3A"
            preferredWidth="44" preferredHeight="36"
            onClick="onBtnMinimizeUq" tooltip="Restore Unique Districts panel">▲</Button>
  </HorizontalLayout>
</Panel>

<!-- SCOREBOARD PANEL (shown at game end) -->
<Panel id="pnlScoreboard"
       width="480" height="540"
       anchorMin="0.5 0.5" anchorMax="0.5 0.5"
       pivot="0.5 0.5"
       offsetMin="-240 -270" offsetMax="240 270"
       color="#0a0a1aF0" active="false">
  <VerticalLayout spacing="6" padding="14 14 14 14" childAlignment="UpperCenter">

    <HorizontalLayout spacing="4" preferredHeight="32">
      <Text fontSize="17" fontStyle="Bold" color="#FFD700"
            alignment="MiddleLeft" flexibleWidth="1">🏆  FINAL SCORES</Text>
      <Button id="btnScoreReset" fontSize="11" color="white"
              colors="#6B4F1B|#AE8C27|#5A4014|#6B4F1B"
              preferredWidth="132" preferredHeight="32"
              onClick="onBtnResetGame"
              tooltip="Host only: reset the table for a new game">↺ Reset Table</Button>
      <Button id="btnCloseScore" fontSize="13" color="white"
              colors="#4A4A4A|#777777|#2A2A2A|#4A4A4A"
              preferredWidth="32" preferredHeight="32"
              onClick="onBtnCloseScore" tooltip="Close scoreboard">✕</Button>
    </HorizontalLayout>

    <Text id="txtScoreWinner" fontSize="13" fontStyle="Bold" color="#44FF88"
          alignment="MiddleCenter" preferredHeight="26">—</Text>

    <Panel color="#FFFFFF22" preferredHeight="2" />

    <Text id="txtScoreBody" fontSize="11" color="#DDDDDD"
          alignment="UpperLeft" resizeTextForBestFit="false"
          horizontalOverflow="Wrap" preferredHeight="440">—</Text>

    <Button id="btnCloseScore2" fontSize="12" color="white"
            colors="#922B21|#E74C3C|#641E16|#922B21"
            preferredHeight="36" onClick="onBtnCloseScore"
            tooltip="Close the scoreboard">✕  Close Scoreboard</Button>

  </VerticalLayout>
</Panel>

<!-- MAIN GAME PANEL -->
<Panel id="mainPanel"
       width="260" height="600"
       anchorMin="1 0.5" anchorMax="1 0.5"
       pivot="1 0.5"
       offsetMin="-270 -300" offsetMax="-10 300"
       color="#111122EE">

  <VerticalLayout spacing="6" padding="12 12 12 12" childAlignment="UpperCenter">

    <Text fontSize="17" fontStyle="Bold" color="#FFD700"
          alignment="MiddleCenter" preferredHeight="32">⚜  CITADELS  ⚜</Text>

    <Text id="txtPhase" fontSize="13" color="#AADDFF"
          alignment="MiddleCenter" preferredHeight="24">Phase: SETUP</Text>

    <Text id="txtRound" fontSize="12" color="#AAAAAA"
          alignment="MiddleCenter" preferredHeight="22">Round: —</Text>

    <Text id="txtCrown" fontSize="12" color="#FFD88A"
          alignment="MiddleCenter" preferredHeight="22">Crown: —</Text>

    <Text id="txtMode" fontSize="11" color="#88CCFF"
          alignment="MiddleCenter" preferredHeight="22">Mode: —</Text>

    <Text id="txtTurn" fontSize="12" color="#88FF88"
          alignment="MiddleCenter" preferredHeight="40">—</Text>

    <Button id="btnStart" fontSize="13" color="white"
            colors="#1B6B3A|#27AE60|#145A32|#1B6B3A"
            preferredHeight="42" onClick="onBtnStart"
                tooltip="Begin the game with the current setup options.">
      ▶  Start Game
    </Button>

    <!-- Debug mode toggle — console is visible to all players, use only for testing! -->
    <HorizontalLayout spacing="6" preferredHeight="22">
      <Toggle id="togDebug" fontSize="9" color="#FF8888"
              onValueChanged="onDebugToggle"
              tooltip="Enable verbose console logging for testing. WARNING: the scripting console is visible to ALL players — do not use in real games as it reveals secret information like character choices."
              >🔧 Debug Logging (test only — spoils secrets!)</Toggle>
    </HorizontalLayout>

    <Button id="btnBugReport" fontSize="9" color="#FF8888"
            colors="#4A1A00|#993300|#2A0F00|#4A1A00"
            preferredHeight="20" onClick="onBtnBugReport"
            tooltip="Dump current game state to chat for bug reporting. Screenshot the output and share it.">
      🐛  Report Bug
    </Button>

    <Button id="btnReady" fontSize="13" color="white"
            colors="#1A5276|#2E86C1|#154360|#1A5276"
            preferredHeight="42" onClick="onBtnReady" active="false"
            text="✔  I've Chosen My Character"
                tooltip="Drag your chosen character card into your hand zone first. Any unwanted cards go face-down to the center of the table. Then click this button to confirm.">
    </Button>

    <Button id="btnGold" fontSize="13" color="white"
            colors="#6E2F8A|#9B59B6|#4A235A|#6E2F8A"
            preferredHeight="42" onClick="onBtnGold" active="false"
                tooltip="Take 2 gold coins as your resource action this turn. (Navigator: 4 gold)">
      💰  Take 2 Gold
    </Button>

    <Button id="btnDraw" fontSize="13" color="white"
            colors="#6E2F8A|#9B59B6|#4A235A|#6E2F8A"
            preferredHeight="42" onClick="onBtnDraw" active="false"
                tooltip="Draw 2 district cards, keep 1, return 1 to the deck. (Navigator: draw 4, keep 2)">
      🃏  Draw 2 Cards
    </Button>

    <Button id="btnEnd" fontSize="13" color="white"
            colors="#922B21|#E74C3C|#641E16|#922B21"
            preferredHeight="42" onClick="onBtnEnd" active="false"
                tooltip="End your turn. You must gather resources first. Return extra cards to deck if required.">
      ⏭  End Turn
    </Button>

    <HorizontalLayout spacing="6" preferredHeight="22">
      <Toggle id="togAutoEnd" fontSize="10" color="#A8FFB0"
              onValueChanged="onAutoEndToggle"
              tooltip="Automatically end the current human player's turn after gathering when no legal actions, builds, character abilities, or district abilities remain.">✅ Auto End When Done</Toggle>
    </HorizontalLayout>

    <Text id="txtGold" fontSize="10" color="#FFD700"
          alignment="MiddleCenter" preferredHeight="130">Gold: —</Text>

    <Button id="btnAbility" text="✨  Use Ability" fontSize="12" color="white"
            colors="#7A5C00|#C49A00|#5C4500|#7A5C00"
            preferredHeight="42" onClick="onBtnAbility" active="false"
                tooltip="Use your character's special ability. Each ability can only be used once per turn." />

    <Button id="btnAbility2" text="✨  Ability 2" fontSize="12" color="white"
            colors="#7A5C00|#C49A00|#5C4500|#7A5C00"
            preferredHeight="42" onClick="onBtnAbility2" active="false"
                tooltip="Use your character's second ability option." />

    <Button id="btnUniqueAbility" text="🔨  Smithy: Pay 2g → Draw 3" fontSize="12" color="white"
            colors="#004466|#0077AA|#003355|#004466"
            preferredHeight="36" onClick="onBtnUniqueAbility" active="false"
                tooltip="Pay 2 gold to draw 3 district cards." />
    <Button id="btnDistrictLab" text="🧪  Lab: Discard card → +2g" fontSize="12" color="white"
            colors="#004466|#0077AA|#003355|#004466"
            preferredHeight="36" onClick="onBtnDistrictLab" active="false"
                tooltip="Once per turn: drag a district card face-down onto the deck, then click to confirm and gain 2 gold." />
    <Button id="btnDistrictMuseum" text="🏛  Museum: Tuck card (+1pt)" fontSize="12" color="white"
            colors="#004466|#0077AA|#003355|#004466"
            preferredHeight="36" onClick="onBtnDistrictMuseum" active="false"
                tooltip="Once per turn: tuck a card from your hand under the Museum for +1 point at game end." />
    <Button id="btnDistrictArmory" text="💥  Armory: Sacrifice → Destroy" fontSize="12" color="white"
            colors="#004466|#0077AA|#003355|#004466"
            preferredHeight="36" onClick="onBtnDistrictArmory" active="false"
                tooltip="Sacrifice the Armory to destroy any district in any opponent's city." />

    <!-- Rank Targeting Panel (shown during ability targeting) -->
    <Panel id="pnlTarget" color="#00000055" active="false"
           preferredHeight="160">
      <VerticalLayout spacing="3" padding="4 4 4 4" childAlignment="UpperCenter">
        <Text id="txtTargetPrompt" fontSize="11" color="#FFDD88"
              alignment="MiddleCenter" preferredHeight="32">Choose a rank:</Text>
        <GridLayout cellSize="72 30" spacing="3" childAlignment="MiddleCenter">
          <Button id="btnRank1" fontSize="11" color="white" colors="#333366|#5566CC|#222244|#333366"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetRank_1"
                tooltip="Select rank 1">1</Button>
          <Button id="btnRank2" fontSize="11" color="white" colors="#333366|#5566CC|#222244|#333366"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetRank_2"
                tooltip="Select rank 2">2</Button>
          <Button id="btnRank3" fontSize="11" color="white" colors="#333366|#5566CC|#222244|#333366"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetRank_3"
                tooltip="Select rank 3">3</Button>
          <Button id="btnRank4" fontSize="11" color="white" colors="#333366|#5566CC|#222244|#333366"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetRank_4"
                tooltip="Select rank 4">4</Button>
          <Button id="btnRank5" fontSize="11" color="white" colors="#333366|#5566CC|#222244|#333366"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetRank_5"
                tooltip="Select rank 5">5</Button>
          <Button id="btnRank6" fontSize="11" color="white" colors="#333366|#5566CC|#222244|#333366"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetRank_6"
                tooltip="Select rank 6">6</Button>
          <Button id="btnRank7" fontSize="11" color="white" colors="#333366|#5566CC|#222244|#333366"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetRank_7"
                tooltip="Select rank 7">7</Button>
          <Button id="btnRank8" fontSize="11" color="white" colors="#333366|#5566CC|#222244|#333366"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetRank_8"
                tooltip="Select rank 8">8</Button>
          <Button id="btnRank9" fontSize="11" color="white" colors="#333366|#5566CC|#222244|#333366"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetRank_9"
                tooltip="Select rank 9">9</Button>
          <Button fontSize="11" color="white" colors="#6B2222|#CC3333|#4A1515|#6B2222"
                  preferredWidth="72" preferredHeight="30" onClick="onTargetCancel">✕ Cancel</Button>
        </GridLayout>
      </VerticalLayout>
    </Panel>

    <!-- Player Targeting Panel (shown during abilities that target players) -->
    <Panel id="pnlTargetPlayer" color="#00000055" active="false"
           preferredHeight="230">
      <VerticalLayout spacing="3" padding="4 4 4 4" childAlignment="UpperCenter">
        <Text id="txtTargetPrompt" fontSize="11" color="#FFDD88"
              alignment="MiddleCenter" preferredHeight="40">Choose a player:</Text>
        <Button id="btnPick1" text="—" fontSize="11" color="white" colors="#225533|#33AA66|#1A4428|#225533"
                preferredHeight="28" onClick="onBtnPick_1" active="false" />
        <Button id="btnPick2" text="—" fontSize="11" color="white" colors="#225533|#33AA66|#1A4428|#225533"
                preferredHeight="28" onClick="onBtnPick_2" active="false" />
        <Button id="btnPick3" text="—" fontSize="11" color="white" colors="#225533|#33AA66|#1A4428|#225533"
                preferredHeight="28" onClick="onBtnPick_3" active="false" />
        <Button id="btnPick4" text="—" fontSize="11" color="white" colors="#225533|#33AA66|#1A4428|#225533"
                preferredHeight="28" onClick="onBtnPick_4" active="false" />
        <Button id="btnPick5" text="—" fontSize="11" color="white" colors="#225533|#33AA66|#1A4428|#225533"
                preferredHeight="28" onClick="onBtnPick_5" active="false" />
        <Button id="btnPick6" text="—" fontSize="11" color="white" colors="#225533|#33AA66|#1A4428|#225533"
                preferredHeight="28" onClick="onBtnPick_6" active="false" />
        <Button id="btnPick7" text="—" fontSize="11" color="white" colors="#225533|#33AA66|#1A4428|#225533"
                preferredHeight="28" onClick="onBtnPick_7" active="false" />
        <Button id="btnPick8" text="—" fontSize="11" color="white" colors="#225533|#33AA66|#1A4428|#225533"
                preferredHeight="28" onClick="onBtnPick_8" active="false" />
        <Button fontSize="11" color="white" colors="#6B2222|#CC3333|#4A1515|#6B2222"
                preferredHeight="28" onClick="onTargetCancel">✕ Cancel</Button>
      </VerticalLayout>
    </Panel>

    <Text id="txtStatus" fontSize="11" color="#CCCCCC"
          alignment="MiddleCenter" preferredHeight="52">
      Configure cast on the left, then press Start Game.
    </Text>

    <!-- In-game bot management -->
    <Button id="btnBotsToggle" fontSize="11" color="white"
            colors="#1A3A4A|#2E6680|#0F2233|#1A3A4A"
            preferredHeight="30" onClick="onBtnBotsToggle" active="false"
            tooltip="Show/hide computer player controls">🤖  Manage Bots  ▾</Button>

    <Panel id="pnlBotsGame" color="#0d1a2aCC" active="false" preferredHeight="90">
      <VerticalLayout spacing="3" padding="6 6 6 6" childAlignment="UpperCenter">
        <Text fontSize="9" color="#88CCFF" alignment="MiddleCenter" preferredHeight="16">Toggle computer players:</Text>
        <HorizontalLayout spacing="3" preferredHeight="22">
          <Toggle id="togBotG_Red"    fontSize="9" color="#FF6666" preferredHeight="22" onValueChanged="onBotToggleGame">Red</Toggle>
          <Toggle id="togBotG_Green"  fontSize="9" color="#66FF66" preferredHeight="22" onValueChanged="onBotToggleGame">Green</Toggle>
          <Toggle id="togBotG_Blue"   fontSize="9" color="#6699FF" preferredHeight="22" onValueChanged="onBotToggleGame">Blue</Toggle>
          <Toggle id="togBotG_White"  fontSize="9" color="white"   preferredHeight="22" onValueChanged="onBotToggleGame">White</Toggle>
        </HorizontalLayout>
        <HorizontalLayout spacing="3" preferredHeight="22">
          <Toggle id="togBotG_Pink"   fontSize="9" color="#FF88CC" preferredHeight="22" onValueChanged="onBotToggleGame">Pink</Toggle>
          <Toggle id="togBotG_Yellow" fontSize="9" color="#FFEE44" preferredHeight="22" onValueChanged="onBotToggleGame">Yellow</Toggle>
          <Toggle id="togBotG_Orange" fontSize="9" color="#FFAA44" preferredHeight="22" onValueChanged="onBotToggleGame">Orange</Toggle>
          <Toggle id="togBotG_Purple" fontSize="9" color="#CC88FF" preferredHeight="22" onValueChanged="onBotToggleGame">Purple</Toggle>
        </HorizontalLayout>
      </VerticalLayout>
    </Panel>

  </VerticalLayout>
</Panel>
]], rankRows))

    -- Populate the initial scenario cast display
    refreshScenarioDisplay()
    refreshManualButtons()
    refreshManualValidation()
end

-- ============================================================
--  UI HELPERS
-- ============================================================
local function setPhaseUI(t) UI.setValue('txtPhase','Phase: '..t) end
local function setRoundUI()  UI.setValue('txtRound','Round: '..G.roundNumber) end
local function setCrownUI()
    local c = G.players[G.crownIndex] or '—'
    UI.setValue('txtCrown', 'Crown: '..c)
    UI.setAttribute('txtCrown', 'color', hexOf(c))
end
local function setTurnUI(t, color)
    UI.setValue('txtTurn', t)
    if color then UI.setAttribute('txtTurn', 'color', hexOf(color)) end
end
local function setStatus(t)  UI.setValue('txtStatus',t) end
local function btn(id,on)    UI.setAttribute(id,'active',on and 'true' or 'false') end
local function btnColor(id,active)
    local on  = '#1B6B3A|#27AE60|#145A32|#1B6B3A'
    local off = '#333355|#5555AA|#222244|#333355'
    UI.setAttribute(id,'colors',active and on or off)
end

function updateGoldUI()
    local lines={}
    for _,c in ipairs(G.players or {}) do
        if c and c ~= '' then
            table.insert(lines,c..': '..(G.gold[c] or 0)..'g  |  City: '..(G.citySize[c] or 0)..'  |  '..(G.cityScore[c] or 0)..' pts')
        end
    end
    UI.setValue('txtGold',table.concat(lines,'\n'))
end

-- Announce a score change to all players in chat and refresh the UI.
local function announceScoreChange(color, delta, reason)
    if delta == 0 then return end
    local total = G.cityScore[color] or 0
    local sign  = delta > 0 and '+' or ''
    printToAll('📊 '..color..' '..sign..delta..' pts ('..reason..') — '..total..' pts total',
               delta > 0 and {0.7,1.0,0.7} or {1.0,0.75,0.6})
    updateGoldUI()
end

-- Show/hide the three sub-panels in setupPanel
local function showSetupPane(mode)
    UI.setAttribute('paneScenario','active', mode=='scenario' and 'true' or 'false')
    UI.setAttribute('paneRandom',  'active', mode=='random'   and 'true' or 'false')
    UI.setAttribute('paneManual',  'active', mode=='manual'   and 'true' or 'false')
    btnColor('btnModeScenario', mode=='scenario')
    btnColor('btnModeRandom',   mode=='random')
    btnColor('btnModeManual',   mode=='manual')
end

-- Rebuild the scenario description + cast lines
function refreshScenarioDisplay()
    local s = SCENARIOS[G.scenarioIndex]
    UI.setValue('txtScenDesc', s.desc)
    local lines={}
    for rank,guid in ipairs(s.chars) do
        table.insert(lines,'R'..rank..': '..CHAR_NAME[guid])
    end
    if s.rank9 then
        local suffix = G.includeRank9 and '' or ' (disabled)'
        table.insert(lines,'R9: '..CHAR_NAME[s.rank9]..suffix)
    else
        table.insert(lines,'R9: — (none in this scenario)')
    end
    UI.setValue('txtScenCast', table.concat(lines,'\n'))

    -- Sync the rank 9 toggle visual
    UI.setAttribute('togRank9Scenario','isOn', G.includeRank9 and 'true' or 'false')

    -- Highlight the active scenario button
    for i=0,6 do btnColor('btnScen'..i, i+1==G.scenarioIndex) end
end

-- Colour the manual pick buttons — green = selected for that rank
function refreshManualButtons()
    for rank=1,9 do
        for col=1,3 do
            local g   = RANKS[rank][col]
            local sel = G.manualSelection[rank]
            btnColor('mBtn_'..rank..'_'..col, sel==g)
        end
    end
    -- Show rank9 toggle state
    UI.setAttribute('togRank9Manual','isOn', G.includeRank9 and 'true' or 'false')
end

function refreshManualValidation()
    local ok, err = validateManual()
    UI.setValue('txtManualValid', ok and '✔ Cast is valid' or '✗ '..err)
    if ok then UI.setAttribute('txtManualValid','color','#88FF88')
    else        UI.setAttribute('txtManualValid','color','#FF8888') end
end

local function refreshSetupModeLabel()
    if G.setupMode == 'manual' then
        UI.setValue('txtMode', 'Mode: Manual')
    elseif G.setupMode == 'random' then
        UI.setValue('txtMode', 'Mode: Random')
    else
        local scenario = SCENARIOS[G.scenarioIndex] or SCENARIOS[1]
        UI.setValue('txtMode', 'Mode: Scenario — '..(scenario and scenario.name or 'First Game'))
    end
end

local refreshUniqueSetupUI

local function releaseAllHandObjects()
    for color, _ in pairs(PLAYER_POS) do
        local p, hand = getPlayerHandObjectsForReset(color)
        for _, hobj in ipairs(hand) do
            detachHandObjectForReset(color, p, hobj)
        end
    end
end

local function resetAllPhysicalObjects()
    for _, o in ipairs(getAllObjects()) do
        pcall(function() o.reset() end)
    end
end

local function resetHomeSpawnPos(guid, lift)
    local home = RESET_HOME[guid]
    if not home or not home.position then return nil end
    return {
        x = home.position.x,
        y = home.position.y + (lift or 1.5),
        z = home.position.z,
    }
end

local function moveKnownObjectToResetHome(o, guid)
    local home = RESET_HOME[guid]
    if not o or not home then return false end
    local moved = false
    pcall(function()
        o.setRotation(home.rotation)
        o.setPosition(home.position)
        moved = true
    end)
    return moved
end

local function extractKnownObjectsFromCarrier(carrier)
    if not carrier or (carrier.type ~= 'Deck' and carrier.type ~= 'DeckCustom') then return 0 end
    local ok, contents = pcall(function() return carrier.getObjects() end)
    if not ok or not contents or #contents == 0 then return 0 end
    local moved = 0
    for _, entry in ipairs(contents) do
        if RESET_HOME[entry.guid] then
            local extracted = nil
            pcall(function()
                extracted = carrier.takeObject({
                    guid = entry.guid,
                    position = resetHomeSpawnPos(entry.guid, 2.0) or carrier.getPosition(),
                    smooth = false,
                    flip = false,
                })
            end)
            if extracted and moveKnownObjectToResetHome(extracted, entry.guid) then
                moved = moved + 1
            end
        end
    end
    return moved
end

local function restoreKnownResetObjects()
    for _, guid in ipairs(KNOWN_RESET_GUIDS) do
        local o = obj(guid)
        if o then
            pcall(function() o.reset() end)
            moveKnownObjectToResetHome(o, guid)
        end
    end

    for _ = 1, 2 do
        for _, o in ipairs(getAllObjects()) do
            local guid = nil
            pcall(function() guid = o.getGUID() end)
            if guid and RESET_HOME[guid] then
                pcall(function() o.reset() end)
                moveKnownObjectToResetHome(o, guid)
            else
                extractKnownObjectsFromCarrier(o)
            end
        end
    end
end

local function returnLooseGoldToBowl()
    local bp = bowlPos()
    local idx = 0
    for _, o in ipairs(getAllObjects()) do
        pcall(function()
            local name = o.getName()
            if name == 'Gold' or name == 'Beautify Gold' then
                idx = idx + 1
                if G.lockedCoins then G.lockedCoins[o.getGUID()] = nil end
                if G.beautifyCoinMeta then G.beautifyCoinMeta[o.getGUID()] = nil end
                o.setName('Gold')
                o.setDescription('')
                o.setRotation({0, 0, 0})
                o.setPosition({
                    x = bp.x + ((idx % 6) - 2.5) * 0.45,
                    y = bp.y + 0.4 + math.floor(idx / 6) * 0.08,
                    z = bp.z + (math.floor((idx - 1) / 6) - 1.5) * 0.45,
                })
            end
        end)
    end
end

local function resetGameToSetupState()
    if G.resetting then return end
    G.resetting = true
    pcall(function() Wait.stopAll() end)
    pcall(function() MusicPlayer.stop() end)
    G.phase='SETUP'; G.roundNumber=0; G.gameOver=false
    G.players={}; G.gold={}; G.citySize={}; G.cityScore={}; G.cityTypes={}
    G.buildTypes={}; G.chosenBy={}
    G.turnAdvancePending=false; G.roundEnding=false
    G.uniqueBuilt={}; G.cityCosts={}; G.museumCards={}
    G.beautified={}; G.beautifyCoins={}; G.beautifyCoinMeta={}; G.lockedCoins={}; G.taxGold=0
    G.manualSelection={nil,nil,nil,nil,nil,nil,nil,nil,nil}
    setPhaseUI('SETUP'); setRoundUI(); setTurnUI('—'); setCrownUI(); updateGoldUI()
    btn('setupPanel',true); btn('pnlUniqueDist',true); btn('btnStart',false)
    btn('btnReady',false); btn('btnGold',false); btn('btnDraw',false)
    btn('btnEnd',false); btn('btnAbility',false); btn('btnAbility2',false)
    btn('btnBotsToggle', false)
    UI.setAttribute('pnlBotsGame', 'active', 'false')
    UI.setAttribute('pnlScoreboard', 'active', 'false')
    UI.setValue('btnBotsToggle', '🤖  Manage Bots  ▾')
    UI.setValue('btnStart','↺  Resetting...')
    refreshSetupModeLabel()
    setStatus('Resetting table to its starting layout...')

    Wait.time(function()
        if not G.resetting then return end
        resetAllPhysicalObjects()
        Wait.time(function()
            if not G.resetting then return end
            for _, guid in ipairs(KNOWN_RESET_GUIDS) do
                local o = obj(guid)
                if o then pcall(function() o.reset() end) end
            end
            local dd = obj(GUID.districtCards)
            if dd then pcall(function() dd.reset() end) end
            local ud = obj(GUID.uniqueDistricts)
            if ud then pcall(function() ud.reset() end) end
            Wait.time(function()
                if not G.resetting then return end
                G.resetting = false
                setPhaseUI('SETUP'); setRoundUI(); setTurnUI('—'); setCrownUI(); updateGoldUI()
                refreshSetupModeLabel()
                refreshUniqueSetupUI()
                refreshScenarioDisplay()
                refreshManualButtons()
                UI.setValue('btnStart','▶  Start Game')
                btn('btnStart',true)
                setStatus('Game reset. Configure cast then press Start Game.')
            end, 1.2)
        end, 0.6)
    end, 0.1)
end

local function randomUniqueCount()
    local s = SCENARIOS[G.scenarioIndex] or {}
    local scenarioCount = #(s.uniqueDistricts or {})
    if scenarioCount <= 0 then scenarioCount = 14 end
    return math.min(scenarioCount, #ALL_UNIQUE_NAMES)
end

refreshUniqueSetupUI = function()
    local mode = G.uniqueMode or 'scenario'
    local customCount = 0
    for _, v in pairs(G.customUniques or {}) do
        if v then customCount = customCount + 1 end
    end

    UI.setAttribute('btnUqScenario','colors',
        mode == 'scenario' and '#1B6B3A|#27AE60|#145A32|#1B6B3A' or '#333355|#5555AA|#222244|#333355')
    UI.setAttribute('btnUqCustom','colors',
        mode == 'custom' and '#1B6B3A|#27AE60|#145A32|#1B6B3A' or '#333355|#5555AA|#222244|#333355')
    UI.setAttribute('btnUqAll','colors',
        mode == 'alluniques' and '#1B6B3A|#27AE60|#145A32|#1B6B3A' or '#6B1010|#AA2222|#500000|#6B1010')

    UI.setAttribute('togRandomizeUniques', 'isOn', G.randomizeUniques and 'True' or 'False')
    UI.setAttribute('pnlUqToggles', 'active', (mode == 'custom' and not G.randomizeUniques) and 'true' or 'false')
    UI.setValue('txtUqCount', 'Selected: '..customCount..' / 30')

    if G.randomizeUniques then
        UI.setValue('txtUqDesc', 'Randomized: '..randomUniqueCount()..' unique districts will be chosen from all 30 when the game starts.')
    elseif mode == 'scenario' then
        UI.setValue('txtUqDesc','Use unique districts from selected scenario.')
    elseif mode == 'custom' then
        UI.setValue('txtUqDesc','Custom: choose which unique districts to include.')
    else
        UI.setValue('txtUqDesc','⚠ ALL 30 unique districts included. Not recommended — game may feel unbalanced.')
    end
end

-- ============================================================
--  SETUP PANEL CALLBACKS
-- ============================================================

function onModeScenario(player)
    if not player.host then return end
    G.setupMode='scenario'; showSetupPane('scenario')
    UI.setValue('txtMode','Mode: Scenario — '..SCENARIOS[G.scenarioIndex].name)
end

function onModeRandom(player)
    if not player.host then return end
    G.setupMode='random'; showSetupPane('random')
    UI.setValue('txtMode','Mode: Random')
end


-- ============================================================
--  UNIQUE DISTRICT MODE HANDLERS
-- ============================================================
function onUqModeScenario(player)
    if not player.host then return end
    G.uniqueMode = 'scenario'
    refreshUniqueSetupUI()
    captureDeckResetAnchors()
end

function onUqModeCustom(player)
    if not player.host then return end
    G.uniqueMode = 'custom'
    refreshUniqueSetupUI()
end

function onUqModeAll(player)
    if not player.host then return end
    G.uniqueMode = 'alluniques'
    UI.setAttribute('btnUqScenario','colors','#333355|#5555AA|#222244|#333355')
    UI.setAttribute('btnUqCustom',  'colors','#333355|#5555AA|#222244|#333355')
    UI.setAttribute('btnUqAll',     'colors','#1B6B3A|#27AE60|#145A32|#1B6B3A')
    UI.setAttribute('pnlUqToggles', 'active','false')
    UI.setValue('txtUqDesc','⚠ ALL 30 unique districts included. Not recommended — game may feel unbalanced.')
end

function onUniqueToggle(player, value, id)
    if not player.host then return end
    -- Convert toggle ID back to district name
    -- id format: uq_DistrictName (spaces→underscores, apostrophes removed)
    local nameKey = id:sub(4)  -- strip 'uq_'
    -- Find matching district name from ALL_UNIQUE_NAMES
    G.customUniques = G.customUniques or {}
    for _, name in ipairs(ALL_UNIQUE_NAMES) do
        local norm = name:gsub(' ','_'):gsub("'",''):gsub('%.','')
        if norm == nameKey then
            G.customUniques[name] = (value == 'True')
            break
        end
    end
    local count = 0
    for _, v in pairs(G.customUniques) do if v then count=count+1 end end
    UI.setValue('txtUqCount','Selected: '..count..' / 30')
end

-- Unique district mode overrides
function onUqModeScenario(player)
    if not player.host then return end
    G.uniqueMode = 'scenario'
    refreshUniqueSetupUI()
end

function onUqModeCustom(player)
    if not player.host then return end
    G.uniqueMode = 'custom'
    refreshUniqueSetupUI()
end

function onUqModeAll(player)
    if not player.host then return end
    G.uniqueMode = 'alluniques'
    refreshUniqueSetupUI()
end

function onTogRandomizeUniques(player, value)
    if not player.host then return end
    G.randomizeUniques = (value == 'True')
    refreshUniqueSetupUI()
end

function onUniqueToggle(player, value, id)
    if not player.host then return end
    local nameKey = id:sub(4)
    G.customUniques = G.customUniques or {}
    for _, name in ipairs(ALL_UNIQUE_NAMES) do
        local norm = name:gsub(' ','_'):gsub("'",''):gsub('%.','')
        if norm == nameKey then
            G.customUniques[name] = (value == 'True')
            break
        end
    end
    refreshUniqueSetupUI()
end

function onModeManual(player)
    if not player.host then return end
    G.setupMode='manual'; showSetupPane('manual')
    UI.setValue('txtMode','Mode: Manual')
    refreshManualValidation()
end

-- Scenario buttons: id = "btnScen0" .. "btnScen6"
function onScenBtn(player, _, id)
    if not player.host then return end
    local idx = tonumber(id:match('btnScen(%d)')) + 1
    G.scenarioIndex = idx
    refreshScenarioDisplay()
    UI.setValue('txtMode','Mode: Scenario — '..SCENARIOS[idx].name)
end

function onTogRank9Scenario(player, value)
    if not player.host then return end
    G.includeRank9 = (value=='True')
    refreshScenarioDisplay()
end

function onTogRank9Random(player, value)
    if not player.host then return end
    G.includeRank9 = (value=='True')
end

function onTogRank9Manual(player, value)
    if not player.host then return end
    G.includeRank9 = (value=='True')
    -- If turning off, clear manual rank9 selection
    if not G.includeRank9 then
        G.manualSelection[9]=nil
        refreshManualButtons()
    end
    refreshManualValidation()
end

-- Manual character toggle buttons: id = "mBtn_RANK_COL"
function onManualBtn(player, _, id)
    if not player.host then return end
    local rank, col = id:match('mBtn_(%d+)_(%d+)')
    rank=tonumber(rank); col=tonumber(col)
    local guid = RANKS[rank][col]

    -- Toggle: if already selected, deselect; otherwise select
    if G.manualSelection[rank] == guid then
        G.manualSelection[rank] = nil
    else
        G.manualSelection[rank] = guid
        -- If rank 9 was just picked, auto-enable include toggle
        if rank==9 then G.includeRank9=true end
    end

    refreshManualButtons()

    -- Show validation hint live
    local ok, err = validateManual()
    UI.setValue('txtManualValid', ok and '✔ Cast is valid' or '✗ '..err)
    if ok then UI.setAttribute('txtManualValid','color','#88FF88')
    else        UI.setAttribute('txtManualValid','color','#FF8888') end
end

-- ============================================================
--  START GAME
-- ============================================================

function onBtnStart(player)
    if G.phase~='SETUP' then logTo(player.color,'Game already running!'); return end
    if not player.host  then logTo(player.color,'Only the host can start.'); return end

    -- Validate manual mode before starting
    if G.setupMode=='manual' then
        local ok, err = validateManual()
        if not ok then
            setStatus('Cannot start: '..err)
            logTo(player.color,'Cannot start: '..err)
            return
        end
    end

    startGame()
end

-- Pull the selected unique districts into the district deck and shuffle.
-- Unselected unique cards stay in their home deck so reset/replay can rebuild cleanly.
function setupUniqueDistricts()
    local uniqueDeck   = findUniqueDeck()
    local districtDeck = findDistrictDeck()
    if not uniqueDeck   then log('WARNING: Unique districts deck not found'); return end
    if not districtDeck then log('WARNING: District deck not found'); return end

    -- Build set of names to keep.
    local function normName(s) return normCardName(s) end
    local keepNames = {}
    local umode = G.uniqueMode or 'scenario'
    local randomized = (G.randomizeUniques == true)
    if randomized then
        local pool = {}
        for _, name in ipairs(ALL_UNIQUE_NAMES) do
            pool[#pool + 1] = normName(name)
        end
        shuffle(pool)
        local keepCount = math.min(randomUniqueCount(), #pool)
        for i = 1, keepCount do
            keepNames[pool[i]] = true
        end
    elseif umode == 'scenario' then
        local s = SCENARIOS[G.scenarioIndex]
        for _, name in ipairs(s.uniqueDistricts or {}) do
            keepNames[normName(name)] = true
        end
    elseif umode == 'custom' then
        for name, sel in pairs(G.customUniques or {}) do
            if sel then keepNames[normName(name)] = true end
        end
    elseif umode == 'alluniques' then
        for _, c in ipairs(uniqueDeck.getObjects()) do keepNames[normName(c.name)] = true end
    else
        -- Default: use scenario uniques
        local s = SCENARIOS[G.scenarioIndex]
        for _, name in ipairs(s.uniqueDistricts or {}) do
            keepNames[normName(name)] = true
        end
    end

    -- Snapshot only the cards we actually want to move into the district deck.
    -- Unselected uniques stay in the unique deck so reset/replay can rebuild cleanly.
    local allCards = {}
    for _, cardInfo in ipairs(uniqueDeck.getObjects() or {}) do
        if keepNames[normName(cardInfo.name)] then
            table.insert(allCards, cardInfo)
        end
    end
    local ddPos    = districtDeck.getPosition()

    local kept = 0

    -- Move the selected cards into the district deck one by one.
    local function processNext(remaining)
        if #remaining == 0 then
            -- Shuffle the district deck after the selected unique cards have merged in.
            Wait.time(function()
                local dd = getObjectFromGUID(GUID.districtCards)
                if dd then dd.shuffle() end
                log('District deck ready: '..kept..(randomized and ' random' or '')..' unique districts added and shuffled.')
            end, 0.5)
            return
        end

        local cardInfo = remaining[1]
        table.remove(remaining, 1)

        local ud = findUniqueDeck()
        local cardNameNorm = normName(cardInfo.name)
        local dest = {x=ddPos.x, y=ddPos.y+1, z=ddPos.z}

        local taken = nil
        pcall(function()
            if ud and (ud.type == 'Deck' or ud.type == 'DeckCustom') then
                taken = ud.takeObject({
                    guid     = cardInfo.guid,
                    position = dest,
                    smooth   = false,
                    flip     = false,
                })
            elseif ud then
                ud.setPosition(dest)
                taken = ud
            end
        end)
        if not taken then
            -- Last card or deck gone — scan all objects for matching name
            for _, o in ipairs(getAllObjects()) do
                pcall(function()
                    if o.getName() == cardInfo.name then
                        o.setPosition(dest)
                        taken = o
                    end
                end)
                if taken then break end
            end
            if not taken then
                processNext(remaining)
                return
            end
        end

        Wait.time(function()
            if taken then
                -- Put into district deck
                local dd = findDistrictDeck()
                if dd then
                    pcall(function() dd.putObject(taken) end)
                end
                kept = kept + 1
            end
            processNext(remaining)
        end, 0.12)
    end

    processNext(allCards)
end

function startGame()
    local seated = configuredPlayerList()
    captureDeckResetAnchors()
    restoreDistrictCardsToHomeDecks()

    G.playerCount=#seated
    if G.playerCount<2 then log('Need at least 2 players!'); return end

    G.players={}; G.gold={}; G.citySize={}; G.cityScore={}; G.cityTypes={}
    G.chosenBy={}; G.gameOver=false; G.completedFirst=nil; G.roundNumber=0
    G.uniqueBuilt={}; G.cityCosts={}; G.museumCards={}
    G.beautified={}; G.beautifyCoins={}; G.beautifyCoinMeta={}; G.lockedCoins={}; G.taxGold=0

    -- Sort seated players into clockwise table order so selection and turn order
    -- always go clockwise regardless of TTS seat-number assignment.
    local CW_ORDER = {'White','Red','Orange','Yellow','Green','Blue','Purple','Pink'}
    local cwIndex = {}; for i,c in ipairs(CW_ORDER) do cwIndex[c]=i end
    table.sort(seated, function(a,b)
        return (cwIndex[a] or 99) < (cwIndex[b] or 99)
    end)

    for _,color in ipairs(seated) do
        table.insert(G.players,color)
        G.gold[color]=0; G.citySize[color]=0; G.cityScore[color]=0; G.cityTypes[color]={}
    end
    G.crownIndex=1
    G.crownMovedThisRound=false
    G.cityNames={}

    -- Move physical crown to the starting crowned player
    Wait.time(function() moveCrown(G.players[G.crownIndex]) end, 0.5)

    -- For random/manual modes default to First Game unique districts
    if G.setupMode ~= 'scenario' then G.scenarioIndex = 1 end

    -- Resolve the character cast
    resolveCast()

    -- Set up unique districts for this scenario (must happen before dealDistrictCards)
    setupUniqueDistricts()

    -- Move cast tokens into their display row
    gatherAllCharTokens()
    setupSpecialMarkers()

    -- Starting gold — wait for setupUniqueDistricts to finish (30 cards * 0.12s + 1s buffer)
    local uniqueDelay = 30 * 0.12 + 1.5
    for i,color in ipairs(G.players) do
        local c = color
        Wait.time(function() giveGold(c, 2) end, uniqueDelay + (i-1) * 1.5)
    end
    -- Deal district cards after unique districts shuffled and all gold dealt
    -- Shuffle district deck then deal (unique districts already shuffled in by setupUniqueDistricts)
    Wait.time(function()
        local dd = findDistrictDeck()
        if dd then dd.shuffle() end
        Wait.time(function() dealDistrictCards(4) end, 0.5)
    end, uniqueDelay + #G.players * 1.5)

    -- Hide setup panel during game
    btn('setupPanel', false)
    btn('pnlUniqueDist', false)
    btn('btnStart',   false)
    btn('btnBotsToggle', true)

    local modeLabel = G.setupMode=='scenario' and ('Scenario: '..SCENARIOS[G.scenarioIndex].name)
                   or G.setupMode=='random'   and 'Random Cast'
                   or 'Manual Cast'
    UI.setValue('txtMode', modeLabel)

    log('Game started — '..G.playerCount..' players — '..modeLabel)
    setCrownUI(); updateGoldUI()

    -- Play intro music: "The race to build the greatest"
    MusicPlayer.setCurrentAudioclip({
        title = 'The race to build the greatest',
        url   = 'https://dl.sndup.net/xyptd/The_race_to_build_the_greatest.mp3',
    })
    MusicPlayer.play()

    Wait.time(beginSelectionPhase, 1.5)
end

function dealDistrictCards(count)
    local deck=findDistrictDeck()
    if not deck then log('WARNING: District deck GUID '..GUID.districtCards..' not found.'); return end
    for _,color in ipairs(G.players) do
        for _=1,count do deck.deal(1,color) end
    end
end

-- ============================================================
--  SELECTION PHASE
-- ============================================================

function recountPhysicalGold()
    -- Physically count Gold coins near each player's area and correct G.gold if drifted.
    -- Beautify coins placed on district cards sit within the player's radius but are NOT
    -- spendable gold — subtract them from the count before comparing.
    for _, color in ipairs(G.players or {}) do
        if color and color ~= '' then
        local p = PLAYER_POS[color]
        if p then
            local count = 0
            for _, o in ipairs(getAllObjects()) do
                pcall(function()
                    if o.getName() == 'Gold' then
                        local op = o.getPosition()
                        if math.sqrt((op.x-p.x)^2+(op.z-p.z)^2) <= 14 then
                            count = count + 1
                        end
                    end
                end)
            end
            -- Beautify markers are renamed away from "Gold", so only spendable coins are counted here.
            local beautifyCoins = 0
            if count ~= (G.gold[color] or 0) then
                debugLog('Gold recount: '..color..' logged='..tostring(G.gold[color])..' physical='..count..' (excl. '..beautifyCoins..' beautify coins) → corrected.')
                G.gold[color] = count
            end
        end
        end -- if color
    end
    updateGoldUI()
end

function beginSelectionPhase()
    if G.resetting then return end
    local ok, err = xpcall(function()

    G.roundNumber=G.roundNumber+1; G.phase='SELECTION'; G.chosenBy={}; G.chosenBy2={}; G.selectionStep=0; G.selectionBusy=false
    G.turnAdvancePending = false; G.roundEnding = false
    setPhaseUI('SELECTION'); setRoundUI(); setCrownUI()
    setStatus('Selection Phase — Round '..G.roundNumber)
    log('=== Round '..G.roundNumber..' — Selection Phase ===')
    pcall(recountPhysicalGold)

    -- Reset all per-round ability state
    G.killedChar=nil;  G.bewitchedChar=nil; G.witchColor=nil
    G.robbedChar=nil;  G.thiefColor=nil
    G.bishopColor=nil; G.blackmailTargets={}; G.blackmailerColor=nil
    G.blackmailReal=nil; G.blackmailRealRank=nil; G.blackmailRealChar=nil; G.blackmailRealTokenGuid=nil
    G.spyData=nil;     G.artistBeautifyCount=0
    G.blackmailPending=nil; G.blackmailResolved=false
    G.magistrateColor=nil; G.warrantedChar=nil; G.warrantBuilds={}
    G.targeting=nil

    G.selectionOrder={}
    G.chosenBy2={}
    G.twoPlayerDiscardPending=false
    G.botSeenChars={}

    if G.playerCount==2 then
        local colorA=G.players[G.crownIndex] or G.players[1]
        local colorB=G.players[(G.crownIndex%2)+1] or G.players[2]
        G.selectionOrder={colorA,colorB,colorA,colorB}
    elseif G.playerCount==3 then
        for i=0,2 do
            local idx=((G.crownIndex-1+i)%3)+1
            table.insert(G.selectionOrder, G.players[idx] or G.players[1])
        end
        for i=0,2 do
            local idx=((G.crownIndex-1+i)%3)+1
            table.insert(G.selectionOrder, G.players[idx] or G.players[1])
        end
    else
        for i=0,G.playerCount-1 do
            local idx=((G.crownIndex-1+i)%G.playerCount)+1
            local c = G.players[idx]
            if c then table.insert(G.selectionOrder, c) end
        end
    end
    -- Strip any nil entries that slipped in
    local cleanOrder = {}
    for _, c in ipairs(G.selectionOrder) do
        if c then table.insert(cleanOrder, c) end
    end
    G.selectionOrder = cleanOrder

    local gatherTime = gatherAllCharCards()  -- returns exact time needed
    pcall(gatherAllCharTokens)
    Wait.time(doDiscardPhase, gatherTime)

    end, function(e) return debug and debug.traceback and debug.traceback(e,2) or tostring(e) end)
    if not ok then
        printToAll('[Citadels] beginSelectionPhase error: '..tostring(err), {1,0.4,0.4})
        -- Still try to proceed so the game isn't stuck
        local gatherTime = gatherAllCharCards()
        pcall(gatherAllCharTokens)
        Wait.time(doDiscardPhase, gatherTime)
    end
end

function gatherAllCharCards()
    -- Build a set of all cast GUIDs for quick lookup
    local castSet = {}
    local castNameToRank = {}
    for rank=1,9 do
        local guid = G.gameCast[rank]
        if guid then
            castSet[guid] = rank
            local charName = CHAR_NAME[guid]
            if charName and charName ~= '' then castNameToRank[charName] = rank end
        end
    end

    -- Phase 1: pull any cast cards out of player hands onto the table.
    local pullDelay = 0
    for _, color in ipairs(G.players or {}) do
        -- Do not skip bot seats here. Character cards can end up hidden in a bot hand
        -- after effects like Theater or from hand-zone capture during physics movement.
        if color and color ~= '' then
            local p = Player[color]
            if p then
                local ok, hobjs = pcall(function() return p.getHandObjects() end)
                if ok and hobjs then
                    for _, hobj in ipairs(hobjs) do
                        pcall(function()
                            local g = nil
                            local name = nil
                            pcall(function() g = hobj.getGUID() end)
                            pcall(function() name = (hobj.getName() or ''):match('^%s*(.-)%s*$') end)
                            local rank = (g and castSet[g]) or (name and castNameToRank[name])
                            if rank then
                                -- Move cards directly into unique staging slots instead of
                                -- dropping them near player areas where they can stack.
                                local dropPos = charStagingPos(rank, 1)
                                local captured_obj = hobj
                                local captured_pos  = dropPos
                                Wait.time(function()
                                    if G.resetting or G.phase ~= 'SELECTION' then return end
                                    pcall(function()
                                        local freshObj = captured_obj
                                        if freshObj then
                                            freshObj.setPosition(captured_pos)
                                            freshObj.setRotation({0,0,180})
                                        end
                                    end)
                                end, pullDelay)
                                pullDelay = pullDelay + 0.15
                            end
                        end)
                    end
                end
            end
        end
    end

    -- Phase 2: move every cast card to staging.
    local castGuids = {}
    local castCount = 0
    for rank=1,9 do
        if G.gameCast[rank] then
            castGuids[G.gameCast[rank]] = true
            castCount = castCount + 1
        end
    end

    -- Phase 2 starts after all hand-pulls settle
    local phase2Start = pullDelay + 0.6
    Wait.time(function()
        if G.resetting or G.phase ~= 'SELECTION' then return end
        -- Step A: extract any char cards trapped inside deck objects
        local extractIdx = 0
        for _, o in ipairs(getAllObjects()) do
            pcall(function()
                if o.type == 'Deck' then
                    local ok, contents = pcall(function() return o.getObjects() end)
                    if ok and contents then
                        for _, entry in ipairs(contents) do
                            local entryGuid = entry and entry.guid
                            if entryGuid and castGuids[entryGuid] then
                                local dg = entry.guid
                                extractIdx = extractIdx + 1
                                pcall(function()
                                    if G.resetting or G.phase ~= 'SELECTION' then return end
                                    -- Extract trapped character cards into separate staging
                                    -- slots so deck ejection never creates a stacked pile.
                                    local spread = charStagingPos(extractIdx, 2)
                                    o.takeObject({guid=dg, position=spread, smooth=false})
                                end)
                            end
                        end
                    end
                end
            end)
        end

        -- Step B: move all cast cards to their staging spots.
        local cardOrder = {}
        for rank=1,9 do
            if G.gameCast[rank] then table.insert(cardOrder, G.gameCast[rank]) end
        end
        for idx, guid in ipairs(cardOrder) do
            local i = idx - 1
            -- Re-seat every cast card into its final staging slot before discard/setup.
            local dest = charStagingPos(i + 1, 0)
            local cg, cd = guid, dest
            Wait.time(function()
                if G.resetting or G.phase ~= 'SELECTION' then return end
                pcall(function()
                    local card = obj(cg)
                    if card then
                        card.setRotation({0,0,180})
                        liftThenPlace(card, cd)
                    end
                end)
            end, 0.6 + i * 0.12)
        end
    end, phase2Start)

    -- Return the total time this function will take so the caller can schedule
    -- doDiscardPhase exactly when gathering is done, with a small buffer.
    local stagingTime = 0.6 + (castCount - 1) * 0.12  -- last card's delay
    local totalTime   = phase2Start + stagingTime + 1.2  -- +1.2s buffer for liftThenPlace arc
    return totalTime
end


-- Move cast character tokens into a visible row using lift-over to avoid hand zones
function gatherAllCharTokens()
    local i=0
    for rank=1,9 do
        local guid=G.gameCast[rank]
        if guid then
            local tokenGuid=CHAR_TOKEN[guid]
            if tokenGuid then
                -- Re-lookup by GUID inside pcall — captured references can go stale
                local dest={
                    x=TOKEN_ROW_POS.x+i*TOKEN_SPREAD_GAP,
                    y=TOKEN_ROW_POS.y,
                    z=TOKEN_ROW_POS.z,
                }
                local tg = tokenGuid  -- capture for closure
                local d  = dest
                local delay = i * 0.08
                Wait.time(function()
                    if G.resetting then return end
                    pcall(function()
                        local token = obj(tg)
                        if token then
                            token.setRotation({0,0,0})
                            liftThenPlace(token, d)
                        end
                    end)
                end, delay + 0.1)
                i=i+1
            end
        end
    end
end

-- Move warrant/threat markers to the play area only if their character is in the cast.
-- Markers NOT in the cast are left exactly where they are.
function setupSpecialMarkers()
    local hasMagistrate = false
    local hasBlackmailer = false
    for rank=1,9 do
        if G.gameCast[rank]==GUID.magistrate  then hasMagistrate=true  end
        if G.gameCast[rank]==GUID.blackmailer then hasBlackmailer=true end
    end

    if hasMagistrate then
        local warrantGuids = {GUID.warrant1, GUID.warrant2, GUID.warrant3}
        for i,guid in ipairs(warrantGuids) do
            local g,idx = guid,i
            pcall(function()
                local o = obj(g)
                if o then liftThenPlace(o, {
                    x=MARKER_POS.warrant.x+(idx-1)*1.5,
                    y=MARKER_POS.warrant.y,
                    z=MARKER_POS.warrant.z,
                }, (idx-1)*0.15) end
            end)
        end
        log('Magistrate in cast — warrant markers moved to table.')
    end

    if hasBlackmailer then
        local threatGuids = {GUID.threat1, GUID.threat2}
        for i,guid in ipairs(threatGuids) do
            local g,idx = guid,i
            pcall(function()
                local o = obj(g)
                if o then liftThenPlace(o, {
                    x=MARKER_POS.threat.x+(idx-1)*1.5,
                    y=MARKER_POS.threat.y,
                    z=MARKER_POS.threat.z,
                }, (idx-1)*0.15) end
            end)
        end
        log('Blackmailer in cast — threat markers moved to table.')
    end
end

function doDiscardPhase()
    if G.resetting then return end
    -- Pool = all cast characters that are valid this game
    local pool={}
    for rank=1,9 do
        local guid=G.gameCast[rank]
        if guid then table.insert(pool,guid) end
    end
    shuffle(pool)

    local faceUpCount=({[2]=0,[3]=0,[4]=2,[5]=1,[6]=0,[7]=0,[8]=0})[G.playerCount] or 0

    -- 1 face-down discard (never rank 4)
    G.faceDownDiscardGuid = nil
    for i,guid in ipairs(pool) do
        if CHAR_RANK[guid]~=4 then
            local card=obj(guid)
            if card then pcall(function()
                card.setRotation({0,0,180}); liftThenPlace(card, DISCARD_DOWN_POS)
            end) end
            G.faceDownDiscardGuid = guid
            table.remove(pool,i); break
        end
    end

    -- Face-up discards (never rank 4)
    G.faceUpDiscards = G.faceUpDiscards or {}
    for k in pairs(G.faceUpDiscards) do G.faceUpDiscards[k] = nil end
    local fuDone=0; local i=1
    while fuDone<faceUpCount and i<=#pool do
        if CHAR_RANK[pool[i]]~=4 then
            local guid = pool[i]
            local card=obj(guid)
            if card then pcall(function()
                card.setRotation({0,0,0})
                liftThenPlace(card, {x=DISCARD_UP_POS.x+fuDone*CARD_SPREAD_GAP,y=DISCARD_UP_POS.y,z=DISCARD_UP_POS.z})
            end) end
            G.faceUpDiscards[guid] = true
            table.remove(pool,i); fuDone=fuDone+1
        else i=i+1 end
    end

    G.activeCharGuids=pool
    debugLog('Discarded '..fuDone..' face-up, 1 face-down. '..#G.activeCharGuids..' in selection pool.')
    advanceSelection()
end

function advanceSelection()
    if G.resetting then return end
    G.selectionStep=G.selectionStep+1

    -- 7-player rule (step 7) and 8-player rule (step 8):
    -- The last player receives the remaining pool card(s) PLUS the face-down discard.
    -- Add the face-down discard back into activeCharGuids so it gets spread to them.
    -- NOTE: we add the GUID unconditionally even if obj() returns nil (card may be inside a
    -- deck, in which case obj() returns nil but the GUID is still valid). The deck-extraction
    -- loop below will find and free it from any deck it ended up in.
    local isLastPlayerSpecial = (G.playerCount==7 and G.selectionStep==7)
                              or (G.playerCount==8 and G.selectionStep==8)
    if isLastPlayerSpecial and G.faceDownDiscardGuid then
        table.insert(G.activeCharGuids, G.faceDownDiscardGuid)
        -- Try to set rotation if the card is directly accessible
        local fdCard = obj(G.faceDownDiscardGuid)
        if fdCard then pcall(function() fdCard.setRotation({0,0,180}) end) end
        G.faceDownDiscardGuid = nil   -- consumed
        local lastColor = G.selectionOrder[G.selectionStep]
        logTo(lastColor, 'Special rule: you receive the last card AND the face-down discard. Both will be spread to you — drag your chosen one INTO YOUR HAND, then click confirm. Drag the other face-down to the CENTER OF THE TABLE.')
        printToAll('📋  '..lastColor..' receives the face-down discard (special '..G.playerCount..'-player rule).',{0.9,0.8,0.5})
    end

    local maxSelSteps
    if     G.playerCount==2 then maxSelSteps=4
    elseif G.playerCount==3 then maxSelSteps=6
    else   maxSelSteps=G.playerCount end

    if G.selectionStep>maxSelSteps then
        -- Discard ALL remaining cards face-down (not just the first one)
        for i,guid in ipairs(G.activeCharGuids) do
            local leftover = obj(guid)
            if leftover then
                pcall(function()
                    leftover.setRotation({0,0,180})
                    liftThenPlace(leftover,
                        {x=DISCARD_DOWN_POS.x+(math.random()-0.5)*1.5,
                         y=DISCARD_DOWN_POS.y,
                         z=DISCARD_DOWN_POS.z+(math.random()-0.5)*1.5},
                        (i-1)*0.1)
                end)
            end
        end
        G.activeCharGuids = {}
        log('All characters chosen. Starting turn phase.')
        btn('btnReady',false)
        -- Theater check: if someone has Theater, let them swap a character card first
        Wait.time(beginTheaterPhase,1.0)
        return
    end

    local color=G.selectionOrder[G.selectionStep]
    if not color then
        log('WARN: selectionOrder[' .. tostring(G.selectionStep) .. '] is nil — skipping step')
        G.selectionBusy = false
        Wait.time(advanceSelection, 0.3)
        return
    end
    local pos=PLAYER_POS[color]; local n=#G.activeCharGuids

    -- Extract any active char cards that were stacked into a deck by a previous chooser.
    -- We scan ALL decks proactively since obj(guid) may return nil OR the deck itself.
    local function deckContainsCardGuid(deckObj, cardGuid)
        if not deckObj or deckObj.type ~= 'Deck' or not cardGuid then return false end
        local ok, contents = pcall(function() return deckObj.getObjects() end)
        if not ok or not contents then return false end
        for _, entry in ipairs(contents) do
            if entry and entry.guid == cardGuid then return true end
        end
        return false
    end

    local function findDeckWithCardGuid(cardGuid)
        if not cardGuid then return nil end
        for _, candidate in ipairs(getAllObjects()) do
            local found = nil
            pcall(function()
                if candidate.type == 'Deck' and deckContainsCardGuid(candidate, cardGuid) then
                    found = candidate
                end
            end)
            if found then return found end
        end
        return nil
    end

    local extractDelay = 0
    local toExtract = {}   -- {deckGuid, cardGuid} pairs found
    local seenExtract = {}

    for _, o in ipairs(getAllObjects()) do
        pcall(function()
            if o.type == 'Deck' then
                local deckGuid = o.getGUID()
                local ok, contents = pcall(function() return o.getObjects() end)
                if ok and contents then
                    for _, entry in ipairs(contents) do
                        local entryGuid = entry and entry.guid
                        if entryGuid and contains(G.activeCharGuids, entryGuid) and not seenExtract[entryGuid] then
                            table.insert(toExtract, {deckGuid=deckGuid, cardGuid=entryGuid})
                            seenExtract[entryGuid] = true
                        end
                    end
                end
            end
        end)
    end

    for extractIdx, ex in ipairs(toExtract) do
        local cg, dg = ex.cardGuid, ex.deckGuid
        Wait.time(function()
            local stageOffset = (extractIdx-1)*CARD_SPREAD_GAP - (#toExtract-1)*CARD_SPREAD_GAP*0.5
            local stagePos = {
                x = STAGING_POS.x + stageOffset,
                y = LIFT_Y,
                z = STAGING_POS.z + (math.random()-0.5)*0.4
            }

            -- If the card is already loose, just re-stage it.
            local looseCard = obj(cg)
            if looseCard and looseCard.type ~= 'Deck' then
                pcall(function()
                    looseCard.setPosition(stagePos)
                    looseCard.setRotation({0,0,180})
                end)
                return
            end

            -- Re-fetch the deck by GUID, but fall back to a live deck scan if the
            -- card moved into a different deck after the first scan.
            local deck = obj(dg)
            if not deck or deck.type ~= 'Deck' or not deckContainsCardGuid(deck, cg) then
                deck = findDeckWithCardGuid(cg)
            end
            if not deck then return end
            pcall(function()
                deck.takeObject({
                    guid     = cg,
                    position = stagePos,
                    rotation = {0,0,180},
                    smooth   = false,
                })
            end)
        end, extractDelay)
        extractDelay = extractDelay + 0.22
    end

    -- Shuffle activeCharGuids before spreading so card positions don't reveal pass order
    do
        local t = G.activeCharGuids
        for i = #t, 2, -1 do
            local j = math.random(i)
            t[i], t[j] = t[j], t[i]
        end
    end

    -- Spread cards to the current chooser after any extraction is complete.
    -- Shuffle the spread order so card positions don't reveal rank information.
    -- Place cards 50% of the way between the player's seat and the table center so
    -- they land clear of built district cards (which sit at ~pos ± 6 units).
    local isSidePlayer = pos and math.abs(pos.x) > 40
    -- selX/selZ: the anchor point for the spread, pushed toward center
    local selX = pos and pos.x * 0.50 or 0
    local selZ = pos and pos.z * 0.50 or 0
    Wait.time(function()
        local fresh_n = #G.activeCharGuids
        local spreadOrder = {}
        for i=1,fresh_n do table.insert(spreadOrder, i) end
        for i=#spreadOrder,2,-1 do
            local j = math.random(i)
            spreadOrder[i],spreadOrder[j] = spreadOrder[j],spreadOrder[i]
        end
        for slot, srcIdx in ipairs(spreadOrder) do
            local guid = G.activeCharGuids[srcIdx]
            local card = obj(guid)
            if card and pos then
                local capturedCard = card
                local capturedSlot = slot
                local offset = (capturedSlot-1)*CARD_SPREAD_GAP - (fresh_n-1)*CARD_SPREAD_GAP*0.5
                if isSidePlayer then
                    pcall(function()
                        capturedCard.setRotation({0, 90, 180})
                        liftThenPlace(capturedCard, {
                            x = selX,
                            y = pos.y,
                            z = selZ + offset,
                        }, (capturedSlot-1)*0.06)
                    end)
                else
                    pcall(function()
                        capturedCard.setRotation({0, 0, 180})
                        liftThenPlace(capturedCard, {
                            x = selX + offset,
                            y = pos.y,
                            z = selZ,
                        }, (capturedSlot-1)*0.06)
                    end)
                end
            else
                -- Card not directly accessible — re-try after extraction settles.
                local capturedGuid = guid
                local capturedSlot = slot
                local offset = (capturedSlot-1)*CARD_SPREAD_GAP - (fresh_n-1)*CARD_SPREAD_GAP*0.5
                Wait.time(function()
                    local retryCard = obj(capturedGuid)
                    if retryCard and pos then
                        pcall(function()
                            retryCard.setRotation(isSidePlayer and {0,90,180} or {0,0,180})
                            liftThenPlace(retryCard, {
                                x = isSidePlayer and selX or selX + offset,
                                y = pos.y,
                                z = isSidePlayer and selZ + offset or selZ,
                            })
                        end)
                    end
                end, 0.5)
            end
        end
    end, extractDelay + 0.4)

    debugLog(color..' is choosing ('..n..' cards).')
    local pickNum = ''
    if G.playerCount==2 then
        -- Steps 1,3=colorA's turns; steps 2,4=colorB's turns. This is their 1st or 2nd pick.
        pickNum = (G.selectionStep<=2) and ' (1st character)' or ' (2nd character)'
    elseif G.playerCount==3 then
        pickNum = (G.selectionStep<=3) and ' (1st character)' or ' (2nd character)'
    end
    logTo(color, '🃏 SELECTION: Drag your chosen character card INTO YOUR HAND (bottom of screen), then click "I\'ve Chosen My Character". Any cards you are not keeping should be dragged face-down to the CENTER OF THE TABLE.'..pickNum)
    setStatus(color..' is choosing'..pickNum..'...')
    setTurnUI('Selecting:\n'..color, color)
    btn('btnReady',true)

    -- Bot: auto-pick after cards have been spread (extraction + spread delay + 1s)
    if isBot(color) then
        btn('btnReady', false)  -- bot doesn't need the button
        Wait.time(function()
            G.selectionBusy = true
            botDoSelection(color)
        end, extractDelay + 1.8)
    end

    -- Give the selection glow to the current chooser
end

-- Called when a player clicks a character card during selection phase
-- Replaces the fragile position-detection approach entirely
function onObjectClick(click_object, player_color)
    if G.phase ~= 'SELECTION' then return end
    if G.selectionBusy then return end

    -- Only respond to clicks on character cards that are in the active pool
    local clickedGuid = click_object.getGUID()
    if not contains(G.activeCharGuids, clickedGuid) then return end

    -- Only the current chooser can select
    local expected = G.selectionOrder[G.selectionStep]
    if player_color ~= expected then
        if expected then
            logTo(player_color, 'It is '..expected.."'s turn to choose, not yours.")
        end
        return
    end

    -- Register the pending selection and highlight the card
    G.pendingChoice = clickedGuid
    -- Visually mark the selected card (tilt it slightly as indicator)
    for _, guid in ipairs(G.activeCharGuids) do
        local c = obj(guid)
        if c then
            pcall(function()
                if guid == clickedGuid then
                    c.setRotation({15, 0, 180})  -- tilted = selected
                else
                    c.setRotation({0, 0, 180})   -- flat = not selected
                end
            end)
        end
    end

    logTo(player_color, 'Selected: '..CHAR_NAME[clickedGuid]..'. Click the button to confirm.')
    setStatus(player_color..' is selecting...')

end

function onBtnReady(player)
    if G.phase ~= 'SELECTION' then return end
    if G.selectionBusy then logTo(player.color, 'Please wait...'); return end

    -- 2-player discard sub-step: player must discard one card face-down
    if G.twoPlayerDiscardPending then
        local expected = G.selectionOrder[G.selectionStep]
        if player.color ~= expected then
            logTo(player.color, 'Not your turn to discard!')
            return
        end
        -- If the player dragged a card physically rather than clicking it,
        -- scan for any activeCharGuids card that is no longer near the player's spread position.
        if not G.pendingChoice then
            local dpos = PLAYER_POS[player.color]
            -- Pass 1: loose cards — obj(guid) works normally
            for _, guid in ipairs(G.activeCharGuids) do
                local dc = obj(guid)
                if dc and dpos then
                    pcall(function()
                        local p = dc.getPosition()
                        local dist = math.sqrt((p.x-dpos.x)^2+(p.z-dpos.z)^2)
                        if dist > 18 then
                            G.pendingChoice = guid
                        end
                    end)
                    if G.pendingChoice then break end
                end
            end
            -- Pass 2: card may have been stacked into a Deck (obj returns nil for cards
            -- inside a deck). Scan all Deck objects for any active char card GUID.
            if not G.pendingChoice and dpos then
                for _, o in ipairs(getAllObjects()) do
                    if G.pendingChoice then break end
                    pcall(function()
                        if o.type == 'Deck' then
                            local ok, contents = pcall(function() return o.getObjects() end)
                            if ok and contents then
                                for _, entry in ipairs(contents) do
                                    if contains(G.activeCharGuids, entry.guid) then
                                        local dp = o.getPosition()
                                        local dist = math.sqrt((dp.x-dpos.x)^2+(dp.z-dpos.z)^2)
                                        if dist > 18 then
                                            -- Extract the card from the deck before discarding
                                            local cg = entry.guid
                                            pcall(function()
                                                o.takeObject({
                                                    guid     = cg,
                                                    position = {x=dp.x, y=dp.y+1, z=dp.z},
                                                    smooth   = false,
                                                })
                                            end)
                                            G.pendingChoice = cg
                                        end
                                        break
                                    end
                                end
                            end
                        end
                    end)
                end
            end
            if G.pendingChoice then
                logTo(player.color, 'Detected card moved away — selected for discard. Press button to confirm.')
            end
        end
        if not G.pendingChoice then
            logTo(player.color, 'Click one of the cards spread near you to select it for discard, then press the red button.')
            return
        end
        -- Discard the chosen card face-down
        local discardGuid = G.pendingChoice
        G.pendingChoice   = nil
        G.twoPlayerDiscardPending = false
        local dcard = obj(discardGuid)
        if dcard then
            pcall(function()
                dcard.setRotation({0,0,180})
                liftThenPlace(dcard, {x=DISCARD_DOWN_POS.x+(math.random()-0.5),
                                       y=DISCARD_DOWN_POS.y,
                                       z=DISCARD_DOWN_POS.z+(math.random()-0.5)})
            end)
        end
        removeValue(G.activeCharGuids, discardGuid)
        logTo(player.color, 'Card discarded face-down. Passing remaining cards...')
        debugLog(player.color..' discarded a card face-down (mid-round discard, step '..G.selectionStep..').')
        -- Restore button to normal label/colour
        UI.setAttribute('btnReady','text',"✔  I've Chosen My Character")
        UI.setAttribute('btnReady','tooltip','Confirm your character selection.')
        UI.setAttribute('btnReady','colors','#1A5276|#2E86C1|#154360|#1A5276')
        btn('btnReady', false)
        Wait.time(function()
            G.selectionBusy = false
            advanceSelection()
        end, 0.5)
        return
    end

    local expected = G.selectionOrder[G.selectionStep]
    if player.color ~= expected then
        logTo(player.color, 'Not your turn to choose! Waiting for '..expected..'.')
        return
    end

    -- If no card was clicked on the table, check whether the player dragged one
    -- into their hand zone. Cards may be individual OR stacked into a deck in hand.
    if not G.pendingChoice then
        local handObjects = Player[player.color] and Player[player.color].getHandObjects() or {}
        for _, hobj in ipairs(handObjects) do
            pcall(function()
                local guid = hobj.getGUID()
                if contains(G.activeCharGuids, guid) then
                    G.pendingChoice = guid
                end
            end)
            if G.pendingChoice then break end
            -- Deck in hand: player stacked character cards together — search inside
            if not G.pendingChoice then
                pcall(function()
                    if hobj.type == 'Deck' then
                        local ok, contained = pcall(function() return hobj.getObjects() end)
                        if ok and contained then
                            for _, entry in ipairs(contained) do
                                if contains(G.activeCharGuids, entry.guid) then
                                    local takePos = PLAYER_POS[player.color] or {x=0,y=1.5,z=0}
                                    pcall(function()
                                        if hobj.getPosition then takePos = PLAYER_POS[player.color] or hobj.getPosition() end
                                        hobj.takeObject({
                                            guid     = entry.guid,
                                            position = {x=takePos.x, y=takePos.y+2, z=takePos.z-3},
                                            smooth   = false,
                                        })
                                    end)
                                    G.pendingChoice = entry.guid
                                end
                            end
                        end
                    end
                end)
            end
            if G.pendingChoice then break end
        end
    end

    if not G.pendingChoice then
        logTo(player.color, 'Select a character card first — click it on the table, or drag it into your hand, then click here.')
        return
    end

    -- Block if the player has MORE than one character card in their hand
    -- (they may have accidentally grabbed two from the pool)
    local handCheck = Player[player.color] and Player[player.color].getHandObjects() or {}
    local charCardsInHand = {}
    for _, hobj in ipairs(handCheck) do
        pcall(function()
            if hobj.type == 'Deck' then
                local ok, contained = pcall(function() return hobj.getObjects() end)
                if ok and contained then
                    for _, entry in ipairs(contained) do
                        if contains(G.activeCharGuids, entry.guid) or entry.guid == G.pendingChoice then
                            table.insert(charCardsInHand, entry.guid)
                        end
                    end
                end
            else
                local g = hobj.getGUID()
                if contains(G.activeCharGuids, g) or g == G.pendingChoice then
                    table.insert(charCardsInHand, g)
                end
            end
        end)
    end
    -- On second picks (2p steps 3-4, 3p steps 4-6) player already holds their first card.
    -- On 7p step 7 / 8p step 8 the player holds the pool card AND the face-down discard (2 cards).
    local isSecondPick = (G.playerCount==2 and G.selectionStep>2)
                      or (G.playerCount==3 and G.selectionStep>3)
                      or (G.playerCount==7 and G.selectionStep==7)
                      or (G.playerCount==8 and G.selectionStep==8)
    if #charCardsInHand > (isSecondPick and 2 or 1) then
        logTo(player.color, 'You have '..#charCardsInHand..' character cards in your hand — return extras to the table first, then click confirm.')
        return
    end

    -- Make sure the pending choice is still in the pool (race condition safety)
    if not contains(G.activeCharGuids, G.pendingChoice) then
        logTo(player.color, 'That card is no longer available. Please click another.')
        G.pendingChoice = nil
        return
    end

    -- Lock out further interaction
    G.selectionBusy = true
    btn('btnReady', false)

    local chosenGuid = G.pendingChoice
    G.pendingChoice  = nil

    -- 2p steps 3-4 and 3p steps 4-6 are SECOND picks → store in chosenBy2
    -- Without this, the second pick overwrites the first pick in chosenBy and
    -- the first character is lost from turnOrder entirely.
    if (G.playerCount==2 and G.selectionStep>=3)
    or (G.playerCount==3 and G.selectionStep>=4) then
        G.chosenBy2[player.color] = chosenGuid
    else
        G.chosenBy[player.color] = chosenGuid
    end
    removeValue(G.activeCharGuids, chosenGuid)

    -- Move chosen card in front of the player, unless they already have it in hand
    local card = obj(chosenGuid)
    local pos  = PLAYER_POS[player.color]
    local inHand = false
    if card then
        local handObjects = Player[player.color] and Player[player.color].getHandObjects() or {}
        for _, hobj in ipairs(handObjects) do
            pcall(function()
                if hobj.getGUID() == chosenGuid then inHand = true end
            end)
            if inHand then break end
        end
    end
    if card and pos and not inHand then
        pcall(function()
            card.setRotation({0, 0, 180})
            -- Offset 2nd character card slightly so they don't overlap
            local isSecondCard = (G.playerCount==2 and G.selectionStep>=3) or (G.playerCount==3 and G.selectionStep>=4)
            local zOff = isSecondCard and -5.5 or -3.5
            liftThenPlace(card, {x=pos.x, y=pos.y, z=pos.z + zOff})
        end)
    end

    -- Reset tilt on remaining cards
    for _, guid in ipairs(G.activeCharGuids) do
        local c = obj(guid)
        if c then pcall(function() c.setRotation({0, 0, 180}) end) end
    end

    local charName = CHAR_NAME[chosenGuid] or '?'
    logTo(player.color, 'You chose '..charName..'. Your secret is safe!')
    debugLog(player.color..' has chosen their character (step '..G.selectionStep..').')

    -- 2p: after steps 2 and 3 the picker discards one card face-down.
    -- 3p: after step 3 (P3's first pick) P3 discards one card face-down.
    local needsMidDiscard = (G.playerCount==2 and (G.selectionStep==2 or G.selectionStep==3))
                         or (G.playerCount==3 and G.selectionStep==3)
    if needsMidDiscard then
        Wait.time(function()
            G.selectionBusy = false
            G.twoPlayerDiscardPending = true
            -- Show remaining cards spread toward the center of the table (50% of seat
            -- distance) so they don't land on top of built district cards.
            local fresh_n = #G.activeCharGuids
            local dpos = PLAYER_POS[player.color]
            local isSide = dpos and math.abs(dpos.x) > 40
            local selX = dpos and dpos.x * 0.50 or 0
            local selZ = dpos and dpos.z * 0.50 or 0
            for i, guid in ipairs(G.activeCharGuids) do
                local dc = obj(guid)
                if dc and dpos then
                    local ci, fresh_ni = i, fresh_n
                    local offset = (ci-1)*CARD_SPREAD_GAP - (fresh_ni-1)*CARD_SPREAD_GAP*0.5
                    if isSide then
                        pcall(function()
                            dc.setRotation({0, 90, 180})
                            liftThenPlace(dc, {
                                x = selX,
                                y = dpos.y,
                                z = selZ + offset,
                            }, (ci-1)*0.06)
                        end)
                    else
                        pcall(function()
                            dc.setRotation({0, 0, 180})
                            liftThenPlace(dc, {
                                x = selX + offset,
                                y = dpos.y,
                                z = selZ,
                            }, (ci-1)*0.06)
                        end)
                    end
                end
            end
            logTo(player.color, '🗑️  MID-ROUND DISCARD: Your chosen character is safe. You must drag ONE of the '..fresh_n..' remaining cards to the CENTER OF THE TABLE face-down, then press ✖ Confirm Discard. The rest will pass to the next player.')
            setStatus('⚠️  '..player.color..': drag 1 card to center face-down,\nthen press Confirm Discard!')
            UI.setAttribute('btnReady','text','✖  Confirm Discard')
            UI.setAttribute('btnReady','tooltip','Confirm which card to discard face-down. Click a card first to select it, then press this button.')
            UI.setAttribute('btnReady','colors','#922B21|#E74C3C|#641E16|#922B21')
            btn('btnReady', true)
        end, 0.6)
        return
    end

    Wait.time(function()
        G.selectionBusy = false
        advanceSelection()
    end, 0.5)
end

-- ============================================================
--  HELPERS: character name lookup by rank in current cast
-- ============================================================
local function charNameForRank(rank)
    local guid = G.gameCast[rank]
    return guid and CHAR_NAME[guid] or ('Rank '..rank)
end

local function colorForChar(guid)
    for color, cg in pairs(G.chosenBy) do
        if cg == guid then return color end
    end
    for color, cg in pairs(G.chosenBy2 or {}) do
        if cg == guid then return color end
    end
    return nil
end

local function richestPlayer(excludeColor)
    -- Returns the player (other than excludeColor) with the most gold.
    -- In a tie, returns the first one found in turn order.
    local best, bestG = nil, -1
    for _, c in ipairs(G.players) do
        if c ~= excludeColor and (G.gold[c] or 0) > bestG then
            best=c; bestG=(G.gold[c] or 0)
        end
    end
    return best, bestG
end

local function countDistrictType(color, dtype)
    -- Count districts of dtype in city.
    -- School of Magic counts as any type for income (auto-applied to queried type).
    -- Haunted Quarter only counts for end-game scoring, NOT income.
    local base = (G.buildTypes[color] and G.buildTypes[color][dtype]) or 0
    if hasUnique and hasUnique(color,'School of Magic') then
        base = base + 1
    end
    return base
end

local function incomeForChar(charGuid, color)
    -- Returns gold income from rank ability based on districts
    local rank = CHAR_RANK[charGuid]
    local dtype = ({[4]='noble',[5]='religious',[6]='trade',[7]=nil,[8]='military'})[rank]
    if not dtype then return 0 end
    return countDistrictType(color, dtype)
end

-- ============================================================
--  ABILITY BUTTON TEXT per character
-- ============================================================
local ABILITY_LABEL = {
    -- Rank 1
    [GUID and GUID.assassin]    = {'Kill rank (skip their turn)',''},
    [GUID and GUID.witch]       = {'Bewitch rank (take their turn)',''},
    [GUID and GUID.magistrate]  = {'Place warrant on a rank',''},
    -- Rank 2
    [GUID and GUID.thief]       = {'Rob rank (steal all gold on reveal)',''},
    [GUID and GUID.spy]         = {'Spy (count district type, gain cards)',''},
    [GUID and GUID.blackmailer] = {'Threaten rank (pay or be exposed)',''},
    -- Rank 3
    [GUID and GUID.magician]    = {'Swap hands with a player','Discard cards, draw same amount'},
    [GUID and GUID.wizard]      = {"Look at a player's hand, keep 1",''},
    [GUID and GUID.seer]        = {'Take 1 random card from each player',''},
    -- Rank 4
    [GUID and GUID.king]        = {'Take crown + 1g per noble district',''},
    [GUID and GUID.emperor]     = {'Give crown, take 1g or card',''},
    [GUID and GUID.patrician]   = {'Take crown + 1 card per noble district',''},
    -- Rank 5
    [GUID and GUID.bishop]      = {'Gain 1g per religious district',''},
    [GUID and GUID.abbot]       = {'Gain 1g per religious district','Collect 1g from richest player'},
    [GUID and GUID.cardinal]    = {'Gain 1 card per religious district',''},
    -- Rank 6
    [GUID and GUID.merchant]    = {'Gain 1g per trade district + bonus 1g',''},
    [GUID and GUID.alchemist]   = {'Refund all gold spent to build at end of turn',''},
    [GUID and GUID.trader]      = {'Gain 1g per trade district (build any amount)',''},
    -- Rank 7
    [GUID and GUID.architect]   = {'Draw 2 cards (build up to 3 districts)',''},
    [GUID and GUID.navigator]   = {'Take 4 Gold','Draw 4 Cards'},
    [GUID and GUID.scholar]     = {'Draw 7 cards, keep 1, shuffle rest',''},
    -- Rank 8
    [GUID and GUID.warlord]     = {'Destroy a district (pay cost-1)','Gain 1g per military district'},
    [GUID and GUID.diplomat]    = {'Swap a district with a player (pay diff)','Gain 1g per military district'},
    [GUID and GUID.marshal]     = {'Gain 1g per military district','Seize district costing ≤3 (pay its cost)'},
    -- Rank 9
    [GUID and GUID.queen]       = {'Gain 3g (if seated next to rank 4)',''},
    [GUID and GUID.artist]      = {'Spend 1g to beautify a district (+1 pt)',''},
    [GUID and GUID.taxcollector]= {'Collect all tax gold from the plate',''},
}

-- Per-character tooltip text shown on the Use Ability buttons.
-- Index [1] = btnAbility tooltip, [2] = btnAbility2 tooltip.
local ABILITY_TOOLTIP = {
    -- Rank 1
    [GUID and GUID.assassin]    = {
        'Name a character rank. If any player chose that character, their turn is skipped this round.',
        ''},
    [GUID and GUID.witch]       = {
        'Gather first, then name a character rank to bewitch. Your turn pauses — you cannot build. When the bewitched character is called, they gather only (turn auto-ends). Then you resume as that character: use their abilities, build in your city with your gold.',
        ''},
    [GUID and GUID.magistrate]  = {
        'Place a signed warrant on a character rank. If the warranted character builds a district this round, you may confiscate it for free.',
        ''},
    -- Rank 2
    [GUID and GUID.thief]       = {
        'Name a character rank. When that character is revealed, you immediately steal all their gold.',
        ''},
    [GUID and GUID.spy]         = {
        'Choose a player and a district type. Look at their hand. For each matching card, take 1g from them and draw 1 card from the deck.',
        ''},
    [GUID and GUID.blackmailer] = {
        'Place a threat token on up to 2 character ranks. When threatened characters reveal, they must pay half their gold to you or risk being exposed.',
        ''},
    -- Rank 3
    [GUID and GUID.magician]    = {
        "Choose a player to swap your entire hand with theirs. Neither of you may look at the other's cards during the swap.",
        'Discard any number of cards from your hand face-down. Draw the same number from the district deck.'},
    [GUID and GUID.wizard]      = {
        'Choose a player, look at their entire hand privately, then take one card of your choice. You may build it this turn at normal cost.',
        ''},
    [GUID and GUID.seer]        = {
        "Take 1 random card from each other player's hand. Then give each of them 1 card back from your hand. Build limit becomes 2.",
        ''},
    -- Rank 4
    [GUID and GUID.king]        = {
        'Take the crown — you choose turn order next round. Gain 1 gold for each noble (yellow) district in your city.',
        ''},
    [GUID and GUID.emperor]     = {
        'Give the crown to any other player. Take 1 gold OR 1 random card from that player as payment. Gain 1g per noble district.',
        ''},
    [GUID and GUID.patrician]   = {
        'Take the crown — you choose turn order next round. Draw 1 card for each noble (yellow) district in your city.',
        ''},
    -- Rank 5
    [GUID and GUID.bishop]      = {
        'Gain 1 gold for each religious (blue) district in your city. Your districts cannot be destroyed by rank 8 characters this round.',
        ''},
    [GUID and GUID.abbot]       = {
        'Gain gold and/or cards equal to your number of religious (blue) districts — you split the total however you like.',
        'Collect 1 gold from whichever other player has the most gold (you choose in a tie).'},
    [GUID and GUID.cardinal]    = {
        'Draw 1 card for each religious (blue) district in your city. When you build a district and lack gold, you may automatically borrow the difference from another player (1 card per 1g borrowed).',
        ''},
    -- Rank 6
    [GUID and GUID.merchant]    = {
        'Gain 1 gold per trade (green) district in your city, plus 1 bonus gold.',
        ''},
    [GUID and GUID.alchemist]   = {
        'All gold you spend building districts this turn is fully refunded at End Turn. Activate this ability before building.',
        ''},
    [GUID and GUID.trader]      = {
        'Gain 1 gold per trade (green) district. You may build any number of districts this turn (unlimited build limit).',
        ''},
    -- Rank 7
    [GUID and GUID.architect]   = {
        'Draw 2 extra district cards into your hand (no discard required). You may build up to 3 districts this turn.',
        ''},
    [GUID and GUID.navigator]   = {
        'Choose: take 4 gold OR draw 4 cards. You cannot build any districts this turn regardless of your choice.',
        ''},
    [GUID and GUID.scholar]     = {
        'Draw 7 cards, choose 1 to keep, then shuffle the other 6 back into the deck. You may build up to 2 districts this turn.',
        ''},
    -- Rank 8
    [GUID and GUID.warlord]     = {
        "Pay (cost - 1) gold to destroy any district in any city except the Bishop's. Gain 1g per military (red) district you own.",
        'Gain 1 gold per military (red) district in your city. (Use first button to destroy a district.)'},
    [GUID and GUID.diplomat]    = {
        "Swap one of your built districts with one in another player's city. Pay the gold difference if theirs costs more. Gain 1g per military district.",
        'Gain 1 gold per military (red) district in your city.'},
    [GUID and GUID.marshal]     = {
        'Gain 1 gold per military (red) district in your city.',
        "Seize any district costing 3 gold or less from another player's city — pay its build cost to that player."},
    -- Rank 9
    [GUID and GUID.queen]       = {
        'Gain 3 gold if you are seated directly next to the player who chose rank 4 (King/Emperor/Patrician) this round.',
        ''},
    [GUID and GUID.artist]      = {
        'Spend 1 gold to place a beauty token on any district in your city. Each beautified district scores +1 point at game end. (Max 2 per turn.)',
        ''},
    [GUID and GUID.taxcollector]= {
        'Collect all accumulated tax gold from the tax plate. Tax gold is added to the plate (1g) whenever any player other than you builds a district.',
        ''},
}

-- ============================================================
--  TURN PHASE
-- ============================================================
-- ============================================================
--  THEATER — post-selection character-card swap
-- ============================================================

local botBestFairTheaterSwap

local function theaterSlotFallback(color, slot)
    local pos = PLAYER_POS[color]
    if not pos then return charStagingPos(1, 3) end
    local zOff = (slot == 'secondary') and -5.5 or -3.5
    return {x=pos.x, y=pos.y, z=pos.z + zOff}
end

local function captureTheaterCardSlot(color, guid, slot)
    local handPos = HAND_POS[color]
    local p = Player[color]
    if p and handPos then
        local ok, handObjs = pcall(function() return p.getHandObjects() end)
        if ok and handObjs then
            for _, hobj in ipairs(handObjs) do
                local directHit = false
                pcall(function() directHit = (hobj.getGUID() == guid) end)
                if directHit then
                    return {kind='hand', color=color, pos={x=handPos.x, y=handPos.y, z=handPos.z}, slot=slot}
                end
            end
        end
    end

    local card = obj(guid)
    if card then
        local pos = nil
        local rot = nil
        pcall(function() pos = card.getPosition() end)
        pcall(function() rot = card.getRotation() end)
        if pos then
            return {
                kind='table',
                color=color,
                pos={x=pos.x, y=pos.y, z=pos.z},
                rot=rot and {x=rot.x, y=rot.y, z=rot.z} or {x=0, y=0, z=180},
                slot=slot,
            }
        end
    end

    return {
        kind='table',
        color=color,
        pos=theaterSlotFallback(color, slot),
        rot={x=0, y=0, z=180},
        slot=slot,
    }
end

local function moveTheaterCardToSlot(guid, slot, delay, tempIndex)
    local stagePos = charStagingPos(tempIndex or 1, 3)
    Wait.time(function()
        pcall(function()
            local card = obj(guid)
            if not card then return end
            card.setRotation({0, 0, 180})
            card.setPosition({x=stagePos.x, y=stagePos.y + 4, z=stagePos.z})

            Wait.time(function()
                pcall(function()
                    local fresh = obj(guid)
                    if not fresh then return end

                    if slot.kind == 'hand' then
                        local hp = slot.pos or HAND_POS[slot.color]
                        if not hp then
                            hp = theaterSlotFallback(slot.color, slot.slot)
                            fresh.setRotation({0, 0, 180})
                            fresh.setPosition({x=hp.x, y=hp.y + 4, z=hp.z})
                            Wait.time(function()
                                pcall(function()
                                    local landed = obj(guid)
                                    if landed then landed.setPositionSmooth(hp, false, false) end
                                end)
                            end, 0.05)
                            return
                        end

                        local faceZ = (G.bots and G.bots[slot.color]) and 0 or 180
                        fresh.setRotation({0, 0, faceZ})
                        fresh.setPosition({x=hp.x, y=hp.y + 4, z=hp.z})
                        Wait.time(function()
                            pcall(function()
                                local landed = obj(guid)
                                if landed then landed.setPosition(hp) end
                            end)
                        end, 0.1)
                    else
                        local dest = slot.pos or theaterSlotFallback(slot.color, slot.slot)
                        local rot = slot.rot or {x=0, y=0, z=180}
                        fresh.setRotation({rot.x or 0, rot.y or 0, rot.z or 180})
                        fresh.setPosition({x=dest.x, y=dest.y + 4, z=dest.z})
                        Wait.time(function()
                            pcall(function()
                                local landed = obj(guid)
                                if landed then
                                    landed.setRotation({rot.x or 0, rot.y or 0, rot.z or 180})
                                    landed.setPositionSmooth(dest, false, false)
                                end
                            end)
                        end, 0.05)
                    end
                end)
            end, 0.15)
        end)
    end, delay or 0)
end

-- Executes the actual character-card swap between owner and target.
-- ownerGuidToGive: which of the owner's character GUIDs to hand over (nil = random).
local function theaterDoSwap(owner, target, ownerGuidToGive)
    local ownerChar1 = G.chosenBy[owner]
    local ownerChar2 = G.chosenBy2 and G.chosenBy2[owner]
    local targetChar1 = G.chosenBy[target]
    local targetChar2 = G.chosenBy2 and G.chosenBy2[target]

    -- Collect target's characters; pick one at random (blind exchange)
    local targetPool = {}
    if targetChar1 then table.insert(targetPool, {slot='primary',   guid=targetChar1}) end
    if targetChar2 then table.insert(targetPool, {slot='secondary', guid=targetChar2}) end
    if #targetPool == 0 then logTo(owner,'THEATER: target has no character to exchange.'); return end
    local targetChoice = targetPool[math.random(#targetPool)]

    -- Determine which owner character to give away
    local ownerPool = {}
    if ownerChar1 then table.insert(ownerPool, {slot='primary',   guid=ownerChar1}) end
    if ownerChar2 then table.insert(ownerPool, {slot='secondary', guid=ownerChar2}) end
    local ownerChoice
    for _, c in ipairs(ownerPool) do
        if c.guid == ownerGuidToGive then ownerChoice = c; break end
    end
    if not ownerChoice then ownerChoice = ownerPool[math.random(#ownerPool)] end
    if not ownerChoice then logTo(owner,'THEATER: could not find a character to give.'); return end

    local ownerSlot  = captureTheaterCardSlot(owner,  ownerChoice.guid,  ownerChoice.slot)
    local targetSlot = captureTheaterCardSlot(target, targetChoice.guid, targetChoice.slot)

    -- Swap chosenBy/chosenBy2 entries
    if ownerChoice.slot == 'primary' then
        G.chosenBy[owner]  = targetChoice.guid
    else
        G.chosenBy2[owner] = targetChoice.guid
    end
    if targetChoice.slot == 'primary' then
        G.chosenBy[target]  = ownerChoice.guid
    else
        G.chosenBy2[target] = ownerChoice.guid
    end

    -- Keep the physical cards aligned with the logical exchange.
    -- We route both cards through neutral staging spots first so we never
    -- try to land a card on top of the one still occupying that slot.
    moveTheaterCardToSlot(targetChoice.guid, ownerSlot, 0.00, 1)
    moveTheaterCardToSlot(ownerChoice.guid, targetSlot, 0.03, 2)

    -- Private notifications: each player sees their new character
    local ownerNewName  = CHAR_NAME[targetChoice.guid] or '?'
    local targetNewName = CHAR_NAME[ownerChoice.guid]  or '?'
    logTo(owner,  '🎭 THEATER: You gave away your character and received '..ownerNewName..' (rank '..
                  (CHAR_RANK[targetChoice.guid] or '?')..').')
    logTo(target, '🎭 A player with the Theater exchanged a character card with you. Your new character is '..
                  targetNewName..' (rank '..(CHAR_RANK[ownerChoice.guid] or '?')..').')
    printToAll('🎭  '..owner..' (Theater) secretly exchanged a character card with '..target..'!',{0.9,0.7,1.0})
end

-- Called in place of beginTurnPhase when a Theater owner is present.
-- Lets the Theater owner choose a target (and, in 2-3p, which char to give),
-- then executes the swap and proceeds to the turn phase.
function beginTheaterPhase()
    -- Find a Theater owner who hasn't exchanged this round
    local owner = nil
    for _, color in ipairs(G.players or {}) do
        if hasUnique(color, 'Theater') then owner = color; break end
    end
    if not owner then beginTurnPhase(); return end

    G.theaterOwner  = owner
    G.currentColor  = owner  -- needed so handleRankPick accepts this player's input

    -- Bot: infer the best swap from public information only.
    if G.bots and G.bots[owner] then
        local plan = botBestFairTheaterSwap and botBestFairTheaterSwap(owner)
        if plan and plan.targetColor and plan.ownerGuid then
            debugLog(string.format('[BOT] %s Theater targets %s with %s (score %.1f).',
                owner,
                plan.targetColor,
                CHAR_NAME[plan.ownerGuid] or '?',
                plan.score or 0))
            theaterDoSwap(owner, plan.targetColor, plan.ownerGuid)
        else
            debugLog('[BOT] '..owner..' Theater: explicit pass (no positive public-info swap).')
        end
        G.theaterOwner = nil; G.currentColor = nil
        Wait.time(beginTurnPhase, 0.8)
        return
    end

    -- Human: prompt to pick a target player
    printToAll('🎭  '..owner..' (Theater) is choosing a character exchange...',{0.9,0.7,1.0})
    logTo(owner, '🎭 THEATER: Choose a player to exchange character cards with. You will give one of your characters and receive one of theirs at random.')
    showPlayerPicker('THEATER: Exchange characters with which player?', 'theater_char_target', true)
end

function beginTurnPhase()
    G.phase='TURN'; G.turnStep=0; setPhaseUI('TURN')
    G.turnAdvancePending = false; G.roundEnding = false
    G.turnOrder={}
    G.taxCollectorColor=nil
    -- NOTE: G.taxGold is NOT reset here — gold on the plate carries over between rounds.
    -- Check whether Tax Collector is anywhere in the cast (even if not chosen this round)
    G.taxInCast = false
    if G.gameCast then
        for _, guid in pairs(G.gameCast) do
            if guid == GUID.taxcollector then G.taxInCast = true; break end
        end
    end
    for color,guid in pairs(G.chosenBy) do
        table.insert(G.turnOrder,{color=color,guid=guid,rank=CHAR_RANK[guid] or 99,name=CHAR_NAME[guid] or '?'})
        if guid==GUID.taxcollector then G.taxCollectorColor=color end
    end
    -- 2-player: each player has a second character (stored in chosenBy2)
    for color,guid in pairs(G.chosenBy2 or {}) do
        table.insert(G.turnOrder,{color=color,guid=guid,rank=CHAR_RANK[guid] or 99,name=CHAR_NAME[guid] or '?'})
        if guid==GUID.taxcollector then G.taxCollectorColor=color end
    end
    table.sort(G.turnOrder,function(a,b) return a.rank<b.rank end)
    -- Do NOT reveal turn order — characters are secret until called
    advanceTurn()
end

-- ============================================================
--  advanceTurn — reveal character, set up ability buttons
-- ============================================================
-- ============================================================
--  UNIQUE DISTRICT ABILITY ENGINE
-- ============================================================

-- Check if a player has built a named unique district
function hasUnique(color, name)
    return G.uniqueBuilt and G.uniqueBuilt[color] and G.uniqueBuilt[color][name]
end

-- Count unique districts in a player's city
function countUniques(color)
    local n = 0
    if G.uniqueBuilt and G.uniqueBuilt[color] then
        for _ in pairs(G.uniqueBuilt[color]) do n = n + 1 end
    end
    return n
end

-- Count cards with odd cost in a player's city (Basilica awards +1 per odd-cost district)
function countOddCostDistricts(color)
    local n = 0
    if G.cityCosts and G.cityCosts[color] then
        for _, c in ipairs(G.cityCosts[color]) do if c % 2 == 1 then n = n + 1 end end
    end
    return n
end

-- Count districts of a specific color type in a player's city
function maxSameColorCount(color)
    local best = 0
    if G.buildTypes and G.buildTypes[color] then
        for _, cnt in pairs(G.buildTypes[color]) do if cnt > best then best = cnt end end
    end
    return best
end

-- Called from onDistrictBuilt after a district is successfully placed
function onUniqueDistrictBuilt(color, districtName, cost)
    -- Track this unique in the player's set
    G.uniqueBuilt = G.uniqueBuilt or {}
    G.uniqueBuilt[color] = G.uniqueBuilt[color] or {}
    G.uniqueBuilt[color][districtName] = true

    -- Monument's extra completion value is handled by addCityCompletion().
    if districtName == 'Monument' then
        logTo(color, 'MONUMENT: Counts as 2 districts toward city completion!')
    end

    -- Treasury: gain 1g each time you build another district (tracked in onDistrictBuilt)
    if districtName == 'Treasury' then
        logTo(color, 'TREASURY: You will now gain 1g whenever you build a district!')
    end

    -- Poor House reminder
    if districtName == 'Poor House' then
        logTo(color, 'POOR HOUSE: At end of turn, gain 1g if you have 0 gold.')
    end
end

-- Called from onDistrictBuilt for ALL districts (regular and unique) when a build succeeds
-- to trigger on-build passive effects
function applyOnBuildPassives(color, cost, dtype)
    -- Treasury: gain 1g if already built
    if hasUnique(color, 'Treasury') then
        giveGold(color, 1)
        logTo(color, 'TREASURY: +1g for building a district.')
    end

    -- Poor House triggers at END OF TURN, not immediately after building (see applyEndOfTurnUniques)

end

-- Called from onBtnEnd after all processing, before advancing turn
-- Remove a district from all city-tracking tables (score, size, types, names, cityCosts, beautified).
-- Call this whenever a district is destroyed or removed from any player's city.
-- Find the physical Museum card object in a player's city area
local function findMuseumCard(color)
    local p = PLAYER_POS[color]
    if not p then return nil end
    local best, bestDist = nil, math.huge
    for _, o in ipairs(getAllObjects()) do
        pcall(function()
            if o.getName() == 'Museum' then
                local op = o.getPosition()
                local d  = math.sqrt((op.x-p.x)^2+(op.z-p.z)^2)
                if d < 35 and d < bestDist then best = o; bestDist = d end
            end
        end)
    end
    return best
end

-- Lift the Museum card, stack all tucked cards face-down beneath it, then
-- lower the Museum back on top face-up.
local function stackMuseumCards(color, delay)
    Wait.time(function()
        local museum = findMuseumCard(color)
        if not museum then return end
        local pile = G.museumCards[color] or {}
        if #pile == 0 then return end

        pcall(function()
            local mp  = museum.getPosition()
            local mr  = museum.getRotation()
            local gap = 0.08   -- card thickness in TTS units

            -- Lift Museum card clear of the stack
            museum.setPosition({x=mp.x, y=mp.y+6, z=mp.z})

            -- Place each tucked card face-down at increasing heights
            for i, guid in ipairs(pile) do
                local ci = i
                Wait.time(function()
                    local card = obj(guid)
                    if card then pcall(function()
                        card.setRotation({0, mr.y, 180})
                        card.setPosition({x=mp.x, y=mp.y+(ci-1)*gap, z=mp.z})
                    end) end
                end, (ci-1)*0.12)
            end

            -- Lower Museum back on top face-up
            Wait.time(function()
                pcall(function()
                    museum.setRotation({0, mr.y, 0})
                    museum.setPositionSmooth({x=mp.x, y=mp.y+#pile*gap, z=mp.z}, false, false)
                end)
            end, #pile*0.12 + 0.2)
        end)
    end, delay or 0.5)
end

-- Discard all Museum-assigned cards to the bottom of the district deck
local function discardMuseumCards(color)
    for _, guid in ipairs(G.museumCards[color] or {}) do
        local card = obj(guid)
        if card then discardToBottom(card) end
    end
    G.museumCards[color] = {}
end

-- Transfer Museum-assigned cards to a new owner (Marshal seize / Diplomat swap)
local function transferMuseumCards(fromColor, toColor)
    local pile = G.museumCards[fromColor] or {}
    G.museumCards[fromColor] = {}
    G.museumCards[toColor] = G.museumCards[toColor] or {}
    for _, guid in ipairs(pile) do
        table.insert(G.museumCards[toColor], guid)
    end
    -- Re-stack the cards under the Museum in the new owner's city.
    -- Use a longer delay so the Museum card has time to arrive first.
    if #pile > 0 then
        stackMuseumCards(toColor, 2.5)
    end
end

local function isBuiltDistrictObjectInCity(color, districtObj, distName)
    if not color or not districtObj then return false end
    local objName = nil
    local objPos = nil
    pcall(function() objName = normCardName(districtObj.getName() or '') end)
    if not objName or objName == '' or not DISTRICT_DATA[objName] then return false end
    if distName and objName ~= normCardName(distName) then return false end
    pcall(function() objPos = districtObj.getPosition() end)
    if not objPos then return false end
    return citySlotIndexFromPosition(color, objPos) ~= nil
end

-- Find the named district card that is actually sitting in one of the player's city slots.
local function findDistrictCardInCity(color, distName)
    local best, bestSlot = nil, math.huge
    for _, o in ipairs(getAllObjects()) do
        pcall(function()
            if isBuiltDistrictObjectInCity(color, o, distName) then
                local slot = citySlotIndexFromPosition(color, o.getPosition())
                if slot ~= nil and slot < bestSlot then
                    best = o
                    bestSlot = slot
                end
            end
        end)
    end
    if best then return best end

    -- If a built district somehow got stacked into a deck while still in a city slot,
    -- pull only that exact district back out.
    for _, o in ipairs(getAllObjects()) do
        local extracted = nil
        pcall(function()
            if o.type == 'Deck' or o.type == 'DeckCustom' then
                local op = o.getPosition()
                if citySlotIndexFromPosition(color, op) ~= nil then
                    local ok, contents = pcall(function() return o.getObjects() end)
                    if ok and contents then
                        for _, entry in ipairs(contents) do
                            if normCardName(entry.name or '') == normCardName(distName) then
                                extracted = o.takeObject({
                                    guid     = entry.guid,
                                    position = {x=op.x, y=op.y+2, z=op.z},
                                    smooth   = false,
                                })
                                break
                            end
                        end
                    end
                end
            end
        end)
        if extracted then return extracted end
    end
    return nil
end

-- Mark a coin as a beautify token attached to a specific district.
local function registerBeautifyCoin(color, distName, coinObj)
    if not coinObj then return nil end
    local guid = coinObj.getGUID()
    G.lockedCoins = G.lockedCoins or {}
    G.lockedCoins[guid] = true
    G.beautifyCoins = G.beautifyCoins or {}
    G.beautifyCoins[color] = G.beautifyCoins[color] or {}
    G.beautifyCoins[color][distName] = guid
    G.beautifyCoinMeta = G.beautifyCoinMeta or {}
    G.beautifyCoinMeta[guid] = {color=color, districtName=distName}
    pcall(function()
        coinObj.setName('Beautify Gold')
        coinObj.setDescription('Attached to '..distName..' in '..color.."'s city.")
    end)
    return guid
end

-- Snap a beautify coin back onto its district card after either one moves.
local function syncBeautifyCoin(color, distName, delay)
    local coinGuid = G.beautifyCoins and G.beautifyCoins[color] and G.beautifyCoins[color][distName]
    if not coinGuid then return end
    local coin = obj(coinGuid)
    local card = findDistrictCardInCity(color, distName)
    if not coin or not card then return end
    Wait.time(function()
        local liveCoin = obj(coinGuid)
        local liveCard = findDistrictCardInCity(color, distName)
        if not liveCoin or not liveCard then return end
        local cp = liveCard.getPosition()
        pcall(function()
            liveCoin.setName('Beautify Gold')
            liveCoin.setDescription('Attached to '..distName..' in '..color.."'s city.")
            liveCoin.setRotation({0, 0, 0})
            liveCoin.setPositionSmooth({
                x = cp.x + (math.random()-0.5)*0.25,
                y = cp.y + 0.45,
                z = cp.z + (math.random()-0.5)*0.25,
            }, false, false)
        end)
    end, delay or 0.05)
end

-- Return a beautify coin to circulation by renaming and moving it back to the bowl.
local function releaseBeautifyCoin(coinGuid)
    if not coinGuid then return end
    local coin = obj(coinGuid)
    if G.lockedCoins then G.lockedCoins[coinGuid] = nil end
    if G.beautifyCoinMeta then G.beautifyCoinMeta[coinGuid] = nil end
    if coin then
        pcall(function()
            coin.setName('Gold')
            coin.setDescription('')
            liftThenPlace(coin, bowlPos())
        end)
    end
end

-- Transfer an existing beautify marker to a new owner without putting it back in circulation.
local function transferBeautifyCoin(coinGuid, toColor, distName)
    if not coinGuid then return end
    G.beautified = G.beautified or {}
    G.beautified[toColor] = G.beautified[toColor] or {}
    G.beautified[toColor][distName] = true
    G.beautifyCoins = G.beautifyCoins or {}
    G.beautifyCoins[toColor] = G.beautifyCoins[toColor] or {}
    G.beautifyCoins[toColor][distName] = coinGuid
    G.beautifyCoinMeta = G.beautifyCoinMeta or {}
    G.beautifyCoinMeta[coinGuid] = {color=toColor, districtName=distName}
    syncBeautifyCoin(toColor, distName, 0.8)
end

local function removeDistrictFromCity(color, distName, dCost, dType, preserveBeautify)
    G.cityNames[color] = G.cityNames[color] or {}
    if not G.cityNames[color][distName] then
        debugLog('removeDistrictFromCity skipped for '..tostring(color)..' / '..tostring(distName)..' because it is not recorded in that city.')
        return nil
    end
    G.cityNames[color][distName] = nil
    removeCityCompletion(color, distName)
    -- Remove base cost from score
    G.cityScore[color] = math.max(0, (G.cityScore[color] or 0) - dCost)
    -- Remove beauty bonus if this district was beautified
    local beautifyCoinGuid = nil
    if G.beautified and G.beautified[color] and G.beautified[color][distName] then
        G.beautified[color][distName] = nil
        G.cityScore[color] = math.max(0, (G.cityScore[color] or 0) - 1)
        if G.beautifyCoins and G.beautifyCoins[color] then
            beautifyCoinGuid = G.beautifyCoins[color][distName]
            G.beautifyCoins[color][distName] = nil
        end
        if preserveBeautify then
            if G.beautifyCoinMeta then G.beautifyCoinMeta[beautifyCoinGuid] = nil end
        else
            releaseBeautifyCoin(beautifyCoinGuid)
        end
    end
    -- Remove from cityCosts list (used by Basilica odd-cost scoring)
    if G.cityCosts and G.cityCosts[color] then
        for i, c in ipairs(G.cityCosts[color]) do
            if c == dCost then table.remove(G.cityCosts[color], i); break end
        end
    end
    -- Update district-type tracking
    G.buildTypes[color] = G.buildTypes[color] or {}
    G.buildTypes[color][dType] = math.max(0, (G.buildTypes[color][dType] or 1) - 1)
    if (G.buildTypes[color][dType] or 0) == 0 then
        G.cityTypes[color] = G.cityTypes[color] or {}
        G.cityTypes[color][dType] = nil
    end
    -- Remove unique tracking
    if dType == 'unique' and G.uniqueBuilt and G.uniqueBuilt[color] then
        G.uniqueBuilt[color][distName] = nil
    end
    -- Museum: if the Museum itself is destroyed, discard all its assigned cards
    if distName == 'Museum' then
        discardMuseumCards(color)
    end
    return beautifyCoinGuid
end

function applyEndOfTurnUniques(color)
    -- Park: if hand has no district cards (character cards don't count), draw 2
    if hasUnique(color, 'Park') then
        local hand = {}
        pcall(function()
            local p = Player[color]
            if p then hand = p.getHandObjects() or {} end
        end)
        local districtCount = 0
        local handNames = {}
        for _, c in ipairs(hand) do
            pcall(function()
                local n = (c.getName() or ''):match('^%s*(.-)%s*$')
                table.insert(handNames, n)
                if DISTRICT_DATA[n] then districtCount = districtCount + 1 end
            end)
        end
        debugLog('PARK check for '..color..': hand=['..table.concat(handNames,', ')..'] districtCount='..districtCount)
        if districtCount == 0 then
            local deck = findDistrictDeck()
            if deck then
                deck.deal(2, color)
                logTo(color, 'PARK: No district cards in hand — drew 2 cards!')
            else
                logTo(color, 'PARK: No district cards in hand but district deck not found!')
            end
        else
            logTo(color, 'PARK: '..districtCount..' district card(s) still in hand — no draw.')
        end
    end
    -- Poor House: if stash is empty at end of turn, gain 1 gold
    if hasUnique(color, 'Poor House') then
        if (G.gold[color] or 0) == 0 then
            giveGold(color, 1)
            logTo(color, 'POOR HOUSE: Stash empty at end of turn — gained 1g!')
        end
    end
end

-- Called from onBtnGold (and onBtnDraw) after gathering to apply draw passives
function applyGatherPassives(color, gatherMode)
    -- Gold Mine: gain 1 extra gold when choosing to gather gold
    if gatherMode == 'gold' and hasUnique(color, 'Gold Mine') then
        giveGold(color, 1)
        logTo(color, 'GOLD MINE: +1 bonus gold for gathering gold.')
        updateGoldUI()
    end
end

local function formatDistrictChoiceLabel(name, detail)
    if not detail or detail == '' then return name end
    return name..'\n'..detail
end

local function setTargetPlayerPanelLayout(mode, optionCount)
    local tall = (mode == 'district')
    local promptHeight = tall and 50 or 40
    local buttonHeight = tall and 36 or 28
    local spacing = 3
    local visibleOptions = math.max(0, math.min(8, tonumber(optionCount) or (tall and 8 or 4)))
    local totalRows = visibleOptions + 1  -- include the Cancel row
    local panelHeight = promptHeight + (totalRows * buttonHeight) + (totalRows * spacing) + 14

    UI.setAttribute('pnlTargetPlayer', 'preferredHeight', tostring(panelHeight))
    UI.setAttribute('txtTargetPrompt', 'preferredHeight', tostring(promptHeight))
    UI.setAttribute('txtTargetPrompt', 'fontSize', tall and '10' or '11')
    for i = 1, 8 do
        local bid = 'btnPick'..i
        UI.setAttribute(bid, 'fontSize', tall and '10' or '11')
        UI.setAttribute(bid, 'preferredHeight', tostring(buttonHeight))
    end
end

-- Adjusted cost for building a district.
-- Only Factory reduces the gold paid for unique districts, and it never drops below 1.
function adjustedBuildCost(color, dtype, baseCost)
    local cost = baseCost
    if dtype == 'unique' then
        -- Factory reduces the gold paid, but does not change the district's score value.
        if hasUnique(color, 'Factory') then cost = cost - 1 end
        -- Deluxe rules keep the minimum payment for Factory at 1 gold.
        cost = math.max(1, cost)
    end
    return math.max(0, cost)
end

-- ============================================================
--  UNIQUE DISTRICT ABILITY BUTTONS (turn-based)
--  These are shown via a dedicated UI button when the player
--  has one of the interactive unique districts in their city.
-- ============================================================

function onBtnUniqueAbility(player)
    if G.phase ~= 'TURN' then return end
    if player.color ~= G.currentColor then logTo(player.color,'Not your turn!'); return end
    local color = player.color
    if requireBlackmailResolved(color, 'using Smithy') then return end
    -- Smithy dedicated button
    if hasUnique(color, 'Smithy') then
        if G.smithyUsed then logTo(color,'Smithy already used this turn!'); return end
        if (G.gold[color] or 0) < 2 then logTo(color,'Smithy: need 2g!'); return end
        G.smithyUsed = true
        takeGold(color, 2)
        local deck = findDistrictDeck()
        if deck then deck.deal(3, color) end
        logTo(color,'SMITHY: Paid 2g, drew 3 district cards!')
        updateGoldUI()
        refreshUniqueAbilityButton(color)
        return
    end
    logTo(color,'No Smithy in your city.')
end

-- Laboratory dedicated button (legacy handler kept as reference)
function onBtnDistrictLab_legacy(player)
    if G.phase ~= 'TURN' then return end
    if player.color ~= G.currentColor then logTo(player.color,'Not your turn!'); return end
    local color = player.color
    if requireBlackmailResolved(color, 'using Laboratory') then return end
    if not hasUnique(color,'Laboratory') then return end
    if G.labPending and not G.labPendingDiscarded then
        logTo(color,'LABORATORY: No card has been discarded yet. Drag a district card from your hand onto the district deck first.')
        return
    end
    if G.labPending and G.labPendingDiscarded then
        G.labPending = false
        G.labUsed    = true
        giveGold(color, 2)
        logTo(color,'LABORATORY: Discarded '..(G.labPendingCardName or '1 card')..' -> gained 2g!')
        G.labPendingDiscarded = false
        G.labPendingCardName  = nil
        updateGoldUI()
        refreshUniqueAbilityButton(color)
        return
    end
    if false and G.labPending then -- legacy Lab confirm path kept only as reference
        -- Second click: confirm the discard
        G.labPending = false
        G.labUsed    = true
        giveGold(color, 2)
        logTo(color,'LABORATORY: Discarded 1 card → gained 2g!')
        updateGoldUI()
        refreshUniqueAbilityButton(color)
        return
    end
    if G.labUsed then logTo(color,'Laboratory already used this turn!'); return end
    G.labPendingDiscarded = false
    G.labPendingCardName  = nil
    logTo(color,'LABORATORY: Drag a district card face-down from your hand onto the district deck, then click this button again to confirm and receive 2 gold.')
    G.labPending = true
    refreshUniqueAbilityButton(color)
end

-- Museum dedicated button — show a card picker so the player selects which card to tuck
-- Override the earlier Laboratory handler so the payout only happens after a
-- real hand-to-deck discard has been registered during this turn.
-- Laboratory dedicated button override
function onBtnDistrictLab(player)
    if G.phase ~= 'TURN' then return end
    if player.color ~= G.currentColor then logTo(player.color,'Not your turn!'); return end
    local color = player.color
    if requireBlackmailResolved(color, 'using Laboratory') then return end
    if not hasUnique(color,'Laboratory') then return end

    if G.labPending and not G.labPendingDiscarded then
        logTo(color,'LABORATORY: No card has been discarded yet. Drag a district card from your hand onto the district deck first.')
        return
    end

    if G.labPending and G.labPendingDiscarded then
        G.labPending = false
        G.labUsed = true
        giveGold(color, 2)
        logTo(color,'LABORATORY: Discarded '..(G.labPendingCardName or '1 card')..' and gained 2g!')
        G.labPendingDiscarded = false
        G.labPendingCardName = nil
        updateGoldUI()
        refreshUniqueAbilityButton(color)
        scheduleAutoEndTurnCheck(color, 0.1)
        return
    end

    if G.labUsed then
        logTo(color,'Laboratory already used this turn!')
        return
    end

    G.labPendingDiscarded = false
    G.labPendingCardName = nil
    G.labPending = true
    logTo(color,'LABORATORY: Drag a district card face-down from your hand onto the district deck, then click this button again to confirm and receive 2 gold.')
    refreshUniqueAbilityButton(color)
end

-- Museum dedicated button: show a card picker so the player selects which card to tuck
function onBtnDistrictMuseum(player)
    if G.phase ~= 'TURN' then return end
    if player.color ~= G.currentColor then logTo(player.color,'Not your turn!'); return end
    local color = player.color
    if requireBlackmailResolved(color, 'using Museum') then return end
    if not hasUnique(color,'Museum') then return end
    if G.museumUsed then logTo(color,'Museum already used this turn!'); return end

    -- Build list of district cards currently in hand
    local handCards = {}
    pcall(function()
        local p = Player[color]
        if not p then return end
        for _, c in ipairs(p.getHandObjects()) do
            pcall(function()
                local n = (c.getName() or ''):match('^%s*(.-)%s*$')
                if DISTRICT_DATA[n] then
                    table.insert(handCards, {guid=c.getGUID(), name=n})
                end
            end)
        end
    end)

    if #handCards == 0 then
        logTo(color, 'MUSEUM: No district cards in hand to tuck.')
        return
    end

    G.museumHandList = handCards
    G.targeting = 'museum_pick'
    UI.setValue('txtTargetPrompt', 'MUSEUM: Which card to tuck? (+1pt at game end)')
    for i = 1, 8 do
        local bid = 'btnPick'..i
        if i <= #handCards then
            UI.setAttribute(bid,'active','true')
            UI.setAttribute(bid,'text', handCards[i].name)
            UI.setAttribute(bid,'color','white')
            UI.setAttribute(bid,'colors','#004466|#0077AA|#003355|#004466')
        else
            UI.setAttribute(bid,'active','false')
        end
    end
    UI.setAttribute('pnlTarget','active','false')
    UI.setAttribute('pnlTargetPlayer','active','true')
    btn('btnAbility',false); btn('btnAbility2',false)
end

-- Armory dedicated button
function onBtnDistrictArmory(player)
    if G.phase ~= 'TURN' then return end
    if player.color ~= G.currentColor then logTo(player.color,'Not your turn!'); return end
    local color = player.color
    if requireBlackmailResolved(color, 'using Armory') then return end
    if not hasUnique(color,'Armory') then return end
    if G.armoryUsed then logTo(color,'Armory already used this turn!'); return end
    G.armoryUsed = true
    G.cityNames[color] = G.cityNames[color] or {}
    G.cityNames[color]['Armory'] = nil
    removeCityCompletion(color, 'Armory')
    G.cityScore[color] = math.max(0,(G.cityScore[color] or 0)-3)
    G.buildTypes[color] = G.buildTypes[color] or {}
    G.buildTypes[color]['unique'] = math.max(0,(G.buildTypes[color]['unique'] or 1)-1)
    if G.uniqueBuilt and G.uniqueBuilt[color] then G.uniqueBuilt[color]['Armory'] = nil end
    local ap = PLAYER_POS[color]
    if ap then
        for _, o in ipairs(getAllObjects()) do
            pcall(function()
                if o.getName() == 'Armory' then
                    local op = o.getPosition()
                    if math.sqrt((op.x-ap.x)^2+(op.z-ap.z)^2) < 20 then
                        discardToBottom(o)
                    end
                end
            end)
        end
    end
    logTo(color,'ARMORY: Sacrificed! Now choose which player to destroy a district from.')
    G.armoryUser = color
    showPlayerPicker('ARMORY: Destroy a district from which player?','armory_target', false)
    refreshUniqueAbilityButton(color)
end

local function countHandDistrictCards(color)
    local count = 0
    local ok, hand = pcall(function()
        local p = Player[color]
        return p and p.getHandObjects() or {}
    end)
    if not ok or not hand then return 0 end
    for _, card in ipairs(hand) do
        pcall(function()
            local name = (card.getName() or ''):match('^%s*(.-)%s*$')
            if DISTRICT_DATA[name] then count = count + 1 end
        end)
    end
    return count
end

local function getHandDistrictEntries(color)
    local entries = {}
    local ok, hand = pcall(function()
        local p = Player[color]
        return p and p.getHandObjects() or {}
    end)
    if not ok or not hand then return entries end
    for _, card in ipairs(hand) do
        pcall(function()
            local name = (card.getName() or ''):match('^%s*(.-)%s*$')
            local data = DISTRICT_DATA[name]
            if data then
                table.insert(entries, {
                    name = name,
                    cost = data[1],
                    dtype = data[2],
                    guid = card.getGUID(),
                    obj = card,
                })
            end
        end)
    end
    return entries
end

local function isDistrictBuildLegal(color, name, dtype)
    if not name or name == '' or name == 'Secret Vault' then return false end
    local cityNames = G.cityNames or {}
    local alreadyBuilt = cityNames[color] and cityNames[color][name]
    local hasQuarry = hasUnique(color, 'Quarry')
    local isWizardTurn = (G.currentChar == GUID.wizard and color == G.currentColor)
    local duplicateAllowed = hasQuarry or isWizardTurn
    local traderLockedToTrade = (G.currentChar == GUID.trader and (G.buildCount or 0) >= 1)
    local traderBuildAllowed = (not traderLockedToTrade) or dtype == 'trade'
    return (not alreadyBuilt or duplicateAllowed) and traderBuildAllowed
end

local function effectiveHandBuildCost(color, entry)
    local cost = entry.cost or 0
    if entry.dtype == 'unique' then
        cost = adjustedBuildCost(color, entry.dtype, cost)
    end
    return cost
end

local function playerHasUsableFrameworkBuild(color, handEntries)
    if not hasUnique(color, 'Framework') then return false end
    if G.frameworkMode or G.frameworkResume or G.frameworkPendingBuild then return false end
    for _, entry in ipairs(handEntries) do
        if entry.name ~= 'Necropolis'
           and isDistrictBuildLegal(color, entry.name, entry.dtype) then
            return true
        end
    end
    return false
end

local function playerHasUsableThievesDenBuild(color, handEntries)
    local gold = G.gold[color] or 0
    local districtCount = #handEntries
    for _, entry in ipairs(handEntries) do
        if entry.name == "Thieves' Den"
           and isDistrictBuildLegal(color, entry.name, entry.dtype) then
            local cost = effectiveHandBuildCost(color, entry)
            if gold < cost then
                local goldGap = cost - gold
                local remainingDistrictCards = districtCount - 1
                if remainingDistrictCards >= goldGap then
                    return true
                end
            end
        end
    end
    return false
end

local function playerHasUsableCardinalBuild(color, handEntries)
    if G.currentChar ~= GUID.cardinal then return false end
    local gold = G.gold[color] or 0
    local districtCount = #handEntries
    for _, entry in ipairs(handEntries) do
        if entry.name ~= 'Necropolis'
           and isDistrictBuildLegal(color, entry.name, entry.dtype) then
            local cost = effectiveHandBuildCost(color, entry)
            if gold < cost then
                local shortfall = cost - gold
                local remainingDistrictCards = districtCount - 1
                if shortfall > 0 and remainingDistrictCards >= shortfall then
                    for _, otherColor in ipairs(G.players or {}) do
                        if otherColor ~= color and (G.gold[otherColor] or 0) >= shortfall then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

local function playerHasUsableNecropolisBuild(color, handEntries)
    if G.necropolisUsed then return false end
    local cityNames = G.cityNames or {}
    if next(cityNames[color] or {}) == nil then return false end
    for _, entry in ipairs(handEntries) do
        if entry.name == 'Necropolis' then
            return true
        end
    end
    return false
end

local function playerHasUsableArmoryTarget(color)
    if not hasUnique(color, 'Armory') or G.armoryUsed then return false end
    local cityNames = G.cityNames or {}
    for _, otherColor in ipairs(G.players or {}) do
        if otherColor ~= color
           and next(cityNames[otherColor] or {}) ~= nil
           and (G.citySize[otherColor] or 0) < cityThreshold() then
            return true
        end
    end
    return false
end

local function playerHasBuildOption(color)
    if G.phase ~= 'TURN' or color ~= G.currentColor then return false end
    if not G.hasGathered or G.witchOnHold then return false end
    if (G.mustDiscard or 0) > 0 or (G.seerMustReturn or 0) > 0 then return false end
    if G.wizardPeeking or G.cardinalPendingBuild or G.cardinalCardTarget or G.cardinalBuildResuming then return false end
    if G.labPending or G.frameworkPendingBuild or G.necropolisMode or G.thievesDenPending or G.thievesDenPendingBuild then return false end
    if G.currentChar == GUID.witch and not G.witchResuming then return false end
    if G.currentChar == GUID.navigator then return false end

    local buildCount = G.buildCount or 0
    local buildLimit = G.buildLimit or 0
    local gold = G.gold[color] or 0
    local handEntries = getHandDistrictEntries(color)

    if buildCount < buildLimit then
        for _, entry in ipairs(handEntries) do
            if isDistrictBuildLegal(color, entry.name, entry.dtype) then
                local cost = effectiveHandBuildCost(color, entry)
                if cost <= gold then
                    return true
                end
            end
        end

        if playerHasUsableThievesDenBuild(color, handEntries) then return true end
        if playerHasUsableCardinalBuild(color, handEntries) then return true end
        if playerHasUsableNecropolisBuild(color, handEntries) then return true end
    end

    if playerHasUsableFrameworkBuild(color, handEntries) then return true end
    return false
end

function blackmailResolutionPendingForColor(color)
    return G.phase == 'TURN'
       and color
       and color == G.currentColor
       and G.blackmailPending
       and G.blackmailPending == G.currentChar
       and not G.blackmailResolved
end

function requireBlackmailResolved(color, actionLabel)
    if not blackmailResolutionPendingForColor(color) then return false end
    if G.blackmailNeedsGather then
        logTo(color, 'You must gather resources first, then resolve the blackmail threat before '..actionLabel..'!')
    else
        logTo(color, 'You must pay or refuse the blackmail before '..actionLabel..'!')
    end
    return true
end

local function playerHasInteractiveDistrictAbility(color)
    local handDistricts = countHandDistrictCards(color)
    if hasUnique(color, 'Smithy') and not G.smithyUsed and (G.gold[color] or 0) >= 2 then return true end
    if hasUnique(color, 'Laboratory') and (G.labPending or (not G.labUsed and handDistricts > 0)) then return true end
    if hasUnique(color, 'Museum') and not G.museumUsed and handDistricts > 0 then return true end
    if playerHasUsableArmoryTarget(color) then return true end
    return false
end

local function uiButtonIsActive(id)
    local ok, value = pcall(function() return UI.getAttribute(id, 'active') end)
    if not ok then return false end
    value = tostring(value or ''):lower()
    return value == 'true'
end

local function abbotCanCollectFromRichest(color)
    local richest, richestGold = richestPlayer(color)
    local myGold = G.gold[color] or 0
    return richest and richestGold > myGold
end

local function refreshCharacterAbilityButtons(color)
    if G.phase ~= 'TURN' or color ~= G.currentColor then return end
    local guid = G.currentChar
    if guid == GUID.abbot then
        local labels = ABILITY_LABEL[guid] or {}
        local tooltips = ABILITY_TOOLTIP[guid] or {}
        local canIncome = (not G.abilityUsed) and countDistrictType(color, 'religious') > 0
        local canRichest = (not G.abbotRichUsed) and abbotCanCollectFromRichest(color)
        if labels[1] and labels[1] ~= '' then
            UI.setAttribute('btnAbility', 'text', '✨  '..labels[1])
            if tooltips[1] and tooltips[1] ~= '' then
                UI.setAttribute('btnAbility', 'tooltip', tooltips[1])
            end
        end
        if labels[2] and labels[2] ~= '' then
            UI.setAttribute('btnAbility2', 'text', '✨  '..labels[2])
            if tooltips[2] and tooltips[2] ~= '' then
                UI.setAttribute('btnAbility2', 'tooltip', tooltips[2])
            end
        end
        btn('btnAbility', canIncome)
        btn('btnAbility2', canRichest)
    end
end

local function tryAutoEndTurn(color)
    if not G.autoEndTurn or G.phase ~= 'TURN' then return false end
    if not color or color ~= G.currentColor or isBot(color) then return false end
    if G.turnAdvancePending or G.roundEnding then return false end
    if not G.hasGathered then return false end
    if G.magicianSwapPending then return false end
    if blackmailResolutionPendingForColor(color) then return false end
    if G.targeting or G.blackmailNeedsGather or G.blackmailRefusalPending then return false end
    if (G.mustDiscard or 0) > 0 or (G.seerMustReturn or 0) > 0 then return false end
    if G.wizardPeeking or G.cardinalPendingBuild or G.cardinalCardTarget or G.cardinalBuildResuming then return false end
    if G.labPending or G.frameworkPendingBuild or G.necropolisMode or G.thievesDenPending or G.thievesDenPendingBuild then return false end
    if uiButtonIsActive('btnAbility') or uiButtonIsActive('btnAbility2') then return false end
    if playerHasInteractiveDistrictAbility(color) then return false end
    if playerHasBuildOption(color) then return false end
    local seat = Player[color]
    if not seat then return false end
    logTo(color, 'AUTO-END: No legal actions remain. Ending your turn.')
    onBtnEnd(seat)
    return true
end

function scheduleAutoEndTurnCheck(color, delay)
    if not color then return end
    Wait.time(function()
        if color == G.currentColor then
            pcall(function() tryAutoEndTurn(color) end)
        end
    end, delay or 0.15)
end

local function scheduleAdvanceTurn(delay)
    if G.turnAdvancePending or G.roundEnding then return false end
    G.turnAdvancePending = true
    Wait.time(function()
        G.turnAdvancePending = false
        pcall(advanceTurn)
    end, delay or 0.4)
    return true
end

-- Refreshes all per-district ability buttons independently.
-- Each interactive district now has its own dedicated button.
function refreshUniqueAbilityButton(color)
    if G.phase ~= 'TURN' then
        btn('btnUniqueAbility', false)
        btn('btnDistrictLab',   false)
        btn('btnDistrictMuseum',false)
        btn('btnDistrictArmory',false)
        return
    end

    -- Smithy button
    local smithyAvail = hasUnique(color,'Smithy') and not G.smithyUsed
    if smithyAvail then
        UI.setAttribute('btnUniqueAbility','text','🔨  Smithy: Pay 2g → Draw 3')
        UI.setAttribute('btnUniqueAbility','colors','#004466|#0077AA|#003355|#004466')
    else
        UI.setAttribute('btnUniqueAbility','text','🔨  Smithy (used)')
        UI.setAttribute('btnUniqueAbility','colors','#333333|#333333|#333333|#333333')
    end
    btn('btnUniqueAbility', hasUnique(color,'Smithy'))

    -- Laboratory button
    if hasUnique(color,'Laboratory') then
        if G.labUsed then
            UI.setAttribute('btnDistrictLab','text','🧪  Lab: used this turn')
            UI.setAttribute('btnDistrictLab','colors','#333333|#333333|#333333|#333333')
        elseif G.labPending and not G.labPendingDiscarded then
            UI.setAttribute('btnDistrictLab','text','🧪  Lab: Await deck discard')
            UI.setAttribute('btnDistrictLab','colors','#7A5C00|#C49A00|#5C4500|#7A5C00')
        elseif G.labPending and G.labPendingDiscarded then
            UI.setAttribute('btnDistrictLab','text','✅  Confirm Lab discard (+2g)')
            UI.setAttribute('btnDistrictLab','colors','#1B6B3A|#27AE60|#145A32|#1B6B3A')
        elseif G.labPending then
            UI.setAttribute('btnDistrictLab','text','✅  Confirm Lab discard (+2g)')
            UI.setAttribute('btnDistrictLab','colors','#1B6B3A|#27AE60|#145A32|#1B6B3A')
        else
            UI.setAttribute('btnDistrictLab','text','🧪  Lab: Discard card → +2g')
            UI.setAttribute('btnDistrictLab','colors','#004466|#0077AA|#003355|#004466')
        end
        btn('btnDistrictLab', true)
    else
        btn('btnDistrictLab', false)
    end

    -- Museum button
    if hasUnique(color,'Museum') then
        if G.museumUsed then
            UI.setAttribute('btnDistrictMuseum','text','🏛  Museum: used this turn')
            UI.setAttribute('btnDistrictMuseum','colors','#333333|#333333|#333333|#333333')
        else
            UI.setAttribute('btnDistrictMuseum','text','🏛  Museum: Tuck card (+1pt)')
            UI.setAttribute('btnDistrictMuseum','colors','#004466|#0077AA|#003355|#004466')
        end
        btn('btnDistrictMuseum', true)
    else
        btn('btnDistrictMuseum', false)
    end

    -- Armory button
    if hasUnique(color,'Armory') then
        if G.armoryUsed then
            UI.setAttribute('btnDistrictArmory','text','💥  Armory: used this turn')
            UI.setAttribute('btnDistrictArmory','colors','#333333|#333333|#333333|#333333')
        else
            UI.setAttribute('btnDistrictArmory','text','💥  Armory: Sacrifice → Destroy')
            UI.setAttribute('btnDistrictArmory','colors','#004466|#0077AA|#003355|#004466')
        end
        btn('btnDistrictArmory', true)
    else
        btn('btnDistrictArmory', false)
    end

    refreshCharacterAbilityButtons(color)
    if color == G.currentColor then scheduleAutoEndTurnCheck(color, 0.05) end
end

-- Ping the table at the player's seat and glow their character token.
-- Called at the start of every turn so players know whose turn it is.
local function notifyTurnStart(playerColor, charGuid)
    local pos = PLAYER_POS[playerColor]
    -- pingTable only works for human (non-bot) seats.
    -- Calling it on a bot seat throws a C# null reference in TTS.
    if pos and not (G.bots and G.bots[playerColor]) then
        pcall(function()
            local p = Player[playerColor]
            if p then p.pingTable(pos) end
        end)
    end
    -- Glow the character token in the player's color for 3 seconds (works for bots too)
    local tokenGuid = charGuid and CHAR_TOKEN[charGuid]
    if tokenGuid then
        local token = obj(tokenGuid)
        if token then
            local rgb = COLOR_RGB[playerColor] or {1,1,1}
            pcall(function() token.highlightOn(rgb, 3) end)
        end
    end
end

function advanceTurn()
    if G.resetting then return end
    if G.phase ~= 'TURN' or G.roundEnding then return end
    G.turnAdvancePending = false

    -- Always clear any leftover targeting state from the previous turn.
    -- Async bot picks (e.g. Blackmailer 0.4s fake-pick delay) can leave G.targeting
    -- set and pnlTarget visible when the next player's turn begins.
    G.targeting = nil
    UI.setAttribute('pnlTarget',       'active', 'false')
    UI.setAttribute('pnlTargetPlayer', 'active', 'false')

    G.turnStep = G.turnStep + 1

    -- Skip killed character
    while G.turnStep <= #G.turnOrder do
        local e = G.turnOrder[G.turnStep]
        if e.guid == G.killedChar then
            printToAll('💀  Rank '..e.rank..' — '..e.name..' was killed. Turn skipped.',{0.8,0.3,0.3})
            G.turnStep = G.turnStep + 1
        else
            break
        end
    end

    if G.turnStep > #G.turnOrder then endRound(); return end

    local e = G.turnOrder[G.turnStep]
    G.currentColor   = e.color
    G.currentChar    = e.guid
    G.hasGathered    = false
    G.abilityUsed    = false
    G.buildCount     = 0
    G.alchemistGold  = 0
    G.wizardPeeking       = false
    G.wizardFreeBuilds    = 0
    G.wizardBorrowedFrom  = nil
    G.wizardBorrowedGuids = nil
    G.labUsed = false; G.labPending = false; G.labPendingDiscarded = false; G.labPendingCardName = nil
    G.frameworkPendingBuild = nil; G.frameworkMode = false; G.frameworkResume = false
    -- Reset Laboratory button colour so the grey-out from a previous turn doesn't persist
    UI.setAttribute('btnUniqueAbility','colors','#004466|#0077AA|#003355|#004466')
    G.smithyUsed = false; G.necropolisMode = false; G.necropolisUsed = false
    G.museumUsed = false; G.abbotRichUsed = false
    G.armoryUsed = false; G.armoryUser = nil
    G.mustDiscard    = 0   -- cards player must return to deck before ending turn
    G.mustDiscardShuffle = false
    G.seerMustReturn = 0   -- cards Seer must give back to other players
    G.seerReturnTargets = {}
    G.thievesDenDiscount = 0
    G.thievesDenPending  = nil
    G.thievesDenPendingBuild = nil
    G.theaterUsed = G.theaterUsed or {}; G.theaterUsed[G.currentColor] = false
    G.witchOnHold = false        -- cleared each turn; set true after witch picks bewitch target
    G.witchPendingResume = false -- cleared each turn; set true when bewitched player must discard before Witch resumes
    G.witchResuming = false -- set true only during resumeWitchTurn so Witch can build then
    G.seizeUsed = false          -- Marshal seize used this turn
    G.warlordIncomeUsed = false  -- Warlord military income used this turn
    G.diplomatIncomeUsed = false -- Diplomat military income used this turn
    G.cardinalIncomeUsed = false
    G.blackmailNeedsGather = false
    G.cardinalPendingBuild = nil
    G.cardinalBorrowUsed = false
    G.cardinalBuildResuming = false
    G.cardinalBuiltGuids = {}
    G.artistUsedCoins = {}
    G.spyRevealedCards = nil
    G.spyRevealTarget  = nil
    G.magicianSwapPending = false

    -- Set build limit per character
    if e.guid == GUID.architect   then G.buildLimit = 3
    elseif e.guid == GUID.seer    then G.buildLimit = 2
    elseif e.guid == GUID.scholar then G.buildLimit = 2
    elseif e.guid == GUID.navigator then G.buildLimit = 0
    elseif e.guid == GUID.witch   then G.buildLimit = 0  -- Witch cannot build during initial turn; only during resume
    else G.buildLimit = 1
    end

    -- If bewitched: the actual turn-taker's gather+turn-end happens, then witch resumes
    local isBewitched = (e.guid == G.bewitchedChar)

    -- Flip character card face-up to reveal
    local card = obj(e.guid)
    if card then pcall(function() card.setRotation({0,0,0}) end) end

    -- Bob the token
    local tokenGuid = CHAR_TOKEN[e.guid]
    if tokenGuid then
        local token = obj(tokenGuid)
        if token then
            pcall(function()
                local tp = token.getPosition()
                token.setPositionSmooth({x=tp.x,y=tp.y+0.8,z=tp.z})
                Wait.time(function() pcall(function() if token then token.setPositionSmooth(tp) end end) end, 1.0)
            end)
        end
    end

    -- Announce (this is the moment the character is revealed to all)
    printToAll('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',{0.4,0.4,0.4})
    printToAll('  ⚜  Rank '..e.rank..' — '..e.name,{1,0.9,0.4})
    if isBewitched then
        printToAll('  🧙  BEWITCHED — gather only, then Witch takes over',{0.8,0.5,1.0})
    else
        printToAll('  ►  '..e.color.."'s turn!",{1,1,0.4})
    end
    printToAll('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',{0.4,0.4,0.4})

    -- Ping + glow at the active player's seat
    notifyTurnStart(e.color, e.guid)

    -- Thief steal: happens when character is revealed
    if G.robbedChar == e.guid and G.thiefColor then
        local stolen = G.gold[e.color] or 0
        if stolen > 0 then
            G.gold[e.color] = 0
            G.gold[G.thiefColor] = (G.gold[G.thiefColor] or 0) + stolen
            -- Move coins physically
            local tp = PLAYER_POS[e.color]
            local pp = PLAYER_POS[G.thiefColor]
            if tp and pp then
                local radius = 10
                local moved = 0
                for _,o in ipairs(getAllObjects()) do
                    if moved >= stolen then break end
                    pcall(function()
                        if o.getName() == 'Gold' then
                            local p = o.getPosition()
                            if math.sqrt((p.x-tp.x)^2+(p.z-tp.z)^2) <= radius then
                                liftThenPlace(o, {x=pp.x+(math.random()-0.5)*1.5,y=pp.y,z=pp.z-4+(math.random()-0.5)*1.5}, moved*0.08)
                                moved = moved + 1
                            end
                        end
                    end)
                end
            end
            updateGoldUI()
            printToAll('💰  '..G.thiefColor..' (Thief) stole '..stolen..'g from '..e.color..'!',{1,0.8,0.2})
        end
    end

    -- Magistrate warrant reveal: when the warranted character's rank is called, flip the
    -- signed warrant face-up (to decorated side = {0,0,180}).
    -- Blank warrants on other characters are flipped to show they are blank.
    if G.warrantedChar and e.guid == G.warrantedChar then
        local signedWarrant = obj(GUID.warrant1)
        if signedWarrant then
            pcall(function() signedWarrant.setRotation({0, 0, 0}) end)
            printToAll('📜  Warrant revealed! '..e.name..' ('..e.color..') was the Magistrate\'s target!',{1,0.9,0.4})
        end
    end

    -- Blackmailer threat: mark pending; the second block below prints the warning and sets UI.
    if G.blackmailTargets and G.blackmailTargets[e.guid] then
        G.blackmailPending = e.guid
    end

    setTurnUI('Turn: '..e.name..'\n('..e.color..')', e.color)
    if isBewitched then
        setStatus(e.color..': gather resources only.\nWitch resumes after.')
    elseif e.guid == GUID.witch then
        setStatus('Gather, Bewitch a rank, End Turn.\n(Build during resume phase only.)')
    elseif e.guid == GUID.navigator then
        setStatus('Gather 2g/2 cards, then use ability\nfor +4 gold or +4 cards. No building.')
    else
        setStatus('Gather resources, use ability,\nbuild, then End Turn.')
    end

    -- Show gather buttons (normal 2g / draw 2 for everyone, including Navigator)
    btn('btnGold', true)
    UI.setValue('btnGold','💰  Take 2 Gold')
    btn('btnDraw', true)
    UI.setValue('btnDraw','🃏  Draw 2 Cards')
    btn('btnEnd', true)

    -- Show ability buttons and update their tooltips for this character
    local labels   = ABILITY_LABEL[e.guid]
    local tooltips = ABILITY_TOOLTIP[e.guid]
    if labels and not isBewitched then
        if labels[1] and labels[1] ~= '' then
            UI.setAttribute('btnAbility','text','✨  '..labels[1])
            btn('btnAbility', true)
            if tooltips and tooltips[1] and tooltips[1] ~= '' then
                UI.setAttribute('btnAbility', 'tooltip', tooltips[1])
            end
        else
            btn('btnAbility', false)
        end
        if labels[2] and labels[2] ~= '' then
            UI.setAttribute('btnAbility2','text','✨  '..labels[2])
            btn('btnAbility2', true)
            if tooltips and tooltips[2] and tooltips[2] ~= '' then
                UI.setAttribute('btnAbility2', 'tooltip', tooltips[2])
            end
        else
            btn('btnAbility2', false)
        end
    else
        btn('btnAbility', false); btn('btnAbility2', false)
    end

    if isBewitched then
        btn('btnAbility', false); btn('btnAbility2', false)
    end

    -- Blackmailer: if this player is threatened, show a warning but HIDE pay/refuse until after gather
    if G.blackmailPending and G.blackmailPending == e.guid then
        local half = math.floor((G.gold[e.color] or 0) / 2)
        logTo(e.color, '⚠️  You are THREATENED by '..(G.blackmailerColor or '?')..'! You MUST gather resources first, THEN choose to Pay ('..half..'g) or Refuse.')
        -- Buttons shown AFTER gather (see onBtnGold/onBtnDraw)
        btn('btnAbility', false); btn('btnAbility2', false)
        G.blackmailResolved = false
        G.blackmailNeedsGather = true  -- flag: reveal pay/refuse after gather
    end

    -- Show/hide the District Ability button based on what the player has built
    refreshUniqueAbilityButton(e.color)

    if e.guid == GUID.witch then
        logTo(e.color, '>> YOUR TURN as Witch! Gather resources, then Bewitch a character rank, then End Turn. You will build during the RESUME phase after the bewitched player gathers.')
    elseif e.guid == GUID.navigator then
        logTo(e.color, '>> YOUR TURN as Navigator! Gather resources (2g or 2 cards) as normal, then use your ability to take 4 gold OR draw 4 cards. You cannot build any districts this turn.')
    else
        logTo(e.color, '>> YOUR TURN as '..e.name..'! Gather resources, use your ability, build, then End Turn.')
    end

    -- Bot: auto-play after a short visual delay
    if isBot(e.color) then
        Wait.time(function() botDoTurn(e.color) end, 2.0)
    end
end

-- ============================================================
--  GATHER RESOURCES
-- ============================================================
function onBtnGold(player)
    if G.phase ~= 'TURN' then return end
    if player.color ~= G.currentColor then logTo(player.color,'Not your turn!'); return end
    if G.hasGathered then logTo(player.color,'Already gathered this turn!'); return end
    G.hasGathered = true

    giveGold(player.color, 2)
    logTo(player.color, 'Took 2g. Total: '..G.gold[player.color]..'g')
    -- Gold Mine passive
    applyGatherPassives(player.color, 'gold')
    btn('btnGold', false); btn('btnDraw', false)

    -- Blackmailer: now that resources are gathered, show Pay/Refuse buttons
    if G.blackmailNeedsGather and G.blackmailPending then
        G.blackmailNeedsGather = false
        local half = math.floor((G.gold[player.color] or 0) / 2)
        UI.setAttribute('btnAbility','text','💰  Pay Blackmailer ('..half..'g)')
        UI.setAttribute('btnAbility','tooltip','Pay half your gold to the Blackmailer. Threat removed, identity secret.')
        btn('btnAbility', true)
        UI.setAttribute('btnAbility2','text','✋  Refuse Blackmail')
        UI.setAttribute('btnAbility2','tooltip','Refuse payment — Blackmailer reveals your character, but you keep your gold.')
        btn('btnAbility2', true)
        logTo(player.color, 'Resources gathered. Now choose: Pay ('..half..'g) or Refuse the blackmail.')
        setStatus('Resources gathered. Resolve blackmail:\nPay or Refuse, then use ability and build.')
    else
        -- General post-gather status update
        local e2 = G.turnOrder[G.turnStep]
        if e2 then
            if G.witchResuming then
                setStatus(player.color..': use '..e2.name.."'s ability and build.")
            elseif (G.buildLimit or 1) == 0 then
                setStatus('Resources gathered. Use ability,\nthen End Turn.')
            else
                setStatus('Resources gathered. Use ability,\nbuild, then End Turn.')
            end
        end
    end

    -- Bewitched: turn immediately ends after gathering, Witch resumes
    local e = G.turnOrder[G.turnStep]
    if e and e.guid == G.bewitchedChar and G.witchColor then
        btn('btnEnd', false)
        Wait.time(function() resumeWitchTurn(e) end, 0.8)
    end
    scheduleAutoEndTurnCheck(player.color, 0.2)
end

function onBtnDraw(player)
    if G.phase ~= 'TURN' then return end
    if player.color ~= G.currentColor then logTo(player.color,'Not your turn!'); return end
    if G.hasGathered then logTo(player.color,'Already gathered this turn!'); return end
    G.hasGathered = true

    local deck = findDistrictDeck()

    if deck then
        local hasLib = hasUnique and hasUnique(player.color,'Library')
        local hasObs = hasUnique and hasUnique(player.color,'Observatory')
        if hasLib then
            deck.deal(2, player.color)
            logTo(player.color, 'LIBRARY: Drew 2 cards — keep ALL of them!')
        elseif hasObs then
            deck.deal(3, player.color)
            G.mustDiscard = 2   -- must return 2 of the 3 drawn cards
            logTo(player.color, 'OBSERVATORY: Drew 3 cards — keep 1. You MUST drag the 2 unwanted cards face-down onto the district deck before ending your turn.')
        else
            deck.deal(2, player.color)
            G.mustDiscard = 1   -- player must return 1 card to deck before ending turn
            logTo(player.color, 'Drew 2 cards — keep 1. You MUST drag the unwanted card face-down onto the district deck before you can end your turn.')
            printToAll('📋  '..player.color..' is choosing 1 of 2 drawn cards — please wait.',{0.8,0.8,1.0})
        end
    else
        logTo(player.color, 'District deck not found!')
    end
    btn('btnGold', false); btn('btnDraw', false)

    -- Blackmailer: now that resources are gathered, show Pay/Refuse buttons
    if G.blackmailNeedsGather and G.blackmailPending then
        G.blackmailNeedsGather = false
        local half = math.floor((G.gold[player.color] or 0) / 2)
        UI.setAttribute('btnAbility','text','💰  Pay Blackmailer ('..half..'g)')
        UI.setAttribute('btnAbility','tooltip','Pay half your gold to the Blackmailer. Threat removed, identity secret.')
        btn('btnAbility', true)
        UI.setAttribute('btnAbility2','text','✋  Refuse Blackmail')
        UI.setAttribute('btnAbility2','tooltip','Refuse payment — Blackmailer reveals your character, but you keep your gold.')
        btn('btnAbility2', true)
        logTo(player.color, 'Resources gathered. Now choose: Pay ('..half..'g) or Refuse the blackmail.')
        setStatus('Resources gathered. Resolve blackmail:\nPay or Refuse, then use ability and build.')
    else
        -- General post-gather status update
        local eg = G.turnOrder[G.turnStep]
        if eg then
            if G.witchResuming then
                setStatus(player.color..': use '..eg.name.."'s ability and build.")
            elseif (G.buildLimit or 1) == 0 then
                setStatus('Resources gathered. Use ability,\nthen End Turn.')
            else
                setStatus('Resources gathered. Use ability,\nbuild, then End Turn.')
            end
        end
    end

    -- Bewitched: turn ends after gathering, then Witch resumes.
    -- If the bewitched player drew cards and still owes a discard, wait for that
    -- first — resumeWitchTurn will be called from onObjectDrop once mustDiscard hits 0.
    local e2 = G.turnOrder[G.turnStep]
    if e2 and e2.guid == G.bewitchedChar and G.witchColor then
        btn('btnEnd', false)
        if (G.mustDiscard or 0) > 0 then
            -- Player must discard first; set a flag so onObjectDrop knows to resume Witch
            G.witchPendingResume = true
            logTo(player.color, 'Drew 2 cards — drag the unwanted card face-down onto the district deck first, then the Witch will resume.')
        else
            Wait.time(function() resumeWitchTurn(e2) end, 0.8)
        end
    end
    scheduleAutoEndTurnCheck(player.color, 0.2)
end

-- ============================================================
--  WITCH RESUME
--  Called when the bewitched character finishes their gather-only
--  mini-turn. Witch now plays as the bewitched character.
-- ============================================================
function resumeWitchTurn(e)
    if not G.witchColor or not e then return end
    printToAll('🧙  Witch ('..G.witchColor..') now takes their turn as '..e.name..'!',{0.7,0.4,1.0})
    G.currentColor = G.witchColor
    G.currentChar  = e.guid    -- ensure bot sees the bewitched character's guid
    G.hasGathered  = true   -- Witch already gathered during her initial turn; no second gather in resume
    G.abilityUsed  = false
    G.buildCount   = 0
    G.mustDiscard  = 0
    G.mustDiscardShuffle = false
    G.witchOnHold  = false
    G.witchResuming = true  -- Witch is now in resume phase — building allowed
    -- Witch already gathered — if the bewitched character was blackmailed, resolve it now
    G.blackmailNeedsGather = false

    -- Build limit inherits from bewitched character's rules
    if e.guid == GUID.architect   then G.buildLimit = 3
    elseif e.guid == GUID.scholar  then G.buildLimit = 2
    elseif e.guid == GUID.seer     then G.buildLimit = 2
    elseif e.guid == GUID.navigator then G.buildLimit = 0
    else G.buildLimit = 1
    end

    setTurnUI('Witch turn:\n'..e.name, G.witchColor)
    -- Ping + glow at the Witch's seat (she is now the active player)
    notifyTurnStart(G.witchColor, e.guid)
    if G.buildLimit == 0 then
        setStatus(G.witchColor..': use '..e.name.."'s ability. No building (Navigator).")
    else
        setStatus(G.witchColor..': use '..e.name.."'s ability and build in your city.")
    end
    logTo(G.witchColor, '>> WITCH RESUME: You now play as '..e.name..'. Use their ability and build in YOUR city with YOUR gold! (You already gathered on your initial turn.)')

    -- Show ability buttons for the bewitched character
    local labels   = ABILITY_LABEL[e.guid]
    local tooltips = ABILITY_TOOLTIP[e.guid]
    btn('btnAbility', false); btn('btnAbility2', false)
    if labels then
        if labels[1] and labels[1] ~= '' then
            UI.setAttribute('btnAbility','text','✨  '..labels[1]); btn('btnAbility',true)
            if tooltips and tooltips[1] and tooltips[1] ~= '' then
                UI.setAttribute('btnAbility','tooltip', tooltips[1])
            end
        end
        if labels[2] and labels[2] ~= '' then
            UI.setAttribute('btnAbility2','text','✨  '..labels[2]); btn('btnAbility2',true)
            if tooltips and tooltips[2] and tooltips[2] ~= '' then
                UI.setAttribute('btnAbility2','tooltip', tooltips[2])
            end
        end
    end
    -- Witch already gathered on her initial turn — no second gather in resume phase
    btn('btnGold', false); btn('btnDraw', false)
    btn('btnEnd', true)

    -- If the bewitched character was blackmailed, Witch must resolve it now
    -- (blackmailNeedsGather was already cleared above since Witch already gathered)
    if G.blackmailPending and G.blackmailPending == e.guid then
        local half = math.floor((G.gold[G.witchColor] or 0) / 2)
        UI.setAttribute('btnAbility','text','💰  Pay Blackmailer ('..half..'g)')
        UI.setAttribute('btnAbility','tooltip','Pay half your gold to the Blackmailer. Threat removed.')
        btn('btnAbility', true)
        UI.setAttribute('btnAbility2','text','✋  Refuse Blackmail')
        UI.setAttribute('btnAbility2','tooltip','Refuse — Blackmailer reveals the Marshal\'s identity, but you keep your gold.')
        btn('btnAbility2', true)
        G.blackmailResolved = false
        logTo(G.witchColor, '⚠️  The bewitched character was threatened! Resolve the blackmail: Pay ('..half..'g) or Refuse, then use '..e.name.."'s ability and build.")
        setStatus('Resolve blackmail: Pay or Refuse,\nthen use ability and build.')
    end

    G.bewitchedChar = nil  -- clear so witch's own end-turn goes normally

    -- Bot witch: auto-play the bewitched character's turn
    if isBot(G.witchColor) then
        Wait.time(function() botDoTurn(G.witchColor) end, 1.5)
    end
end

-- ============================================================
--  END TURN
-- ============================================================
function onBtnBugReport(player)
    local lines = {}
    local function add(s) table.insert(lines, s) end

    add('════════════════════════════════')
    add('🐛  BUG REPORT — ' .. os.date('%H:%M:%S'))
    add('════════════════════════════════')
    add('Phase: '  .. tostring(G.phase)        .. '  |  Round: '  .. tostring(G.roundNumber))
    add('Turn: '   .. tostring(G.currentColor) .. '  |  Char: '   .. tostring(G.currentChar and (CHAR_NAME[G.currentChar] or G.currentChar) or '—'))
    add('Crown: '  .. tostring(G.crownColor)   .. '  |  Step: '   .. tostring(G.turnStep) .. '/' .. tostring(#(G.turnOrder or {})))
    add('Gathered: '.. tostring(G.hasGathered) .. '  |  BuildCount: ' .. tostring(G.buildCount) .. '/' .. tostring(G.buildLimit))
    add('AbilityUsed: ' .. tostring(G.abilityUsed) .. '  |  Targeting: ' .. tostring(G.targeting))

    -- Per-player gold and city
    add('────────────────────────────────')
    for _, c in ipairs(G.players or {}) do
        add(c .. ':  ' .. tostring(G.gold[c] or 0) .. 'g  |  City: ' .. tostring(G.citySize[c] or 0) .. '  |  Score: ' .. tostring(G.cityScore[c] or 0))
    end

    -- Active flags
    add('────────────────────────────────')
    local flags = {}
    local check = {
        witchOnHold='witchOnHold', witchResuming='witchResuming',
        cardinalPendingBuild='cardinalPending', cardinalBuildResuming='cardinalResuming',
        cardinalCardTarget='cardinalTarget',
        necropolisPendingBuild='necropolisPending',
        thievesDenPendingBuild='thievesDenPending',
        spyRevealedCards='spyRevealed',
        mustDiscard='mustDiscard',
        killedChar='killed', bewitchedChar='bewitched', robbedChar='robbed',
    }
    for k, label in pairs(check) do
        if G[k] and G[k] ~= false and G[k] ~= 0 then
            local v = type(G[k]) == 'table' and '(table)' or tostring(G[k])
            table.insert(flags, label .. '=' .. v)
        end
    end
    if #flags > 0 then
        add('Flags: ' .. table.concat(flags, '  '))
    else
        add('Flags: (none)')
    end

    add('════════════════════════════════')

    -- Print to the reporting player privately first, then broadcast to all
    local out = table.concat(lines, '\n')
    printToAll(out, {1, 0.6, 0.2})
    log('[BUG REPORT]\n' .. out)
end

-- Shared: return any Spy-revealed cards to the target's hand. Called by both
-- onBtnEnd (human) and botEndTurn (bot) so the return always fires.
local function returnSpyCards()
    if not (G.spyRevealedCards and #G.spyRevealedCards > 0 and G.spyRevealTarget) then return end
    local targetColor = G.spyRevealTarget
    local handPos     = HAND_POS[targetColor]
    local faceZ       = (G.bots and G.bots[targetColor]) and 0 or 180
    for i, guid in ipairs(G.spyRevealedCards) do
        local ci = i
        Wait.time(function()
            local c = getObjectFromGUID(guid)
            if c and handPos then pcall(function()
                c.setRotation({0, 0, faceZ})
                c.setPosition({x=handPos.x, y=handPos.y + 4, z=handPos.z})
                Wait.time(function() pcall(function() c.setPosition(handPos) end) end, 0.1)
            end) end
        end, (ci-1)*0.2)
    end
    logTo(targetColor, 'Spy has ended their turn — your hand cards have been returned to your hand.')
    G.spyRevealedCards = nil
    G.spyRevealTarget  = nil
end

local function seerRemainingReturns()
    local pending = 0
    for _, needsCard in pairs(G.seerReturnTargets or {}) do
        if needsCard then pending = pending + 1 end
    end
    return pending
end

local function seerHoldingPos(color, slot)
    local pos = PLAYER_POS[color] or {x=0, y=1, z=0}
    local spread = ((slot or 1) - 1) * CARD_SPREAD_GAP
    if math.abs(pos.x) > 40 then
        local xDir = pos.x > 0 and -10 or 10
        return {x=pos.x + xDir, y=pos.y + 0.5, z=pos.z - 4 + spread}
    end
    local zDir = pos.z >= 0 and -10 or 10
    return {x=pos.x - 4 + spread, y=pos.y + 0.5, z=pos.z + zDir}
end

local function bounceSeerCardBack(color, cardObj)
    if not cardObj then return end
    local dest = seerHoldingPos(color, seerRemainingReturns() + 1)
    pcall(function()
        cardObj.setRotation({0, 0, 180})
        cardObj.setPosition({x=dest.x, y=dest.y + 4, z=dest.z})
        Wait.time(function() pcall(function() cardObj.setPosition(dest) end) end, 0.1)
    end)
end

local function tryHandleSeerReturn(playerColor, droppedObject, pos, guid)
    if (G.seerMustReturn or 0) <= 0 or G.phase ~= 'TURN' then return false end
    if playerColor ~= G.currentColor or G.currentChar ~= GUID.seer then return false end

    for _, otherColor in ipairs(G.players or {}) do
        if otherColor ~= playerColor then
            local areaPos = PLAYER_POS[otherColor]
            local handPos = HAND_POS[otherColor]
            local nearArea = areaPos and math.sqrt((pos.x-areaPos.x)^2+(pos.z-areaPos.z)^2) < 20
            local nearHand = handPos and math.sqrt((pos.x-handPos.x)^2+(pos.z-handPos.z)^2) < 18
            if nearArea or nearHand then
                if not (G.seerReturnTargets and G.seerReturnTargets[otherColor]) then
                    G.cardFromHand[guid] = nil
                    logTo(playerColor, 'SEER: '..otherColor..' does not need a returned card. Choose a different player.')
                    bounceSeerCardBack(playerColor, droppedObject)
                    return true
                end

                if handPos then
                    local faceZ = (G.bots and G.bots[otherColor]) and 0 or 180
                    pcall(function()
                        droppedObject.setRotation({0,0,faceZ})
                        droppedObject.setPosition({x=handPos.x, y=handPos.y+4, z=handPos.z})
                        Wait.time(function()
                            pcall(function() droppedObject.setPosition(handPos) end)
                        end, 0.1)
                    end)
                end

                G.cardFromHand[guid] = nil
                G.seerReturnTargets[otherColor] = nil
                G.seerMustReturn = seerRemainingReturns()

                if G.seerMustReturn > 0 then
                    logTo(playerColor, 'SEER: Card returned to '..otherColor..'. '..G.seerMustReturn..' more card(s) to return.')
                else
                    logTo(playerColor, 'SEER: All cards returned. You may now End Turn.')
                    scheduleAutoEndTurnCheck(playerColor, 0.15)
                end
                return true
            end
        end
    end

    return false
end

function onBtnEnd(player)
    if G.phase ~= 'TURN' then return end
    if not player or player.color ~= G.currentColor then return end
    if G.turnAdvancePending or G.roundEnding then return end
    if not G.hasGathered then logTo(player.color,'You must gather resources first!'); return end
    if requireBlackmailResolved(player.color, 'ending your turn') then return end
    if (G.mustDiscard or 0) > 0 then
        logTo(player.color, 'You must return '..G.mustDiscard..' card(s) to the district deck first — drag them face-down onto the deck.')
        return
    end
    G.seerMustReturn = seerRemainingReturns()
    if (G.seerMustReturn or 0) > 0 then
        logTo(player.color, 'SEER: You must return '..G.seerMustReturn..' more card(s) to other players first — drag a card to each player\'s area.')
        return
    end

    -- Alchemist refund
    if G.currentChar == GUID.alchemist and G.alchemistGold > 0 then
        giveGold(player.color, G.alchemistGold)
        logTo(player.color, 'Alchemist: refunded '..G.alchemistGold..'g spent on districts.')
        G.alchemistGold = 0
    end

    -- Tax Collector: if any tax gold accumulated, take it
    -- (Tax gold accumulates via onDistrictBuilt when taxcollector is in play)

    -- Witch: if this was the bewitched player's gather-turn, now witch resumes
    local e = G.turnOrder[G.turnStep]
    local wasBewitched = (e and e.guid == G.bewitchedChar)
    if wasBewitched and G.witchColor then
        resumeWitchTurn(e)
        return
    end

    btn('btnGold',false); btn('btnDraw',false); btn('btnEnd',false)
    btn('btnAbility',false); btn('btnAbility2',false)
    btn('btnUniqueAbility',false); btn('btnDistrictLab',false); btn('btnDistrictMuseum',false); btn('btnDistrictArmory',false)

    -- Park: if hand is empty at end of turn, draw 2
    applyEndOfTurnUniques(player.color)

    returnSpyCards()

    debugLog(player.color..' ended their turn.')
    scheduleAdvanceTurn(0.4)
end

-- ============================================================
--  ABILITY HANDLERS
-- ============================================================

-- Helper: prompt current player to name a character by rank
local function promptNameChar(promptMsg, callback)
    -- We use chat: player types the rank number in response
    -- Store callback for onChat to pick up
    G.pendingPrompt = { color=G.currentColor, msg=promptMsg, cb=callback }
    logTo(G.currentColor, promptMsg..' Type the rank number (1-9) in chat.')
end


-- ============================================================
--  UI TARGETING SYSTEM (defined before onBtnAbility so it is in scope)
-- ============================================================
function showRankPicker(prompt, mode)
    G.targeting = mode
    UI.setValue('txtTargetPrompt', prompt)
    -- Label each rank button with the character name if game is running
    for r = 1, 9 do
        local charGuid = G.gameCast and G.gameCast[r]
        local charName = charGuid and CHAR_NAME and CHAR_NAME[charGuid]
        local btn_id   = 'btnRank'..r
        if charName then
            -- Show rank number + abbreviated name so player knows what's at each slot
            local short = charName:sub(1, 9)  -- truncate long names
            UI.setAttribute(btn_id, 'text',    r..': '..short)
            UI.setAttribute(btn_id, 'tooltip', 'Rank '..r..' — '..charName)
            UI.setAttribute(btn_id, 'fontSize', '9')
        else
            UI.setAttribute(btn_id, 'text',    tostring(r))
            UI.setAttribute(btn_id, 'tooltip', 'Select rank '..r)
            UI.setAttribute(btn_id, 'fontSize', '11')
        end
    end
    UI.setAttribute('pnlTarget', 'active', 'true')
    UI.setAttribute('pnlTargetPlayer', 'active', 'false')
    btn('btnAbility', false); btn('btnAbility2', false)
end

function hideTargetPanels()
    UI.setAttribute('pnlTarget', 'active', 'false')
    UI.setAttribute('pnlTargetPlayer', 'active', 'false')
    setTargetPlayerPanelLayout('compact', 4)
    G.targeting = nil
    scheduleAutoEndTurnCheck(G.currentColor, 0.1)
end

-- Rebuild the player target panel dynamically based on current players
function showPlayerPicker(prompt, mode, excludeSelf)
    G.targeting = mode
    -- Build the player list
    G.targetPlayerList = {}
    for _, c in ipairs(G.players) do
        if not (excludeSelf and c == G.currentColor) then
            table.insert(G.targetPlayerList, c)
        end
    end
    local n = #G.targetPlayerList
    setTargetPlayerPanelLayout('compact', n)
    -- Show prompt text above the buttons
    UI.setValue('txtTargetPrompt', prompt)
    -- Label and enable/disable each pick button based on player list
    for i = 1, 8 do
        local bid = 'btnPick'..i
        if i <= n then
            local pc = G.targetPlayerList[i]
            UI.setAttribute(bid, 'active', 'true')
            UI.setAttribute(bid, 'text', pc)
            UI.setAttribute(bid, 'colors', COLOR_BTN[pc] or '#225533|#33AA66|#1A4428|#225533')
            UI.setAttribute(bid, 'color',  hexOf(pc))
        else
            UI.setAttribute(bid, 'active', 'false')
        end
    end
    UI.setAttribute('pnlTarget', 'active', 'false')
    UI.setAttribute('pnlTargetPlayer', 'active', 'true')
    btn('btnAbility', false); btn('btnAbility2', false)
end

-- Show the player-picker panel repurposed as a district-type picker.
-- Buttons are labelled and colour-coded by district type (1-5).
local DTYPE_LABELS = {
    {name='⚜  Noble',     color='#CCAA00', colors='#664400|#AA8800|#332200|#664400'},
    {name='✝  Religious', color='#4488FF', colors='#002266|#1144BB|#001144|#002266'},
    {name='💰  Trade',    color='#22BB55', colors='#004422|#118844|#002211|#004422'},
    {name='⚔  Military', color='#FF5555', colors='#661111|#CC2222|#330808|#661111'},
    {name='🔮  Unique',   color='#BB66FF', colors='#440077|#8833CC|#220044|#440077'},
}
function showTypePicker(prompt, mode)
    G.targeting = mode
    setTargetPlayerPanelLayout('compact', #DTYPE_LABELS)
    UI.setValue('txtTargetPrompt', prompt)
    for i = 1, 8 do
        local bid = 'btnPick'..i
        if i <= #DTYPE_LABELS then
            local d = DTYPE_LABELS[i]
            UI.setAttribute(bid, 'active', 'true')
            UI.setAttribute(bid, 'text',   d.name)
            UI.setAttribute(bid, 'color',  d.color)
            UI.setAttribute(bid, 'colors', d.colors)
        else
            UI.setAttribute(bid, 'active', 'false')
        end
    end
    UI.setAttribute('pnlTarget',       'active', 'false')
    UI.setAttribute('pnlTargetPlayer', 'active', 'true')
    btn('btnAbility', false); btn('btnAbility2', false)
end

function onTargetCancel(player)
    if player.color ~= G.currentColor then return end
    local wasCardinalPick = (G.targeting == 'cardinal_target' or G.targeting == 'cardinal_card_pick')
    local wasTheaterPick = (G.targeting == 'theater_char_target' or G.targeting == 'theater_char_mychoice')
    hideTargetPanels()
    -- If Cardinal borrow was in progress, clean all state and flip the card back
    if wasCardinalPick or G.cardinalPendingBuild or G.cardinalCardTarget then
        local pb = G.cardinalPendingBuild
        G.cardinalPendingBuild  = nil
        G.cardinalCardTarget    = nil
        G.cardinalCardsNeeded   = nil
        G.cardinalCardPicks     = nil
        G.cardinalHandCards     = nil
        G.cardinalBuildResuming = false
        -- Flip the pending district card face-down (it stayed face-up during the picker)
        if pb and pb.distName then
            for _, o in ipairs(getAllObjects()) do
                pcall(function()
                    if o.getName():match('^%s*(.-)%s*$') == pb.distName then
                        local rot = o.getRotation()
                        local faceUp = (math.abs(rot.z) < 45)
                        if faceUp then o.flip() end
                    end
                end)
            end
        end
        logTo(player.color, 'Cardinal borrow cancelled.')
    elseif G.frameworkPendingBuild then
        local fb = G.frameworkPendingBuild
        G.frameworkPendingBuild = nil
        G.frameworkMode = false
        G.frameworkResume = false
        local dropObj = fb and fb.guid and obj(fb.guid)
        if dropObj then pcall(function() dropObj.flip() end) end
        logTo(player.color, 'Framework build cancelled.')
    elseif wasTheaterPick or G.theaterOwner or G.theaterTarget then
        G.theaterOwner = nil
        G.theaterTarget = nil
        G.currentColor = nil
        G.targeting = nil
        logTo(player.color, 'THEATER: Character exchange cancelled. Starting the turn phase.')
        Wait.time(beginTurnPhase, 0.1)
        return
    else
        logTo(player.color, 'Targeting cancelled.')
    end
    -- Restore ability buttons
    local e = G.turnOrder[G.turnStep]
    if e then
        local labels = ABILITY_LABEL[e.guid]
        if labels then
            if labels[1] and labels[1] ~= '' then
                UI.setAttribute('btnAbility','text','✨  '..labels[1]); btn('btnAbility',true)
            end
            if labels[2] and labels[2] ~= '' then
                UI.setAttribute('btnAbility2','text','✨  '..labels[2]); btn('btnAbility2',true)
            end
        end
    end
end

-- ============================================================
--  THIEVES' DEN — CARD PICKER
--  Replaces the old rank-number prompt with a panel that shows
--  the player's actual hand cards so they can pick which to discard.
-- ============================================================
function showThievesDenPicker()
    local color = G.currentColor
    local pb    = G.thievesDenPendingBuild
    if not pb then return end

    -- Build list of hand cards available to discard (excluding already-selected)
    local selectedSet = {}
    G.thievesDenSelectedCards = G.thievesDenSelectedCards or {}
    for _, sc in ipairs(G.thievesDenSelectedCards) do selectedSet[sc.guid] = true end

    local available = {}
    pcall(function()
        local p = Player[color]
        if not p then return end
        for _, c in ipairs(p.getHandObjects()) do
            local n = (c.getName() or ''):match('^%s*(.-)%s*$')
            -- Only district cards may be discarded — skip character cards
            if n ~= '' and not selectedSet[c.getGUID()] and DISTRICT_DATA[n] then
                table.insert(available, {guid=c.getGUID(), name=n})
            end
        end
    end)
    G.thievesDenHandList = available

    local selectedCount = #G.thievesDenSelectedCards
    local gap           = G.thievesDenGoldGap or 0
    local remaining     = math.max(0, gap - selectedCount)

    G.targeting = 'thieves_pick_card'

    local prompt
    if remaining > 0 then
        prompt = "THIEVES' DEN — pick "..remaining.." more card(s) to discard ("
                 ..selectedCount.." selected, "..remaining.."g still owed):"
    else
        prompt = "THIEVES' DEN — "..selectedCount.." card(s) selected. Confirm to build, or pick more."
    end
    UI.setValue('txtTargetPrompt', prompt)

    local btnIdx = 1
    -- Show Confirm button when enough cards are selected
    if remaining <= 0 then
        UI.setAttribute('btnPick'..btnIdx, 'active',  'true')
        UI.setAttribute('btnPick'..btnIdx, 'text',    '✅  Build now ('..selectedCount..' card(s) used)')
        UI.setAttribute('btnPick'..btnIdx, 'color',   '#88FF88')
        UI.setAttribute('btnPick'..btnIdx, 'colors',  '#1B6B3A|#27AE60|#145A32|#1B6B3A')
        btnIdx = btnIdx + 1
    end

    -- List available hand cards
    for _, hc in ipairs(available) do
        if btnIdx > 8 then break end
        UI.setAttribute('btnPick'..btnIdx, 'active', 'true')
        UI.setAttribute('btnPick'..btnIdx, 'text',   hc.name)
        UI.setAttribute('btnPick'..btnIdx, 'color',  'white')
        UI.setAttribute('btnPick'..btnIdx, 'colors', '#333355|#5555AA|#222244|#333355')
        btnIdx = btnIdx + 1
    end

    -- Hide unused slots
    for i = btnIdx, 8 do UI.setAttribute('btnPick'..i, 'active', 'false') end

    UI.setAttribute('pnlTarget',       'active', 'false')
    UI.setAttribute('pnlTargetPlayer', 'active', 'true')
    btn('btnAbility', false); btn('btnAbility2', false)
end

function confirmThievesDenBuild()
    local pb       = G.thievesDenPendingBuild
    local selected = G.thievesDenSelectedCards or {}
    if not pb then return end

    local discardCount = #selected
    G.thievesDenDiscount       = discardCount
    G.thievesDenPending        = nil
    G.thievesDenPendingBuild   = nil
    G.thievesDenSelectedCards  = {}
    G.thievesDenHandList       = {}
    G.thievesDenGoldGap        = 0
    hideTargetPanels()

    -- Restore character ability buttons that showThievesDenPicker() disabled
    if not G.abilityUsed then
        local labels   = ABILITY_LABEL[G.currentChar]
        local tooltips = ABILITY_TOOLTIP[G.currentChar]
        if labels and labels[1] and labels[1] ~= '' then
            UI.setAttribute('btnAbility','text','✨  '..labels[1])
            if tooltips and tooltips[1] and tooltips[1] ~= '' then
                UI.setAttribute('btnAbility','tooltip',tooltips[1])
            end
            btn('btnAbility', true)
        end
        if labels and labels[2] and labels[2] ~= '' then
            UI.setAttribute('btnAbility2','text','✨  '..labels[2])
            if tooltips and tooltips[2] and tooltips[2] ~= '' then
                UI.setAttribute('btnAbility2','tooltip',tooltips[2])
            end
            btn('btnAbility2', true)
        end
    end

    -- Physically move selected hand cards to the district deck face-down
    local deck = findDistrictDeck()
    for i, sc in ipairs(selected) do
        local cardObj = obj(sc.guid)
        if cardObj then
            local delay = (i - 1) * 0.18
            pcall(function()
                local p = Player[pb.color]
                if p and p.seated then pcall(function() p.removeHandObject(cardObj) end) end
            end)
            Wait.time(function()
                pcall(function()
                    cardObj.setRotation({0, 0, 180})
                    if deck then deck.putObject(cardObj)
                    else liftThenPlace(cardObj, DISCARD_DOWN_POS) end
                end)
            end, delay)
        end
    end

    -- Resume the build after the cards have been sent to the deck
    Wait.time(function()
        local result = onDistrictBuilt({
            color        = pb.color,
            cost         = pb.cost,
            districtType = pb.dtype,
            districtName = pb.dname,
            droppedGuid  = pb.guid,
        })
        if not result then
            local cardObj = obj(pb.guid)
            if cardObj then pcall(function() cardObj.flip() end) end
        end
    end, #selected * 0.18 + 0.4)

    logTo(pb.color, "THIEVES' DEN: Discarded "..discardCount..' card(s) → building '
          ..pb.dname..' with -'..discardCount..'g discount!')
end

-- Shared rank pick handler
function handleRankPick(player, rank)
    if player.color ~= G.currentColor then return end
    local mode = G.targeting
    if not mode then return end
    hideTargetPanels()

    local target = G.gameCast[rank]

    if mode == 'kill' then
        if rank == 1 then
            logTo(player.color,'Cannot kill rank 1! Choose another.')
            showRankPicker('ASSASSIN: Kill which rank? (not rank 1, yourself, or revealed)', 'kill')
            return
        end
        if not target then
            logTo(player.color,'No character at rank '..rank..'. Choose another.')
            showRankPicker('ASSASSIN: Kill which rank? (not rank 1, yourself, or revealed)', 'kill')
            return
        end
        if target == G.currentChar then
            logTo(player.color,'Cannot kill yourself! Choose another.')
            showRankPicker('ASSASSIN: Kill which rank? (not rank 1, yourself, or revealed)', 'kill')
            return
        end
        if G.faceUpDiscards and G.faceUpDiscards[target] then
            logTo(player.color,'That character was discarded face-up — they are not in play! Choose another.')
            showRankPicker('ASSASSIN: Kill which rank? (not rank 1, yourself, or revealed)', 'kill')
            return
        end
        G.killedChar = target
        logTo(player.color,'ASSASSIN: Rank '..rank..' ('..CHAR_NAME[target]..') will be killed this round. Their turn will be skipped.')
        debugLog(player.color..' (Assassin) used their ability.')

    elseif mode == 'bewitch' then
        if rank == 1 then
            logTo(player.color,'Cannot bewitch rank 1! Choose another.')
            showRankPicker('WITCH: Bewitch which rank? (not rank 1, yourself, or revealed)', 'bewitch')
            return
        end
        if not target then
            logTo(player.color,'No character at rank '..rank..'. Choose another.')
            showRankPicker('WITCH: Bewitch which rank? (not rank 1, yourself, or revealed)', 'bewitch')
            return
        end
        if target == G.currentChar then
            logTo(player.color,'Cannot bewitch yourself! Choose another.')
            showRankPicker('WITCH: Bewitch which rank? (not rank 1, yourself, or revealed)', 'bewitch')
            return
        end
        if G.faceUpDiscards and G.faceUpDiscards[target] then
            logTo(player.color,'That character was discarded face-up — they are not in play! Choose another.')
            showRankPicker('WITCH: Bewitch which rank? (not rank 1, yourself, or revealed)', 'bewitch')
            return
        end
        G.bewitchedChar = target
        G.witchColor    = player.color
        G.abilityUsed   = true   -- can't use ability again
        G.witchOnHold   = true   -- witch cannot build until she resumes after bewitched player
        G.buildLimit    = 0      -- no building while on hold
        btn('btnAbility', false); btn('btnAbility2', false)
        printToAll('🧙  '..player.color..' (Witch) has bewitched rank '..rank..' — '..CHAR_NAME[target]..'. When that rank is called, they gather only, then the Witch takes their turn.',{0.7,0.4,1.0})
        logTo(player.color,'WITCH: Your turn is now on hold — click End Turn. You will resume after rank '..rank..' gathers.')
        debugLog(player.color..' (Witch) used their ability.')

    elseif mode == 'rob' then
        if rank == 1 then
            logTo(player.color,'Cannot rob rank 1! Choose a different rank.')
            showRankPicker('THIEF: Rob which rank? (not rank 1, yourself, killed, or revealed)', 'rob')
            return
        end
        if not target then
            logTo(player.color,'No character at rank '..rank..'. Choose another.')
            showRankPicker('THIEF: Rob which rank? (not rank 1, yourself, killed, or revealed)', 'rob')
            return
        end
        if target == G.currentChar then
            logTo(player.color,'Cannot rob yourself! Choose a different rank.')
            showRankPicker('THIEF: Rob which rank? (not rank 1, yourself, killed, or revealed)', 'rob')
            return
        end
        if target == G.killedChar then
            logTo(player.color,'Cannot rob the killed character! Choose a different rank.')
            showRankPicker('THIEF: Rob which rank? (not rank 1, yourself, killed, or revealed)', 'rob')
            return
        end
        if target == G.bewitchedChar then
            logTo(player.color,'Cannot rob the bewitched character! Choose a different rank.')
            showRankPicker('THIEF: Rob which rank? (not rank 1, yourself, killed, or revealed)', 'rob')
            return
        end
        if G.faceUpDiscards and G.faceUpDiscards[target] then
            logTo(player.color,'That character was discarded face-up — they are not in play! Choose another.')
            showRankPicker('THIEF: Rob which rank? (not rank 1, yourself, killed, or revealed)', 'rob')
            return
        end
        G.robbedChar = target
        G.thiefColor = player.color
        logTo(player.color,'THIEF: Will rob rank '..rank..' ('..CHAR_NAME[target]..') when they are revealed.')
        debugLog(player.color..' (Thief) used their ability.')

    elseif mode == 'necropolis_sacrifice' then
        local pickList = G.necropolisPickList or {}
        local pending  = G.necropolisPendingBuild
        local color    = player.color
        hideTargetPanels()
        G.necropolisPickList    = nil
        G.necropolisPendingBuild = nil

        -- Slot after the last district is the "Pay normally" button
        local paySlot = math.min(#pickList, 7) + 1
        if rank == paySlot then
            -- Player chose to pay gold normally
            local cost  = pending and pending.cost  or 5
            local dtype = pending and pending.dtype or 'unique'
            local dname = pending and pending.dname or 'Necropolis'
            local result = onDistrictBuilt({
                color        = color,
                cost         = cost,
                districtType = dtype,
                districtName = dname,
            })
            if not result then
                local dropObj = pending and obj(pending.guid)
                if dropObj then dropObj.flip() end
            end
            return
        end

        local distName = pickList[rank]
        if not distName then logTo(color,'Invalid selection.'); return end

        local ddata = DISTRICT_DATA[distName] or {0,'unknown'}
        local dCost, dType = ddata[1], ddata[2]
        local prevNecropolisScore = G.cityScore[color] or 0

        -- Remove sacrificed district from city state
        removeDistrictFromCity(color, distName, dCost, dType)

        -- Move sacrificed card to bottom of district deck
        local pp = PLAYER_POS[color]
        if pp then
            for _, o in ipairs(getAllObjects()) do
                pcall(function()
                    if o.getName() == distName then
                        local op = o.getPosition()
                        if math.sqrt((op.x-pp.x)^2+(op.z-pp.z)^2) < 25 then
                            discardToBottom(o)
                        end
                    end
                end)
            end
        end

        -- Build Necropolis for free (cost=0, card already in city from the drop)
        G.necropolisMode = true
        local result = onDistrictBuilt({
            color        = color,
            cost         = 0,
            districtType = 'unique',
            districtName = 'Necropolis',
        })
        G.necropolisMode = false
        if not result then
            -- Build was rejected (shouldn't happen but flip the card back if so)
            local dropObj = pending and obj(pending.guid)
            if dropObj then dropObj.flip() end
        else
            -- Necropolis is worth its face value (5 pts) for scoring even though built for free
            local nVal = (DISTRICT_DATA['Necropolis'] or {5})[1] or 5
            G.cityScore[color] = (G.cityScore[color] or 0) + nVal
            -- Fix cityCosts: replace the 0 that onDistrictBuilt recorded with the face value
            -- (important for Basilica odd-cost scoring)
            if G.cityCosts and G.cityCosts[color] then
                for i = #G.cityCosts[color], 1, -1 do
                    if G.cityCosts[color][i] == 0 then
                        G.cityCosts[color][i] = nVal
                        break
                    end
                end
            end
        end
        logTo(color,'NECROPOLIS: Sacrificed '..distName..'. Necropolis placed for free! (+' ..(DISTRICT_DATA['Necropolis'] or {5})[1]..' pts)')
        printToAll('💀 '..color..' (Necropolis): sacrificed '..distName..' to build Necropolis!',{0.7,0.4,1.0})
        announceScoreChange(color, (G.cityScore[color] or 0) - prevNecropolisScore, 'Necropolis (sacrificed '..distName..')')

    elseif mode == 'framework_choice' then
        local pending = G.frameworkPendingBuild
        local color   = player.color
        hideTargetPanels()
        G.frameworkPendingBuild = nil
        if not pending or pending.color ~= color then
            logTo(color,'FRAMEWORK: Pending build lost.')
            return
        end

        local dropObj = pending.guid and obj(pending.guid)
        if rank == 1 then
            local frameworkCard = findDistrictCardInCity(color, 'Framework')
            local prevFrameworkScore = G.cityScore[color] or 0
            removeDistrictFromCity(color, 'Framework', 3, 'unique')
            if frameworkCard then discardToBottom(frameworkCard) end

            G.frameworkResume = true
            G.frameworkMode   = true
            local result = onDistrictBuilt({
                color        = color,
                cost         = 0,
                districtType = pending.dtype,
                districtName = pending.dname,
                droppedGuid  = pending.guid,
            })
            G.frameworkMode   = false
            G.frameworkResume = false

            if not result then
                if dropObj then dropObj.flip() end
                logTo(color,'FRAMEWORK: Free build failed.')
                return
            end

            local faceValue = pending.faceValue or ((DISTRICT_DATA[pending.dname] or {pending.cost})[1] or pending.cost or 0)
            G.cityScore[color] = (G.cityScore[color] or 0) + faceValue
            if G.cityCosts and G.cityCosts[color] then
                for i = #G.cityCosts[color], 1, -1 do
                    if G.cityCosts[color][i] == 0 then
                        G.cityCosts[color][i] = faceValue
                        break
                    end
                end
            end
            announceScoreChange(color, (G.cityScore[color] or 0) - prevFrameworkScore, 'built '..pending.dname..' using Framework')
            logTo(color,'FRAMEWORK: Destroyed Framework to build '..pending.dname..' for free.')
            printToAll('🧱 '..color..' destroyed Framework to build '..pending.dname..' for free!',{0.8,0.6,1.0})
            return
        end

        G.frameworkResume = true
        local result = onDistrictBuilt({
            color        = color,
            cost         = pending.cost,
            districtType = pending.dtype,
            districtName = pending.dname,
            droppedGuid  = pending.guid,
        })
        G.frameworkResume = false
        if not result and dropObj then dropObj.flip() end
        return

    elseif mode == 'armory_target' then
        local aTarget = G.targetPlayerList and G.targetPlayerList[rank]
        if not aTarget then return end
        -- Check target city isn't completed (protection rule)
        if (G.citySize[aTarget] or 0) >= cityThreshold() then
            logTo(player.color,'Cannot target a completed city with Armory!')
            showPlayerPicker('ARMORY: Destroy a district from which player?','armory_target',false)
            return
        end
        G.armoryTarget = aTarget
        -- Show their districts as named buttons
        local districts = {}
        for name,_ in pairs(G.cityNames[aTarget] or {}) do
            if findDistrictCardInCity(aTarget, name) then
                table.insert(districts, name)
            end
        end
        table.sort(districts)
        if #districts == 0 then logTo(player.color,aTarget..' has no districts!'); return end
        G.armoryDistrictList = districts
        G.targeting = 'armory_district'
        UI.setValue('txtTargetPrompt','ARMORY: Destroy which district in '..aTarget.."'s city?")
        for i=1,8 do
            local bid = 'btnPick'..i
            if i <= #districts then
                local dname = districts[i]
                local ddata = DISTRICT_DATA[dname] or {0,'unknown'}
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text', dname..' ('..ddata[1]..'g)')
                UI.setAttribute(bid,'color','#FF9988')
                UI.setAttribute(bid,'colors','#661111|#AA2222|#330808|#661111')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')

    elseif mode == 'armory_district' then
        local aTarget   = G.armoryTarget
        local distList  = G.armoryDistrictList or {}
        local distName  = distList[rank]
        if not aTarget or not distName then logTo(player.color,'Invalid selection.'); return end
        G.armoryTarget = nil; G.armoryDistrictList = nil
        local ddata = DISTRICT_DATA[distName] or {0,'unknown'}
        local dCost, dType = ddata[1], ddata[2]
        local districtCard = findDistrictCardInCity(aTarget, distName)
        if not districtCard then
            logTo(player.color,'Could not find a built '..distName..' in '..aTarget.."'s city.")
            return
        end
        removeDistrictFromCity(aTarget, distName, dCost, dType)
        discardToBottom(districtCard)
        logTo(aTarget,'Armory destroyed your '..distName..'.')
        printToAll('💥 Armory ('..player.color..') destroyed '..aTarget.."'s "..distName..'!',{1,0.5,0.3})
        updateGoldUI()

    elseif mode == 'blackmail_real' then
        if rank == 1 then logTo(player.color,'Cannot threaten rank 1!'); showRankPicker('🖤 BLACKMAIL — REAL THREAT: Choose a different rank.','blackmail_real'); return end
        local realTarget = G.gameCast[rank]
        if not realTarget then logTo(player.color,'No character at rank '..rank..'.'); return end
        if realTarget == G.currentChar then logTo(player.color,'Cannot threaten yourself!'); showRankPicker('🖤 BLACKMAIL — REAL THREAT: Choose a different rank.','blackmail_real'); return end
        if realTarget == G.killedChar then logTo(player.color,'Cannot threaten the killed character!'); showRankPicker('🖤 BLACKMAIL — REAL THREAT: Choose a different rank.','blackmail_real'); return end
        if realTarget == G.bewitchedChar then logTo(player.color,'Cannot threaten the bewitched character!'); showRankPicker('🖤 BLACKMAIL — REAL THREAT: Choose a different rank.','blackmail_real'); return end
        G.blackmailReal = realTarget
        G.blackmailRealRank = rank
        showRankPicker('🖤 BLACKMAIL — STEP 2 of 2: Choose your FAKE bluff rank (decoy — they will NOT have to pay).', 'blackmail_fake')

    elseif mode == 'blackmail_fake' then
        if rank == 1 then logTo(player.color,'Cannot use rank 1!'); showRankPicker('🖤 BLACKMAIL — FAKE THREAT: Choose a different rank.','blackmail_fake'); return end
        local fakeTarget = G.gameCast[rank]
        if not fakeTarget then logTo(player.color,'No character at rank '..rank..'.'); return end
        if fakeTarget == G.blackmailReal then logTo(player.color,'Must be a different rank than the real threat!'); showRankPicker('🖤 BLACKMAIL — FAKE THREAT: Choose a different rank.','blackmail_fake'); return end
        if fakeTarget == G.currentChar then logTo(player.color,'Cannot threaten yourself!'); showRankPicker('🖤 BLACKMAIL — FAKE THREAT: Choose a different rank.','blackmail_fake'); return end
        if fakeTarget == G.killedChar then logTo(player.color,'Cannot threaten the killed character!'); showRankPicker('🖤 BLACKMAIL — FAKE THREAT: Choose a different rank.','blackmail_fake'); return end
        if fakeTarget == G.bewitchedChar then logTo(player.color,'Cannot threaten the bewitched character!'); showRankPicker('🖤 BLACKMAIL — FAKE THREAT: Choose a different rank.','blackmail_fake'); return end
        -- Register both threats (guard against real target being nil if it was rejected earlier)
        if not G.blackmailReal then
            logTo(player.color, 'Blackmail cancelled — real threat was not confirmed (target may have been killed or bewitched).')
            return
        end
        G.blackmailTargets[G.blackmailReal] = true
        G.blackmailTargets[fakeTarget]       = true

        -- Collect target positions (next to each character token)
        local function threatPos(charGuid)
            local tg  = charGuid and CHAR_TOKEN[charGuid]
            local tok = tg and obj(tg)
            if tok then
                local p = tok.getPosition()
                return {x=p.x+1.5, y=p.y+0.3, z=p.z}
            end
            local tp = MARKER_POS.threat or {x=16, y=3.0, z=-8}
            return {x=tp.x, y=tp.y, z=tp.z}
        end

        local realPos = threatPos(G.blackmailReal)
        local fakePos = threatPos(fakeTarget)

        -- Fisher-Yates shuffle: randomly swap which physical token goes to which position
        local threatObjs = {obj(GUID.threat1), obj(GUID.threat2)}
        local positions  = {realPos, fakePos}
        if math.random(2) == 1 then
            positions[1], positions[2] = positions[2], positions[1]
        end
        -- Track which physical token ends up on the real target so we can flip it on reveal
        -- After potential swap: threatObjs[1] goes to positions[1], threatObjs[2] to positions[2]
        -- We need to know: does threat1 land on realPos or fakePos?
        -- positions[1] is either realPos or fakePos depending on the swap.
        -- Re-derive: if we swapped, threat1→fakePos and threat2→realPos, so realToken=threat2
        -- If no swap: threat1→realPos, realToken=threat1
        -- Simpler: compare position tables
        local function samePos(a, b) return math.abs(a.x-b.x)<0.1 and math.abs(a.z-b.z)<0.1 end
        G.blackmailRealTokenGuid = samePos(positions[1], realPos) and GUID.threat1 or GUID.threat2

        -- Flip both face-down and place at shuffled positions simultaneously
        for i, tobj in ipairs(threatObjs) do
            if tobj then
                local dest  = positions[i]
                local delay = (i-1) * 0.15
                local captured = tobj
                local capDest  = dest
                Wait.time(function()
                    liftThenPlace(captured, capDest)
                    -- Apply rotation AFTER the token has finished landing (~0.7s)
                    Wait.time(function()
                        pcall(function() captured.setRotation({0, 0, 180}) end)
                    end, 0.75)
                end, delay)
            end
        end

        local realName = CHAR_NAME[G.blackmailReal] or 'rank '..G.blackmailRealRank
        local fakeName = CHAR_NAME[fakeTarget]      or 'rank '..rank
        logTo(player.color,'BLACKMAILER: Both threat tokens shuffled face-down and placed. Only you know which is real ('..realName..'). Threatened characters must pay half gold or refuse when revealed.')
        printToAll('🖤  Blackmailer ('..player.color..') has placed 2 threat tokens face-down on character ranks.',{0.7,0.4,0.9})
        -- NOTE: real/fake targets deliberately NOT logged publicly — that would spoil the bluff
        G.blackmailRealChar = G.blackmailReal   -- keep for reveal announcement
        G.blackmailReal = nil; G.blackmailRealRank = nil

    elseif mode == 'magistrate_warrant' then
        -- Step 1: choose the rank that gets the REAL (signed) warrant
        if rank == 1 then
            logTo(player.color,'Cannot warrant rank 1!')
            showRankPicker('MAGISTRATE: Place REAL warrant on which rank?','magistrate_warrant')
            return
        end
        local target = G.gameCast[rank]
        if not target then
            logTo(player.color,'No character at rank '..rank..' — cannot place the real warrant on an empty slot. Choose an occupied rank.')
            showRankPicker('MAGISTRATE: Place REAL warrant on which rank?','magistrate_warrant')
            return
        end
        if target == G.currentChar then
            logTo(player.color,'Cannot warrant yourself!')
            showRankPicker('MAGISTRATE: Place REAL warrant on which rank?','magistrate_warrant')
            return
        end
        G.magistrateColor   = player.color
        G.warrantedChar     = target
        G.warrantedRank     = rank
        G.warrantBuilds     = {}
        G.warrantBlankRanks = {}

        -- Don't place anything yet — wait until all 3 targets are chosen, then place simultaneously
        logTo(player.color, 'MAGISTRATE: Rank '..rank..' marked as real target. Now choose where to place blank warrant #1.')
        showRankPicker('MAGISTRATE: Place BLANK warrant #1 on which rank? (any rank except '..rank..')', 'magistrate_blank1')

    elseif mode == 'magistrate_blank1' then
        -- Step 2: choose first blank warrant placement
        if rank == 1 then
            logTo(player.color,'Cannot place a warrant on rank 1!')
            showRankPicker('MAGISTRATE: Place BLANK warrant #1 on which rank?', 'magistrate_blank1')
            return
        end
        if rank == G.warrantedRank then
            logTo(player.color,'Rank '..rank..' already has the real warrant! Choose a different rank.')
            showRankPicker('MAGISTRATE: Place BLANK warrant #1 on which rank?', 'magistrate_blank1')
            return
        end
        G.warrantBlankRanks = G.warrantBlankRanks or {}
        G.warrantBlankRanks[1] = rank
        logTo(player.color, 'MAGISTRATE: Blank warrant #1 on rank '..rank..'. Now choose rank for blank warrant #2.')
        showRankPicker('MAGISTRATE: Place BLANK warrant #2 on which rank? (not ranks '..G.warrantedRank..' or '..rank..')', 'magistrate_blank2')

    elseif mode == 'magistrate_blank2' then
        -- Step 3: choose second blank, then place ALL 3 simultaneously face-down in random order
        local usedRanks = {G.warrantedRank, G.warrantBlankRanks and G.warrantBlankRanks[1]}
        if rank == 1 then
            logTo(player.color,'Cannot place a warrant on rank 1!')
            showRankPicker('MAGISTRATE: Place BLANK warrant #2 on which rank?', 'magistrate_blank2')
            return
        end
        for _, ur in ipairs(usedRanks) do
            if rank == ur then
                logTo(player.color,'Rank '..rank..' already has a warrant! Choose a different rank.')
                showRankPicker('MAGISTRATE: Place BLANK warrant #2 on which rank?', 'magistrate_blank2')
                return
            end
        end
        G.warrantBlankRanks[2] = rank

        -- ── Collect the 3 target positions ─────────────────────────────
        local function tokenPos(charRank)
            local cg  = G.gameCast[charRank]
            local tg  = cg and CHAR_TOKEN[cg]
            local tok = tg and obj(tg)
            if tok then
                local p = tok.getPosition()
                return {x=p.x+1.2, y=p.y, z=p.z}
            end
            -- Fallback for unoccupied slot
            local wp = MARKER_POS.warrant or {x=12, y=3.0, z=-8}
            return {x=wp.x + charRank*1.5, y=wp.y, z=wp.z}
        end

        -- positions[i] is where the warrant for warrantAssign[i] rank should land
        local positions = {
            tokenPos(G.warrantedRank),
            tokenPos(G.warrantBlankRanks[1]),
            tokenPos(G.warrantBlankRanks[2]),
        }

        -- ── Shuffle which physical warrant object goes to which position ─
        -- warrant1 = signed, warrant2/3 = blanks; we randomise token↔position mapping
        local warrantObjs = {obj(GUID.warrant1), obj(GUID.warrant2), obj(GUID.warrant3)}

        -- Fisher-Yates shuffle of position indices
        local perm = {1, 2, 3}
        for i = 3, 2, -1 do
            local j = math.random(i)
            perm[i], perm[j] = perm[j], perm[i]
        end

        -- Flip ALL three tokens face-down, then place at shuffled positions
        for i, wo in ipairs(warrantObjs) do
            if wo then
                local dest  = positions[perm[i]]
                local delay = (i-1) * 0.15
                local captured_wo   = wo
                local captured_dest = dest
                Wait.time(function()
                    liftThenPlace(captured_wo, captured_dest)
                    -- Apply rotation AFTER the token has finished landing (~0.7s)
                    Wait.time(function()
                        pcall(function() captured_wo.setRotation({0, 0, 180}) end)
                    end, 0.75)
                end, delay)
            end
        end

        G.warrantBlankRanks = nil
        logTo(player.color, 'MAGISTRATE: All 3 warrants shuffled face-down and placed. Only you know which rank bears the signed warrant (rank '..G.warrantedRank..').')
        printToAll('📜  Magistrate ('..player.color..') has placed 3 warrant tokens face-down on character ranks.',{0.9,0.8,0.5})
        -- NOTE: signed warrant rank deliberately NOT logged publicly — that would spoil the bluff

    elseif mode == 'wizard_target' then
        local wTarget = G.targetPlayerList and G.targetPlayerList[rank]
        if not wTarget then logTo(player.color,'Invalid selection.'); return end
        -- Move only DISTRICT cards from the target player's hand to the wizard's area.
        -- Character cards (active char guids, or any card whose name is a character name)
        -- are skipped entirely so they stay in the target's hand.
        local hand = Player[wTarget] and Player[wTarget].getHandObjects() or {}
        local distHand = {}
        for _, c in ipairs(hand) do
            pcall(function()
                local cname = (c.getName() or ''):match('^%s*(.-)%s*$')
                -- Keep only if it's a known district card
                if DISTRICT_DATA[cname] then
                    table.insert(distHand, c)
                end
            end)
        end
        if #distHand == 0 then
            logTo(player.color, 'WIZARD: '..wTarget..' has no district cards in hand.')
            return
        end
        local myPos = PLAYER_POS[player.color]
        G.wizardBorrowedFrom = wTarget
        G.wizardBorrowedGuids = {}
        -- Spread cards toward the center of the table so they don't land on city
        -- areas or inside hand zones.  Use 55% of the player's seat position (toward origin).
        local isSideW  = myPos and math.abs(myPos.x) > 40
        local peekCX   = myPos and myPos.x * 0.55 or 0
        local peekCZ   = myPos and myPos.z * 0.55 or 0
        local n        = #distHand
        for i, c in ipairs(distHand) do
            table.insert(G.wizardBorrowedGuids, c.getGUID())
            if myPos then
                local offset = (i-1)*CARD_SPREAD_GAP - (n-1)*CARD_SPREAD_GAP*0.5
                local dest = isSideW
                    and {x=peekCX, y=myPos.y+1, z=peekCZ+offset}
                    or  {x=peekCX+offset, y=myPos.y+1, z=peekCZ}
                pcall(function()
                    local p = Player[wTarget]
                    if p and p.seated then p.removeHandObject(c) end
                end)
                local idx = i
                Wait.time(function()
                    pcall(function()
                        c.setPosition(dest)
                        c.setRotation({0, 0, 180})  -- face-down: only wizard peeks privately
                    end)
                end, (idx-1)*0.12)
            end
        end
        G.wizardPeeking = true
        UI.setAttribute('btnAbility2','text','✅  Done — return rest to '..wTarget)
        btn('btnAbility2', true)
        logTo(player.color, 'WIZARD: '..n..' card(s) from '..wTarget..' placed face-down near the table center. '..
            'Peek at them privately, drag your chosen card into your HAND, then press Done. '..
            'After Done you may build the chosen card for free (does not count toward build limit).')
        logTo(wTarget, 'Wizard ('..player.color..') took your district cards to look at them. They will be returned shortly.')

    elseif mode == 'spy_target' then
        -- Player index from rank buttons
        local spyTargetPlayer = G.targetPlayerList and G.targetPlayerList[rank]
        if not spyTargetPlayer then logTo(player.color,'Invalid selection.'); return end
        G.spyData = { color=player.color, target=spyTargetPlayer }
        showTypePicker('SPY: Which district type to spy on?', 'spy_rank')

    elseif mode == 'spy_rank' then
        -- Button index (1-5) maps to district type via DTYPE_LABELS
        local types = {[1]='noble',[2]='religious',[3]='trade',[4]='military',[5]='unique'}
        local dtype = types[rank]
        if not dtype then
            showTypePicker('SPY: Which district type to spy on?', 'spy_rank')
            return
        end
        local spyTarget = G.spyData and G.spyData.target
        if not spyTarget then logTo(player.color,'Spy target lost.'); return end
        hideTargetPanels()
        -- Auto-count matching district cards in target's hand using DISTRICT_DATA
        local hand = Player[spyTarget] and Player[spyTarget].getHandObjects() or {}
        local count = 0
        for _, hcard in ipairs(hand) do
            local hn = (hcard.getName() or ''):match('^%s*(.-)%s*$')
            local dd = DISTRICT_DATA[hn]
            if dd and dd[2] == dtype then count = count + 1 end
        end
        -- Execute spy effect immediately
        local goldTake = math.min(count, G.gold[spyTarget] or 0)
        if goldTake > 0 then takeGold(spyTarget, goldTake); giveGold(player.color, goldTake) end
        local deck = findDistrictDeck()
        if deck and count > 0 then deck.deal(count, player.color) end
        logTo(player.color, 'SPY: '..spyTarget.." had "..#hand.." cards; "..count.." matched "..dtype..". Took "..goldTake.."g and drew "..count.." card(s).")
        logTo(spyTarget, 'Spy ('..player.color..') found '..count..' '..dtype..' card(s) in your hand. Took '..goldTake..'g and drew '..count..' card(s).')

        -- Spread the target's hand face-up near the Spy so they can examine it.
        -- First teleport each card just outside the hand zone, then smooth-move
        -- to the final spread position so the animation looks natural.
        local spyPos = PLAYER_POS[player.color]
        local isSide = spyPos and math.abs(spyPos.x) > 40
        -- Use the same anchor as character-selection: halfway between seat and table centre
        local selX   = spyPos and spyPos.x * 0.50 or 0
        local selZ   = spyPos and spyPos.z * 0.50 or 0
        local revealed = {}
        for i, hcard in ipairs(hand) do
            local guid = hcard.getGUID()
            table.insert(revealed, guid)
            local ci = i
            local n  = #hand
            Wait.time(function()
                local c = getObjectFromGUID(guid)
                if c and spyPos then pcall(function()
                    -- Face-down so only the Spy can read them by physically picking them up
                    local rot = {0, isSide and ((spyPos.x > 0) and 270 or 90) or (spyPos.z < 0 and 180 or 0), 180}
                    c.setRotation(rot)
                    -- Step 1: instant teleport to character-selection area (clears hand zone)
                    c.setPosition({ x=selX, y=spyPos.y + 3, z=selZ })
                    -- Step 2: smooth-move to centered spread, same layout as character selection
                    local offset = (ci - (n+1)*0.5) * CARD_SPREAD_GAP
                    local dest
                    if isSide then
                        dest = { x=selX, y=spyPos.y + 0.5, z=selZ + offset }
                    else
                        dest = { x=selX + offset, y=spyPos.y + 0.5, z=selZ }
                    end
                    Wait.time(function()
                        pcall(function() c.setPositionSmooth(dest, false, false) end)
                    end, 0.05)
                end) end
            end, (i-1)*0.15)
        end
        G.spyRevealedCards = revealed
        G.spyRevealTarget  = spyTarget
        G.spyData = nil
        if #hand > 0 then
            logTo(player.color, "SPY: "..spyTarget.."'s "..#hand.." card(s) are spread near you. Cards return to them when you End Turn.")
        end

    elseif mode == 'emperor_target' then
        -- rank buttons repurposed as player index
        local empTarget = G.targetPlayerList and G.targetPlayerList[rank]
        if not empTarget then logTo(player.color,'Invalid selection.'); return end
        G.emperorTarget = empTarget
        -- Show two clearly named buttons instead of rank numbers
        G.targeting = 'emperor_resource'
        UI.setValue('txtTargetPrompt', 'EMPEROR: Take from '..empTarget..'?')
        for i = 1, 8 do
            local bid = 'btnPick'..i
            if i == 1 then
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text','💰  Take 1 Gold')
                UI.setAttribute(bid,'color','#FFD700')
                UI.setAttribute(bid,'colors','#664400|#AA8800|#332200|#664400')
            elseif i == 2 then
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text','🃏  Take 1 Card')
                UI.setAttribute(bid,'color','#88CCFF')
                UI.setAttribute(bid,'colors','#002266|#1144BB|#001144|#002266')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')
        btn('btnAbility',false); btn('btnAbility2',false)

    elseif mode == 'emperor_resource' then
        local empTarget = G.emperorTarget
        if not empTarget then return end
        G.emperorTarget = nil
        for i,c in ipairs(G.players) do
            if c == empTarget then G.crownIndex = i; break end
        end
        G.crownMovedThisRound = true
        moveCrown(empTarget); setCrownUI()
        if rank == 1 then
            local taken = math.min(1, G.gold[empTarget] or 0)
            takeGold(empTarget, taken); giveGold(player.color, taken)
            logTo(player.color,'EMPEROR: Crown to '..empTarget..'. Took '..taken..'g.')
        else
            local hand = Player[empTarget] and Player[empTarget].getHandObjects() or {}
            if #hand > 0 then
                local card   = hand[math.random(#hand)]
                local srcPos = PLAYER_POS[empTarget]
                local hp     = HAND_POS[player.color]
                if card and srcPos then
                    -- Eject from source hand zone
                    pcall(function()
                        local p = Player[empTarget]
                        if p and p.seated then p.removeHandObject(card) end
                    end)
                    -- Teleport above source seat to clear the hand zone
                    pcall(function() card.setPosition({x=srcPos.x, y=srcPos.y+4, z=srcPos.z}) end)
                    -- Fly into the Emperor's hand zone
                    Wait.time(function()
                        pcall(function()
                            if hp then
                                card.setPosition(hp)
                            end
                        end)
                    end, 0.15)
                end
            end
            logTo(player.color,'EMPEROR: Crown to '..empTarget..'. Took a random card.')
        end
        printToAll(player.color..' (Emperor) gives the crown to '..empTarget..'!',{1,0.9,0.4})

    elseif mode == 'warlord_target' then
        local wTarget = G.targetPlayerList and G.targetPlayerList[rank]
        if not wTarget then logTo(player.color,'Invalid selection.'); return end
        if wTarget == G.bishopColor then
            logTo(player.color,'Cannot target the Bishop\'s districts! Choose a different player.')
            showPlayerPicker('WARLORD: Destroy a district of which player?', 'warlord_target', true)
            return
        end
        if hasUnique and hasUnique(wTarget,'Keep') then
            logTo(player.color,wTarget.." has the Keep — their districts cannot be destroyed! Choose a different player.")
            showPlayerPicker('WARLORD: Destroy a district of which player?', 'warlord_target', true)
            return
        end
        G.destroyTarget = wTarget
        -- Show target's city as named district buttons
        local districts = {}
        for name,_ in pairs(G.cityNames[wTarget] or {}) do
            if name ~= 'Keep' and findDistrictCardInCity(wTarget, name) then
                table.insert(districts, name)
            end
        end
        table.sort(districts)
        if #districts == 0 then
            logTo(player.color, wTarget..' has no districts to destroy!')
            G.destroyTarget = nil; return
        end
        G.warlordDistrictList = districts
        G.targeting = 'warlord_district'
        local hasGreatWall = hasUnique and hasUnique(wTarget,'Great Wall')
        local gwNote = hasGreatWall and ' (+2 Great Wall)' or ''
        setTargetPlayerPanelLayout('district', #districts)
        UI.setValue('txtTargetPrompt','WARLORD: Choose a district in '..wTarget.."'s city.")
        for i=1,8 do
            local bid = 'btnPick'..i
            if i <= #districts then
                local dname = districts[i]
                local ddata = DISTRICT_DATA[dname] or {0,'unknown'}
                local baseCost = ddata[1]
                local destroyCost = math.max(0, baseCost - 1 + (hasGreatWall and 2 or 0))
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text', formatDistrictChoiceLabel(dname, 'Pay '..destroyCost..'g'))
                UI.setAttribute(bid,'color','#FF6644')
                UI.setAttribute(bid,'colors','#661100|#AA2200|#330800|#661100')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')

    elseif mode == 'warlord_district' then
        local wTarget   = G.destroyTarget
        local distList  = G.warlordDistrictList or {}
        local distName  = distList[rank]
        if not wTarget or not distName then logTo(player.color,'Invalid selection.'); return end
        G.destroyTarget = nil; G.warlordDistrictList = nil
        local ddata = DISTRICT_DATA[distName] or {0,'unknown'}
        local dCost = ddata[1]
        local hasGreatWall = hasUnique and hasUnique(wTarget,'Great Wall')
        local pay = math.max(0, dCost - 1 + (hasGreatWall and 2 or 0))
        local districtCard = findDistrictCardInCity(wTarget, distName)
        if not districtCard then
            logTo(player.color,'Could not find a built '..distName..' in '..wTarget.."'s city.")
            return
        end
        if (G.gold[player.color] or 0) < pay then
            logTo(player.color,'Not enough gold to destroy '..distName..' (need '..pay..'g, have '..(G.gold[player.color] or 0)..'g).')
            return
        end
        if pay > 0 then takeGold(player.color, pay) end
        local dType = ddata[2] or 'unknown'
        local prevWarlordVictimScore = G.cityScore[wTarget] or 0
        removeDistrictFromCity(wTarget, distName, dCost, dType)
        discardToBottom(districtCard)
        hideTargetPanels()
        logTo(player.color,'WARLORD: Paid '..pay..'g. Destroyed '..distName..' in '..wTarget.."'s city.")
        logTo(wTarget,'Warlord ('..player.color..') destroyed your '..distName..'.')
        printToAll('⚔  Warlord ('..player.color..') destroys '..distName..' in '..wTarget.."'s city!",{1,0.5,0.3})
        announceScoreChange(wTarget, (G.cityScore[wTarget] or 0) - prevWarlordVictimScore, 'Warlord destroyed '..distName)

    elseif mode == 'marshal_target' then
        local mTarget = G.targetPlayerList and G.targetPlayerList[rank]
        if not mTarget then return end
        if mTarget == G.bishopColor then
            logTo(player.color,'Cannot target the Bishop\'s districts! Choose a different player.')
            showPlayerPicker('MARSHAL: Seize a district from which player?', 'marshal_target', true)
            return
        end
        -- Cannot seize from a completed city
        if (G.citySize[mTarget] or 0) >= cityThreshold() then
            logTo(player.color, mTarget..'\'s city is complete — Marshal cannot seize from a completed city!')
            showPlayerPicker('MARSHAL: Seize a district from which player?', 'marshal_target', true)
            return
        end
        -- Build list of target's districts that cost ≤ 3, excluding Keep and districts
        -- identical to ones already in the Marshal's own city
        local myCity    = G.cityNames[player.color] or {}
        local hasGrtWall = hasUnique and hasUnique(mTarget, 'Great Wall')
        local eligible  = {}
        for name,_ in pairs(G.cityNames[mTarget] or {}) do
            local dd = DISTRICT_DATA[name]
            if dd and dd[1] <= 3 then
                -- Keep: immune to Marshal and Warlord
                if name == 'Keep' then goto continue end
                -- Cannot seize a district identical to one already in Marshal's city
                if myCity[name] then goto continue end
                table.insert(eligible, name)
            end
            ::continue::
        end
        table.sort(eligible)
        if #eligible == 0 then
            logTo(player.color, mTarget..' has no districts costing 3 or less that you can seize! Choose a different player.')
            showPlayerPicker('MARSHAL: Seize a district from which player?', 'marshal_target', true)
            return
        end
        -- Great Wall: each seized district costs +1g more
        G.greatWallActive = hasGrtWall
        G.seizeTarget = mTarget
        G.marshalDistrictList = eligible
        G.targeting = 'marshal_district'
        setTargetPlayerPanelLayout('district', #eligible)
        UI.setValue('txtTargetPrompt', 'MARSHAL: Choose a district to seize from '..mTarget.."'s city.")
        for i=1,8 do
            local bid = 'btnPick'..i
            if i <= #eligible then
                local dname = eligible[i]
                local ddata = DISTRICT_DATA[dname] or {0,'unknown'}
                local dcost = ddata[1] + (hasGrtWall and 1 or 0)
                local canAfford = (G.gold[player.color] or 0) >= dcost
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text', formatDistrictChoiceLabel(dname, 'Pay '..dcost..'g'..(canAfford and '' or ' ✗')))
                UI.setAttribute(bid,'color', canAfford and 'white' or '#888888')
                UI.setAttribute(bid,'colors', canAfford and '#1A5E20|#27AE60|#0D3B13|#1A5E20'
                                                          or '#444444|#666666|#222222|#444444')
                if not canAfford then
                    UI.setAttribute(bid,'active','false')
                end
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')

    elseif mode == 'marshal_district' then
        local mTarget   = G.seizeTarget
        local distList  = G.marshalDistrictList or {}
        local distName  = distList[rank]
        if not mTarget or not distName then logTo(player.color,'Invalid selection.'); return end
        G.seizeTarget = nil; G.marshalDistrictList = nil
        local ddata    = DISTRICT_DATA[distName] or {0,'unknown'}
        local baseCost = ddata[1]
        local cost     = baseCost + (G.greatWallActive and 1 or 0)
        G.greatWallActive = nil
        if baseCost > 3 then
            logTo(player.color, distName..' costs more than 3 — Marshal cannot seize it!')
            return
        end
        if (G.gold[player.color] or 0) < cost then
            logTo(player.color, 'Not enough gold to seize '..distName..' (need '..cost..'g, have '..(G.gold[player.color] or 0)..'g).')
            return
        end
        -- Pay the district's build cost to the target player
        if cost > 0 then takeGold(player.color, cost); giveGold(mTarget, cost) end
        -- Remove district from source city, add to Marshal's city
        local dType = ddata[2] or 'unknown'
        local prevMarshalVictimScore = G.cityScore[mTarget] or 0
        local beautifyCoinGuid = removeDistrictFromCity(mTarget, distName, cost, dType, true)
        addCityCompletion(player.color, distName)
        G.cityScore[player.color] = (G.cityScore[player.color] or 0)+cost
        G.cityNames[player.color] = G.cityNames[player.color] or {}
        G.cityNames[player.color][distName] = true
        G.buildTypes[player.color] = G.buildTypes[player.color] or {}
        G.buildTypes[player.color][dType] = (G.buildTypes[player.color][dType] or 0)+1
        G.cityTypes[player.color] = G.cityTypes[player.color] or {}
        G.cityTypes[player.color][dType] = true
        G.cityCosts[player.color] = G.cityCosts[player.color] or {}
        table.insert(G.cityCosts[player.color], cost)
        if dType=='unique' and G.uniqueBuilt then
            G.uniqueBuilt[player.color] = G.uniqueBuilt[player.color] or {}
            G.uniqueBuilt[player.color][distName] = true
        end
        if beautifyCoinGuid then
            G.cityScore[player.color] = (G.cityScore[player.color] or 0) + 1
            transferBeautifyCoin(beautifyCoinGuid, player.color, distName)
        end
        -- Museum: assigned cards follow the Museum to its new owner
        if distName == 'Museum' then transferMuseumCards(mTarget, player.color) end
        -- Move the seized district into its exact city slot so it cannot stack on
        -- top of an existing built district by accident.
        local seizedCard = findDistrictCardInCity(mTarget, distName)
        if seizedCard then moveDistrictCardToCity(player.color, distName, seizedCard) end
        hideTargetPanels()
        logTo(player.color,'MARSHAL: Paid '..cost..'g. '..distName..' seized from '..mTarget..' and added to your city.')
        logTo(mTarget,'Marshal ('..player.color..') seized your '..distName..' (cost '..cost..'g). You received '..cost..'g.')
        printToAll('🏇  Marshal ('..player.color..') seizes '..distName..' from '..mTarget..'!',{0.4,0.9,0.5})
        announceScoreChange(mTarget, (G.cityScore[mTarget] or 0) - prevMarshalVictimScore, 'Marshal seized '..distName)
        announceScoreChange(player.color, cost, 'seized '..distName..' from '..mTarget)
        checkCityCompletion(player.color)

    elseif mode == 'diplomat_target' then
        local dTarget = G.targetPlayerList and G.targetPlayerList[rank]
        if not dTarget then return end
        if dTarget == G.bishopColor then
            logTo(player.color,"Cannot target the Bishop's districts! Choose a different player.")
            showPlayerPicker('DIPLOMAT: Swap a district with which player?','diplomat_target',true)
            return
        end
        G.diplomatTarget = dTarget
        -- Show the Diplomat's own city as named buttons to pick their district
        local myDistricts = {}
        for name,_ in pairs(G.cityNames[player.color] or {}) do
            table.insert(myDistricts, name)
        end
        table.sort(myDistricts)
        if #myDistricts == 0 then
            logTo(player.color,'You have no districts in your city to swap!'); return
        end
        G.diplomatMyList = myDistricts
        G.targeting = 'diplomat_mydistrict'
        setTargetPlayerPanelLayout('district', #myDistricts)
        UI.setValue('txtTargetPrompt','DIPLOMAT: Which of YOUR districts to give away?')
        for i=1,8 do
            local bid = 'btnPick'..i
            if i <= #myDistricts then
                local dname = myDistricts[i]
                local ddata = DISTRICT_DATA[dname] or {0,'unknown'}
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text', formatDistrictChoiceLabel(dname, ddata[1]..'g'))
                UI.setAttribute(bid,'color','#DDDDDD')
                UI.setAttribute(bid,'colors','#333355|#5566AA|#222233|#333355')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')

    elseif mode == 'diplomat_mydistrict' then
        local myList = G.diplomatMyList or {}
        local myDistrict = myList[rank]
        if not myDistrict then
            logTo(player.color,'Invalid selection — pick a district from the list.')
            return
        end
        G.diplomatMyDistrict = myDistrict
        -- Show the target's city as named buttons
        local dTarget = G.diplomatTarget
        local theirDistricts = {}
        for name,_ in pairs(G.cityNames[dTarget] or {}) do
            table.insert(theirDistricts, name)
        end
        table.sort(theirDistricts)
        if #theirDistricts == 0 then
            logTo(player.color,dTarget..' has no districts to swap!'); return
        end
        G.diplomatTheirList = theirDistricts
        G.targeting = 'diplomat_theirdistrict'
        setTargetPlayerPanelLayout('district', #theirDistricts)
        UI.setValue('txtTargetPrompt','DIPLOMAT: Which of '..dTarget.."'s districts to take?")
        for i=1,8 do
            local bid = 'btnPick'..i
            if i <= #theirDistricts then
                local dname = theirDistricts[i]
                local ddata = DISTRICT_DATA[dname] or {0,'unknown'}
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text', formatDistrictChoiceLabel(dname, ddata[1]..'g'))
                UI.setAttribute(bid,'color','#DDDDDD')
                UI.setAttribute(bid,'colors','#553333|#AA5566|#332222|#553333')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')

    elseif mode == 'diplomat_theirdistrict' then
        local dTarget       = G.diplomatTarget
        local myDistrict    = G.diplomatMyDistrict
        local theirList     = G.diplomatTheirList or {}
        local theirDistrict = theirList[rank]
        if not dTarget or not myDistrict or not theirDistrict then
            logTo(player.color,'Diplomat swap data lost — please restart ability.'); return
        end
        G.diplomatTarget=nil; G.diplomatMyDistrict=nil
        G.diplomatMyList=nil; G.diplomatTheirList=nil

        local myData    = DISTRICT_DATA[myDistrict]    or {0,'unknown'}
        local theirData = DISTRICT_DATA[theirDistrict] or {0,'unknown'}
        local myCost    = myData[1];    local myType    = myData[2]
        local theirCost = theirData[1]; local theirType = theirData[2]
        local diff = math.max(0, theirCost - myCost)

        if (G.gold[player.color] or 0) < diff then
            logTo(player.color,'DIPLOMAT: Need '..diff..'g to take '..theirDistrict..' (cost '..theirCost..') for your '..myDistrict..' (cost '..myCost..'). You only have '..(G.gold[player.color] or 0)..'g.')
            return
        end

        hideTargetPanels()

        -- Pay the cost difference
        if diff > 0 then
            takeGold(player.color, diff)
            giveGold(dTarget, diff)
        end

        -- ── Update game state for both players ──────────────────────────────
        -- Remove each district from its current city but preserve any beautify marker so
        -- it can transfer with the district instead of returning to circulation.
        local myBeautifyCoin    = removeDistrictFromCity(player.color, myDistrict, myCost, myType, true)
        local theirBeautifyCoin = removeDistrictFromCity(dTarget, theirDistrict, theirCost, theirType, true)

        -- Add theirDistrict to Diplomat's city
        G.cityNames[player.color][theirDistrict] = true
        G.cityScore[player.color] = (G.cityScore[player.color] or 0) + theirCost
        addCityCompletion(player.color, theirDistrict)
        G.buildTypes[player.color][theirType] = (G.buildTypes[player.color][theirType] or 0) + 1
        G.cityTypes[player.color][theirType]  = true
        if theirType == 'unique' then
            G.uniqueBuilt = G.uniqueBuilt or {}
            G.uniqueBuilt[player.color] = G.uniqueBuilt[player.color] or {}
            G.uniqueBuilt[player.color][theirDistrict] = true
        end
        if theirBeautifyCoin then
            G.cityScore[player.color] = (G.cityScore[player.color] or 0) + 1
            transferBeautifyCoin(theirBeautifyCoin, player.color, theirDistrict)
        end
        if theirDistrict == 'Museum' then transferMuseumCards(dTarget, player.color) end
        if myDistrict    == 'Museum' then transferMuseumCards(player.color, dTarget) end

        -- Add myDistrict to target's city
        G.cityNames[dTarget][myDistrict] = true
        G.cityScore[dTarget] = (G.cityScore[dTarget] or 0) + myCost
        addCityCompletion(dTarget, myDistrict)
        G.buildTypes[dTarget][myType] = (G.buildTypes[dTarget][myType] or 0) + 1
        G.cityTypes[dTarget][myType]  = true
        if myType == 'unique' then
            G.uniqueBuilt = G.uniqueBuilt or {}
            G.uniqueBuilt[dTarget] = G.uniqueBuilt[dTarget] or {}
            G.uniqueBuilt[dTarget][myDistrict] = true
        end
        if myBeautifyCoin then
            G.cityScore[dTarget] = (G.cityScore[dTarget] or 0) + 1
            transferBeautifyCoin(myBeautifyCoin, dTarget, myDistrict)
        end

        updateGoldUI()

        -- ── Move the physical cards ──────────────────────────────────────────
        local myCard    = findDistrictCardInCity(player.color, myDistrict)
        local theirCard = findDistrictCardInCity(dTarget, theirDistrict)
        if myCard then moveDistrictCardToCity(dTarget, myDistrict, myCard) end
        if theirCard then moveDistrictCardToCity(player.color, theirDistrict, theirCard, 0.05) end

        local msg = 'DIPLOMAT: Swapped '..myDistrict..' → '..dTarget..' for '..theirDistrict
        if diff > 0 then msg = msg..' (paid '..diff..'g)' end
        logTo(player.color, msg..'.')
        logTo(dTarget, 'Diplomat ('..player.color..') swapped their '..myDistrict..' into your city and took your '..theirDistrict..'.')
        printToAll('🤝 Diplomat ('..player.color..'): '..myDistrict..' ↔ '..dTarget.."'s "..theirDistrict,{0.7,0.8,1.0})

    elseif mode == 'theater_char_target' then
        local tTarget = G.targetPlayerList and G.targetPlayerList[rank]
        if not tTarget then return end
        hideTargetPanels()
        local owner      = G.theaterOwner
        local ownerChar2 = G.chosenBy2 and G.chosenBy2[owner]
        if ownerChar2 then
            -- 2-3 player: owner has 2 characters; let them choose which to give
            G.theaterTarget  = tTarget
            G.targeting = 'theater_char_mychoice'
            UI.setValue('txtTargetPrompt','THEATER: Which of your characters to give away?')
            local c1name = CHAR_NAME[G.chosenBy[owner]] or '?'
            local c2name = CHAR_NAME[ownerChar2] or '?'
            local r1 = CHAR_RANK[G.chosenBy[owner]] or '?'
            local r2 = CHAR_RANK[ownerChar2] or '?'
            for i = 1, 8 do UI.setAttribute('btnPick'..i,'active','false') end
            UI.setAttribute('btnPick1','active','true')
            UI.setAttribute('btnPick1','text', c1name..' (rank '..r1..')')
            UI.setAttribute('btnPick1','color','white')
            UI.setAttribute('btnPick1','colors','#333355|#5566AA|#222233|#333355')
            UI.setAttribute('btnPick2','active','true')
            UI.setAttribute('btnPick2','text', c2name..' (rank '..r2..')')
            UI.setAttribute('btnPick2','color','white')
            UI.setAttribute('btnPick2','colors','#553333|#AA5566|#332222|#553333')
            UI.setAttribute('pnlTarget','active','false')
            UI.setAttribute('pnlTargetPlayer','active','true')
        else
            -- 4+ player: owner has 1 character — no choice, swap immediately
            local ownerGuid = G.chosenBy[owner]
            G.theaterOwner = nil; G.currentColor = nil
            theaterDoSwap(owner, tTarget, ownerGuid)
            Wait.time(beginTurnPhase, 0.8)
        end

    elseif mode == 'theater_char_mychoice' then
        local owner  = G.theaterOwner
        local target = G.theaterTarget
        if not owner or not target then return end
        hideTargetPanels()
        local charToGive = (rank == 1) and G.chosenBy[owner] or (G.chosenBy2 and G.chosenBy2[owner])
        G.theaterOwner = nil; G.theaterTarget = nil; G.currentColor = nil
        theaterDoSwap(owner, target, charToGive)
        Wait.time(beginTurnPhase, 0.8)

    elseif mode == 'magician_swap' then
        local swapTarget = G.targetPlayerList and G.targetPlayerList[rank]
        if not swapTarget then return end
        G.abilityUsed = true
        G.magicianSwapPending = true

        -- Snapshot both hands BEFORE moving anything, filtering out character cards.
        -- Build a set of all character GUIDs so we can skip them during the swap.
        local charGuidSet = {}
        for rank = 1, 9 do
            if G.gameCast and G.gameCast[rank] then charGuidSet[G.gameCast[rank]] = true end
        end
        local function isDistrictCard(obj)
            if charGuidSet[obj.getGUID()] then return false end  -- skip character cards
            local n = obj.getName()
            return DISTRICT_DATA[n] ~= nil or DISTRICT_DATA[(n or ''):match('^%s*(.-)%s*$')] ~= nil
        end

        local myCards, theirCards = {}, {}
        local ok1, mh = pcall(function() return Player[player.color].getHandObjects() end)
        local ok2, th = pcall(function() return Player[swapTarget].getHandObjects() end)
        if ok1 and mh then
            for _,c in ipairs(mh) do
                if isDistrictCard(c) then table.insert(myCards, c) end
            end
        end
        if ok2 and th then
            for _,c in ipairs(th) do
                if isDistrictCard(c) then table.insert(theirCards, c) end
            end
        end

        -- Move cards using direct setPosition (smooth movement doesn't work on hand objects).
        -- Place cards near the player's area but well inside the table surface.
        -- Clamp x to ±20 and push z toward center so nothing ends up in a hand zone.
        local function tableDropPos(color, i)
            local p = PLAYER_POS[color]
            if not p then return nil end
            local zDir = (p.z >= 0) and -1 or 1
            local xDir = (p.x >= 0) and -1 or 1
            -- Use a modest x offset from center, not the full seat x value
            local baseX = math.max(-20, math.min(20, p.x)) + xDir*(i-1)*2.5
            local baseZ = p.z + zDir*10
            return {x = baseX, y = p.y + 1.5, z = baseZ}
        end

        -- Step 1: eject cards from hand zones onto the table so both sides can briefly see the count
        for i, card in ipairs(myCards) do
            local dest = tableDropPos(swapTarget, i)
            if dest then pcall(function()
                card.setPosition(dest)
                card.setRotation({0, card.getRotation().y, 180})
            end) end
        end
        for i, card in ipairs(theirCards) do
            local dest = tableDropPos(player.color, i)
            if dest then pcall(function()
                card.setPosition(dest)
                card.setRotation({0, card.getRotation().y, 180})
            end) end
        end

        -- Step 2: after a short pause deal them into the receiving player's hand zone
        local magColor   = player.color
        local tgtColor   = swapTarget
        local mySnap     = myCards
        local theirSnap  = theirCards
        local swapSettleDelay = 1.5 + math.max(#mySnap, #theirSnap) * 0.12 + 0.25
        Wait.time(function()
            -- Magician's cards → swap target's hand
            local hp1   = HAND_POS[tgtColor]
            local faceZ1 = (G.bots and G.bots[tgtColor]) and 0 or 180
            for i, card in ipairs(mySnap) do
                local ci, c = i, card
                Wait.time(function()
                    pcall(function()
                        if hp1 then
                            c.setRotation({0, 0, faceZ1})
                            c.setPosition({x=hp1.x, y=hp1.y+4, z=hp1.z})
                            Wait.time(function() pcall(function() c.setPosition(hp1) end) end, 0.1)
                        end
                    end)
                end, (ci-1)*0.12)
            end
            -- Target's cards → Magician's hand
            local hp2   = HAND_POS[magColor]
            local faceZ2 = (G.bots and G.bots[magColor]) and 0 or 180
            for i, card in ipairs(theirSnap) do
                local ci, c = i, card
                Wait.time(function()
                    pcall(function()
                        if hp2 then
                            c.setRotation({0, 0, faceZ2})
                            c.setPosition({x=hp2.x, y=hp2.y+4, z=hp2.z})
                            Wait.time(function() pcall(function() c.setPosition(hp2) end) end, 0.1)
                        end
                    end)
                end, (ci-1)*0.12)
            end
        end, 1.5)
        Wait.time(function()
            G.magicianSwapPending = false
            if magColor == G.currentColor then
                scheduleAutoEndTurnCheck(magColor, 0.15)
            end
        end, swapSettleDelay)

        G.mustDiscard = 0
        G.mustDiscardShuffle = false
        logTo(player.color,'MAGICIAN: Swapped hands with '..swapTarget..
              '. ('..#myCards..' sent, '..#theirCards..' received.) Cards will be dealt to each player\'s hand.')
        logTo(swapTarget,'Magician ('..player.color..') swapped hands with you! Their cards will be dealt to your hand shortly.')

    elseif mode == 'cardinal_target' then
        local cTarget = G.targetPlayerList and G.targetPlayerList[rank]
        if not cTarget then return end
        local pb = G.cardinalPendingBuild
        if not pb then
            logTo(player.color,'CARDINAL: No pending build to borrow for.'); return
        end
        local shortfall  = pb.shortfall
        local targetGold = G.gold[cTarget] or 0
        -- Cannot take more than needed; cannot take more than target has
        local borrow = math.min(shortfall, targetGold)
        if borrow < shortfall then
            logTo(player.color,'CARDINAL: '..cTarget..' only has '..targetGold..'g — not enough to cover the '..shortfall..'g shortfall. Choose a different player.')
            showPlayerPicker('CARDINAL: Borrow '..shortfall..'g from which player?', 'cardinal_target', true)
            return
        end
        -- Build list of district cards currently in Cardinal's hand
        local districtCardsInHand = {}
        local hand = Player[player.color] and Player[player.color].getHandObjects() or {}
        for _, hcard in ipairs(hand) do
            local hn = (hcard.getName() or ''):match('^%s*(.-)%s*$')
            if DISTRICT_DATA[hn] then
                table.insert(districtCardsInHand, {name=hn, guid=hcard.getGUID()})
            end
        end
        if #districtCardsInHand < borrow then
            logTo(player.color,'CARDINAL: Not enough district cards in hand ('..#districtCardsInHand..' available, need '..borrow..').')
            G.cardinalPendingBuild = nil
            return
        end
        -- Store state and show card picker for first card to give
        G.cardinalCardTarget  = cTarget
        G.cardinalCardsNeeded = borrow
        G.cardinalCardPicks   = {}   -- GUIDs of cards chosen so far
        G.cardinalHandCards   = districtCardsInHand
        -- Show card pick panel
        local remaining = borrow
        UI.setValue('txtTargetPrompt', 'CARDINAL: Choose card 1 of '..borrow..' to give to '..cTarget..' (you borrow '..borrow..'g):')
        for i = 1, 8 do
            local bid = 'btnPick'..i
            if i <= #districtCardsInHand then
                local entry = districtCardsInHand[i]
                local dd    = DISTRICT_DATA[entry.name] or {0,'unknown'}
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text', entry.name..' ('..dd[2]..', '..dd[1]..'g)')
                UI.setAttribute(bid,'color','white')
                UI.setAttribute(bid,'colors','#1A5276|#2E86C1|#154360|#1A5276')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        G.targeting = 'cardinal_card_pick'
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')

    elseif mode == 'cardinal_card_pick' then
        -- rank = btnPick index of chosen card
        local handCards = G.cardinalHandCards or {}
        local entry     = handCards[rank]
        if not entry then logTo(player.color,'Invalid selection.'); return end
        -- Check not already picked
        for _, g in ipairs(G.cardinalCardPicks) do
            if g == entry.guid then
                logTo(player.color,'Already picked that card — choose a different one.'); return
            end
        end
        table.insert(G.cardinalCardPicks, entry.guid)
        local picked  = #G.cardinalCardPicks
        local needed  = G.cardinalCardsNeeded
        local cTarget = G.cardinalCardTarget
        local pb      = G.cardinalPendingBuild
        if picked < needed then
            -- Need more cards — rebuild picker without already-chosen cards
            local remaining = {}
            for _, e in ipairs(handCards) do
                local alreadyPicked = false
                for _, g in ipairs(G.cardinalCardPicks) do if g == e.guid then alreadyPicked = true; break end end
                if not alreadyPicked then table.insert(remaining, e) end
            end
            G.cardinalHandCards = remaining  -- update list for next pick
            UI.setValue('txtTargetPrompt', 'CARDINAL: Choose card '..(picked+1)..' of '..needed..' to give to '..cTarget..':')
            for i = 1, 8 do
                local bid = 'btnPick'..i
                if i <= #remaining then
                    local e  = remaining[i]
                    local dd = DISTRICT_DATA[e.name] or {0,'unknown'}
                    UI.setAttribute(bid,'active','true')
                    UI.setAttribute(bid,'text', e.name..' ('..dd[2]..', '..dd[1]..'g)')
                    UI.setAttribute(bid,'color','white')
                    UI.setAttribute(bid,'colors','#1A5276|#2E86C1|#154360|#1A5276')
                else
                    UI.setAttribute(bid,'active','false')
                end
            end
            -- hideTargetPanels() (called at the top of handleRankPick) hid the panel
            -- and cleared G.targeting — restore both so the next pick works.
            G.targeting = 'cardinal_card_pick'
            UI.setAttribute('pnlTargetPlayer','active','true')
        else
            -- All cards chosen — execute transfer
            hideTargetPanels()
            G.targeting = nil
            -- Transfer: target pays `needed` gold directly to the bank (bowl).
            -- Cardinal pays only the remainder from their own stash.
            -- We never give gold TO the Cardinal — that would fly coins into their
            -- stash only to immediately take them back out again.
            takeGold(cTarget, needed)
            local cardinalPays = math.max(0, pb.cost - needed)
            if cardinalPays > 0 then takeGold(player.color, cardinalPays) end
            -- Move chosen cards directly into the target's hand zone
            local theirHand = HAND_POS[cTarget]
            local faceZC = (G.bots and G.bots[cTarget]) and 0 or 180
            for i, guid in ipairs(G.cardinalCardPicks) do
                local ci, cardObj = i, getObjectFromGUID(guid)
                if cardObj and theirHand then
                    Wait.time(function()
                        pcall(function()
                            cardObj.setRotation({0, 0, faceZC})
                            cardObj.setPosition({x=theirHand.x, y=theirHand.y+4, z=theirHand.z})
                            Wait.time(function()
                                pcall(function() cardObj.setPosition(theirHand) end)
                            end, 0.1)
                        end)
                    end, (ci-1)*0.15)
                end
            end
            logTo(player.color,'CARDINAL: Borrowed '..needed..'g from '..cTarget..'. Gave them '..needed..' card(s). Building '..pb.distName..'.')
            logTo(cTarget,'Cardinal ('..player.color..') borrowed '..needed..'g and gave you '..needed..' district card(s).')

            -- ── Execute the build INLINE ─────────────────────────────────────────
            -- We NEVER call onDistrictBuilt here because the district card is still
            -- physically on the table and would re-trigger onObjectDrop → build limit.
            -- Instead: lock the card by GUID, do every state update directly, then
            -- move the card to the city so it can never be dropped again.
            local color    = player.color
            local cost     = pb.cost
            local dtype    = pb.dtype
            local distName = pb.distName
            local droppedGuid = pb.droppedGuid

            -- Lock this GUID so onObjectDrop ignores it forever
            G.cardinalBuiltGuids = G.cardinalBuiltGuids or {}
            if droppedGuid then G.cardinalBuiltGuids[droppedGuid] = true end

            -- Count toward build limit (Cardinal's borrow can only build 1 district)
            G.buildCount = (G.buildCount or 0) + 1

            -- Payment was already split above (target paid `needed`, Cardinal paid remainder).
            -- No takeGold here.

            -- Property tax
            chargeTax(color)

            -- City state updates
            addCityCompletion(color, distName)
            G.cityScore[color] = (G.cityScore[color] or 0) + cost
            G.cityTypes[color] = G.cityTypes[color] or {}
            G.cityTypes[color][dtype] = true
            G.cityNames[color] = G.cityNames[color] or {}
            if distName and distName ~= '' then
                G.cityNames[color][distName] = true
            end
            G.buildTypes[color] = G.buildTypes[color] or {}
            G.buildTypes[color][dtype] = (G.buildTypes[color][dtype] or 0) + 1
            G.cityCosts[color] = G.cityCosts[color] or {}
            table.insert(G.cityCosts[color], cost)

            -- Unique district effects
            if dtype == 'unique' and distName ~= '' then
                onUniqueDistrictBuilt(color, distName, cost)
            end

            -- On-build passives (Treasury, Poor House, etc.)
            applyOnBuildPassives(color, cost, dtype)

            updateGoldUI()
            checkCityCompletion(color)
            debugLog(color..' (Cardinal borrow) built '..distName..' (cost '..cost..'g). City: '..G.citySize[color]..'/'..cityThreshold())

            -- Move the district card after the state update so it lands in the next
            -- visible city slot instead of stacking on Stables/Monument layouts.
            local cardObj = droppedGuid and getObjectFromGUID(droppedGuid)
            if cardObj then
                Wait.time(function()
                    moveDistrictCardToCity(color, distName, cardObj)
                end, 0.4)
            end

            -- Clean up all Cardinal borrow state
            G.cardinalPendingBuild = nil
            G.cardinalCardTarget   = nil
            G.cardinalCardsNeeded  = nil
            G.cardinalCardPicks    = nil
            G.cardinalHandCards    = nil
            G.cardinalBuildResuming = false

            logTo(color, 'Resources gathered. Use ability, build, then End Turn.')
            setStatus(color.."'s turn (Cardinal). District built via borrow. Build another or End Turn.")
        end

    elseif mode == 'abbot_income' then
        -- rank here = btnPick index (1-based); gold = index-1, cards = total-(index-1)
        local total = G.abbotTotal or countDistrictType(player.color,'religious')
        local gold  = rank - 1
        local cards = total - gold
        G.abbotTotal = nil
        if gold < 0 then gold = 0 end
        if cards < 0 then cards = 0 end
        hideTargetPanels()
        if gold > 0 then giveGold(player.color, gold) end
        if cards > 0 then
            local deck = findDistrictDeck()
            if deck then deck.deal(cards, player.color) end
        end
        logTo(player.color,'ABBOT: Gained '..gold..'g and '..cards..' card(s) from religious districts.')
        refreshCharacterAbilityButtons(player.color)
        scheduleAutoEndTurnCheck(player.color, 0.1)

    elseif mode == 'artist_beautify' then
        local pickList = G.artistPickList or {}
        local distName = pickList[rank]
        if not distName then logTo(player.color,'Invalid selection.'); return end
        G.artistPickList = nil
        -- Deduct gold
        if (G.gold[player.color] or 0) < 1 then
            logTo(player.color,'ARTIST: No longer enough gold!'); return
        end
        -- Decrement gold count directly (don't return coin to bowl — it goes on the card)
        G.gold[player.color] = (G.gold[player.color] or 0) - 1
        updateGoldUI()
        -- Find the district card in the player's city and place the coin on top of it
        local pp = PLAYER_POS[player.color]
        local distCard = nil
        if pp then
            local bestDist = math.huge
            for _, o in ipairs(getAllObjects()) do
                pcall(function()
                    if o.getName() == distName then
                        local op = o.getPosition()
                        local d = math.sqrt((op.x-pp.x)^2+(op.z-pp.z)^2)
                        if d < 30 and d < bestDist then
                            distCard = o; bestDist = d
                        end
                    end
                end)
            end
        end
        -- Find a gold coin near the player and move it onto the district card.
        -- Mark it in G.lockedCoins before moving so onObjectDrop does not re-credit it.
        -- Also skip any coin already used as a beautify token this turn.
        if distCard and pp then
            local cardPos = distCard.getPosition()
            local coinMoved = false
            local beautifyCoinObj = nil
            G.artistUsedCoins = G.artistUsedCoins or {}
            for _, o in ipairs(getAllObjects()) do
                if coinMoved then break end
                pcall(function()
                    if o.getName() == 'Gold' and not G.artistUsedCoins[o.getGUID()] then
                        local op = o.getPosition()
                        local d = math.sqrt((op.x-pp.x)^2+(op.z-pp.z)^2)
                        if d < 15 then
                            G.artistUsedCoins[o.getGUID()] = true  -- mark as consumed by beautify
                            registerBeautifyCoin(player.color, distName, o)
                            o.setPositionSmooth({x=cardPos.x+(math.random()-0.5)*0.3,
                                                 y=cardPos.y+0.5,
                                                 z=cardPos.z+(math.random()-0.5)*0.3})
                            beautifyCoinObj = o
                            coinMoved = true
                        end
                    end
                end)
            end
            -- Fallback: if no coin found near player, take one from the bowl
            if not coinMoved then
                local bp = bowlPos()
                for _, o in ipairs(getAllObjects()) do
                    if coinMoved then break end
                    pcall(function()
                        if o.getName() == 'Gold' then
                            local op = o.getPosition()
                            local d = math.sqrt((op.x-bp.x)^2+(op.z-bp.z)^2)
                            if d < 15 then
                                registerBeautifyCoin(player.color, distName, o)
                                o.setPositionSmooth({x=cardPos.x+(math.random()-0.5)*0.3,
                                                     y=cardPos.y+0.5,
                                                     z=cardPos.z+(math.random()-0.5)*0.3})
                                beautifyCoinObj = o
                                coinMoved = true
                            end
                        end
                    end)
                end
            end
            if beautifyCoinObj then
                syncBeautifyCoin(player.color, distName, 0.2)
            end
        else
            -- Card not found on table — fall back to just returning to bowl
            if pp then returnToBowl({x=pp.x, y=pp.y, z=pp.z-4}, 1) end
        end
        -- Register beautification
        G.beautified = G.beautified or {}
        G.beautified[player.color] = G.beautified[player.color] or {}
        G.beautified[player.color][distName] = true
        G.artistBeautifyCount = (G.artistBeautifyCount or 0) + 1
        -- Add +1 to cityScore immediately (it increases both effective cost and points)
        G.cityScore[player.color] = (G.cityScore[player.color] or 0) + 1
        local remaining = 2 - G.artistBeautifyCount
        logTo(player.color,'ARTIST: Beautified '..distName..' (+1 pt). '..remaining..' beautify action(s) remaining this turn.')
        printToAll('🎨 '..player.color..' (Artist) beautified '..distName..'!',{1,0.9,0.5})
        announceScoreChange(player.color, 1, 'beautified '..distName)
        hideTargetPanels()
        -- Re-enable ability buttons if under limit
        if G.artistBeautifyCount < 2 then
            local labels   = ABILITY_LABEL[G.currentChar]
            local tooltips = ABILITY_TOOLTIP[G.currentChar]
            if labels and labels[1] ~= '' then
                UI.setAttribute('btnAbility','text','✨  '..labels[1])
                btn('btnAbility',true)
                if tooltips and tooltips[1] ~= '' then
                    UI.setAttribute('btnAbility','tooltip',tooltips[1])
                end
            end
        end

    elseif mode == 'museum_pick' then
        local handList = G.museumHandList or {}
        local chosen   = handList[rank]
        if not chosen then logTo(player.color,'Invalid selection.'); return end
        G.museumHandList = nil
        hideTargetPanels()
        G.museumUsed = true
        G.museumCards = G.museumCards or {}
        G.museumCards[player.color] = G.museumCards[player.color] or {}
        table.insert(G.museumCards[player.color], chosen.guid)
        local cardObj = obj(chosen.guid)
        if cardObj then
            pcall(function()
                local p = Player[player.color]
                if p and p.seated then p.removeHandObject(cardObj) end
                -- Park card near the Museum temporarily; stackMuseumCards will arrange it
                local pp = PLAYER_POS[player.color]
                if pp then cardObj.setPosition({x=pp.x, y=pp.y+2, z=pp.z+6}) end
            end)
        end
        local total = #G.museumCards[player.color]
        logTo(player.color, 'MUSEUM: Tucked '..chosen.name..'. ('..total..' card(s) assigned — +'..total..' pts at game end.)')
        printToAll('🏛  '..player.color..' (Museum) tucked a card!',{0.7,0.9,1.0})
        refreshUniqueAbilityButton(player.color)
        -- Restore character ability buttons that were hidden when the picker opened
        if not G.abilityUsed then
            local labels   = ABILITY_LABEL[G.currentChar]
            local tooltips = ABILITY_TOOLTIP[G.currentChar]
            if labels and labels[1] and labels[1] ~= '' then
                UI.setAttribute('btnAbility','text','✨  '..labels[1])
                if tooltips and tooltips[1] ~= '' then UI.setAttribute('btnAbility','tooltip',tooltips[1]) end
                btn('btnAbility', true)
            end
            if labels and labels[2] and labels[2] ~= '' then
                UI.setAttribute('btnAbility2','text','✨  '..labels[2])
                if tooltips and tooltips[2] ~= '' then UI.setAttribute('btnAbility2','tooltip',tooltips[2]) end
                btn('btnAbility2', true)
            end
        end
        -- Lift Museum, stack tucked cards beneath it, lower Museum back on top
        stackMuseumCards(player.color, 0.5)

    elseif mode == 'thieves_pick_card' then
        local available     = G.thievesDenHandList or {}
        G.thievesDenSelectedCards = G.thievesDenSelectedCards or {}
        local selectedCount = #G.thievesDenSelectedCards
        local gap           = G.thievesDenGoldGap or 0
        local remaining     = math.max(0, gap - selectedCount)

        -- When enough cards are selected the first button is "Confirm / Build now"
        if remaining <= 0 and rank == 1 then
            confirmThievesDenBuild()
            return
        end

        -- Adjust index when Confirm button occupies slot 1
        local cardIdx = (remaining <= 0) and (rank - 1) or rank
        local chosen  = available[cardIdx]
        if not chosen then
            logTo(player.color, "THIEVES' DEN: Invalid selection.")
            return
        end

        -- Add chosen card to the discard selection
        table.insert(G.thievesDenSelectedCards, chosen)
        logTo(player.color, "THIEVES' DEN: Selected '"..chosen.name.."' for discard. "
              ..(#G.thievesDenSelectedCards)..'/'..gap..' cards chosen.')

        -- If we now have exactly enough, auto-confirm; otherwise refresh picker
        local newRemaining = math.max(0, gap - #G.thievesDenSelectedCards)
        if newRemaining <= 0 and #available <= 1 then
            -- No more choices needed and no more cards — confirm immediately
            confirmThievesDenBuild()
        else
            showThievesDenPicker()
        end
    end
end

-- Wire up the 9 rank buttons
function onTargetRank_1(p) handleRankPick(p,1) end
function onTargetRank_2(p) handleRankPick(p,2) end
function onTargetRank_3(p) handleRankPick(p,3) end
function onTargetRank_4(p) handleRankPick(p,4) end
function onTargetRank_5(p) handleRankPick(p,5) end
function onTargetRank_6(p) handleRankPick(p,6) end
function onTargetRank_7(p) handleRankPick(p,7) end
function onTargetRank_8(p) handleRankPick(p,8) end
function onTargetRank_9(p) handleRankPick(p,9) end
-- Player picker buttons (shown in pnlTargetPlayer, each maps to G.targetPlayerList[i])
function onBtnPick_1(p) handleRankPick(p,1) end
function onBtnPick_2(p) handleRankPick(p,2) end
function onBtnPick_3(p) handleRankPick(p,3) end
function onBtnPick_4(p) handleRankPick(p,4) end
function onBtnPick_5(p) handleRankPick(p,5) end
function onBtnPick_6(p) handleRankPick(p,6) end
function onBtnPick_7(p) handleRankPick(p,7) end
function onBtnPick_8(p) handleRankPick(p,8) end
function onBtnPick_9(p) handleRankPick(p,9) end

-- ------------------------------------------------------------
--  BLACKMAILER REVEAL HELPERS
--  Called after a threatened player refuses to pay.
--  Blackmailer chooses to flip the marker (!flip) or pass (!pass).
-- ------------------------------------------------------------
local function blackmailerReveal(revealerColor)
    local pending = G.blackmailRefusalPending
    if not pending then return end
    G.blackmailRefusalPending = nil
    local targetColor = pending.color
    local targetGuid  = pending.charGuid
    -- Determine which physical token is on the refusing player's character
    local isReal = (targetGuid == G.blackmailRealChar)
    local myTokenGuid
    if isReal then
        myTokenGuid = G.blackmailRealTokenGuid
    else
        myTokenGuid = (G.blackmailRealTokenGuid == GUID.threat1) and GUID.threat2 or GUID.threat1
    end
    local tok = obj(myTokenGuid)
    if tok then pcall(function() tok.setRotation({0, 0, 0}) end) end  -- flip face-up
    if isReal then
        -- Real target refused → Blackmailer takes ALL their gold
        local allGold = G.gold[targetColor] or 0
        if allGold > 0 then
            takeGold(targetColor, allGold)
            giveGold(revealerColor, allGold)
        end
        printToAll('🖤  Flowered lace revealed! '..revealerColor..' takes ALL '..allGold..'g from '..targetColor..'!',{1,0.4,0.1})
        logTo(targetColor, 'BLACKMAIL: Your marker was real. '..revealerColor..' takes all '..allGold..'g.')
    else
        -- Fake target refused → nothing, bluff exposed
        printToAll('🖤  Blank marker! '..targetColor..' was not the real target — the bluff is exposed.',{0.7,0.7,0.7})
        logTo(revealerColor, 'BLACKMAIL: '..targetColor..' was your fake target. No gold taken.')
    end
    updateGoldUI()
end

local function blackmailerPass()
    local pending = G.blackmailRefusalPending
    if not pending then return end
    G.blackmailRefusalPending = nil
    printToAll('🖤  Blackmailer chooses not to reveal '..pending.color.."'s marker.",{0.6,0.6,0.6})
end

function onBtnAbility(player)
    if G.phase ~= 'TURN' then return end
    if player.color ~= G.currentColor then logTo(player.color,'Not your turn!'); return end

    local guid = G.currentChar
    if not guid then return end

    -- ── Blackmail resolution (Pay) — checked FIRST so it overrides any character ability ──
    if G.blackmailPending and G.blackmailPending == G.currentChar then
        if G.blackmailNeedsGather then
            logTo(player.color,'You must gather resources FIRST before resolving the blackmail threat!'); return
        end
        if G.blackmailResolved then logTo(player.color,'Already resolved!'); return end
        G.blackmailResolved = true
        -- A player with only 1 gold bribes for 0 gold (half of 1 rounded down = 0)
        local half = math.floor((G.gold[player.color] or 0) / 2)
        if half > 0 then
            takeGold(player.color, half)
            giveGold(G.blackmailerColor, half)
        end
        G.blackmailPending = nil
        -- Physically remove this player's threat marker face-down (identity stays secret)
        local isReal = (G.currentChar == G.blackmailRealChar)
        local myTokGuid = isReal and G.blackmailRealTokenGuid
            or ((G.blackmailRealTokenGuid == GUID.threat1) and GUID.threat2 or GUID.threat1)
        local myTok = obj(myTokGuid)
        if myTok then
            pcall(function()
                myTok.setRotation({0, 0, 180})   -- keep face-down
                liftThenPlace(myTok, {x=DISCARD_DOWN_POS.x+(math.random()-0.5), y=DISCARD_DOWN_POS.y, z=DISCARD_DOWN_POS.z+2})
            end)
        end
        -- Restore normal ability buttons
        local labels   = ABILITY_LABEL[G.currentChar]
        local tooltips = ABILITY_TOOLTIP[G.currentChar]
        btn('btnAbility', false); btn('btnAbility2', false)
        if labels and labels[1] ~= '' then
            UI.setAttribute('btnAbility','text','✨  '..labels[1])
            if tooltips and tooltips[1] ~= '' then UI.setAttribute('btnAbility','tooltip',tooltips[1]) end
            btn('btnAbility', true)
        end
        if labels and labels[2] and labels[2] ~= '' then
            UI.setAttribute('btnAbility2','text','✨  '..labels[2])
            if tooltips and tooltips[2] ~= '' then UI.setAttribute('btnAbility2','tooltip',tooltips[2]) end
            btn('btnAbility2', true)
        end
        local bribeMsg = half > 0 and (half..'g') or '0g (1 gold rounds to 0)'
        logTo(player.color,'BLACKMAIL: Bribed with '..bribeMsg..'. Threat marker removed — your identity is safe.')
        logTo(G.blackmailerColor,'BLACKMAIL: '..player.color..' bribed ('..half..'g). Marker removed face-down.')
        scheduleAutoEndTurnCheck(player.color, 0.2)
        return
    end

    -- ── Rank 1 ──
    if guid == GUID.assassin then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        showRankPicker('ASSASSIN: Kill which rank?', 'kill')

    elseif guid == GUID.witch then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        showRankPicker('WITCH: Bewitch which rank?', 'bewitch')

    elseif guid == GUID.magistrate then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        showRankPicker('MAGISTRATE: Place REAL warrant on which rank?', 'magistrate_warrant')

    -- ── Rank 2 ──
    elseif guid == GUID.thief then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        showRankPicker('THIEF: Rob which rank? (taken when revealed)', 'rob')

    elseif guid == GUID.spy then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        G.spyData = { color=player.color }
        showPlayerPicker('SPY: Spy on which player?', 'spy_target', true)

    elseif guid == GUID.blackmailer then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        G.blackmailerColor = player.color
        G.blackmailTargets = {}
        logTo(player.color,
            'BLACKMAILER — 2 steps:\n'..
            '  STEP 1: Choose the REAL target (that player must pay half their gold or be exposed).\n'..
            '  STEP 2: Choose the FAKE bluff target (a decoy — they will NOT pay anything).\n'..
            'Both tokens are placed face-down in a random order so only you know which is real.')
        showRankPicker('🖤 BLACKMAIL — STEP 1 of 2: Choose your REAL target rank.', 'blackmail_real')

    -- ── Rank 3 ──
    elseif guid == GUID.magician then
        if G.abilityUsed then logTo(player.color,'Ability already used this turn!'); return end
        showPlayerPicker('MAGICIAN: Swap hands with which player?', 'magician_swap', true)

    elseif guid == GUID.wizard then
        if G.abilityUsed then logTo(player.color,'Ability already used this turn!'); return end
        G.abilityUsed = true
        G.wizardFreeBuilds = 1
        showPlayerPicker('WIZARD: Look at whose hand?', 'wizard_target', true)

    elseif guid == GUID.seer then
        if G.abilityUsed then logTo(player.color,'Already used Seer ability!'); return end
        G.abilityUsed = true
        G.seerReturnTargets = {}
        -- Take 1 random card from each other player.
        -- Cards are in hand zones and cannot be moved directly — we teleport each card
        -- to a safe escape position (50% of the source player's seat position, which is
        -- the character-selection area and is outside all hand zones), then smooth-move
        -- it to the Seer's area.
        local destPos = PLAYER_POS[player.color]
        local cardIdx = 0
        for _, c in ipairs(G.players) do
            if c ~= player.color then
                local hand = Player[c] and Player[c].getHandObjects() or {}
                -- Filter to district cards only
                local distCards = {}
                for _, hc in ipairs(hand) do
                    pcall(function()
                        local n = (hc.getName() or ''):match('^%s*(.-)%s*$')
                        if DISTRICT_DATA[n] then table.insert(distCards, hc) end
                    end)
                end
                if #distCards > 0 then
                    local card = distCards[math.random(#distCards)]
                    local guid = card.getGUID()
                    local srcPos = PLAYER_POS[c]
                    G.seerReturnTargets[c] = true
                    cardIdx = cardIdx + 1
                    local ci = cardIdx
                    if srcPos and destPos then
                        local escX = srcPos.x * 0.5  -- halfway to table centre = outside hand zone
                        local escZ = srcPos.z * 0.5
                        Wait.time(function()
                            local freshCard = getObjectFromGUID(guid)
                            if freshCard then pcall(function()
                                -- Step 1: teleport above the escape position (clear of hand zone)
                                freshCard.setRotation({0, 0, 180})  -- face-down for the Seer
                                freshCard.setPosition({x=escX, y=srcPos.y + 4, z=escZ})
                                -- Step 2: smooth-move to a spread toward the TABLE CENTRE
                                -- (pushing toward centre keeps cards out of the Seer's hand zone)
                                Wait.time(function()
                                    pcall(function()
                                        local spread = (ci - 1) * CARD_SPREAD_GAP
                                        local isSide = math.abs(destPos.x) > 40
                                        local dest
                                        if isSide then
                                            -- Side seat: push x toward centre
                                            local xDir = destPos.x > 0 and -10 or 10
                                            dest = {x=destPos.x+xDir, y=destPos.y+0.5, z=destPos.z-4+spread}
                                        else
                                            -- Top/bottom seat: push z toward centre
                                            local zDir = destPos.z >= 0 and -10 or 10
                                            dest = {x=destPos.x-4+spread, y=destPos.y+0.5, z=destPos.z+zDir}
                                        end
                                        freshCard.setPositionSmooth(dest, false, false)
                                    end)
                                end, 0.15)
                            end) end
                        end, (ci-1)*0.25)
                    end
                    logTo(c, 'Seer ('..player.color..') took a random card from your hand.')
                end
            end
        end
        G.seerMustReturn = seerRemainingReturns()  -- must give 1 card back to each player taken from
        logTo(player.color, 'SEER: Took '..cardIdx..' card(s). Drag 1 card to each other player\'s area to return it. ('..cardIdx..' return(s) required before you can End Turn.) Build limit is 2.')
        G.buildLimit = 2

    -- ── Rank 4 ──
    elseif guid == GUID.king then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local income = countDistrictType(player.color,'noble')
        if income > 0 then giveGold(player.color, income) end
        -- Pass crown
        for i,c in ipairs(G.players) do
            if c == player.color then G.crownIndex = i; break end
        end
        G.crownMovedThisRound = true
        moveCrown(player.color); setCrownUI()
        if income > 0 then
            logTo(player.color, 'KING: Took the crown. Gained '..income..'g from noble districts.')
        else
            logTo(player.color, 'KING: Took the crown. No noble districts in your city yet, so no income this time.')
        end
        printToAll(player.color..' (King) takes the crown!',{1,0.9,0.4})

    elseif guid == GUID.emperor then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local income = countDistrictType(player.color,'noble')
        if income > 0 then giveGold(player.color, income) end
        logTo(player.color, 'EMPEROR: Gained '..income..'g from noble districts.')
        showPlayerPicker('EMPEROR: Give crown to which player?', 'emperor_target', true)

    elseif guid == GUID.patrician then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local deck = findDistrictDeck()
        local cards = countDistrictType(player.color,'noble')
        if cards > 0 and deck then deck.deal(cards, player.color) end
        for i,c in ipairs(G.players) do
            if c == player.color then G.crownIndex = i; break end
        end
        G.crownMovedThisRound = true
        moveCrown(player.color); setCrownUI()
        logTo(player.color, 'PATRICIAN: Took the crown. Drew '..cards..' card(s) from noble districts.')
        printToAll(player.color..' (Patrician) takes the crown!',{1,0.9,0.4})

    -- ── Rank 5 ──
    elseif guid == GUID.bishop then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local income = countDistrictType(player.color,'religious')
        if income > 0 then giveGold(player.color, income) end
        if income == 0 then
            logTo(player.color, 'BISHOP: No religious districts in your city, so no income. Your districts are still protected from rank 8 this round.')
        else
            logTo(player.color, 'BISHOP: Gained '..income..'g from religious districts. Your districts are protected from rank 8 this round.')
        end
        G.bishopColor = player.color

    elseif guid == GUID.abbot then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local relig = countDistrictType(player.color,'religious')
        if relig == 0 then logTo(player.color,'No religious districts to gain income from.'); return end
        -- Show one button per possible gold/card split (no rank numbers)
        G.abbotTotal = relig
        G.targeting = 'abbot_income'
        UI.setValue('txtTargetPrompt','ABBOT: Choose how to collect '..relig..' income from religious districts:')
        for i=1,8 do
            local bid = 'btnPick'..i
            local gold = i - 1  -- 0-indexed: button 1 = 0g/all cards, button 2 = 1g, etc.
            if gold <= relig then
                local cards = relig - gold
                local label
                if gold == 0 then
                    label = cards..' card'..(cards~=1 and 's' or '')
                elseif cards == 0 then
                    label = gold..'g'
                else
                    label = gold..'g + '..cards..' card'..(cards~=1 and 's' or '')
                end
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text', label)
                UI.setAttribute(bid,'color','white')
                UI.setAttribute(bid,'colors','#1A5276|#2E86C1|#154360|#1A5276')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')

    elseif guid == GUID.cardinal then
        -- Ability 1: draw cards equal to religious districts (always usable once per turn)
        if G.cardinalIncomeUsed then logTo(player.color,'Already drew cards this turn!'); return end
        G.cardinalIncomeUsed = true
        G.abilityUsed = true   -- also set generic flag so stale-state misfires are blocked
        local income = countDistrictType(player.color,'religious')
        if income > 0 then
            local deck = findDistrictDeck()
            if deck then deck.deal(income, player.color) end
        end
        logTo(player.color, 'CARDINAL: Drew '..income..' card(s) from religious districts. If you need to build but lack gold, drop the district card on the table — you will be prompted to borrow gold from a player.')

    -- ── Rank 6 ──
    elseif guid == GUID.merchant then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local income = countDistrictType(player.color,'trade')
        local total = income + 1  -- +1 bonus
        giveGold(player.color, total)
        logTo(player.color, 'MERCHANT: Gained '..income..'g from trade districts + 1 bonus = '..total..'g total.')

    elseif guid == GUID.alchemist then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        logTo(player.color, 'ALCHEMIST: All gold you spend building districts this turn will be refunded at End Turn.')

    elseif guid == GUID.trader then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local income = countDistrictType(player.color,'trade')
        if income > 0 then giveGold(player.color, income) end
        G.buildLimit = 99  -- can build unlimited trade districts
        logTo(player.color, 'TRADER: Gained '..income..'g from trade districts. You may build unlimited trade districts this turn.')

    -- ── Rank 7 ──
    elseif guid == GUID.architect then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local deck = findDistrictDeck()
        if deck then deck.deal(2, player.color) end
        G.buildLimit = 3
        logTo(player.color, 'ARCHITECT: Drew 2 extra cards. You may build up to 3 districts this turn.')

    elseif guid == GUID.navigator then
        -- Ability 1: Take 4 gold (separate from normal 2g gather)
        if G.abilityUsed then logTo(player.color,'NAVIGATOR: Ability already used this turn!'); return end
        G.abilityUsed = true
        giveGold(player.color, 4)
        updateGoldUI()
        logTo(player.color, 'NAVIGATOR: Took 4 gold. You cannot build any districts this turn.')
        printToAll('⛵  '..player.color..' (Navigator) takes 4 gold!',{0.7,0.9,1.0})
        btn('btnAbility', false); btn('btnAbility2', false)

    elseif guid == GUID.scholar then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local deck = findDistrictDeck()
        if deck then
            local drawCount = math.min(7, deck.getQuantity and deck.getQuantity() or 7)
            deck.deal(drawCount, player.color)
            G.mustDiscard = math.max(0, drawCount - 1)
            G.mustDiscardShuffle = G.mustDiscard > 0
            if G.mustDiscard > 0 then
                logTo(player.color, 'SCHOLAR: Drew '..drawCount..' cards - keep 1, drag the other '..G.mustDiscard..' face-down onto the district deck. They will be shuffled back in. Build limit is 2.')
            else
                logTo(player.color, 'SCHOLAR: Drew '..drawCount..' card. No shuffle return needed. Build limit is 2.')
            end
        else
            G.mustDiscard = 0
            G.mustDiscardShuffle = false
            logTo(player.color, 'SCHOLAR: District deck not found.')
        end
        G.buildLimit = 2

    -- ── Rank 8 ──
    elseif guid == GUID.warlord then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        showPlayerPicker('WARLORD: Destroy a district of which player?', 'warlord_target', true)

    elseif guid == GUID.diplomat then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        showPlayerPicker('DIPLOMAT: Swap a district with which player?', 'diplomat_target', true)

    elseif guid == GUID.marshal then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local income = countDistrictType(player.color,'military')
        if income > 0 then giveGold(player.color, income) end
        logTo(player.color, 'MARSHAL: Gained '..income..'g from military districts. Use the Seize button to seize a district.')

    -- ── Rank 9 ──
    elseif guid == GUID.queen then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        -- Check adjacency to rank 4 in turn order
        local rank4color = nil
        for _,e in ipairs(G.turnOrder) do
            if e.rank == 4 then rank4color = e.color; break end
        end
        local adjacent = false
        if rank4color then
            for i,p in ipairs(G.players) do
                if p == player.color then
                    local prev = G.players[((i-2) % G.playerCount) + 1]
                    local next = G.players[(i % G.playerCount) + 1]
                    if prev == rank4color or next == rank4color then adjacent = true end
                end
            end
        end
        if adjacent then
            G.abilityUsed = true
            giveGold(player.color, 3)
            logTo(player.color, 'QUEEN: Seated next to the rank 4 character. Gained 3g!')
        else
            logTo(player.color, 'QUEEN: You are not seated next to the rank 4 character. No gold gained.')
        end

    elseif guid == GUID.artist then
        if G.artistBeautifyCount >= 2 then
            logTo(player.color,'ARTIST: Already beautified 2 districts this turn (max 2).')
            return
        end
        if (G.gold[player.color] or 0) < 1 then
            logTo(player.color,'ARTIST: Not enough gold (need 1g to beautify).')
            return
        end
        -- Build list of districts in own city that haven't been beautified yet
        G.beautified = G.beautified or {}
        G.beautified[player.color] = G.beautified[player.color] or {}
        local available = {}
        for name,_ in pairs(G.cityNames[player.color] or {}) do
            if not G.beautified[player.color][name] then
                table.insert(available, name)
            end
        end
        table.sort(available)
        if #available == 0 then
            logTo(player.color,'ARTIST: All your districts have already been beautified.')
            return
        end
        G.artistPickList = available
        G.targeting = 'artist_beautify'
        UI.setValue('txtTargetPrompt','ARTIST: Beautify which district? (costs 1g)')
        for i=1,8 do
            local bid = 'btnPick'..i
            if i <= #available then
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text', available[i])
                UI.setAttribute(bid,'color','#FFDD88')
                UI.setAttribute(bid,'colors','#554400|#AA8800|#332200|#554400')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')
        btn('btnAbility',false); btn('btnAbility2',false)

        elseif guid == GUID.taxcollector then
        if G.abilityUsed then logTo(player.color,'Already used!'); return end
        G.abilityUsed = true
        local tcToken = obj(GUID.taxcollectorToken)
        local pp = PLAYER_POS[player.color]
        if tcToken and pp then
            local tp = tcToken.getPosition()
            -- Collect ALL gold coins physically near the tax token (radius 18, any Y)
            local coinsNear = {}
            for _, o in ipairs(getAllObjects()) do
                pcall(function()
                    if o.getName() == 'Gold' then
                        local op = o.getPosition()
                        if math.sqrt((op.x-tp.x)^2+(op.z-tp.z)^2) < 18 then
                            table.insert(coinsNear, o)
                        end
                    end
                end)
            end
            local collected = #coinsNear
            if collected > 0 then
                G.taxGold = 0
                G.gold[player.color] = (G.gold[player.color] or 0) + collected
                for i, coin in ipairs(coinsNear) do
                    pcall(function()
                        G.lockedCoins = G.lockedCoins or {}
                        G.lockedCoins[coin.getGUID()] = nil
                        G.coinPickedFrom = G.coinPickedFrom or {}
                        G.coinPickedFrom[coin.getGUID()] = nil
                        liftThenPlace(coin, {
                            x = pp.x + (math.random()-0.5)*1.5,
                            y = pp.y,
                            z = pp.z - 4 + (math.random()-0.5)*1.5,
                        }, (i-1) * 0.08)
                    end)
                end
                updateGoldUI()
                logTo(player.color, 'TAX COLLECTOR: Collected '..collected..'g from the tax plate!')
            else
                logTo(player.color, 'TAX COLLECTOR: No gold on the tax plate yet.')
            end
        else
            -- Fallback: use G.taxGold counter if token not found
            if (G.taxGold or 0) > 0 then
                local collected = G.taxGold
                G.taxGold = 0
                G.gold[player.color] = (G.gold[player.color] or 0) + collected
                if pp then takeFromBowl({x=pp.x, y=pp.y, z=pp.z-4}, collected) end
                updateGoldUI()
                logTo(player.color, 'TAX COLLECTOR: Collected '..collected..'g from the tax plate!')
            else
                logTo(player.color, 'TAX COLLECTOR: No gold on the tax plate yet.')
            end
        end
    end
    scheduleAutoEndTurnCheck(player.color, 0.2)
end

function onBtnAbility2(player)
    if G.phase ~= 'TURN' then return end
    if player.color ~= G.currentColor then logTo(player.color,'Not your turn!'); return end

    local guid = G.currentChar
    if not guid then return end

    -- ── Blackmail resolution (Refuse) — checked FIRST so it overrides any character ability ──
    if G.blackmailPending and G.blackmailPending == G.currentChar then
        if G.blackmailNeedsGather then
            logTo(player.color,'You must gather resources FIRST before resolving the blackmail threat!'); return
        end
        if G.blackmailResolved then logTo(player.color,'Already resolved!'); return end
        G.blackmailResolved = true
        G.blackmailPending = nil
        -- Restore ability buttons so player can continue their turn
        local labels   = ABILITY_LABEL[G.currentChar]
        local tooltips = ABILITY_TOOLTIP[G.currentChar]
        btn('btnAbility', false); btn('btnAbility2', false)
        if labels and labels[1] ~= '' then
            UI.setAttribute('btnAbility','text','✨  '..labels[1])
            if tooltips and tooltips[1] ~= '' then UI.setAttribute('btnAbility','tooltip',tooltips[1]) end
            btn('btnAbility', true)
        end
        if labels and labels[2] and labels[2] ~= '' then
            UI.setAttribute('btnAbility2','text','✨  '..labels[2])
            if tooltips and tooltips[2] ~= '' then UI.setAttribute('btnAbility2','tooltip',tooltips[2]) end
            btn('btnAbility2', true)
        end
        -- Threatened player refuses — Blackmailer now decides whether to flip the marker.
        -- If real (flowered lace): Blackmailer takes ALL their gold.
        -- If fake: nothing happens.
        printToAll('🃏  '..player.color..' refuses to pay the Blackmailer!',{1,0.6,0.3})
        logTo(player.color,'BLACKMAIL: You refused. Keep your gold — but the Blackmailer may flip your marker.')
        G.blackmailRefusalPending = { color=player.color, charGuid=G.currentChar }
        local tcColor = G.blackmailerColor
        if tcColor and isBot(tcColor) then
            -- Bot Blackmailer always flips (optimal play — free information and potentially all gold)
            Wait.time(function() blackmailerReveal(tcColor) end, 1.5)
        else
            logTo(tcColor, 'BLACKMAIL: '..player.color..' refused! Type  !flip  to reveal their marker '..
                '(if flowered lace, take ALL their gold), or  !pass  to leave it face-down.')
        end
        scheduleAutoEndTurnCheck(player.color, 0.2)
        return
    end

    if guid == GUID.navigator then
        -- Ability 2: Draw 4 cards (separate from normal 2-card gather)
        if G.abilityUsed then logTo(player.color,'NAVIGATOR: Ability already used this turn!'); return end
        G.abilityUsed = true
        local deck = findDistrictDeck()
        if deck then deck.deal(4, player.color) end
        logTo(player.color, 'NAVIGATOR: Drew 4 cards — keep them all. You cannot build any districts this turn.')
        printToAll('⛵  '..player.color..' (Navigator) draws 4 cards!',{0.7,0.9,1.0})
        btn('btnAbility', false); btn('btnAbility2', false)

    elseif guid == GUID.magician then
        -- Ability 2: discard & draw
        if G.abilityUsed then logTo(player.color,'Ability already used this turn!'); return end
        logTo(player.color, 'MAGICIAN: Drag the cards you want to discard to the district deck. Type "!magicdraw [count]" and you will draw that many cards.')

    elseif guid == GUID.wizard then
        -- Done button: return all remaining borrowed cards to the target's HAND zone.
        -- The chosen card has already been handled by the player:
        --   • Dragged to own CITY  → built for free via onObjectDrop (removed from borrowedGuids)
        --   • Dragged to own HAND  → detected here and left in hand (not returned)
        --   • Still on table       → treated as "keep in hand" (moved to wizard's hand zone)
        G.wizardPeeking = false
        btn('btnAbility2', false)
        local wTarget  = G.wizardBorrowedFrom
        local borrowed = G.wizardBorrowedGuids or {}
        local theirPos = wTarget and PLAYER_POS[wTarget]
        local myPos    = PLAYER_POS[player.color]

        -- Helper: compute a position inside a player's hand zone (direction-aware)
        -- Use exact hand zone positions measured in-game
        local function handZonePos(color, idx)
            local hp = HAND_POS[color]
            if not hp then return nil end
            return {x=hp.x, y=hp.y, z=hp.z}
        end

        -- Snapshot wizard's current hand
        local wHand = Player[player.color] and Player[player.color].getHandObjects() or {}
        local wHandGuids = {}
        for _, h in ipairs(wHand) do wHandGuids[h.getGUID()] = true end

        local returned = 0
        local keptInHand = 0
        for _, cardGuid in ipairs(borrowed) do
            local c = obj(cardGuid)
            if not c then
                -- Card was built this turn via drag-to-city (onObjectDrop removed it from
                -- the borrowed list) — nothing to do, count it as handled.
            elseif wHandGuids[cardGuid] then
                -- Card is in wizard's hand — player chose to keep it. Leave it there.
                keptInHand = keptInHand + 1
                logTo(player.color, 'WIZARD: Kept '..(c.getName() or '?')..' in your hand.')
            else
                -- Card still on table — return it to target's hand zone
                local dest = handZonePos(wTarget, returned)
                if dest then
                    local faceZ = (G.bots and G.bots[wTarget]) and 0 or 180
                    pcall(function()
                        c.setRotation({0, 0, faceZ})
                        c.setPosition({x=dest.x, y=dest.y + 4, z=dest.z})
                        Wait.time(function()
                            pcall(function() c.setPosition(dest) end)
                        end, 0.1 + returned * 0.15)
                    end)
                end
                returned = returned + 1
            end
        end

        G.wizardBorrowedFrom  = nil
        G.wizardBorrowedGuids = nil

        if returned > 0 then
            logTo(player.color, 'WIZARD: Returned '..returned..' card(s) to '..wTarget.."'s hand.")
            logTo(wTarget, 'Wizard returned '..returned..' card(s) to your hand.')
        end
        if keptInHand == 0 and returned == #borrowed then
            -- Player pressed Done without choosing — remind them
            logTo(player.color, 'WIZARD: No card was kept or built. You can still build normally this turn (build limit applies).')
        end

    elseif guid == GUID.abbot then
        -- Ability 2: receive 1g from the richest other player (once per turn)
        if G.abbotRichUsed then logTo(player.color,'ABBOT: Already collected from richest this turn!'); return end
        G.abbotRichUsed = true
        local richest, richestGold = richestPlayer(player.color)
        local myGold = G.gold[player.color] or 0
        if richest and richestGold > myGold then
            takeGold(richest, 1)
            giveGold(player.color, 1)
            logTo(player.color, 'ABBOT: Received 1g from '..richest..' ('..richestGold..'g — richest player).')
            logTo(richest, 'Abbot ('..player.color..') collected 1g from you (richest player).')
        elseif richest and richestGold <= myGold then
            logTo(player.color, 'ABBOT: You have equal or more gold than the richest other player — cannot use this ability.')
        else
            logTo(player.color, 'ABBOT: No other player has any gold.')
        end
        refreshCharacterAbilityButtons(player.color)

    elseif guid == GUID.warlord then
        if G.warlordIncomeUsed then logTo(player.color,'WARLORD: Already collected military income this turn!'); return end
        G.warlordIncomeUsed = true
        local income = countDistrictType(player.color,'military')
        if income > 0 then giveGold(player.color, income) end
        logTo(player.color, 'WARLORD: Gained '..income..'g from military districts.')
        btn('btnAbility2', false)

    elseif guid == GUID.diplomat then
        if G.diplomatIncomeUsed then logTo(player.color,'DIPLOMAT: Already collected military income this turn!'); return end
        G.diplomatIncomeUsed = true
        local income = countDistrictType(player.color,'military')
        if income > 0 then giveGold(player.color, income) end
        logTo(player.color, 'DIPLOMAT: Gained '..income..'g from military districts.')
        btn('btnAbility2', false)

    elseif guid == GUID.marshal then
        if G.seizeUsed then logTo(player.color,'Already seized a district this turn!'); return end
        G.seizeUsed = true
        showPlayerPicker('MARSHAL: Seize a district from which player?', 'marshal_target', true)

    elseif guid == GUID.artist then
        -- Ability 2 for artist: same as ability 1 (second beautify)
        if G.artistBeautifyCount >= 2 then
            logTo(player.color,'ARTIST: Already beautified 2 districts this turn (max 2).')
            return
        end
        if (G.gold[player.color] or 0) < 1 then
            logTo(player.color,'ARTIST: Not enough gold (need 1g to beautify).')
            return
        end
        G.beautified = G.beautified or {}
        G.beautified[player.color] = G.beautified[player.color] or {}
        local available = {}
        for name,_ in pairs(G.cityNames[player.color] or {}) do
            if not G.beautified[player.color][name] then
                table.insert(available, name)
            end
        end
        table.sort(available)
        if #available == 0 then
            logTo(player.color,'ARTIST: All your districts have already been beautified.')
            return
        end
        G.artistPickList = available
        G.targeting = 'artist_beautify'
        UI.setValue('txtTargetPrompt','ARTIST: Beautify which district? (costs 1g)')
        for i=1,8 do
            local bid = 'btnPick'..i
            if i <= #available then
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text', available[i])
                UI.setAttribute(bid,'color','#FFDD88')
                UI.setAttribute(bid,'colors','#554400|#AA8800|#332200|#554400')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')
        btn('btnAbility',false); btn('btnAbility2',false)
    end
    scheduleAutoEndTurnCheck(player.color, 0.2)
end

-- ============================================================
--  UI TARGETING SYSTEM
--  Abilities that need a rank/player target show a picker panel
--  instead of requiring chat commands.
-- ============================================================



-- ============================================================
--  CHAT COMMAND HANDLER for ability effects
-- ============================================================
function onChat(message, player)
    if G.phase ~= 'TURN' then return true end
    local color = player.color
    local msg = message:lower():gsub('^%s+',''):gsub('%s+$','')

    -- Only the current player (or witch during witch-turn) can issue ability commands
    if color ~= G.currentColor then return true end

    -- !emperor [color] gold|card
    local empTarget, empRes = msg:match('^!emperor%s+(%a+)%s+(%a+)')
    if empTarget then
        empTarget = empTarget:gsub('^%l',string.upper)
        if not G.gold[empTarget] then logTo(color,'Player '..empTarget..' not found.'); return false end
        if G.abilityUsed then logTo(color,'Emperor ability already used this turn!'); return false end
        G.abilityUsed = true
        -- Give crown
        for i,c in ipairs(G.players) do
            if c == empTarget then G.crownIndex = i; break end
        end
        G.crownMovedThisRound = true
        moveCrown(empTarget); setCrownUI()
        -- Take resource
        if empRes == 'gold' then
            local taken = math.min(1, G.gold[empTarget] or 0)
            takeGold(empTarget, taken); giveGold(color, taken)
            logTo(color,'EMPEROR: Gave crown to '..empTarget..', took '..taken..'g.')
        else
            local hand = Player[empTarget] and Player[empTarget].getHandObjects() or {}
            if #hand > 0 then
                local card = hand[math.random(#hand)]
                local pos = PLAYER_POS[color]
                if pos and card then liftThenPlace(card,{x=pos.x,y=pos.y,z=pos.z-5}) end
            end
            logTo(color,'EMPEROR: Gave crown to '..empTarget..', took a random card.')
        end
        printToAll(color..' (Emperor) gives the crown to '..empTarget..'!',{1,0.9,0.4})
        return false
    end

    -- ── Debug / host commands ──────────────────────────────────
    if player.host then
        if message=='!reset' then
            resetGameToSetupState()
            log('Game reset by host.'); return false
        end
        if message=='!skip' then
            if G.phase=='SELECTION' then
                local expected=G.selectionOrder[G.selectionStep]
                if expected and #G.activeCharGuids>0 then
                    local guid=G.activeCharGuids[1]
                    local isSecond3p = (G.playerCount==2 and G.selectionStep>=3)
                                    or (G.playerCount==3 and G.selectionStep>=4)
                    if isSecond3p then
                        G.chosenBy2[expected]=guid
                    else
                        G.chosenBy[expected]=guid
                    end
                    removeValue(G.activeCharGuids,guid)
                    logTo(player.color,'!skip: auto-assigned '..CHAR_NAME[guid]..' to '..expected)
                end
                G.selectionBusy=false; btn('btnReady',false); advanceSelection()
            elseif G.phase=='TURN' then
                G.hasGathered=true
                btn('btnGold',false); btn('btnDraw',false); btn('btnEnd',false)
                btn('btnAbility',false); btn('btnAbility2',false)
                log('!skip: force-ending '..(G.currentColor or '?').."'s turn")
                scheduleAdvanceTurn(0.2)
            end
            return false
        end
        if message=='!state' then
            log('Phase: '..G.phase..' | Round: '..G.roundNumber)
            if G.phase=='TURN' then
                log('Current: '..(G.currentColor or 'none')..' | Char: '..(G.currentChar and CHAR_NAME[G.currentChar] or '?'))
                log('Gathered: '..tostring(G.hasGathered)..' | Build: '..G.buildCount..'/'..G.buildLimit)
                log('Killed: '..(G.killedChar and CHAR_NAME[G.killedChar] or 'none'))
                debugLog('TaxGold: '..(G.taxGold or 0))
            end
            return false
        end
    end

    -- Blackmailer post-refusal: flip to reveal and potentially take all gold, or pass
    if msg == '!flip' then
        if not G.blackmailRefusalPending then logTo(color,'No refusal pending.'); return false end
        if color ~= G.blackmailerColor then logTo(color,'Only the Blackmailer can reveal the marker.'); return false end
        blackmailerReveal(color)
        return false
    end
    if msg == '!pass' then
        if not G.blackmailRefusalPending then return true end
        if color ~= G.blackmailerColor then return true end
        blackmailerPass()
        return false
    end

    return true  -- pass through to normal chat
end

-- ============================================================
--  DISTRICT BUILDING
-- ============================================================

function onDistrictBuilt(districtData)
    local color=districtData.color; local cost=districtData.cost or 0; local dtype=districtData.districtType or 'unique'

    -- Only the active player can build during the TURN phase
    if G.phase ~= 'TURN' then
        logTo(color, 'You can only build during the Turn phase.')
        return false
    end
    if color ~= G.currentColor then
        logTo(color, 'It is not your turn — you cannot build right now.')
        return false
    end

    -- Secret Vault cannot be placed in a city — keep it in hand until end of game
    if requireBlackmailResolved(color, 'building a district') then
        return false
    end

    local _distName = districtData.districtName or ''
    if _distName == 'Secret Vault' then
        logTo(color, 'SECRET VAULT: This card stays in your hand — it cannot be built. At the end of the game it reveals itself for +3 points.')
        return false
    end

    -- Wizard peek: block building borrowed cards until the player clicks Done.
    -- After Done, wizardPeeking is cleared and the chosen card can be built for free.
    if G.wizardPeeking and color == G.currentColor and G.wizardBorrowedGuids then
        local droppedGuid = districtData.droppedGuid
        if droppedGuid and contains(G.wizardBorrowedGuids, droppedGuid) then
            logTo(color, 'WIZARD: Drag your chosen card into your hand first, then press Done before building it.')
            return false
        end
    end
    -- Duplicate exemption: Wizard may build cards identical to ones already in their city.

    -- Must gather resources before building
    if not G.hasGathered and color == G.currentColor then
        logTo(color, 'You must gather resources (take gold or draw cards) before building a district!')
        return false
    end

    -- Witch cannot build during her initial turn (buildLimit=0 handles this),
    -- but the witchResuming flag additionally gives a clear message if somehow attempted
    if G.currentChar == GUID.witch and color == G.currentColor and not G.witchResuming then
        logTo(color, 'Witch cannot build during her initial turn! Use your Bewitch ability, then End Turn. You will build during the resume phase.')
        return false
    end

    -- Block building while Witch is on hold (has bewitched but resume not yet started)
    if G.witchOnHold and color == G.currentColor then
        logTo(color, 'Your turn is on hold — click End Turn. You will resume after the bewitched character takes their gather-only turn.')
        return false
    end

    -- Navigator: absolutely no building this turn
    if G.currentChar == GUID.navigator and color == G.currentColor then
        logTo(color, 'Navigator cannot build any districts this turn.')
        return false
    end

    -- Apply Quarry / Factory cost reductions for unique districts.
    -- Framework can bypass the gold payment entirely for the resumed free build.
    if G.frameworkMode then
        cost = 0
    elseif dtype == 'unique' then
        cost = adjustedBuildCost(color, dtype, cost)
    end

    -- Thieves' Den discount: player discarded cards to reduce the GOLD PAID,
    -- but the district still scores its full face value.
    local scoreValue = cost   -- face value used for cityScore / cityCosts
    if (G.thievesDenDiscount or 0) > 0 then
        local disc = G.thievesDenDiscount
        cost = math.max(0, cost - disc)   -- reduced gold payment only
        G.thievesDenDiscount = 0
        logTo(color, "THIEVES' DEN discount applied: -"..disc..'g → cost now '..cost..'g.')
    end

    -- Duplicate district check: cannot build a district with the same name twice
    -- (unless the player has Quarry, which allows building any duplicate district)
    local distName = districtData.districtName or ''
    if distName ~= '' then
        G.cityNames = G.cityNames or {}
        G.cityNames[color] = G.cityNames[color] or {}
        if G.cityNames[color][distName] then
            local hasQuarry  = hasUnique and hasUnique(color,'Quarry')
            local isWizardTurn = (G.currentChar == GUID.wizard and color == G.currentColor)
            if not hasQuarry and not isWizardTurn then
                logTo(color, 'You already built '..distName..' — you cannot build the same district twice.')
                return false
            end
        end
    end

    if color == G.currentColor and districtData.droppedGuid and distName ~= ''
       and hasUnique(color,'Framework') and not G.frameworkMode and not G.frameworkResume
       and not G.frameworkPendingBuild and distName ~= 'Necropolis' then
        local canPayNormally = (G.gold[color] or 0) >= cost
        local faceValue = (DISTRICT_DATA[distName] and DISTRICT_DATA[distName][1]) or cost
        G.frameworkPendingBuild = {
            guid = districtData.droppedGuid,
            color = color,
            cost = cost,
            dtype = dtype,
            dname = distName,
            faceValue = faceValue,
        }
        G.targeting = 'framework_choice'
        setTargetPlayerPanelLayout('compact', 2)
        UI.setValue('txtTargetPrompt', 'FRAMEWORK: Destroy Framework to build '..distName..' for free?')
        for i = 1, 8 do
            local bid = 'btnPick'..i
            if i == 1 then
                UI.setAttribute(bid,'active','true')
                UI.setAttribute(bid,'text','🧱  Use Framework\nFree build')
                UI.setAttribute(bid,'color','white')
                UI.setAttribute(bid,'colors','#440077|#7733BB|#220044|#440077')
            elseif i == 2 then
                UI.setAttribute(bid,'active', canPayNormally and 'true' or 'false')
                UI.setAttribute(bid,'text','💰  Pay normally\n'..cost..'g')
                UI.setAttribute(bid,'color', canPayNormally and '#FFD700' or '#888888')
                UI.setAttribute(bid,'colors', canPayNormally and '#664400|#AA7700|#443300|#664400'
                                                          or '#444444|#666666|#222222|#444444')
            else
                UI.setAttribute(bid,'active','false')
            end
        end
        UI.setAttribute('pnlTarget','active','false')
        UI.setAttribute('pnlTargetPlayer','active','true')
        btn('btnAbility', false); btn('btnAbility2', false)
        return false
    end

    -- Cardinal borrow: if Cardinal can't afford, offer to borrow difference from a player
    if (G.gold[color] or 0) < cost and G.currentChar == GUID.cardinal and color == G.currentColor then
        local shortfall = cost - (G.gold[color] or 0)
        -- Count district cards in hand (not character cards)
        local handDistCards = 0
        pcall(function()
            local p = Player[color]; if not p then return end
            for _, hcard in ipairs(p.getHandObjects()) do
                local hn = hcard.getName() or ''
                if DISTRICT_DATA[hn] or DISTRICT_DATA[hn:match('^%s*(.-)%s*$')] then
                    handDistCards = handDistCards + 1
                end
            end
        end)
        if handDistCards >= shortfall then
            -- Enough cards to cover the borrow — store the pending build and ask who to borrow from
            G.cardinalPendingBuild = { cost=cost, dtype=dtype, distName=distName, shortfall=shortfall,
                                       droppedGuid=districtData.droppedGuid }
            showPlayerPicker('CARDINAL: Borrow '..shortfall..'g from which player? (you give them '..shortfall..' district card(s))', 'cardinal_target', true)
            return false  -- halt build; will resume after borrow
        else
            logTo(color, 'CARDINAL: Cannot afford '..distName..' (need '..cost..'g, have '..(G.gold[color] or 0)..'g, only '..handDistCards..' card(s) to give).')
            return false
        end
    end

    -- Afford check
    if (G.gold[color] or 0) < cost then
        debugLog(color..' cannot afford district (cost '..cost..', has '..(G.gold[color] or 0)..'g).')
        return false
    end

    -- Build limit: Wizard gets 1 free build (doesn't count toward limit), then normal limit applies
    local isFree = false
    if G.frameworkMode then
        isFree = true
        logTo(color, 'FRAMEWORK: Free build does not count toward your build limit.')
    elseif color == G.currentColor and G.currentChar == GUID.wizard
       and (G.wizardFreeBuilds or 0) > 0 then
        isFree = true
        G.wizardFreeBuilds = G.wizardFreeBuilds - 1
        logTo(color, 'WIZARD: Free build — does not count toward your build limit.')
    else
        G.buildCount = (G.buildCount or 0) + 1
        if G.buildCount > (G.buildLimit or 1) then
            logTo(color, 'Build limit reached ('..tostring(G.buildLimit)..' this turn).')
            G.buildCount = G.buildCount - 1   -- undo the increment
            return false
        end
        -- Trader: unlimited builds but only trade-type districts beyond the first
        if G.currentChar == GUID.trader and G.buildCount > 1 and dtype ~= 'trade' then
            logTo(color, 'TRADER: Your unlimited build bonus only applies to trade (green) districts. Non-trade limited to 1 per turn.')
            G.buildCount = G.buildCount - 1
            return false
        end
    end

    -- Stables: the turn it is built, it does not count toward the build limit
    if distName == 'Stables' and not isFree then
        G.buildCount = math.max(0, G.buildCount - 1)
        logTo(color, 'STABLES: This build did not count toward your build limit!')
    end

    takeGold(color, cost)

    -- Magistrate confiscation: if this is the warranted character's FIRST build, confiscate it
    if G.warrantedChar and G.currentChar == G.warrantedChar
       and not (G.warrantBuilds and G.warrantBuilds[color]) then
        G.warrantBuilds[color] = true
        local magistrateColor = G.magistrateColor
        if magistrateColor and magistrateColor ~= color then
            -- Refund the builder's gold
            giveGold(color, cost)
            -- Magistrate builds it for free — add to their city instead
            addCityCompletion(magistrateColor, distName)
            G.cityScore[magistrateColor] = (G.cityScore[magistrateColor] or 0) + cost
            G.buildTypes[magistrateColor] = G.buildTypes[magistrateColor] or {}
            G.buildTypes[magistrateColor][dtype] = (G.buildTypes[magistrateColor][dtype] or 0) + 1
            -- Also track in cityNames / uniqueBuilt so scoring/duplicate checks work
            G.cityNames[magistrateColor] = G.cityNames[magistrateColor] or {}
            G.cityNames[magistrateColor][distName] = true
            if dtype == 'unique' then
                G.uniqueBuilt[magistrateColor] = G.uniqueBuilt[magistrateColor] or {}
                G.uniqueBuilt[magistrateColor][distName] = true
            end
            -- Move the district card physically to the Magistrate's city area
            local mPos = PLAYER_POS[magistrateColor]
            local bPos = PLAYER_POS[color]
            if mPos and bPos and distName ~= '' then
                -- Find the card near the builder's area (it was just dropped there)
                local searchRadius = 25
                for _, o in ipairs(getAllObjects()) do
                    pcall(function()
                        if o.getName() == distName then
                            local op = o.getPosition()
                            if math.sqrt((op.x-bPos.x)^2+(op.z-bPos.z)^2) < searchRadius then
                                moveDistrictCardToCity(magistrateColor, distName, o)
                            end
                        end
                    end)
                end
            end
            G.magistrateConfiscating = { from=color, to=magistrateColor, cost=cost, dtype=dtype }
            printToAll('⚖️  Magistrate ('..magistrateColor..') CONFISCATES '..distName..' from '..color..'!',{1,0.85,0.2})
            logTo(color, 'Your '..distName..' was confiscated by the Magistrate! Gold refunded.')
            logTo(magistrateColor, 'MAGISTRATE: Confiscated '..distName..' (cost '..cost..'g, '..dtype..'). Added to your city for free!')
            announceScoreChange(magistrateColor, cost, 'Magistrate confiscated '..distName)
            -- The Magistrate is the player who ultimately built the confiscated district.
            chargeTax(magistrateColor)
            checkCityCompletion(magistrateColor)
            -- Don't count this toward the builder's city — return early
            return true
        end
    end
    if G.warrantedChar and G.currentChar == G.warrantedChar then
        G.warrantBuilds = G.warrantBuilds or {}
        G.warrantBuilds[color] = true  -- mark first build done; no more confiscation
    end
    if G.currentChar == GUID.alchemist and color == G.currentColor then
        G.alchemistGold = (G.alchemistGold or 0) + cost
    end
    -- Property tax: 1g from builder to Tax Collector's token after every build
    chargeTax(color)

    addCityCompletion(color, distName)
    G.cityScore[color] = (G.cityScore[color] or 0) + scoreValue   -- face value, not discounted
    if scoreValue > 0 then
        local label = (distName and distName ~= '') and distName or (dtype..' district')
        announceScoreChange(color, scoreValue, 'built '..label)
    end
    G.cityTypes[color][dtype] = true
    -- Track name for duplicate prevention
    if distName and distName ~= '' then
        G.cityNames = G.cityNames or {}
        G.cityNames[color] = G.cityNames[color] or {}
        G.cityNames[color][distName] = true
    end
    G.buildTypes[color] = G.buildTypes[color] or {}
    G.buildTypes[color][dtype] = (G.buildTypes[color][dtype] or 0) + 1

    -- Track face value for Basilica scoring (not the discounted gold paid)
    G.cityCosts[color] = G.cityCosts[color] or {}
    table.insert(G.cityCosts[color], scoreValue)

    -- Unique district: register name and trigger instant effects
    local distName = districtData.districtName or ''
    if dtype == 'unique' and distName ~= '' then
        onUniqueDistrictBuilt(color, distName, cost)
    end

    -- On-build passives (Treasury, Poor House) — run AFTER uniqueBuilt is updated
    if color == G.currentColor then
        applyOnBuildPassives(color, cost, dtype)
    end

    debugLog(color..' built '..dtype..' district (cost '..cost..'). City: '..G.citySize[color]..'/'..cityThreshold())
    -- Refresh the District Ability button immediately so newly built uniques are usable at once
    if color == G.currentColor then refreshUniqueAbilityButton(color) end
    updateGoldUI()
    checkCityCompletion(color)
    scheduleAutoEndTurnCheck(color, 0.2)
    return true
end

function checkCityCompletion(color)
    if (G.citySize[color] or 0)>=cityThreshold() then
        if not G.completedFirst then
            G.completedFirst=color
            printToAll('🏰 '..color..' completed their city first!',{1,0.85,0})
            -- Play city-completion sound
            pcall(function()
                MusicPlayer.setCurrentAudioclip({
                    title = 'A city has been completed',
                    url   = 'https://steamusercontent-a.akamaihd.net/ugc/17229559286410266333/79F9AD2836D005100448539CF283AE3F4444CAD0/',
                })
                MusicPlayer.play()
            end)
        end
        G.gameOver=true
    end
end

-- ============================================================
--  END OF ROUND
-- ============================================================

function endRound()
    if G.resetting then return end
    if G.roundEnding then return end
    G.roundEnding = true
    G.turnAdvancePending = false
    log('=== End of Round '..G.roundNumber..' ===')

    -- Re-stage all character cards into fixed slots instead of dropping them into a
    -- random center pile. The old pile-up could auto-stack cards into transient decks,
    -- which then caused null-key errors when the next selection phase tried to extract
    -- specific GUIDs back out of that stack.
    local charGuids = {}
    if G.gameCast then
        for _, guid in pairs(G.gameCast) do charGuids[guid] = true end
    end
    -- Also include any that were in chosenBy / chosenBy2
    for _, guid in pairs(G.chosenBy or {}) do charGuids[guid] = true end
    for _, guid in pairs(G.chosenBy2 or {}) do charGuids[guid] = true end

    local returnIdx = 0
    for _, o in ipairs(getAllObjects()) do
        pcall(function()
            local g = o.getGUID()
            if charGuids[g] then
                returnIdx = returnIdx + 1
                local idx = returnIdx
                Wait.time(function()
                    if G.resetting or G.phase == 'SETUP' then return end
                    pcall(function()
                        o.setRotation({0, 0, 180})  -- face-down while waiting for next round
                        liftThenPlace(o, charStagingPos(idx, -1), 0)
                    end)
                end, (idx-1)*0.08)
            end
        end)
    end
    -- If bewitched character was not in play (killed or not in cast), witch does not resume.
    if G.bewitchedChar and G.witchColor then
        local charName = CHAR_NAME[G.bewitchedChar] or '?'
        printToAll('🧙  Bewitched character ('..charName..') was not in play — Witch does not resume.',{0.7,0.5,1.0})
        G.bewitchedChar = nil
        G.witchColor    = nil
        G.witchOnHold   = false
    end    -- Crown auto-passes to rank 4 ONLY if nobody explicitly moved it this round.
    -- Emperor, King, Patrician, and !emperor chat command set G.crownMovedThisRound=true.
    if not G.crownMovedThisRound then
        for _,e in ipairs(G.turnOrder) do
            if e.rank==4 then
                for i,color in ipairs(G.players) do
                    if color==e.color then G.crownIndex=i; break end
                end
                debugLog('Crown passes to '..e.color..' ('..e.name..') — rank 4 auto-pass.')
                moveCrown(e.color)
                break
            end
        end
    else
        debugLog('Crown was moved explicitly this round — keeping current holder.')
    end
    G.crownMovedThisRound = false   -- reset for next round
    setCrownUI()
    if G.gameOver then Wait.time(endGame,1.5) else Wait.time(beginSelectionPhase,0.5) end
end

-- ============================================================
--  SCORING
-- ============================================================

function endGame()
    G.phase='END'; setPhaseUI('GAME OVER')
    log('=== GAME OVER — Calculating scores ===')

    local scores={}; local winner=nil; local highScore=-1; local winnerRank=-1
    local lastRevealRank = {}
    local lastRevealGuid = {}
    local playerOrder = {}
    -- Per-player score breakdown for scoreboard UI
    local scoreData = {}

    for idx, color in ipairs(G.players) do
        playerOrder[color] = idx
    end

    for _,color in ipairs(G.players) do
        local score = G.cityScore[color] or 0
        local bonuses = {}
        local baseScore = score

        -- ── Standard bonuses ─────────────────────────────
        local tc=0; for _ in pairs(G.cityTypes[color] or {}) do tc=tc+1 end
        if tc>=5 then score=score+3; table.insert(bonuses,'+3  All 5 district types') end
        if G.completedFirst==color then score=score+4; table.insert(bonuses,'+4  First completed city')
        elseif (G.citySize[color] or 0)>=cityThreshold() then score=score+2; table.insert(bonuses,'+2  Completed city') end

        -- ── Unique district bonus scoring ─────────────────
        local ub = G.uniqueBuilt and G.uniqueBuilt[color] or {}

        -- Artist: +1 per beautified district
        local beautifyCount = 0
        if G.beautified and G.beautified[color] then
            for _ in pairs(G.beautified[color]) do beautifyCount = beautifyCount + 1 end
        end
        if beautifyCount > 0 then table.insert(bonuses, '+'..beautifyCount..'  Beautified districts (Artist)') end

        -- Dragon Gate: +2 points
        if ub['Dragon Gate'] then score=score+2; table.insert(bonuses,'+2  Dragon Gate') end

        -- Ivory Tower: +5 if it is the ONLY unique district in the city
        if ub['Ivory Tower'] then
            local uniqueCount = 0
            for _ in pairs(ub) do uniqueCount = uniqueCount + 1 end
            if uniqueCount == 1 then
                score=score+5; table.insert(bonuses,'+5  Ivory Tower (only unique)')
            else
                table.insert(bonuses,'0   Ivory Tower (not only unique)')
            end
        end

        -- Wishing Well: +1 per unique district
        if ub['Wishing Well'] then
            local ucount = 0
            for _ in pairs(ub) do ucount=ucount+1 end
            score=score+ucount; table.insert(bonuses,'+'..ucount..'  Wishing Well ('..ucount..' uniques)')
        end

        -- Imperial Treasury: +1 per gold in stash
        if ub['Imperial Treasury'] then
            local g = G.gold[color] or 0
            score=score+g; table.insert(bonuses,'+'..g..'  Imperial Treasury ('..g..'g)')
        end

        -- Map Room: +1 per district card in hand (character cards excluded)
        if ub['Map Room'] then
            local hand = Player[color] and Player[color].getHandObjects() or {}
            local dCount = 0
            for _, hcard in ipairs(hand) do
                local hn = hcard.getName() or ''
                if DISTRICT_DATA[hn] or DISTRICT_DATA[hn:match('^%s*(.-)%s*$')] then
                    dCount = dCount + 1
                end
            end
            score=score+dCount
            table.insert(bonuses,'+'..dCount..'  Map Room ('..dCount..' cards in hand)')
        end

        -- Museum: +1 per card tucked under it
        if ub['Museum'] then
            local mc = G.museumCards and G.museumCards[color] and #G.museumCards[color] or 0
            score=score+mc; table.insert(bonuses,'+'..mc..'  Museum ('..mc..' tucked cards)')
        end

        -- Monument: +4 if hand is empty
        if ub['Monument'] then
            local hand = Player[color] and Player[color].getHandObjects() or {}
            if #hand==0 then score=score+4; table.insert(bonuses,'+4  Monument (empty hand)') end
        end

        -- Statue: +3 if this player holds the crown
        if ub['Statue'] then
            local crownHolder = G.players[G.crownIndex]
            if crownHolder==color then score=score+3; table.insert(bonuses,'+3  Statue (has crown)') end
        end

        -- Capitol: +3 if 3+ districts of same type
        if ub['Capitol'] then
            if maxSameColorCount(color)>=3 then score=score+3; table.insert(bonuses,'+3  Capitol (3+ same type)') end
        end

        -- Secret Vault: +3 if held in hand at game end (it is never built into the city)
        local hasSecretVault = false
        pcall(function()
            local p = Player[color]
            if p then
                for _, hobj in ipairs(p.getHandObjects()) do
                    pcall(function()
                        local n = (hobj.getName() or ''):match('^%s*(.-)%s*$')
                        if n == 'Secret Vault' then hasSecretVault = true end
                    end)
                end
            end
        end)
        if hasSecretVault then score=score+3; table.insert(bonuses,'+3  Secret Vault (revealed from hand)') end

        -- Basilica: +1 per odd-cost district
        if ub['Basilica'] then
            local oc = countOddCostDistricts(color)
            score=score+oc; table.insert(bonuses,'+'..oc..'  Basilica ('..oc..' odd-cost districts)')
        end

        -- Haunted Quarter: counts as 5th type → all-5-types bonus
        if ub['Haunted Quarter'] and tc==4 then
            score=score+3
            table.insert(bonuses,'+3  Haunted Quarter (5th district type)')
        end

        scores[color]=score
        scoreData[color] = {score=score, base=baseScore, bonuses=bonuses}

        -- Print detailed breakdown to that player's private log
        logTo(color,'── FINAL SCORE: '..score..' pts ──')
        logTo(color,'  Base (districts): '..baseScore..'pts')
        for _,b in ipairs(bonuses) do logTo(color,'  '..b) end

        local g1 = G.chosenBy[color]
        local g2 = G.chosenBy2 and G.chosenBy2[color] or nil
        local r1 = g1 and (CHAR_RANK[g1] or 0) or 0
        local r2 = g2 and (CHAR_RANK[g2] or 0) or 0
        local lastRank = r1
        local lastGuid = g1
        if r2 > r1 then
            lastRank = r2
            lastGuid = g2
        end
        lastRevealRank[color] = lastRank
        lastRevealGuid[color] = lastGuid
        scoreData[color].lastRank = lastRank
        scoreData[color].lastGuid = lastGuid
        if score>highScore or (score==highScore and lastRank>winnerRank) then
            highScore=score; winner=color; winnerRank=lastRank
        end
    end

    local tiedLeaders = {}
    for _, color in ipairs(G.players) do
        if scores[color] == highScore then
            table.insert(tiedLeaders, color)
        end
    end

    local tieBreakNote = nil
    if #tiedLeaders > 1 then
        local winningGuid = lastRevealGuid[winner]
        local winningName = winningGuid and CHAR_NAME[winningGuid] or ('rank '..tostring(winnerRank))
        tieBreakNote = 'Tie at '..highScore..' pts. '..winner..' wins the tiebreak because among the tied players, whoever revealed the highest-numbered character rank during the last round wins ('..winner..' revealed rank '..winnerRank..' - '..winningName..').'
    end

    printToAll('',{1,1,1})
    printToAll('╔═══════════════════════════╗',{1,0.9,0.3})
    printToAll('║       FINAL  SCORES       ║',{1,0.9,0.3})
    printToAll('╠═══════════════════════════╣',{1,0.9,0.3})
    for _,color in ipairs(G.players) do printToAll('  '..color..':  '..scores[color]..' pts',{1,1,0.7}) end
    printToAll('╚═══════════════════════════╝',{1,0.9,0.3})
    if tieBreakNote then
        printToAll(tieBreakNote,{1,0.9,0.4})
    end
    printToAll('🏆  WINNER:  '..winner..'  ('..highScore..' pts)',{0.4,1,0.4})
    if tieBreakNote then
        setStatus('🏆 Winner: '..winner..' — '..highScore..' pts (tiebreak: highest revealed rank)')
    else
        setStatus('🏆 Winner: '..winner..' — '..highScore..' pts')
    end
    setTurnUI('')

    -- ── Build scoreboard UI text ──────────────────────────────────
    -- Sort players by score, then by the last revealed rank from the final round.
    local sorted = {}
    for _,color in ipairs(G.players) do table.insert(sorted,color) end
    table.sort(sorted, function(a,b)
        if (scores[a] or 0) ~= (scores[b] or 0) then
            return (scores[a] or 0) > (scores[b] or 0)
        end
        if (lastRevealRank[a] or 0) ~= (lastRevealRank[b] or 0) then
            return (lastRevealRank[a] or 0) > (lastRevealRank[b] or 0)
        end
        return (playerOrder[a] or 999) < (playerOrder[b] or 999)
    end)

    local bodyLines = {}
    if tieBreakNote then
        table.insert(bodyLines, 'TIEBREAK: If players tie on points, the tied player who revealed the highest-numbered rank during the last round wins.')
        for _, color in ipairs(tiedLeaders) do
            local infoGuid = lastRevealGuid[color]
            local infoName = infoGuid and CHAR_NAME[infoGuid] or '?'
            table.insert(bodyLines, '  '..color..': rank '..(lastRevealRank[color] or 0)..' ('..infoName..')')
        end
        table.insert(bodyLines, '————————————————————————————————————————')
    end
    for rank_pos, color in ipairs(sorted) do
        local sd = scoreData[color]
        local medal = rank_pos==1 and '🥇' or rank_pos==2 and '🥈' or rank_pos==3 and '🥉' or '  '
        table.insert(bodyLines, medal..' '..color..'   TOTAL: '..sd.score..' pts')
        table.insert(bodyLines, '   Districts built: '..sd.base..'pts')
        for _,b in ipairs(sd.bonuses) do
            table.insert(bodyLines, '   '..b)
        end
        if rank_pos < #sorted then
            table.insert(bodyLines, '────────────────────────────────────────')
        end
    end

    if tieBreakNote then
        UI.setValue('txtScoreWinner', '🏆  Winner: '..winner..'  —  '..highScore..' pts (tiebreak)')
    else
        UI.setValue('txtScoreWinner', '🏆  Winner: '..winner..'  —  '..highScore..' pts')
    end
    UI.setValue('txtScoreBody', table.concat(bodyLines, '\n'))
    UI.setAttribute('pnlScoreboard', 'active', 'true')

    -- Disable turn system on game end; restore setup panel for next game
    btn('setupPanel',true); btn('pnlUniqueDist',true); btn('btnStart',true)
    btn('btnBotsToggle', false)
    UI.setAttribute('pnlBotsGame', 'active', 'false')
    UI.setValue('btnBotsToggle', '🤖  Manage Bots  ▾')
    UI.setValue('btnStart','↺  Play Again')
    G.phase='SETUP'
end

function onBtnCloseScore()
    UI.setAttribute('pnlScoreboard', 'active', 'false')
end

function onBtnResetGame(player)
    if not player.host then
        logTo(player.color, 'Only the host can reset the table.')
        return
    end
    resetGameToSetupState()
    log('Game reset by host.')
end

-- ── Minimize / restore: Character Setup panel ────────────────────────────
-- Hides the full panel and shows a compact tab in the bottom-left corner.
local setupMinimized = false
function onBtnMinimizeSetup(player)
    setupMinimized = not setupMinimized
    if setupMinimized then
        UI.setAttribute('setupPanel',  'active', 'false')
        UI.setAttribute('pnlSetupTab', 'active', 'true')
    else
        UI.setAttribute('setupPanel',  'active', 'true')
        UI.setAttribute('pnlSetupTab', 'active', 'false')
    end
end

-- ── Minimize / restore: Unique Districts panel ───────────────────────────
local uqMinimized = false
function onBtnMinimizeUq(player)
    uqMinimized = not uqMinimized
    if uqMinimized then
        UI.setAttribute('pnlUniqueDist', 'active', 'false')
        UI.setAttribute('pnlUqTab',      'active', 'true')
    else
        UI.setAttribute('pnlUniqueDist', 'active', 'true')
        UI.setAttribute('pnlUqTab',      'active', 'false')
    end
end

-- ============================================================
--  DISTRICT CARD SCRIPT  — NO LONGER NEEDED
--  All district drops are now handled centrally via onObjectDrop
--  in the Global script using the DISTRICT_DATA lookup table.
--  You do NOT need to paste any script into individual district cards.
-- ============================================================
--[[  (kept for reference only — this code is not used)

cardCost = 3        -- building cost in gold
cardType = 'noble'  -- noble | military | religious | trade | unique
-- cardName should be set to self.getName() for unique districts so scoring works.
-- For non-unique districts this can be left blank.

function onDrop(player_color)
    -- Only trigger building when dropped face-up on the TABLE, not inside a hand zone.
    -- Note: this script is no longer used — drops are handled centrally in Global onObjectDrop.
    -- self.isHandObject() would be valid here but the script is inactive.

    -- Ignore face-down drops (card being passed, not played).
    local rot = self.getRotation()
    local faceDown = (math.abs(rot.z - 180) < 45 or math.abs(rot.z + 180) < 45)
    if faceDown then return end

    local result = Global.call('onDistrictBuilt', {
        color        = player_color,
        cost         = cardCost,
        districtType = cardType,
        districtName = self.getName(),  -- used for unique district ability tracking
    })
    if not result then
        -- Can't build: flip back face-down and return to hand
        self.flip()
    end
end

--]]

-- ============================================================
--  TTS CALLBACKS
-- ============================================================

-- ============================================================
--  GOLD DROP CORRECTION
--  Dropping a Gold coin near any player's area credits that player's count.
--  This lets players fix mistakes without needing a command.
-- ============================================================
function onObjectDrop(player_color, dropped_object)
    if G.resetting then return end
    -- Beautify markers are not spendable gold. If one gets bumped, snap it back.
    if dropped_object.getName() == 'Beautify Gold' then
        local guid = dropped_object.getGUID()
        local meta = G.beautifyCoinMeta and G.beautifyCoinMeta[guid]
        if meta then syncBeautifyCoin(meta.color, meta.districtName, 0.05) end
        return
    end
    -- ── District card: handle building centrally (no card script needed) ──
    local dname = dropped_object.getName()
    if not dname or dname == '' then return end  -- nil-guard: unnamed objects can't be districts
    -- Try exact match first, then strip any trailing/leading whitespace
    local ddata = DISTRICT_DATA[dname] or DISTRICT_DATA[dname:match('^%s*(.-)%s*$')]
    if ddata then
        -- Beautified districts are already built. Re-seat the attached marker and stop.
        for ownerColor, marks in pairs(G.beautifyCoins or {}) do
            if marks and marks[dname] then
                local ownerPos = PLAYER_POS[ownerColor]
                local dropPos = dropped_object.getPosition()
                if ownerPos and math.sqrt((dropPos.x-ownerPos.x)^2+(dropPos.z-ownerPos.z)^2) < 25 then
                    syncBeautifyCoin(ownerColor, dname, 0.05)
                    return
                end
            end
        end
        -- Bots handle their own builds via explicit onDistrictBuilt calls in botBuildAndEnd.
        -- Suppress onObjectDrop for bot colors (and script-driven "" drops) to prevent
        -- double-builds and deck.deal placement false triggers.
        if isBot(player_color) or player_color == '' then return end
        -- If a borrow/intercept picker is active, ignore table-drop events for this card
        -- to prevent the face-up card settling on the table from triggering a second build.
        if G.cardinalPendingBuild or G.cardinalCardTarget or G.cardinalBuildResuming then return end
        -- Card was already built by the Cardinal borrow flow — ignore all future drops for it
        if G.cardinalBuiltGuids and G.cardinalBuiltGuids[dropped_object.getGUID()] then return end
        -- Tucked Museum cards cannot be built — they are permanently assigned to the Museum
        do
            local droppedGuid = dropped_object.getGUID()
            for _, c in ipairs(G.players or {}) do
                local pile = G.museumCards and G.museumCards[c]
                if pile then
                    for _, g in ipairs(pile) do
                        if g == droppedGuid then
                            logTo(player_color, 'That card is tucked under the Museum and cannot be built.')
                            dropped_object.flip()
                            return
                        end
                    end
                end
            end
        end
        -- Block building while Witch is on hold (has bewitched but not yet resumed)
        if G.witchOnHold and player_color == G.witchColor then
            logTo(player_color, 'You cannot build while your turn is on hold — End Turn and wait for the bewitched character.')
            return
        end
        -- Detect if the card landed inside a hand zone by position.
        -- Seat positions: top/bottom at abs(z)≈27-28, side at abs(x)≈46.
        -- Hand zones extend just beyond those — use 30 (Z) and 48 (X) as thresholds
        -- so legitimate drops anywhere on the table surface are never mis-flagged.
        local pos = dropped_object.getPosition()
        local HAND_ZONE_Z = 30   -- Green sits at z=28.21; 30 clears it safely
        local HAND_ZONE_X = 48   -- Side players sit at x≈±46; 48 clears them safely
        local guid = dropped_object.getGUID()
        G.cardFromHand = G.cardFromHand or {}
        -- Seer returns can be dropped straight into another player's hand zone.
        -- Handle that before the generic hand-zone early-return marks the card
        -- as "from hand" and swallows the drop without decrementing the counter.
        if tryHandleSeerReturn(player_color, dropped_object, pos, guid) then return end
        if math.abs(pos.z) > HAND_ZONE_Z or math.abs(pos.x) > HAND_ZONE_X then
            -- Dropped back into a hand zone — mark as from-hand so the next
            -- time it is pulled out we will still require an explicit table drop.
            G.cardFromHand[guid] = true
            return
        end

        -- ── Seer card-return detection ──
        -- seerMustReturn > 0 means the Seer owes a card back to each other player.
        -- Detect a drop near ANY other player's area and route the card to their hand zone.
        if tryHandleSeerReturn(player_color, dropped_object, pos, guid) then return end
        if (G.seerMustReturn or 0) > 0 and G.phase == 'TURN' and player_color == G.currentColor
           and G.currentChar == GUID.seer then
            for _, otherColor in ipairs(G.players) do
                if otherColor ~= player_color then
                    local op = PLAYER_POS[otherColor]
                    local hp = HAND_POS[otherColor]
                    -- Accept drop in the player's general area or directly in their hand zone
                    local nearArea = op and math.sqrt((pos.x-op.x)^2+(pos.z-op.z)^2) < 20
                    local nearHand = hp and math.sqrt((pos.x-hp.x)^2+(pos.z-hp.z)^2) < 18
                    if nearArea or nearHand then
                            -- Card dropped near this player — route to their hand zone
                            if hp then
                                local faceZ = (G.bots and G.bots[otherColor]) and 0 or 180
                                pcall(function()
                                    dropped_object.setRotation({0,0,faceZ})
                                    dropped_object.setPosition({x=hp.x, y=hp.y+4, z=hp.z})
                                    Wait.time(function()
                                        pcall(function() dropped_object.setPosition(hp) end)
                                    end, 0.1)
                                end)
                            end
                            G.seerMustReturn = G.seerMustReturn - 1
                            if G.seerMustReturn > 0 then
                                logTo(player_color, 'SEER: Card returned to '..otherColor..'. '..G.seerMustReturn..' more card(s) to return.')
                            else
                                logTo(player_color, 'SEER: All cards returned. You may now End Turn.')
                                scheduleAutoEndTurnCheck(player_color, 0.15)
                            end
                            return
                    end
                end
            end
        end

        -- ── Discard-back detection (before cardFromHand guard, any orientation) ──
        -- mustDiscard > 0 means the player owes a card back to the deck.
        -- Cards from hand are face-up in TTS, so we check proximity NOT orientation.
        -- This must run before the cardFromHand guard or the flag swallows the drop.
        if G.labPending and not G.labPendingDiscarded and G.phase == 'TURN' and player_color == G.currentColor then
            local deck = getObjectFromGUID(GUID.districtCards)
            if deck then
                local dp = deck.getPosition()
                local distToDeck = math.sqrt((pos.x-dp.x)^2+(pos.z-dp.z)^2)
                if distToDeck < 10 then
                    G.cardFromHand[guid] = nil
                    G.labPendingDiscarded = true
                    G.labPendingCardName  = dname
                    discardToBottom(dropped_object)
                    logTo(player_color, 'LABORATORY: '..dname..' staged for discard. Click the Laboratory button again to gain 2 gold.')
                    refreshUniqueAbilityButton(player_color)
                    return
                end
            end
        end

        if (G.mustDiscard or 0) > 0 and G.phase == 'TURN' and player_color == G.currentColor then
            local deck = getObjectFromGUID(GUID.districtCards)
            if deck then
                local dp = deck.getPosition()
                local distToDeck = math.sqrt((pos.x-dp.x)^2+(pos.z-dp.z)^2)
                if distToDeck < 10 then
                    G.cardFromHand[guid] = nil
                    discardToBottom(dropped_object)
                    G.mustDiscard = G.mustDiscard - 1
                    if G.mustDiscard > 0 then
                        if G.mustDiscardShuffle then
                            logTo(player_color, 'Card returned to deck. Still need to return '..G.mustDiscard..' more card(s).')
                        else
                            logTo(player_color, 'Card returned to bottom of deck. Still need to discard '..G.mustDiscard..' more card(s).')
                        end
                    else
                        local shouldShuffle = G.mustDiscardShuffle
                        G.mustDiscardShuffle = false
                        local function finishPendingDiscards()
                            if G.witchPendingResume then
                                G.witchPendingResume = false
                                local eW = G.turnOrder[G.turnStep]
                                if eW and G.witchColor then
                                    logTo(player_color, shouldShuffle and 'Scholar returns complete. Witch resumes now.' or 'Discard complete. Witch resumes now.')
                                    Wait.time(function() resumeWitchTurn(eW) end, 0.6)
                                end
                            else
                                if shouldShuffle then
                                    logTo(player_color, 'SCHOLAR: All returned cards have been shuffled back into the district deck. You may now End Turn.')
                                else
                                    logTo(player_color, 'Card returned to bottom of deck. You may now End Turn.')
                                end
                                scheduleAutoEndTurnCheck(player_color, 0.15)
                            end
                        end
                        if shouldShuffle then
                            Wait.time(function()
                                local dd = findDistrictDeck()
                                if dd then pcall(function() dd.shuffle() end) end
                                finishPendingDiscards()
                            end, 0.4)
                        else
                            finishPendingDiscards()
                        end
                    end
                    return
                end
            end
        end

        -- If the card just came from a hand zone, clear the flag and allow
        -- the build to proceed — dropping on the table IS the deliberate intent.
        -- (Dropping back into a hand zone is already caught by the zone-boundary
        --  check above, so no extra guard is needed here.)
        if G.cardFromHand[guid] then
            G.cardFromHand[guid] = nil
        end

        -- Ignore face-down drops that are not near the deck (being passed around)
        local rot = dropped_object.getRotation()
        local faceDown = (math.abs(rot.z - 180) < 45 or math.abs(rot.z + 180) < 45)
        if faceDown then return end

        -- Position guard: card must be dropped in the current player's own area.
        -- Find which player's seat is closest to the drop position.
        if G.phase == 'TURN' then
            local nearestColor, nearestDist = nil, math.huge
            for _, c in ipairs(G.players or {}) do
                local pp = PLAYER_POS[c]
                if pp then
                    local d = math.sqrt((pos.x-pp.x)^2+(pos.z-pp.z)^2)
                    if d < nearestDist then nearestColor = c; nearestDist = d end
                end
            end
            if nearestColor and nearestColor ~= player_color then
                logTo(player_color, 'Build rejected: drop the card near your own area, not '..nearestColor.."'s.")
                dropped_object.flip()
                return
            end
        end

        local buildCost = ddata[1]
        local buildType = ddata[2]

        -- Necropolis intercept: when player drops Necropolis, offer to sacrifice a city
        -- district instead of paying the 5g cost.
        if dname == 'Necropolis'
           and G.phase == 'TURN'
           and player_color == G.currentColor
           and (G.necropolisUsed ~= true)
        then
            local available = {}
            for name,_ in pairs(G.cityNames[player_color] or {}) do
                if name ~= 'Necropolis' then table.insert(available, name) end
            end
            table.sort(available)
            if #available > 0 then
                -- Save pending build so sacrifice handler can resume it
                G.necropolisPendingBuild = {
                    guid  = dropped_object.getGUID(),
                    color = player_color,
                    cost  = buildCost,
                    dtype = buildType,
                    dname = dname,
                }
                G.necropolisPickList = available
                G.targeting = 'necropolis_sacrifice'
                -- Build named buttons for each sacrificeable district + a "Pay normally" option
                local maxSlot = math.min(#available, 7)  -- leave slot 8 for "Pay normally"
                UI.setValue('txtTargetPrompt','NECROPOLIS: Sacrifice a district (free) or pay '..buildCost..'g?')
                for i=1,8 do
                    local bid = 'btnPick'..i
                    if i <= maxSlot then
                        local nm = available[i]
                        local dd = DISTRICT_DATA[nm] or {0,'unknown'}
                        UI.setAttribute(bid,'active','true')
                        UI.setAttribute(bid,'text', nm..' ('..dd[1]..'g)')
                        UI.setAttribute(bid,'color','#CC88FF')
                        UI.setAttribute(bid,'colors','#440077|#7733BB|#220044|#440077')
                    elseif i == maxSlot + 1 then
                        UI.setAttribute(bid,'active','true')
                        UI.setAttribute(bid,'text','💰 Pay '..buildCost..'g normally')
                        UI.setAttribute(bid,'color','#FFD700')
                        UI.setAttribute(bid,'colors','#664400|#AA7700|#443300|#664400')
                    else
                        UI.setAttribute(bid,'active','false')
                    end
                end
                UI.setAttribute('pnlTarget','active','false')
                UI.setAttribute('pnlTargetPlayer','active','true')
                return  -- leave card in city area; build resumes after picker
            end
            -- No districts to sacrifice — fall through to normal 5g build
        end

        -- Thieves' Den intercept: if the player owns Thieves' Den,
        -- can't afford with gold alone, but has cards that could cover the gap,
        -- pause the build and ask how many cards to discard.
        if G.phase == 'TURN'
           and player_color == G.currentColor
           and dname == "Thieves' Den"
           and (G.thievesDenDiscount or 0) == 0   -- not already set
        then
            -- Effective cost after other discounts (Quarry/Factory)
            local effCost = buildCost
            if buildType == 'unique' then
                effCost = adjustedBuildCost(player_color, buildType, buildCost)
            end
            local haveGold = G.gold[player_color] or 0
            if haveGold < effCost then
                -- How many cards does the player have in hand?
                local handSize = 0
                pcall(function()
                    local hobj = Player[player_color]
                    if hobj then handSize = #hobj.getHandObjects() end
                end)
                local goldGap   = effCost - haveGold          -- gold deficit
                local maxDiscard = math.min(handSize, effCost) -- can't discard more than cost
                if maxDiscard >= goldGap then
                    -- Save pending build so we can resume after picker
                    G.thievesDenPendingBuild = {
                        guid     = dropped_object.getGUID(),
                        color    = player_color,
                        cost     = buildCost,
                        dtype    = buildType,
                        dname    = dname,
                    }
                    G.thievesDenGoldGap       = goldGap
                    G.thievesDenSelectedCards = {}
                    G.thievesDenPending       = maxDiscard
                    showThievesDenPicker()
                    -- Leave the card face-up where it is; build will proceed after picker
                    return
                end
                -- Not enough cards either — fall through to normal build (which will fail & flip)
            end
        end

        -- Ensure card is face-up before registering the build
        pcall(function() dropped_object.setRotation({0, dropped_object.getRotation().y, 0}) end)

        local result = onDistrictBuilt({
            color        = player_color,
            cost         = buildCost,
            districtType = buildType,
            districtName = dname,
            droppedGuid  = dropped_object.getGUID(),
        })
        if result then
            -- If this was one of the Wizard's borrowed cards, mark it as handled
            -- so the Done button doesn't try to return it to the target.
            if G.wizardBorrowedGuids then
                local builtGuid = dropped_object.getGUID()
                removeValue(G.wizardBorrowedGuids, builtGuid)
            end
        end
        if not result then
            -- Can't build: flip the card back face-down, UNLESS a borrow/sacrifice
            -- intercept is pending (Cardinal, Necropolis, Thieves' Den) — in those
            -- cases the card must stay face-up so the resumed build can find it.
            if not G.cardinalPendingBuild
               and not G.frameworkPendingBuild
               and not G.necropolisPendingBuild
               and not G.thievesDenPendingBuild then
                dropped_object.flip()
            end
        end
        return
    end

    -- ── Gold coin correction ──────────────────────────────────────────────────
    if dropped_object.getName() ~= 'Gold' then return end
    if not G.players or #G.players == 0 then return end

    local guid = dropped_object.getGUID()

    -- Coins locked by script (e.g. Artist beautify placed on a district card) must not
    -- be re-credited to the player when setPositionSmooth fires onObjectDrop.
    if G.lockedCoins and G.lockedCoins[guid] then return end

    local now  = os.time()
    G.recentDrops    = G.recentDrops    or {}
    G.coinPickedFrom = G.coinPickedFrom or {}

    -- Cooldown: ignore drops within 2 seconds of last credit for this coin
    if G.recentDrops[guid] and (now - G.recentDrops[guid]) < 2 then return end

    local p = dropped_object.getPosition()
    local CREDIT_RADIUS = 12

    -- Find nearest player area to drop position
    local nearest, nearestDist = nil, CREDIT_RADIUS + 1
    for _, color in ipairs(G.players) do
        local pp = PLAYER_POS[color]
        if pp then
            local dist = math.sqrt((p.x-pp.x)^2+(p.z-pp.z)^2)
            if dist < nearestDist then nearest = color; nearestDist = dist end
        end
    end

    -- Check if dropped near bowl
    local bp = bowlPos()
    local distToBowl = math.sqrt((p.x-bp.x)^2+(p.z-bp.z)^2)
    local nearBowl = distToBowl <= (BOWL_RADIUS + 4)

    local fromPlayer = G.coinPickedFrom[guid]  -- which player area it was picked from
    G.coinPickedFrom[guid] = nil               -- consume the pickup record

    if nearest then
        -- Coin dropped in a player area
        if fromPlayer == nearest then
            -- Same player area — no change, just moving within their pile
            return
        elseif fromPlayer then
            -- Moved from one player to another
            G.gold[fromPlayer] = math.max(0, (G.gold[fromPlayer] or 0) - 1)
            G.gold[nearest]    = (G.gold[nearest] or 0) + 1
            G.recentDrops[guid] = now
            updateGoldUI()
            logTo(player_color, 'Gold: -1g '..fromPlayer..' → +1g '..nearest..
                  '. ('..fromPlayer..': '..(G.gold[fromPlayer])..'g, '..nearest..': '..(G.gold[nearest])..'g)')
        else
            -- Fresh from bowl or unknown — credit nearest player
            G.gold[nearest] = (G.gold[nearest] or 0) + 1
            G.recentDrops[guid] = now
            updateGoldUI()
            logTo(player_color, '+1g to '..nearest..'. Total: '..G.gold[nearest]..'g')
        end
    elseif nearBowl then
        -- Returned to bowl
        if fromPlayer then
            G.gold[fromPlayer] = math.max(0, (G.gold[fromPlayer] or 0) - 1)
            G.recentDrops[guid] = now
            updateGoldUI()
            logTo(player_color, '-1g from '..fromPlayer..' (returned to bowl). Total: '..G.gold[fromPlayer]..'g')
        end
    end
end

-- Called when a gold coin leaves a player's area (picked up from their zone).
-- We DON'T deduct gold here because the player might just be moving it within their area.
-- Deduction only happens when the coin lands somewhere new (onObjectDrop handles that).
function onObjectPickUp(player_color, picked_up_object)
    if G.resetting then return end
    if not player_color or player_color == '' then return end
    local name = picked_up_object.getName()
    local guid = picked_up_object.getGUID()

    -- Beautify markers should stay attached to their district until that district is destroyed.
    if name == 'Beautify Gold' then
        local meta = G.beautifyCoinMeta and G.beautifyCoinMeta[guid]
        if meta then syncBeautifyCoin(meta.color, meta.districtName, 0.2) end
        return
    end

    -- Track which player area this gold coin was picked up from
    if name == 'Gold' then
        if not G.players or #G.players == 0 then return end
        G.recentDrops = G.recentDrops or {}
        G.recentDrops[guid] = nil  -- clear cooldown so re-drop registers
        -- If this was a locked beautify coin, unlock it now that a player grabbed it
        if G.lockedCoins and G.lockedCoins[guid] then
            G.lockedCoins[guid] = nil
        end
        local p = picked_up_object.getPosition()
        G.coinPickedFrom = G.coinPickedFrom or {}
        -- Check if it was in a player area
        local CREDIT_RADIUS = 12
        for _, color in ipairs(G.players) do
            local pp = PLAYER_POS[color]
            if pp then
                local dist = math.sqrt((p.x-pp.x)^2+(p.z-pp.z)^2)
                if dist <= CREDIT_RADIUS then
                    G.coinPickedFrom[guid] = color
                    return
                end
            end
        end
        -- Not from a player area (came from bowl or elsewhere)
        G.coinPickedFrom[guid] = nil
    end

    -- Track district cards being picked up from hand zones so we can
    -- ignore the first drop (which may land mid-table while player is still deciding).
    if DISTRICT_DATA and DISTRICT_DATA[name] then
        G.cardFromHand = G.cardFromHand or {}
        -- We can't call isHandObject() here either, but we can check position.
        -- Hand zones are at abs(x or z) > 28.
        local p = picked_up_object.getPosition()
        -- Match onObjectDrop thresholds: Z>30 for top/bottom, X>48 for sides.
        if math.abs(p.z) > 30 or math.abs(p.x) > 48 then
            G.cardFromHand[guid] = true
        else
            G.cardFromHand[guid] = nil
        end
    end
end

-- ============================================================
--  BOT (COMPUTER PLAYER) SYSTEM
--  Bots can be toggled per color in the setup panel.
--  During selection they auto-pick a random character.
--  During their turn they take gold, try to build the best
--  affordable district, then end turn automatically.
-- ============================================================

-- Colors currently assigned as bots (set from UI toggles)
G.bots = G.bots or {}

-- Debug mode toggle handler
function onDebugToggle(player, value, id)
    G.debugMode = (value == 'True')
    if G.debugMode then
        printToAll('⚠️  Debug logging ENABLED — scripting console will reveal secret game info. For testing only!', {1,0.5,0.3})
        log('[DEBUG] Debug mode enabled by '..player.color)
    else
        printToAll('🔧 Debug logging disabled.', {0.8,0.8,0.8})
    end
end

function onAutoEndToggle(player, value, id)
    G.autoEndTurn = (value == 'True')
    if G.autoEndTurn then
        log('Auto-end when no actions remain enabled by '..player.color..'.')
        scheduleAutoEndTurnCheck(G.currentColor, 0.1)
    else
        log('Auto-end when no actions remain disabled by '..player.color..'.')
    end
end

-- Called from UI toggle: mark/unmark a color as a bot
function onBotToggle(player, value, id)
    -- id = e.g. "togBot_Red"
    local color = id:match('togBot_(.+)$')
    if not color then return end
    if value == 'True' then
        G.bots[color] = true
        log('[BOT] '..color..' is now a computer player.')
    else
        G.bots[color] = nil
        log('[BOT] '..color..' is now a human player.')
    end
    -- Sync the in-game panel toggle to match
    pcall(function() UI.setAttribute('togBotG_'..color, 'isOn', value) end)
    if G.setupMode == 'manual' then refreshManualValidation() end
end

-- In-game bot toggle (same logic, also syncs back to setup panel toggle)
function onBotToggleGame(player, value, id)
    local color = id:match('togBotG_(.+)$')
    if not color then return end
    if value == 'True' then
        G.bots[color] = true
        log('[BOT] '..color..' is now a computer player.')
        -- Resume if game is waiting on this player
        if G.phase == 'TURN' and G.currentColor == color then
            Wait.time(function() botDoTurn(color) end, 1.5)
        elseif G.phase == 'SELECTION' then
            local expected = G.selectionOrder and G.selectionOrder[G.selectionStep]
            if expected == color and not G.selectionBusy then
                G.selectionBusy = true
                Wait.time(function() botDoSelection(color) end, 1.5)
            end
        end
    else
        G.bots[color] = nil
        log('[BOT] '..color..' is now a human player.')
    end
    -- Sync the setup panel toggle to match
    pcall(function() UI.setAttribute('togBot_'..color, 'isOn', value) end)
    if G.phase == 'SETUP' and G.setupMode == 'manual' then refreshManualValidation() end
end

-- Show/hide the in-game bot panel and sync toggle states
function onBtnBotsToggle(player)
    local current = UI.getAttribute('pnlBotsGame', 'active')
    if current == 'true' then
        UI.setAttribute('pnlBotsGame', 'active', 'false')
        UI.setValue('btnBotsToggle', '🤖  Manage Bots  ▾')
    else
        -- Sync all toggle states from G.bots before showing
        local colors = {'Red','Green','Blue','White','Pink','Yellow','Orange','Purple'}
        for _, c in ipairs(colors) do
            pcall(function()
                UI.setAttribute('togBotG_'..c, 'isOn', isBot(c) and 'True' or 'False')
            end)
        end
        UI.setAttribute('pnlBotsGame', 'active', 'true')
        UI.setValue('btnBotsToggle', '🤖  Manage Bots  ▴')
    end
end

function isBot(color)
    return G.bots and G.bots[color] == true
end

-- ── Bot selection logic ───────────────────────────────────────────────────
-- Called by advanceSelection when the current chooser is a bot.
-- Picks a random card from G.activeCharGuids, simulates the confirm flow.
function botDoSelection(color)
    if G.resetting then return end
    if #G.activeCharGuids == 0 then return end

    -- Remember the public cards this bot actually saw before making its pick.
    -- Abilities like Witch may use this later as imperfect information, but must
    -- not peek at who secretly took which character.
    G.botSeenChars = G.botSeenChars or {}
    local seen = G.botSeenChars[color]
    if not seen or seen.round ~= G.roundNumber then
        seen = { round = G.roundNumber, guids = {} }
        G.botSeenChars[color] = seen
    end
    for _, guid in ipairs(G.activeCharGuids or {}) do
        seen.guids[guid] = true
    end

    -- Simple heuristic: prefer characters that grant income matching city
    -- For testing purposes, just pick a random available character
    local pick = G.activeCharGuids[math.random(#G.activeCharGuids)]
    local pickName = CHAR_NAME[pick] or '?'

    -- Register choice (same logic as onBtnReady for normal step)
    local isSecondPick = (G.playerCount==2 and G.selectionStep>=3)
                      or (G.playerCount==3 and G.selectionStep>=4)
    if isSecondPick then
        G.chosenBy2[color] = pick
    else
        G.chosenBy[color] = pick
    end
    removeValue(G.activeCharGuids, pick)

    -- Place card face-down near bot's area
    local card = obj(pick)
    local pos  = PLAYER_POS[color]
    if card and pos then
        local isSide = math.abs(pos.x) > 40
        local zOff = isSecondPick and -5.5 or -3.5
        pcall(function()
            card.setRotation(isSide and {0, 90, 180} or {0, 0, 180})
            liftThenPlace(card, {x=pos.x, y=pos.y, z=pos.z+zOff})
        end)
    end

    debugLog('[BOT] '..color..' chose '..pickName..' (step '..G.selectionStep..')')
    printToAll('🤖  '..color..' (Bot) has chosen their character.',{0.7,0.8,1.0})

    -- Handle mid-round discard for 2p/3p rules
    local needsMidDiscard = (G.playerCount==2 and (G.selectionStep==2 or G.selectionStep==3))
                         or (G.playerCount==3 and G.selectionStep==3)
    if needsMidDiscard then
        -- Bot discards a random card face-down
        Wait.time(function()
            if #G.activeCharGuids == 0 then
                G.selectionBusy = false
                Wait.time(function() G.twoPlayerDiscardPending=false; advanceSelection() end, 0.3)
                return
            end
            local discard = G.activeCharGuids[math.random(#G.activeCharGuids)]
            removeValue(G.activeCharGuids, discard)
            local dc = obj(discard)
            if dc then
                pcall(function()
                    dc.setRotation({0,0,180})
                    liftThenPlace(dc, {
                        x=DISCARD_DOWN_POS.x+(math.random()-0.5)*1.5,
                        y=DISCARD_DOWN_POS.y,
                        z=DISCARD_DOWN_POS.z+(math.random()-0.5)*1.5,
                    })
                end)
            end
            G.selectionBusy = false
            G.twoPlayerDiscardPending = false
            Wait.time(advanceSelection, 0.8)
        end, 1.0)
        return
    end

    G.selectionBusy = false
    Wait.time(advanceSelection, 0.8)
end

-- ── Bot turn logic ────────────────────────────────────────────────────────
local function botGetHand(color)
    local hand = {}
    pcall(function()
        local p = Player[color]
        if p then
            for _, c in ipairs(p.getHandObjects()) do
                local n = c.getName() or ''
                local d = DISTRICT_DATA[n]
                if d then table.insert(hand, {name=n, cost=d[1], dtype=d[2], obj=c}) end
            end
        end
    end)
    return hand
end

local function botCountFollowupBuilds(color, hand, chosenCard, goldLeft, buildsLeft, hasQuarry, traderLockedToTrade)
    if buildsLeft <= 0 or goldLeft <= 0 then return 0 end

    local builtNames = {}
    for name, present in pairs(G.cityNames[color] or {}) do
        if present then builtNames[name] = true end
    end
    if chosenCard and chosenCard.name then
        builtNames[chosenCard.name] = true
    end

    local candidates = {}
    for _, card in ipairs(hand) do
        local sameObject = chosenCard and chosenCard.obj and card.obj == chosenCard.obj
        local duplicateBlocked = builtNames[card.name] and not hasQuarry
        local traderBuildAllowed = (not traderLockedToTrade) or card.dtype == 'trade'
        if not sameObject
           and card.name ~= 'Secret Vault'
           and card.name ~= 'Necropolis'
           and not duplicateBlocked
           and traderBuildAllowed then
            local cost = card.cost
            if card.dtype == 'unique' then
                cost = adjustedBuildCost(color, card.dtype, cost)
            end
            table.insert(candidates, {
                name = card.name,
                cost = cost,
                faceValue = card.cost,
                dtype = card.dtype,
            })
        end
    end

    table.sort(candidates, function(a, b)
        if a.cost ~= b.cost then return a.cost < b.cost end
        return a.faceValue > b.faceValue
    end)

    local count = 0
    local gold = goldLeft
    for _, candidate in ipairs(candidates) do
        if count >= buildsLeft then break end
        if candidate.cost <= gold and (not builtNames[candidate.name] or hasQuarry) then
            gold = gold - candidate.cost
            count = count + 1
            builtNames[candidate.name] = true
        end
    end
    return count
end

local function botPickBuild(color, extraGold)
    -- Score legal builds instead of always taking the most expensive one.
    -- Bots should still like strong cards, but when multiple builds are possible,
    -- city tempo and finishing pressure matter more than raw face value.
    local gold = (G.gold[color] or 0) + (extraGold or 0)
    local hand  = botGetHand(color)
    local best  = nil
    local bestScore = -math.huge
    local hasQuarry = hasUnique(color, 'Quarry')
    local traderLockedToTrade = (G.currentChar == GUID.trader and (G.buildCount or 0) >= 1)
    local remainingBuilds = math.max(1, (G.buildLimit or 1) - (G.buildCount or 0))
    local citySize = G.citySize[color] or 0
    local threshold = cityThreshold()
    for _, card in ipairs(hand) do
        -- Respect duplicate-build restrictions unless Quarry explicitly allows it.
        local alreadyBuilt = G.cityNames[color] and G.cityNames[color][card.name]
        local duplicateAllowed = hasQuarry
        local traderBuildAllowed = (not traderLockedToTrade) or card.dtype == 'trade'
        if card.name ~= 'Secret Vault'
           and (not alreadyBuilt or duplicateAllowed)
           and traderBuildAllowed then
            local cost = card.cost
            -- Unique districts can be discounted by the same helper humans use.
            if card.dtype == 'unique' then
                cost = adjustedBuildCost(color, card.dtype, cost)
            end
            if cost <= gold then
                local goldLeft = gold - cost
                local followupBuilds = botCountFollowupBuilds(
                    color, hand, card, goldLeft, remainingBuilds - 1, hasQuarry, traderLockedToTrade
                )
                local score = card.cost * 2

                if citySize + 1 >= threshold then
                    score = score + 40
                elseif citySize + 1 == threshold - 1 then
                    score = score + 16
                elseif citySize + 1 == threshold - 2 then
                    score = score + 8
                end

                if remainingBuilds > 1 then
                    score = score + followupBuilds * 14
                    if followupBuilds == 0 and card.cost >= 4 and cost == gold then
                        score = score - 8
                    end
                end

                if citySize < threshold - 1 and cost <= 2 then
                    score = score + 3
                end

                if card.dtype == 'unique' then
                    score = score + 1
                end

                if not best
                   or score > bestScore
                   or (score == bestScore and cost < best.cost)
                   or (score == bestScore and cost == best.cost and card.cost > (best.faceValue or best.cost)) then
                    bestScore = score
                    best = {
                        name = card.name,
                        cost = cost,
                        faceValue = card.cost,
                        obj = card.obj,
                        dtype = card.dtype,
                    }
                end
            end
        end
    end
    return best
end

local function botPickCardinalBorrowTarget(color, shortfall)
    local best, bestScore = nil, -math.huge
    for _, candidate in ipairs(G.players or {}) do
        local gold = G.gold[candidate] or 0
        if candidate ~= color and gold >= shortfall then
            local score = gold * 3 + (G.cityScore[candidate] or 0) * 1.4 + (G.citySize[candidate] or 0) * 1.2
            if (G.citySize[candidate] or 0) >= cityThreshold() - 1 then
                score = score + 4
            end
            if not best or score > bestScore then
                best = candidate
                bestScore = score
            end
        end
    end
    return best
end

local function botPickCardinalBorrowBuild(color, extraGold)
    if G.currentChar ~= GUID.cardinal or color ~= G.currentColor then return nil end
    if G.witchOnHold or (G.buildLimit or 1) == 0 then return nil end

    local gold = (G.gold[color] or 0) + (extraGold or 0)
    local hand = botGetHand(color)
    local hasQuarry = hasUnique(color, 'Quarry')
    local best = nil
    local bestScore = -math.huge
    local citySize = G.citySize[color] or 0
    local threshold = cityThreshold()

    for _, card in ipairs(hand) do
        local alreadyBuilt = G.cityNames[color] and G.cityNames[color][card.name]
        local duplicateAllowed = hasQuarry
        if card.name ~= 'Secret Vault'
           and card.name ~= 'Necropolis'
           and (not alreadyBuilt or duplicateAllowed) then
            local cost = card.cost
            if card.dtype == 'unique' then
                cost = adjustedBuildCost(color, card.dtype, cost)
            end
            if cost > gold then
                local shortfall = cost - gold
                local gifts = {}
                for _, other in ipairs(hand) do
                    if other.obj ~= card.obj then
                        table.insert(gifts, other)
                    end
                end
                table.sort(gifts, function(a, b)
                    if a.cost ~= b.cost then return a.cost < b.cost end
                    return a.name < b.name
                end)
                if shortfall <= #gifts then
                    local target = botPickCardinalBorrowTarget(color, shortfall)
                    if target then
                        local chosenGifts = {}
                        for i = 1, shortfall do
                            chosenGifts[i] = gifts[i]
                        end
                        local score = card.cost * 2 - shortfall * 4
                        if card.dtype == 'unique' then score = score + 1 end
                        if citySize + 1 >= threshold then
                            score = score + 40
                        elseif citySize + 1 == threshold - 1 then
                            score = score + 16
                        elseif citySize + 1 == threshold - 2 then
                            score = score + 8
                        end
                        if shortfall == 1 then
                            score = score + 3
                        end
                        if not best
                           or score > bestScore
                           or (score == bestScore and shortfall < (best.borrowAmount or math.huge))
                           or (score == bestScore and shortfall == (best.borrowAmount or math.huge) and card.cost > (best.faceValue or 0)) then
                            bestScore = score
                            best = {
                                name = card.name,
                                cost = cost,
                                faceValue = card.cost,
                                obj = card.obj,
                                dtype = card.dtype,
                                useCardinalBorrow = true,
                                borrowTarget = target,
                                borrowAmount = shortfall,
                                giftCards = chosenGifts,
                            }
                        end
                    end
                end
            end
        end
    end
    return best
end

local function botPickAnyBuild(color, extraGold)
    local build = botPickBuild(color, extraGold)
    if build then return build end
    return botPickCardinalBorrowBuild(color, extraGold)
end

local function botPickFrameworkBuild(color)
    if not hasUnique(color, 'Framework') then return nil end
    if G.frameworkMode or G.frameworkResume or G.frameworkPendingBuild then return nil end
    if (G.buildLimit or 0) <= 0 then return nil end
    if (G.buildCount or 0) < (G.buildLimit or 0) then return nil end

    local hand = botGetHand(color)
    local best = nil
    local hasQuarry = hasUnique(color, 'Quarry')
    for _, card in ipairs(hand) do
        local alreadyBuilt = G.cityNames[color] and G.cityNames[color][card.name]
        local duplicateAllowed = hasQuarry
        if card.cost >= 4
           and card.name ~= 'Necropolis'
           and card.name ~= 'Secret Vault'
           and (not alreadyBuilt or duplicateAllowed) then
            if not best or card.cost > best.faceValue then
                best = {
                    name = card.name,
                    cost = 0,
                    faceValue = card.cost,
                    obj = card.obj,
                    dtype = card.dtype,
                    useFramework = true,
                }
            end
        end
    end

    if best and math.random() <= 0.10 then
        return nil
    end
    return best
end

local function botIncomeBoostDistrictType(guid)
    if guid == GUID.king or guid == GUID.emperor then return 'noble' end
    if guid == GUID.bishop or guid == GUID.abbot then return 'religious' end
    if guid == GUID.merchant or guid == GUID.trader then return 'trade' end
    if guid == GUID.warlord or guid == GUID.diplomat or guid == GUID.marshal then return 'military' end
    return nil
end

local function botCurrentIncomeAbilityGold(color, guid)
    local dtype = botIncomeBoostDistrictType(guid)
    if not dtype then return 0 end
    local inc = countDistrictType(color, dtype)
    if guid == GUID.merchant then
        return inc + 1
    end
    return inc
end

local function botPickPreAbilityIncomeBuild(color)
    local guid = G.currentChar
    local boostType = botIncomeBoostDistrictType(guid)
    if not boostType then return nil end
    if G.witchOnHold or (G.buildLimit or 1) == 0 then return nil end

    local goldAfterGather = (G.gold[color] or 0) + (G.hasGathered and 0 or 2)
    local hand = botGetHand(color)
    local hasQuarry = hasUnique(color, 'Quarry')
    local traderLockedToTrade = (guid == GUID.trader and (G.buildCount or 0) >= 1)
    local candidate = nil

    for _, card in ipairs(hand) do
        local alreadyBuilt = G.cityNames[color] and G.cityNames[color][card.name]
        local duplicateAllowed = hasQuarry
        local traderBuildAllowed = (not traderLockedToTrade) or card.dtype == 'trade'
        if card.dtype == boostType
           and card.name ~= 'Secret Vault'
           and card.name ~= 'Necropolis'
           and (not alreadyBuilt or duplicateAllowed)
           and traderBuildAllowed then
            local cost = card.cost
            if card.dtype == 'unique' then
                cost = adjustedBuildCost(color, card.dtype, cost)
            end
            if cost <= goldAfterGather then
                local prefer = false
                if not candidate then
                    prefer = true
                elseif cost < candidate.cost then
                    prefer = true
                elseif cost == candidate.cost and card.cost > (candidate.faceValue or candidate.cost) then
                    prefer = true
                end
                if prefer then
                    candidate = {
                        name = card.name,
                        cost = cost,
                        faceValue = card.cost,
                        obj = card.obj,
                        dtype = card.dtype,
                    }
                end
            end
        end
    end

    if not candidate then return nil end

    local citySize = G.citySize[color] or 0
    local nearFinish = citySize >= cityThreshold() - 1
    local prebuildValue = 1
    if guid == GUID.abbot then
        prebuildValue = 1.25
    elseif guid == GUID.merchant then
        prebuildValue = 1.1
    end
    if nearFinish then
        prebuildValue = prebuildValue + 0.75
    end
    if candidate.cost > (prebuildValue + 1.5) then
        return nil
    end

    local abilityGoldNow = botCurrentIncomeAbilityGold(color, guid)
    local goldIfAbilityFirst = goldAfterGather + abilityGoldNow
    local goldIfPrebuildThenAbility = goldAfterGather - candidate.cost + abilityGoldNow + 1
    for _, card in ipairs(hand) do
        local alreadyBuilt = G.cityNames[color] and G.cityNames[color][card.name]
        local duplicateAllowed = hasQuarry
        local traderBuildAllowed = (not traderLockedToTrade) or card.dtype == 'trade'
        if card.name ~= candidate.name
           and card.name ~= 'Secret Vault'
           and card.name ~= 'Necropolis'
           and (not alreadyBuilt or duplicateAllowed)
           and traderBuildAllowed then
            local otherCost = card.cost
            if card.dtype == 'unique' then
                otherCost = adjustedBuildCost(color, card.dtype, otherCost)
            end
            if otherCost > candidate.cost
               and otherCost <= goldIfAbilityFirst
               and otherCost > goldIfPrebuildThenAbility then
                return nil
            end
        end
    end

    if math.random() <= 0.35 then
        return nil
    end

    return candidate
end

-- Returns the opponent with the biggest city (by score), excluding `color`
local function botBiggestCity(color)
    local best, bestS = nil, -1
    for _, c in ipairs(G.players) do
        if c ~= color and (G.cityScore[c] or 0) > bestS then
            best = c; bestS = G.cityScore[c]
        end
    end
    return best
end

-- Use any available interactive unique district abilities during the bot's turn.
-- Calls onDone() when finished (may be async if multiple abilities chain).
local function botUseUniqueAbilities(color, onDone)
    -- Laboratory: discard cheapest hand card for 2g — do this if bot can't afford anything
    if hasUnique(color, 'Laboratory') and not G.labUsed and not G.labPending then
        local build = botPickAnyBuild(color, 0)
        if not build then
            -- Find cheapest card in hand to throw away
            local hand = botGetHand(color)
            local cheapCard, cheapCost = nil, math.huge
            for _, c in ipairs(hand) do
                if c.cost < cheapCost then cheapCost = c.cost; cheapCard = c end
            end
            if cheapCard then
                G.labUsed = true
                -- Put card back into bottom of deck, gain 2g
                pcall(function()
                    cheapCard.obj.setPosition({x=0, y=3, z=0})  -- escape hand zone
                    Wait.time(function() discardToBottom(cheapCard.obj) end, 0.15)
                end)
                Wait.time(function()
                    giveGold(color, 2)
                    printToAll('🤖  '..color..' (Bot/Laboratory) discarded '..cheapCard.name..' for 2g.',{0.7,0.8,1.0})
                    updateGoldUI()
                    botUseUniqueAbilities(color, onDone)  -- check remaining abilities
                end, 0.5)
                return
            end
        end
    end

    -- Smithy: pay 2g, draw 3 cards — do this if bot has gold but no affordable build
    if hasUnique(color, 'Smithy') and not G.smithyUsed then
        local build = botPickAnyBuild(color, 0)
        if not build and (G.gold[color] or 0) >= 2 then
            G.smithyUsed = true
            takeGold(color, 2)
            local deck = findDistrictDeck()
            if deck then deck.deal(3, color) end
            updateGoldUI()
            printToAll('🤖  '..color..' (Bot/Smithy) paid 2g, drew 3 cards.',{0.7,0.8,1.0})
            Wait.time(function() botUseUniqueAbilities(color, onDone) end, 0.5)
            return
        end
    end

    -- Museum: tuck cheapest hand card for +1 endgame pt (once per turn)
    if hasUnique(color, 'Museum') and not G.museumUsed then
        local hand = botGetHand(color)
        if #hand > 0 then
            G.museumUsed = true
            local cheapCard, cheapCost = nil, math.huge
            for _, c in ipairs(hand) do
                if c.cost < cheapCost then cheapCost = c.cost; cheapCard = c end
            end
            if cheapCard then
                G.museumCards = G.museumCards or {}
                G.museumCards[color] = G.museumCards[color] or {}
                table.insert(G.museumCards[color], cheapCard.obj.getGUID())
                -- Park card near city temporarily; stackMuseumCards will arrange it
                local pp = PLAYER_POS[color]
                pcall(function()
                    if pp then cheapCard.obj.setPosition({x=pp.x, y=pp.y+2, z=pp.z+6}) end
                end)
                printToAll('🤖  '..color..' (Bot/Museum) tucked '..cheapCard.name..' for +1 endgame pt.',{0.7,0.8,1.0})
                stackMuseumCards(color, 0.5)
            end
            Wait.time(function() botUseUniqueAbilities(color, onDone) end, 1.2)
            return
        end
    end

    -- Armory: sacrifice itself to destroy the most valuable district in the biggest
    -- opposing city when that trade is actually favorable.
    if hasUnique(color, 'Armory') and not G.armoryUsed then
        local target = botBiggestCity(color)
        local myScore = G.cityScore[color] or 0
        local theirScore = target and (G.cityScore[target] or 0) or 0
        if target and target ~= G.bishopColor and theirScore > myScore then
            G.armoryUsed = true
            -- Remove Armory from city state
            G.cityNames[color] = G.cityNames[color] or {}
            G.cityNames[color]['Armory'] = nil
            removeCityCompletion(color, 'Armory')
            G.cityScore[color] = math.max(0, (G.cityScore[color] or 0) - 3)
            G.buildTypes[color] = G.buildTypes[color] or {}
            G.buildTypes[color]['unique'] = math.max(0, (G.buildTypes[color]['unique'] or 1) - 1)
            if G.uniqueBuilt and G.uniqueBuilt[color] then G.uniqueBuilt[color]['Armory'] = nil end
            -- Move Armory card to deck
            local ap = PLAYER_POS[color]
            if ap then
                for _, o in ipairs(getAllObjects()) do
                    pcall(function()
                        if o.getName() == 'Armory' then
                            local op = o.getPosition()
                            if math.sqrt((op.x-ap.x)^2+(op.z-ap.z)^2) < 20 then
                                discardToBottom(o)
                            end
                        end
                    end)
                end
            end
            -- Find and destroy the highest-value district in the target's city so the
            -- bot uses Armory as a real swing tool instead of trading down.
            local bestObj2, bestCost2 = nil, -1
            for n, _ in pairs(G.cityNames[target] or {}) do
                local d = DISTRICT_DATA[n]
                local districtCard = findDistrictCardInCity(target, n)
                if d and districtCard and n ~= 'Keep' and d[1] > bestCost2 then
                    bestCost2 = d[1]
                    bestObj2 = districtCard
                end
            end
            if bestObj2 and bestCost2 >= 3 then
                local dname  = bestObj2.getName()
                local dType2 = (DISTRICT_DATA[dname] or {0,'unknown'})[2]
                local prevArmoryTargetScore = G.cityScore[target] or 0
                removeDistrictFromCity(target, dname, bestCost2, dType2)
                discardToBottom(bestObj2)
                printToAll('💥  '..color..' (Bot/Armory) destroys '..dname..' in '..target.."'s city!",{1,0.5,0.3})
                announceScoreChange(target, G.cityScore[target] - prevArmoryTargetScore, 'Armory destroyed '..dname)
            end
            Wait.time(function() botUseUniqueAbilities(color, onDone) end, 0.5)
            return
        end
    end

    -- No more abilities to use — proceed
    onDone()
end

local function botEndTurn(color)
    if G.phase ~= 'TURN' then return end
    if color ~= G.currentColor then return end
    if G.turnAdvancePending or G.roundEnding then return end
    -- Alchemist refund
    if G.currentChar == GUID.alchemist and (G.alchemistGold or 0) > 0 then
        giveGold(color, G.alchemistGold)
        G.alchemistGold = 0
    end
    applyEndOfTurnUniques(color)
    returnSpyCards()  -- return any Spy-revealed cards to the target
    btn('btnGold',false); btn('btnDraw',false); btn('btnEnd',false)
    btn('btnAbility',false); btn('btnAbility2',false); btn('btnUniqueAbility',false)
    log('[BOT] '..color..' ended their turn.')

    -- Witch on-hold: just advance turn (bewitched char will trigger resume)
    if G.witchOnHold and color == G.witchColor then
        G.witchOnHold = false
        scheduleAdvanceTurn(0.6)
        return
    end

    -- Bewitched: this bot was the bewitched player — resume witch's turn
    local e = G.turnOrder and G.turnOrder[G.turnStep]
    if e and e.guid == G.bewitchedChar and G.witchColor then
        resumeWitchTurn(e)
        return
    end

    scheduleAdvanceTurn(0.6)
end

local function botExecuteCardinalBorrowBuild(color, build, onDone)
    local pos = PLAYER_POS[color]
    if not pos or not build or not build.obj or not build.borrowTarget or not build.borrowAmount then
        if onDone then onDone(false) end
        return
    end
    if (G.gold[build.borrowTarget] or 0) < build.borrowAmount then
        if onDone then onDone(false) end
        return
    end

    local citySlot = citySlotForPendingDistrict(color)
    local dest, rot = cityDistrictPlacement(color, citySlot)

    pcall(function()
        build.obj.setLock(true)
        if dest then build.obj.setPosition(dest) end
        if rot then build.obj.setRotation(rot) end
    end)

    Wait.time(function()
        pcall(function() build.obj.setLock(false) end)
        Wait.time(function()
            takeGold(build.borrowTarget, build.borrowAmount)
            giveGold(color, build.borrowAmount)

            local result = onDistrictBuilt({
                color        = color,
                cost         = build.cost,
                districtType = build.dtype,
                districtName = build.name,
            })

            if result then
                local theirHand = HAND_POS[build.borrowTarget] or PLAYER_POS[build.borrowTarget]
                local faceZ = (G.bots and G.bots[build.borrowTarget]) and 0 or 180
                for i, gift in ipairs(build.giftCards or {}) do
                    local giftObj = gift.obj or (gift.guid and getObjectFromGUID(gift.guid))
                    if giftObj and theirHand then
                        local dropPos = {x=theirHand.x, y=theirHand.y+4, z=theirHand.z}
                        Wait.time(function()
                            pcall(function()
                                giftObj.setRotation({0,0,faceZ})
                                giftObj.setPosition(dropPos)
                                Wait.time(function()
                                    pcall(function() giftObj.setPosition(theirHand) end)
                                end, 0.1)
                            end)
                        end, (i-1)*0.15)
                    end
                end
                printToAll('🤖  '..color..' (Bot/Cardinal) borrowed '..build.borrowAmount..'g from '..build.borrowTarget..' and built '..build.name..'!',{0.7,0.8,1.0})
                logTo(color,'[BOT] Cardinal borrowed '..build.borrowAmount..'g from '..build.borrowTarget..' and gave '..build.borrowAmount..' district card(s) to build '..build.name..'.')
                logTo(build.borrowTarget,'Cardinal ('..color..') borrowed '..build.borrowAmount..'g and gave you '..build.borrowAmount..' district card(s).')
            else
                takeGold(color, build.borrowAmount)
                giveGold(build.borrowTarget, build.borrowAmount)
                logTo(color,'[BOT] Cardinal borrow build failed.')
            end

            if onDone then onDone(result) end
        end, 0.4)
    end, 0.3)
end

local function botExecuteBuild(color, build, onDone)
    local pos = PLAYER_POS[color]
    if not pos or not build or not build.obj then
        if onDone then onDone(false) end
        return
    end

    local frameworkCard = nil
    if build.useFramework then
        frameworkCard = findDistrictCardInCity(color, 'Framework')
    end

    local citySlot = citySlotForPendingDistrict(color, frameworkCard)
    local dest, rot = cityDistrictPlacement(color, citySlot)

    pcall(function()
        build.obj.setLock(true)
        if rot then build.obj.setRotation(rot) end
        if dest and not build.useFramework then build.obj.setPosition(dest) end
    end)

    Wait.time(function()
        pcall(function() build.obj.setLock(false) end)
        Wait.time(function()
            local prevFrameworkScore = nil
            if build.useFramework then
                prevFrameworkScore = G.cityScore[color] or 0
                removeDistrictFromCity(color, 'Framework', 3, 'unique')
                if frameworkCard then discardToBottom(frameworkCard) end
                if dest then
                    pcall(function()
                        build.obj.setRotation(rot or build.obj.getRotation())
                        build.obj.setPosition({x=dest.x, y=dest.y + 4, z=dest.z})
                    end)
                end
                G.frameworkResume = true
                G.frameworkMode = true
            end

            local result = onDistrictBuilt({
                color        = color,
                cost         = build.useFramework and 0 or build.cost,
                districtType = build.dtype,
                districtName = build.name,
            })

            if build.useFramework then
                G.frameworkMode = false
                G.frameworkResume = false
            end

            if result and build.useFramework then
                if dest then
                    pcall(function()
                        if rot then build.obj.setRotation(rot) end
                        liftThenPlace(build.obj, dest, 0.05)
                    end)
                else
                    moveDistrictCardToCity(color, build.name, build.obj, 0.05)
                end
            end

            if result and build.useFramework then
                local faceValue = build.faceValue or ((DISTRICT_DATA[build.name] or {0})[1] or 0)
                G.cityScore[color] = (G.cityScore[color] or 0) + faceValue
                if G.cityCosts and G.cityCosts[color] then
                    for i = #G.cityCosts[color], 1, -1 do
                        if G.cityCosts[color][i] == 0 then
                            G.cityCosts[color][i] = faceValue
                            break
                        end
                    end
                end
                announceScoreChange(color, (G.cityScore[color] or 0) - (prevFrameworkScore or 0), 'built '..build.name..' using Framework')
                printToAll('🧱 '..color..' (Bot/Framework) destroyed Framework to build '..build.name..' for free!',{0.8,0.6,1.0})
                logTo(color, '[BOT] Framework built '..build.name..' for free.')
            elseif result then
                printToAll('🤖  '..color..' (Bot) built '..build.name..' ('..build.cost..'g).',{0.7,0.8,1.0})
            end

            if not result and build.useFramework then
                logTo(color, '[BOT] Framework build failed.')
            end
            if onDone then onDone(result) end
        end, 0.4)
    end, 0.3)
end

local function botBuildAndEnd(color)
    -- Build recursively until the bot runs out of legal builds, then end the turn.
    -- This lets Architect / Trader / Scholar / Seer actually spend their extra builds.
    local function finishTurn()
        Wait.time(function() botEndTurn(color) end, 0.4)
    end

    local function executeBuild(build)
        if true then
            if build.useCardinalBorrow then
                return botExecuteCardinalBorrowBuild(color, build, function(result)
                    if result then
                        Wait.time(function()
                            botUseUniqueAbilities(color, function()
                                Wait.time(function() botBuildAndEnd(color) end, 0.2)
                            end)
                        end, 0.2)
                    else
                        finishTurn()
                    end
                end)
            end
            return botExecuteBuild(color, build, function(result)
                if result then
                    Wait.time(function()
                        botUseUniqueAbilities(color, function()
                            Wait.time(function() botBuildAndEnd(color) end, 0.2)
                        end)
                    end, 0.2)
                else
                    finishTurn()
                end
            end)
        end

        -- Legacy inline build path retained only as reference.
        --[[ 
        local pos = PLAYER_POS[color]
        if not pos or not build.obj then
            finishTurn()
            return
        end

        local citySlot = G.citySize[color] or 0
        if build.useFramework then
            citySlot = math.max(0, citySlot - 1)
        end
        local dest, rot = cityDistrictPlacement(color, citySlot)

        pcall(function()
            build.obj.setLock(true)
            if dest then build.obj.setPosition(dest) end
            if rot then build.obj.setRotation(rot) end
        end)

        Wait.time(function()
            pcall(function() build.obj.setLock(false) end)
            Wait.time(function()
                local prevFrameworkScore = nil
                if build.useFramework then
                    local frameworkCard = findDistrictCardInCity(color, 'Framework')
                    prevFrameworkScore = G.cityScore[color] or 0
                    removeDistrictFromCity(color, 'Framework', 3, 'unique')
                    if frameworkCard then discardToBottom(frameworkCard) end
                    G.frameworkResume = true
                    G.frameworkMode = true
                end

                local result = onDistrictBuilt({
                    color        = color,
                    cost         = build.useFramework and 0 or build.cost,
                    districtType = build.dtype,
                    districtName = build.name,
                })

                if build.useFramework then
                    G.frameworkMode = false
                    G.frameworkResume = false
                end

                if result and build.useFramework then
                    local faceValue = build.faceValue or ((DISTRICT_DATA[build.name] or {0})[1] or 0)
                    G.cityScore[color] = (G.cityScore[color] or 0) + faceValue
                    if G.cityCosts and G.cityCosts[color] then
                        for i = #G.cityCosts[color], 1, -1 do
                            if G.cityCosts[color][i] == 0 then
                                G.cityCosts[color][i] = faceValue
                                break
                            end
                        end
                    end
                    announceScoreChange(color, (G.cityScore[color] or 0) - (prevFrameworkScore or 0), 'built '..build.name..' using Framework')
                    printToAll('🧱 '..color..' (Bot/Framework) destroyed Framework to build '..build.name..' for free!',{0.8,0.6,1.0})
                    logTo(color, '[BOT] Framework built '..build.name..' for free.')
                elseif result then
                    printToAll('🤖  '..color..' (Bot) built '..build.name..' ('..build.cost..'g).',{0.7,0.8,1.0})
                end

                if result then
                    Wait.time(function()
                        botUseUniqueAbilities(color, function()
                            Wait.time(function() botBuildAndEnd(color) end, 0.2)
                        end)
                    end, 0.2)
                else
                    if build.useFramework then
                        logTo(color, '[BOT] Framework build failed.')
                    end
                    finishTurn()
                end
            end, 0.4)
        end, 0.3)
        ]]
    end

    -- Witch on-hold: no building allowed, just end turn
    if G.witchOnHold or (G.buildLimit or 1) == 0 then
        finishTurn()
        return
    end

    local build = nil
    local buildLimitReached = (G.buildLimit or 0) > 0 and (G.buildCount or 0) >= (G.buildLimit or 0)
    if buildLimitReached then
        build = botPickFrameworkBuild(color)
    else
        build = botPickAnyBuild(color, 0)
    end
    if build then
        executeBuild(build)
    else
        finishTurn()
    end
end

-- Returns a random opponent color (excluding `color`), or nil if none
local function botRandomOpponent(color)
    local opts = {}
    for _, c in ipairs(G.players) do
        if c ~= color then table.insert(opts, c) end
    end
    if #opts == 0 then return nil end
    return opts[math.random(#opts)]
end

-- Returns the opponent with the most gold, excluding `color`
local function botRichestOpponent(color)
    local best, bestG = nil, -1
    for _, c in ipairs(G.players) do
        if c ~= color and (G.gold[c] or 0) > bestG then
            best = c; bestG = G.gold[c]
        end
    end
    return best, bestG
end

-- Returns a random rank from G.gameCast that belongs to an opponent and isn't the bot
local function botPickTargetRank(color, exclude)
    local opts = {}
    for rank, guid in pairs(G.gameCast or {}) do
        local owner = nil
        for c, g in pairs(G.chosenBy) do if g==guid then owner=c; break end end
        if not owner then for c,g in pairs(G.chosenBy2 or {}) do if g==guid then owner=c; break end end end
        if owner and owner ~= color and (not exclude or guid ~= exclude) and rank ~= 1
           and guid ~= G.killedChar and guid ~= G.bewitchedChar then
            table.insert(opts, {rank=rank, guid=guid, color=owner})
        end
    end
    if #opts == 0 then return nil end
    return opts[math.random(#opts)]
end

local BOT_DISTRICT_TYPES = {'noble','religious','trade','military','unique'}

local function botHandStats(color)
    local stats = {count=0, total=0, bestCost=0, cheapCount=0, duplicateCount=0}
    for _, card in ipairs(botGetHand(color)) do
        stats.count = stats.count + 1
        stats.total = stats.total + card.cost
        if card.cost > stats.bestCost then stats.bestCost = card.cost end
        if card.cost <= 2 then stats.cheapCount = stats.cheapCount + 1 end
        if G.cityNames[color] and G.cityNames[color][card.name] then
            stats.duplicateCount = stats.duplicateCount + 1
        end
    end
    return stats
end

local function botBuildGapStats(color)
    local stats = {bestGap=nil, legalCount=0, nearMissCount=0, cheapLegal=0}
    local gold = G.gold[color] or 0
    local hasQuarry = hasUnique(color, 'Quarry')
    local traderLockedToTrade = (G.currentChar == GUID.trader and (G.buildCount or 0) >= 1)
    for _, card in ipairs(botGetHand(color)) do
        local duplicate = G.cityNames[color] and G.cityNames[color][card.name]
        local traderBuildAllowed = (not traderLockedToTrade) or card.dtype == 'trade'
        if card.name ~= 'Secret Vault'
           and card.name ~= 'Necropolis'
           and traderBuildAllowed
           and (not duplicate or hasQuarry) then
            local cost = card.cost
            if card.dtype == 'unique' then cost = adjustedBuildCost(color, card.dtype, cost) end
            local gap = math.max(0, cost - gold)
            stats.legalCount = stats.legalCount + 1
            if cost <= 2 then stats.cheapLegal = stats.cheapLegal + 1 end
            if gap <= 4 then stats.nearMissCount = stats.nearMissCount + 1 end
            if stats.bestGap == nil or gap < stats.bestGap then
                stats.bestGap = gap
            end
        end
    end
    return stats
end

local function botEstimateBuildValue(color, extraGold)
    local gold = (G.gold[color] or 0) + (extraGold or 0)
    local best = 0
    local hasQuarry = hasUnique(color, 'Quarry')
    for _, card in ipairs(botGetHand(color)) do
        local duplicate = G.cityNames[color] and G.cityNames[color][card.name]
        local cost = card.cost
        if card.dtype == 'unique' then cost = adjustedBuildCost(color, card.dtype, cost) end
        if card.name ~= 'Secret Vault'
           and (not duplicate or hasQuarry)
           and cost <= gold and cost > best then
            best = cost
        end
    end
    return best
end

local function botShouldTakeGoldOnGather(color)
    local buildWithGold = botPickAnyBuild(color, 2)
    if buildWithGold then
        return true
    end

    local handStats = botHandStats(color)
    local gapStats = botBuildGapStats(color)
    if gapStats.legalCount == 0 then
        return false
    end

    local score = 0
    local currentBest = botEstimateBuildValue(color, 0)
    local bestWithGold = botEstimateBuildValue(color, 2)
    local citySize = G.citySize[color] or 0
    local threshold = cityThreshold()

    if bestWithGold > currentBest then
        score = score + 6
    end
    if gapStats.bestGap and gapStats.bestGap <= 3 then
        score = score + 8
    elseif gapStats.bestGap and gapStats.bestGap <= 4 then
        score = score + 5
    end
    if gapStats.nearMissCount >= 2 then
        score = score + 4
    end
    if handStats.cheapCount >= 2 or gapStats.cheapLegal >= 2 then
        score = score + 4
    end
    if handStats.count >= 4 then
        score = score + 2
    end
    if citySize >= threshold - 2 then
        score = score + 6
    end
    if handStats.duplicateCount >= math.max(2, handStats.count - 1) then
        score = score - 6
    end
    if handStats.count <= 1 then
        score = score - 8
    elseif handStats.count == 2 then
        score = score - 3
    end
    if handStats.bestCost >= 5 and handStats.cheapCount == 0 then
        score = score - 2
    end

    return score >= 8
end

local function botRankThreatScore(color, target)
    local owner = target.color
    local score = 0
    score = score + (G.cityScore[owner] or 0) * 3
    score = score + (G.citySize[owner] or 0) * 4
    score = score + (G.gold[owner] or 0) * 1.5
    score = score + botEstimateBuildValue(owner, 0) * 2
    if target.guid == GUID.king or target.guid == GUID.emperor or target.guid == GUID.patrician then score = score + 4 end
    if target.guid == GUID.architect or target.guid == GUID.scholar or target.guid == GUID.navigator then score = score + 6 end
    return score + target.rank
end

local function botBestTargetRank(color, excludeGuid, scorer)
    local best, bestScore = nil, -math.huge
    for rank, guid in pairs(G.gameCast or {}) do
        local owner = nil
        for c, g in pairs(G.chosenBy or {}) do if g == guid then owner = c break end end
        if not owner then
            for c, g in pairs(G.chosenBy2 or {}) do if g == guid then owner = c break end end
        end
        if owner and owner ~= color and rank ~= 1 and guid ~= excludeGuid
           and guid ~= G.killedChar and guid ~= G.bewitchedChar then
            local candidate = {rank=rank, guid=guid, color=owner}
            local score = scorer and scorer(candidate) or botRankThreatScore(color, candidate)
            if score > bestScore then
                best = candidate
                bestScore = score
            end
        end
    end
    return best, bestScore
end

-- Use only public information about the cast when picking a target rank.
-- This avoids bots cheating by looking up who secretly owns each character.
local function botBestPublicRankTarget(excludeGuid, scorer)
    local best, bestScore = nil, -math.huge
    for rank, guid in pairs(G.gameCast or {}) do
        if rank ~= 1 and guid ~= excludeGuid and guid ~= G.killedChar and guid ~= G.bewitchedChar then
            local candidate = {rank=rank, guid=guid}
            local score = scorer and scorer(candidate) or rank
            if score > bestScore then
                best = candidate
                bestScore = score
            end
        end
    end
    return best, bestScore
end

local function botSeenCharSet(color)
    local seen = G.botSeenChars and G.botSeenChars[color]
    if seen and seen.round == G.roundNumber then
        return seen.guids or {}
    end
    return {}
end

-- Pick among the strongest public target ranks, but allow a little randomness
-- inside a narrow score band so Witch does not feel perfectly scripted.
local function botBestPublicRankTargetRandomized(excludeGuid, scorer)
    local candidates = {}
    local topScore = -math.huge
    for rank, guid in pairs(G.gameCast or {}) do
        if rank ~= 1 and guid ~= excludeGuid and guid ~= G.killedChar and guid ~= G.bewitchedChar then
            local candidate = {rank=rank, guid=guid}
            local score = scorer and scorer(candidate) or rank
            candidate.score = score
            table.insert(candidates, candidate)
            if score > topScore then topScore = score end
        end
    end
    if #candidates == 0 then return nil, nil end
    table.sort(candidates, function(a, b)
        if a.score == b.score then return a.rank < b.rank end
        return a.score > b.score
    end)
    local shortlist = {}
    local floorScore = topScore - 4
    for _, candidate in ipairs(candidates) do
        if candidate.score >= floorScore then table.insert(shortlist, candidate) end
    end
    local totalWeight = 0
    for _, candidate in ipairs(shortlist) do
        candidate.weight = math.max(1, math.floor(candidate.score - floorScore + 1))
        totalWeight = totalWeight + candidate.weight
    end
    local roll = math.random(totalWeight)
    local running = 0
    for _, candidate in ipairs(shortlist) do
        running = running + candidate.weight
        if roll <= running then
            return {rank=candidate.rank, guid=candidate.guid}, candidate.score
        end
    end
    local fallback = shortlist[1]
    return fallback and {rank=fallback.rank, guid=fallback.guid} or nil, fallback and fallback.score or nil
end

local function botVisibleRiskFromRankEight(color)
    local risk = 0
    for name, _ in pairs(G.cityNames[color] or {}) do
        local d = DISTRICT_DATA[name]
        if d then
            if d[1] >= 4 then risk = risk + 3 end
            if name == 'Keep' then risk = risk - 4 end
            if name == 'Monument' or name == 'Stables' or name == 'Dragon Gate' or name == 'Town Hall' then
                risk = risk + 2
            end
        end
    end
    if (G.citySize[color] or 0) >= cityThreshold() - 1 then risk = risk + 6 end
    return risk
end

local function botPublicCharacterFitForPlayer(observerColor, playerColor, guid, role)
    local score = 0
    local citySize = G.citySize[playerColor] or 0
    local cityScore = G.cityScore[playerColor] or 0
    local gold = G.gold[playerColor] or 0
    local threshold = cityThreshold()
    local nearFinish = citySize >= threshold - 1
    local closeFinish = citySize >= threshold - 2
    local tradeCount = countDistrictType(playerColor, 'trade')
    local nobleCount = countDistrictType(playerColor, 'noble')
    local religiousCount = countDistrictType(playerColor, 'religious')
    local militaryCount = countDistrictType(playerColor, 'military')
    local myGold = G.gold[observerColor] or 0
    local myRankEightRisk = botVisibleRiskFromRankEight(observerColor)

    score = score + citySize * 1.5 + cityScore * 0.8

    if guid == GUID.architect then
        score = score + gold * 2.4 + citySize * 1.8
        if nearFinish then score = score + 18 elseif closeFinish then score = score + 9 end
    elseif guid == GUID.navigator or guid == GUID.scholar then
        score = score + gold * 0.5 + citySize * 1.2
        if nearFinish then score = score + 15 elseif closeFinish then score = score + 8 end
    elseif guid == GUID.merchant or guid == GUID.trader then
        score = score + tradeCount * 5 + math.max(0, 5 - gold)
    elseif guid == GUID.king or guid == GUID.emperor or guid == GUID.patrician then
        score = score + nobleCount * 5 + citySize
        if guid == GUID.king and role == 'assassin' then score = score - 2 end
    elseif guid == GUID.bishop or guid == GUID.abbot or guid == GUID.cardinal then
        score = score + religiousCount * 4
        if nearFinish then score = score + 4 end
    elseif guid == GUID.warlord or guid == GUID.diplomat or guid == GUID.marshal then
        score = score + militaryCount * 4.5 + myRankEightRisk
        if nearFinish then score = score + 5 end
    elseif guid == GUID.magician or guid == GUID.wizard or guid == GUID.seer then
        score = score + math.max(0, 4 - gold) * 1.8 + math.max(0, 3 - citySize) * 1.2
        if role == 'assassin' and guid == GUID.magician then score = score + 2 end
    elseif guid == GUID.thief then
        score = score + math.max(0, myGold - 2) * 2.5
    elseif guid == GUID.blackmailer then
        score = score + math.max(0, myGold - 2) * 1.8
    elseif guid == GUID.artist then
        score = score + citySize + math.floor(cityScore / 3)
    else
        score = score + citySize + gold * 0.5
    end

    if role == 'witch' then
        if guid == GUID.architect or guid == GUID.scholar or guid == GUID.navigator then score = score + 3 end
        if nearFinish then score = score + 4 end
    elseif role == 'assassin' then
        if guid == GUID.thief and myGold >= 4 then score = score + 5 end
        if guid == GUID.warlord or guid == GUID.diplomat or guid == GUID.marshal then score = score + 2 end
    end

    return score
end

local function botPublicStrategicRankScore(color, candidate, role)
    local seenChars = botSeenCharSet(color)
    local bestFit = -math.huge
    for _, playerColor in ipairs(G.players or {}) do
        if playerColor ~= color then
            local fit = botPublicCharacterFitForPlayer(color, playerColor, candidate.guid, role)
            if fit > bestFit then bestFit = fit end
        end
    end
    if bestFit == -math.huge then bestFit = candidate.rank end
    local score = bestFit + candidate.rank * 0.25
    if seenChars[candidate.guid] then score = score + 3 end
    return score
end

local function botPublicBlackmailerFitForPlayer(observerColor, playerColor, guid)
    local score = botPublicCharacterFitForPlayer(observerColor, playerColor, guid, 'blackmailer')
    local citySize = G.citySize[playerColor] or 0
    local gold = G.gold[playerColor] or 0
    local threshold = cityThreshold()
    local nearFinish = citySize >= threshold - 1
    local closeFinish = citySize >= threshold - 2
    local myGold = G.gold[observerColor] or 0

    score = score + gold * 0.8

    if guid == GUID.architect then
        score = score + 8
        if nearFinish then score = score + 8 elseif closeFinish then score = score + 4 end
    elseif guid == GUID.scholar or guid == GUID.navigator then
        score = score + 6
        if nearFinish then score = score + 6 elseif closeFinish then score = score + 3 end
    elseif guid == GUID.merchant or guid == GUID.trader or guid == GUID.alchemist then
        score = score + 4 + math.max(0, 4 - gold)
    elseif guid == GUID.cardinal or guid == GUID.abbot then
        score = score + 3 + math.max(0, 3 - gold)
    elseif guid == GUID.king or guid == GUID.emperor or guid == GUID.patrician then
        score = score + 3
    elseif guid == GUID.thief then
        score = score + math.max(0, myGold - 2) * 1.8
    elseif guid == GUID.warlord or guid == GUID.diplomat or guid == GUID.marshal then
        score = score + botVisibleRiskFromRankEight(observerColor) * 0.7
    elseif guid == GUID.magician or guid == GUID.wizard or guid == GUID.seer then
        score = score + math.max(0, 3 - gold) * 1.4
    elseif guid == GUID.artist then
        score = score + citySize
    end

    return score
end

local function botPublicBlackmailerRankScore(color, candidate)
    local seenChars = botSeenCharSet(color)
    local bestFit = -math.huge
    for _, playerColor in ipairs(G.players or {}) do
        if playerColor ~= color then
            local fit = botPublicBlackmailerFitForPlayer(color, playerColor, candidate.guid)
            if fit > bestFit then bestFit = fit end
        end
    end
    if bestFit == -math.huge then bestFit = candidate.rank end
    local score = bestFit + candidate.rank * 0.2
    if seenChars[candidate.guid] then score = score + 2.5 end
    return score
end

local function botBlackmailerBluffGroup(guid)
    if guid == GUID.architect or guid == GUID.scholar or guid == GUID.navigator then return 'tempo' end
    if guid == GUID.merchant or guid == GUID.trader or guid == GUID.alchemist
       or guid == GUID.cardinal or guid == GUID.abbot then
        return 'economy'
    end
    if guid == GUID.king or guid == GUID.emperor or guid == GUID.patrician then return 'crown' end
    if guid == GUID.warlord or guid == GUID.diplomat or guid == GUID.marshal or guid == GUID.bishop then
        return 'pressure'
    end
    if guid == GUID.magician or guid == GUID.wizard or guid == GUID.seer then return 'cards' end
    if guid == GUID.thief or guid == GUID.blackmailer then return 'disruption' end
    if guid == GUID.artist or guid == GUID.taxCollector then return 'value' end
    return 'misc'
end

local function botWeightedBlackmailerCandidatePick(candidates, band)
    if #candidates == 0 then return nil end
    local topScore = -math.huge
    for _, candidate in ipairs(candidates) do
        if candidate.score > topScore then topScore = candidate.score end
    end
    local cutoff = topScore - (band or 5)
    local shortlist = {}
    local totalWeight = 0
    for _, candidate in ipairs(candidates) do
        if candidate.score >= cutoff then
            candidate.weight = math.max(1, math.floor(candidate.score - cutoff + 1))
            totalWeight = totalWeight + candidate.weight
            table.insert(shortlist, candidate)
        end
    end
    if #shortlist == 0 then return nil end
    local roll = math.random(totalWeight)
    local running = 0
    for _, candidate in ipairs(shortlist) do
        running = running + candidate.weight
        if roll <= running then return candidate end
    end
    return shortlist[1]
end

local function botBestBlackmailerTargets(color)
    local baseCandidates = {}
    for rank, guid in pairs(G.gameCast or {}) do
        if rank ~= 1 and guid and guid ~= G.killedChar and guid ~= G.bewitchedChar then
            table.insert(baseCandidates, {
                rank = rank,
                guid = guid,
                score = botPublicBlackmailerRankScore(color, {rank=rank, guid=guid}),
            })
        end
    end
    table.sort(baseCandidates, function(a, b)
        if a.score == b.score then return a.rank < b.rank end
        return a.score > b.score
    end)

    local real = botWeightedBlackmailerCandidatePick(baseCandidates, 6)
    if not real then return nil, nil end

    local realGroup = botBlackmailerBluffGroup(real.guid)
    local fakePool = {}
    for _, candidate in ipairs(baseCandidates) do
        if candidate.rank ~= real.rank then
            local decoyScore = candidate.score
            if botBlackmailerBluffGroup(candidate.guid) == realGroup then
                decoyScore = decoyScore + 4
            end
            if math.abs(candidate.rank - real.rank) <= 2 then
                decoyScore = decoyScore + 1.5
            end
            if candidate.score >= real.score - 5 then
                decoyScore = decoyScore + 1
            elseif candidate.score < real.score - 12 then
                decoyScore = decoyScore - 2
            end
            table.insert(fakePool, {
                rank = candidate.rank,
                guid = candidate.guid,
                score = decoyScore,
            })
        end
    end

    local fake = botWeightedBlackmailerCandidatePick(fakePool, 7)
    if not fake then
        for _, candidate in ipairs(baseCandidates) do
            if candidate.rank ~= real.rank then
                fake = {rank=candidate.rank, guid=candidate.guid}
                break
            end
        end
    end
    if not fake then return nil, nil end

    return {rank=real.rank, guid=real.guid}, {rank=fake.rank, guid=fake.guid}
end

-- Magistrate should bluff from public board state only.
-- The real warrant aims at the rank most likely to produce a valuable first build,
-- while blank warrants stay close to other plausible public threats.
local function botPublicMagistrateFitForPlayer(observerColor, playerColor, guid)
    local citySize = G.citySize[playerColor] or 0
    local cityScore = G.cityScore[playerColor] or 0
    local gold = G.gold[playerColor] or 0
    local threshold = cityThreshold()
    local nearFinish = citySize >= threshold - 1
    local closeFinish = citySize >= threshold - 2
    local tradeCount = countDistrictType(playerColor, 'trade')
    local nobleCount = countDistrictType(playerColor, 'noble')
    local religiousCount = countDistrictType(playerColor, 'religious')
    local militaryCount = countDistrictType(playerColor, 'military')
    local uniqueCount = countDistrictType(playerColor, 'unique')
    local score = citySize * 1.9 + cityScore * 0.9 + gold * 1.15

    if nearFinish then
        score = score + 11
    elseif closeFinish then
        score = score + 5
    end

    if guid == GUID.architect then
        score = score + 24 + gold * 1.9 + citySize * 2.3
        if nearFinish then score = score + 14 elseif closeFinish then score = score + 7 end
    elseif guid == GUID.scholar then
        score = score + 18 + gold * 0.9 + citySize * 1.9
        if nearFinish then score = score + 12 elseif closeFinish then score = score + 6 end
    elseif guid == GUID.navigator then
        score = score + 17 + citySize * 1.5
        if gold <= 2 then score = score + 5 end
        if nearFinish then score = score + 10 elseif closeFinish then score = score + 5 end
    elseif guid == GUID.merchant or guid == GUID.trader then
        score = score + 12 + tradeCount * 4.5 + math.max(0, 6 - gold)
    elseif guid == GUID.alchemist then
        score = score + 10 + gold * 1.2 + uniqueCount
    elseif guid == GUID.cardinal then
        score = score + 10 + religiousCount * 3.2 + gold * 1.1
        if nearFinish then score = score + 4 end
    elseif guid == GUID.king or guid == GUID.emperor or guid == GUID.patrician then
        score = score + 9 + nobleCount * 4.2 + citySize
        if nearFinish then score = score + 3 end
    elseif guid == GUID.abbot or guid == GUID.bishop then
        score = score + 7 + religiousCount * 3 + citySize * 0.6
    elseif guid == GUID.magician or guid == GUID.wizard or guid == GUID.seer then
        score = score + 8 + math.max(0, 4 - gold) * 2 + math.max(0, 3 - citySize) * 1.5
    elseif guid == GUID.artist then
        score = score + 6 + citySize * 1.2 + math.floor(cityScore / 4)
    elseif guid == GUID.warlord or guid == GUID.diplomat or guid == GUID.marshal then
        score = score + 6 + militaryCount * 3 + uniqueCount
        if nearFinish then score = score + 2 end
    elseif guid == GUID.thief or guid == GUID.blackmailer then
        score = score + 4 + gold * 0.9
    elseif guid == GUID.taxCollector then
        score = score + 3 + citySize + tradeCount
    else
        score = score + citySize + gold * 0.5
    end

    return score
end

local function botPublicMagistrateRankScore(color, candidate)
    local seenChars = botSeenCharSet(color)
    local bestFit = -math.huge
    for _, playerColor in ipairs(G.players or {}) do
        if playerColor ~= color then
            local fit = botPublicMagistrateFitForPlayer(color, playerColor, candidate.guid)
            if fit > bestFit then bestFit = fit end
        end
    end
    if bestFit == -math.huge then bestFit = candidate.rank end
    local score = bestFit + candidate.rank * 0.2
    if seenChars[candidate.guid] then score = score + 2.5 end
    return score
end

local function botMagistrateBluffGroup(guid)
    if guid == GUID.architect or guid == GUID.scholar or guid == GUID.navigator then return 'tempo' end
    if guid == GUID.merchant or guid == GUID.trader or guid == GUID.alchemist
       or guid == GUID.cardinal or guid == GUID.abbot then
        return 'economy'
    end
    if guid == GUID.king or guid == GUID.emperor or guid == GUID.patrician then return 'crown' end
    if guid == GUID.warlord or guid == GUID.diplomat or guid == GUID.marshal or guid == GUID.bishop then
        return 'pressure'
    end
    if guid == GUID.magician or guid == GUID.wizard or guid == GUID.seer then return 'cards' end
    if guid == GUID.thief or guid == GUID.blackmailer then return 'disruption' end
    if guid == GUID.artist or guid == GUID.taxCollector then return 'value' end
    return 'misc'
end

local function botWeightedPublicCandidatePick(candidates, band)
    if #candidates == 0 then return nil end
    local topScore = -math.huge
    for _, candidate in ipairs(candidates) do
        if candidate.score > topScore then topScore = candidate.score end
    end
    local cutoff = topScore - (band or 5)
    local shortlist = {}
    local totalWeight = 0
    for _, candidate in ipairs(candidates) do
        if candidate.score >= cutoff then
            candidate.weight = math.max(1, math.floor(candidate.score - cutoff + 1))
            totalWeight = totalWeight + candidate.weight
            table.insert(shortlist, candidate)
        end
    end
    if #shortlist == 0 then return nil end
    local roll = math.random(totalWeight)
    local running = 0
    for _, candidate in ipairs(shortlist) do
        running = running + candidate.weight
        if roll <= running then return candidate end
    end
    return shortlist[1]
end

local function botPublicTheaterFitForPlayer(observerColor, playerColor, guid)
    local score = botPublicCharacterFitForPlayer(observerColor, playerColor, guid, 'theater')
    local citySize = G.citySize[playerColor] or 0
    local cityScore = G.cityScore[playerColor] or 0
    local gold = G.gold[playerColor] or 0
    local threshold = cityThreshold()
    local nearFinish = citySize >= threshold - 1
    local closeFinish = citySize >= threshold - 2
    local tradeCount = countDistrictType(playerColor, 'trade')
    local nobleCount = countDistrictType(playerColor, 'noble')
    local religiousCount = countDistrictType(playerColor, 'religious')
    local militaryCount = countDistrictType(playerColor, 'military')
    local _, richestGold = botRichestOpponent(playerColor)
    richestGold = richestGold or 0

    if guid == GUID.assassin then
        score = score + 9 + cityScore * 0.25
        if nearFinish then score = score + 5 elseif closeFinish then score = score + 2 end
    elseif guid == GUID.witch then
        score = score + 10 + citySize
        if nearFinish then score = score + 6 elseif closeFinish then score = score + 3 end
    elseif guid == GUID.magistrate then
        score = score + 11 + citySize * 1.1 + gold * 0.8
    elseif guid == GUID.architect then
        score = score + 10 + gold * 1.5 + citySize * 1.4
        if nearFinish then score = score + 8 elseif closeFinish then score = score + 4 end
    elseif guid == GUID.scholar or guid == GUID.navigator then
        score = score + 8 + citySize * 0.9
        if nearFinish then score = score + 6 elseif closeFinish then score = score + 3 end
    elseif guid == GUID.merchant or guid == GUID.trader then
        score = score + tradeCount * 2.2
    elseif guid == GUID.king or guid == GUID.emperor or guid == GUID.patrician then
        score = score + nobleCount * 2.0 + citySize * 0.5
    elseif guid == GUID.bishop or guid == GUID.abbot or guid == GUID.cardinal then
        score = score + religiousCount * 1.8
    elseif guid == GUID.warlord or guid == GUID.diplomat or guid == GUID.marshal then
        score = score + militaryCount * 1.8
    elseif guid == GUID.thief then
        score = score + richestGold * 1.6
    elseif guid == GUID.blackmailer then
        score = score + richestGold * 1.2
    elseif guid == GUID.taxCollector then
        score = score + (G.taxGold or 0) * 1.4 + citySize * 0.6
    end

    return score
end

local function botLikelyTheaterCharsForTarget(ownerColor, targetColor, ownerGuidSet)
    local seenChars = botSeenCharSet(ownerColor)
    local targetCount = ((G.chosenBy2 and G.chosenBy2[targetColor]) and 2) or 1
    local candidates = {}

    for rank, guid in pairs(G.gameCast or {}) do
        if guid and not ownerGuidSet[guid] then
            local score = botPublicTheaterFitForPlayer(ownerColor, targetColor, guid) + rank * 0.1
            if seenChars[guid] then score = score + 2.5 end
            table.insert(candidates, {
                rank = rank,
                guid = guid,
                score = score,
            })
        end
    end

    table.sort(candidates, function(a, b)
        if a.score == b.score then return a.rank < b.rank end
        return a.score > b.score
    end)

    local likely = {}
    for i = 1, math.min(targetCount, #candidates) do
        table.insert(likely, candidates[i])
    end
    return likely
end

-- Theater bots infer likely target hands from public board state and the cards
-- they personally saw during draft; they never read opponents' hidden picks.
botBestFairTheaterSwap = function(ownerColor)
    local ownChoices = {}
    local ownerGuidSet = {}
    if G.chosenBy and G.chosenBy[ownerColor] then
        table.insert(ownChoices, {guid = G.chosenBy[ownerColor]})
        ownerGuidSet[G.chosenBy[ownerColor]] = true
    end
    if G.chosenBy2 and G.chosenBy2[ownerColor] then
        table.insert(ownChoices, {guid = G.chosenBy2[ownerColor]})
        ownerGuidSet[G.chosenBy2[ownerColor]] = true
    end
    if #ownChoices == 0 then return nil end

    local plans = {}
    for _, own in ipairs(ownChoices) do
        local giveSelfValue = botPublicTheaterFitForPlayer(ownerColor, ownerColor, own.guid)
        for _, targetColor in ipairs(G.players or {}) do
            if targetColor ~= ownerColor and G.chosenBy and G.chosenBy[targetColor] then
                local likely = botLikelyTheaterCharsForTarget(ownerColor, targetColor, ownerGuidSet)
                if #likely > 0 then
                    local receiveValue = 0
                    local denyValue = 0
                    for _, candidate in ipairs(likely) do
                        receiveValue = receiveValue + botPublicTheaterFitForPlayer(ownerColor, ownerColor, candidate.guid)
                        denyValue = denyValue + botPublicTheaterFitForPlayer(ownerColor, targetColor, candidate.guid)
                    end
                    receiveValue = receiveValue / #likely
                    denyValue = denyValue / #likely

                    local targetGiftFit = botPublicTheaterFitForPlayer(ownerColor, targetColor, own.guid)
                    local denyWeight = (#likely > 1) and 0.28 or 0.45
                    local score = receiveValue
                        - giveSelfValue * 0.78
                        + denyValue * denyWeight
                        - targetGiftFit * 0.18

                    local targetSize = G.citySize[targetColor] or 0
                    if targetSize >= cityThreshold() - 1 then
                        score = score + 4
                    elseif targetSize >= cityThreshold() - 2 then
                        score = score + 2
                    end
                    if (G.cityScore[targetColor] or 0) > (G.cityScore[ownerColor] or 0) then
                        score = score + 1.5
                    end
                    if (G.gold[targetColor] or 0) >= 6 then
                        score = score + 1.0
                    end

                    table.insert(plans, {
                        targetColor = targetColor,
                        ownerGuid = own.guid,
                        score = score,
                    })
                end
            end
        end
    end

    local picked = botWeightedPublicCandidatePick(plans, 4)
    if picked and picked.score and picked.score > 3 then
        return {
            targetColor = picked.targetColor,
            ownerGuid = picked.ownerGuid,
            score = picked.score,
        }
    end
    return nil
end

local function botBestMagistrateTargets(color)
    local baseCandidates = {}
    for rank, guid in pairs(G.gameCast or {}) do
        if rank ~= 1 and guid and guid ~= G.killedChar and guid ~= G.bewitchedChar then
            table.insert(baseCandidates, {
                rank = rank,
                guid = guid,
                score = botPublicMagistrateRankScore(color, {rank=rank, guid=guid}),
            })
        end
    end
    table.sort(baseCandidates, function(a, b)
        if a.score == b.score then return a.rank < b.rank end
        return a.score > b.score
    end)

    local real = botWeightedPublicCandidatePick(baseCandidates, 6)
    if not real then return nil, {} end

    local realGroup = botMagistrateBluffGroup(real.guid)
    local blanksPool = {}
    for _, candidate in ipairs(baseCandidates) do
        if candidate.rank ~= real.rank then
            local decoyScore = candidate.score
            if botMagistrateBluffGroup(candidate.guid) == realGroup then
                decoyScore = decoyScore + 5
            end
            if math.abs(candidate.rank - real.rank) <= 2 then
                decoyScore = decoyScore + 1.5
            end
            if candidate.score < real.score - 10 then
                decoyScore = decoyScore - 2
            end
            table.insert(blanksPool, {
                rank = candidate.rank,
                guid = candidate.guid,
                score = decoyScore,
            })
        end
    end

    local blankRanks = {}
    local chosen = {}
    for pickIndex = 1, 2 do
        local available = {}
        for _, candidate in ipairs(blanksPool) do
            if not chosen[candidate.rank] then
                local score = candidate.score
                if pickIndex == 2 and #blankRanks == 1 and math.abs(candidate.rank - blankRanks[1]) <= 2 then
                    score = score + 1
                end
                table.insert(available, {
                    rank = candidate.rank,
                    guid = candidate.guid,
                    score = score,
                })
            end
        end
        local picked = botWeightedPublicCandidatePick(available, 7)
        if not picked then break end
        chosen[picked.rank] = true
        table.insert(blankRanks, picked.rank)
    end

    if #blankRanks < 2 then
        for _, candidate in ipairs(baseCandidates) do
            if candidate.rank ~= real.rank and not chosen[candidate.rank] then
                chosen[candidate.rank] = true
                table.insert(blankRanks, candidate.rank)
                if #blankRanks >= 2 then break end
            end
        end
    end

    return {rank=real.rank, guid=real.guid}, blankRanks
end

local function botDistrictPressureScore(ownerColor, name, cost, dtype)
    local score = cost * 4
    if dtype == 'unique' then score = score + 4 end
    if (G.citySize[ownerColor] or 0) >= cityThreshold() - 1 then score = score + 10 end
    if name == 'Keep' then score = score - 100 end
    if name == 'Monument' or name == 'Stables' then score = score + 5 end
    if G.beautified and G.beautified[ownerColor] and G.beautified[ownerColor][name] then score = score + 2 end
    return score
end

local function botBestWarlordTarget(color)
    local best = nil
    local bestScore = 0
    for targetColor, city in pairs(G.cityNames or {}) do
        if targetColor ~= color and targetColor ~= G.bishopColor and (G.citySize[targetColor] or 0) < cityThreshold() then
            for name, _ in pairs(city or {}) do
                local d = DISTRICT_DATA[name]
                local districtCard = findDistrictCardInCity(targetColor, name)
                if d and districtCard and name ~= 'Keep' then
                    local hasGreatWall = hasUnique and hasUnique(targetColor, 'Great Wall')
                    local destroyCost = math.max(0, d[1] - 1 + (hasGreatWall and 2 or 0))
                    if destroyCost <= (G.gold[color] or 0) then
                        local score = botDistrictPressureScore(targetColor, name, d[1], d[2]) - destroyCost * 2
                        if score > bestScore then
                            bestScore = score
                            best = {targetColor=targetColor, name=name, cost=d[1], dtype=d[2], destroyCost=destroyCost, card=districtCard}
                        end
                    end
                end
            end
        end
    end
    return best, bestScore
end

local function botBestDiplomatSwap(color)
    local best = nil
    local bestScore = 0
    for targetColor, city in pairs(G.cityNames or {}) do
        if targetColor ~= color and targetColor ~= G.bishopColor and next(city or {}) and next(G.cityNames[color] or {}) then
            for myName, _ in pairs(G.cityNames[color] or {}) do
                local myData = DISTRICT_DATA[myName]
                if myData then
                    for theirName, _ in pairs(city or {}) do
                        local theirData = DISTRICT_DATA[theirName]
                        if theirData and theirName ~= 'Keep' and theirData[1] > myData[1]
                           and not (G.cityNames[color] and G.cityNames[color][theirName]) then
                            local diff = math.max(0, theirData[1] - myData[1])
                            if diff <= (G.gold[color] or 0) then
                                local score = botDistrictPressureScore(targetColor, theirName, theirData[1], theirData[2])
                                    - botDistrictPressureScore(color, myName, myData[1], myData[2]) * 0.6
                                    - diff * 2
                                if score > bestScore then
                                    bestScore = score
                                    best = {
                                        targetColor=targetColor,
                                        myDist=myName, myCost=myData[1], myType=myData[2],
                                        theirDist=theirName, theirCost=theirData[1], theirType=theirData[2],
                                        diff=diff
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return best, bestScore
end

local function botBestMarshalTarget(color)
    local best = nil
    local bestScore = 0
    for targetColor, city in pairs(G.cityNames or {}) do
        if targetColor ~= color and targetColor ~= G.bishopColor and (G.citySize[targetColor] or 0) < cityThreshold() then
            for name, _ in pairs(city or {}) do
                local d = DISTRICT_DATA[name]
                if d and name ~= 'Keep' and d[1] <= 3 and d[1] <= (G.gold[color] or 0)
                   and not (G.cityNames[color] and G.cityNames[color][name]) then
                    local score = botDistrictPressureScore(targetColor, name, d[1], d[2]) - d[1] * 1.5
                    if score > bestScore then
                        bestScore = score
                        best = {targetColor=targetColor, name=name, cost=d[1], dtype=d[2]}
                    end
                end
            end
        end
    end
    return best, bestScore
end

-- Simulate the rank-picker selection for bot
local function botSimulateRankPick(color, rank, mode)
    -- Guard: if the turn has already moved on, do nothing.
    -- Wait.time callbacks (e.g. 0.4s fake blackmail pick) can fire during a different
    -- player's turn if the bot's turn ends faster than expected.
    if G.currentColor ~= color then return end
    -- Build a fake player-like table and call the rank handler directly
    local fakePlayer = { color = color }
    G.targeting = mode   -- set targeting mode so handleRankPick routes correctly
    handleRankPick(fakePlayer, rank)
end

-- Simulate the player-picker selection for bot
local function botSimulatePlayerPick(color, targetColor, mode)
    -- Find the index of targetColor in targetPlayerList
    for i, c in ipairs(G.targetPlayerList or {}) do
        if c == targetColor then
            local fakePlayer = { color = color }
            G.targeting = mode
            handleRankPick(fakePlayer, i)
            return true
        end
    end
    return false
end

-- ── Full per-character bot ability logic ─────────────────────────────────
-- Returns the delay (seconds) the bot turn logic should wait after this
-- before proceeding to gather/build. Most abilities are instant (0.3s).
-- Abilities that involve async UI flows return a longer delay.
local function botDoCharacterAbility(color, onDone)
    local guid = G.currentChar
    if G.abilityUsed then onDone(); return end
    G.abilityUsed = true

    -- ── Rank 1 ──
    if guid == GUID.assassin then
        -- Infer the most valuable hidden target from public board state and visible draft info.
        local target = botBestPublicRankTargetRandomized(nil, function(candidate)
            return botPublicStrategicRankScore(color, candidate, 'assassin')
        end)
        if target then
            G.killedChar = target.guid
            printToAll('💀  '..color..' (Bot/Assassin) kills rank '..target.rank..' ('..CHAR_NAME[target.guid]..')!',{0.8,0.3,0.3})
            logTo(color, '[BOT] Assassin killed rank '..target.rank..'.')
        else
            logTo(color, '[BOT] Assassin: explicit pass (no legal target).')
        end
        Wait.time(onDone, 0.4)

    elseif guid == GUID.witch then
        -- Witch uses the same public-info inference model, with extra weight on acceleration.
        local target = botBestPublicRankTargetRandomized(nil, function(candidate)
            return botPublicStrategicRankScore(color, candidate, 'witch')
        end)
        if target then
            G.bewitchedChar = target.guid
            G.witchColor = color
            G.witchOnHold = true   -- witch cannot build until she resumes
            G.buildLimit  = 0      -- no building while on hold
            printToAll('🧙  '..color..' (Bot/Witch) bewitches rank '..target.rank..'!',{0.7,0.4,1.0})
        else
            logTo(color, '[BOT] Witch: explicit pass (no legal target).')
        end
        Wait.time(onDone, 0.4)

    elseif guid == GUID.magistrate and botBestMagistrateTargets then
        -- Magistrate now bluffs from public board-state inference only.
        local target, blankRanks = botBestMagistrateTargets(color)
        if target and blankRanks and #blankRanks >= 2 then
            G.magistrateColor = color
            G.warrantBuilds   = {}

            -- Simulate the exact same three rank-picker clicks a human would make.
            botSimulateRankPick(color, target.rank,       'magistrate_warrant')
            Wait.time(function()
                botSimulateRankPick(color, blankRanks[1], 'magistrate_blank1')
                Wait.time(function()
                    botSimulateRankPick(color, blankRanks[2], 'magistrate_blank2')
                end, 0.3)
            end, 0.3)
        else
            logTo(color, '[BOT] Magistrate: explicit pass (no legal target).')
        end
        Wait.time(onDone, 1.5)

    elseif false and guid == GUID.magistrate then -- legacy hidden-info Magistrate path kept only as reference
        -- Pick real target + 2 distinct blank ranks, then simulate the three rank-picker steps
        local target = botBestTargetRank(color, nil, function(candidate)
            return botRankThreatScore(color, candidate) + botEstimateBuildValue(candidate.color, 0) * 2
        end)
        if target then
            G.magistrateColor = color
            G.warrantBuilds   = {}

            -- Collect up to 2 blank ranks (occupied, ≠ rank 1, ≠ target, ≠ each other)
            local blankRanks = {}
            local usedRanks  = { [target.rank]=true, [1]=true }
            for rank = 2, 9 do
                if #blankRanks >= 2 then break end
                if not usedRanks[rank] and G.gameCast[rank] then
                    table.insert(blankRanks, rank)
                    usedRanks[rank] = true
                end
            end
            -- Fall back: if fewer than 2 blank ranks found, reuse target rank
            while #blankRanks < 2 do table.insert(blankRanks, target.rank) end

            -- Simulate the exact same three rank-picker clicks a human would make
            botSimulateRankPick(color, target.rank,       'magistrate_warrant')
            Wait.time(function()
                botSimulateRankPick(color, blankRanks[1], 'magistrate_blank1')
                Wait.time(function()
                    botSimulateRankPick(color, blankRanks[2], 'magistrate_blank2')
                end, 0.3)
            end, 0.3)
        else
            logTo(color, '[BOT] Magistrate: explicit pass (no legal target).')
        end
        Wait.time(onDone, 1.5)

    -- ── Rank 2 ──
    elseif guid == GUID.thief then
        -- Rob the richest-city opponent's rank
        local target = botBestTargetRank(color, G.killedChar, function(candidate)
            return botRankThreatScore(color, candidate) + (G.gold[candidate.color] or 0) * 2
        end)
        if target then
            G.robbedChar = target.guid
            G.thiefColor = color
            printToAll('💰  '..color..' (Bot/Thief) targets rank '..target.rank..'.',{1,0.8,0.2})
        else
            logTo(color, '[BOT] Thief: explicit pass (no legal target).')
        end
        Wait.time(onDone, 0.4)

    elseif guid == GUID.blackmailer then
        -- Pick a strong real target and a plausible fake target using public
        -- board-state inference only, with a little randomness in both picks.
        G.blackmailerColor = color
        G.blackmailTargets = {}
        local real, fake = botBestBlackmailerTargets(color)
        if real and fake and real.rank ~= fake.rank then
            -- Simulate blackmail_real pick, then blackmail_fake pick
            botSimulateRankPick(color, real.rank, 'blackmail_real')
            Wait.time(function()
                botSimulateRankPick(color, fake.rank, 'blackmail_fake')
            end, 0.4)
        else
            logTo(color, '[BOT] Blackmailer: explicit pass (not enough legal targets).')
        end
        Wait.time(onDone, 1.5)

    elseif guid == GUID.spy then
        -- Spy on the player/type pair with the best immediate payoff.
        local opp, dtype, matches, bestScore = nil, 'trade', 0, -math.huge
        for _, candidateColor in ipairs(G.players or {}) do
            if candidateColor ~= color then
                for _, candidateType in ipairs(BOT_DISTRICT_TYPES) do
                    local candidateMatches = G.buildTypes[candidateColor] and G.buildTypes[candidateColor][candidateType] or 0
                    local score = candidateMatches * 8 + botEstimateBuildValue(color, candidateMatches) * 2
                    if score > bestScore then
                        opp = candidateColor
                        dtype = candidateType
                        matches = candidateMatches
                        bestScore = score
                    end
                end
            end
        end
        if opp then
            G.spyData = { color=color }
            if matches > 0 then giveGold(color, matches) end
            printToAll('🕵  '..color..' (Bot/Spy) spied on '..opp..'.',{0.7,0.9,0.7})
            logTo(color, '[BOT] Spy gained '..matches..'g from '..opp.."'s "..dtype..' districts.')
        else
            logTo(color, '[BOT] Spy: explicit pass (no legal target).')
        end
        Wait.time(onDone, 0.4)

    -- ── Rank 3 ──
    elseif guid == GUID.magician then
        -- Swap only when another hand is materially better.
        local best, bestGain = nil, 0
        local myStats = botHandStats(color)
        for _, c in ipairs(G.players or {}) do
            if c ~= color then
                local theirStats = botHandStats(c)
                local gain = (theirStats.total - myStats.total) + (theirStats.count - myStats.count) * 2 + (theirStats.bestCost - myStats.bestCost) * 2
                if gain > bestGain then best = c; bestGain = gain end
            end
        end
        if best and bestGain >= 4 then
            -- Swap hands
            local myHand, theirHand = {}, {}
            pcall(function()
                local pm = Player[color]; if pm then myHand = pm.getHandObjects() end
                local pt = Player[best];  if pt then theirHand = pt.getHandObjects() end
            end)
            local myHP    = HAND_POS[color]
            local theirHP = HAND_POS[best]
            local faceMe   = (G.bots and G.bots[color]) and 0 or 180
            local faceThem = (G.bots and G.bots[best])  and 0 or 180
            for i, card in ipairs(myHand) do
                local ci, c = i, card
                Wait.time(function()
                    pcall(function()
                        if theirHP then
                            c.setRotation({0,0,faceThem})
                            c.setPosition({x=theirHP.x,y=theirHP.y+4,z=theirHP.z})
                            Wait.time(function() pcall(function() c.setPosition(theirHP) end) end, 0.1)
                        end
                    end)
                end, (ci-1)*0.1)
            end
            for i, card in ipairs(theirHand) do
                local ci, c = i, card
                Wait.time(function()
                    pcall(function()
                        if myHP then
                            c.setRotation({0,0,faceMe})
                            c.setPosition({x=myHP.x,y=myHP.y+4,z=myHP.z})
                            Wait.time(function() pcall(function() c.setPosition(myHP) end) end, 0.1)
                        end
                    end)
                end, (ci-1)*0.1)
            end
            printToAll('🔮  '..color..' (Bot/Magician) swaps hands with '..best..'!',{0.7,0.7,1.0})
        else
            -- Use discard-and-draw when the hand has low-value or duplicate cards.
            local hand = botGetHand(color)
            local protected = botPickBuild(color)
            local discardList = {}
            local used = {}
            for _ = 1, math.min(2, #hand) do
                local worst, worstScore = nil, math.huge
                for _, card in ipairs(hand) do
                    if not used[card.obj.getGUID()] then
                        local score = card.cost
                        if protected and card.name == protected.name then score = score + 50 end
                        if G.cityNames[color] and G.cityNames[color][card.name] then score = score - 3 end
                        if card.cost <= 2 then score = score - 1 end
                        if score < worstScore then
                            worst = card
                            worstScore = score
                        end
                    end
                end
                if worst then
                    used[worst.obj.getGUID()] = true
                    table.insert(discardList, worst)
                end
            end
            if #discardList > 0 then
                for i, card in ipairs(discardList) do
                    local captured = card.obj
                    Wait.time(function()
                        pcall(function()
                            captured.setPosition({x=0, y=3, z=0})
                            Wait.time(function() discardToBottom(captured) end, 0.12)
                        end)
                    end, (i-1) * 0.12)
                end
                local deck = findDistrictDeck()
                if deck then deck.deal(#discardList, color) end
                printToAll('🔮  '..color..' (Bot/Magician) discarded '..#discardList..' card(s) and drew replacements!',{0.7,0.7,1.0})
                logTo(color, '[BOT] Magician used discard-and-draw for '..#discardList..' card(s).')
            else
                logTo(color, '[BOT] Magician: explicit pass (hand already strong).')
            end
        end
        G.abilityUsed = true
        Wait.time(onDone, 0.6)

    elseif guid == GUID.wizard then
        G.wizardFreeBuilds = 1  -- extra build that doesn't count toward the limit
        -- Take the best card available across all opponent hands.
        local wTarget, best, bestScore = nil, nil, -math.huge
        for _, candidateColor in ipairs(G.players or {}) do
            if candidateColor ~= color then
                local hand = Player[candidateColor] and Player[candidateColor].getHandObjects() or {}
                for _, c in ipairs(hand) do
                    local hn = (c.getName() or ''):match('^%s*(.-)%s*$')
                    local d  = DISTRICT_DATA[hn]
                    if d and not (G.cityNames[color] and G.cityNames[color][hn]) then
                        local score = d[1] * 3 + ((d[1] <= (G.gold[color] or 0)) and 4 or 0)
                        if score > bestScore then
                            bestScore = score
                            best = c
                            wTarget = candidateColor
                        end
                    end
                end
            end
        end
        if wTarget then
            if best then
                -- Move card directly into bot's hand zone so botPickBuild finds it
                local hp = HAND_POS[color]
                pcall(function()
                    local p = Player[wTarget]; if p and p.seated then p.removeHandObject(best) end
                end)
                if hp then
                    pcall(function()
                        best.setRotation({0, 0, 0})   -- face-up for bot
                        best.setPosition({x=hp.x, y=hp.y+4, z=hp.z})
                        Wait.time(function() pcall(function() best.setPosition(hp) end) end, 0.1)
                    end)
                else
                    local pp = PLAYER_POS[color]
                    if pp then pcall(function() liftThenPlace(best,{x=pp.x+(math.random()-0.5)*2,y=pp.y,z=pp.z-4}) end) end
                end
                logTo(color, '[BOT] Wizard took '..best.getName()..' from '..wTarget.."'s hand.")
                logTo(wTarget, 'Wizard ('..color..') took a card from your hand.')
                printToAll('🔮  '..color..' (Bot/Wizard) took a card from '..wTarget.."'s hand!",{0.7,0.7,1.0})
            else
                logTo(color, '[BOT] Wizard: no useful card in target hand.')
            end
        else
            logTo(color, '[BOT] Wizard: explicit pass (no legal target).')
        end
        Wait.time(onDone, 0.6)

    elseif guid == GUID.seer then
        G.abilityUsed = true
        -- Step 1: take 1 random district card from each other player
        local targets = {}
        local takenTargets = {}
        local seerTakeSpacing = 0.45
        local seerTransitDelay = 0.18
        local seerSettleDelay = 0.22
        local seerReturnSpacing = 0.35
        for _, c in ipairs(G.players) do
            if c ~= color then table.insert(targets, c) end
        end
        local hp = HAND_POS[color]
        for i, c in ipairs(targets) do
            local ci = i
            Wait.time(function()
                pcall(function()
                    local hand = Player[c] and Player[c].getHandObjects() or {}
                    local districtCards = {}
                    for _, hc in ipairs(hand) do
                        pcall(function()
                            local n = (hc.getName() or ''):match('^%s*(.-)%s*$')
                            local d = DISTRICT_DATA[n]
                            if d then districtCards[#districtCards + 1] = hc end
                        end)
                    end
                    local card = (#districtCards > 0) and districtCards[math.random(#districtCards)] or nil
                    if card and hp then
                        takenTargets[#takenTargets + 1] = c
                        local sourceHP = HAND_POS[c]
                        local sourcePlayer = Player[c]
                        pcall(function()
                            if sourcePlayer then sourcePlayer.removeHandObject(card) end
                        end)
                        card.setRotation({0,0,0})
                        if sourceHP then
                            card.setPosition({x=sourceHP.x, y=sourceHP.y+4, z=sourceHP.z})
                        else
                            card.setPosition({x=hp.x, y=hp.y+7, z=hp.z})
                        end
                        Wait.time(function()
                            pcall(function()
                                card.setPosition({x=hp.x, y=hp.y+4, z=hp.z})
                                Wait.time(function() pcall(function() card.setPosition(hp) end) end, seerSettleDelay)
                            end)
                        end, seerTransitDelay)
                    end
                end)
            end, (ci-1)*seerTakeSpacing)
        end
        -- Step 2: after cards have settled in bot's hand, return one distinct card to
        -- each player the Seer actually took from.
        Wait.time(function()
            local myHand = {}
            pcall(function()
                local p = Player[color]
                if p then myHand = p.getHandObjects() or {} end
            end)

            local protected = botPickBuild(color)
            local returnPool = {}
            for _, hc in ipairs(myHand) do
                pcall(function()
                    local n = (hc.getName() or ''):match('^%s*(.-)%s*$')
                    local d = DISTRICT_DATA[n]
                    if d then
                        local score = d[1]
                        if protected and n == protected.name then score = score + 50 end
                        if G.cityNames[color] and G.cityNames[color][n] then score = score - 3 end
                        if d[1] <= 2 then score = score - 1 end
                        returnPool[#returnPool + 1] = {obj=hc, score=score}
                    end
                end)
            end

            table.sort(returnPool, function(a, b) return a.score < b.score end)

            for idx, targetColor in ipairs(takenTargets) do
                local chosen = table.remove(returnPool, 1)
                if chosen and chosen.obj then
                    local targetHP = HAND_POS[targetColor]
                    local faceZ = (G.bots and G.bots[targetColor]) and 0 or 180
                    local captured = chosen.obj
                    Wait.time(function()
                        pcall(function()
                            local p = Player[color]
                            if p then pcall(function() p.removeHandObject(captured) end) end
                            if targetHP then
                                captured.setRotation({0,0,faceZ})
                                if hp then
                                    captured.setPosition({x=hp.x, y=hp.y+4, z=hp.z})
                                end
                                Wait.time(function()
                                    pcall(function()
                                        captured.setPosition({x=targetHP.x, y=targetHP.y+4, z=targetHP.z})
                                        Wait.time(function()
                                            pcall(function() captured.setPosition(targetHP) end)
                                        end, seerSettleDelay)
                                    end)
                                end, seerTransitDelay)
                                logTo(color, '[BOT] Seer returned a card to '..targetColor..'.')
                                logTo(targetColor, 'Seer ('..color..') returned a card to your hand.')
                            end
                        end)
                    end, (idx - 1) * seerReturnSpacing)
                end
            end
            logTo(color, '[BOT] Seer took cards from opponents and returned one to each.')
            local returnWindow = math.max(0, (#takenTargets - 1) * seerReturnSpacing) + seerTransitDelay + seerSettleDelay + 0.6
            Wait.time(onDone, returnWindow)
        end, math.max(0, (#targets - 1) * seerTakeSpacing) + seerTransitDelay + seerSettleDelay + 0.8)

    -- ── Rank 4 ──
    elseif guid == GUID.king then
        local inc = countDistrictType(color,'noble')
        if inc > 0 then giveGold(color, inc) end
        for i,c in ipairs(G.players) do if c==color then G.crownIndex=i; break end end
        G.crownMovedThisRound = true; moveCrown(color); setCrownUI()
        printToAll(color..' (Bot/King) takes the crown!',{1,0.9,0.4})
        Wait.time(onDone, 0.3)

    elseif guid == GUID.emperor then
        local inc = countDistrictType(color,'noble')
        if inc > 0 then giveGold(color, inc) end
        -- Give the crown where it helps the bot most and take the best payment available.
        local weakest, weakN = nil, -math.huge
        for _, c in ipairs(G.players) do
            if c ~= color then
                local score = -((G.cityScore[c] or 0) * 0.4 + (G.citySize[c] or 0))
                score = score + (((G.gold[c] or 0) > 0) and 8 or 4)
                if score > weakN then weakest = c; weakN = score end
            end
        end
        if weakest then
            for i,c in ipairs(G.players) do if c==weakest then G.crownIndex=i; break end end
            moveCrown(weakest); setCrownUI()
            -- Take 1g if possible; otherwise take a district card from the target's hand.
            if (G.gold[weakest] or 0) > 0 then
                takeGold(weakest,1); giveGold(color,1)
                logTo(color,'[BOT] Emperor gave crown to '..weakest..', took 1g.')
            else
                local targetHand = Player[weakest] and Player[weakest].getHandObjects() or {}
                local stolen = nil
                for _, card in ipairs(targetHand) do
                    local n = (card.getName() or ''):match('^%s*(.-)%s*$')
                    if DISTRICT_DATA[n] then stolen = card break end
                end
                if stolen then
                    local hp = HAND_POS[color]
                    pcall(function()
                        local p = Player[weakest]
                        if p and p.seated then p.removeHandObject(stolen) end
                    end)
                    if hp then
                        pcall(function()
                            stolen.setRotation({0,0,0})
                            stolen.setPosition({x=hp.x, y=hp.y+4, z=hp.z})
                            Wait.time(function() pcall(function() stolen.setPosition(hp) end) end, 0.1)
                        end)
                    end
                    logTo(color,'[BOT] Emperor gave crown to '..weakest..', took 1 card.')
                    logTo(weakest,'Emperor ('..color..') took a card from your hand.')
                end
            end
        else
            logTo(color,'[BOT] Emperor: explicit pass (no legal target).')
        end
        Wait.time(onDone, 0.3)

    elseif guid == GUID.patrician then
        local deck = findDistrictDeck()
        local cards = countDistrictType(color,'noble')
        if cards > 0 and deck then deck.deal(cards, color) end
        for i,c in ipairs(G.players) do if c==color then G.crownIndex=i; break end end
        G.crownMovedThisRound = true; moveCrown(color); setCrownUI()
        printToAll(color..' (Bot/Patrician) takes the crown!',{1,0.9,0.4})
        Wait.time(onDone, 0.4)

    -- ── Rank 5 ──
    elseif guid == GUID.bishop then
        local inc = countDistrictType(color,'religious')
        if inc > 0 then giveGold(color, inc) end
        G.bishopColor = color
        logTo(color,'[BOT] Bishop: '..inc..'g income, city protected.')
        Wait.time(onDone, 0.3)

    elseif guid == GUID.abbot then
        local inc = countDistrictType(color,'religious')
        local bestGold, bestCards, bestScore = 0, inc, -math.huge
        for gold = 0, inc do
            local cards = inc - gold
            local score = cards * 4 + gold * 3
            if botEstimateBuildValue(color, gold) > botEstimateBuildValue(color, 0) then score = score + 8 end
            if score > bestScore then
                bestGold = gold
                bestCards = cards
                bestScore = score
            end
        end
        if bestGold > 0 then giveGold(color, bestGold) end
        local deck = findDistrictDeck()
        if bestCards > 0 and deck then deck.deal(bestCards, color) end
        local richest, richestGold = richestPlayer(color)
        local myGold = G.gold[color] or 0
        if richest and richestGold > myGold and not G.abbotRichUsed then
            takeGold(richest, 1)
            giveGold(color, 1)
            G.abbotRichUsed = true
            logTo(richest, 'Abbot ('..color..') collected 1g from you (richest player).')
        end
        logTo(color,'[BOT] Abbot: '..bestGold..'g and '..bestCards..' card(s) from religious districts.')
        Wait.time(onDone, 0.3)

    elseif guid == GUID.cardinal then
        -- Draw cards equal to religious districts (income ability only)
        -- Borrowing gold is handled automatically in onDistrictBuilt if bot can't afford
        local inc = countDistrictType(color,'religious')
        local deck = findDistrictDeck()
        if inc > 0 and deck then deck.deal(inc, color) end
        G.cardinalIncomeUsed = true
        logTo(color,'[BOT] Cardinal: drew '..inc..' card(s) from religious districts.')
        Wait.time(onDone, 0.4)

    -- ── Rank 6 ──
    elseif guid == GUID.merchant then
        local inc = countDistrictType(color,'trade')
        giveGold(color, inc + 1)
        logTo(color,'[BOT] Merchant: '..(inc+1)..'g.')
        Wait.time(onDone, 0.3)

    elseif guid == GUID.alchemist then
        -- Alchemist: all building costs refunded — just note it
        logTo(color,'[BOT] Alchemist: build costs refunded at end of turn.')
        Wait.time(onDone, 0.3)

    elseif guid == GUID.trader then
        local inc = countDistrictType(color,'trade')
        if inc > 0 then giveGold(color, inc) end
        G.buildLimit = 99
        logTo(color,'[BOT] Trader: '..inc..'g, unlimited trade builds.')
        Wait.time(onDone, 0.3)

    -- ── Rank 7 ──
    elseif guid == GUID.architect then
        local deck = findDistrictDeck()
        if deck then deck.deal(2, color) end
        G.buildLimit = 3
        logTo(color,'[BOT] Architect: drew 2 cards, 3 build limit.')
        Wait.time(onDone, 0.5)

    elseif guid == GUID.navigator and botHandStats then
        G.abilityUsed = true
        local chooseCards = botEstimateBuildValue(color, 0) == 0 or botHandStats(color).count <= 1
        if chooseCards then
            local deck = findDistrictDeck()
            if deck then deck.deal(4, color) end
            logTo(color,'[BOT] Navigator: ability used - drew 4 cards.')
            printToAll('Navigator '..color..' (Bot) draws 4 cards!',{0.7,0.9,1.0})
        else
            giveGold(color, 4)
            updateGoldUI()
            logTo(color,'[BOT] Navigator: ability used - took 4g.')
            printToAll('Navigator '..color..' (Bot) takes 4 gold!',{0.7,0.9,1.0})
        end
        Wait.time(onDone, 0.3)

    elseif guid == GUID.navigator then
        -- Navigator ability: use both slots — gather 2g normally, then ability gives +4g
        -- (bot always prefers gold since it cannot build anyway)
        G.abilityUsed = true
        giveGold(color, 4)
        updateGoldUI()
        logTo(color,'[BOT] Navigator: ability used — took 4g.')
        printToAll('⛵  '..color..' (Bot/Navigator) takes 4 gold!',{0.7,0.9,1.0})
        Wait.time(onDone, 0.3)

    elseif guid == GUID.scholar then
        -- Scholar: deal 7 cards, keep best of the newly drawn cards, shuffle the rest back in.
        local deck = findDistrictDeck()
        if deck then
            local drawCount = math.min(7, deck.getQuantity and deck.getQuantity() or 7)
            local existingHand = {}
            pcall(function()
                local p = Player[color]
                if not p then return end
                for _, ho in ipairs(p.getHandObjects() or {}) do
                    existingHand[ho.getGUID()] = true
                end
            end)
            deck.deal(drawCount, color)
            Wait.time(function()
                local drawnEntries = {}
                local keepGuid  = nil
                local keepScore = -math.huge
                local currentGold = G.gold[color] or 0
                pcall(function()
                    local p = Player[color]
                    if not p then return end
                    for _, ho in ipairs(p.getHandObjects()) do
                        local guid = ho.getGUID()
                        if not existingHand[guid] then
                            local name = (ho.getName() or ''):match('^%s*(.-)%s*$')
                            local d    = DISTRICT_DATA[name]
                            table.insert(drawnEntries, { guid=guid, cost=d and d[1] or -1 })
                            if d then
                                local score = d[1] * 3 + ((d[1] <= currentGold) and 4 or 0)
                                if G.cityNames[color] and G.cityNames[color][name] then score = score - 6 end
                                if score > keepScore then
                                    keepScore = score
                                    keepGuid = guid
                                end
                            end
                        end
                    end
                end)
                for i, entry in ipairs(drawnEntries) do
                    if entry.guid ~= keepGuid then
                        local capturedGuid = entry.guid
                        local delay = i * 0.18
                        Wait.time(function()
                            local cardObj = getObjectFromGUID(capturedGuid)
                            if cardObj then
                                pcall(function()
                                    cardObj.setPosition({x=0, y=3, z=0})
                                    Wait.time(function() discardToBottom(cardObj) end, 0.12)
                                end)
                            end
                        end, delay)
                    end
                end
                G.buildLimit = 2
                logTo(color,'[BOT] Scholar: kept the strongest drawn card and shuffled the rest back in.')
                local shuffleDelay = math.max(0.4, (#drawnEntries) * 0.18 + 0.45)
                Wait.time(function()
                    local dd = findDistrictDeck()
                    if dd then pcall(function() dd.shuffle() end) end
                    onDone()
                end, shuffleDelay)
            end, 1.5)
        else
            Wait.time(onDone, 0.3)
        end

    -- ── Rank 8 ──
    elseif guid == GUID.warlord then
        local inc = countDistrictType(color,'military')
        if inc > 0 then giveGold(color, inc) end
        local bestTarget = botBestWarlordTarget(color)
        if bestTarget and bestTarget.card then
            if bestTarget.destroyCost > 0 then takeGold(color, bestTarget.destroyCost) end
            local prevBotWarlordScore = G.cityScore[bestTarget.targetColor] or 0
            removeDistrictFromCity(bestTarget.targetColor, bestTarget.name, bestTarget.cost, bestTarget.dtype)
            discardToBottom(bestTarget.card)
            printToAll('⚔️  '..color..' (Bot/Warlord) destroys '..bestTarget.name..' in '..bestTarget.targetColor.."'s city!",{0.8,0.3,0.3})
            announceScoreChange(bestTarget.targetColor, G.cityScore[bestTarget.targetColor] - prevBotWarlordScore, 'Warlord destroyed '..bestTarget.name)
        end
        Wait.time(onDone, 0.5)

    elseif guid == GUID.diplomat then
        local inc = countDistrictType(color,'military')
        if inc > 0 then giveGold(color, inc) end
        -- Try to swap: give cheapest own district, take most expensive from biggest opponent
        local dTarget = botBiggestCity(color)
        local swapped = false
        if dTarget and dTarget ~= G.bishopColor
           and G.cityNames[color] and next(G.cityNames[color])
           and G.cityNames[dTarget] and next(G.cityNames[dTarget]) then
            -- Cheapest district we own to give away
            local myDist, myCost, myType = nil, math.huge, nil
            for name,_ in pairs(G.cityNames[color]) do
                local d = DISTRICT_DATA[name]
                if d and d[1] < myCost then myCost=d[1]; myDist=name; myType=d[2] end
            end
            -- Most expensive district they own to take (skip Keep)
            local theirDist, theirCost, theirType = nil, -1, nil
            for name,_ in pairs(G.cityNames[dTarget]) do
                if name ~= 'Keep' then
                    local d = DISTRICT_DATA[name]
                    if d and d[1] > theirCost then theirCost=d[1]; theirDist=name; theirType=d[2] end
                end
            end
            local diff = (myDist and theirDist) and math.max(0, theirCost - myCost) or nil
            if myDist and theirDist and diff ~= nil and theirCost > myCost and (G.gold[color] or 0) >= diff then
                if diff > 0 then takeGold(color, diff); giveGold(dTarget, diff) end
                local prevMyScore    = G.cityScore[color]  or 0
                local prevTheirScore = G.cityScore[dTarget] or 0
                -- Remove each district from its owner, add to the other
                local myBeautifyCoin    = removeDistrictFromCity(color,   myDist,    myCost,    myType, true)
                local theirBeautifyCoin = removeDistrictFromCity(dTarget, theirDist, theirCost, theirType, true)
                -- Give theirDist to diplomat
                G.cityNames[color][theirDist] = true
                G.cityScore[color] = (G.cityScore[color] or 0) + theirCost
                addCityCompletion(color, theirDist)
                G.buildTypes[color] = G.buildTypes[color] or {}
                G.buildTypes[color][theirType] = (G.buildTypes[color][theirType] or 0) + 1
                G.cityTypes[color][theirType] = true
                G.cityCosts[color] = G.cityCosts[color] or {}
                table.insert(G.cityCosts[color], theirCost)
                if theirType == 'unique' then
                    G.uniqueBuilt = G.uniqueBuilt or {}
                    G.uniqueBuilt[color] = G.uniqueBuilt[color] or {}
                    G.uniqueBuilt[color][theirDist] = true
                end
                if theirBeautifyCoin then
                    G.cityScore[color] = (G.cityScore[color] or 0) + 1
                    transferBeautifyCoin(theirBeautifyCoin, color, theirDist)
                end
                -- Give myDist to target
                G.cityNames[dTarget][myDist] = true
                G.cityScore[dTarget] = (G.cityScore[dTarget] or 0) + myCost
                addCityCompletion(dTarget, myDist)
                G.buildTypes[dTarget] = G.buildTypes[dTarget] or {}
                G.buildTypes[dTarget][myType] = (G.buildTypes[dTarget][myType] or 0) + 1
                G.cityTypes[dTarget][myType] = true
                G.cityCosts[dTarget] = G.cityCosts[dTarget] or {}
                table.insert(G.cityCosts[dTarget], myCost)
                if myType == 'unique' then
                    G.uniqueBuilt = G.uniqueBuilt or {}
                    G.uniqueBuilt[dTarget] = G.uniqueBuilt[dTarget] or {}
                    G.uniqueBuilt[dTarget][myDist] = true
                end
                if myBeautifyCoin then
                    G.cityScore[dTarget] = (G.cityScore[dTarget] or 0) + 1
                    transferBeautifyCoin(myBeautifyCoin, dTarget, myDist)
                end
                printToAll('🤝  '..color..' (Bot/Diplomat) swaps '..myDist..' → '..theirDist..' with '..dTarget..'!',{0.4,0.9,0.9})
                -- Museum keeps ownership of its tucked cards when it changes hands.
                if theirDist == 'Museum' then transferMuseumCards(dTarget, color) end
                if myDist    == 'Museum' then transferMuseumCards(color, dTarget) end

                local myCard    = findDistrictCardInCity(color, myDist)
                local theirCard = findDistrictCardInCity(dTarget, theirDist)
                if myCard then moveDistrictCardToCity(dTarget, myDist, myCard) end
                if theirCard then moveDistrictCardToCity(color, theirDist, theirCard, 0.05) end

                logTo(dTarget, 'Diplomat ('..color..') swapped '..theirDist..' for your '..myDist..'.')
                announceScoreChange(color,   (G.cityScore[color]  or 0) - prevMyScore,    'Diplomat swap')
                announceScoreChange(dTarget, (G.cityScore[dTarget] or 0) - prevTheirScore, 'Diplomat swap')
                checkCityCompletion(color)
                swapped = true
            end
        end
        if not swapped then logTo(color,'[BOT] Diplomat: '..inc..'g income, no beneficial swap found.') end
        Wait.time(onDone, 0.3)

    elseif guid == GUID.marshal then
        local inc = countDistrictType(color,'military')
        if inc > 0 then
            giveGold(color, inc)
            updateGoldUI()
        end
        logTo(color, '[BOT] Marshal: '..inc..'g from military districts (School of Magic counts if owned).')
        -- Seize the most valuable district (cost ≤ 3) from the biggest opponent's city
        local mTarget = botBiggestCity(color)
        local seized = false
        if mTarget and mTarget ~= G.bishopColor
           and (G.citySize[mTarget] or 0) < cityThreshold() then
            local bestName, bestCost, bestType = nil, -1, nil
            for name,_ in pairs(G.cityNames[mTarget] or {}) do
                if name ~= 'Keep' then
                    local d = DISTRICT_DATA[name]
                    -- Marshal can only seize districts with base cost ≤ 3
                    if d and d[1] <= 3 and d[1] > bestCost
                       and not (G.cityNames[color] and G.cityNames[color][name]) then
                        bestCost = d[1]; bestName = name; bestType = d[2]
                    end
                end
            end
            if bestName and (G.gold[color] or 0) >= bestCost then
                G.seizeUsed = true
                if bestCost > 0 then takeGold(color, bestCost); giveGold(mTarget, bestCost) end
                local prevMarshalVictimScore = G.cityScore[mTarget] or 0
                -- Capture the live district card before city-state removal so we can move
                -- the physical card into the Marshal's city after ownership changes.
                local seizedCard = findDistrictCardInCity(mTarget, bestName)
                local beautifyCoinGuid = removeDistrictFromCity(mTarget, bestName, bestCost, bestType, true)
                -- Add to marshal's city
                G.cityNames[color] = G.cityNames[color] or {}
                G.cityNames[color][bestName] = true
                G.cityScore[color] = (G.cityScore[color] or 0) + bestCost
                addCityCompletion(color, bestName)
                G.buildTypes[color] = G.buildTypes[color] or {}
                G.buildTypes[color][bestType] = (G.buildTypes[color][bestType] or 0) + 1
                G.cityTypes[color] = G.cityTypes[color] or {}
                G.cityTypes[color][bestType] = true
                G.cityCosts[color] = G.cityCosts[color] or {}
                table.insert(G.cityCosts[color], bestCost)
                if bestType == 'unique' then
                    G.uniqueBuilt = G.uniqueBuilt or {}
                    G.uniqueBuilt[color] = G.uniqueBuilt[color] or {}
                    G.uniqueBuilt[color][bestName] = true
                end
                printToAll('🏇  '..color..' (Bot/Marshal) seizes '..bestName..' from '..mTarget..'!',{0.4,0.9,0.5})
                if beautifyCoinGuid then
                    G.cityScore[color] = (G.cityScore[color] or 0) + 1
                    transferBeautifyCoin(beautifyCoinGuid, color, bestName)
                end
                -- Museum keeps its tucked cards when seized.
                if bestName == 'Museum' then transferMuseumCards(mTarget, color) end
                -- Move the seized district card into the Marshal's visible city row.
                if seizedCard then moveDistrictCardToCity(color, bestName, seizedCard) end
                logTo(mTarget, 'Marshal ('..color..') seized your '..bestName..' (paid '..bestCost..'g).')
                announceScoreChange(mTarget, (G.cityScore[mTarget] or 0) - prevMarshalVictimScore, 'Marshal seized '..bestName)
                announceScoreChange(color,   bestCost, 'seized '..bestName..' from '..mTarget)
                checkCityCompletion(color)
                seized = true
            end
        end
        if not seized then logTo(color,'[BOT] Marshal: no seizure target found.') end
        Wait.time(onDone, 0.3)

    -- ── Rank 9 ──
    elseif guid == GUID.queen then
        -- Check if adjacent to rank 4 in turn order
        local rank4color = nil
        for _,e in ipairs(G.turnOrder) do if e.rank==4 then rank4color=e.color; break end end
        local adjacent = false
        if rank4color then
            for i,e in ipairs(G.turnOrder) do
                if e.color==color then
                    local prev = G.turnOrder[i-1]; local next = G.turnOrder[i+1]
                    if (prev and prev.color==rank4color) or (next and next.color==rank4color) then
                        adjacent = true; break
                    end
                end
            end
        end
        if adjacent then giveGold(color,3); logTo(color,'[BOT] Queen: 3g from adjacency.') end
        Wait.time(onDone, 0.3)

    elseif guid == GUID.artist then
        -- Beautify up to 2 of the most expensive unbeautified districts (1g each, +1 pt each)
        G.beautified = G.beautified or {}
        G.beautified[color] = G.beautified[color] or {}
        local candidates = {}
        for name, _ in pairs(G.cityNames[color] or {}) do
            if not G.beautified[color][name] then
                local d = DISTRICT_DATA[name]
                if d then table.insert(candidates, {name=name, cost=d[1]}) end
            end
        end
        table.sort(candidates, function(a,b) return a.cost > b.cost end)
        local nBeautified = 0
        for _, c in ipairs(candidates) do
            if nBeautified >= 2 or (G.gold[color] or 0) < 1 then break end
            G.beautified[color][c.name] = true
            G.cityScore[color] = (G.cityScore[color] or 0) + 1
            G.artistBeautifyCount = (G.artistBeautifyCount or 0) + 1
            -- Beautify gold stays on the district, so do not send a coin back to the bowl first.
            G.gold[color] = (G.gold[color] or 0) - 1
            updateGoldUI()
            nBeautified = nBeautified + 1
            local districtCard = findDistrictCardInCity(color, c.name)
            if districtCard then
                local cardPos = districtCard.getPosition()
                local usedCoin = nil
                G.artistUsedCoins = G.artistUsedCoins or {}
                for _, o in ipairs(getAllObjects()) do
                    if usedCoin then break end
                    pcall(function()
                        if o.getName() == 'Gold' and not G.artistUsedCoins[o.getGUID()] then
                            local op = o.getPosition()
                            if math.sqrt((op.x-PLAYER_POS[color].x)^2+(op.z-PLAYER_POS[color].z)^2) < 15 then
                                G.artistUsedCoins[o.getGUID()] = true
                                registerBeautifyCoin(color, c.name, o)
                                o.setPositionSmooth({
                                    x=cardPos.x+(math.random()-0.5)*0.3,
                                    y=cardPos.y+0.5,
                                    z=cardPos.z+(math.random()-0.5)*0.3,
                                }, false, false)
                                usedCoin = o
                            end
                        end
                    end)
                end
                if not usedCoin then
                    local bp = bowlPos()
                    for _, o in ipairs(getAllObjects()) do
                        if usedCoin then break end
                        pcall(function()
                            if o.getName() == 'Gold' then
                                local op = o.getPosition()
                                if math.sqrt((op.x-bp.x)^2+(op.z-bp.z)^2) < 15 then
                                    G.artistUsedCoins[o.getGUID()] = true
                                    registerBeautifyCoin(color, c.name, o)
                                    o.setPositionSmooth({
                                        x=cardPos.x+(math.random()-0.5)*0.3,
                                        y=cardPos.y+0.5,
                                        z=cardPos.z+(math.random()-0.5)*0.3,
                                    }, false, false)
                                    usedCoin = o
                                end
                            end
                        end)
                    end
                end
                if usedCoin then syncBeautifyCoin(color, c.name, 0.2) end
            end
            logTo(color, '[BOT] Artist beautified '..c.name..' (+1 pt).')
            printToAll('🎨  '..color..' (Bot/Artist) beautified '..c.name..'!',{1,0.9,0.5})
            announceScoreChange(color, 1, 'beautified '..c.name)
        end
        if nBeautified == 0 then logTo(color, '[BOT] Artist: no gold or all districts already beautified.') end
        Wait.time(onDone, 0.3)

    elseif guid == GUID.taxcollector then
        -- Tax Collector: collect ALL coins physically near the plate
        local tcToken = obj(GUID.taxcollectorToken)
        local pp = PLAYER_POS[color]
        if tcToken and pp then
            local tp = tcToken.getPosition()
            local coinsNear = {}
            for _, o in ipairs(getAllObjects()) do
                pcall(function()
                    if o.getName() == 'Gold' then
                        local op = o.getPosition()
                        if math.sqrt((op.x-tp.x)^2+(op.z-tp.z)^2) < 18 then
                            table.insert(coinsNear, o)
                        end
                    end
                end)
            end
            local collected = #coinsNear
            if collected > 0 then
                G.taxGold = 0
                G.gold[color] = (G.gold[color] or 0) + collected
                for i, coin in ipairs(coinsNear) do
                    pcall(function()
                        G.lockedCoins = G.lockedCoins or {}
                        G.lockedCoins[coin.getGUID()] = nil
                        G.coinPickedFrom = G.coinPickedFrom or {}
                        G.coinPickedFrom[coin.getGUID()] = nil
                        liftThenPlace(coin, {
                            x = pp.x + (math.random()-0.5)*1.5,
                            y = pp.y,
                            z = pp.z - 4 + (math.random()-0.5)*1.5,
                        }, (i-1) * 0.08)
                    end)
                end
                updateGoldUI()
                logTo(color,'[BOT] Tax Collector: collected '..collected..'g from plate.')
            else
                logTo(color,'[BOT] Tax Collector: no gold on plate.')
            end
        elseif (G.taxGold or 0) > 0 then
            local collected = G.taxGold
            G.taxGold = 0
            giveGold(color, collected)
            logTo(color,'[BOT] Tax Collector: collected '..collected..'g (no token found).')
        end
        Wait.time(onDone, 0.3)

    else
        -- Unknown / unimplemented — leave a debug trace instead of noisy player-facing output.
        debugLog('[BOT] Ability fallback passed for '..tostring(CHAR_NAME[guid] or guid)..'.')
        Wait.time(onDone, 0.3)
    end

    updateGoldUI()
end

function botDoTurn(color)
    if G.resetting then return end
    if G.phase ~= 'TURN' then return end
    if G.currentColor ~= color then return end

    -- If this character is bewitched, only gather (no ability, no build) then hand off to witch
    if G.bewitchedChar and G.currentChar == G.bewitchedChar and G.witchColor then
        printToAll('🤖  '..color..' (Bot) is bewitched — gathering only.',{0.7,0.8,1.0})
        Wait.time(function()
            if not G.hasGathered then
                G.hasGathered = true
                giveGold(color, 2)
                applyGatherPassives(color, 'gold')
                logTo(color, '[BOT] Bewitched: took 2g only.')
            end
            local e = G.turnOrder and G.turnOrder[G.turnStep]
            if e and e.guid == G.bewitchedChar and G.witchColor then
                resumeWitchTurn(e)
            else
                botEndTurn(color)
            end
        end, 1.0)
        return
    end

    printToAll('🤖  '..color..' (Bot) is taking their turn...',{0.7,0.8,1.0})

    -- Resolve blackmail if this bot is threatened.
    -- The token is face-down so the bot doesn't know if it is the real or fake target.
    -- Bots refuse ~40% of the time (calling the bluff), otherwise pay.
    if G.blackmailPending and G.blackmailPending == G.currentChar and not G.blackmailResolved then
        G.blackmailNeedsGather = false
        -- Gather first (blackmail rules require gathering before resolving)
        if not G.hasGathered then
            G.hasGathered = true
            giveGold(color, 2)
            applyGatherPassives(color, 'gold')
        end
        G.blackmailResolved = true
        G.blackmailPending = nil
        if math.random() < 0.4 then
            -- Refuse: keep gold, but Blackmailer may flip the marker
            printToAll('🤖  '..color..' (Bot) refuses to pay the Blackmailer!',{1,0.6,0.3})
            logTo(color, '[BOT] Refused blackmail.')
            G.blackmailRefusalPending = { color=color, charGuid=G.currentChar }
            local tcColor = G.blackmailerColor
            if tcColor and isBot(tcColor) then
                Wait.time(function() blackmailerReveal(tcColor) end, 1.5)
            else
                logTo(tcColor, 'BLACKMAIL: '..color..' (Bot) refused! Type  !flip  to reveal their marker '..
                    '(if flowered lace, take ALL their gold), or  !pass  to leave it face-down.')
            end
        else
            -- Pay: hand over half gold, keep identity secret
            local half = math.floor((G.gold[color] or 0) / 2)
            if half > 0 then
                takeGold(color, half)
                if G.blackmailerColor then giveGold(G.blackmailerColor, half) end
            end
            printToAll('🤖  '..color..' (Bot) pays '..half..'g blackmail.',{0.8,0.7,1.0})
            logTo(color, '[BOT] Paid blackmail: '..half..'g to '..(G.blackmailerColor or '?')..'.')
        end
    end

    -- 1. Use character ability (async — calls onDone when finished)
    local function afterAbility()
        -- Use any interactive unique district abilities before gathering
        botUseUniqueAbilities(color, function()
        if G.hasGathered then
            Wait.time(function() botBuildAndEnd(color) end, 0.5)
            return
        end

        -- 3. Decide: take gold or draw cards
        local takeGold = botShouldTakeGoldOnGather(color)
        G.hasGathered = true

        if takeGold then
            giveGold(color, 2)
            logTo(color, '[BOT] Took 2g. Total: '..G.gold[color]..'g')
            applyGatherPassives(color, 'gold')
            Wait.time(function() botBuildAndEnd(color) end, 0.5)
        else
            -- Can't afford anything — draw 2, keep 1
            local deck = findDistrictDeck()
            if deck then
                deck.deal(2, color)
                Wait.time(function()
                    -- Discard cheaper of the two new cards
                    local allHand = {}
                    pcall(function()
                        local p = Player[color]; if p then allHand = p.getHandObjects() end
                    end)
                    if #allHand > 4 then
                        -- Find cheapest district card to discard
                        local cheapIdx, cheapCost = nil, math.huge
                        for i, ho in ipairs(allHand) do
                            local d = DISTRICT_DATA[ho.getName() or '']
                            if d and d[1] < cheapCost then cheapCost=d[1]; cheapIdx=i end
                        end
                        if cheapIdx then
                            local extra = allHand[cheapIdx]
                            pcall(function()
                                extra.setPosition({x=0, y=4, z=0})  -- escape hand zone
                                Wait.time(function() discardToBottom(extra) end, 0.15)
                            end)
                        end
                    end
                    Wait.time(function() botBuildAndEnd(color) end, 0.6)
                end, 1.2)
            else
                giveGold(color, 2)
                applyGatherPassives(color, 'gold')
                Wait.time(function() botBuildAndEnd(color) end, 0.5)
            end
            logTo(color, '[BOT] Drew cards.')
        end
        end)  -- end botUseUniqueAbilities callback
    end

    local function startAbilityPhase()
        Wait.time(function()
            botDoCharacterAbility(color, afterAbility)
        end, 0.4)
    end

    local preAbilityBuild = botPickPreAbilityIncomeBuild(color)
    if preAbilityBuild then
        if not G.hasGathered then
            G.hasGathered = true
            giveGold(color, 2)
            applyGatherPassives(color, 'gold')
            logTo(color, '[BOT] Took 2g before ability to line up a better income build.')
        end
        botExecuteBuild(color, preAbilityBuild, function(result)
            if result then
                logTo(color, '[BOT] Built '..preAbilityBuild.name..' before using '..(CHAR_NAME[G.currentChar] or 'their ability')..' for extra income.')
            end
            Wait.time(startAbilityPhase, result and 0.35 or 0.15)
        end)
    else
        Wait.time(startAbilityPhase, 1.0)
    end
end

-- ============================================================
--  SPECTATOR / DISCONNECT → BOT TAKEOVER
--  Fires when a seated player goes to spectator or disconnects.
-- ============================================================

-- Shared logic: assign a bot to `color` and resume if it's their turn
local function botTakeover(color)
    if not G.players or #G.players == 0 then return end

    -- Must be part of the current game
    local inGame = false
    for _, c in ipairs(G.players) do if c == color then inGame = true; break end end
    if not inGame then return end

    -- Already a bot — nothing to do
    if isBot(color) then return end

    G.bots[color] = true
    printToAll('👤➜🤖  '..color..' left the game — a bot will take over.',{0.8,0.8,0.5})

    -- Sync the toggle in the setup panel if it's still visible
    pcall(function() UI.setAttribute('togBot_'..color,'isOn','True') end)

    -- Resume game if it was waiting on this player
    if G.phase == 'TURN' and G.currentColor == color then
        Wait.time(function() botDoTurn(color) end, 1.5)
    elseif G.phase == 'SELECTION' then
        local expected = G.selectionOrder and G.selectionOrder[G.selectionStep]
        if expected == color and not G.selectionBusy then
            G.selectionBusy = true
            Wait.time(function() botDoSelection(color) end, 1.5)
        end
    end
end

-- TTS callback: player changed seat color.
-- When a player goes to spectator, new_color == 'Grey' but player_object.color
-- has already been updated to 'Grey' by the time this fires, so we can't read
-- the old color from the object. Instead diff G.players vs seated to find who left.
function onPlayerChangeColor(player_object, new_color)
    if new_color ~= 'Grey' then return end
    if not G.players or #G.players == 0 then return end
    -- Find which game-color is no longer seated and not already a bot
    local seated = {}
    for _, p in ipairs(getSeatedPlayers()) do seated[p] = true end
    for _, color in ipairs(G.playersa) do
        if not seated[color] and not isBot(color) then
            botTakeover(color)
        end
    end
end

-- TTS callback: player disconnected from the server entirely.
-- player_object.color is the seat they held.
function onPlayerDisconnect(player_object)
    local color = player_object and player_object.color
    if color and color ~= 'Grey' then
        botTakeover(color)
    end
end

function onLoad()
    math.randomseed(os.time())
    buildUI()
    refreshUniqueSetupUI()
    captureDeckResetAnchors()
    captureKnownResetHomes()
    -- Init mode display
    UI.setValue('txtMode','Mode: Scenario — '..SCENARIOS[1].name)
    UI.setAttribute('togAutoEnd', 'isOn', G.autoEndTurn and 'True' or 'False')
    log(' loaded. Configure the cast on the left panel, then press Start Game.')
end