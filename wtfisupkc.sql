BEGIN;

CREATE TABLE location (
    id              serial              NOT NULL,
    name            text                NOT NULL,
    capacity        integer             NOT NULL,
    latitude        double precision    NOT NULL,
    longitude       double precision    NOT NULL,
    
    PRIMARY KEY (id),
    UNIQUE (latitude, longitude)
);

CREATE TABLE event (
    id              serial              NOT NULL,
    name            text                NOT NULL,
    time            timestamp           NOT NULL,

    location_id     integer             NOT NULL,

    PRIMARY KEY (id),

    FOREIGN KEY (location_id) REFERENCES location(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE VIEW current_event AS
     SELECT event.name AS event_name, event.time, location.name AS location_name, location.capacity
       FROM event, location
      WHERE event.time < (now() + interval '3 hours') AND 
            event.time > (now() - interval '3 hours') AND
            event.location_id = location.id
   ORDER BY location.name ASC, event.time ASC;

COMMIT;
