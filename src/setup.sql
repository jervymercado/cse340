CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

SELECT * FROM organization;


CREATE TABLE project (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(150) NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (organization_id) REFERENCES organization (organization_id)
);

SELECT organization_id, name FROM organization;

INSERT INTO project (organization_id, title, description, location, date)
VALUES
(1, 'Community Garden Build', 'Constructing raised garden beds for a neighborhood community center.', 'Springfield, IL', '2026-03-10'),
(1, 'Playground Renovation', 'Repairing and upgrading playground equipment at a local park.', 'Springfield, IL', '2026-04-22'),
(1, 'Roof Repair for Elderly Housing', 'Volunteer crew repairing roofs for low-income senior housing.', 'Decatur, IL', '2026-05-15'),
(1, 'Wheelchair Ramp Installation', 'Building accessibility ramps for homes of disabled residents.', 'Springfield, IL', '2026-06-01'),
(1, 'Storm Shelter Construction', 'Building a community storm shelter for emergency preparedness.', 'Decatur, IL', '2026-07-20'),

(2, 'Urban Farm Expansion', 'Adding new growing plots to the downtown urban farm.', 'Chicago, IL', '2026-03-18'),
(2, 'Composting Workshop Series', 'Teaching households how to compost food waste.', 'Chicago, IL', '2026-04-05'),
(2, 'School Garden Program', 'Installing vegetable gardens at three elementary schools.', 'Evanston, IL', '2026-05-02'),
(2, 'Farmers Market Support', 'Coordinating volunteer support for a weekly farmers market.', 'Chicago, IL', '2026-06-14'),
(2, 'Seed Library Launch', 'Setting up a free community seed-sharing library.', 'Evanston, IL', '2026-07-09'),

(3, 'Food Pantry Restock Drive', 'Organizing a donation drive to restock the local food pantry.', 'Naperville, IL', '2026-03-25'),
(3, 'Winter Coat Drive', 'Collecting and distributing winter coats to families in need.', 'Naperville, IL', '2026-04-11'),
(3, 'Volunteer Training Day', 'Hosting a training day for new volunteer coordinators.', 'Aurora, IL', '2026-05-20'),
(3, 'Senior Companion Program', 'Pairing volunteers with isolated seniors for weekly visits.', 'Aurora, IL', '2026-06-08'),
(3, 'Neighborhood Cleanup', 'Organizing a large-scale litter and cleanup event.', 'Naperville, IL', '2026-07-17');

SELECT * FROM project;


CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE project_category (
    project_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    PRIMARY KEY (project_id, category_id),
    FOREIGN KEY (project_id) REFERENCES project (project_id),
    FOREIGN KEY (category_id) REFERENCES category (category_id)
);

INSERT INTO category (name)
VALUES
('Construction'),
('Food Security'),
('Education'),
('Environment'),
('Community Support');

SELECT * FROM category;

INSERT INTO project_category (project_id, category_id)
VALUES
(1, 1),   -- Community Garden Build -> Construction
(2, 1),   -- Playground Renovation -> Construction
(3, 1),   -- Roof Repair for Elderly Housing -> Construction
(4, 1),   -- Wheelchair Ramp Installation -> Construction
(5, 1),   -- Storm Shelter Construction -> Construction
(6, 4),   -- Urban Farm Expansion -> Environment
(6, 2),   -- Urban Farm Expansion -> Food Security (example of 2 categories on one project)
(7, 4),   -- Composting Workshop Series -> Environment
(8, 3),   -- School Garden Program -> Education
(8, 4),   -- School Garden Program -> Environment
(9, 2),   -- Farmers Market Support -> Food Security
(10, 3),  -- Seed Library Launch -> Education
(11, 2),  -- Food Pantry Restock Drive -> Food Security
(12, 5),  -- Winter Coat Drive -> Community Support
(13, 3),  -- Volunteer Training Day -> Education
(14, 5),  -- Senior Companion Program -> Community Support
(15, 4);  -- Neighborhood Cleanup -> Environment

SELECT * FROM project_category;