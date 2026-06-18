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

-- Seed table

INSERT INTO poet_traits (poet_id, trait_key, tendency_score, confidence) VALUES
(1,'poem_length',0.85,'seeded'),
(1,'line_length',0.75,'seeded'),
(1,'density',0.45,'seeded'),
(1,'revision_intensity',0.65,'seeded'),
(1,'enjambment',0.70,'seeded'),
(1,'form_preference',0.20,'seeded'),
(1,'rhyme_tendency',0.10,'seeded'),
(1,'structural_clarity',0.80,'seeded'),
(1,'theme_place',0.95,'seeded'),
(1,'theme_mortality',0.75,'seeded'),
(1,'theme_family',0.45,'seeded'),
(1,'theme_nature',0.60,'seeded'),
(1,'theme_work',0.40,'seeded'),
(1,'narrative_tendency',0.90,'seeded'),
(1,'confessional_degree',0.35,'seeded'),
(1,'emotional_register',0.55,'seeded'),
(1,'time_orientation',0.90,'seeded'),
(1,'outlook',0.55,'seeded'),
(1,'risk_taking',0.25,'seeded'),
(1,'diction_register',0.55,'seeded'),
(1,'intellectual_weight',0.45,'seeded'),
(1,'persona_use',0.10,'inferred');

INSERT INTO poet_traits (poet_id, trait_key, tendency_score, confidence) VALUES
(2,'poem_length',0.40,'seeded'),
(2,'line_length',0.45,'seeded'),
(2,'density',0.55,'seeded'),
(2,'revision_intensity',0.60,'seeded'),
(2,'enjambment',0.50,'seeded'),
(2,'form_preference',0.20,'seeded'),
(2,'rhyme_tendency',0.15,'seeded'),
(2,'structural_clarity',0.90,'seeded'),
(2,'theme_family',0.90,'seeded'),
(2,'theme_faith',0.70,'seeded'),
(2,'theme_nature',0.40,'seeded'),
(2,'theme_work',0.60,'seeded'),
(2,'confessional_degree',0.35,'seeded'),
(2,'emotional_register',0.40,'seeded'),
(2,'time_orientation',0.75,'seeded'),
(2,'outlook',0.70,'seeded'),
(2,'risk_taking',0.25,'seeded'),
(2,'diction_register',0.45,'seeded'),
(2,'intellectual_weight',0.70,'seeded'),
(2,'narrative_tendency',0.55,'seeded'),
(2,'address',0.30,'inferred');


INSERT INTO poet_traits (poet_id, trait_key, tendency_score, confidence) VALUES
(3,'poem_length',0.70,'seeded'),
(3,'line_length',0.55,'seeded'),
(3,'density',0.80,'seeded'),
(3,'revision_intensity',0.90,'seeded'),
(3,'enjambment',0.75,'seeded'),
(3,'form_preference',0.65,'seeded'),
(3,'rhyme_tendency',0.30,'seeded'),
(3,'structural_clarity',0.85,'seeded'),
(3,'uses_sequences',0.95,'seeded'),
(3,'theme_language',0.95,'seeded'),
(3,'theme_place',0.60,'seeded'),
(3,'theme_mortality',0.40,'seeded'),
(3,'confessional_degree',0.50,'seeded'),
(3,'emotional_register',0.75,'seeded'),
(3,'time_orientation',0.70,'seeded'),
(3,'outlook',0.45,'seeded'),
(3,'risk_taking',0.50,'seeded'),
(3,'diction_register',0.80,'seeded'),
(3,'intellectual_weight',0.90,'seeded'),
(3,'narrative_tendency',0.40,'seeded'),
(3,'persona_use',0.35,'inferred');

INSERT INTO poet_traits (poet_id, trait_key, tendency_score, confidence) VALUES
(4,'poem_length',0.55,'seeded'),
(4,'line_length',0.55,'seeded'),
(4,'density',0.60,'seeded'),
(4,'revision_intensity',0.80,'seeded'),
(4,'enjambment',0.35,'seeded'),
(4,'form_preference',0.95,'seeded'),
(4,'rhyme_tendency',0.90,'seeded'),
(4,'structural_clarity',0.95,'seeded'),
(4,'theme_work',0.95,'seeded'),
(4,'theme_place',0.55,'seeded'),
(4,'theme_family',0.30,'seeded'),
(4,'theme_politics',0.20,'seeded'),
(4,'confessional_degree',0.20,'seeded'),
(4,'emotional_register',0.45,'seeded'),
(4,'irony_quotient',0.65,'seeded'),
(4,'time_orientation',0.65,'seeded'),
(4,'outlook',0.60,'seeded'),
(4,'risk_taking',0.30,'seeded'),
(4,'diction_register',0.60,'seeded'),
(4,'intellectual_weight',0.55,'seeded'),
(4,'narrative_tendency',0.65,'inferred');

INSERT INTO poet_traits (poet_id, trait_key, tendency_score, confidence) VALUES
(5,'poem_length',0.50,'seeded'),
(5,'line_length',0.40,'seeded'),
(5,'density',0.75,'seeded'),
(5,'revision_intensity',0.70,'seeded'),
(5,'enjambment',0.65,'seeded'),
(5,'white_space',0.60,'seeded'),
(5,'form_preference',0.55,'seeded'),
(5,'rhyme_tendency',0.20,'seeded'),
(5,'structural_clarity',0.70,'seeded'),
(5,'theme_body',0.60,'seeded'),
(5,'theme_language',0.50,'seeded'),
(5,'theme_work',0.40,'seeded'),
(5,'confessional_degree',0.40,'seeded'),
(5,'emotional_register',0.45,'seeded'),
(5,'irony_quotient',0.70,'seeded'),
(5,'time_orientation',0.45,'seeded'),
(5,'outlook',0.60,'seeded'),
(5,'risk_taking',0.90,'seeded'),
(5,'diction_register',0.65,'seeded'),
(5,'intellectual_weight',0.95,'seeded'),
(5,'narrative_tendency',0.25,'seeded');

INSERT INTO poet_traits (poet_id, trait_key, tendency_score, confidence) VALUES
(6,'poem_length',0.45,'seeded'),
(6,'line_length',0.50,'seeded'),
(6,'density',0.70,'seeded'),
(6,'revision_intensity',0.40,'seeded'),
(6,'enjambment',0.70,'seeded'),
(6,'white_space',0.50,'seeded'),
(6,'form_preference',0.40,'seeded'),
(6,'rhyme_tendency',0.20,'seeded'),
(6,'structural_clarity',0.40,'seeded'),
(6,'theme_language',0.75,'seeded'),
(6,'theme_politics',0.75,'seeded'),
(6,'theme_place',0.45,'seeded'),
(6,'confessional_degree',0.65,'seeded'),
(6,'emotional_register',0.70,'seeded'),
(6,'irony_quotient',0.45,'seeded'),
(6,'time_orientation',0.35,'seeded'),
(6,'outlook',0.50,'seeded'),
(6,'risk_taking',0.95,'seeded'),
(6,'diction_register',0.60,'seeded'),
(6,'intellectual_weight',0.85,'seeded'),
(6,'narrative_tendency',0.35,'seeded'),
(6,'persona_use',0.55,'inferred');


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

-- Seed data: literary influences for each poet
INSERT INTO poet_influences
(poet_id, influence_name, influence_type, depth)
VALUES

-- Margaret Ellison (id = 1)

(1, 'Philip Larkin', 'poet', 'significant'),
(1, 'Seamus Heaney', 'poet', 'formative'),
(1, 'Local history archives', 'other', 'significant'),
(1, 'British landscape tradition', 'movement', 'significant'),

-- Yusuf Rahman (id = 2)

(2, 'R. S. Thomas', 'poet', 'significant'),
(2, 'The Quran', 'text', 'formative'),
(2, 'Astronomy', 'art_form', 'passing'),
(2, 'Miroslav Holub', 'poet', 'significant'),

-- Elena Kovacs (id = 3)

(3, 'Paul Celan', 'poet', 'formative'),
(3, 'Wisława Szymborska', 'poet', 'significant'),
(3, 'Translation studies', 'other', 'significant'),
(3, 'Central European literary modernism', 'movement', 'significant'),
(3, 'Italo Calvino', 'other', 'passing'),

-- Thomas Arkwright (id = 4)

(4, 'Robert Frost', 'poet', 'significant'),
(4, 'Traditional English ballads', 'text', 'formative'),
(4, 'George Herbert', 'poet', 'significant'),
(4, 'Traditional craftsmanship', 'other', 'formative'),
(4, 'New Formalism', 'movement', 'significant'),

-- Lydia Chen (id = 5)

(5, 'Oulipo', 'movement', 'formative'),
(5, 'Georges Perec', 'other', 'significant'),
(5, 'Marianne Moore', 'poet', 'significant'),
(5, 'Statistics', 'other', 'formative'),
(5, 'Experimental literature', 'movement', 'significant'),

-- Aisha Mahmood (id = 6)

(6, 'Anne Carson', 'poet', 'formative'),
(6, 'Ocean Vuong', 'poet', 'significant'),
(6, 'Contemporary digital culture', 'other', 'significant'),
(6, 'Postmodernism', 'movement', 'passing'),
(6, 'Philosophy', 'other', 'formative');

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

-- Seed data
INSERT INTO poet_relationships
(poet_id, person_name, relationship_type, status, notes, introduced_week)
VALUES

-- ==========================================
-- Margaret Ellison
-- ==========================================

(
(SELECT id FROM poets WHERE name='Margaret Ellison'),
'Peter Ellison',
'deceased_loved_one',
'deceased',
'Husband of thirty-three years. Former civil engineer. Died from cancer ten years ago. Appears frequently in Margaret''s memories of shared walks and local places.',
NULL
),

(
(SELECT id FROM poets WHERE name='Margaret Ellison'),
'Sarah Ellison',
'child',
'current',
'Daughter, 41. Architect living in Bristol. Close relationship but they see each other less often than either would like.',
NULL
),

(
(SELECT id FROM poets WHERE name='Margaret Ellison'),
'Daniel Ellison',
'child',
'current',
'Son, 38. Works in environmental policy in Leeds. Shares his mother''s interest in public spaces and urban change.',
NULL
),

(
(SELECT id FROM poets WHERE name='Margaret Ellison'),
'Joan Cartwright',
'friend',
'current',
'Retired librarian and long-time walking companion. Frequently joins local history events.',
NULL
),

(
(SELECT id FROM poets WHERE name='Margaret Ellison'),
'Michael Hargreaves',
'friend',
'current',
'Chair of an Oxford local-history society. Occasionally sends Margaret obscure archival discoveries.',
NULL
),

-- ==========================================
-- Yusuf Rahman
-- ==========================================

(
(SELECT id FROM poets WHERE name='Yusuf Rahman'),
'Samira Rahman',
'partner',
'current',
'Married in 2018. Community pharmacist. Intelligent, practical and frequently the first reader of Yusuf''s poems.',
NULL
),

(
(SELECT id FROM poets WHERE name='Yusuf Rahman'),
'Leila Rahman',
'child',
'current',
'Daughter, age three. Source of both exhaustion and wonder.',
NULL
),

(
(SELECT id FROM poets WHERE name='Yusuf Rahman'),
'Abdul Rahman',
'parent',
'current',
'Father. Retired mechanical engineer. Encouraged Yusuf''s interest in science and fixing things.',
NULL
),

(
(SELECT id FROM poets WHERE name='Yusuf Rahman'),
'Nadia Rahman',
'parent',
'current',
'Mother. Former primary-school teacher. Values education and community service.',
NULL
),

(
(SELECT id FROM poets WHERE name='Yusuf Rahman'),
'James Porter',
'colleague',
'current',
'History teacher at Yusuf''s school. Frequent lunch companion and sounding board.',
NULL
),

-- ==========================================
-- Elena Kovacs
-- ==========================================

(
(SELECT id FROM poets WHERE name='Elena Kovacs'),
'Oliver Grant',
'partner',
'current',
'Academic editor. Met Elena at a translation conference in Prague. Calm, patient and intellectually curious.',
NULL
),

(
(SELECT id FROM poets WHERE name='Elena Kovacs'),
'Katalin Kovacs',
'parent',
'current',
'Mother. Retired music teacher in Hungary. Strong influence on Elena''s sensitivity to rhythm and sound.',
NULL
),

(
(SELECT id FROM poets WHERE name='Elena Kovacs'),
'Andras Kovacs',
'parent',
'deceased',
'Father. Former railway engineer. Died unexpectedly when Elena was in her twenties.',
NULL
),

(
(SELECT id FROM poets WHERE name='Elena Kovacs'),
'Zsofia Nagy',
'friend',
'current',
'Translator living in Budapest. Maintains a decades-long correspondence with Elena.',
NULL
),

(
(SELECT id FROM poets WHERE name='Elena Kovacs'),
'Aisha Mahmood',
'mentor',
'current',
'Young poet Elena informally mentors through the workshop. Appreciates her ambition and curiosity.',
NULL
),

-- ==========================================
-- Thomas Arkwright
-- ==========================================

(
(SELECT id FROM poets WHERE name='Thomas Arkwright'),
'Rachel Arkwright',
'partner',
'current',
'Primary-school headteacher. Married for thirty years. Appreciates Thomas''s stubbornness more than he deserves.',
NULL
),

(
(SELECT id FROM poets WHERE name='Thomas Arkwright'),
'Ben Arkwright',
'child',
'current',
'Software engineer living in Cambridge. Loves his father but finds him occasionally impossible.',
NULL
),

(
(SELECT id FROM poets WHERE name='Thomas Arkwright'),
'George Arkwright',
'parent',
'deceased',
'Former carpenter. Taught Thomas practical skills and respect for craftsmanship.',
NULL
),

(
(SELECT id FROM poets WHERE name='Thomas Arkwright'),
'Arthur Wells',
'friend',
'current',
'Retired blacksmith and regular customer. Shares Thomas''s enthusiasm for traditional crafts.',
NULL
),

(
(SELECT id FROM poets WHERE name='Thomas Arkwright'),
'Lydia Chen',
'rival',
'current',
'Good-natured poetic rival. They regularly disagree about free verse, constraints and experimentation.',
NULL
),

-- ==========================================
-- Lydia Chen
-- ==========================================

(
(SELECT id FROM poets WHERE name='Lydia Chen'),
'Mark Sullivan',
'ex_partner',
'past',
'Relationship ended amicably after six years. Still occasionally exchanges messages with Lydia.',
NULL
),

(
(SELECT id FROM poets WHERE name='Lydia Chen'),
'Mei Chen',
'parent',
'current',
'Mother. Accountant living in Manchester. Encouraged Lydia''s love of puzzles and numbers.',
NULL
),

(
(SELECT id FROM poets WHERE name='Lydia Chen'),
'David Chen',
'parent',
'current',
'Father. Civil engineer. Shares Lydia''s fascination with systems and design.',
NULL
),

(
(SELECT id FROM poets WHERE name='Lydia Chen'),
'Priya Nair',
'friend',
'current',
'Data scientist and enthusiastic board-game player. One of Lydia''s closest friends.',
NULL
),

(
(SELECT id FROM poets WHERE name='Lydia Chen'),
'Thomas Arkwright',
'rival',
'current',
'Frequent debating partner on poetic form. Their disagreements are affectionate and productive.',
NULL
),

-- ==========================================
-- Aisha Mahmood
-- ==========================================

(
(SELECT id FROM poets WHERE name='Aisha Mahmood'),
'Farah Mahmood',
'parent',
'current',
'Mother. Secondary-school English teacher who fostered Aisha''s love of reading.',
NULL
),

(
(SELECT id FROM poets WHERE name='Aisha Mahmood'),
'Imran Mahmood',
'parent',
'current',
'Solicitor. Encouraged debate, argument and intellectual independence.',
NULL
),

(
(SELECT id FROM poets WHERE name='Aisha Mahmood'),
'Sana Mahmood',
'sibling',
'current',
'Older sister, 24. Doctor in Birmingham. Practical and protective.',
NULL
),

(
(SELECT id FROM poets WHERE name='Aisha Mahmood'),
'Elena Kovacs',
'mentor',
'current',
'A writer Aisha greatly admires. Provides occasional feedback and encouragement.',
NULL
),

(
(SELECT id FROM poets WHERE name='Aisha Mahmood'),
'Jacob Reed',
'friend',
'current',
'Philosophy undergraduate. Frequent discussion partner on ethics, politics and technology.',
NULL
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

-- Seed data
INSERT INTO poet_events (
    poet_id,
    issue_id,
    event_type,
    description,
    source
) VALUES

-- =====================================================
-- Margaret Ellison (poet_id = 1)
-- =====================================================

(
    1,
    1,
    'life_event',
    'While clearing boxes during her move to a smaller flat, discovered notebooks kept by her late husband during the 1980s, prompting renewed reflection on memory and shared history.',
    'seeded'
),

(
    1,
    1,
    'life_event',
    'Began volunteering one afternoon each week with a local history archive, helping catalogue photographs of Oxford neighbourhoods.',
    'seeded'
),

(
    1,
    1,
    'life_event',
    'A recurring knee problem has made her aware that some of her favourite walking routes may become difficult in the coming years.',
    'seeded'
),

(
    1,
    1,
    'new_obsession',
    'Became increasingly interested in vanished footpaths, demolished buildings and other traces of forgotten urban landscapes around Oxford.',
    'seeded'
),

(
    1,
    1,
    'new_obsession',
    'Started comparing old maps with present-day streets, developing a fascination with how cities remember and forget their own histories.',
    'seeded'
),

-- =====================================================
-- Yusuf Rahman (poet_id = 2)
-- =====================================================

(
    2,
    1,
    'life_event',
    'His daughter began speaking in complete sentences, making him newly aware of language acquisition, attention and the passage of time.',
    'seeded'
),

(
    2,
    1,
    'life_event',
    'Accepted responsibility for coordinating the school science enrichment programme, increasing both workload and professional satisfaction.',
    'seeded'
),

(
    2,
    1,
    'life_event',
    'Spent several late evenings repairing household items instead of replacing them, reinforcing his appreciation for maintenance and stewardship.',
    'seeded'
),

(
    2,
    1,
    'new_obsession',
    'Developed a growing fascination with astronomical timescales after leading a school astronomy club project on stellar evolution.',
    'seeded'
),

(
    2,
    1,
    'new_obsession',
    'Became interested in the parallels between scientific measurement and the imperfect ways people assess meaning, value and responsibility.',
    'seeded'
),

-- =====================================================
-- Elena Kovacs (poet_id = 3)
-- =====================================================

(
    3,
    1,
    'life_event',
    'Accepted a demanding translation commission involving multiple narrators whose voices are intentionally difficult to distinguish.',
    'seeded'
),

(
    3,
    1,
    'life_event',
    'Returned briefly to Hungary for a family gathering and was surprised by how unfamiliar parts of her childhood city now felt.',
    'seeded'
),

(
    3,
    1,
    'life_event',
    'Renewed correspondence with an elderly Hungarian poet whose letters increasingly focus on memory, ageing and literary legacy.',
    'seeded'
),

(
    3,
    1,
    'new_obsession',
    'Began collecting examples of words and phrases that resist direct translation between languages, filling several notebooks with observations.',
    'seeded'
),

(
    3,
    1,
    'new_obsession',
    'Started keeping records of recurring images that appear independently across unrelated translation projects.',
    'seeded'
),

-- =====================================================
-- Thomas Arkwright (poet_id = 4)
-- =====================================================

(
    4,
    1,
    'life_event',
    'Received an informal enquiry from a potential buyer interested in acquiring his bicycle repair business, forcing him to seriously consider retirement.',
    'seeded'
),

(
    4,
    1,
    'life_event',
    'A younger mechanic he had informally mentored left to open a workshop of his own, leaving Thomas unexpectedly proud and reflective.',
    'seeded'
),

(
    4,
    1,
    'life_event',
    'Noticed increasing stiffness in his hands after long days in the workshop and began wondering how much longer he wishes to work full time.',
    'seeded'
),

(
    4,
    1,
    'new_obsession',
    'Started researching traditional apprenticeship records and local tradespeople from nineteenth-century Oxford.',
    'seeded'
),

(
    4,
    1,
    'new_obsession',
    'Developed a habit of collecting old tool catalogues and repair manuals, admiring the language used to describe skilled labour.',
    'seeded'
),

-- =====================================================
-- Lydia Chen (poet_id = 5)
-- =====================================================

(
    5,
    1,
    'life_event',
    'Joined several new social groups following the end of a long relationship and is cautiously rebuilding a wider circle of friends.',
    'seeded'
),

(
    5,
    1,
    'life_event',
    'Became a lead analyst on a major longitudinal health study expected to continue for several years.',
    'seeded'
),

(
    5,
    1,
    'life_event',
    'Started attending a monthly puzzle and games evening, finding unexpected enjoyment in meeting people outside academic circles.',
    'seeded'
),

(
    5,
    1,
    'new_obsession',
    'Became intrigued by the ways statistical models succeed and fail when predicting rare events, leading to broader reflections on uncertainty.',
    'seeded'
),

(
    5,
    1,
    'new_obsession',
    'Started designing self-imposed writing constraints inspired by probability theory, combinatorics and information systems.',
    'seeded'
),

-- =====================================================
-- Aisha Mahmood (poet_id = 6)
-- =====================================================

(
    6,
    1,
    'life_event',
    'Completed her first term away from home and returned to Oxford with a stronger sense of independence but lingering uncertainty about identity and belonging.',
    'seeded'
),

(
    6,
    1,
    'life_event',
    'Became involved in a student discussion group focused on ethics, technology and public policy.',
    'seeded'
),

(
    6,
    1,
    'life_event',
    'Formed several close friendships at university that exposed her to unfamiliar political, philosophical and cultural perspectives.',
    'seeded'
),

(
    6,
    1,
    'new_obsession',
    'Developed an intense interest in how emerging technologies influence personal identity, memory and ethical responsibility.',
    'seeded'
),

(
    6,
    1,
    'new_obsession',
    'Started keeping a notebook of philosophical questions that arise from everyday conversations, lectures and online debates.',
    'seeded'
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