-- ─────────────────────────────────────────────────
-- Core poet identity
-- ─────────────────────────────────────────────────

DROP TABLE IF EXISTS poets;

CREATE TABLE poets (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    name                TEXT NOT NULL,
    age                 INTEGER,                    -- age affects tone, reference pool, urgency
    nationality         TEXT,
    first_language      TEXT,                       -- non-native English speakers have a distinct music
    education_level     TEXT,                       -- 'self-taught' | 'undergraduate' | 'postgraduate' | 'MFA'
    occupation          TEXT,                       -- affects time available, subject matter, class register
    location            TEXT,                       -- city, rural, coast — shapes imagery pool
    biography           TEXT,                       -- free-text backstory fed directly into LLM context
    physical_notes      TEXT,                       -- appearance, health — can surface in poems about the body
    current_life_notes  TEXT,                       -- mutable: current situation, mood, circumstances
    created_at          TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ─────────────────────────────────────────────────
-- Seed poets
-- ─────────────────────────────────────────────────

INSERT INTO poets (
    name,
    age,
    nationality,
    first_language,
    education_level,
    occupation,
    location,
    biography,
    physical_notes,
    current_life_notes
) VALUES

(
'Margaret Ellison',
68,
'British',
'English',
'undergraduate',
'Retired urban planner',
'Oxford, England',
'Born and raised in Oxford. Worked for local authorities across the Midlands before returning to the city in her forties. Spent much of her career involved in transport, housing and public-space projects. Widowed in her late fifties. Maintains a wide circle of acquaintances through local history groups, walking societies and community organisations. Has watched Oxford change dramatically over six decades and remains fascinated by how people inhabit places.',
'Tall, grey-haired, walks several miles most days. Slight stiffness in one knee from an old injury.',
'Recently sorting through boxes of papers and photographs after downsizing from the family home to a smaller flat. Increasingly reflective about memory, legacy and change.'
),

(
'Yusuf Rahman',
34,
'British',
'English',
'postgraduate',
'Secondary-school physics teacher',
'Oxford, England',
'Raised in Luton and moved to Oxford for teacher training. Comes from a family with roots in Bangladesh. Known among friends for balancing intellectual curiosity with practicality. Enjoys repairing household objects, amateur astronomy and long conversations that begin with scientific questions and drift elsewhere. Married with one young child.',
'Slim build. Often tired during term time. Wears glasses.',
'Adjusting to the demands of parenthood while taking on additional responsibilities at work. Thinking often about time, attention and competing obligations.'
),

(
'Elena Kovacs',
42,
'Hungarian',
'Hungarian',
'postgraduate',
'Literary translator',
'Oxford, England',
'Grew up in Szeged and studied languages before moving between several European cities. Settled in Oxford after meeting her partner at a translation conference. Works primarily on contemporary fiction and essays. Has spent much of her adult life navigating between languages and cultures, and has a habit of collecting notebooks filled with fragments, overheard phrases and observations.',
'Dark-haired, usually carries a notebook. Near-sighted.',
'Working on a difficult translation project that has left her questioning ideas of authorship, originality and voice. Travels frequently but increasingly values routine.'
),

(
'Thomas Arkwright',
57,
'British',
'English',
'self-taught',
'Bicycle mechanic and shop owner',
'Oxford, England',
'Left school at sixteen and built a successful independent bicycle repair business. A lifelong reader who discovered poetry through public libraries rather than formal study. Deeply knowledgeable about local history, mechanical systems and traditional crafts. Known for strong opinions delivered with warmth and humour.',
'Broad-shouldered, permanently marked by years of manual work. Oil stains frequently survive hand washing.',
'Considering whether to sell the business and retire within the next few years. Uncertain whether he wants more freedom or simply fears losing a defining part of his identity.'
),

(
'Lydia Chen',
32,
'British',
'English',
'postgraduate',
'Medical statistician',
'Oxford, England',
'Born in Manchester and educated in London before moving to Oxford for research work. Interested in how people interpret uncertainty and risk. Equally comfortable discussing epidemiology, crossword puzzles and experimental literature. Has a playful sense of humour that sometimes masks a highly analytical temperament.',
'Short, energetic, often restless. Frequently seen carrying multiple books at once.',
'Working on a large long-term health study. Recently ended a long relationship and is cautiously rebuilding a social life outside work.'
),

(
'Aisha Mahmood',
19,
'British',
'English',
'undergraduate',
'Philosophy student',
'Oxford, England',
'First-year undergraduate from Birmingham. Grew up in a household where books, debate and strong opinions were common. Reads far beyond her course syllabus and frequently changes her mind after encountering a compelling argument. Ambitious, self-critical and intellectually adventurous. The youngest member of the poetry group by a considerable margin.',
'Usually sleep-deprived. Dresses practically and pays little attention to fashion.',
'Experiencing the mixture of excitement, loneliness and possibility that comes with living away from home for the first time. Constantly reassessing who she wants to become.'
);



-- ─────────────────────────────────────────────────
-- Trait taxonomy (the vocabulary of tendencies)
-- ─────────────────────────────────────────────────

DROP TABLE IF EXISTS poet_trait_definitions;

CREATE TABLE IF NOT EXISTS poet_trait_definitions (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    trait_key    TEXT NOT NULL UNIQUE,   -- machine-readable, used in LLM prompts
    category     TEXT NOT NULL,          -- see CHECK below
    label        TEXT NOT NULL,          -- human-readable name
    description  TEXT,                   -- what this trait means in practice
    low_label    TEXT,                   -- what score ~0.1 looks like, e.g. 'spare'
    high_label   TEXT,                   -- what score ~0.9 looks like, e.g. 'lush'
    CHECK (category IN (
        'craft',         -- line length, density, revision style, lineation
        'formal',        -- form preference, rhyme, structure
        'thematic',      -- subject obsessions
        'psychological', -- emotional processing, confessional tendency, outlook
        'voice'          -- register, irony, intellectual vs visceral
    ))
);

-- Seed data: the trait vocabulary
INSERT INTO poet_trait_definitions (trait_key, category, label, low_label, high_label, description) VALUES

-- CRAFT
('poem_length',        'craft', 'Poem length',        'epigrammatic', 'expansive',
 'Tendency toward short compressed poems vs longer meditative or narrative ones'),
('line_length',        'craft', 'Line length',         'clipped, short', 'long, sprawling',
 'Preferred line length — affects breath, pace, and how much can fit in a single movement'),
('density',            'craft', 'Lexical density',     'spare, minimal', 'lush, saturated',
 'How many images and ideas per line — sparse with white space vs packed with language'),
('revision_intensity', 'craft', 'Revision intensity',  'trusts first drafts', 'obsessive reviser',
 'Whether poems tend to arrive close to finished or are worked over many drafts'),
('enjambment',         'craft', 'Enjambment use',      'end-stopped', 'heavily enjambed',
 'Whether lines end syntactically or run on, creating tension between line and sentence'),
('punctuation_weight', 'craft', 'Punctuation weight',  'minimal/none', 'heavily punctuated',
 'Use of commas, em-dashes, colons — affects pace and how the voice sounds on the page'),
('white_space',        'craft', 'Use of white space',  'dense on page', 'airy, fragmented',
 'How much visual space and silence the poems use — stanza gaps, caesurae, spacing'),

-- FORMAL
('form_preference',    'formal', 'Form preference',    'free verse only', 'traditional forms',
 'Whether the poet gravitates toward free verse or fixed/inherited forms (sonnets, villanelles, etc.)'),
('rhyme_tendency',     'formal', 'Rhyme tendency',     'never rhymes', 'rhymes frequently',
 'From no rhyme through slant rhyme to full end rhyme'),
('structural_clarity', 'formal', 'Structural clarity', 'associative, drifting', 'tightly architectured',
 'Whether poems have a clear through-line and logic, or move by association and surprise'),
('uses_sequences',     'formal', 'Uses sequences',     'standalone poems only', 'often writes sequences',
 'Whether this poet tends to write individual poems or longer linked sequences'),

-- THEMATIC
('theme_nature',       'thematic', 'Nature / landscape',    'rarely', 'central obsession', ''),
('theme_family',       'thematic', 'Family / childhood',    'rarely', 'central obsession', ''),
('theme_mortality',    'thematic', 'Death / time / loss',   'rarely', 'central obsession', ''),
('theme_body',         'thematic', 'The body / illness',    'rarely', 'central obsession', ''),
('theme_politics',     'thematic', 'Politics / history',    'rarely', 'central obsession', ''),
('theme_faith',        'thematic', 'Faith / the sacred',    'rarely', 'central obsession', ''),
('theme_eros',         'thematic', 'Love / desire / eros',  'rarely', 'central obsession', ''),
('theme_place',        'thematic', 'Specific place',        'rarely', 'central obsession', ''),
('theme_language',     'thematic', 'Language itself / metapoetry', 'rarely', 'central obsession', ''),
('theme_work',         'thematic', 'Labour / class / money','rarely', 'central obsession', ''),

-- PSYCHOLOGICAL
('confessional_degree','psychological', 'Confessional degree', 'oblique, masked', 'nakedly autobiographical',
 'How directly the poet writes from personal experience vs. via persona, myth, or displacement'),
('emotional_register', 'psychological', 'Emotional temperature','cool, restrained', 'hot, exposed',
 'The emotional intensity on the surface of the poems'),
('irony_quotient',     'psychological', 'Irony / humour',      'earnest throughout', 'deeply ironic',
 'Whether the poet uses wit, irony, or dark humour as a primary mode'),
('time_orientation',   'psychological', 'Time orientation',    'present-focused', 'memory-obsessed',
 'Whether poems are rooted in the immediate present or tend to excavate the past'),
('outlook',            'psychological', 'Fundamental outlook', 'elegiac, grieving', 'celebratory, affirmative',
 'The emotional weather the poems tend to inhabit — not mood but worldview'),
('risk_taking',        'psychological', 'Formal/emotional risk','safe, controlled', 'reckless, daring',
 'Whether the poet pushes into uncomfortable territory or keeps to familiar ground'),

-- VOICE
('diction_register',   'voice', 'Diction register',   'plain, demotic', 'elevated, literary',
 'The social register of the vocabulary — from the spoken vernacular to the highly literary'),
('intellectual_weight', 'voice', 'Intellectual weight', 'sensory, immediate', 'cerebral, philosophical',
 'Whether poems work primarily through image and sensation or through idea and argument'),
('narrative_tendency', 'voice', 'Narrative tendency',  'lyric, imagistic', 'story-driven, anecdotal',
 'Whether poems are lyric moments or contain character, plot, narrative arc'),
('address',            'voice', 'Mode of address',     'private, interior', 'public, rhetorical',
 'Whether the poet speaks inward or outward — to themselves, a lover, or the world'),
('persona_use',        'voice', 'Use of persona',      'always first person', 'dramatic monologue / persona',
 'Whether the poet writes as themselves or inhabits other voices and characters');


-- ─────────────────────────────────────────────────
-- Per-poet trait scores
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS poet_traits;

CREATE TABLE poet_traits (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    poet_id         INTEGER NOT NULL REFERENCES poets(id),
    trait_key       TEXT NOT NULL REFERENCES poet_trait_definitions(trait_key),
    tendency_score  REAL NOT NULL CHECK (tendency_score BETWEEN 0.0 AND 1.0),
    -- 'seeded'   = set when the character was created
    -- 'observed' = updated from a poem the LLM analysed
    -- 'inferred' = LLM guessed from biography, not yet confirmed by poems
    confidence      TEXT NOT NULL DEFAULT 'seeded'
                    CHECK (confidence IN ('seeded', 'inferred', 'observed')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (poet_id, trait_key)
);


-- ─────────────────────────────────────────────────
-- Literary and cultural influences
-- ─────────────────────────────────────────────────

DROP TABLE IF EXISTS poet_influences;

CREATE TABLE poet_influences (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    poet_id         INTEGER NOT NULL REFERENCES poets(id),
    influence_name  TEXT NOT NULL,   -- e.g. 'Seamus Heaney', 'New York School', 'King James Bible'
    influence_type  TEXT NOT NULL CHECK (influence_type IN ('poet', 'movement', 'text', 'art_form', 'other')),
    -- 'passing'     = aware of, occasionally surfaces
    -- 'significant' = clearly shaped their voice
    -- 'formative'   = foundational, baked into everything
    depth           TEXT NOT NULL DEFAULT 'significant'
                    CHECK (depth IN ('passing', 'significant', 'formative'))
);


-- ─────────────────────────────────────────────────
-- Named people in the poet's life
-- (these can be referenced in poems and need to stay consistent)
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS poet_relationships;

CREATE TABLE IF NOT EXISTS poet_relationships (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    poet_id           INTEGER NOT NULL REFERENCES poets(id),
    person_name       TEXT NOT NULL,
    relationship_type TEXT NOT NULL,  -- 'partner' | 'ex_partner' | 'child' | 'parent' | 'sibling'
                                      -- 'friend' | 'mentor' | 'rival' | 'colleague' | 'deceased_loved_one'
    status            TEXT NOT NULL DEFAULT 'current'
                      CHECK (status IN ('current', 'past', 'deceased', 'estranged', 'unknown')),
    notes             TEXT,           -- e.g. "married 2019, lives in Glasgow, source of joy and friction"
    introduced_week   INTEGER         -- which week this person first appeared in a poem
);

-- ─────────────────────────────────────────────────
-- Life events and notable developments
-- ─────────────────────────────────────────────────

DROP TABLE IF EXISTS poet_events;

CREATE TABLE IF NOT EXISTS poet_events (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    poet_id      INTEGER NOT NULL REFERENCES poets(id),
    issue_id     INTEGER NOT NULL REFERENCES issues(id),
    event_type   TEXT NOT NULL CHECK (event_type IN (
                     'life_event',          -- something happened to them
                     'relationship_change', -- status change on a poet_relationships row
                     'trait_drift',         -- a trait score has shifted noticeably
                     'new_obsession',       -- a new theme has emerged
                     'poem_written'         -- cross-reference to poems table
                 )),
    description  TEXT NOT NULL,
    source       TEXT NOT NULL DEFAULT 'llm_inferred'
                 CHECK (source IN ('seeded', 'llm_inferred', 'user_added')),
    poem_id      INTEGER REFERENCES poems(id),  -- if this event was inferred from a specific poem
    occurred_at  TEXT NOT NULL DEFAULT (datetime('now'))
);


-- ─────────────────────────────────────────────────
-- Weekly issue
-- ─────────────────────────────────────────────────

DROP TABLE IF EXISTS issues;

CREATE TABLE IF NOT EXISTS issues (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    prompt TEXT NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at   TEXT NOT NULL DEFAULT (datetime('now'))
);


-- ─────────────────────────────────────────────────
-- Poems (the primary output)
-- ─────────────────────────────────────────────────

DROP TABLE IF EXISTS poems;

CREATE TABLE IF NOT EXISTS poems (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    poet_id INTEGER NOT NULL,
    issue_id INTEGER NOT NULL,      -- inc the stimulus for this week
    idea TEXT,                      -- the chosen idea sketch, for traceability
    draft TEXT,                     -- last draft before review
    review TEXT,
    revision TEXT,                  -- post-revision
    score INTEGER,                  -- 0–100, from editorial ranker
    --editorial_note  TEXT,             -- the ranker's one-word / two-sentence verdict (not in current scope but could be added later)
    published       INTEGER NOT NULL DEFAULT 0 CHECK (published IN (0, 1)),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(poet_id)
    REFERENCES poets(id)
);

-- ─────────────────────────────────────────────────
-- Indexes worth having
-- ─────────────────────────────────────────────────

CREATE INDEX idx_poet_traits_poet     ON poet_traits(poet_id);
CREATE INDEX idx_poems_poet_week      ON poems(poet_id, issue_id);
CREATE INDEX idx_poet_events_poet     ON poet_events(poet_id);
CREATE INDEX idx_poet_events_week     ON poet_events(issue_id);
CREATE INDEX idx_relationships_poet   ON poet_relationships(poet_id);