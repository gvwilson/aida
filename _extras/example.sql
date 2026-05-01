drop table if exists penguins;
drop table if exists islands;

create table islands (
   island text not null,
   lat_s float not null,
   long_w float not null,
   area_km2 float not null,
   max_elevation_m integer not null,
   shape text not null,
   features text not null
);

create table penguins (
   species text not null,
   island text not null references islands(island),
   bill_length_mm float,
   bill_depth_mm float,
   flipper_length_mm integer,
   body_mass_g integer,
   sex text
);

drop table if exists squirrels;
create table squirrels (
   x float not null,
   y float not null,
   "unique squirrel id" text not null,
   hectare text not null,
   shift text not null,
   date integer not null,
   "hectare squirrel number" integer not null,
   age text,
   "primary fur color" text,
   "highlight fur color" text,
   "combination of primary and highlight color" text not null,
   "color notes" text,
   location text,
   "above ground sighter measurement" text,
   "specific location" text,
   running bool not null,
   chasing bool not null,
   climbing bool not null,
   eating bool not null,
   foraging bool not null,
   "other activities" text,
   kuks bool not null,
   quaas bool not null,
   moans bool not null,
   "tail flags" bool not null,
   "tail twitches" bool not null,
   approaches bool not null,
   indifferent bool not null,
   "runs from" bool not null,
   "other interactions" text,
   "lat/long" text not null
);

.mode csv
.import --skip 1 islands.csv islands
.import --skip 1 penguins.csv penguins
.import --skip 1 squirrels.csv squirrels

update squirrels set
    running     = case when running     = '' then null else (lower(running)     = 'true') end,
    chasing     = case when chasing     = '' then null else (lower(chasing)     = 'true') end,
    climbing    = case when climbing    = '' then null else (lower(climbing)    = 'true') end,
    eating      = case when eating      = '' then null else (lower(eating)      = 'true') end,
    foraging    = case when foraging    = '' then null else (lower(foraging)    = 'true') end,
    kuks        = case when kuks        = '' then null else (lower(kuks)        = 'true') end,
    quaas       = case when quaas       = '' then null else (lower(quaas)       = 'true') end,
    moans       = case when moans       = '' then null else (lower(moans)       = 'true') end,
    "tail flags"    = case when "tail flags"    = '' then null else (lower("tail flags")    = 'true') end,
    "tail twitches" = case when "tail twitches" = '' then null else (lower("tail twitches") = 'true') end,
    approaches  = case when approaches  = '' then null else (lower(approaches)  = 'true') end,
    indifferent = case when indifferent = '' then null else (lower(indifferent) = 'true') end,
    "runs from" = case when "runs from" = '' then null else (lower("runs from") = 'true') end;
