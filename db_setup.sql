CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);


CREATE TABLE skills (
    id SERIAL PRIMARY KEY,
    role_id INT REFERENCES roles(id) ON DELETE CASCADE,
    name TEXT NOT NULL
);


CREATE TABLE resources (
    id SERIAL PRIMARY KEY,
    skill_id INT REFERENCES skills(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    url TEXT NOT NULL,
    type TEXT CHECK (type IN ('course', 'book', 'video', 'article', 'podcast')),
    vetted BOOLEAN DEFAULT FALSE
);


INSERT INTO roles (name) VALUES 
('Prompt Engineer'),
('Data Scientist'),
('Product Manager'),
('Venture Capitalist'),
('Management Consultant');


INSERT INTO skills (role_id, name) VALUES 
(1, 'Prompt Engineering Techniques'),
(1, 'AI Ethics'),
(1, 'Python Scripting'),
(1, 'Machine Learning Basics'),
(1, 'Natural Language Processing'),
(2, 'Machine Learning'),
(2, 'Data Visualization'),
(2, 'SQL & Databases'),
(2, 'Deep Learning'),
(2, 'Statistics'),
(3, 'Product Strategy'),
(3, 'User Experience (UX)'),
(3, 'Market Research'),
(3, 'Agile Methodology'),
(3, 'Stakeholder Communication'),
(4, 'Financial Modeling'),
(4, 'Market Analysis'),
(4, 'Pitching & Fundraising'),
(4, 'Business Strategy'),
(4, 'Due Diligence'),
(5, 'Consulting Frameworks'),
(5, 'Problem Solving'),
(5, 'Data Analytics'),
(5, 'Public Speaking'),
(5, 'Negotiation');


INSERT INTO resources (skill_id, title, url, type, vetted) VALUES 
(1, 'Prompt Engineering Guide', 'https://www.prompting101.com', 'article', TRUE),
(2, 'AI Ethics by Harvard', 'https://cs50.aiethics.harvard.edu', 'course', TRUE),
(3, 'Automate Boring Stuff with Python', 'https://automatetheboringstuff.com', 'book', TRUE),
(6, 'Intro to ML by Andrew Ng', 'https://www.coursera.org/ml-course', 'course', TRUE),
(5, 'NLP with Transformers', 'https://huggingface.co/course', 'course', TRUE);
