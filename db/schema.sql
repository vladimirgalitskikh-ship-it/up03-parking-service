PRAGMA foreign_keys=ON;
CREATE TABLE parking_zone(
 id INTEGER PRIMARY KEY,
 name TEXT NOT NULL UNIQUE,
 floor INTEGER NOT NULL,
 is_active INTEGER NOT NULL
);
CREATE TABLE parking_space(
 id INTEGER PRIMARY KEY,
 zone_id INTEGER NOT NULL REFERENCES parking_zone(id) ON DELETE RESTRICT,
 number TEXT NOT NULL,
 status TEXT NOT NULL,
 UNIQUE(zone_id,number),
 CHECK(status IN ('FREE','OCCUPIED','BLOCKED'))
);
CREATE TABLE vehicle(
 id INTEGER PRIMARY KEY,
 plate TEXT NOT NULL UNIQUE,
 brand TEXT NOT NULL,
 color TEXT NOT NULL
);
CREATE TABLE tariff(
 id INTEGER PRIMARY KEY,
 name TEXT NOT NULL UNIQUE,
 kind TEXT NOT NULL,
 rate NUMERIC NOT NULL CHECK(rate>=0),
 unit_minutes INTEGER NOT NULL,
 CHECK(kind IN ('HOUR','DAY','SUBSCRIPTION')),
 CHECK(unit_minutes>0)
);
CREATE TABLE parking_session(
 id INTEGER PRIMARY KEY,
 vehicle_id INTEGER NOT NULL REFERENCES vehicle(id) ON DELETE RESTRICT,
 space_id INTEGER NOT NULL REFERENCES parking_space(id) ON DELETE RESTRICT,
 tariff_id INTEGER NOT NULL REFERENCES tariff(id) ON DELETE RESTRICT,
 entry_at TEXT NOT NULL,
 exit_at TEXT,
 agreed_rate NUMERIC NOT NULL CHECK(agreed_rate>=0),
 amount_due NUMERIC NOT NULL CHECK(amount_due>=0),
 CHECK(exit_at IS NULL OR exit_at>=entry_at)
);
CREATE TABLE payment(
 id INTEGER PRIMARY KEY,
 session_id INTEGER NOT NULL REFERENCES parking_session(id) ON DELETE RESTRICT,
 paid_at TEXT NOT NULL,
 amount NUMERIC NOT NULL CHECK(amount>=0),
 method TEXT NOT NULL,
 status TEXT NOT NULL,
 CHECK(method IN ('CASH','CARD')),
 CHECK(status IN ('SUCCESS','FAILED'))
);
CREATE TABLE subscription(
 id INTEGER PRIMARY KEY,
 vehicle_id INTEGER NOT NULL REFERENCES vehicle(id) ON DELETE RESTRICT,
 tariff_id INTEGER NOT NULL REFERENCES tariff(id) ON DELETE RESTRICT,
 starts_at TEXT NOT NULL,
 ends_at TEXT NOT NULL,
 paid_amount NUMERIC NOT NULL CHECK(paid_amount>=0),
 CHECK(ends_at>starts_at)
);
CREATE UNIQUE INDEX one_active_vehicle ON parking_session(vehicle_id) WHERE exit_at IS NULL;
CREATE UNIQUE INDEX one_active_space ON parking_session(space_id) WHERE exit_at IS NULL;
INSERT INTO parking_zone VALUES(1,'Основная',0,1);
INSERT INTO parking_space VALUES(1,1,'A01','FREE'),(2,1,'A02','OCCUPIED');
INSERT INTO vehicle VALUES(1,'A001AA77','Учебная марка','Белый'),(2,'A002AA77','Учебная марка','Серый');
INSERT INTO tariff VALUES(1,'Часовой','HOUR',100,60),(2,'Суточный','DAY',700,1440),(3,'Месячный','SUBSCRIPTION',6000,43200);
INSERT INTO parking_session VALUES(1,1,1,1,'2026-11-01 10:00','2026-11-01 12:10',100,300),(2,2,2,1,'2026-11-01 11:00',NULL,100,0);
INSERT INTO payment VALUES(1,1,'2026-11-01 12:10',300,'CARD','SUCCESS');
INSERT INTO subscription VALUES(1,1,3,'2026-12-01','2027-01-01',6000);
