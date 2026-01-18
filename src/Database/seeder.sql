-- Seed data for gestion_etudiants
-- This file populates the database with test data

-- Configuration de l'encodage
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ============================================
-- INSERTION DES UTILISATEURS
-- ============================================

INSERT INTO users (id, nom, prenom, email, password, role, statut, departement, telephone, bureau) VALUES
(1, 'Admin', 'Système', 'admin@gestion-etudiants.com', 'admin123', 'admin', 'actif', 'Administration', '+237 690 000 001', 'Bureau A101'),
(2, 'Mbarga', 'Paul', 'paul.mbarga@gestion-etudiants.com', 'prof123', 'professeur', 'actif', 'Informatique', '+237 691 234 567', 'Bureau B205'),
(3, 'Ngono', 'Claire', 'claire.ngono@gestion-etudiants.com', 'prof123', 'professeur', 'actif', 'Mathématiques', '+237 692 345 678', 'Bureau B210')
ON DUPLICATE KEY UPDATE 
  nom = VALUES(nom),
  prenom = VALUES(prenom);

-- ============================================
-- INSERTION DES ÉTUDIANTS
-- ============================================

INSERT INTO etudiants (
  numero_etudiant, prenom, nom, date_naissance, genre, email, telephone,
  adresse_rue, adresse_ville, adresse_code_postal, adresse_pays,
  date_inscription, filiere, niveau, statut, created_by
) VALUES
-- Informatique
('26A0001', 'Marie', 'NGUEMA', '2003-05-15', 'femme', 'marie.nguema@etudiant.com', '+237 690 123 456', 'Quartier Bastos, Rue 1234', 'Yaoundé', '12345', 'Cameroun', '2024-09-01', 'Informatique', 'L2', 'actif', 1),
('26A0002', 'David', 'ESSOMBA', '2003-08-22', 'homme', 'david.essomba@etudiant.com', '+237 691 123 457', 'Mendong, Carrefour Total', 'Yaoundé', '12346', 'Cameroun', '2024-09-01', 'Informatique', 'L2', 'actif', 1),
('26A0003', 'Aminata', 'DIALLO', '2002-11-10', 'femme', 'aminata.diallo@etudiant.com', '+237 692 123 458', 'Emana, Rue principale', 'Yaoundé', '12347', 'Cameroun', '2023-09-01', 'Informatique', 'L3', 'actif', 2),

-- Mathématiques
('26B0001', 'Jean', 'KAMENI', '2002-08-20', 'homme', 'jean.kameni@etudiant.com', '+237 691 234 567', 'Odza, Borne 10', 'Yaoundé', '23456', 'Cameroun', '2024-09-01', 'Mathématiques', 'L3', 'actif', 1),
('26B0002', 'Patricia', 'FOTSO', '2003-03-18', 'femme', 'patricia.fotso@etudiant.com', '+237 692 234 568', 'Nkolbisson, Avenue principale', 'Yaoundé', '23457', 'Cameroun', '2024-09-01', 'Mathématiques', 'L2', 'actif', 3),
('26B0003', 'Ibrahim', 'MAHAMAT', '2001-06-25', 'homme', 'ibrahim.mahamat@etudiant.com', '+237 693 234 569', 'Tsinga, Carrefour', 'Yaoundé', '23458', 'Cameroun', '2022-09-01', 'Mathématiques', 'M1', 'actif', 3),

-- Physique
('26C0001', 'Sophie', 'EKOTTO', '2001-12-10', 'femme', 'sophie.ekotto@etudiant.com', '+237 692 345 678', 'Mvan, Carrefour', 'Yaoundé', '34567', 'Cameroun', '2023-09-01', 'Physique', 'M1', 'actif', 2),
('26C0002', 'Marc', 'ONANA', '2002-04-15', 'homme', 'marc.onana@etudiant.com', '+237 693 345 679', 'Damas, Rond-point', 'Yaoundé', '34568', 'Cameroun', '2023-09-01', 'Physique', 'L3', 'actif', 2),

-- Chimie
('26D0001', 'Fatima', 'ABOUBAKAR', '2003-07-08', 'femme', 'fatima.aboubakar@etudiant.com', '+237 694 456 789', 'Mokolo, Marché', 'Yaoundé', '45678', 'Cameroun', '2024-09-01', 'Chimie', 'L2', 'actif', 1),
('26D0002', 'Kevin', 'TCHOUA', '2002-09-30', 'homme', 'kevin.tchoua@etudiant.com', '+237 695 456 790', 'Essos, Avenue Kennedy', 'Yaoundé', '45679', 'Cameroun', '2023-09-01', 'Chimie', 'L3', 'actif', 1),

-- Biologie
('26E0001', 'Sandrine', 'MOUKOKO', '2001-01-20', 'femme', 'sandrine.moukoko@etudiant.com', '+237 696 567 890', 'Ngoa-Ekellé, Rue 3015', 'Yaoundé', '56789', 'Cameroun', '2022-09-01', 'Biologie', 'M1', 'actif', 2),
('26E0002', 'Eric', 'NKOLO', '2003-02-14', 'homme', 'eric.nkolo@etudiant.com', '+237 697 567 891', 'Nkomkana, Carrefour Nkomkana', 'Yaoundé', '56790', 'Cameroun', '2024-09-01', 'Biologie', 'L2', 'actif', 2)
ON DUPLICATE KEY UPDATE 
  prenom = VALUES(prenom),
  nom = VALUES(nom),
  email = VALUES(email);

-- ============================================
-- INSERTION DES COURS
-- ============================================

INSERT INTO cours (code, nom, description, professeur, filiere, credits, semestre, capacite_max, jour, heure_debut, heure_fin, salle, statut) VALUES
-- Cours d'Informatique
('INF101', 'Programmation Python', 'Introduction à la programmation en Python', 'Paul Mbarga', 'Informatique', 6, 'S1', 30, 'Lundi', '08:00:00', '10:00:00', 'Salle B201', 'actif'),
('INF102', 'Bases de données', 'Introduction aux systèmes de gestion de bases de données', 'Paul Mbarga', 'Informatique', 6, 'S1', 30, 'Mardi', '10:00:00', '12:00:00', 'Salle B202', 'actif'),
('INF201', 'Algorithmes avancés', 'Étude des structures de données et algorithmes complexes', 'Paul Mbarga', 'Informatique', 8, 'S2', 25, 'Mercredi', '14:00:00', '16:00:00', 'Salle B203', 'actif'),

-- Cours de Mathématiques
('MAT101', 'Analyse I', 'Introduction à l\'analyse mathématique', 'Claire Ngono', 'Mathématiques', 6, 'S1', 40, 'Lundi', '10:00:00', '12:00:00', 'Salle A101', 'actif'),
('MAT201', 'Algèbre Linéaire', 'Étude des espaces vectoriels et matrices', 'Claire Ngono', 'Mathématiques', 6, 'S1', 40, 'Mardi', '10:00:00', '12:00:00', 'Salle A105', 'actif'),
('MAT301', 'Statistiques', 'Introduction aux probabilités et statistiques', 'Claire Ngono', 'Mathématiques', 8, 'S2', 35, 'Jeudi', '08:00:00', '10:00:00', 'Salle A106', 'actif'),

-- Cours de Physique
('PHY101', 'Mécanique classique', 'Principes fondamentaux de la mécanique', 'Paul Mbarga', 'Physique', 6, 'S1', 30, 'Lundi', '14:00:00', '16:00:00', 'Labo P101', 'actif'),
('PHY301', 'Mécanique Quantique', 'Introduction à la mécanique quantique', 'Paul Mbarga', 'Physique', 8, 'S1', 25, 'Mercredi', '14:00:00', '16:00:00', 'Labo P201', 'actif'),

-- Cours de Chimie
('CHI101', 'Chimie Générale', 'Principes fondamentaux de la chimie', 'Claire Ngono', 'Chimie', 6, 'S1', 35, 'Mardi', '08:00:00', '10:00:00', 'Labo C101', 'actif'),
('CHI201', 'Chimie Organique', 'Étude des composés organiques', 'Claire Ngono', 'Chimie', 8, 'S2', 30, 'Jeudi', '10:00:00', '12:00:00', 'Labo C102', 'actif'),

-- Cours de Biologie
('BIO101', 'Biologie Cellulaire', 'Structure et fonction des cellules', 'Paul Mbarga', 'Biologie', 6, 'S1', 30, 'Vendredi', '08:00:00', '10:00:00', 'Labo B101', 'actif'),
('BIO301', 'Génétique', 'Principes de l\'hérédité et de la génétique moléculaire', 'Paul Mbarga', 'Biologie', 8, 'S2', 25, 'Vendredi', '14:00:00', '16:00:00', 'Labo B201', 'actif')
ON DUPLICATE KEY UPDATE 
  nom = VALUES(nom),
  description = VALUES(description);

-- ============================================
-- ASSOCIATION COURS-NIVEAUX
-- ============================================

INSERT INTO cours_niveaux (cours_id, niveau) VALUES
-- Informatique
(1, 'L2'), (1, 'L3'),
(2, 'L2'), (2, 'L3'),
(3, 'L3'), (3, 'M1'),

-- Mathématiques
(4, 'L2'), (4, 'L3'),
(5, 'L3'), (5, 'M1'),
(6, 'M1'), (6, 'M2'),

-- Physique
(7, 'L2'), (7, 'L3'),
(8, 'M1'), (8, 'M2'),

-- Chimie
(9, 'L2'), (9, 'L3'),
(10, 'L3'), (10, 'M1'),

-- Biologie
(11, 'L2'), (11, 'L3'),
(12, 'M1'), (12, 'M2')
ON DUPLICATE KEY UPDATE niveau = VALUES(niveau);

-- ============================================
-- INSCRIPTIONS DES ÉTUDIANTS AUX COURS
-- ============================================

INSERT INTO inscriptions (etudiant_id, cours_id, statut) VALUES
-- Marie NGUEMA (Informatique L2)
(1, 1, 'inscrit'), (1, 2, 'inscrit'),

-- David ESSOMBA (Informatique L2)
(2, 1, 'inscrit'), (2, 2, 'inscrit'),

-- Aminata DIALLO (Informatique L3)
(3, 1, 'inscrit'), (3, 2, 'inscrit'), (3, 3, 'inscrit'),

-- Jean KAMENI (Mathématiques L3)
(4, 5, 'inscrit'), (4, 4, 'inscrit'),

-- Patricia FOTSO (Mathématiques L2)
(5, 4, 'inscrit'),

-- Ibrahim MAHAMAT (Mathématiques M1)
(6, 5, 'inscrit'), (6, 6, 'inscrit'),

-- Sophie EKOTTO (Physique M1)
(7, 8, 'inscrit'),

-- Marc ONANA (Physique L3)
(8, 7, 'inscrit'),

-- Fatima ABOUBAKAR (Chimie L2)
(9, 9, 'inscrit'),

-- Kevin TCHOUA (Chimie L3)
(10, 9, 'inscrit'), (10, 10, 'inscrit'),

-- Sandrine MOUKOKO (Biologie M1)
(11, 12, 'inscrit'),

-- Eric NKOLO (Biologie L2)
(12, 11, 'inscrit')
ON DUPLICATE KEY UPDATE statut = VALUES(statut);

-- ============================================
-- NOTES DES ÉTUDIANTS
-- ============================================

INSERT INTO notes (etudiant_id, cours_id, note_examen, note_cc, type_evaluation, validee, validee_par) VALUES
-- Marie NGUEMA
(1, 1, 15.5, 14.0, 'examen', TRUE, 2),
(1, 2, 16.0, 15.5, 'examen', TRUE, 2),

-- David ESSOMBA
(2, 1, 13.0, 12.5, 'examen', TRUE, 2),
(2, 2, 14.5, 13.0, 'examen', TRUE, 2),

-- Aminata DIALLO
(3, 1, 17.0, 16.5, 'examen', TRUE, 2),
(3, 2, 16.5, 17.0, 'examen', TRUE, 2),
(3, 3, 15.0, 14.5, 'examen', TRUE, 2),

-- Jean KAMENI
(4, 4, 14.0, 13.5, 'examen', TRUE, 3),
(4, 5, 16.0, 15.5, 'examen', TRUE, 3),

-- Patricia FOTSO
(5, 4, 15.0, 14.0, 'examen', TRUE, 3),

-- Ibrahim MAHAMAT
(6, 5, 17.5, 18.0, 'examen', TRUE, 3),
(6, 6, 16.0, 15.5, 'examen', TRUE, 3),

-- Sophie EKOTTO
(7, 8, 14.0, 13.5, 'examen', TRUE, 2),

-- Marc ONANA
(8, 7, 13.5, 14.0, 'examen', TRUE, 2),

-- Fatima ABOUBAKAR
(9, 9, 15.5, 16.0, 'examen', TRUE, 3),

-- Kevin TCHOUA
(10, 9, 14.5, 15.0, 'examen', TRUE, 3),
(10, 10, 13.0, 12.5, 'examen', TRUE, 3),

-- Sandrine MOUKOKO
(11, 12, 16.5, 17.0, 'examen', TRUE, 2),

-- Eric NKOLO
(12, 11, 14.0, 13.5, 'examen', TRUE, 2)
ON DUPLICATE KEY UPDATE 
  note_examen = VALUES(note_examen),
  note_cc = VALUES(note_cc);