
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

-- todo: 2.1、分组
-- 1）、查询各科成绩最高和最低的分，以如下的形式显示：课程号，最高分，最低分；
SELECT
    course_id
    , max(score) AS max_score
    , min(score) AS min_score
FROM hive_sql_zg5.score_info
GROUP BY course_id
;


-- 2）、查询每门课程有多少学生参加了考试（有考试成绩）；
-- todo: 两种写法 -> 正常写法，优化写法
-- 正常写法
SELECT
    course_id
    , count(DISTINCT stu_id) AS stu_course_cnt
FROM hive_sql_zg5.score_info
GROUP BY course_id
;

-- 优化写法: count + distinct = group by + count
/*
    CTE 查询语句  Create Table Expression
*/
WITH
    -- step1. 去重，可能成绩有重复
    tmp1 AS (
        SELECT
            course_id, stu_id
        FROM hive_sql_zg5.score_info
        GROUP BY course_id, stu_id
    )
-- step2. 计数
SELECT
    course_id
    , count(stu_id) AS stu_course_cnt
FROM tmp1
GROUP BY course_id
;



-- 3）、查询男生、女生人数；
/*
    sex  cnt
    男    23
    女    24


    男    女
    23    24
 */

SELECT
    sex
    , count(stu_id) AS sex_cnt
FROM hive_sql_zg5.student_info
GROUP BY sex
;


SELECT
    sum(if(sex = '男', 1, 0)) AS male_cnt
    , sum(if(sex = '女', 1, 0)) AS female_cnt
FROM hive_sql_zg5.student_info
;



-- todo：2.2、分组结果的条件
-- 1）、查询平均成绩大于60分的学生的学号和平均成绩；
SELECT
    stu_id
    , round(avg(score), 2) AS avg_score
FROM hive_sql_zg5.score_info
GROUP BY stu_id
HAVING round(avg(score), 2) > 60
;


/*
    todo 查询每门成绩都及格学生  -> 最小成绩 > 60
*/
SELECT
    stu_id
    , min(score) AS min_score
    , collect_list(score) AS score_list
FROM hive_sql_zg5.score_info
GROUP BY stu_id
HAVING min_score > 60
;


-- 2）、查询至少选修四门课程的学生学号；
SELECT
    stu_id
    , count(DISTINCT course_id) AS course_cnt
FROM hive_sql_zg5.score_info
GROUP BY stu_id
HAVING course_cnt >= 4
;



-- 3）、查询同姓（假设每个学生姓名的第一个字为姓）的学生名单并统计同姓人数大于2的姓；
SELECT
    substring(stu_name, 1, 1) AS first_name
    , count(stu_id) AS stu_cnt
FROM hive_sql_zg5.student_info
GROUP BY substring(stu_name, 1, 1)
HAVING count(stu_id) >= 2
;



-- todo 哪些函数
SHOW FUNCTIONS  ;

-- todo 查看某个函数使用
DESC FUNCTION substring ;
/*
substring(str, pos[, len])
    - returns the substring of str that starts at pos and is of length len orsubstring(bin, pos[, len])
    - returns the slice of byte array that starts at pos and is of length len
*/
SELECT
    substring('杨子豪', 0, 1) AS x1
    , substring('杨子豪', 1, 1) AS x2
;

-- 4）、查询每门课程的平均成绩，结果按平均成绩升序排序，平均成绩相同时，按课程号降序排列；
SELECT
    course_id
    , round(avg(score), 2) AS avg_score
FROM hive_sql_zg5.score_info
GROUP BY course_id
ORDER BY avg_score, course_id DESC
;


-- 5）、统计参加考试人数大于等于15的学科；
SELECT
    course_id
    , count(course_id) AS course_cnt
FROM hive_sql_zg5.score_info
GROUP BY course_id
HAVING count(course_id) >= 15
;

