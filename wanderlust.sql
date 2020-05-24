--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: albums; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.albums (
    id integer NOT NULL,
    user_id integer,
    country_id integer,
    title character varying(50) NOT NULL,
    created_on timestamp without time zone
);


ALTER TABLE public.albums OWNER TO postgres;

--
-- Name: albums_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.albums_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.albums_id_seq OWNER TO postgres;

--
-- Name: albums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.albums_id_seq OWNED BY public.albums.id;


--
-- Name: country_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.country_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.country_seq OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id integer DEFAULT nextval('public.country_seq'::regclass) NOT NULL,
    iso character(2) NOT NULL,
    name character varying(80) NOT NULL,
    nicename character varying(80) NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.photos (
    id integer NOT NULL,
    user_id integer,
    album_id integer,
    image text,
    upload_on timestamp without time zone
);


ALTER TABLE public.photos OWNER TO postgres;

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.photos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photos_id_seq OWNER TO postgres;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.photos_id_seq OWNED BY public.photos.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    username character varying(30),
    email text NOT NULL,
    password text,
    image text,
    location integer,
    bio character varying(100)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: albums id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums ALTER COLUMN id SET DEFAULT nextval('public.albums_id_seq'::regclass);


--
-- Name: photos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos ALTER COLUMN id SET DEFAULT nextval('public.photos_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: albums; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.albums (id, user_id, country_id, title, created_on) FROM stdin;
1	1	1	test	2020-05-24 22:17:57.76001
2	1	1	test	2020-05-24 22:18:05.51304
3	1	3	test	2020-05-24 22:23:54.366381
4	1	1	Test	2020-05-24 22:24:00.923693
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.countries (id, iso, name, nicename) FROM stdin;
1	AF	AFGHANISTAN	Afghanistan
2	AL	ALBANIA	Albania
3	DZ	ALGERIA	Algeria
4	AS	AMERICAN SAMOA	American Samoa
5	AD	ANDORRA	Andorra
6	AO	ANGOLA	Angola
7	AI	ANGUILLA	Anguilla
8	AQ	ANTARCTICA	Antarctica
9	AG	ANTIGUA AND BARBUDA	Antigua and Barbuda
10	AR	ARGENTINA	Argentina
11	AM	ARMENIA	Armenia
12	AW	ARUBA	Aruba
13	AU	AUSTRALIA	Australia
14	AT	AUSTRIA	Austria
15	AZ	AZERBAIJAN	Azerbaijan
16	BS	BAHAMAS	Bahamas
17	BH	BAHRAIN	Bahrain
18	BD	BANGLADESH	Bangladesh
19	BB	BARBADOS	Barbados
20	BY	BELARUS	Belarus
21	BE	BELGIUM	Belgium
22	BZ	BELIZE	Belize
23	BJ	BENIN	Benin
24	BM	BERMUDA	Bermuda
25	BT	BHUTAN	Bhutan
26	BO	BOLIVIA	Bolivia
27	BA	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina
28	BW	BOTSWANA	Botswana
29	BV	BOUVET ISLAND	Bouvet Island
30	BR	BRAZIL	Brazil
31	IO	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory
32	BN	BRUNEI DARUSSALAM	Brunei Darussalam
33	BG	BULGARIA	Bulgaria
34	BF	BURKINA FASO	Burkina Faso
35	BI	BURUNDI	Burundi
36	KH	CAMBODIA	Cambodia
37	CM	CAMEROON	Cameroon
38	CA	CANADA	Canada
39	CV	CAPE VERDE	Cape Verde
40	KY	CAYMAN ISLANDS	Cayman Islands
41	CF	CENTRAL AFRICAN REPUBLIC	Central African Republic
42	TD	CHAD	Chad
43	CL	CHILE	Chile
44	CN	CHINA	China
45	CX	CHRISTMAS ISLAND	Christmas Island
46	CC	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands
47	CO	COLOMBIA	Colombia
48	KM	COMOROS	Comoros
49	CG	CONGO	Congo
50	CD	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the
51	CK	COOK ISLANDS	Cook Islands
52	CR	COSTA RICA	Costa Rica
53	CI	COTE D'IVOIRE	Cote D'Ivoire
54	HR	CROATIA	Croatia
55	CU	CUBA	Cuba
56	CY	CYPRUS	Cyprus
57	CZ	CZECHIA	Czech Republic
58	DK	DENMARK	Denmark
59	DJ	DJIBOUTI	Djibouti
60	DM	DOMINICA	Dominica
61	DO	DOMINICAN REPUBLIC	Dominican Republic
62	EC	ECUADOR	Ecuador
63	EG	EGYPT	Egypt
64	SV	EL SALVADOR	El Salvador
65	GQ	EQUATORIAL GUINEA	Equatorial Guinea
66	ER	ERITREA	Eritrea
67	EE	ESTONIA	Estonia
68	ET	ETHIOPIA	Ethiopia
69	FK	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)
70	FO	FAROE ISLANDS	Faroe Islands
71	FJ	FIJI	Fiji
72	FI	FINLAND	Finland
73	FR	FRANCE	France
74	GF	FRENCH GUIANA	French Guiana
75	PF	FRENCH POLYNESIA	French Polynesia
76	TF	FRENCH SOUTHERN TERRITORIES	French Southern Territories
77	GA	GABON	Gabon
78	GM	GAMBIA	Gambia
79	GE	GEORGIA	Georgia
80	DE	GERMANY	Germany
81	GH	GHANA	Ghana
82	GI	GIBRALTAR	Gibraltar
83	GR	GREECE	Greece
84	GL	GREENLAND	Greenland
85	GD	GRENADA	Grenada
86	GP	GUADELOUPE	Guadeloupe
87	GU	GUAM	Guam
88	GT	GUATEMALA	Guatemala
89	GN	GUINEA	Guinea
90	GW	GUINEA-BISSAU	Guinea-Bissau
91	GY	GUYANA	Guyana
92	HT	HAITI	Haiti
93	HM	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island and Mcdonald Islands
94	VA	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)
95	HN	HONDURAS	Honduras
96	HK	HONG KONG	Hong Kong
97	HU	HUNGARY	Hungary
98	IS	ICELAND	Iceland
99	IN	INDIA	India
100	ID	INDONESIA	Indonesia
101	IR	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of
102	IQ	IRAQ	Iraq
103	IE	IRELAND	Ireland
104	IL	ISRAEL	Israel
105	IT	ITALY	Italy
106	JM	JAMAICA	Jamaica
107	JP	JAPAN	Japan
108	JO	JORDAN	Jordan
109	KZ	KAZAKHSTAN	Kazakhstan
110	KE	KENYA	Kenya
111	KI	KIRIBATI	Kiribati
112	KP	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of
113	KR	KOREA, REPUBLIC OF	Korea, Republic of
114	KW	KUWAIT	Kuwait
115	KG	KYRGYZSTAN	Kyrgyzstan
116	LA	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic
117	LV	LATVIA	Latvia
118	LB	LEBANON	Lebanon
119	LS	LESOTHO	Lesotho
120	LR	LIBERIA	Liberia
121	LY	LIBYAN ARAB JAMAHIRIYA	Libyan Arab Jamahiriya
122	LI	LIECHTENSTEIN	Liechtenstein
123	LT	LITHUANIA	Lithuania
124	LU	LUXEMBOURG	Luxembourg
125	MO	MACAO	Macao
126	MK	MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF	Macedonia, the Former Yugoslav Republic of
127	MG	MADAGASCAR	Madagascar
128	MW	MALAWI	Malawi
129	MY	MALAYSIA	Malaysia
130	MV	MALDIVES	Maldives
131	ML	MALI	Mali
132	MT	MALTA	Malta
133	MH	MARSHALL ISLANDS	Marshall Islands
134	MQ	MARTINIQUE	Martinique
135	MR	MAURITANIA	Mauritania
136	MU	MAURITIUS	Mauritius
137	YT	MAYOTTE	Mayotte
138	MX	MEXICO	Mexico
139	FM	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of
140	MD	MOLDOVA, REPUBLIC OF	Moldova, Republic of
141	MC	MONACO	Monaco
142	MN	MONGOLIA	Mongolia
143	MS	MONTSERRAT	Montserrat
144	MA	MOROCCO	Morocco
145	MZ	MOZAMBIQUE	Mozambique
146	MM	MYANMAR	Myanmar
147	NA	NAMIBIA	Namibia
148	NR	NAURU	Nauru
149	NP	NEPAL	Nepal
150	NL	NETHERLANDS	Netherlands
151	AN	NETHERLANDS ANTILLES	Netherlands Antilles
152	NC	NEW CALEDONIA	New Caledonia
153	NZ	NEW ZEALAND	New Zealand
154	NI	NICARAGUA	Nicaragua
155	NE	NIGER	Niger
156	NG	NIGERIA	Nigeria
157	NU	NIUE	Niue
158	NF	NORFOLK ISLAND	Norfolk Island
159	MP	NORTHERN MARIANA ISLANDS	Northern Mariana Islands
160	NO	NORWAY	Norway
161	OM	OMAN	Oman
162	PK	PAKISTAN	Pakistan
163	PW	PALAU	Palau
164	PS	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied
165	PA	PANAMA	Panama
166	PG	PAPUA NEW GUINEA	Papua New Guinea
167	PY	PARAGUAY	Paraguay
168	PE	PERU	Peru
169	PH	PHILIPPINES	Philippines
170	PN	PITCAIRN	Pitcairn
171	PL	POLAND	Poland
172	PT	PORTUGAL	Portugal
173	PR	PUERTO RICO	Puerto Rico
174	QA	QATAR	Qatar
175	RE	REUNION	Reunion
176	RO	ROMANIA	Romania
177	RU	RUSSIAN FEDERATION	Russian Federation
178	RW	RWANDA	Rwanda
179	SH	SAINT HELENA	Saint Helena
180	KN	SAINT KITTS AND NEVIS	Saint Kitts and Nevis
181	LC	SAINT LUCIA	Saint Lucia
182	PM	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon
183	VC	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines
184	WS	SAMOA	Samoa
185	SM	SAN MARINO	San Marino
186	ST	SAO TOME AND PRINCIPE	Sao Tome and Principe
187	SA	SAUDI ARABIA	Saudi Arabia
188	SN	SENEGAL	Senegal
189	RS	SERBIA	Serbia
190	SC	SEYCHELLES	Seychelles
191	SL	SIERRA LEONE	Sierra Leone
192	SG	SINGAPORE	Singapore
193	SK	SLOVAKIA	Slovakia
194	SI	SLOVENIA	Slovenia
195	SB	SOLOMON ISLANDS	Solomon Islands
196	SO	SOMALIA	Somalia
197	ZA	SOUTH AFRICA	South Africa
198	GS	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands
199	ES	SPAIN	Spain
200	LK	SRI LANKA	Sri Lanka
201	SD	SUDAN	Sudan
202	SR	SURINAME	Suriname
203	SJ	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen
204	SZ	SWAZILAND	Swaziland
205	SE	SWEDEN	Sweden
206	CH	SWITZERLAND	Switzerland
207	SY	SYRIAN ARAB REPUBLIC	Syrian Arab Republic
208	TW	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China
209	TJ	TAJIKISTAN	Tajikistan
210	TZ	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of
211	TH	THAILAND	Thailand
212	TL	TIMOR-LESTE	Timor-Leste
213	TG	TOGO	Togo
214	TK	TOKELAU	Tokelau
215	TO	TONGA	Tonga
216	TT	TRINIDAD AND TOBAGO	Trinidad and Tobago
217	TN	TUNISIA	Tunisia
218	TR	TURKEY	Turkey
219	TM	TURKMENISTAN	Turkmenistan
220	TC	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands
221	TV	TUVALU	Tuvalu
222	UG	UGANDA	Uganda
223	UA	UKRAINE	Ukraine
224	AE	UNITED ARAB EMIRATES	United Arab Emirates
225	GB	UNITED KINGDOM	United Kingdom
226	US	UNITED STATES	United States
227	UM	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands
228	UY	URUGUAY	Uruguay
229	UZ	UZBEKISTAN	Uzbekistan
230	VU	VANUATU	Vanuatu
231	VE	VENEZUELA	Venezuela
232	VN	VIET NAM	Viet Nam
233	VG	VIRGIN ISLANDS, BRITISH	Virgin Islands, British
234	VI	VIRGIN ISLANDS, U.S.	Virgin Islands, U.s.
235	WF	WALLIS AND FUTUNA	Wallis and Futuna
236	EH	WESTERN SAHARA	Western Sahara
237	YE	YEMEN	Yemen
238	ZM	ZAMBIA	Zambia
239	ZW	ZIMBABWE	Zimbabwe
240	ME	MONTENEGRO	Montenegro
241	XK	KOSOVO	Kosovo
242	AX	ALAND ISLANDS	Aland Islands
243	BQ	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba
244	CW	CURACAO	Curacao
245	GG	GUERNSEY	Guernsey
246	IM	ISLE OF MAN	Isle of Man
247	JE	JERSEY	Jersey
248	BL	SAINT BARTHELEMY	Saint Barthelemy
249	MF	SAINT MARTIN	Saint Martin
250	SX	SINT MAARTEN	Sint Maarten
251	SS	SOUTH SUDAN	South Sudan
\.


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.photos (id, user_id, album_id, image, upload_on) FROM stdin;
1	1	4	https://s3-us-west-1.amazonaws.com/wanderlust.pictures/cla/AF/Test/Hearthstone%2BScreenshot%2B05-18-20%2B15.42.51.png	2020-05-24 22:24:10.926986
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, username, email, password, image, location, bio) FROM stdin;
1	Calvin	La	cla	cla@osisoft.com	$2b$12$.vNwG1kAjfv/NsRWtRHEpOmZxZKB5cfeyGnXK.I.w3AmhLbr3xmtq	/static/images/default-pic.png	1	\N
\.


--
-- Name: albums_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.albums_id_seq', 4, true);


--
-- Name: country_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.country_seq', 1, false);


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.photos_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: photos photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: albums albums_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: albums albums_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: photos photos_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.albums(id) ON DELETE CASCADE;


--
-- Name: photos photos_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

