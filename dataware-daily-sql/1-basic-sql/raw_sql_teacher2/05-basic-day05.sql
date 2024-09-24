
-- 创建数据库
CREATE DATABASE IF NOT EXISTS hive_sql_zg5;
-- 使用数据库
USE hive_sql_zg5 ;

-- todo: 5.1、表连接
-- 1）、查询学生的选课情况：学号，姓名，课程号，课程名称；
SELECT
    score.stu_id
    , stu.stu_name
    , score.course_id
    , course.course_name
FROM hive_sql_zg5.score_info score
    LEFT JOIN hive_sql_zg5.student_info stu ON score.stu_id = stu.stu_id
    LEFT JOIN hive_sql_zg5.course_info course ON score.course_id = course.course_id
;


-- 2）、查询出每门课程的及格人数和不及格人数；
WITH
    tmp1 AS (
        SELECT
            course_id
             , sum(if(score >= 60, 1, 0)) AS `及格人数`
             , sum(if(score < 60, 1, 0)) AS `不及格人数`
        FROM hive_sql_zg5.score_info
        GROUP BY course_id
    )
SELECT
    tmp1.course_id
    , course.course_name
    , tmp1.`及格人数`
    , tmp1.`不及格人数`
FROM tmp1
    LEFT JOIN hive_sql_zg5.course_info course ON tmp1.course_id = course.course_id
;


-- 3）、查询课程编号为03且课程成绩在80分以上的学生的学号和姓名及课程信息；
WITH
    tmp1 AS (
        SELECT
            stu_id
             , course_id
             , score
        FROM hive_sql_zg5.score_info
        WHERE course_id = '03' AND score > 80
    )
SELECT
    tmp1.stu_id
    , stu.stu_name
    , tmp1.course_id
    , course.course_name
    , tmp1.score
FROM tmp1
    LEFT JOIN hive_sql_zg5.student_info stu ON tmp1.stu_id = stu.stu_id
    LEFT JOIN hive_sql_zg5.course_info course ON tmp1.course_id = course.course_id
;

-- todo：5.2、多表连接
-- 1）、查询学过“李体音”老师所教的所有课的同学的学号、姓名；
WITH
    tmp1 AS (
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        WHERE course_id IN (
            SELECT
                course_id
            FROM hive_sql_zg5.course_info
            WHERE tea_id = (
                SELECT tea_id FROM hive_sql_zg5.teacher_info WHERE tea_name = '李体音'
            )
        )
        GROUP BY stu_id
        HAVING count(course_id) = (
            SELECT
                count(course_id)
            FROM hive_sql_zg5.course_info
            WHERE tea_id = (
                SELECT tea_id FROM hive_sql_zg5.teacher_info WHERE tea_name = '李体音'
            )
        )
    )
SELECT
    tmp1.stu_id
    , stu.stu_name
FROM tmp1
    LEFT JOIN hive_sql_zg5.student_info stu ON tmp1.stu_id = stu.stu_id
;



-- 查找课程
SELECT
    course_id
FROM hive_sql_zg5.course_info
WHERE tea_id = (
        SELECT tea_id FROM hive_sql_zg5.teacher_info WHERE tea_name = '李体音'
    )
;


DESC FUNCTION array_contains;
/*
array_contains(array, value) - Returns TRUE if the array contains value.
*/

-- 2）、查询学过“李体音”老师所讲授的任意一门课程的学生的学号、姓名；
WITH
    tmp1 AS(
        -- c. 过滤授课学生ID
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        WHERE course_id IN (
            -- b. 老师授课课程ID
            SELECT
                course_id
            FROM hive_sql_zg5.course_info
            WHERE tea_id = (
                -- a. 老师ID
                SELECT tea_id FROM hive_sql_zg5.teacher_info WHERE tea_name = '李体音'
            )
        )
    )
-- d. 关联学生表，获取学生姓名
SELECT
    tmp1.stu_id, stu.stu_name
FROM tmp1
    LEFT JOIN hive_sql_zg5.student_info stu ON tmp1.stu_id = stu.stu_id
;



-- 3）、查询没学过"李体音"老师讲授的任一门课程的学生姓名；
WITH
    tmp1 AS(
        -- c. 过滤授课学生ID
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        WHERE course_id IN (
            -- b. 老师授课课程ID
            SELECT
                course_id
            FROM hive_sql_zg5.course_info
            WHERE tea_id = (
                -- a. 老师ID
                SELECT tea_id FROM hive_sql_zg5.teacher_info WHERE tea_name = '李体音'
            )
        )
    )
    , tmp2 AS (
        SELECT
            stu_id
        FROM hive_sql_zg5.score_info
        WHERE stu_id NOT IN (
            SELECT stu_id FROM tmp1
        )
    )
-- d. 关联学生表，获取学生姓名
SELECT
    tmp2.stu_id, stu.stu_name
FROM tmp2
         LEFT JOIN hive_sql_zg5.student_info stu ON tmp2.stu_id = stu.stu_id
;

-- 4）、查询至少有一门课与学号为“001”的学生所学课程相同的学生的学号和姓名；
WITH
    tmp1 AS (
        -- b. 过滤
        SELECT
            DISTINCT stu_id
        FROM hive_sql_zg5.score_info
        WHERE course_id IN (
            -- a. 001学生课程ID
            SELECT DISTINCT course_id
            FROM hive_sql_zg5.score_info
            WHERE stu_id = '001'
        )
    )
-- d. 关联学生表，获取学生姓名
SELECT
    tmp1.stu_id, stu.stu_name
FROM tmp1
         LEFT JOIN hive_sql_zg5.student_info stu ON tmp1.stu_id = stu.stu_id
;


-- 5）、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩；
/*
    学生、课程、成绩、平均成绩
    001  语文  80   85
    001  数学  90   85
    001  英语  85    85
    002  .............

    todo 聚合开窗函数
        avg(成绩) over (partition by 学生) AS avg_score
*/
SELECT
    stu_id
    , course_id
    , score
    , round(avg(score) OVER (PARTITION BY stu_id), 2)  AS avg_score
FROM hive_sql_zg5.score_info
ORDER BY avg_score DESC
;