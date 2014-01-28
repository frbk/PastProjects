
-- Question 1
-- Procedure
CREATE OR REPLACE
PROCEDURE find_stud(v_id IN student.student_id%TYPE,
                    v_lname OUT student.last_name%TYPE,
                    v_phone OUT student.phone%TYPE,
                    v_zip OUT student.zip%TYPE) IS
  v_flag VARCHAR2(5);
BEGIN
  BEGIN
    SELECT 'YES' INTO v_flag
    FROM student
    WHERE student_id = v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('There is NO Student with the ID of: ' || v_id);
  END;
  
  IF v_flag = 'YES' THEN
    SELECT last_name, phone, zip INTO v_lname, v_phone, v_zip
    FROM student
    WHERE student_id = v_id;
    DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id || ' is ' 
                         || v_lname || ' with the phone# ' || v_phone || 
                         ' and who belongs to zip code ' || v_zip);
  END IF;
END find_stud;

-- Executing the code
-- Case 1
VARIABLE lname VARCHAR2(25)
VARIABLE phone VARCHAR2(15)
VARIABLE zip VARCHAR2(5)
EXECUTE find_stud(110, :lname, :phone, :zip)
PRINT lname phone zip 
-- Case 2
VARIABLE lname2 VARCHAR2(25)
VARIABLE phone2 VARCHAR2(15)
VARIABLE zip2 VARCHAR2(5)
EXECUTE find_stud(99, :lname2, :phone2, :zip2)
PRINT lname2 phone2 zip2 


-- Question 2
-- Procedure 
CREATE OR REPLACE
PROCEDURE drop_stud(v_id IN student.student_id%TYPE,
                    v_flag IN VARCHAR2 := 'R') IS
  v_exists VARCHAR2(5);
  v_enrollment VARCHAR2(5);
  v_deleted NUMBER(3) := 0;
  
  CURSOR c1 IS 
    SELECT *
    FROM enrollment 
    WHERE student_id = v_id;
    
  CURSOR c2 IS 
    SELECT *
    FROM grade
    WHERE student_id = v_id;
BEGIN
  BEGIN
    SELECT 'YES' INTO v_exists
    FROM student
    WHERE student_id = v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      v_exists := 'NO';
      DBMS_OUTPUT.PUT_LINE('Student with the Id: ' || v_id || 
                           ' does NOT exist. Try again.');
  END;
  
  BEGIN
    SELECT 'YES' INTO v_enrollment 
    FROM enrollment
    WHERE student_id = v_id AND rownum < 2;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      v_enrollment := 'NO';
  END;
  
  IF v_exists = 'YES' AND v_enrollment = 'YES' AND UPPER(v_flag) = 'R' THEN
    DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id || 
                         ' is enrolled in or more courses and his/her removal is denied.');
  ELSIF v_exists = 'YES' AND v_enrollment = 'NO' AND UPPER(v_flag) IN ('R', 'C') THEN
    DELETE FROM student WHERE student_id = v_id;
    DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id || 
                         ' is removed. He/she was NOT enrolled in any courses.');
  ELSIF v_exists = 'YES' AND v_enrollment = 'YES' AND UPPER(v_flag) = 'C' THEN
    FOR j in c2 LOOP
      v_deleted := v_deleted + 1;
    END LOOP;
    DELETE FROM grade WHERE student_id = v_id;
    
    FOR i in c1 LOOP
      v_deleted := v_deleted + 1;
    END LOOP;
    DELETE FROM enrollment WHERE student_id = v_id;
        
    DELETE FROM student WHERE student_id = v_id;
    v_deleted := v_deleted + 1;
    
    DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id ||
                         ' is removed. Total # of rows deleted is: '  || v_deleted);
  END IF;
END drop_stud;

-- Excuting the code 
-- Case 1
EXECUTE drop_stud(210, 'R')
SELECT section_id, numeric_grade AS "FINAL_GRADE" 
FROM grade 
WHERE student_id = 210 AND grade_type_code = 'FI';
SELECT first_name, last_name FROM student WHERE student_id = 210;
ROLLBACK;
-- Case 2
EXECUTE drop_stud(410, 'R')
SELECT section_id, numeric_grade AS "FINAL_GRADE" 
FROM grade 
WHERE student_id = 410 AND grade_type_code = 'FI';
SELECT first_name, last_name FROM student WHERE student_id = 410;
ROLLBACK;
-- Case 3 
EXECUTE drop_stud(310, 'C')
SELECT section_id, numeric_grade AS "FINAL_GRADE" 
FROM grade 
WHERE student_id = 310 AND grade_type_code = 'FI';
SELECT first_name, last_name FROM student WHERE student_id = 310;
ROLLBACK;
-- Case 4 
EXECUTE drop_stud(110, 'C')
SELECT section_id, numeric_grade AS "FINAL_GRADE" 
FROM grade 
WHERE student_id = 110 AND grade_type_code = 'FI';
SELECT first_name, last_name FROM student WHERE student_id = 110;
ROLLBACK;


-- Question 3
-- Package
CREATE OR REPLACE 
PACKAGE manage_stud AS 
  
  -- Procedures
  PROCEDURE find_stud(v_id IN student.student_id%TYPE,
                    v_lname OUT student.last_name%TYPE,
                    v_phone OUT student.phone%TYPE,
                    v_zip OUT student.zip%TYPE);
  PROCEDURE drop_stud(v_id IN student.student_id%TYPE,
                      v_flag IN VARCHAR2 := 'R');

END manage_stud;

-- Package Body
CREATE OR REPLACE PACKAGE BODY manage_stud IS
  
  PROCEDURE find_stud(v_id IN student.student_id%TYPE,
                      v_lname OUT student.last_name%TYPE,
                      v_phone OUT student.phone%TYPE,
                      v_zip OUT student.zip%TYPE) IS
    v_flag VARCHAR2(5);
  BEGIN
    BEGIN
      SELECT 'YES' INTO v_flag
      FROM student
      WHERE student_id = v_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('There is NO Student with the ID of: ' || v_id);
    END;
    
    IF v_flag = 'YES' THEN
      SELECT last_name, phone, zip INTO v_lname, v_phone, v_zip
      FROM student
      WHERE student_id = v_id;
      DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id || ' is ' 
                           || v_lname || ' with the phone# ' || v_phone || 
                           ' and who belongs to zip code ' || v_zip);
    END IF;
  END find_stud;
  
  PROCEDURE drop_stud(v_id IN student.student_id%TYPE,
                      v_flag IN VARCHAR2 := 'R') IS
    v_exists VARCHAR2(5);
    v_enrollment VARCHAR2(5);
    v_deleted NUMBER(3) := 0;
    
    CURSOR c1 IS 
      SELECT *
      FROM enrollment 
      WHERE student_id = v_id;
      
    CURSOR c2 IS 
      SELECT *
      FROM grade
      WHERE student_id = v_id;
  BEGIN
    BEGIN
      SELECT 'YES' INTO v_exists
      FROM student
      WHERE student_id = v_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        v_exists := 'NO';
        DBMS_OUTPUT.PUT_LINE('Student with the Id: ' || v_id || 
                             ' does NOT exist. Try again.');
    END;
    
    BEGIN
      SELECT 'YES' INTO v_enrollment 
      FROM enrollment
      WHERE student_id = v_id AND rownum < 2;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        v_enrollment := 'NO';
    END;
    
    IF v_exists = 'YES' AND v_enrollment = 'YES' AND UPPER(v_flag) = 'R' THEN
      DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id || 
                           ' is enrolled in or more courses and his/her removal is denied.');
    ELSIF v_exists = 'YES' AND v_enrollment = 'NO' AND UPPER(v_flag) IN ('R', 'C') THEN
      DELETE FROM student WHERE student_id = v_id;
      DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id || 
                           ' is removed. He/she was NOT enrolled in any courses.');
    ELSIF v_exists = 'YES' AND v_enrollment = 'YES' AND UPPER(v_flag) = 'C' THEN
      FOR j in c2 LOOP
        v_deleted := v_deleted + 1;
      END LOOP;
      DELETE FROM grade WHERE student_id = v_id;
      
      FOR i in c1 LOOP
        v_deleted := v_deleted + 1;
      END LOOP;
      DELETE FROM enrollment WHERE student_id = v_id;
          
      DELETE FROM student WHERE student_id = v_id;
      v_deleted := v_deleted + 1;
      
      DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id ||
                           ' is removed. Total # of rows deleted is: '  || v_deleted);
    END IF;
  END drop_stud;

END manage_stud;

-- Executing the code
-- Case 1
VARIABLE lname VARCHAR2(25)
VARIABLE phone VARCHAR2(15)
VARIABLE zip VARCHAR2(5)
EXECUTE manage_stud.find_stud(110, :lname, :phone, :zip)
PRINT lname phone zip 
-- Case 2
EXECUTE manage_stud.drop_stud(310, 'C')
SELECT section_id, numeric_grade AS "FINAL_GRADE" 
FROM grade 
WHERE student_id = 310 AND grade_type_code = 'FI';
SELECT first_name, last_name FROM student WHERE student_id = 310;
ROLLBACK;
-- Case 3
EXECUTE manage_stud.drop_stud(110, 'C')
SELECT section_id, numeric_grade AS "FINAL_GRADE" 
FROM grade 
WHERE student_id = 110 AND grade_type_code = 'FI';
SELECT first_name, last_name FROM student WHERE student_id = 110;
ROLLBACK;


-- Question 4
-- Function
CREATE OR REPLACE 
FUNCTION valid_stud(v_id IN student.student_id%TYPE) RETURN BOOLEAN IS
  v_flag VARCHAR2(5);
BEGIN
  BEGIN
    SELECT 'YES' INTO v_flag
    FROM student
    WHERE student_id = v_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      RETURN FALSE;
  END;
  RETURN TRUE;
END;

-- Overloading Package with another form of the Procedure find_stud
CREATE OR REPLACE
PROCEDURE find_stud(v_id2 IN student.student_id%TYPE,
                    v_fname OUT student.first_name%TYPE,
                    v_lname OUT student.last_name%TYPE) IS
  v_phone student.phone%TYPE;
  v_zip student.zip%TYPE;
BEGIN
  IF valid_stud(v_id2) THEN
    SELECT first_name, last_name, phone, zip INTO v_fname, v_lname, v_phone, v_zip
    FROM student
    WHERE student_id = v_id2;
    DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id2 || ' is ' 
                         || v_lname || ' with the phone# ' || v_phone || 
                         ' and who belongs to zip code ' || v_zip);
  ELSE
    DBMS_OUTPUT.PUT_LINE('There is NO Student with the ID of: ' || v_id2);
  END IF;
END find_stud;

-- Package
CREATE OR REPLACE 
PACKAGE manage_stud AS 

  -- Function
  FUNCTION valid_stud(v_id IN student.student_id%TYPE) RETURN BOOLEAN;
  
  -- Procedures
  PROCEDURE find_stud(v_id IN student.student_id%TYPE,
                      v_lname OUT student.last_name%TYPE,
                      v_phone OUT student.phone%TYPE,
                      v_zip OUT student.zip%TYPE);
  PROCEDURE find_stud(v_id2 IN student.student_id%TYPE,
                      v_fname OUT student.first_name%TYPE,
                      v_lname OUT student.last_name%TYPE);
  PROCEDURE drop_stud(v_id IN student.student_id%TYPE,
                      v_flag IN VARCHAR2 := 'R');

END manage_stud;

-- Package Body
CREATE OR REPLACE PACKAGE BODY manage_stud IS

  FUNCTION valid_stud(v_id IN student.student_id%TYPE) RETURN BOOLEAN IS
    v_flag VARCHAR2(5);
  BEGIN
    BEGIN
      SELECT 'YES' INTO v_flag
      FROM student
      WHERE student_id = v_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
    END;
    RETURN TRUE;
  END;
  
  PROCEDURE find_stud(v_id IN student.student_id%TYPE,
                      v_lname OUT student.last_name%TYPE,
                      v_phone OUT student.phone%TYPE,
                      v_zip OUT student.zip%TYPE) IS
    v_flag VARCHAR2(5);
  BEGIN
    BEGIN
      SELECT 'YES' INTO v_flag
      FROM student
      WHERE student_id = v_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('There is NO Student with the ID of: ' || v_id);
    END;
    
    IF v_flag = 'YES' THEN
      SELECT last_name, phone, zip INTO v_lname, v_phone, v_zip
      FROM student
      WHERE student_id = v_id;
      DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id || ' is ' 
                           || v_lname || ' with the phone# ' || v_phone || 
                           ' and who belongs to zip code ' || v_zip);
    END IF;
  END find_stud;
  
  PROCEDURE find_stud(v_id2 IN student.student_id%TYPE,
                      v_fname OUT student.first_name%TYPE,
                      v_lname OUT student.last_name%TYPE) IS
    v_phone student.phone%TYPE;
    v_zip student.zip%TYPE;
  BEGIN
    IF valid_stud(v_id2) THEN
      SELECT first_name, last_name, phone, zip INTO v_fname, v_lname, v_phone, v_zip
      FROM student
      WHERE student_id = v_id2;
      DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id2 || ' is ' 
                           || v_lname || ' with the phone# ' || v_phone || 
                           ' and who belongs to zip code ' || v_zip);
    ELSE
      DBMS_OUTPUT.PUT_LINE('There is NO Student with the ID of: ' || v_id2);
    END IF;
  END find_stud;
  
  PROCEDURE drop_stud(v_id IN student.student_id%TYPE,
                      v_flag IN VARCHAR2 := 'R') IS
    v_exists VARCHAR2(5);
    v_enrollment VARCHAR2(5);
    v_deleted NUMBER(3) := 0;
    
    CURSOR c1 IS 
      SELECT *
      FROM enrollment 
      WHERE student_id = v_id;
      
    CURSOR c2 IS 
      SELECT *
      FROM grade
      WHERE student_id = v_id;
  BEGIN
    BEGIN
      SELECT 'YES' INTO v_exists
      FROM student
      WHERE student_id = v_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        v_exists := 'NO';
        DBMS_OUTPUT.PUT_LINE('Student with the Id: ' || v_id || 
                             ' does NOT exist. Try again.');
    END;
    
    BEGIN
      SELECT 'YES' INTO v_enrollment 
      FROM enrollment
      WHERE student_id = v_id AND rownum < 2;
      EXCEPTION WHEN NO_DATA_FOUND THEN
        v_enrollment := 'NO';
    END;
    
    IF v_exists = 'YES' AND v_enrollment = 'YES' AND UPPER(v_flag) = 'R' THEN
      DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id || 
                           ' is enrolled in or more courses and his/her removal is denied.');
    ELSIF v_exists = 'YES' AND v_enrollment = 'NO' AND UPPER(v_flag) IN ('R', 'C') THEN
      DELETE FROM student WHERE student_id = v_id;
      DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id || 
                           ' is removed. He/she was NOT enrolled in any courses.');
    ELSIF v_exists = 'YES' AND v_enrollment = 'YES' AND UPPER(v_flag) = 'C' THEN
      FOR j in c2 LOOP
        v_deleted := v_deleted + 1;
      END LOOP;
      DELETE FROM grade WHERE student_id = v_id;
      
      FOR i in c1 LOOP
        v_deleted := v_deleted + 1;
      END LOOP;
      DELETE FROM enrollment WHERE student_id = v_id;
          
      DELETE FROM student WHERE student_id = v_id;
      v_deleted := v_deleted + 1;
      
      DBMS_OUTPUT.PUT_LINE('Student with the Id of: ' || v_id ||
                           ' is removed. Total # of rows deleted is: '  || v_deleted);
    END IF;
  END drop_stud;

END manage_stud;

-- Executing the code
-- Case 1
VARIABLE lname VARCHAR2(25)
VARIABLE fname VARCHAR2(25)
EXECUTE manage_stud.find_stud(110, :fname, :lname)
PRINT fname lname 
-- Case 2
VARIABLE lname2 VARCHAR2(25)
VARIABLE fname2 VARCHAR2(25)
EXECUTE manage_stud.find_stud(99, :fname2, :lname2)
PRINT fname2 lname2


-- Question 5
-- Add a 'Flag' column to Countries
ALTER TABLE countries 
ADD flag CHAR(7);

-- PLSQL Block
SET SERVEROUTPUT ON
SET VERIFY OFF
ACCEPT regionID PROMPT 'Index Table Key: '
DECLARE
  v_flag NUMBER(5);
  v_index NUMBER(3) := 1;
  v_regionCount NUMBER(3) := 0;
  TYPE country_type IS TABLE OF VARCHAR2(40) 
    INDEX BY BINARY_INTEGER;
  country_table country_type;
  CURSOR noCity_cursor IS
    SELECT c.country_name
    FROM countries c
    WHERE NOT EXISTS (SELECT * 
                      FROM locations l 
                      WHERE c.country_id = l.country_id) 
    ORDER BY c.country_name ASC; 
  CURSOR region_cursor IS
    SELECT c.country_name
    FROM countries c
    WHERE NOT EXISTS (SELECT * 
                      FROM locations l 
                      WHERE c.country_id = l.country_id)
    AND c.region_id = &regionID
    ORDER BY c.country_name ASC;
BEGIN
  BEGIN
    SELECT COUNT(*) INTO v_flag 
    FROM regions
    WHERE region_id = &regionID;
  END;
  IF v_flag > 0 THEN
    FOR j in noCity_cursor LOOP
      UPDATE countries SET flag = 'Empty_' || i.region_id WHERE country_id = i.country_id;
      country_table(v_index) := i.country_name;
      DBMS_OUTPUT.PUT_LINE('Index Table Key: ' || v_index || ' has a value of  ' || i.country_name);        
      v_index := v_index + 5;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('======================================================================');  
    DBMS_OUTPUT.PUT_LINE('Total number of elements in the Index Table or Number of countries with NO cities listed is: ' || country_table.COUNT);
    DBMS_OUTPUT.PUT_LINE('Second element (Country) in the Index Table is: ' || country_table(country_table.FIRST + 5));
    DBMS_OUTPUT.PUT_LINE('Before the last element (Country) in the Index Table is: ' || country_table(country_table.LAST - 5));
    DBMS_OUTPUT.PUT_LINE('======================================================================');
    FOR k IN region_cursor LOOP
      v_regionCount := v_regionCount + 1;
      DBMS_OUTPUT.PUT_LINE('In the region '|| &regionID || ' there is country ' || k.country_name || ' with NO city ');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('======================================================================');
    DBMS_OUTPUT.PUT_LINE('Total Number of countries with NO cities listed in the Region ' || &regionID || ' is ' || v_regionCount);
  ELSE
    DBMS_OUTPUT.PUT_LINE('This region ID does NOT exist: ' || &regionID);
  END IF;
END;
SELECT *
FROM countries c
WHERE NOT EXISTS (SELECT * FROM locations l WHERE c.country_id = l.country_id) 
ORDER BY c.region_id, c.country_name ASC;
ROLLBACK;
